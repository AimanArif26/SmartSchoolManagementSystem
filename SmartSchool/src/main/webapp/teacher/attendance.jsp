<%@ page import="com.smartschool.dao.UserDAO"%>
<%@ page import="com.smartschool.model.Classroom"%>
<%@ page import="com.smartschool.model.Student"%>
<%@ page import="com.smartschool.model.Attendance"%>
<%@ page import="com.smartschool.model.Teacher"%>
<%@ page import="com.smartschool.model.User"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
com.smartschool.model.User currentUser = (com.smartschool.model.User) session.getAttribute("currentUser");

if (currentUser == null) {
	response.sendRedirect("../choice.html");
	return;
}

int TeacherID = currentUser.getTeacherID();

UserDAO dao = new UserDAO();
Classroom teacherClass = dao.getTeacherClass(TeacherID);

if (teacherClass == null) {
    out.println("<script type='text/javascript'>");
    out.println("alert('No class assigned to you yet.');");
    out.println("window.location.href='teacherHomepage.jsp';"); 
    out.println("</script>");
    return;
}

String academicYear = "2025";
List<Student> studentList = dao.getStudentsByClass(teacherClass.getClassID());
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Smart School System - Attendance</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="../assets/css/homepage.css"><link rel="icon" type="image/webp" href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">
<style>
.attendance-filters {
	display: flex;            
    justify-content: space-between; 
    align-items: center;                      
    
    margin-bottom: 30px;
    background: #fdfaf8;
    padding: 10px 25px;
    border-radius: 12px;
    border: 1px solid #e6d7cb;
}

.filter-group {
    display: flex;
    flex-direction: row;      
    align-items: center;
    gap: 10px;
}

.filter-group label {
	font-size: 0.9rem;
	font-weight: 600;
	color: #555;
}

.filter-group select, .filter-group input {
	padding: 10px;
	border: 1px solid #d0d0d0;
	border-radius: 8px;
	font-size: 0.95rem;
}

.data-table th:nth-child(3), 
.data-table th:nth-child(4), 
.data-table th:nth-child(5)  {
    text-align: left;
    padding-left: 15px;
}

.status-options {
    display: flex;
    gap: 15px;
    justify-content: flex-start; 
    padding-left: 5px;
}

.radio-label, .status-options label {
    display: flex;
    align-items: center;
    gap: 8px;
    white-space: nowrap;
}

.note-input {
    width: 95%;
    padding: 8px 12px;
    border: 1px solid #e0dcd9;
    border-radius: 8px;
    background-color: #fcfbf9;
    color: #5a4a42;
    font-size: 0.9rem;
    transition: all 0.3s ease;
    outline: none;
}

.note-input:hover {
    border-color: #8c8279;
    background-color: #fff;
}

.note-input:focus {
    border-color: #8c8279;
    background-color: #fff;
    box-shadow: 0 0 0 3px rgba(140, 130, 121, 0.1);
    width: 100%;
}

.note-input::placeholder {
    color: #bbb;
    font-style: italic;
    font-size: 0.85rem;
}

.submit-container {
	margin-top: 30px;
	display: flex;
	justify-content: flex-end;
	gap: 10px;
}

.btn-primary {
	background-color: #8c8279;
	color: white;
	padding: 12px 30px;
	border: none;
	border-radius: 25px;
	font-weight: bold;
	cursor: pointer;
	transition: 0.3s;
}

.btn-primary:hover {
	background-color: #746260;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

.btn-second {
	background-color: black;
	color: white;
	padding: 12px 35px;
	border: none;
	border-radius: 25px;
	font-weight: bold;
	cursor: pointer;
}

.info-bar {
	background: #fdfaf8;
	padding: 15px 25px;
	border-radius: 12px;
	border: 1px solid #e6d7cb;
	margin-bottom: 20px;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.info-item {
	font-weight: bold;
	color: #8c8279;
}
.file-input {
    font-size: 12px;
    color: #8c8279;
    max-width: 150px;
}
.floating-note {
        position: fixed;
        bottom: 20px;
        left: 50%;
        transform: translateX(-50%);
        width: 90%;
        max-width: 800px;
        background: #fdfaf8;
        padding: 15px 25px;
        border-radius: 12px;
        border: 1px solid #e6d7cb;
        color: #746260;
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 15px;
        box-shadow: 0 -4px 15px rgba(0, 0, 0, 0.1);
        z-index: 1000;
        transition: transform 0.5s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.4s ease;
    }

    .note-content {
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .close-note-btn {
        background: transparent;
        border: none;
        color: #8c8279;
        font-size: 1.2rem;
        cursor: pointer;
        transition: 0.3s;
        padding: 5px;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .close-note-btn:hover {
        color: #ef4444;
        transform: scale(1.1);
    }

    .note-slide-down {
        transform: translate(-50%, 150%) !important;
        opacity: 0;
    }
</style>
</head>
<body>

	<header class="header">
		<div class="header-left">
			<i class="fas fa-bars menu-toggle-icon" id="menu-toggle"></i> <span>Smart
				School System</span>
		</div>
		<div class="header-right">
			<div class="profile-area" id="profileBtn">
				<span class="user-name"> <% 
            if ("teacher".equalsIgnoreCase(currentUser.getRole())) { 
        %> <%= currentUser.getName() %> <% 
            } else { 
        %> <%= currentUser.getEmail() %> <% 
            } 
        %>
				</span> <img
					src="../assets/image/<%= "teacher".equals(currentUser.getRole()) ? "adminICON.png" : "adminICON.png" %>"
					alt="Profile Icon" class="profile-image">
			</div>
			<div class="profile-menu" id="profileMenu">
				<p onclick="location.href='teacherProfile.jsp'">
					<i class="fas fa-user"></i> My Profile
				</p>
				<p id="logoutOption">
					<i class="fas fa-sign-out-alt"></i> Logout
				</p>
			</div>
		</div>
	</header>

	<div class="main-container">
		<aside class="sidebar" id="sidebar">
			<ul class="sidebar-menu">
				<li><a href="/SmartSchool/teacher/teacherHomepage.jsp"
					class="menu-item"><i class="fas fa-home icon"></i> <span
						class="link-text">Home</span></a></li>
				<li><a href="attendance.jsp" class="menu-item active"><i
						class="fas fa-calendar-check icon"></i> <span class="link-text">Attendance</span></a></li>
				<li><a href="examSelection.jsp" class="menu-item"><i
						class="fas fa-file-invoice icon"></i> <span class="link-text">Examination</span></a></li>
				<li><a href="classTeacher.jsp" class="menu-item"><i
						class="fas fa-school icon"></i> <span class="link-text">Class</span></a></li>
			</ul>
		</aside>

		<main class="content" style="background: linear-gradient(rgba(255, 255, 255, 0.7), rgba(255, 255, 255, 0.7)), 
             url('<%=request.getContextPath()%>/assets/image/background1.png') no-repeat center center fixed; 
             background-size: cover; min-height: 100vh; overflow-y: auto;">
			<div class="breadcrumb">
				Hi,
				<%=("teacher".equalsIgnoreCase(currentUser.getRole())) ? currentUser.getName() : "Teacher"%>
				<span class="breadcrumb-separator">&gt;</span> <span
					class="current-page">Attendance</span>
			</div>

			<div class="attendance-filters">
				<div>
					Class: <span class="info-item"><%=teacherClass.getClassName()%></span>
				</div>

				<div class="filter-group">
					<label>Date: </label> <input type="date" id="datePicker"
						class="filter-group" required
						value="<%=new java.sql.Date(System.currentTimeMillis())%>"
						max="<%=new java.sql.Date(System.currentTimeMillis())%>">
				</div>
			</div>

			<form id="attendanceForm" action="../AttendanceServlet" method="POST"
				enctype="multipart/form-data">
				<input type="hidden" name="ClassID"
					value="<%=teacherClass.getClassID()%>"> <input
					type="hidden" name="academicYear" value="<%=academicYear%>">
				<input type="hidden" id="hiddenDate" name="attendanceDate" value="">

				<div class="table-box">
					<table class="data-table">
						<thead>
							<tr>
								<th>No.</th>
								<th>Student Name</th>
								<th>Status</th>
								<th>Notes</th>
								<th>Attachment (Optional)</th>
							</tr>
						</thead>
						<tbody>
							<%
							for (int i = 0; i < studentList.size(); i++) {
								Student s = studentList.get(i);
							%>
							<tr>
								<td><%=i + 1%></td>
								<td><%=s.getStudName()%></td>
								<td><input type="hidden" name="StudIC"
									value="<%=s.getStudIC()%>">
									<div class="status-options">
										<label> <input type="radio"
											name="Status_<%=s.getStudIC()%>" value="Present" checked>
											Present
										</label> <label> <input type="radio"
											name="Status_<%=s.getStudIC()%>" value="Absent">
											Absent
										</label>
									</div></td>
								<td><input type="text" name="Notes_<%=s.getStudIC()%>"
									class="note-input" placeholder="Enter here"></td>
								<td><input type="file" name="MC_Image_<%=s.getStudIC()%>"
									accept="image/*" class="file-input"></td>
							</tr>
							<%
							}
							%>
						</tbody>
					</table>
				</div>

				<div class="submit-container">
					<button type="button" class="btn-second"
						onclick="location.href='teacherHomepage.jsp'">Back</button>
					<button type="button" class="btn-primary"
						onclick="showSubmitModal()">Submit</button>
				</div>
			</form>
		</main>
	</div>
	
	<div id="confirmSubmitModal" class="modal-overlay">
		<div class="modal-box">
			<h3 style="margin-bottom: 15px;">Confirm Submission</h3>
			<p id="modalMessage">Are you sure you want to save the attendance for today?</p>
			<div class="modal-buttons">
				<button type="button" onclick="hideModal()"
					class="modal-btn btn-cancel">CANCEL</button>
				<button type="button" onclick="processSubmit()"
					class="modal-btn btn-reject" style="background-color: #8c8279;">CONFIRM</button>
			</div>
		</div>
	</div>

	<div id="successSubmitModal" class="modal-overlay">
		<div class="modal-box">
			<div style="font-size: 3rem; color: #28a745; margin-bottom: 10px;">✓</div>
			<h3 id="successMessage">Attendance Saved Successfully!</h3>
		</div>
	</div>

	<div id="logoutModal" class="modal-overlay">
		<div class="modal-box">
			<h3>Confirm Logout</h3>
			<p>Do you want to logout from this account?</p>
			<div class="modal-buttons">
				<button class="modal-btn btn-cancel" id="cancelLogout">Cancel</button>
				<button class="modal-btn btn-reject" id="confirmLogout">Logout</button>
			</div>
		</div>
	</div>
	<div id="floatingNote" class="info-note floating-note">
		<div class="note-content">
			<i class="fas fa-info-circle"></i> <span><strong>Note:</strong>
				If you have already submitted records for this class, simply fill in
				the details and submit again to <strong>update</strong> the existing
				records.</span>
		</div>
		<button type="button" class="close-note-btn" onclick="closeNote()">
			<i class="fas fa-times"></i>
		</button>
	</div>

	<script>
    const menuToggle = document.getElementById('menu-toggle');
    const sidebar = document.getElementById('sidebar');
    if(menuToggle) {
        menuToggle.addEventListener('click', () => sidebar.classList.toggle('collapsed'));
    }

    const profileBtn = document.getElementById('profileBtn');
    const profileMenu = document.getElementById('profileMenu');
    if(profileBtn) {
        profileBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            profileMenu.style.display = (profileMenu.style.display === 'block') ? 'none' : 'block';
        });
    }
    document.addEventListener('click', () => { if(profileMenu) profileMenu.style.display = 'none'; });

    const logoutOption = document.getElementById('logoutOption');
    const logoutModal = document.getElementById('logoutModal');
    if(logoutOption) {
        logoutOption.addEventListener('click', () => logoutModal.style.display = 'flex');
    }
    document.getElementById('cancelLogout').addEventListener('click', () => logoutModal.style.display = 'none');
    document.getElementById('confirmLogout').addEventListener('click', () => {
        window.location.href = '../choice.html';
    });

    const confirmModal = document.getElementById('confirmSubmitModal');

    function showSubmitModal() {
        confirmModal.style.display = 'flex';
    }

    function hideModal() {
        confirmModal.style.display = 'none';
    }

    function processSubmit() {
        const datePicker = document.getElementById('datePicker');
        const selectedDateStr = datePicker.value;
        
        if (!selectedDateStr) {
            alert("Please select a date first.");
            return;
        }

        const selectedDate = new Date(selectedDateStr);
        const today = new Date();
        
        today.setHours(0, 0, 0, 0);
        selectedDate.setHours(0, 0, 0, 0);

        if (selectedDate > today) {
            alert("Selection Error: You cannot record attendance for a future date.");
            return;
        }

        const dayOfWeek = selectedDate.getDay();
        if (dayOfWeek === 0 || dayOfWeek === 6) {
            const confirmWeekend = confirm("Notice: The selected date falls on a weekend. Do you still want to proceed?");
            if (!confirmWeekend) return;
        }

        document.getElementById('hiddenDate').value = selectedDateStr;
        
        document.getElementById('confirmSubmitModal').style.display = 'none';
        document.getElementById('attendanceForm').submit();
    }

    window.onload = function() {
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('success') === '1') {
            const successModal = document.getElementById('successSubmitModal');
            if(successModal) {
                successModal.style.display = 'flex';
                setTimeout(() => {
                    successModal.style.display = 'none';
                    window.history.replaceState({}, document.title, window.location.pathname);
                }, 2500);
            }
        }
    }
	function closeNote() {
	    const note = document.getElementById('floatingNote');
	    note.classList.add('note-slide-down');
	    
	    setTimeout(() => {
	        note.style.display = 'none';
	    }, 500);
	}
</script>
</body>
</html>