<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartschool.dao.UserDAO"%>
<%@ page import="com.smartschool.model.Classroom"%>
<%@ page import="com.smartschool.model.Teacher"%>
<%@ page import="com.smartschool.model.User"%>
<%@ page import="com.smartschool.model.Student"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.net.URLEncoder"%>

<%
    User currentUser = (com.smartschool.model.User) session.getAttribute("currentUser");
    UserDAO dao = new UserDAO();
    
    int teacherId = (currentUser != null) ? currentUser.getUserId() : 0;
    
    Classroom myClass = dao.getTeacherClass(teacherId); 
    
    List<Student> students = new ArrayList<>();
    String selectedClassName = "No Class Assigned";

    if (myClass != null) {
        selectedClassName = myClass.getClassName();
        // Now fetch students using the ID from the classroom object
        students = dao.getStudentsByClass(myClass.getClassID());
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart School System - Examination</title>
	<link rel="icon" type="image/webp" href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/homepage.css">
    <style>

.success-msg {
	background: #d4edda;
	color: #155724;
	padding: 10px;
	border-radius: 8px;
	margin-bottom: 20px;
	border: 1px solid #c3e6cb;
}

.action-box {
	display: inline-block;
	padding: 6px 12px;
	border-radius: 8px;
	font-size: 0.85rem;
	font-weight: 600;
	text-decoration: none;
	transition: 0.3s;
	border: 1px solid #8c8279;
}

.btn-view-attendance {
	background-color: transparent;
	color: #8c8279;
}

.btn-view-attendance:hover {
	background-color: #8c8279;
	color: white;
}

.btn-view-exam {
	background-color: #8c8279;
	color: white;
}

.btn-view-exam:hover {
	background-color: transparent;
	color : #8c8279;
}

.action-container {
	display: flex;
	gap: 8px;
	justify-content: flex-end;
}
.data-table th:last-child {
    text-align: right;
    padding-right: 260px; 
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
.submit-container {
    display: flex;
    justify-content: flex-end; 
    margin-top: 20px;
}

</style>
</head>
<body>

    <header class="header">
        <div class="header-left">
            <i class="fas fa-bars menu-toggle-icon" id="menu-toggle"></i> 
            <span>Smart School System</span>
        </div>
        <div class="header-right">
            <div class="profile-area" id="profileBtn" style="cursor: pointer;">
                <span class="user-name"><%= currentUser.getName() %></span>
                <img src="../assets/image/adminICON.png" alt="Profile" class="profile-image">
            </div>
            <div class="profile-menu" id="profileMenu" style="display:none;">
                <p onclick="location.href='teacherProfile.jsp'"><i class="fas fa-user"></i> My Profile</p>
                <p id="logoutOption"><i class="fas fa-sign-out-alt"></i> Logout</p>
            </div>
        </div>
    </header>

    <div class="main-container">
        <aside class="sidebar" id="sidebar">
            <ul class="sidebar-menu">
                <li><a href="teacherHomepage.jsp" class="menu-item"><i class="fas fa-home icon"></i> <span class="link-text">Home</span></a></li>
                <li><a href="attendance.jsp" class="menu-item"><i class="fas fa-calendar-check icon"></i> <span class="link-text">Attendance</span></a></li>
                <li><a href="examSelection.jsp" class="menu-item"><i class="fas fa-file-invoice icon"></i> <span class="link-text">Examination</span></a></li>
                <li><a href="classTeacher.jsp" class="menu-item active"><i class="fas fa-school icon"></i> <span class="link-text">Class</span></a></li>            
            </ul>
        </aside>

		<main class="content"
			style="background: linear-gradient(rgba(255, 255, 255, 0.7), rgba(255, 255, 255, 0.7)), 
             url('<%=request.getContextPath()%>/assets/image/background1.png') no-repeat center center fixed; 
             background-size: cover; min-height: 100vh;">
			<div class="breadcrumb">
				Hi,
				<%=("teacher".equalsIgnoreCase(currentUser.getRole())) ? currentUser.getName() : "Teacher"%>
				<span class="breadcrumb-separator">&gt;</span> <span
					class="current-page">Class</span>
			</div>
			<div class="table-header">
				<h3>
					Student List -
					<%= selectedClassName %></h3>
			</div>
			<div class="table-box">
				<% if (myClass == null) { %>
				<div
					style="padding: 20px; background: #fff3cd; color: #856404; border-radius: 10px; border: 1px solid #ffeeba; margin: 20px;">
					<i class="fas fa-info-circle"></i> You are not currently assigned
					as a Form Teacher for any class.
				</div>
				<% } else { %>
				<table class="data-table">
					<thead>
						<tr>
							<th>No.</th>
							<th>Student Name</th>
							<th>Actions</th>
						</tr>
					</thead>
					<tbody>
						<% 
                        int count = 1;
                        for(Student s : students) { 
                    %>
						<tr>
							<td><%= count++ %></td>
							<td><%= s.getStudName() %></td>
							<td>
								<div class="action-container">
									<a href="viewAttendance.jsp?studIC=<%= s.getStudIC() %>"
										class="action-box btn-view-attendance"> <i
										class="fas fa-calendar-check"></i> View Attendance
									</a> <a href="viewExamination.jsp?studIC=<%= s.getStudIC() %>"
										class="action-box btn-view-exam"> <i
										class="fas fa-file-invoice"></i> View Examination
									</a>
								</div>
							</td>
						</tr>
						<% } %>
					</tbody>
				</table>
				<% } %>
			</div>
			<div class="submit-container">
				<button type="button" class="btn-second"
					onclick="location.href='teacherHomepage.jsp'">Back</button>
			</div>
		</main>
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

    <script>
        // Sidebar & Profile Logic
        const menuToggle = document.getElementById('menu-toggle');
        const sidebar = document.getElementById('sidebar');
        menuToggle.addEventListener('click', () => sidebar.classList.toggle('collapsed'));

        const profileBtn = document.getElementById('profileBtn');
        const profileMenu = document.getElementById('profileMenu');
        profileBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            profileMenu.style.display = profileMenu.style.display === 'block' ? 'none' : 'block';
        });
        document.addEventListener('click', () => profileMenu.style.display = 'none');

        // Logout Modal
        const logoutOption = document.getElementById('logoutOption');
        const logoutModal = document.getElementById('logoutModal');
        logoutOption.addEventListener('click', () => logoutModal.style.display = 'flex');
        document.getElementById('cancelLogout').addEventListener('click', () => logoutModal.style.display = 'none');
        document.getElementById('confirmLogout').addEventListener('click', () => window.location.href = '../choice.html');
    </script>
</body>
</html>