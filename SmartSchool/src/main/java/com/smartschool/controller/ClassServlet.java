package com.smartschool.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.smartschool.dao.UserDAO;
import com.smartschool.util.OracleDBConnection;

@WebServlet("/ClassServlet")
public class ClassServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String teacherIdStr = request.getParameter("teacherId");
        UserDAO dao = new UserDAO();

        try (Connection conn = OracleDBConnection.getConnection()) {
            if (teacherIdStr != null && !teacherIdStr.isEmpty()) {
                int teacherId = Integer.parseInt(teacherIdStr);
                Integer currentClassId = null;
                
                if ("update".equals(action)) {
                    currentClassId = Integer.parseInt(request.getParameter("classId"));
                }

                if (dao.isTeacherAlreadyAssigned(teacherId, currentClassId)) {
                    response.sendRedirect("admin/class.jsp?status=teacherTaken");
                    return;
                }
            }

            if ("add".equals(action)) {
                String sql = "INSERT INTO CLASSROOM (CLASS_NAME, ACADEMIC_YEAR, TEACHER_ID) VALUES (?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, request.getParameter("className"));
                    ps.setInt(2, Integer.parseInt(request.getParameter("year")));
                    
                    if (teacherIdStr != null && !teacherIdStr.isEmpty()) {
                        ps.setInt(3, Integer.parseInt(teacherIdStr));
                    } else {
                        ps.setNull(3, java.sql.Types.INTEGER);
                    }
                    
                    ps.executeUpdate();
                    response.sendRedirect("admin/class.jsp?status=success");
                }

            } else if ("update".equals(action)) {
                String sql = "UPDATE CLASSROOM SET CLASS_NAME=?, ACADEMIC_YEAR=?, TEACHER_ID=? WHERE CLASS_ID=?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, request.getParameter("className"));
                    ps.setInt(2, Integer.parseInt(request.getParameter("year")));
                    
                    if (teacherIdStr != null && !teacherIdStr.isEmpty()) {
                        ps.setInt(3, Integer.parseInt(teacherIdStr));
                    } else {
                        ps.setNull(3, java.sql.Types.INTEGER);
                    }
                    
                    ps.setInt(4, Integer.parseInt(request.getParameter("classId")));
                    
                    ps.executeUpdate();
                    response.sendRedirect("admin/class.jsp?status=updated");
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/class.jsp?status=error");
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            String classId = request.getParameter("classId");
            
            try (Connection conn = OracleDBConnection.getConnection()) {
                String deleteAssignmentsSql = "DELETE FROM TEACHER_ASSIGNMENT WHERE CLASS_ID = ?";
                try (PreparedStatement ps1 = conn.prepareStatement(deleteAssignmentsSql)) {
                    ps1.setInt(1, Integer.parseInt(classId));
                    ps1.executeUpdate();
                }

                String deleteClassSql = "DELETE FROM CLASSROOM WHERE CLASS_ID = ?";
                try (PreparedStatement ps2 = conn.prepareStatement(deleteClassSql)) {
                    ps2.setInt(1, Integer.parseInt(classId));
                    ps2.executeUpdate();
                }
                
                response.sendRedirect("admin/class.jsp?status=deleted");
                
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin/class.jsp?status=error");
            }
        }
    }
}