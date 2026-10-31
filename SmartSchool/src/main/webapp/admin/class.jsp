<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.util.Calendar" %>
<%@ page import="com.smartschool.dao.UserDAO"%>
<%@ page import="com.smartschool.model.Teacher"%>
<%@ page import="com.smartschool.model.Classroom"%>

<%
    UserDAO dao = new UserDAO();
    
    // 1. Get the year from URL for filtering
    String yearParam = request.getParameter("year");
    int currentYear = Calendar.getInstance().get(Calendar.YEAR);
    int displayYear = (yearParam != null) ? Integer.parseInt(yearParam) : currentYear;

    // 2. Fetch Data
    List<Teacher> allTeachers = dao.getAllApprovedTeachers(); 
    List<Classroom> classList = dao.getClassroomsByYear(displayYear);
    List<Teacher> availableTeachers = dao.getAvailableTeachers();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart School System - Class Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/studentList.css">
    <link rel="icon" type="image/webp" href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">
    <style>.notification-toast {
    visibility: hidden;
    min-width: 300px;
    background-color: #333;
    color: #fff;
    text-align: center;
    border-radius: 50px;
    padding: 16px;
    position: fixed;
    z-index: 1001;
    left: 50%;
    top: 30px;
    transform: translateX(-50%);
    font-weight: 600;
    box-shadow: 0 4px 15px rgba(0,0,0,0.2);
}

.notification-toast.show {
    visibility: visible;
    animation: fadein 0.5s, fadeout 0.5s 2.5s;
}

.notification-toast.success { background-color: #28a745; }
.notification-toast.error { background-color: #dc3545; }

@keyframes fadein { from { top: 0; opacity: 0; } to { top: 30px; opacity: 1; } }
@keyframes fadeout { from { top: 30px; opacity: 1; } to { top: 0; opacity: 0; } }</style>
</head>
<body>

    <header class="header">
        <div class="header-left">
            <i class="fas fa-bars menu-toggle-icon" id="menu-toggle"></i> <span>Smart School System</span>
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
                <li><a href="class.jsp" class="menu-item active"><i class="fas fa-chalkboard icon"></i> <span class="link-text">Class</span></a></li>
                <li><a href="student.jsp" class="menu-item"><i class="fas fa-user-graduate icon"></i> <span class="link-text">Student</span></a></li>
                <li><a href="validateTeacher.jsp" class="menu-item"><i class="fas fa-user-check icon"></i> <span class="link-text">Validate</span></a></li>
                <li><a href="teacherList.jsp" class="menu-item"><i class="fas fa-users-rectangle icon"></i> <span class="link-text">Teacher List</span></a></li>
                <li><a href="assignment.jsp" class="menu-item"><i class="fas fa-tasks icon"></i> <span class="link-text">Assignment</span></a></li>
                <li><a href="adminSettings.jsp" class="menu-item"><i class="fas fa-cog icon"></i> <span class="link-text">Settings</span></a></li>               
            </ul>
        </aside>

        <main class="content">
            <div class="breadcrumb">
                Hi, Admin <span class="breadcrumb-separator">&gt;</span> <span class="current-page">Class List</span>
            </div>

            <div class="card">
                <div class="card-header-actions">
                    <button class="btn-custom btn-new" onclick="openAddClassModal()">
                        <i class="fas fa-plus"></i> New Class
                    </button>
                </div>

                <div class="controls-row">
					<form action="class.jsp" method="get" id="filterForm"
						class="filter-group">
						<label class="filter-label">Filter by Academic Year</label> <select
							name="year" class="styled-select" onchange="this.form.submit()">
							<%
							for (int i = currentYear + 1; i >= currentYear - 2; i--) {
							%>
							<option value="<%=i%>"
								<%=(i == displayYear) ? "selected" : ""%>><%=i%></option>
							<%
							}
							%>
						</select>
					</form>

					<div class="search-container">
                        <input type="text" id="searchInput" class="form-control" placeholder="Search Class..." onkeyup="searchClass()">
                        <i class="fas fa-magnifying-glass"></i>
                    </div>
                </div>
	
                <div class="table-responsive">
                    <table id="classTable">
                        <thead>
                            <tr>
                                <th style="width: 50px;">No.</th>
                                <th>Class Name</th>
                                <th>Teacher in Charge</th>
                                <th style="width: 150px;">Action</th>
                            </tr>
                        </thead>
                        <tbody id="classTableBody">
                            <% 
                            int count = 1;
                            if(classList != null && !classList.isEmpty()) {
                                for(Classroom c : classList) { 
                            %>
                            <tr>
                                <td><%= count++ %></td>
                                <td><%= c.getClassName() %></td>
                                <td><%= (c.getTeacherName() != null) ? c.getTeacherName() : "<span style='color: #999;'>Not Assigned</span>" %></td>
                                <td class="action-cell">
                                    <div class="action-icons-wrapper">

										<div class="action-btn edit-btn" title="Edit Class"
                                             onclick="openEditClassModal('<%=c.getClassID()%>', '<%=c.getClassName()%>','<%=c.getAcademicYear()%>', '<%=c.getTeacherID()%>')">
                                            <i class="fa-solid fa-pen-to-square" style="color: black;"></i>
                                        </div>
                                        <div class="action-btn delete-btn" title="Delete Class"
                                             onclick="confirmDeleteClass('<%=c.getClassID()%>', '<%=c.getClassName()%>')">
                                            <i class="fa-regular fa-trash-can"></i>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <% 
                                } 
                            } else { 
                            %>
                            <tr>
                                <td colspan="5" style="text-align: center; padding: 20px;">No classes found.</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
					<div id="tableErrorMessage"
						style="color: #dc3545; font-weight: bold; margin-top: 15px; display: none; padding: 10px; background-color: #f8d7da; border-radius: 8px; border: 1px solid #f5c6cb;">
						<i class="fas fa-exclamation-circle"></i> <span id="errorText"></span>
					</div>
				</div>
            </div>
            
            <div id="toastNotification" class="notification-toast">Message</div>
        </main>
    </div>

    <div id="addClassModal" class="modal-overlay">
        <div class="beige-modal">
            <span class="close-icon" onclick="closeAddClassModal()">&times;</span>
            <h3>Create New Class</h3>
            <form action="../ClassServlet" method="POST">
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label>Class Name</label>
                    <input type="text" name="className" class="edit-input" placeholder="e.g. 1 Amanah" required>
                </div>

                <div class="form-group">
                    <label>Year</label>
                    <input type="number" name="year" class="edit-input" value="<%=currentYear%>" required>
                </div>

                <div class="form-group">
                    <label>Teacher-in-Charge</label>
                    <select name="teacherId" class="edit-input">
                        <option value="">-- Select Teacher (Optional) --</option>
                        <% for (Teacher teach : availableTeachers) { %>
                            <option value="<%=teach.getTeacherID()%>"><%=teach.getTeacherName()%></option>
                        <% } %>
                    </select>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-save-grey">Create Class</button>
                </div>
            </form>
        </div>
    </div>

    <div id="editClassModal" class="modal-overlay">
        <div class="beige-modal">
            <span class="close-icon" onclick="closeEditClassModal()">&times;</span>
            <h3>Edit Class</h3>
            <form action="../ClassServlet" method="POST">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="classId" id="editClassId">

                <div class="form-group">
                    <label>Class Name</label>
                    <input type="text" name="className" id="editClassName" class="edit-input" required>
                </div>
				<div class="form-group">
					<label>Academic Year</label> <select name="year" id="editClassYear"
						class="edit-input" required>
						<option value="2025">2025</option>
						<option value="2026" selected>2026</option>
						<option value="2027">2027</option>
						<option value="2028">2028</option>
					</select>
				</div>
				<div class="form-group">
                    <label>Teacher-in-Charge</label>
                    <select name="teacherId" id="editClassTeacher" class="edit-input">
                        <option value="">-- No Teacher Assigned --</option>
                        <% for (Teacher t : dao.getAllApprovedTeachers()) { %>
                            <option value="<%=t.getTeacherID()%>"><%=t.getTeacherName()%></option>
                        <% } %>
                    </select>
                </div>

 				<div class="modal-buttons">
					<button type="button" class="modal-btn btn-cancel"
						onclick="closeEditClassModal()">Cancel</button>
					<button type="submit" class="modal-btn btn-reject"
						style="background-color: #5a4a42;">Confirm</button>
				</div>
            </form>
        </div>
		<div id="toastNotification" class="notification-toast"></div>
	</div>
	
    <div id="deleteClassModal" class="modal-overlay">
        <div class="beige-modal" style="text-align: center;">
            <span class="close-icon" onclick="closeDeleteModal()">&times;</span>
            <h3 style="color: black;">Confirm Deletion</h3>
            <p id="modalMessage">Are you sure you want to delete class: <strong id="deleteClassNameDisplay"></strong>?</p>
            <div class="modal-buttons" style="margin-top: 20px;">
                <button type="button" class="modal-btn" onclick="closeDeleteModal()" style="background-color: #ccc;">Cancel</button>
                <button type="button" class="modal-btn" id="confirmDeleteBtn" style="background-color: #5a4a42; color:white;">Confirm</button>
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
        // Search Logic
        function searchClass() {
            var input = document.getElementById("searchInput");
            var filter = input.value.toUpperCase();
            var tableBody = document.getElementById("classTableBody");
            var tr = tableBody.getElementsByTagName("tr");

            for (var i = 0; i < tr.length; i++) {
                var tdName = tr[i].getElementsByTagName("td")[1];
                var tdTeacher = tr[i].getElementsByTagName("td")[3];
                if (tdName || tdTeacher) {
                    var nameVal = tdName.textContent || tdName.innerText;
                    var teacherVal = tdTeacher.textContent || tdTeacher.innerText;
                    if (nameVal.toUpperCase().indexOf(filter) > -1 || teacherVal.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }

        // Modal Functions
        function openAddClassModal() { document.getElementById('addClassModal').style.display = 'flex'; }
        function closeAddClassModal() { document.getElementById('addClassModal').style.display = 'none'; }
        
        function openEditClassModal(classId, className, classYear, teacherId) {
            document.getElementById('editClassId').value = classId;
            document.getElementById('editClassName').value = className;
            
            const yearSelect = document.getElementById('editClassYear');
            yearSelect.value = classYear; 
            
            document.getElementById('editClassTeacher').value = teacherId;
            document.getElementById('editClassModal').style.display = 'flex';
        }
        function closeEditClassModal() { document.getElementById('editClassModal').style.display = 'none'; }

        let classIdToDelete = null;
        function confirmDeleteClass(id, name) {
            classIdToDelete = id;
            document.getElementById('deleteClassNameDisplay').innerText = name;
            document.getElementById('deleteClassModal').style.display = 'flex';
        }
        function closeDeleteModal() { document.getElementById('deleteClassModal').style.display = 'none'; }

        document.getElementById('confirmDeleteBtn').addEventListener('click', function() {
            if (classIdToDelete) window.location.href = "../ClassServlet?action=delete&classId=" + classIdToDelete;
        });

        // UI Helpers
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

        const logoutOption = document.getElementById('logoutOption');
        const logoutModal = document.getElementById('logoutModal');
        logoutOption.addEventListener('click', () => logoutModal.style.display = 'flex');
        document.getElementById('cancelLogout').addEventListener('click', () => logoutModal.style.display = 'none');
        document.getElementById('confirmLogout').addEventListener('click', () => window.location.href = '../LogoutServlet');
        
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            const status = urlParams.get('status');
            const toast = document.getElementById("toastNotification");
            const errorContainer = document.getElementById("tableErrorMessage");
            const errorText = document.getElementById("errorText");

            if (status) {
                let message = "";
                let type = "success"; // Default to success style

                switch(status) {
                    case 'success': 
                        message = "✅ New Class Added successfully!"; 
                        break;
                    case 'updated': 
                        message = "✏️ Class Updated Successfully!"; 
                        break;
                    case 'deleted': 
                        message = "🗑️ Class Deleted Successfully!"; 
                        break;
                    case 'error': 
                        message = "❌ Action failed. Please try again."; 
                        type = "error";
                        break;
                }

                if (message) {
                    toast.innerText = message;
                    toast.className = "notification-toast " + type + " show";
                    
                    // Hide after 3 seconds and clean URL
                    setTimeout(() => {
                        toast.classList.remove("show");
                        window.history.replaceState({}, document.title, window.location.pathname);
                    }, 3000);
                }
             // Only show if the status is an error type
                if (status === 'teacherTaken' || status === 'error') {
                    let message = "";
                    
                    if (status === 'teacherTaken') {
                        message = "This teacher is already assigned to another class. Please choose a different teacher.";
                    } else {
                        message = "An error occurred while processing the class. Please try again.";
                    }

                    errorText.innerText = message;
                    errorContainer.style.display = "block";
                    
                    // Clean URL without hiding the message immediately
                    window.history.replaceState({}, document.title, window.location.pathname);
                }	
            }
        };
        function validateAcademicYear() {
            const yearInput = document.getElementById('editClassYear');
            const errorMsg = document.getElementById('yearError');
            const currentYear = new Date().getFullYear();
            const enteredYear = parseInt(yearInput.value);

            // Constraint: Year must be between (CurrentYear - 1) and (CurrentYear + 10)
            if (enteredYear < (currentYear - 1) || enteredYear > (currentYear + 10)) {
                yearInput.style.borderColor = "#dc3545";
                errorMsg.textContent = `Year must be between ${currentYear - 1} and ${currentYear + 10}`;
                errorMsg.style.display = "block";
                return false;
            }

            yearInput.style.borderColor = "#ddd";
            errorMsg.style.display = "none";
            return true;
        }

        // Update your form submission to include this check
        document.querySelector('#editClassModal form').onsubmit = function(e) {
            if (!validateAcademicYear()) {
                e.preventDefault(); // Stop form from submitting
                return false;
            }
            return true;
        };
    </script>
</body>
</html>