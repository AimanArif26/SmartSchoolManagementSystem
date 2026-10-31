<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.smartschool.dao.UserDAO"%>
<%@ page import="com.smartschool.model.User"%>
<%@ page import="com.smartschool.model.Student"%>
<%@ page import="com.smartschool.model.Attendance"%>
<%@ page import="java.util.List"%>

<%
    User currentUser = (com.smartschool.model.User) session.getAttribute("currentUser");
    
	String studIC = request.getParameter("studIC");
    String selectedMonth = request.getParameter("selectedMonth"); // Get the month from the dropdown
    
    UserDAO dao = new UserDAO();
    
    if (currentUser == null || studIC == null) {
        response.sendRedirect("classTeacher.jsp");
        return;
    }

    List<Attendance> attendanceList = dao.getStudentAttendanceByIC(studIC, selectedMonth);
    Student student = dao.getStudentByIC(studIC); 
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Attendance History - <%= student != null ? student.getStudName() : "" %></title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="../assets/css/homepage.css">
<link rel="icon" type="image/webp" href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">
<style>
.status-badge {
	padding: 5px 12px;
	border-radius: 15px;
	font-size: 0.8rem;
	font-weight: bold;
	text-transform: uppercase;
}

.status-present {
	background: #d4edda;
	color: #155724;
}

.status-absent {
	background: #f8d7da;
	color: #721c24;
}

.status-mc {
	background: #fff3cd;
	color: #856404;
}
.btn-print {
    background-color: #555;
    color: white;
    padding: 10px 20px;
    border-radius: 20px;
    text-decoration: none;
    font-weight: bold;
    border: none;
    cursor: pointer;
    margin-left: 10px;
    transition: 0.3s;
}
.btn-print:hover {
    background-color: #333;
}
@media print {
    .sidebar, .header, .btn-primary, .btn-print, .breadcrumb {
        display: none !important;
    }
    .main-container, .content {
        margin: 0 !important;
        padding: 0 !important;
    }
    .table-box {
        border: none !important;
        box-shadow: none !important;
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
			<div class="profile-area" id="profileBtn" style="cursor: pointer;">
				<span class="user-name"><%= currentUser.getName() %></span> <img
					src="../assets/image/adminICON.png" alt="Profile"
					class="profile-image">
			</div>
			<div class="profile-menu" id="profileMenu" style="display: none;">
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
				<li><a href="teacherHomepage.jsp" class="menu-item"><i
						class="fas fa-home icon"></i> <span class="link-text">Home</span></a></li>
				<li><a href="attendance.jsp" class="menu-item"><i
						class="fas fa-calendar-check icon"></i> <span class="link-text">Attendance</span></a></li>
				<li><a href="examSelection.jsp" class="menu-item"><i
						class="fas fa-file-invoice icon"></i> <span class="link-text">Examination</span></a></li>
				<li><a href="classTeacher.jsp" class="menu-item active"><i
						class="fas fa-school icon"></i> <span class="link-text">Class</span></a></li>
			</ul>
		</aside>
		<main class="content"
			style="background: linear-gradient(rgba(255, 255, 255, 0.7), rgba(255, 255, 255, 0.7)), 
             url('<%=request.getContextPath()%>/assets/image/background1.png') no-repeat center center fixed; 
             background-size: cover; min-height: 100vh;">			<div class="breadcrumb">
							Hi,
				<%= ("teacher".equalsIgnoreCase(currentUser.getRole())) ? currentUser.getName() : "Teacher" %>
				<span class="breadcrumb-separator">&gt;</span>
				<a style="text-decoration: none; color: inherit;">Class</a> <span class="breadcrumb-separator">></span>
				<span class="current-page">View Attendance</span>
			</div>
				<div class="table-header"
					style="display: flex; justify-content: space-between; align-items: center;">
					<div>
						<h2 style="color: black;">Name : <%= student.getStudName() %></h2>
					</div>
				<button onclick="window.print()" class="btn-print">
					<i class="fas fa-print"></i> Print Report
				</button>
			</div>
			<div class="filter-section" style="margin-bottom: 20px;">
				<form action="viewAttendance.jsp" method="get"
					style="display: flex; align-items: center; gap: 10px;">
					<input type="hidden" name="studIC" value="<%= studIC %>"> <label
						style="font-weight: bold;">Filter by Month:</label> <select
						name="selectedMonth"
						style="padding: 5px 10px; border-radius: 5px; border: 1px solid #8c8279;">
						<option value="ALL">Show All</option>
						<% 
        String[] months = {"January", "February", "March", "April", "May", "June", 
                           "July", "August", "September", "October", "November", "December"};
        String currentFilter = request.getParameter("selectedMonth");
        
        for (int i = 0; i < months.length; i++) {
            String monthVal = String.valueOf(i + 1); // Months are 1-12
            String selected = monthVal.equals(currentFilter) ? "selected" : "";
    %>
						<option value="<%= monthVal %>" <%= selected %>><%= months[i] %></option>
						<% } %>
					</select>
					<button type="submit" class="btn-primary"
						style="padding: 5px 15px;">Filter</button>
				</form>
			</div>
			<div class="table-box">
				<table class="data-table">
					<thead>
						<tr>
							<th>Date</th>
							<th>Status</th>
							<th>Notes</th>
						</tr>
					</thead>
					<tbody>
						<% if(attendanceList != null && !attendanceList.isEmpty()) { 
                            for(Attendance a : attendanceList) { 
                                String statusClass = "status-present";
                                if(a.getStatus().equalsIgnoreCase("Absent")) statusClass = "status-absent";
                                if(a.getStatus().equalsIgnoreCase("MC")) statusClass = "status-mc";
                        %>
						<tr>
							<td><%= a.getDate().substring(0, 10) %></td>
							<td><span class="status-badge <%= statusClass %>"><%= a.getStatus() %></span></td>
							<td><%= (a.getNotes() != null) ? a.getNotes() : "-" %></td>
						</tr>
						<% } } else { %>
						<tr>
							<td colspan="3" style="text-align: center;">No attendance
								records found.</td>
						</tr>
						<% } %>
					</tbody>
				</table>
			</div>
			<div class="submit-container"
				style="display: flex; justify-content: flex-end; margin-top: 25px;">
				<button type="button" class="btn-custom"
					style="background-color: black; color: white; border: none; padding: 12px 35px; border-radius: 25px; cursor: pointer; font-weight: bold;"
					onclick="location.href='classTeacher.jsp'">Back</button>
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