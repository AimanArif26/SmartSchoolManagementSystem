package com.smartschool.dao;

import java.sql.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.smartschool.model.Attendance;
import com.smartschool.model.Classroom;
import com.smartschool.model.Examination;
import com.smartschool.model.Guardian;
import com.smartschool.model.Student;
import com.smartschool.model.Subject;
import com.smartschool.model.Teacher;
import com.smartschool.model.TeacherAssign;
import com.smartschool.model.User;
import com.smartschool.util.OracleDBConnection;

public class UserDAO {
	public boolean updateUserPassword(int userId, String newPassword) {
		boolean isUpdated = false;
		String sql = "UPDATE USERS SET PASSWORD = ? WHERE USER_ID = ?";

		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, newPassword);
			ps.setInt(2, userId);

			int rowsAffected = ps.executeUpdate();
			isUpdated = (rowsAffected > 0);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return isUpdated;
	}

	public User loginCheck(String email, String password, String role) {
		User user = null;

		String sql = "SELECT u.*, t.STATUS as STATUS FROM USERS u " +
				"LEFT JOIN TEACHER t ON u.USER_ID = t.TEACHER_ID " +
				"WHERE u.EMAIL = ? AND u.PASSWORD = ? AND u.ROLE = ?";

		try (Connection con = OracleDBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, email);
			ps.setString(2, password);
			ps.setString(3, role);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				String status = rs.getString("STATUS");

				if ("teacher".equalsIgnoreCase(role)) {
					if ("approved".equalsIgnoreCase(status)) {
						user = new User();
						user.setUserId(rs.getInt("USER_ID"));
						user.setEmail(rs.getString("EMAIL"));
						user.setRole(role);

						fetchTeacherName(con, user); 
					} else {
						return null; 
					}
				} else {
					user = new User();
					user.setUserId(rs.getInt("USER_ID"));
					user.setEmail(rs.getString("EMAIL"));
					user.setRole(role);
					user.setName("System Admin");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return user;
	}

	public int getTotalCountTeacher() {
		int count = 0;
		String sql = "SELECT COUNT(*) FROM TEACHER WHERE STATUS ='approved'";
		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			if (rs.next()) {
				count = rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return count;
	}
	public int getTotalCountStudent() {
		int count = 0;
		String sql = "SELECT COUNT(*) FROM STUDENT WHERE STUD_STATUS ='ACTIVE'";
		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			if (rs.next()) {
				count = rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return count;
	}

	public int getPendingValidationCount() {
		int count = 0;

		String sql = "SELECT COUNT(*) FROM TEACHER WHERE STATUS = 'pending'";
		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			if (rs.next()) {
				count = rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return count;
	}

	public List<User> getUsersByStatus(String status) {
		List<User> list = new ArrayList<>();
		String sql = "SELECT * FROM TEACHER WHERE STATUS = ?";
		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, status);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				User u = new User();
				u.setUserId(rs.getInt("USER_ID"));
				u.setName(rs.getString("NAME"));
				u.setEmail(rs.getString("EMAIL"));
				u.setRole(rs.getString("ROLE"));
				list.add(u);
			}
		} catch (Exception e) { e.printStackTrace(); }
		return list;
	}

	private void fetchTeacherName(Connection con, User user) throws SQLException {
		String sql = "SELECT TEACHER_NAME FROM TEACHER WHERE TEACHER_ID = ?";
		try (PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, user.getUserId());
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				user.setName(rs.getString("TEACHER_NAME"));
			}
		}
	}

	public boolean registerTeacher(String email, String password, String role, String name, String CertNumber, String TeacherPhoneNum) {
		Connection conn = null;
		try {
			conn = OracleDBConnection.getConnection();
			conn.setAutoCommit(false);

			String sqlUser = "INSERT INTO USERS (EMAIL, PASSWORD, ROLE) VALUES (?, ?, ?)";	        
			String[] generatedColumns = {"USER_ID"}; 
			PreparedStatement psUser = conn.prepareStatement(sqlUser, generatedColumns);

			psUser.setString(1, email);
			psUser.setString(2, password);
			psUser.setString(3, role);

			int affectedRows = psUser.executeUpdate();

			if (affectedRows > 0) {
				ResultSet rs = psUser.getGeneratedKeys();
				if (rs.next()) {
					int newUserId = rs.getInt(1);

					String sqlTeacher = "INSERT INTO TEACHER (TEACHER_ID, TEACHER_NAME, CERT_NUMBER, PHONE_NUM, STATUS) VALUES (?, ?, ?, ?, 'pending')";
					PreparedStatement psTeacher = conn.prepareStatement(sqlTeacher);
					psTeacher.setInt(1, newUserId);
					psTeacher.setString(2, name);
					psTeacher.setString(3, CertNumber);
					psTeacher.setString(4, TeacherPhoneNum);

					psTeacher.executeUpdate();	
					conn.commit();
					return true;
				}
			}
		} catch (Exception e) {
			try { if (conn != null) conn.rollback(); } catch (SQLException se) { se.printStackTrace(); }
			e.printStackTrace();
		} finally {
			try { if (conn != null) conn.close(); } catch (SQLException se) { se.printStackTrace(); }
		}
		return false;
	}

	public List<Teacher> getPendingTeachers() {
		List<Teacher> list = new ArrayList<>();
		try {
			Connection conn = OracleDBConnection.getConnection();

			String sql = "SELECT * FROM TEACHER WHERE STATUS = 'pending'";
			PreparedStatement ps = conn.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();

			while(rs.next()) {
				Teacher t = new Teacher();
				t.setTeacherID(rs.getInt("TEACHER_ID"));
				t.setTeacherName(rs.getString("TEACHER_NAME"));
				t.setCertNumber(rs.getString("CERT_NUMBER"));
				t.setTeacherPhoneNum(rs.getString("PHONE_NUM"));
				list.add(t);
			}
		} catch(Exception e) { e.printStackTrace(); }
		return list;
	}
	public List<Teacher> getAvailableTeachers() {
	    List<Teacher> teachers = new ArrayList<>();
	    String sql = "SELECT * FROM TEACHER " +
	                 "WHERE TEACHER_ID NOT IN (SELECT TEACHER_ID FROM CLASSROOM WHERE TEACHER_ID IS NOT NULL) " +
	                 "AND STATUS = 'approved'"; 

	    try (Connection conn = OracleDBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {
	        while (rs.next()) {
	            Teacher t = new Teacher();
	            t.setTeacherID(rs.getInt("TEACHER_ID"));
	            t.setTeacherName(rs.getString("TEACHER_NAME"));
	            teachers.add(t);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return teachers;
	}
	public Classroom getTeacherClass(int TeacherID) {
		Classroom classroom = null;
		String sql = "SELECT * FROM CLASSROOM WHERE TEACHER_ID = ?";

		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, TeacherID);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				classroom = new Classroom();
				classroom.setClassID(rs.getInt("CLASS_ID"));
				classroom.setClassName(rs.getString("CLASS_NAME"));
			}
		} catch (Exception e) { e.printStackTrace(); }
		return classroom;
	}

	public List<Student> getStudentsByClass(int ClassID) {
		List<Student> students = new ArrayList<>();

		String sql = "SELECT STUD_IC, STUD_NAME FROM STUDENT WHERE CLASS_ID = ? AND STUD_STATUS = 'ACTIVE'";

		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, ClassID);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Student s = new Student();
				s.setStudIC(rs.getString("STUD_IC"));
				s.setStudName(rs.getString("STUD_NAME"));
				students.add(s);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return students;
	}

	public boolean insertAttendance(List<Attendance> attendanceList) {
		String sql = "INSERT INTO ATTENDANCE (ATTENDANCE_DATE, CLASS_ID, ACADEMICYEAR, STUD_IC, STATUS, NOTES, MC_IMAGE_PATH) " +
				"VALUES (TO_DATE(?, 'YYYY-MM-DD'), ?, ?, ?, ?, ?, ?)";
		return executeBatchAttendance(sql, attendanceList, false);
	}

	public boolean updateAttendance(List<Attendance> attendanceList) {
		String sql = "UPDATE ATTENDANCE SET STATUS = ?, NOTES = ?, MC_IMAGE_PATH = ? " +
				"WHERE ATTENDANCE_DATE = TO_DATE(?, 'YYYY-MM-DD') AND STUD_IC = ?";
		return executeBatchAttendance(sql, attendanceList, true);
	}

	private boolean executeBatchAttendance(String sql, List<Attendance> list, boolean isUpdate) {
		try (Connection conn = OracleDBConnection.getConnection()) {
			conn.setAutoCommit(false);
			try (PreparedStatement ps = conn.prepareStatement(sql)) {
				for (Attendance a : list) {
					if (isUpdate) {
						ps.setString(1, a.getStatus());
						ps.setString(2, a.getNotes());
						ps.setString(3, a.getMcImage());
						ps.setString(4, a.getDate());
						ps.setString(5, a.getStudIC());
					} else {
						ps.setString(1, a.getDate());
						ps.setInt(2, a.getClassID());
						ps.setString(3, a.getAcademicYear());
						ps.setString(4, a.getStudIC());
						ps.setString(5, a.getStatus());
						ps.setString(6, a.getNotes());
						ps.setString(7, a.getMcImage());
					}
					ps.addBatch();
				}
				ps.executeBatch();
				conn.commit();
				return true;
			} catch (Exception e) {
				conn.rollback();
				e.printStackTrace();
			}
		} catch (Exception e) { e.printStackTrace(); }
		return false;
	}

	public boolean checkAttendanceExists(int classId, String date) {
		String sql = "SELECT COUNT(*) FROM ATTENDANCE WHERE CLASS_ID = ? AND ATTENDANCE_DATE = TO_DATE(?, 'YYYY-MM-DD')";
		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, classId);
			ps.setString(2, date);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) return rs.getInt(1) > 0;
		} catch (Exception e) { e.printStackTrace(); }
		return false;
	}

	public List<TeacherAssign> getTeacherAssignments(int TeacherID) {
		List<TeacherAssign> assignments = new ArrayList<>();
		String sql = "SELECT ta.ASSIGN_ID, ta.CLASS_ID, ta.SUBJECT_ID, ta.ACADEMIC_YEAR, c.CLASS_NAME, s.SUBJECT_NAME " +
				"FROM TEACHER_ASSIGNMENT ta " +
				"JOIN CLASSROOM c ON ta.CLASS_ID = c.CLASS_ID " +
				"JOIN SUBJECT s ON ta.SUBJECT_ID = s.SUBJECT_ID " +
				"WHERE ta.TEACHER_ID = ?";

		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, TeacherID);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					TeacherAssign ta = new TeacherAssign();
					ta.setAssignId(rs.getInt("ASSIGN_ID"));
					ta.setClassId(rs.getInt("CLASS_ID"));
					ta.setSubjectId(rs.getInt("SUBJECT_ID"));
					ta.setClassName(rs.getString("CLASS_NAME"));
					ta.setSubjectName(rs.getString("SUBJECT_NAME"));
					ta.setAcademicYear(rs.getString("ACADEMIC_YEAR"));
					ta.setTeacherId(TeacherID);
					assignments.add(ta);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return assignments;
	}

	public boolean saveExaminationMarks(List<Examination> examList) {
		boolean success = false;

		String sql = "MERGE INTO EXAMINATION e " +
				"USING (SELECT ? AS SID, ? AS SUBID, ? AS ETYPE, ? AS AYEAR FROM dual) src " +
				"ON (e.STUD_IC = src.SID AND e.SUBJECT_ID = src.SUBID AND e.EXAM_TYPE = src.ETYPE AND e.ACADEMIC_YEAR = src.AYEAR) " +
				"WHEN MATCHED THEN " +
				"  UPDATE SET e.MARKS = ?, e.GRADE = ?, e.EXAM_DATE = TO_DATE(?, 'YYYY-MM-DD') " +
				"WHEN NOT MATCHED THEN " +
				"  INSERT (CLASS_ID, STUD_IC, SUBJECT_ID, EXAM_TYPE, MARKS, EXAM_DATE, ACADEMIC_YEAR, GRADE) " +
				"  VALUES (?, src.SID, src.SUBID, src.ETYPE, ?, TO_DATE(?, 'YYYY-MM-DD'), src.AYEAR, ?)";

		try (Connection conn = OracleDBConnection.getConnection()) {
			conn.setAutoCommit(false); 
			try (PreparedStatement ps = conn.prepareStatement(sql)) {
				for (Examination e : examList) {
					ps.setString(1, e.getStudIC());
					ps.setInt(2, e.getSubjectId());
					ps.setString(3, e.getExamType());
					ps.setString(4, e.getAcademicYear()); 

					ps.setDouble(5, e.getExamMark());
					ps.setString(6, e.getExamGrade());
					ps.setString(7, e.getExamDate()); 

					ps.setInt(8, e.getClassID());
					ps.setDouble(9, e.getExamMark());
					ps.setString(10, e.getExamDate()); 
					ps.setString(11, e.getExamGrade());

					ps.addBatch();
				}
				ps.executeBatch();
				conn.commit();
				success = true;
			} catch (SQLException ex) {
				conn.rollback();
				System.err.println("Database Error: " + ex.getMessage());
				ex.printStackTrace();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return success;
	}
	
	public Map<String, Double> getExistingMarks(int classId, int subjectId, String academicYear, String examType) {
	    Map<String, Double> marksMap = new HashMap<>();
	    String sql = "SELECT STUD_IC, MARKS FROM EXAMINATION " +
	                 "WHERE CLASS_ID = ? AND SUBJECT_ID = ? AND ACADEMIC_YEAR = ? AND EXAM_TYPE = ?";
	    
	    try (Connection conn = OracleDBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, classId);
	        ps.setInt(2, subjectId);
	        ps.setString(3, academicYear);
	        ps.setString(4, examType);
	        
	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                marksMap.put(rs.getString("STUD_IC"), rs.getDouble("MARKS"));
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return marksMap;
	}
	public Classroom getTeacherClassByID(int classId) {
		Classroom cr = null;
		String sql = "SELECT CLASS_ID, CLASS_NAME FROM CLASSROOM WHERE CLASS_ID = ?";
		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, classId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					cr = new Classroom();
					cr.setClassID(rs.getInt("CLASS_ID"));
					cr.setClassName(rs.getString("CLASS_NAME"));
				}
			}
		} catch (Exception e) { e.printStackTrace(); }
		return cr;
	}
	public boolean isTeacherAlreadyAssigned(int teacherId, Integer currentClassId) {
	    String sql = "SELECT COUNT(*) FROM CLASSROOM WHERE TEACHER_ID = ?";
	    
	    if (currentClassId != null) {
	        sql += " AND CLASS_ID <> " + currentClassId;
	    }

	    try (Connection conn = OracleDBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, teacherId);
	        try (ResultSet rs = ps.executeQuery()) {
	            if (rs.next()) {
	                return rs.getInt(1) > 0; 
	            }
	        }
	    } catch (Exception e) { e.printStackTrace(); }
	    return false;
	}
	
	public String getSubjectNameByID(int subjectId) {
		String name = "";
		String sql = "SELECT SUBJECT_NAME FROM SUBJECT WHERE SUBJECT_ID = ?";
		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, subjectId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					name = rs.getString("SUBJECT_NAME");
				}
			}
		} catch (Exception e) { e.printStackTrace(); }
		return name;
	}

	public Teacher getTeacherProfile(int teacherId) {
		Teacher teacher = null;
		String sql = "SELECT t.TEACHER_ID, t.TEACHER_NAME, t.CERT_NUMBER, t.PHONE_NUM, t.TEACHER_ROLE, u.EMAIL " +
				"FROM TEACHER t " +
				"JOIN USERS u ON t.TEACHER_ID = u.USER_ID " +
				"WHERE t.TEACHER_ID = ?";

		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, teacherId);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					teacher = new Teacher();
					teacher.setTeacherID(rs.getInt("TEACHER_ID"));
					teacher.setTeacherName(rs.getString("TEACHER_NAME"));
					teacher.setCertNumber(rs.getString("CERT_NUMBER"));
					teacher.setTeacherRole(rs.getString("TEACHER_ROLE"));
					teacher.setTeacherPhoneNum(rs.getString("PHONE_NUM"));
					teacher.setEmail(rs.getString("EMAIL")); 
					teacher.setAssignedSubjects(this.getAssignedSubjects(teacherId));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return teacher;
	}
	public List<String> getAssignedSubjects(int teacherId) {
		List<String> subjects = new ArrayList<>();
		String sql = "SELECT DISTINCT s.SUBJECT_NAME FROM TEACHER_ASSIGNMENT ta " +
				"JOIN SUBJECT s ON ta.SUBJECT_ID = s.SUBJECT_ID " +
				"WHERE ta.TEACHER_ID = ?";

		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, teacherId);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					subjects.add(rs.getString("SUBJECT_NAME"));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return subjects;
	}

	public boolean updateProfile(int userId, int teacherId, String phone, String password) {
	    boolean success = false;
	    Connection conn = null;
	    
	    try {
	        conn = OracleDBConnection.getConnection();
	        conn.setAutoCommit(false); 

	        if (password != null && !password.isEmpty()) {
	            String userSql = "UPDATE USERS SET PASSWORD = ? WHERE USER_ID = ?";
	            try (PreparedStatement psUser = conn.prepareStatement(userSql)) {
	                psUser.setString(1, password);
	                psUser.setInt(2, userId);
	                psUser.executeUpdate();
	            }
	        }
	        String teacherSql = "UPDATE TEACHER SET PHONE_NUM = ? WHERE TEACHER_ID = ?";
	        try (PreparedStatement psTeacher = conn.prepareStatement(teacherSql)) {
	            psTeacher.setString(1, phone);
	            psTeacher.setInt(2, teacherId);
	            psTeacher.executeUpdate();
	        }

	        conn.commit(); 
	        success = true;
	    } catch (Exception e) {
	        if (conn != null) {
	            try { conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
	        }
	        e.printStackTrace();
	    } finally {
	        if (conn != null) {
	            try { conn.close(); } catch (Exception ex) { ex.printStackTrace(); }
	        }
	    }
	    return success;
	}
	public List<Teacher> getAllApprovedTeachers() {
		List<Teacher> teachers = new ArrayList<>();
		String sql = "SELECT TEACHER_ID, TEACHER_NAME FROM TEACHER WHERE STATUS = 'approved' ORDER BY TEACHER_NAME ASC";

		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			while (rs.next()) {
				Teacher t = new Teacher();
				t.setTeacherID(rs.getInt("TEACHER_ID"));
				t.setTeacherName(rs.getString("TEACHER_NAME"));
				teachers.add(t);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return teachers;
	}
	public List<Classroom> getClassroomsByYear(int year) {
		List<Classroom> list = new ArrayList<>();
		String sql = "SELECT c.*, t.TEACHER_NAME " +
				"FROM CLASSROOM c " +
				"LEFT JOIN TEACHER t ON c.TEACHER_ID = t.TEACHER_ID " +
				"WHERE c.ACADEMIC_YEAR = ? " +
				"ORDER BY c.CLASS_NAME ASC";

		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, year);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Classroom c = new Classroom();
				c.setClassID(rs.getInt("CLASS_ID"));
				c.setClassName(rs.getString("CLASS_NAME"));
				c.setAcademicYear(rs.getInt("ACADEMIC_YEAR"));
				c.setTeacherName(rs.getString("TEACHER_NAME")); 
				list.add(c);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	public Classroom getClassroomById(int classId) {
		Classroom classroom = null;
		String sql = "SELECT c.*, t.TEACHER_NAME FROM CLASSROOM c " +
				"LEFT JOIN TEACHER t ON c.TEACHER_ID = t.TEACHER_ID " +
				"WHERE c.CLASS_ID = ?";

		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, classId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					classroom = new Classroom();
					classroom.setClassID(rs.getInt("CLASS_ID"));
					classroom.setClassName(rs.getString("CLASS_NAME"));
					classroom.setAcademicYear(rs.getInt("ACADEMIC_YEAR"));
					classroom.setTeacherName(rs.getString("TEACHER_NAME"));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return classroom;
	}
	public List<Teacher> getHeadTeachers() {
		List<Teacher> list = new ArrayList<>();
		String sql = "SELECT * FROM TEACHER WHERE HEAD_TEACHER_ID IS NULL";

		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			while(rs.next()) {
				Teacher t = new Teacher();
				t.setTeacherID(rs.getInt("TEACHER_ID"));
				t.setTeacherName(rs.getString("TEACHER_NAME"));
				list.add(t);
			}
		} catch (Exception e) { e.printStackTrace(); }
		return list;
	}
	public List<Teacher> getApprovedTeachers() {
		List<Teacher> list = new ArrayList<>();
		String sql = "SELECT * FROM TEACHER WHERE STATUS = 'approved' ORDER BY TEACHER_NAME ASC";
		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			while (rs.next()) {
				Teacher t = new Teacher();
				t.setTeacherID(rs.getInt("TEACHER_ID"));
				t.setTeacherName(rs.getString("TEACHER_NAME"));
				t.setTeacherRole(rs.getString("TEACHER_ROLE"));
				list.add(t);
			}
		} catch (Exception e) { e.printStackTrace(); }
		return list;
	}
	public List<Subject> getAllSubjects() {
		List<Subject> list = new ArrayList<>();
		String sql = "SELECT * FROM SUBJECT ORDER BY SUBJECT_CODE ASC";
		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			while (rs.next()) {
				Subject s = new Subject();
				s.setSubjectID(rs.getInt("SUBJECT_ID"));
				s.setSubjectName(rs.getString("SUBJECT_NAME"));
				s.setSubjectCode(rs.getString("SUBJECT_CODE"));
				list.add(s);
			}
		} catch (Exception e) { e.printStackTrace(); }
		return list;
	}
	public List<Classroom> getAllClasses() {
		List<Classroom> list = new ArrayList<>();
		String sql = "SELECT * FROM CLASSROOM ORDER BY CLASS_NAME ASC";
		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			while (rs.next()) {
				Classroom c = new Classroom();
				c.setClassID(rs.getInt("CLASS_ID"));
				c.setClassName(rs.getString("CLASS_NAME"));
				c.setClassYear(rs.getInt("CLASS_YEAR"));
				list.add(c);
			}
		} catch (Exception e) { e.printStackTrace(); }
		return list;
	}
	public List<Classroom> getAssignedClasses(int teacherId) {
		List<Classroom> list = new ArrayList<>();
		String sql = "SELECT DISTINCT c.CLASS_ID, c.CLASS_NAME " +
				"FROM TEACHER_ASSIGNMENT ta " +
				"JOIN CLASSROOM c ON ta.CLASS_ID = c.CLASS_ID " +
				"WHERE ta.TEACHER_ID = ?";
		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, teacherId);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Classroom c = new Classroom();
					c.setClassID(rs.getInt("CLASS_ID"));
					c.setClassName(rs.getString("CLASS_NAME"));
					list.add(c);
				}
			}
		} catch (Exception e) { e.printStackTrace(); }
		return list;
	}
	public Student getStudentByIC(String studIC) {
		Student s = null;
		String sql = "SELECT STUD_IC, STUD_NAME FROM STUDENT WHERE STUD_IC = ?";
		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, studIC);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				s = new Student();
				s.setStudIC(rs.getString("STUD_IC"));
				s.setStudName(rs.getString("STUD_NAME"));
			}
		} catch (Exception e) { e.printStackTrace(); }
		return s;
	}
	public List<Attendance> getStudentAttendanceByIC(String studIC, String month) {
		List<Attendance> list = new ArrayList<>();
		StringBuilder sql = new StringBuilder("SELECT ATTENDANCE_DATE, STATUS, NOTES FROM ATTENDANCE WHERE STUD_IC = ?");

		if (month != null && !month.equals("ALL")) {
			sql.append(" AND EXTRACT(MONTH FROM ATTENDANCE_DATE) = ?");
		}
		sql.append(" ORDER BY ATTENDANCE_DATE DESC");

		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql.toString())) {
			ps.setString(1, studIC);
			if (month != null && !month.equals("ALL")) {
				ps.setInt(2, Integer.parseInt(month));
			}

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				Attendance a = new Attendance();
				a.setDate(rs.getString("ATTENDANCE_DATE")); 
				a.setStatus(rs.getString("STATUS"));
				a.setNotes(rs.getString("NOTES"));
				list.add(a);
			}
		} catch (Exception e) { e.printStackTrace(); }
		return list;
	}
	public List<Examination> getStudentExamsByIC(String studIC, String examType, String academicYear) {
	    List<Examination> list = new ArrayList<>();
	    String sql = "SELECT * FROM EXAMINATION WHERE STUD_IC = ? AND EXAM_TYPE = ? AND ACADEMIC_YEAR = ?";
	    
	    try (Connection conn = OracleDBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setString(1, studIC);
	        ps.setString(2, examType);
	        ps.setString(3, academicYear);
	        
	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                Examination e = new Examination();
	                e.setSubjectId(rs.getInt("SUBJECT_ID"));
	                e.setExamMark(rs.getDouble("MARKS"));
	                e.setExamGrade(rs.getString("GRADE"));
	                e.setAcademicYear(rs.getString("ACADEMIC_YEAR"));
	                list.add(e);
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	public List<String> getAttendanceByMonth(int classId, String month, String year) {
		List<String> dateList = new ArrayList<>();
		String sql = "SELECT DISTINCT TO_CHAR(ATTENDANCE_DATE, 'YYYY-MM-DD') AS RECORDED_DATE " +
				"FROM ATTENDANCE " +
				"WHERE CLASS_ID = ? " +
				"AND TO_CHAR(ATTENDANCE_DATE, 'MM') = ? " +
				"AND TO_CHAR(ATTENDANCE_DATE, 'YYYY') = ? " +
				"ORDER BY RECORDED_DATE DESC";

		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, classId);
			ps.setString(2, month);
			ps.setString(3, year);

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				dateList.add(rs.getString("RECORDED_DATE"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dateList;
	}
	public String getActiveExamType() {
		String type = "Mid-Term"; 
		String sql = "SELECT ACTIVE_EXAM_TYPE FROM SYSTEM_SETTINGS WHERE SETTING_ID = 1";
		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			if (rs.next()) {
				type = rs.getString("ACTIVE_EXAM_TYPE");
			}
		} catch (Exception e) { e.printStackTrace(); }
		return type;
	}

	public boolean updateActiveExamType(String newType) {
		String sql = "UPDATE SYSTEM_SETTINGS SET ACTIVE_EXAM_TYPE = ? WHERE SETTING_ID = 1";
		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, newType);
			return ps.executeUpdate() > 0;
		} catch (Exception e) { e.printStackTrace(); return false; }
	}
	public List<Teacher> getTeachersByStatus(String uiStatus) {
		List<Teacher> list = new ArrayList<>();

		String dbStatus = "ACTIVE".equalsIgnoreCase(uiStatus) ? "APPROVED" : "INACTIVE";

		if (!"ACTIVE".equalsIgnoreCase(uiStatus) && !"INACTIVE".equalsIgnoreCase(uiStatus)) {
			dbStatus = uiStatus.toLowerCase();
		}

		String sql = "SELECT t.TEACHER_ID, t.TEACHER_NAME, t.CERT_NUMBER, " + 
				"t.PHONE_NUM, t.STATUS, u.EMAIL " + 
				"FROM TEACHER t " +
				"LEFT JOIN USERS u ON t.TEACHER_ID = u.USER_ID " + 
				"WHERE UPPER(t.STATUS) = UPPER(?) " + 
				"ORDER BY t.TEACHER_NAME ASC";

		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, dbStatus);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Teacher t = new Teacher();
				t.setTeacherID(rs.getInt("TEACHER_ID"));
				t.setTeacherName(rs.getString("TEACHER_NAME"));
				t.setCertNumber(rs.getString("CERT_NUMBER"));
				t.setTeacherPhoneNum(rs.getString("PHONE_NUM"));
				t.setTeacherEmail(rs.getString("EMAIL"));
				t.setStatus(rs.getString("STATUS")); 

				list.add(t);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return list; 
	}

	public boolean updateTeacherDetails(int teacherId, String phone, String newPassword) {
		boolean isSuccess = false;
		Connection conn = null;

		try {
			conn = OracleDBConnection.getConnection();
			conn.setAutoCommit(false); 

			String sqlTeacher = "UPDATE TEACHER SET PHONE_NUM = ? WHERE TEACHER_ID = ?";
			try (PreparedStatement psT = conn.prepareStatement(sqlTeacher)) {
				psT.setString(1, phone);
				psT.setInt(2, teacherId);
				psT.executeUpdate();
			}

			if (newPassword != null && !newPassword.trim().isEmpty()) {
				String sqlUser = "UPDATE USERS SET PASSWORD = ? WHERE USER_ID = ?";
				try (PreparedStatement psU = conn.prepareStatement(sqlUser)) {
					psU.setString(1, newPassword);
					psU.setInt(2, teacherId); 
					psU.executeUpdate();
				}
			}

			conn.commit(); 
			isSuccess = true;

		} catch (Exception e) {
			if (conn != null) try { conn.rollback(); } catch (Exception ex) {}
			e.printStackTrace();
		} finally {
			if (conn != null) try { conn.close(); } catch (Exception ex) {}
		}
		return isSuccess;
	}
	public boolean deleteTeacher(int teacherId) {
		boolean isSuccess = false;
		String sql = "UPDATE TEACHER SET STATUS = 'INACTIVE' WHERE TEACHER_ID = ?";

		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, teacherId);

			int rowCount = ps.executeUpdate();
			if (rowCount > 0) {
				isSuccess = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return isSuccess;
	}

	public List<Student> getAllStudents() {
		return getStudentList(null, "ACTIVE"); 
	}

	public List<Student> getStudentsByYear(int year) {
		List<Student> list = new ArrayList<>();
		String sql = "SELECT s.STUD_IC, s.STUD_NAME, s.STUD_YEAR, s.DATEOFBIRTH, s.ADDRESS, s.STUD_GENDER, s.CLASS_ID, c.CLASS_NAME,  g.GUARDIAN_IC " +
				"FROM STUDENT s " +
				"LEFT JOIN CLASSROOM c ON s.CLASS_ID = c.CLASS_ID " +       
				"LEFT JOIN GUARDIAN g ON s.GUARDIAN_ID = g.GUARDIAN_ID " + 
				"WHERE s.STUD_YEAR = ? " +
				"AND UPPER(s.STUD_STATUS) = 'ACTIVE' " +  
				"ORDER BY s.STUD_NAME ASC";

		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, year);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Student s = new Student();

				s.setStudIC(rs.getString("STUD_IC"));
				s.setStudName(rs.getString("STUD_NAME"));
				s.setStudYear(rs.getInt("STUD_YEAR")); 
				s.setDateOfBirth(rs.getDate("DATEOFBIRTH"));
				s.setAddress(rs.getString("ADDRESS"));
				s.setStudGender(rs.getString("STUD_GENDER"));
				s.setGuardianIC(rs.getString("GUARDIAN_IC"));
				s.setClassId(rs.getInt("CLASS_ID"));

				s.setClassName(rs.getString("CLASS_NAME")); 
				if (s.getClassName() == null) s.setClassName("No Class"); 
				list.add(s);
			}
		} catch (Exception e) { e.printStackTrace(); }
		return list; 
	}
	public List<Student> getStudentList(String keyword, String uiStatus) {
		List<Student> students = new ArrayList<>();

		String sql = "SELECT s.STUD_IC, s.STUD_NAME, s.STUD_YEAR, s.DATEOFBIRTH, s.ADDRESS, s.STUD_GENDER, s.CLASS_ID, c.CLASS_NAME,  g.GUARDIAN_IC " +
				"FROM STUDENT s " +
				"JOIN CLASSROOM c ON s.CLASS_ID = c.CLASS_ID " + 
				"JOIN GUARDIAN g ON s.GUARDIAN_ID = g.GUARDIAN_ID " +
				"WHERE s.STUD_STATUS = 'ACTIVE' " +
				"ORDER BY s.STUD_NAME ASC";

		if (keyword != null && !keyword.trim().isEmpty()) {
			sql = "SELECT s.STUD_IC, s.STUD_NAME, s.STUD_YEAR, s.DATEOFBIRTH, s.ADDRESS, s.STUD_GENDER, s.CLASS_ID, c.CLASS_NAME, g.GUARDIAN_IC " +
					"FROM STUDENT s " +
					"JOIN CLASSROOM c ON s.CLASS_ID = c.CLASS_ID " +
					"JOIN GUARDIAN g ON s.GUARDIAN_ID = g.GUARDIAN_ID " +
					"WHERE LOWER(s.STUD_NAME) LIKE ? OR s.STUD_IC LIKE ? " +
					"WHERE s.STUD_STATUS = 'ACTIVE' " +
					"ORDER BY s.STUD_NAME ASC";
		}

		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement preparedStatement = conn.prepareStatement(sql)) {
			if (keyword != null && !keyword.trim().isEmpty()) {
				String queryParam = "%" + keyword.toLowerCase() + "%";
				preparedStatement.setString(1, queryParam);
				preparedStatement.setString(2, queryParam);
			}

			ResultSet rs = preparedStatement.executeQuery();

			while (rs.next()) {
				Student s = new Student();

				s.setStudIC(rs.getString("STUD_IC"));
				s.setStudName(rs.getString("STUD_NAME"));
				s.setStudYear(rs.getInt("STUD_YEAR")); 
				s.setDateOfBirth(rs.getDate("DATEOFBIRTH"));
				s.setAddress(rs.getString("ADDRESS"));
				s.setStudGender(rs.getString("STUD_GENDER"));
				s.setGuardianIC(rs.getString("GUARDIAN_IC"));
				s.setClassId(rs.getInt("CLASS_ID"));
				s.setClassName(rs.getString("CLASS_NAME")); 

				students.add(s);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return students;
	}
	public boolean deleteStudent(String ic) {
	      boolean isSuccess = false;
	        
	        String sql = "UPDATE STUDENT SET STUD_STATUS = 'inactive' WHERE STUD_IC = ?";
	        
	        try (Connection conn = OracleDBConnection.getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql)) {
	            ps.setString(1, ic);
	  
	            int rowCount = ps.executeUpdate();
	            
	            if (rowCount > 0) {
	                isSuccess = true;
	            }
	  
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return isSuccess;
	    }
	public boolean deleteAllStudents() {
	      boolean isSuccess = false;
	      String sql = "UPDATE STUDENT SET STUD_STATUS = 'INACTIVE'"; 
	      
	      try (Connection conn = OracleDBConnection.getConnection();
	           PreparedStatement ps = conn.prepareStatement(sql)) {
	          int rows = ps.executeUpdate();
	          isSuccess = rows > 0;
	          
	      } catch (SQLException e) {
	          e.printStackTrace();
	      }
	      return isSuccess;
	  }
	public boolean deleteStudentsByYear(int year) {
		boolean isSuccess = false;
		
		String sql = "UPDATE STUDENT SET STUD_STATUS = 'inactive' WHERE STUD_YEAR = ?";

		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, year);
			int rowCount = ps.executeUpdate();

			if (rowCount > 0) isSuccess = true;

		} catch (Exception e) {
			e.printStackTrace();
		}
		return isSuccess;
	}
	public boolean addStudent(Student s) {
        boolean isSuccess = false;
        Connection conn = null;

        try {
            conn = OracleDBConnection.getConnection();
            conn.setAutoCommit(false); 

            int guardianId = getGuardianIdByIC(s.getGuardianIC());

            if (guardianId == 0) {
                guardianId = createIncompleteGuardian(conn, s.getGuardianIC());
            }

            if (guardianId == 0) {
                conn.rollback(); 
                return false;
            }

            boolean studentExists = false;
            String checkSql = "SELECT COUNT(*) FROM STUDENT WHERE STUD_IC = ?";
            try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                psCheck.setString(1, s.getStudIC());
                ResultSet rs = psCheck.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) studentExists = true;
            }

            String finalSql;
            if (studentExists) {
                finalSql = "UPDATE STUDENT SET STUD_NAME=?, STUD_YEAR=?, DATEOFBIRTH=?, " +
                           "ADDRESS=?, STUD_GENDER=?, CLASS_ID=?, GUARDIAN_ID=?, STUD_STATUS='ACTIVE' " +
                           "WHERE STUD_IC=?";
            } else {
                finalSql = "INSERT INTO STUDENT (STUD_NAME, STUD_YEAR, DATEOFBIRTH, " +
                           "ADDRESS, STUD_GENDER, CLASS_ID, GUARDIAN_ID, STUD_STATUS, STUD_IC) " +
                           "VALUES (?, ?, ?, ?, ?, ?, ?, 'ACTIVE', ?)";
            }

            try (PreparedStatement ps = conn.prepareStatement(finalSql)) {
                ps.setString(1, s.getStudName());
                ps.setInt(2, s.getStudYear());
                ps.setDate(3, s.getDateOfBirth());
                ps.setString(4, s.getAddress());
                ps.setString(5, s.getStudGender());
                ps.setInt(6, s.getClassId());
                ps.setInt(7, guardianId);
                ps.setString(8, s.getStudIC()); 

                ps.executeUpdate();
            }

            conn.commit(); 
            isSuccess = true;

        } catch (Exception e) {
            if (conn != null) {
                try { 
                    System.out.println("Rolling back transaction due to error...");
                    conn.rollback(); 
                } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception ex) {}
        }
        
        return isSuccess;
    }
	public boolean checkGuardian(String ic) {
		boolean exists = false;
		String sql = "SELECT 1 FROM GUARDIAN WHERE GUARDIAN_IC = ?";

		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, ic);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				exists = true; 
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return exists;
	}
	private int createIncompleteGuardian(Connection conn, String guardianIC) throws SQLException {
        int newId = 0;
        
        String seqSql = "SELECT USERS_SEQ.NEXTVAL FROM DUAL";
        try (PreparedStatement psSeq = conn.prepareStatement(seqSql);
             ResultSet rs = psSeq.executeQuery()) {
            if (rs.next()) {
                newId = rs.getInt(1);
            }
        }

        if (newId == 0) return 0;

        String sqlUser = "INSERT INTO USERS (USER_ID, EMAIL, PASSWORD, ROLE) VALUES (?, NULL, NULL, 'guardian')";
        try (PreparedStatement psUser = conn.prepareStatement(sqlUser)) {
            psUser.setInt(1, newId);
            psUser.executeUpdate();
        }

        String sqlGuardian = "INSERT INTO GUARDIAN (GUARDIAN_ID, GUARDIAN_IC) VALUES (?, ?)";
        try (PreparedStatement psGuardian = conn.prepareStatement(sqlGuardian)) {
            psGuardian.setInt(1, newId);
            psGuardian.setString(2, guardianIC);
            psGuardian.executeUpdate();
        }
        
        return newId;
    }
	public int getGuardianIdByIC(String ic) {
		int id = 0;
		String sql = "SELECT GUARDIAN_ID FROM GUARDIAN WHERE GUARDIAN_IC = ?";
		try (Connection conn = OracleDBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, ic);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				id = rs.getInt("GUARDIAN_ID");
			}
		} catch (Exception e) { e.printStackTrace(); }
		return id;
	}

	public String registerGuardian(String email, String password, String guardianIC) {
        Connection conn = null;
        String status = "FAIL"; 

        try {
            conn = OracleDBConnection.getConnection();
            conn.setAutoCommit(false);

            int userId = 0;
            String findGuardianSql = "SELECT GUARDIAN_ID FROM GUARDIAN WHERE GUARDIAN_IC = ?";
            
            try (PreparedStatement ps = conn.prepareStatement(findGuardianSql)) {
                ps.setString(1, guardianIC);
                ResultSet rs = ps.executeQuery();
                
                if (rs.next()) {
                    userId = rs.getInt("GUARDIAN_ID"); 
                } else {
                    return "IC_NOT_FOUND";
                }
            }

            String checkUserSql = "SELECT EMAIL FROM USERS WHERE USER_ID = ?";
            try (PreparedStatement ps = conn.prepareStatement(checkUserSql)) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    String existingEmail = rs.getString("EMAIL");
                    if (existingEmail != null && !existingEmail.trim().isEmpty()) {
                        return "ALREADY_REGISTERED";
                    }
                }
            }

            String checkEmailUnique = "SELECT USER_ID FROM USERS WHERE EMAIL = ?";
            try (PreparedStatement ps = conn.prepareStatement(checkEmailUnique)) {
                ps.setString(1, email);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    return "EMAIL_TAKEN";
                }
            }

            String updateSql = "UPDATE USERS SET EMAIL = ?, PASSWORD = ? WHERE USER_ID = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setString(1, email);
                ps.setString(2, password);
                ps.setInt(3, userId);
                
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    status = "SUCCESS";
                }
            }

            conn.commit();
            return status;

        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) {}
            e.printStackTrace();
            return "DB_ERROR";
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException ex) {}
        }
    }

	public Guardian loginGuardian(String email, String password) {
		Guardian guardian = null;

		String sql = "SELECT g.GUARDIAN_ID " + "FROM USERS u " + "JOIN GUARDIAN g ON u.USER_ID = g.GUARDIAN_ID "
				+ "WHERE u.EMAIL = ? " + "AND u.PASSWORD = ? " + "AND u.ROLE = 'guardian'";

		try (Connection conn = OracleDBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, email);
			ps.setString(2, password);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					guardian = new Guardian();
					guardian.setGuardianID(rs.getInt("GUARDIAN_ID"));
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return guardian;
	}

	public List<Student> getStudentsByGuardian(int guardianID) {
		List<Student> students = new ArrayList<>();

		String sql = "SELECT STUD_IC, STUD_NAME, STUD_YEAR " + "FROM STUDENT " + "WHERE GUARDIAN_ID = ?";

		try (Connection conn = OracleDBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, guardianID);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Student s = new Student();
					s.setStudIC(rs.getString("STUD_IC"));
					s.setStudName(rs.getString("STUD_NAME"));
					s.setStudYear(rs.getInt("STUD_YEAR"));
					students.add(s);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return students;
	}

	public Student getStudentDetailsByIC(String studIC) {
	    Student s = null;
	    String sql = "SELECT s.*, c.CLASS_NAME " +
	                 "FROM STUDENT s " +
	                 "JOIN CLASSROOM c ON s.CLASS_ID = c.CLASS_ID " +
	                 "WHERE s.STUD_IC = ?";

	    try (Connection conn = OracleDBConnection.getConnection(); 
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setString(1, studIC);
	        
	        try (ResultSet rs = ps.executeQuery()) {
	            if (rs.next()) {
	                s = new Student();
	                s.setStudIC(rs.getString("STUD_IC"));
	                s.setStudName(rs.getString("STUD_NAME"));
	                s.setStudYear(rs.getInt("STUD_YEAR"));	                
	                s.setDateOfBirth(rs.getDate("DATEOFBIRTH")); 	                
	                s.setAddress(rs.getString("ADDRESS"));
	                s.setStudGender(rs.getString("STUD_GENDER"));
	                s.setGuardianIC(rs.getString("GUARDIAN_ID")); 	                
	                s.setClassName(rs.getString("CLASS_NAME")); 
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return s;
	}

	public boolean updateStudentAddress(String studIC, String newAddress) {
	    String sql = "UPDATE STUDENT SET ADDRESS = ? WHERE STUD_IC = ?";
	    try (Connection conn = OracleDBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setString(1, newAddress);
	        ps.setString(2, studIC);
	        
	        int rowsAffected = ps.executeUpdate();
	        return rowsAffected > 0; 
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;
	    }
	}
	public List<Attendance> getStudentAttendanceByGuardian(String studIC, String month) {
		List<Attendance> list = new ArrayList<>();

		StringBuilder sql = new StringBuilder("SELECT * FROM ATTENDANCE WHERE STUD_IC = ? ");

		if (month != null && !month.equals("ALL")) {
			sql.append("AND TO_CHAR(ATTENDANCE_DATE, 'MM') = ? ");
		}
		sql.append("ORDER BY ATTENDANCE_DATE DESC");

		try (Connection con = OracleDBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(sql.toString())) {
			ps.setString(1, studIC);
			if (month != null && !month.equals("ALL")) {
				ps.setString(2, month);
			}

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Attendance a = new Attendance();
					a.setAttendanceID(rs.getInt("ATTENDANCE_ID"));

					java.sql.Date dbDate = rs.getDate("ATTENDANCE_DATE");
					a.setDate(dbDate != null ? dbDate.toString() : "");

					a.setStatus(rs.getString("STATUS"));
					a.setNotes(rs.getString("NOTES"));
					list.add(a);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public List<Examination> getAllStudentExamsByIC(String studIC) {
	    List<Examination> list = new ArrayList<>();
	    String sql = "SELECT e.*, s.SUBJECT_NAME " +
	                 "FROM EXAMINATION e " +
	                 "JOIN SUBJECT s ON e.SUBJECT_ID = s.SUBJECT_ID " +
	                 "WHERE TRIM(e.STUD_IC) = TRIM(?) " +
	                 "ORDER BY e.ACADEMIC_YEAR DESC";
	    
	    try (Connection conn = OracleDBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setString(1, studIC);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            Examination ex = new Examination();
	            ex.setSubjectId(rs.getInt("SUBJECT_ID"));
	            ex.setExamMark(rs.getDouble("MARKS"));
	            ex.setExamType(rs.getString("EXAM_TYPE"));
	            ex.setAcademicYear(rs.getString("ACADEMIC_YEAR"));
	            ex.setSubjectName(rs.getString("SUBJECT_NAME")); 
	            list.add(ex);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    System.out.println("Fetching all exams for IC: " + studIC + " | Found: " + list.size());
	    return list;
	}
	public List<String> getDistinctAcademicYearsByStudent(String studIC) {
	    List<String> years = new ArrayList<>();
	    String sql = "SELECT DISTINCT ACADEMIC_YEAR FROM EXAMINATION WHERE STUD_IC = ? ORDER BY ACADEMIC_YEAR DESC";
	    
	    try (Connection conn = OracleDBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setString(1, studIC);
	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                years.add(rs.getString("ACADEMIC_YEAR"));
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return years;
	}

}