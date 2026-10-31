<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.smartschool.model.User"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>

<%
User currentUser = (User) session.getAttribute("currentUser");
if (currentUser == null) {
	response.sendRedirect("../choice.html");
	return;
}
String displayName = currentUser.getName();
String displayEmail = currentUser.getEmail();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Smart School System - Admin Profile</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
<link rel="stylesheet" href="../assets/css/homepage.css" />
<link rel="icon" type="image/webp" href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">
<style>
/* PROFILE SPECIFIC STYLES */
.profile-grid {
	display: grid;
	grid-template-columns: 320px 1fr;
	gap: 30px;
	max-width: 1100px;
	margin: 0 auto;
}

/* Left Side Card */
.profile-card-left {
	background: white;
	padding: 40px 20px;
	border-radius: 20px;
	text-align: center;
	border: 1px solid #e6d7cb;
	height: fit-content;
}

.profile-img-container {
	position: relative;
	width: 160px;
	height: 160px;
	margin: 0 auto 20px;
}

.profile-img-large {
	width: 100%;
	height: 100%;
	border-radius: 50%;
	object-fit: cover;
	border: 4px solid #8c8279;
}

.profile-card-left h2 {
	font-size: 1.4rem;
	color: #333;
	margin-bottom: 5px;
}

.profile-card-left p {
	color: #888;
	font-size: 0.9rem;
	margin-bottom: 20px;
}

/* Right Side Details */
.profile-details-right {
	background: white;
	padding: 40px;
	border-radius: 20px;
	border: 1px solid #e6d7cb;
}

.info-row {
	display: grid;
	grid-template-columns: 200px 1fr;
	padding: 15px 0;
	border-bottom: 1px solid #f0f0f0;
	align-items: center;
}

.info-row:last-child {
	border-bottom: none;
}

.label {
	font-weight: 600;
	color: #8c8279;
	text-transform: uppercase;
	font-size: 0.8rem;
	letter-spacing: 0.5px;
}

.value {
	color: #333;
	font-size: 1rem;
}

.password-display {
	font-family: monospace;
	background: #f9f9f9;
	padding: 4px 8px;
	border-radius: 4px;
}

/* Action Buttons */
.profile-actions {
	margin-top: 30px;
	display: flex;
	gap: 15px;
	justify-content: flex-end;
}

.btn-edit {
	background-color: #8c8279;
	color: white;
	padding: 12px 25px;
	border: none;
	border-radius: 25px;
	font-weight: bold;
	cursor: pointer;
	transition: 0.3s;
	display: flex;
	align-items: center;
	gap: 10px;
}

.btn-edit:hover {
	background-color: #746260;
	transform: translateY(-2px);
}

/* Responsive */
@media ( max-width : 850px) {
	.profile-grid {
		grid-template-columns: 1fr;
	}
}

.notification-toast {
	visibility: hidden;
	min-width: 280px;
	background-color: #333;
	color: #fff;
	text-align: center;
	border-radius: 50px;
	padding: 16px 25px;
	position: fixed;
	z-index: 1001;
	left: 50%;
	top: 30px;
	transform: translateX(-50%);
	font-weight: 600;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
}

.notification-toast.show {
	visibility: visible;
	animation: fadein 0.5s, fadeout 0.5s 2.5s;
}

.notification-toast.success {
	background-color: #28a745;
}

.notification-toast.error {
	background-color: #dc3545;
}

@
keyframes fadein {from { top:0;
	opacity: 0;
}

to {
	top: 30px;
	opacity: 1;
}

}
@
keyframes fadeout {from { top:30px;
	opacity: 1;
}

to {
	top: 0;
	opacity: 0;
}
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
				<li><a href="adminHomepage.jsp" class="menu-item"><i
						class="fas fa-home icon"></i> <span class="link-text">Home</span></a></li>
				<li><a href="class.jsp" class="menu-item"><i
						class="fas fa-chalkboard icon"></i> <span class="link-text">Class</span></a></li>
				<li><a href="student.jsp" class="menu-item"><i
						class="fas fa-user-graduate icon"></i> <span class="link-text">Student</span></a></li>
				<li><a href="validateTeacher.jsp" class="menu-item"><i
						class="fas fa-user-check icon"></i> <span class="link-text">Validate</span></a></li>
				<li><a href="teacherList.jsp" class="menu-item"><i
						class="fas fa-users-rectangle icon"></i> <span class="link-text">Teacher
							List</span></a></li>
				<li><a href="assignment.jsp" class="menu-item"><i
						class="fas fa-tasks icon"></i> <span class="link-text">Assignment</span></a></li>
				<li><a href="adminSettings.jsp" class="menu-item"><i
						class="fas fa-cog icon"></i> <span class="link-text">Settings</span></a></li>
			</ul>
		</aside>

		<main class="content">
			<div class="breadcrumb">
				Hi, Admin <span class="breadcrumb-separator">&gt;</span> <span
					class="current-page">Profile</span>
			</div>

			<div class="profile-grid">
				<div class="profile-card-left">
					<div class="profile-img-container">
						<img src="../assets/image/adminICON.png" alt="Admin Avatar"
							class="profile-img-large" />
					</div>
					<h2><%=displayName%></h2>
					<hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0" />
					<p
						style="text-transform: capitalize; font-weight: bold; color: <%=(currentUser.getUserId() == 1) ? "#5a4a42" : "#555"%>;">
						<%=(currentUser.getUserId() == 1) ? "Superadmin" : "Administrator"%>
					</p>

					<%
					if (currentUser.getUserId() == 1) {
					%>
					<%
					}
					%>
				</div>

				<div class="profile-details-right">
					<div class="info-row">
						<div class="label">Name</div>
						<div class="value"><%=displayName%></div>
					</div>
					<div class="info-row">
						<div class="label">Email Address</div>
						<div class="value"><%=displayEmail%></div>
					</div>
					<div class="info-row">
						<div class="label">Password</div>
						<div class="value">
							<span class="password-display">************</span>
						</div>
					</div>

					<div class="profile-actions">
						<%
						if (currentUser.getUserId() == 1) {
						%>
						<button class="btn-edit" onclick="openAddAdminModal()"
							style="background-color: #5a4a42;">
							<i class="fas fa-user-plus"></i> Add New Admin
						</button>
						<%
						}
						%>
						<button class="btn-edit" onclick="openEditModal()">
							<i class="fas fa-key"></i> Change Password
						</button>
					</div>
				</div>
			</div>
			<div id="toastNotification" class="notification-toast"></div>
		</main>
	</div>
	<div id="addAdminModal" class="modal-overlay">
		<div class="modal-box"
			style="width: 450px; text-align: left; background: #e6d7cb;">
			<span class="close-icon" onclick="closeAddAdminModal()"
				style="float: right; cursor: pointer;">&times;</span>
			<h3 style="margin-bottom: 20px; text-align: center; color: #5a4a42;">Register
				New Administrator</h3>
			<div
				style="background-color: rgba(90, 74, 66, 0.1); border-left: 4px solid #5a4a42; padding: 12px; margin-bottom: 20px; border-radius: 4px;">
				<p
					style="margin: 0; font-size: 0.85rem; color: #5a4a42; line-height: 1.4;">
					<i style="margin-right: 8px;"></i> <strong>Note:</strong>
					This action is restricted. Only the <strong>Superadmin</strong> is authorized to create new administrator accounts.
				</p>
			</div>
			<form action="../RegisterAdminServlet" method="POST">
				<div class="form-group" style="margin-bottom: 15px;">
					<label
						style="font-weight: 600; color: #5a4a42; display: block; margin-bottom: 5px;">Email
						Address</label> <input type="email" name="adminEmail"
						placeholder="Enter email" required
						style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid #ddd;" />
				</div>

				<div class="form-group" style="margin-bottom: 20px;">
					<label
						style="font-weight: 600; color: #5a4a42; display: block; margin-bottom: 5px;">Password</label>
					<input type="password" name="adminPassword"
						placeholder="Create password" required
						style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid #ddd;" />
				</div>

				<div class="modal-buttons"
					style="justify-content: flex-end; gap: 10px; display: flex;">
					<button type="button" class="modal-btn btn-cancel"
						onclick="closeAddAdminModal()">Cancel</button>
					<button type="submit" class="modal-btn btn-approve"
						style="background-color: #5a4a42; color: white; padding: 10px 20px; border: none; border-radius: 50px; cursor: pointer;">
						Create</button>
				</div>
			</form>
		</div>
	</div>
	<div id="editProfileModal" class="modal-overlay">
		<div class="modal-box" style="width: 450px; text-align: left">
			<form action="../UpdateProfileAdminServlet" method="POST">
				<h3 style="margin-bottom: 20px; text-align: center">Update
					Password</h3>

				<div class="filter-group" style="margin-bottom: 20px">
					<label>New Password</label> <input type="password" name="password"
						placeholder="Enter new password" required
						style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid #ddd;" />
				</div>

				<div class="modal-buttons"
					style="justify-content: flex-end; gap: 10px">
					<button type="button" class="modal-btn btn-cancel"
						onclick="closeEditModal()">Cancel</button>
					<button type="submit" class="modal-btn btn-approve"
						style="background-color: #5a4a42; color:white;">Update Password</button>
				</div>
			</form>
		</div>
	</div>

	<div id="logoutModal" class="modal-overlay">
		<div class="modal-box">
			<h3>Confirm Logout</h3>
			<p>Do you want to logout from this account?</p>
			<div class="modal-buttons">
				<button class="modal-btn btn-cancel" id="cancelLogout">Cancel</button>
				<button class="modal-btn btn-reject" id="confirmLogout">
					Logout</button>
			</div>
		</div>
	</div>

	<script>
      const menuToggle = document.getElementById("menu-toggle");
      const sidebar = document.getElementById("sidebar");
      menuToggle.addEventListener("click", () =>
        sidebar.classList.toggle("collapsed")
      );

      const profileBtn = document.getElementById("profileBtn");
      const profileMenu = document.getElementById("profileMenu");
      profileBtn.addEventListener("click", (e) => {
        e.stopPropagation();
        profileMenu.style.display =
          profileMenu.style.display === "block" ? "none" : "block";
      });

      document.addEventListener(
        "click",
        () => (profileMenu.style.display = "none")
      );

      const logoutOption = document.getElementById("logoutOption");
      const logoutModal = document.getElementById("logoutModal");
      logoutOption.addEventListener(
        "click",
        () => (logoutModal.style.display = "flex")
      );
      document
        .getElementById("cancelLogout")
        .addEventListener("click", () => (logoutModal.style.display = "none"));
      document
        .getElementById("confirmLogout")
        .addEventListener(
          "click",
          () => (window.location.href = "../choice.html")
        );

      const editModal = document.getElementById("editProfileModal");

      // Open the Modal
      function openEditModal() {
        editModal.style.display = "flex";
      }

      // Close the Modal
      function closeEditModal() {
        editModal.style.display = "none";
      }
      const addAdminModal = document.getElementById("addAdminModal");

      function openAddAdminModal() {
          addAdminModal.style.display = "flex";
      }

      function closeAddAdminModal() {
          addAdminModal.style.display = "none";
      }

      // Close modals if clicking outside the box
      window.addEventListener("click", (event) => {
          if (event.target == addAdminModal) closeAddAdminModal();
          if (event.target == editModal) closeEditModal();
      });
      
      window.onload = function() {
    	    const urlParams = new URLSearchParams(window.location.search);
    	    const status = urlParams.get('status');
    	    const toast = document.getElementById("toastNotification");

    	    if (status) {
    	        let message = "";
    	        let colorType = "";

    	        // Logic for different statuses
    	        if (status === 'adminAdded') { 
    	            message = "✅ New Admin Account Created!"; 
    	            colorType = "success"; 
    	        } else if (status === 'success1') { 
    	            message = "✅ Password Updated!"; 
    	            colorType = "success"; 
    	        } else if (status === 'error') { 
    	            message = "❌ Failed to create account."; 
    	            colorType = "error"; 
    	        } else if (status === 'unauthorized') { 
    	            message = "🚫 Access Denied: Only the Superadmin can create accounts."; 
    	            colorType = "error"; 
    	        }

    	        if (message) {
    	            toast.innerText = message;
    	            toast.className = "notification-toast " + colorType + " show"; 
    	            
    	            setTimeout(function(){ 
    	                toast.classList.remove("show"); 
    	                window.history.replaceState({}, document.title, window.location.pathname);
    	            }, 3000);
    	        }
    	    }
    	};
    </script>
</body>
</html>