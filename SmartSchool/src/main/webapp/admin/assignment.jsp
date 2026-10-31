<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartschool.dao.UserDAO"%>
<%@ page import="com.smartschool.model.User"%>
<%@ page import="com.smartschool.model.Teacher"%>
<%@ page import="com.smartschool.model.Classroom"%>
<%@ page import="com.smartschool.model.Subject"%>
<%@ page import="java.util.List"%>

<%
    // 1. Session Security Check
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect("../choice.html");
        return;
    }

    UserDAO dao = new UserDAO();
    
    // 2. Fetch data for the dropdowns
    List<Teacher> approvedTeachers = dao.getApprovedTeachers(); 
    List<Classroom> allClasses = dao.getAllClasses();
    List<Subject> allSubjects = dao.getAllSubjects();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart School - Teacher Assignment</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/homepage.css">
    <link rel="icon" type="image/webp" href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">
    <style>
		.assignment-card {
            background: white;
            padding: 30px;
            border-radius: 20px;
            border: 1px solid #e6d7cb;
            max-width: 700px;
            margin: 20px auto;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #8c8279;
            font-size: 0.9rem;
        }
        .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 10px;
            font-size: 1rem;
            outline: none;
            transition: 0.3s;
        }
        .form-control:focus {
            border-color: #8c8279;
        }
        .button-row {
            display: flex;
            justify-content: flex-end;
            margin-top: 25px;
        }
        .btn-assign {
            background-color: #8c8279;
            color: white;
            padding: 15px; 
            border: none;
            border-radius: 30px;
            font-weight: bold;
            cursor: pointer;
            width: 35%; 
            font-size: 1rem;
            transition: 0.3s;
        }
        .btn-assign:hover {
            background-color: #746260;
            transform: translateY(-2px);
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
                <li><a href="adminHomepage.jsp" class="menu-item"><i class="fas fa-home icon"></i> <span class="link-text">Home</span></a></li>
                <li><a href="class.jsp" class="menu-item"><i class="fas fa-chalkboard icon"></i> <span class="link-text">Class</span></a></li>
                <li><a href="student.jsp" class="menu-item"><i class="fas fa-user-graduate icon"></i> <span class="link-text">Student</span></a></li>
                <li><a href="validateTeacher.jsp" class="menu-item"><i class="fas fa-user-check icon"></i> <span class="link-text">Validate</span></a></li>
                <li><a href="teacherList.jsp" class="menu-item"><i class="fas fa-users-rectangle icon"></i> <span class="link-text">Teacher List</span></a></li>
                <li><a href="assignment.jsp" class="menu-item active"><i class="fas fa-tasks icon"></i> <span class="link-text">Assignment</span></a></li>
                <li><a href="adminSettings.jsp" class="menu-item"><i class="fas fa-cog icon"></i> <span class="link-text">Settings</span></a></li> 
            </ul>
        </aside>

        <main class="content">
			<div class="breadcrumb">
				Hi, Admin
				<span class="breadcrumb-separator">&gt;</span> <span
					class="current-page">Assignment</span>
			</div>

            <div class="assignment-card">
                <h2 style="margin-bottom: 25px; text-align: center; color: #333;">Assign Teacher Workload</h2>
                <form action="../AssignServlet" method="POST">
                    
                    <div class="form-group">
                        <label><i class="fas fa-user-tie"></i> Select Teacher</label>
                        <select name="teacherId" class="form-control" required>
                            <option value="">-- Select Teacher --</option>
                            <% for (Teacher t : approvedTeachers) { %>
                                <option value="<%= t.getTeacherID() %>">
                                    <%= t.getTeacherName() %>
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label><i class="fas fa-book"></i> Select Subject</label>
                        <select name="subjectId" class="form-control" required>
                            <option value="">-- Select Subject --</option>
                            <% for (Subject s : allSubjects) { %>
                                <option value="<%= s.getSubjectID() %>">
                                    <%= s.getSubjectCode() %> - <%= s.getSubjectName() %>
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label><i class="fas fa-school"></i> Select Class</label>
                        <select name="classId" class="form-control" required>
                            <option value="">-- Select Class --</option>
                            <% for (Classroom c : allClasses) { %>
                                <option value="<%= c.getClassID() %>">
                                    <%= c.getClassName() %>
                                </option>
                            <% } %>
                        </select>
                    </div>
					<div class="form-group">
						<label><i class="fas fa-calendar-alt"></i> Academic Year</label> <select
							name="academicYear" class="form-control" required>
							<option value="2025">2025</option>
							<option value="2026" selected>2026</option>
							<option value="2027">2027</option>
						</select>
					</div>

					<div class="button-row">
						<button type="submit" class="btn-assign">
							<i></i> Confirm
						</button>
					</div>
				</form>
            </div>
			<div id="toastNotification" class="notification-toast"></div>
		</main>
    </div>
	<div id="assignConfirmModal" class="modal-overlay">
		<div class="modal-box">
			<h3>Confirm Assignment</h3>
			<p>Are you sure you want to assign this workload to the selected
				teacher?</p>
			<div class="modal-buttons">
				<button class="modal-btn btn-cancel" id="cancelAssign">Cancel</button>
				<button class="modal-btn btn-confirm" id="executeAssign"
					style="background-color: #8c8279; color: white;">Confirm</button>
			</div>
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

    // Logout Modal Logic
    const logoutOption = document.getElementById('logoutOption');
    const logoutModal = document.getElementById('logoutModal');
    const cancelLogout = document.getElementById('cancelLogout');
    const confirmLogout = document.getElementById('confirmLogout');

    logoutOption.addEventListener('click', () => logoutModal.style.display = 'flex');
    cancelLogout.addEventListener('click', () => logoutModal.style.display = 'none');
    confirmLogout.addEventListener('click', () => window.location.href = '../LogoutServlet');

    window.onload = function() {
        const urlParams = new URLSearchParams(window.location.search);
        const success = urlParams.get('success');
        const status = urlParams.get('status');
        const toast = document.getElementById("toastNotification");

        let message = "";
        let colorType = "";

        if (status === '1') { 
            message = "✅ Workload Assigned Successfully!"; 
            colorType = "success"; 
        } else if (status === 'failed') {
            message = "⚠️ This assignment already exists!";
            colorType = "error";
        } else if (status === 'duplicate') {
            message = "❌ Failed to create assignment.";
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
    };
 	// Assignment Confirmation Logic
    const assignmentForm = document.querySelector('form[action="../AssignServlet"]');
    const assignModal = document.getElementById('assignConfirmModal');
    const cancelAssign = document.getElementById('cancelAssign');
    const executeAssign = document.getElementById('executeAssign');

    // intercept the form submit
    assignmentForm.addEventListener('submit', function(e) {
        // Prevent actual submission first
        e.preventDefault();
        
        // Show the confirmation modal
        assignModal.style.display = 'flex';
    });

    // If user cancels
    cancelAssign.addEventListener('click', () => {
        assignModal.style.display = 'none';
    });

    // If user confirms
    executeAssign.addEventListener('click', () => {
        assignModal.style.display = 'none';
        assignmentForm.submit(); // Now actually send the data to the servlet
    });
    </script>
</body>
</html>