<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.smartschool.model.Teacher"%>
<%@ page import="java.util.List"%>

<%
    // Safety check: Redirect if accessed directly without Servlet
    List<Teacher> teacherList = (List<Teacher>) request.getAttribute("teacherList");
    if (teacherList == null) {
        response.sendRedirect(request.getContextPath() + "/admin/TeacherListServlet");
        return;
    }
    String currentStatus = (String) request.getAttribute("currentStatus");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Smart School System - Teacher List</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/teacherList.css"><link rel="icon" type="image/webp" href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">
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
				<li><a
					href="${pageContext.request.contextPath}/admin/TeacherListServlet"
					class="menu-item active"><i class="fas fa-users-rectangle icon"></i>
						<span class="link-text">Teacher List</span></a></li>
				<li><a href="assignment.jsp" class="menu-item"><i
						class="fas fa-tasks icon"></i> <span class="link-text">Assignment</span></a></li>
				<li><a href="adminSettings.jsp" class="menu-item"><i
						class="fas fa-cog icon"></i> <span class="link-text">Settings</span></a></li>
			</ul>
		</aside>

		<main class="content">
			<div class="breadcrumb">
				Hi, Admin <span class="breadcrumb-separator">&gt;</span> <span
					class="current-page">Teacher List</span>
			</div>

			<div class="card">
				<div class="controls-row">

					<form
						action="${pageContext.request.contextPath}/admin/TeacherListServlet"
						method="get" id="filterForm" class="filter-group">
						<label class="filter-label">Status:</label> <select name="status"
							class="styled-select"
							onchange="document.getElementById('filterForm').submit()">
							<option value="ACTIVE"
								<%= "ACTIVE".equals(currentStatus) ? "selected" : "" %>>Active
								Teachers</option>
							<option value="INACTIVE"
								<%= "INACTIVE".equals(currentStatus) ? "selected" : "" %>>Inactive
								Teachers</option>
						</select>
					</form>

					<div class="search-container">
						<input type="text" id="searchInput" class="form-control"
							placeholder="Search Teacher Name..." onkeyup="searchTable()">
						<i class="fas fa-magnifying-glass"></i>
					</div>
				</div>

				<div class="table-responsive">
					<table id="teacherTable">
						<thead>
							<tr>
								<th style="width: 50px;">No.</th>
								<th>Name</th>
								<th>Certificate No</th>
								<th>Email</th>
								<th>Phone No.</th>
								<th style="width: 100px;">Action</th>
							</tr>
						</thead>
						<tbody>
							<%
                                int count = 1;
                                if (teacherList.isEmpty()) {
                            %>
							<tr>
								<td colspan="6" style="text-align: center; padding: 20px;">
									No teachers found</td>
							</tr>
							<%
                                } else {
                                    for (Teacher t : teacherList) {
                            %>
							<tr>
								<td><%=count++%></td>
								<td><%=t.getTeacherName()%></td>
								<td><%=t.getCertNumber()%></td>
								<td><%=t.getTeacherEmail()%></td>
								<td><%=t.getTeacherPhoneNum()%></td>
								<td class="action-cell">
									<% if ("ACTIVE".equals(currentStatus)) { %>
									<div class="action-icons-wrapper">
										<div class="action-btn edit-btn"
											onclick="openEditModal('<%=t.getTeacherID()%>', '<%=t.getTeacherName()%>', '<%=t.getCertNumber()%>', '<%=t.getTeacherPhoneNum()%>', '<%=t.getTeacherEmail()%>')">
											<i class="fa-solid fa-pen-to-square" style="color: black;"></i>
										</div>
										<div class="action-btn delete-btn"
											onclick="openSingleDeleteModal('<%=t.getTeacherID()%>')">
											<i class="fa-regular fa-trash-can"></i>
										</div>
									</div> <% } else { %> <span style="color: #999; font-size: 0.9em;">(Inactive)</span>
									<% } %>
								</td>
							</tr>
							<%
                                    }
                                }
                            %>
						</tbody>
					</table>
				</div>
			</div>
			<div id="toastNotification" class="notification-toast">Message</div>
		</main>
	</div>

	<div id="editTeacherModal" class="modal-overlay">
		<div class="beige-modal">
			<h3>Edit Teacher</h3>
			<form
				action="${pageContext.request.contextPath}/admin/TeacherListServlet"
				method="post">
				<input type="hidden" name="action" value="edit"> <input
					type="hidden" id="editTeacherId" name="editTeacherId">

				<div class="form-group">
					<label>Name</label> <input type="text" id="editName"
						class="edit-input readonly-input" readonly>
				</div>

				<div class="form-group">
					<label>Certificate No</label> <input type="text" id="editCert"
						class="edit-input readonly-input" readonly>
				</div>

				<div class="form-group">
					<label>Email</label> <input type="email" id="editEmail"
						class="edit-input readonly-input" readonly>
				</div>

				<div class="form-group">
					<label>Phone No.</label> <input type="text" id="editPhone"
						name="editPhone" class="edit-input" required>
				</div>

				<div class="form-group">
					<label>New Password (Optional)</label> <input type="password"
						name="editPassword" class="edit-input"
						placeholder="Leave blank to keep current">
				</div>

				<div class="modal-buttons">
					<button type="button" class="modal-btn btn-cancel"
						onclick="closeEditModal()">Cancel</button>
					<button type="submit" class="modal-btn btn-reject" style="background-color: #5a4a42;">Confirm</button>
				</div>
			</form>
		</div>
	</div>

	<div id="deleteTeacherModal" class="modal-overlay">
		<div class="modal-box">
			<h3 style="color: black;">Confirm Deactivation</h3>
			<p>Are you sure you want to deactivate this teacher?</p>
			<p style="font-size: 0.85rem; color: #666; margin-top: 5px;">The
				teacher will no longer be able to log in to the system.</p>
			<form
				action="${pageContext.request.contextPath}/admin/TeacherListServlet"
				method="post">
				<input type="hidden" name="action" value="delete"> <input
					type="hidden" id="deleteTeacherId" name="teacherId">
				<div class="modal-buttons">
					<button type="button" class="modal-btn btn-cancel"
						onclick="closeDeleteModal()">Cancel</button>
					<button type="submit" class="modal-btn btn-reject"
						style="background-color: #5a4a42;">Confirm</button>
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
				<button class="modal-btn btn-reject" id="confirmLogout">Logout</button>
			</div>
		</div>
	</div>

	<script>
    const menuToggle = document.getElementById('menu-toggle');
    const sidebar = document.getElementById('sidebar');
    if (menuToggle) {
        menuToggle.addEventListener('click', () => sidebar.classList.toggle('collapsed'));
    }

    const profileBtn = document.getElementById('profileBtn');
    const profileMenu = document.getElementById('profileMenu');
    if (profileBtn) {
        profileBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            profileMenu.style.display = profileMenu.style.display === 'block' ? 'none' : 'block';
        });
    }
    
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

    function searchTable() {
        let input = document.getElementById("searchInput").value.toUpperCase();
        let table = document.getElementById("teacherTable");
        let tr = table.getElementsByTagName("tr");
        for (let i = 1; i < tr.length; i++) { 
            let td = tr[i].getElementsByTagName("td")[1];
            if (td) {
                let txtValue = td.textContent || td.innerText;
                tr[i].style.display = txtValue.toUpperCase().indexOf(input) > -1 ? "" : "none";
            }
        }
    }

function openEditModal(id, name, cert, phone, email) {
    document.getElementById('editTeacherId').value = id;
    document.getElementById('editName').value = name;
    document.getElementById('editCert').value = cert;
    document.getElementById('editEmail').value = email;
    document.getElementById('editPhone').value = phone;

    document.getElementById('editTeacherModal').style.display = 'flex';
}

function closeEditModal() {
    document.getElementById('editTeacherModal').style.display = 'none';
}
    function openSingleDeleteModal(id) {
        document.getElementById('deleteTeacherId').value = id;
        document.getElementById('deleteTeacherModal').style.display = 'flex';
    }

    function closeDeleteModal() {
        document.getElementById('deleteTeacherModal').style.display = 'none';
    }

    window.onclick = function(event) {
        if (event.target == document.getElementById('editTeacherModal')) closeEditModal();
        if (event.target == document.getElementById('deleteTeacherModal')) closeDeleteModal();
        if (profileMenu && event.target != profileBtn && !profileBtn.contains(event.target)) {
             profileMenu.style.display = 'none';
        }
    }

    window.onload = function() {
        const urlParams = new URLSearchParams(window.location.search);
        const status = urlParams.get('status');
        const toast = document.getElementById("toastNotification");

        if (status) {
            let message = "";
            let type = "";
            switch(status) {
                case 'success': message = "✅ Update Successful!"; type = "success"; break;
                case 'successDelete': message = "🗑️ Teacher Deactivated Successfully!"; type = "success"; break;
                case 'fail': message = "❌ Action Failed."; type = "error"; break;
                case 'error': message = "⚠️ System Error."; type = "error"; break;
            }
            if (message) {
                toast.innerText = message;
                toast.className = "notification-toast " + type; 
                toast.classList.add("show");
                setTimeout(function(){ toast.classList.remove("show"); }, 3000);
                window.history.replaceState({}, document.title, window.location.pathname);
            }
        }
    };
    </script>
</body>
</html>