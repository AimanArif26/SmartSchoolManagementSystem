<%@ page import="com.smartschool.model.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("../choice.html"); // Redirect if not logged in
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Smart School System - Teacher Home</title>
<link rel="icon" type="image/webp" href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="../assets/css/validate.css">    
<style>
        #preloader {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background-color: #fcfbf9; /* Soft Off-White to match page */
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
            border: 3px solid rgba(90, 74, 66, 0.15); /* Light Brown Transparent */
            border-top: 3px solid #5a4a42; /* Primary Brown */
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
					class="menu-item active"><i class="fas fa-home icon"></i> <span
						class="link-text">Home</span></a></li>
				<li><a href="attendance.jsp" class="menu-item"><i
						class="fas fa-calendar-check icon"></i> <span class="link-text">Attendance</span></a></li>
				<li><a href="examSelection.jsp" class="menu-item"><i
						class="fas fa-file-invoice icon"></i> <span class="link-text">Examination</span></a></li>
				<li><a href="classTeacher.jsp" class="menu-item"><i
						class="fas fa-school icon"></i> <span class="link-text">Class</span></a></li>
			</ul>
		</aside>

		<main class="content"
			style="background: linear-gradient(rgba(255, 255, 255, 0.7), rgba(255, 255, 255, 0.7)), 
             url('<%=request.getContextPath()%>/assets/image/background1.png') no-repeat center center fixed; 
             background-size: cover; min-height: 100vh;">
			<div class="breadcrumb">
				Hi,
				<%= ("teacher".equalsIgnoreCase(currentUser.getRole())) ? currentUser.getName() : "Teacher" %>
				<span class="breadcrumb-separator">&gt;</span> <span
					class="current-page">Dashboard</span>
			</div>

			<div class="card-grid">
				<div class="dashboard-card" onclick="location.href='attendance.jsp'">
					<div class="card-icon">
						<i class="fas fa-calendar-check"></i>
					</div>
					<p>Attendance</p>
				</div>

				<div class="dashboard-card"
					onclick="location.href='examSelection.jsp'">
					<div class="card-icon">
						<i class="fas fa-file-invoice"></i>
					</div>
					<p>Examination</p>
				</div>

				<div class="dashboard-card"
					onclick="location.href='classTeacher.jsp'">
					<div class="card-icon">
						<i class="fas fa-school"></i>
					</div>
					<p>Class</p>
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
        // Sidebar Toggle
        const menuToggle = document.getElementById('menu-toggle');
        const sidebar = document.getElementById('sidebar');
        menuToggle.addEventListener('click', () => {
            sidebar.classList.toggle('collapsed');
        });

        // Profile Menu Toggle
        const profileBtn = document.getElementById('profileBtn');
        const profileMenu = document.getElementById('profileMenu');
        profileBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            profileMenu.style.display = profileMenu.style.display === 'block' ? 'none' : 'block';
        });

        // Close dropdown on outside click
        window.addEventListener('click', () => {
            profileMenu.style.display = 'none';
        });

        // Logout 
        const logoutOption = document.getElementById('logoutOption');
        const logoutModal = document.getElementById('logoutModal');
        const cancelLogout = document.getElementById('cancelLogout');
        const confirmLogout = document.getElementById('confirmLogout');

        logoutOption.addEventListener('click', () => logoutModal.style.display = 'flex');
        cancelLogout.addEventListener('click', () => logoutModal.style.display = 'none');
        confirmLogout.addEventListener('click', () => window.location.href = '../choice.html');
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