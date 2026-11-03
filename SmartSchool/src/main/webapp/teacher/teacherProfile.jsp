<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.smartschool.model.User"%>
<%@ page import="com.smartschool.model.Teacher"%>
<%@ page import="com.smartschool.dao.UserDAO"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>

<%
    // 1. Session Check
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("../choice.html");
        return;
    }

    // 2. Fetch Detailed Teacher Info from Database
    UserDAO dao = new UserDAO();
    Teacher profile = dao.getTeacherProfile(currentUser.getTeacherID());

    List<String> mySubjects = (profile != null) ? profile.getAssignedSubjects() : new ArrayList<>();
    String displayName = (profile != null) ? profile.getTeacherName() : currentUser.getName();
    String displayCert = (profile != null) ? profile.getCertNumber() : "Not Set";
    String displayPhone = (profile != null) ? profile.getTeacherPhoneNum() : "Not Set";
    String displayRole = "Standard Teacher"; // Default
    if (profile != null && profile.getTeacherRole() != null && !profile.getTeacherRole().isEmpty()) {
        displayRole = profile.getTeacherRole();
    }%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Smart School System - My Profile</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
<link rel="stylesheet" href="../assets/css/homepage.css" />
<link rel="icon" type="image/webp" href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">
<style>
.profile-grid {
	display: grid;
	grid-template-columns: 320px 1fr;
	gap: 30px;
	max-width: 1100px;
	margin: 0 auto;
}

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

@media ( max-width : 850px) {
	.profile-grid {
		grid-template-columns: 1fr;
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
					<li><a href="teacherHomepage.jsp" class="menu-item"> <i
							class="fas fa-home icon"></i> <span class="link-text">Home</span>
					</a></li>
					<li><a href="attendance.jsp" class="menu-item"> <i
							class="fas fa-calendar-check icon"></i> <span class="link-text">Attendance</span>
					</a></li>
					<li><a href="examSelection.jsp" class="menu-item"> <i
							class="fas fa-file-invoice icon"></i> <span class="link-text">Examination</span>
					</a></li>
				<li><a href="classTeacher.jsp" class="menu-item"><i
						class="fas fa-school icon"></i> <span class="link-text">Class</span></a></li>
				</ul>
			</aside>

		<main class="content"
			style="background: linear-gradient(rgba(255, 255, 255, 0.7), rgba(255, 255, 255, 0.7)), 
             url('<%=request.getContextPath()%>/assets/image/background1.png') no-repeat center center fixed; 
             background-size: cover; min-height: 100vh;">
			<div class="breadcrumb">
				My Profile <span class="breadcrumb-separator">&gt;</span> <span
					class="current-page">Information Details</span>
			</div>

			<div class="profile-grid">
				<div class="profile-card-left">
					<div class="profile-img-container">
						<img src="../assets/image/adminICON.png" alt="Teacher Avatar"
							class="profile-img-large" />
					</div>
					<h2><%= displayName %></h2>
					<hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0" />
					<p style="color: #555; text-transform: capitalize;"><%= currentUser.getRole() %></p>
				</div>

				<div class="profile-details-right">
					<div class="info-row">
						<div class="label">Full Name</div>
						<div class="value"><%= displayName %></div>
					</div>
					<div class="info-row">
						<div class="label">Certificate No.</div>
						<div class="value"><%= displayCert %></div>
					</div>
					<div class="info-row">
						<div class="label">Teacher Role</div>
						<div class="value"><%=displayRole%></div>
					</div>
					<div class="info-row">
						<div class="label">Subjects</div>
						<div class="value">
							<%
							if (mySubjects != null && !mySubjects.isEmpty()) {
							%>
							<%=String.join(", ", mySubjects)%>
							<%
							} else { %>None assigned for current year<% }
							%>
						</div>
					</div>
					<div class="info-row">
						<div class="label">Phone Number</div>
						<div class="value"><%= displayPhone %></div>
					</div>
					<div class="info-row">
						<div class="label">Email Address</div>
						<div class="value"><%= (profile != null) ? profile.getEmail() : currentUser.getEmail() %></div>
					</div>
					<div class="info-row">
						<div class="label">Password</div>
						<div class="value">
							<span class="password-display">************</span>
						</div>
					</div>

					<div class="profile-actions">
						<button class="btn-edit" onclick="openEditModal()">
							<i class="fas fa-user-edit"></i> Update Profile
						</button>
					</div>
				</div>
			</div>
		</main>
	</div>

	<div id="editProfileModal" class="modal-overlay">
		<div class="modal-box" style="width: 450px; text-align: left">
			<form action="../UpdateProfileServlet" method="POST">
				<h3 style="margin-bottom: 20px; text-align: center">Update
					Profile</h3>

				<div class="filter-group" style="margin-bottom: 15px">
					<label>New Phone Number</label> <input type="text" name="phone"
						value="<%=displayPhone%>" required
						style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid #ddd;" />
				</div>

				<div class="filter-group" style="margin-bottom: 20px">
					<label>New Password (Optional)</label> <input type="password"
						name="password" placeholder="Leave blank to stay the same"
						style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid #ddd;" />
				</div>

				<div class="modal-buttons"
					style="justify-content: flex-end; gap: 10px">
					<button type="button" class="modal-btn btn-cancel"
						onclick="closeEditModal()">Cancel</button>
					<button type="submit" class="modal-btn btn-approve"
						style="background-color: #8c8279">Save Changes</button>
				</div>
			</form>
		</div>
	</div>

	<div id="successSubmitModal" class="modal-overlay">
		<div class="modal-box">
			<div style="font-size: 3rem; color: #28a745; margin-bottom: 10px;">✓</div>
			<h3 id="successMessage">Profile Updated Successfully!</h3>
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

      function openEditModal() {
        editModal.style.display = "flex";
      }

      function closeEditModal() {
        editModal.style.display = "none";
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

    </script>
</body>
</html>
