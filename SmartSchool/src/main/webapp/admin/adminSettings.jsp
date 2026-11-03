<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartschool.dao.UserDAO, com.smartschool.model.User" %>
<%
    // Security check - ensure only Admin can access
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }

    UserDAO dao = new UserDAO();
    String currentExam = dao.getActiveExamType(); // Fetch the global setting
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart School System - System Settings</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/validate.css">
    <link rel="stylesheet" href="../assets/css/classList.css">
    <link rel="icon" type="image/webp" href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">
    <style>
        .settings-card {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            max-width: 800px;
            margin: 20px auto;
        }
        .status-box {
            background: #f8f5f2;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 30px;
            border: 1px solid #e0dcd9;
        }
        .active-label {
            font-size: 1.5rem;
            color: #8c8279; 
            font-weight: bold;
            display: block;
            margin-top: 10px;
        }
        .control-grid {
    	display: grid;
    	grid-template-columns: repeat(3, 1fr); 
    	gap: 20px;
    	margin-top: 30px;
    	align-items: stretch; 
		}

		.control-grid form {
  	  	 width: 100%;
   		 margin: 0;
		}
        .switch-btn {
            padding: 20px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-weight: bold;
            font-size: 1rem;
            transition: 0.3s;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
        }
        .btn-ujian { background: #4CAF50; color: white; }
        .btn-midterm { background: #4CAF50; color: white; }
        .btn-final { background: #4CAF50; color: white; }
        .switch-btn:hover { transform: translateY(-3px); box-shadow: 0 5px 15px rgba(0,0,0,0.2); }
        .switch-btn:disabled { background: #ccc; cursor: not-allowed; transform: none; }
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
                <li><a href="adminHomepage.jsp" class="menu-item"><i class="fas fa-home icon"></i> <span class="link-text">Home</span></a></li>
                <li><a href="class.jsp" class="menu-item"><i class="fas fa-chalkboard icon"></i> <span class="link-text">Class</span></a></li>
                <li><a href="student.jsp" class="menu-item"><i class="fas fa-user-graduate icon"></i> <span class="link-text">Student</span></a></li>
                <li><a href="validateTeacher.jsp" class="menu-item"><i class="fas fa-user-check icon"></i> <span class="link-text">Validate</span></a></li>
                <li><a href="teacherList.jsp" class="menu-item"><i class="fas fa-users-rectangle icon"></i> <span class="link-text">Teacher List</span></a></li>
                <li><a href="assignment.jsp" class="menu-item"><i class="fas fa-tasks icon"></i> <span class="link-text">Assignment</span></a></li>
                <li><a href="adminSettings.jsp" class="menu-item active"><i class="fas fa-cog icon"></i> <span class="link-text">Settings</span></a></li>
            </ul>
        </aside>

        <main class="content">
            <div class="breadcrumb">
                <a style="text-decoration:none; color:black;">Hi, Admin</a> 
                <span class="breadcrumb-separator">&gt;</span> 
                <span class="current-page">Settings</span>
            </div>

            <div class="settings-card">
                <div class="status-box">
                    <p style="margin:0; color:#666;">Current Active Examination Session</p>
                    <span class="active-label">
                        <i class="fas fa-bullhorn"></i> <%= currentExam %>
                    </span>
                </div>

                <h4 style="margin-bottom: 20px; color: #333;">Switch Examination Phase</h4>
				<div class="control-grid">
                    <form action="../SettingsServlet" method="POST">
                        <input type="hidden" name="newExamType" value="Ujian 1">
                        <button type="submit" class="switch-btn btn-ujian" <%= "Ujian 1".equals(currentExam) ? "disabled" : "" %>>
                            <i class="fas fa-pencil-alt fa-2x"></i>
                            Activate Ujian 1
                            <% if("Ujian 1".equals(currentExam)) { %><span class="current-indicator">Currently Active</span><% } %>
                        </button>
                    </form>

                    <form action="../SettingsServlet" method="POST">
                        <input type="hidden" name="newExamType" value="Mid-Term">
                        <button type="submit" class="switch-btn btn-midterm" <%= "Mid-Term".equals(currentExam) ? "disabled" : "" %>>
                            <i class="fas fa-file-contract fa-2x"></i>
                            Activate Mid-Term
                            <% if("Mid-Term".equals(currentExam)) { %><span class="current-indicator">Currently Active</span><% } %>
                        </button>
                    </form>

                    <form action="../SettingsServlet" method="POST">
                        <input type="hidden" name="newExamType" value="Final Exam">
                        <button type="submit" class="switch-btn btn-final" <%= "Final Exam".equals(currentExam) ? "disabled" : "" %>>
                            <i class="fas fa-graduation-cap fa-2x"></i>
                            Activate Final Exam
                            <% if("Final Exam".equals(currentExam)) { %><span class="current-indicator">Currently Active</span><% } %>
                        </button>
                    </form>

					<form action="../SettingsServlet" method="POST">
						<input type="hidden" name="newExamType" value="LOCKED">
						<button type="submit" class="switch-btn"
							style="background: #dc3545; color: white;"
							<%="LOCKED".equalsIgnoreCase(currentExam) ? "disabled" : ""%>>
							<i class="fas fa-lock fa-2x"></i> Lock All Marking
							<%
							if ("LOCKED".equalsIgnoreCase(currentExam)) {
							%><span
								class="current-indicator">SYSTEM LOCKED</span>
							<%
							}
							%>
						</button>
					</form>
				</div>

                <div style="margin-top: 30px; padding: 15px; background: #fff9c4; border-left: 5px solid #fbc02d; border-radius: 4px;">
                    <small><strong>Note:</strong> Switching the exam type will affect all teachers. They will only be able to enter marks for the selected session.</small>
                </div>
            </div>
            <div id="toastNotification" class="notification-toast"></div>
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
		
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            const status = urlParams.get('status');
            const toast = document.getElementById("toastNotification");

            if (status === 'success' || urlParams.has('success')) {
                let message = "✅ Exam Phase Switched Successfully!";
                
                toast.innerText = message;
                toast.className = "notification-toast success show"; 
                
                setTimeout(function(){ 
                    toast.classList.remove("show"); 
                    window.history.replaceState({}, document.title, window.location.pathname);
                }, 3000);
            }
        };
    </script>
</body>
</html>