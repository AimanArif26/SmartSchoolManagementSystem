<%@ page import="com.smartschool.model.User"%>
<%@ page import="com.smartschool.model.Teacher"%>
<%@ page import="com.smartschool.dao.UserDAO"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    UserDAO dao = new UserDAO();
    List<Teacher> pendingTeachers = dao.getPendingTeachers();
    List<Teacher> headTeachers = dao.getHeadTeachers();
    if (headTeachers == null) headTeachers = new ArrayList<>();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart School System - Validate Teachers</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/studentList.css">
    <link rel="icon" type="image/webp" href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">
</head>
<body>

    <header class="header">
        <div class="header-left">
            <i class="fas fa-bars menu-toggle-icon" id="menu-toggle"></i> 
            <span>Smart School System</span>
        </div>
        <div class="header-right">
            <div class="profile-area" id="profileBtn">
                <span class="user-name">Admin</span> 
                <img src="../assets/image/adminICON.png" alt="Admin Profile" class="profile-image">
            </div>
            <div class="profile-menu" id="profileMenu">
                <p onclick="location.href='adminProfile.jsp'"><i class="fas fa-user"></i> My Profile</p>
                <p id="logoutOption"><i class="fas fa-sign-out-alt"></i> Logout</p>
            </div>
        </div>
    </header>

    <div class="main-container">
        <aside class="sidebar" id="sidebar">
            <ul class="sidebar-menu">
                <li><a href="adminHomepage.jsp" class="menu-item"><i class="fas fa-home icon"></i> <span class="link-text">Home</span></a></li>
                <li><a href="class.jsp" class="menu-item"><i class="fas fa-chalkboard icon"></i> <span class="link-text">Class</span></a></li>
                <li><a href="student.jsp" class="menu-item"><i class="fas fa-user-graduate icon"></i> <span class="link-text">Student</span></a></li>
                <li><a href="validateTeacher.jsp" class="menu-item active"><i class="fas fa-user-check icon"></i> <span class="link-text">Validate</span></a></li>
                <li><a href="teacherList.jsp" class="menu-item"><i class="fas fa-users-rectangle icon"></i> <span class="link-text">Teacher List</span></a></li>
                <li><a href="assignment.jsp" class="menu-item"><i class="fas fa-tasks icon"></i> <span class="link-text">Assignment</span></a></li>
                <li><a href="adminSettings.jsp" class="menu-item"><i class="fas fa-cog icon"></i> <span class="link-text">Settings</span></a></li>                
            </ul>
        </aside>

        <main class="content">
            <div class="breadcrumb">
                Hi, Admin <span class="breadcrumb-separator">&gt;</span> <span class="current-page">Validate Registrations</span>
            </div>

            <div class="card">
                <div class="controls-row">
                    <div class="filter-group">
                        <label class="filter-label">Pending Requests: <%= pendingTeachers.size() %></label>
                    </div>
                </div>

                <div class="table-responsive">
                    <table id="validateTable">
                        <thead>
                            <tr>
                                <th style="width: 50px;">No.</th>
                                <th>Teacher Name</th>
                                <th>Certificate Number</th>
                                <th style="width: 200px; text-align: center;">Action</th>
                            </tr>
                        </thead>
                        <tbody id="validateTableBody">
                            <%
                            int count = 1;
                            if (pendingTeachers.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="4" style="text-align: center; padding: 20px;">No pending registrations found.</td>
                            </tr>
                            <%
                            } else {
                                for (Teacher t : pendingTeachers) {
                            %>
                            <tr>
                                <td><%=count++%></td>
                                <td><strong><%=t.getTeacherName()%></strong></td>
                                <td><%=t.getCertNumber()%></td>
                                <td class="action-cell">
                                    <div class="action-icons-wrapper" style="justify-content: center; gap: 15px;">
                                        <button class="btn-custom" style="background-color: #28a745; color: white; border:none; padding: 12px 30px; border-radius: 30px; cursor:pointer;" 
                                                onclick="openPopup(<%=t.getTeacherID()%>, 'approve')">
                                            <i class="fas fa-check"></i> Approve
                                        </button>
                                        <button class="btn-custom" style="background-color: #dc3545; color: white; border:none; padding: 12px 30px; border-radius: 30px; cursor:pointer;" 
                                                onclick="openPopup(<%=t.getTeacherID()%>, 'reject')">
                                            <i class="fas fa-times"></i> Reject
                                        </button>
                                    </div>
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
            
            <div id="toastNotification" class="notification-toast"></div>
        </main>
    </div>

    <div id="confirmModal" class="modal-overlay">
        <div class="beige-modal">
            <span class="close-icon" onclick="closePopup()">&times;</span>
            <h3 id="modalTitle">Validate Teacher</h3>
            <p id="modalMessage" style="margin-bottom: 20px; color: #666;"></p>

            <div id="hierarchySection" style="display:none;">
                <div class="form-group">
                    <label>Assign Role</label>
                    <select id="roleSelect" class="edit-input" onchange="toggleSupervisorView(this.value)">
                        <option value="standard">Standard Teacher</option>
                        <option value="head">Head of Subject</option>
                    </select>
                </div>

                <div id="supervisorDiv" class="form-group" style="margin-top:15px;">
                    <label>Report To (Head of Subject)</label>
                    <select id="headTeacherId" class="edit-input">
                        <option value="0">-- Select Teacher --</option>
                        <% for(Teacher head : headTeachers) { %>
                            <option value="<%= head.getTeacherID() %>"><%= head.getTeacherName() %></option>
                        <% } %>
                    </select>
                </div>
            </div>

            	<div class="modal-buttons">
					<button type="button" class="modal-btn btn-cancel"
						onclick="closeEditModal()">Cancel</button>
					<button type="button" id="confirmBtn" class="modal-btn btn-reject" onclick="confirmAction()"
						style="background-color: #5a4a42;">Confirm</button>
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
    // Standard UI Logic
    const menuToggle = document.getElementById('menu-toggle');
    const sidebar = document.getElementById('sidebar');
    menuToggle.addEventListener('click', () => sidebar.classList.toggle('collapsed'));
    
    const profileBtn = document.getElementById('profileBtn');
    const profileMenu = document.getElementById('profileMenu');
    profileBtn.addEventListener('click', (e) => {
        e.stopPropagation();
        profileMenu.style.display = profileMenu.style.display === 'block' ? 'none' : 'block';
    });
    window.onclick = () => profileMenu.style.display = 'none';

    // Logout
    document.getElementById('logoutOption').addEventListener('click', () => document.getElementById('logoutModal').style.display = 'flex');
    document.getElementById('cancelLogout').addEventListener('click', () => document.getElementById('logoutModal').style.display = 'none');
    document.getElementById('confirmLogout').addEventListener('click', () => window.location.href = '../LogoutServlet');

    // Search Logic
    function searchTable() {
        let input = document.getElementById("searchInput").value.toUpperCase();
        let rows = document.getElementById("validateTableBody").getElementsByTagName("tr");
        for (let row of rows) {
            let nameCol = row.getElementsByTagName("td")[1];
            if (nameCol) {
                let text = nameCol.textContent || nameCol.innerText;
                row.style.display = text.toUpperCase().includes(input) ? "" : "none";
            }
        }
    }

    // Modal & Validation Logic
    const modal = document.getElementById('confirmModal');
    const modalTitle = document.getElementById('modalTitle');
    const modalMessage = document.getElementById('modalMessage');
    const hierarchySection = document.getElementById('hierarchySection');
    const confirmBtn = document.getElementById('confirmBtn');

    let currentRowId = null;
    let currentAction = null;

    function openPopup(teacherId, action) {
        currentRowId = teacherId;
        currentAction = action;
        modal.style.display = 'flex';
        
        if (action === 'approve') {
            modalTitle.innerText = "Approve Teacher";
            modalMessage.innerText = "Set the role and supervisor for this teacher.";
            hierarchySection.style.display = 'block';
            confirmBtn.innerText = "Confirm";
            confirmBtn.style.backgroundColor = "#5a4a42";
        } else {
            modalTitle.innerText = "Reject Registration";
            modalMessage.innerText = "Are you sure you want to permanently delete this registration request?";
            hierarchySection.style.display = 'none';
            confirmBtn.innerText = "Confirm";
            confirmBtn.style.backgroundColor = "#5a4a42";
        }
    }

    function toggleSupervisorView(role) {
        document.getElementById('supervisorDiv').style.display = (role === 'head') ? 'none' : 'block';
    }

    function closePopup() { modal.style.display = 'none'; }

    function confirmAction() {
        if (currentRowId && currentAction) {
            let url = "../ValidationServlet?userId=" + currentRowId + "&action=" + currentAction;
            if(currentAction === 'approve') {
                const role = document.getElementById('roleSelect').value;
                const headId = document.getElementById('headTeacherId').value;
                url += "&headId=" + (role === 'head' ? "0" : headId);
            }
            window.location.href = url;
        }
    }
    function closeEditModal() {
        document.getElementById('confirmModal').style.display = 'none';
    }
    // Toast Notifications
    window.onload = function() {
        const urlParams = new URLSearchParams(window.location.search);
        const status = urlParams.get('status');
        const toast = document.getElementById("toastNotification");

        if (status) {
            let msg = "";
            if (status === 'success') msg = "✅ Teacher Successfully Registered!";
            else if (status === 'rejected') msg = "❌ Registration Rejected.";
            else if (status === 'error') msg = "⚠️ Validation Error.";

            if (msg) {
                toast.innerText = msg;
                toast.className = "notification-toast show " + (status === 'success' ? 'success' : 'error');
                setTimeout(() => {
                    toast.classList.remove("show");
                    window.history.replaceState({}, document.title, window.location.pathname);
                }, 3000);
            }
        }
    };
    </script>
</body>
</html>