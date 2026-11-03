<%@ page import="com.smartschool.dao.UserDAO"%>
<%@ page import="com.smartschool.model.User"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
// 1. Session & Admin Role Check
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect("../choice.html");
        return;
    }

    UserDAO dao = new UserDAO();
    
   	// 2. Fetch Dynamic Stats
	int totalStudents = dao.getTotalCountStudent();
	int totalTeachers = dao.getTotalCountTeacher();

	// 3. Fetch Pending Users for the table
	int pendingCount = dao.getPendingValidationCount();
%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Smart School System - Admin Home</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="../assets/css/validate.css">
<link rel="icon" type="image/webp" href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">
<style>
        #preloader {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background-color: #fcfbf9;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            transition: opacity 0.5s ease-out, visibility 0.5s;
        }

        .loader-logo {
            width: 100px;
            margin-bottom: 25px;
            animation: breathe 2s infinite ease-in-out;
            filter: drop-shadow(0 5px 15px rgba(90, 74, 66, 0.2));
        }

        .loader-ring {
            width: 45px; height: 45px;
            border: 3px solid rgba(90, 74, 66, 0.15);
            border-top: 3px solid #5a4a42;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin { 100% { transform: rotate(360deg); } }
        @keyframes breathe { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.05); } }
    
    </style>
</head>

<body>
	<div id="preloader">
		<img src="../assets/image/sksmLOGO.webp" alt="Loading..."
			class="loader-logo">
		<div class="loader-ring"></div>
	</div>
	<header class="header">
		<div class="header-left">
			<i class="fas fa-bars menu-toggle-icon" id="menu-toggle"></i> <span>Smart
				School System</span>
		</div>
		<div class="header-right">
			<div class="profile-area" id="profileBtn">
				<span class="user-name">Admin</span> <img
					src="../assets/image/adminICON.png" alt="Admin Profile"
					class="profile-image">
			</div>
			<div class="profile-menu" id="profileMenu">
				<p onclick="location.href='adminProfile.jsp'">
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
				<li><a href="adminHomepage.jsp" class="menu-item active"><i
						class="fas fa-home icon"></i> <span class="link-text">Home</span></a></li>
				<li><a href="class.jsp" class="menu-item"><i
						class="fas fa-chalkboard icon"></i> <span class="link-text">Class</span></a></li>
				<li><a href="student.jsp" class="menu-item"><i
						class="fas fa-user-graduate icon"></i> <span class="link-text">Student</span></a></li>
				<li><a href="validateTeacher.jsp" class="menu-item"><i
						class="fas fa-user-check icon"></i> <span class="link-text">Validate</span></a></li>
				<li><a href="teacherList.jsp" class="menu-item"><i
						class="fas fa-users-rectangle icon"></i> <span class="link-text">Teacher List</span></a></li>
				<li><a href="assignment.jsp" class="menu-item"><i
                class="fas fa-tasks icon"></i> <span class="link-text">Assignment</span></a></li>
                <li><a href="adminSettings.jsp" class="menu-item"><i class="fas fa-cog icon"></i> <span class="link-text">Settings</span></a></li>
			</ul>
		</aside>

		<main class="content">
			<div class="breadcrumb">
				Hi, Admin
				<span class="breadcrumb-separator">&gt;</span> <span
					class="current-page">Dashboard</span>
			</div>

			<div class="stats-container">
				<div class="stat-item" onclick="location.href='student.jsp'">
					<span class="stat-value"><%=totalStudents%></span> <span
						class="stat-label">Total Students</span>
				</div>
				<div class="stat-item" onclick="location.href='teacherList.jsp'">
					<span class="stat-value"><%=totalTeachers%></span> <span
						class="stat-label">Total Teachers</span>
				</div>
				<div class="stat-item" onclick="location.href='validateTeacher.jsp'">
					<span class="stat-value" style="color: #ef4444;"><%=pendingCount%></span>
					<span class="stat-label">Pending Validation</span>
				</div>
			</div>

			<div class="card-grid">
				<div class="dashboard-card" onclick="location.href='class.jsp'">
					<div class="card-icon">
						<i class="fas fa-chalkboard icon"></i>
					</div>
					<p>Class</p>
				</div>

				<div class="dashboard-card" onclick="location.href='student.jsp'">
					<div class="card-icon">
						<i class="fas fa-user-graduate"></i>
					</div>
					<p>Student</p>
				</div>

				<div class="dashboard-card"
					onclick="location.href='validateTeacher.jsp'">
					<div class="card-icon">
						<i class="fas fa-user-check"></i>
					</div>
					<p>Validate Accounts</p>
				</div>

				<div class="dashboard-card"
					onclick="location.href='teacherList.jsp'">
					<div class="card-icon">
						<i class="fas fa-users-rectangle"></i>
					</div>
					<p>Teacher List</p>
				</div>

				<div class="dashboard-card"
					onclick="location.href='assignment.jsp'">
					<div class="card-icon">
						<i class="fas fa-tasks"></i>
					</div>
					<p>Assignment</p>
				</div>

				<div class="dashboard-card" onclick="location.href='adminSettings.jsp'">
					<div class="card-icon">
						<i class="fas fa-cog icon"></i>
					</div>
					<p>Settings</p>
				</div>
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
        const menuToggle = document.getElementById('menu-toggle');
        const sidebar = document.getElementById('sidebar');
        menuToggle.addEventListener('click', () => {
            sidebar.classList.toggle('collapsed');
        });

        const profileBtn = document.getElementById('profileBtn');
        const profileMenu = document.getElementById('profileMenu');
        profileBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            profileMenu.style.display = profileMenu.style.display === 'block' ? 'none' : 'block';
        });

        window.addEventListener('click', () => {
            profileMenu.style.display = 'none';
        });

        const logoutOption = document.getElementById('logoutOption');
        const logoutModal = document.getElementById('logoutModal');
        const cancelLogout = document.getElementById('cancelLogout');
        const confirmLogout = document.getElementById('confirmLogout');

        logoutOption.addEventListener('click', () => logoutModal.style.display = 'flex');
        cancelLogout.addEventListener('click', () => logoutModal.style.display = 'none');
        confirmLogout.addEventListener('click', () => window.location.href = '../LogoutServlet');
        window.addEventListener('load', () => {
            const loader = document.getElementById('preloader');
            setTimeout(() => {
                loader.style.opacity = '0'; 
                setTimeout(() => {
                    loader.style.visibility = 'hidden'; 
                }, 800); 
            }, 1500); 
        });
    </script>
</body>

</html>