<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.smartschool.dao.UserDAO, com.smartschool.model.*"%>
<%@ page import="java.util.*, java.text.*"%>

<%
    String classIdStr = request.getParameter("classId");
    if (classIdStr == null) { response.sendRedirect("class.jsp"); return; }
    
    int classId = Integer.parseInt(classIdStr);
    UserDAO dao = new UserDAO();
    Classroom currentClass = dao.getClassroomById(classId);
    
    String currentYear = new SimpleDateFormat("yyyy").format(new Date());
    String selectedMonth = request.getParameter("month") != null ? request.getParameter("month") : new SimpleDateFormat("MM").format(new Date());
    String selectedYear = request.getParameter("year") != null ? request.getParameter("year") : currentYear;

    List<String> attendanceDates = dao.getAttendanceByMonth(classId, selectedMonth, selectedYear);
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Smart School System - Manage Attendance</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="../assets/css/validate.css">
<link rel="stylesheet" href="../assets/css/classList.css">
<link rel="icon" type="image/webp" href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">
<style>
.filter-section {
	background: #f9f9f9;
	padding: 20px;
	border-radius: 8px;
	margin-bottom: 20px;
	border: 1px solid #eee;
}

.btn-delete-bulk {
	padding: 10px 20px;
	border-radius: 5px;
	border: none;
	cursor: pointer;
	color: white;
	font-weight: bold;
}

.btn-month {
	background-color: #ff9800;
}

.btn-year {
	background-color: #f44336;
}

.date-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 12px;
	border-bottom: 1px solid #eee;
}

.btn-delete-day {
	color: #f44336;
	cursor: pointer;
	background: none;
	border: none;
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
				<li><a href="class.jsp" class="menu-item active"><i
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
					class="current-page">Class</span><span class="breadcrumb-separator">></span>
				<span class="current-page">Manage Attendance: <%=currentClass.getClassName()%></span>
			</div>

			<div class="attendance-container">
				<div class="filter-section">
					<form method="GET" action="manageAttendance.jsp"
						style="display: flex; gap: 15px; align-items: center;">
						<input type="hidden" name="classId" value="<%=classId%>">

						<label>Month:</label> <select name="month"
							onchange="this.form.submit()">
							<%
							String[] months = {"01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"};
							for (String m : months) {
							%>
							<option value="<%=m%>"
								<%=m.equals(selectedMonth) ? "selected" : ""%>><%=new DateFormatSymbols().getMonths()[Integer.parseInt(m) - 1]%></option>
							<%
							}
							%>
						</select> <label>Year:</label> <select name="year"
							onchange="this.form.submit()">
							<option value="2025"
								<%="2025".equals(selectedYear) ? "selected" : ""%>>2025</option>
							<option value="2026"
								<%="2026".equals(selectedYear) ? "selected" : ""%>>2026</option>
						</select>

						<div
							style="flex-grow: 1; text-align: right; display: flex; gap: 10px; justify-content: flex-end;">
							<button type="button" class="btn-delete-bulk btn-month"
								onclick="confirmDelete('month', '<%=selectedMonth%>')">
								<i class="fas fa-calendar-minus"></i> Delete Entire Month
							</button>
							<button type="button" class="btn-delete-bulk btn-year"
								onclick="confirmDelete('year', '<%=selectedYear%>')">
								<i class="fas fa-trash-alt"></i> Delete Whole Year
							</button>
						</div>
					</form>
				</div>

				<h3 style="margin-bottom: 15px;">
					Attendance History for
					<%=new DateFormatSymbols().getMonths()[Integer.parseInt(selectedMonth) - 1]%></h3>
				<div style="border: 1px solid #eee; border-radius: 8px;">
					<%
					if (attendanceDates.isEmpty()) {
					%>
					<p style="padding: 20px; color: #999; text-align: center;">No
						records found for this period.</p>
					<%
					} else {
					for (String date : attendanceDates) {
					%>
					<div class="date-row">
						<span><i class="fas fa-clock"></i> <strong><%=date%></strong></span>
						<div style="display: flex; gap: 10px;">
							<button class="btn-delete-day"
								onclick="confirmDelete('day', '<%=date%>')">
								<i class="fas fa-times-circle"></i> Delete
							</button>
						</div>
					</div>
					<%
					}
					}
					%>
				</div>
				<div
					style="margin-top: 25px; display: flex; justify-content: flex-end;">
					<button type="button" class="btn-second"
						onclick="location.href='class.jsp'">
						<i></i> Back
					</button>
				</div>
			</div>
		</main>
	</div>

	<form id="deleteForm" action="../DeleteAttendanceServlet" method="POST">
		<input type="hidden" name="classId" value="<%= classId %>"> <input
			type="hidden" name="mode" id="deleteMode"> <input
			type="hidden" name="value" id="deleteValue">
	</form>
	<div id="bulkDeleteModal" class="modal-overlay">
		<div class="modal-box">
			<h3 id="bulkDeleteTitle" style="color: black;">Confirm
				</h3>
			<p id="bulkDeleteMessage"></p>
			<p
				style="font-size: 0.85rem; color: #666; margin-top: 10px; font-weight: bold;">
				This action cannot be undone.</p>
			<div class="modal-buttons">
				<button class="modal-btn btn-cancel"
					onclick="closeBulkDeleteModal()">Cancel</button>
				<button class="modal-btn btn-reject" id="confirmBulkDeleteBtn"
					style="background-color: #d93025;">Delete</button>
			</div>
		</div>
	</div>
	<div id="logoutModal" class="modal-overlay">
		<div class="modal-box">
			<h3>Confirm Logout</h3>
			<p>Do you want to logout?</p>
			<div class="modal-buttons">
				<button class="modal-btn btn-cancel" id="cancelLogout">Cancel</button>
				<button class="modal-btn btn-reject" id="confirmLogout">Logout</button>
			</div>
		</div>
	</div>

	<script>
	let currentDeleteMode = null;
	let currentDeleteValue = null;

	function confirmDelete(mode, val) {
	    currentDeleteMode = mode;
	    currentDeleteValue = val;
	    
	    const title = document.getElementById('bulkDeleteTitle');
	    const message = document.getElementById('bulkDeleteMessage');
	    const modal = document.getElementById('bulkDeleteModal');

	    // Customize the message based on selection
	    if (mode === 'day') {
	        title.innerText = "Delete Day Attendance";
	        message.innerText = "Are you sure you want to delete attendance for " + val + "?";
	    } else if (mode === 'month') {
	        title.innerText = "Delete Entire Month";
	        message.innerText = "WARNING: You are about to delete ALL attendance records for this month.";
	    } else if (mode === 'year') {
	        title.innerText = "Delete Whole Year";
	        message.innerText = "CRITICAL: You are about to WIPE the entire 4 Amanah's attendance history for the year " + val + ".";
	    }

	    modal.style.display = 'flex';
	}

	function closeBulkDeleteModal() {
	    document.getElementById('bulkDeleteModal').style.display = 'none';
	}

	// Attach the submit logic to the modal's confirm button
	document.getElementById('confirmBulkDeleteBtn').addEventListener('click', function() {
	    if (currentDeleteMode && currentDeleteValue) {
	        document.getElementById('deleteMode').value = currentDeleteMode;
	        document.getElementById('deleteValue').value = currentDeleteValue;
	        document.getElementById('deleteForm').submit();
	    }
	});
    
    	// 1. Sidebar Toggle
        const menuToggle = document.getElementById('menu-toggle');
        const sidebar = document.getElementById('sidebar');
        if(menuToggle) {
            menuToggle.addEventListener('click', () => { sidebar.classList.toggle('collapsed'); });
        }

        // 2. Profile Menu
        const profileBtn = document.getElementById('profileBtn');
        const profileMenu = document.getElementById('profileMenu');
        if(profileBtn) {
            profileBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                profileMenu.style.display = profileMenu.style.display === 'block' ? 'none' : 'block';
            });
        }
        window.addEventListener('click', () => { if(profileMenu) profileMenu.style.display = 'none'; });

        // 3. Logout Modal
        const logoutOption = document.getElementById('logoutOption');
        const logoutModal = document.getElementById('logoutModal');
        const cancelLogout = document.getElementById('cancelLogout');
        const confirmLogout = document.getElementById('confirmLogout');

        if(logoutOption) logoutOption.addEventListener('click', () => logoutModal.style.display = 'flex');
        if(cancelLogout) cancelLogout.addEventListener('click', () => logoutModal.style.display = 'none');
        if(confirmLogout) confirmLogout.addEventListener('click', () => window.location.href = '../LogoutServlet');

    </script>
</body>
</html>