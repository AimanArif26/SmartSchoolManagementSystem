<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.smartschool.dao.UserDAO" %>
<%@ page import="com.smartschool.model.Student" %>

<%
	UserDAO dao = new UserDAO();
    List<Student> studentList = (List<Student>) request.getAttribute("studentList");
    if (studentList == null) {
        studentList = dao.getAllStudents(); 
    }
    List<com.smartschool.model.Classroom> classroomList = dao.getAllClasses();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart School System - Student List</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/studentList.css">
    <link rel="icon" type="image/webp" href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">
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
                <li><a href="student.jsp" class="menu-item active"><i class="fas fa-user-graduate icon"></i> <span class="link-text">Student</span></a></li>
                <li><a href="validateTeacher.jsp" class="menu-item"><i class="fas fa-user-check icon"></i> <span class="link-text">Validate</span></a></li>
                <li><a href="teacherList.jsp" class="menu-item"><i class="fas fa-users-rectangle icon"></i> <span class="link-text">Teacher List</span></a></li>
                <li><a href="assignment.jsp" class="menu-item"><i class="fas fa-tasks icon"></i> <span class="link-text">Assignment</span></a></li>
                <li><a href="adminSettings.jsp" class="menu-item"><i class="fas fa-cog icon"></i> <span class="link-text">Settings</span></a></li>
            </ul>
        </aside>

        <main class="content">
            <div class="breadcrumb">
                Hi, Admin <span class="breadcrumb-separator">&gt;</span> <span class="current-page">Student List</span>
            </div>

            <div class="card">
                <div class="card-header-actions">
                    <button class="btn-custom btn-new" onclick="window.location.href='StudentListServlet?action=showAddForm'">
                        <i class="fas fa-plus"></i> New Student
                    </button>
                </div>
                <div class="controls-row">
                    
                    <form action="StudentListServlet" method="get" id="filterForm" class="filter-group">
                        <label class="filter-label">Filter by Year</label>
                        <select name="searchYear" class="styled-select" onchange="document.getElementById('filterForm').submit()">
                            <option value="">All Years</option>
                            <option value="1" ${param.searchYear == '1' ? 'selected' : ''}>Year 1</option>
                            <option value="2" ${param.searchYear == '2' ? 'selected' : ''}>Year 2</option>
                            <option value="3" ${param.searchYear == '3' ? 'selected' : ''}>Year 3</option>
                            <option value="4" ${param.searchYear == '4' ? 'selected' : ''}>Year 4</option>
                            <option value="5" ${param.searchYear == '5' ? 'selected' : ''}>Year 5</option>
                            <option value="6" ${param.searchYear == '6' ? 'selected' : ''}>Year 6</option>
                        </select>
                    </form>

                    <div class="search-container">
                        <input type="text" id="searchInput" class="form-control" placeholder="Search Name or IC..." onkeyup="searchStudent()">
                        <i class="fas fa-magnifying-glass"></i>
                    </div>
                </div>

                <div class="table-responsive">
                    <table id="studentTable">
                        <thead>
                            <tr>
                                <th style="width: 50px;">No.</th>
                                <th>Name</th>
                                <th>IC Number</th>
                                <th>Class</th>
                                <th>Address</th>
                                <th>Gender</th>
                                <th>Date of Birth</th>
                                <th style="width: 100px;">Action</th>
                            </tr>
                        </thead>
                        <tbody id="studentTableBody">
                            <%
                                if (studentList != null && !studentList.isEmpty()) {
                                    int count = 1;
                                    for (Student s : studentList) {
                            %>
                            <tr>
                                <td><%= count++ %></td>
                                <td><%= s.getStudName() %></td>
                                <td><%= s.getStudIC() %></td>
                                <td><%= s.getClassName() %></td> 
                                <td><%= s.getAddress() %></td>
                                <td><%= s.getStudGender() %></td>
                                <td><%= s.getDateOfBirth() %></td>
								<td class="action-cell">
									<div class="action-icons-wrapper">
										<div class="action-btn edit-btn" title="Edit Student"
											onclick="openEditModal('<%=s.getStudIC()%>', '<%=s.getStudName()%>', '<%=s.getStudYear()%>', '<%=s.getClassName()%>')">
											<i class="fa-solid fa-pen-to-square" style="color: black;"></i>
										</div>
										<div class="action-btn delete-btn"
											onclick="deleteSingleStudent(this, '<%=s.getStudIC()%>')">
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
                                <td colspan="8" style="text-align: center; padding: 20px;">
                                    No students found.
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                <div class="card-footer">
                    <button class="btn-custom btn-del-all" onclick="deleteAllStudents('${param.searchYear}')">
                        <i class="fas fa-trash"></i> Delete All ${not empty param.searchYear ? 'Year ' : ''}${param.searchYear}
                    </button>
					<button class="btn-custom btn-promote-all" onclick="promoteAllStudents('${param.searchYear}')"
						style="background-color: #28a745; color: white; border: none; padding: 10px 15px; border-radius: 8px; cursor: pointer;">
						<i class="fas fa-level-up-alt"></i> Promote All ${not empty param.searchYear ? 'Year ' : ''}${param.searchYear}
					</button>
				</div>
            </div>
            
            <div id="toastNotification" class="notification-toast">Message</div>
        </main>
    </div>
	<div id="editStudentModal" class="modal-overlay">
    <div class="beige-modal">
        <h3>Edit Student</h3>

        <form action="${pageContext.request.contextPath}/admin/UpdateStudentServlet" method="post">
            <input type="hidden" id="editStudIC" name="studIC">

            <div class="form-group">
                <label>Name</label> 
                <input type="text" id="editName" class="edit-input readonly-input" readonly>
            </div>

            <div class="form-group">
                <label>IC Number</label> 
                <input type="text" id="editICDisplay" class="edit-input readonly-input" readonly>
            </div>

            <div class="form-group">
                <label>Year</label> 
                <select id="editYear" name="year" class="edit-input" required>
                    <option value="1">Year 1</option>
                    <option value="2">Year 2</option>
                    <option value="3">Year 3</option>
                    <option value="4">Year 4</option>
                    <option value="5">Year 5</option>
                    <option value="6">Year 6</option>
                </select>
            </div>

            <div class="form-group">
                <label>Class Name</label> 
                <select id="editClassName" name="className" class="edit-input" required>
                    <option value="">-- Select Class --</option>
                    <% if (classroomList != null) {
                        for (com.smartschool.model.Classroom c : classroomList) { %>
                        <option value="<%=c.getClassName()%>" data-year="<%=c.getClassYear()%>">
                            <%=c.getClassName()%>
                        </option>
                    <% } } %>
                </select>
            </div>
				<div class="modal-buttons"
					style="display: flex; justify-content: center; gap: 15px;">
					<button type="button" class="modal-btn"
						onclick="closeEditModal()" style="background-color: #ccc;">Cancel</button>
					<button type="submit" class="modal-btn"
						style="background-color: #5a4a42; color:white;">Confirm</button>
				</div>
			</form>
    </div>
</div>
	<div id="deleteStudentModal" class="modal-overlay">
		<div class="beige-modal" style="text-align: center;">
			<span class="close-icon" onclick="closeDeleteModal()">&times;</span>

			<h3 id="deleteModalTitle"; style="color: black;">Confirm Deletion</h3>
			<p id="modalMessage" style="color: #5a4a42; margin-bottom: 25px;">Do
				you want to delete this student?</p>

			<div id="doubleConfirmContainer"
				style="display: none; margin-bottom: 20px;">
				<p style="font-size: 0.9rem; color: #666; margin-bottom: 5px;">
					Type <strong>DELETE</strong> to confirm:
				</p>
				<input type="text" id="confirmInput" placeholder="DELETE"
					autocomplete="off" class="edit-input" style="text-align: center;">
				<p id="inputError"
					style="color: red; font-size: 0.8rem; display: none; margin-top: 5px;">
					Incorrect word. Try again.</p>
			</div>

			<div class="modal-buttons"
				style="display: flex; justify-content: center; gap: 15px;">
				<button type="button" class="modal-btn"
					onclick="closeDeleteModal()" style="background-color: #ccc;">Cancel</button>
				<button type="button" class="modal-btn"
					onclick="confirmDelete()" style="background-color: #5a4a42; color:white;">Confirm</button>
			</div>
		</div>
	</div>
	<div id="promoteStudentModal" class="modal-overlay">
    <div class="beige-modal" style="text-align: center;">
        <span class="close-icon" onclick="closePromoteModal()">&times;</span>
        
        <h3 style="color: black;">Confirm Promotion</h3>
        <p id="promoteModalMessage" style="color: #5a4a42; margin-bottom: 25px;">Do you want to promote these students?</p>
        
        <div style="background: #fff3cd; color: #856404; padding: 10px; border-radius: 8px; font-size: 0.85rem; margin-bottom: 20px; border: 1px solid #ffeeba;">
            <i class="fas fa-exclamation-triangle"></i> 
            <strong>Note:</strong> Year 6 students will be marked as INACTIVE upon promotion.
        </div>

        <div class="modal-buttons" style="display: flex; justify-content: center; gap: 15px;">
            <button type="button" class="modal-btn" onclick="closePromoteModal()" style="background-color: #ccc;">Cancel</button>
            <button type="button" class="modal-btn" id="confirmPromoteBtn" style="background-color: #5a4a42; color:white;">Confirm</button>
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

        function searchStudent() {
            var input = document.getElementById("searchInput");
            var filter = input.value.toUpperCase();
            var tableBody = document.getElementById("studentTableBody");
            var tr = tableBody.getElementsByTagName("tr");

            for (var i = 0; i < tr.length; i++) {
                var tdName = tr[i].getElementsByTagName("td")[1];
                var tdIC = tr[i].getElementsByTagName("td")[2];

                if (tdName || tdIC) {
                    var nameValue = tdName.textContent || tdName.innerText;
                    var icValue = tdIC.textContent || tdIC.innerText;
                    if (nameValue.toUpperCase().indexOf(filter) > -1 || icValue.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }

        const deleteModal = document.getElementById('deleteStudentModal');
        const modalMessage = document.getElementById('modalMessage');
        const doubleConfirmContainer = document.getElementById('doubleConfirmContainer');
        const confirmInput = document.getElementById('confirmInput');
        const inputError = document.getElementById('inputError');

        let idToDelete = null;
        let isDeleteAll = false;
        let yearToDelete = "";

        function deleteSingleStudent(element, ic) {
            isDeleteAll = false;
            idToDelete = ic;
            modalMessage.innerText = "Are you sure you want to delete student with IC: " + ic + "?";
            doubleConfirmContainer.style.display = 'none'; 
            inputError.style.display = 'none';
            deleteModal.style.display = 'flex';
        }

        function deleteAllStudents(year) {
            isDeleteAll = true;
            yearToDelete = year;
            modalMessage.innerText = year ? 
                "WARNING: This will inactive ALL Year " + year + " students." : 
                "WARNING: This will inactive EVERY student in the school.";
            
            doubleConfirmContainer.style.display = 'block'; 
            confirmInput.value = "";
            inputError.style.display = 'none';
            deleteModal.style.display = 'flex';
            confirmInput.focus();
        }

        function closeDeleteModal() {
            deleteModal.style.display = 'none';
        }

        function confirmDelete() {
            if (isDeleteAll) {
                if (confirmInput.value !== "DELETE") {
                    inputError.style.display = 'block';
                    confirmInput.style.border = "1px solid red"; 
                    return; 
                }
                var url = "StudentListServlet?action=deleteAll";
                if (yearToDelete && yearToDelete !== "") {
                    url += "&year=" + yearToDelete;
                }
                window.location.href = url;
            } else {
                window.location.href = "StudentListServlet?action=delete&studIC=" + idToDelete;
            }
        }

        window.onclick = function(event) {
            if (event.target == document.getElementById('editStudentModal')) closeEditModal();
            if (event.target == deleteModal) closeDeleteModal();
            if (event.target == document.getElementById('logoutModal')) {
                document.getElementById('logoutModal').style.display = 'none';
            }
        }

        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            const status = urlParams.get('status');
            const toast = document.getElementById("toastNotification");

            if (status) {
                let message = "";
                let type = "";
                if (status === 'success') { message = "✅ Deletion Successful!"; type = "success"; }
                if (status === 'successful') { message = "✅ Promotion Successful!"; type = "successful"; }
                if (status === 'success1') { message = "✅ Edit Successful!"; type = "success1"; }
                if (status === 'successAdd') { message = "✅ New Student Added!"; type = "successAdd"; }
                else if (status === 'fail') { message = "❌ Action Failed."; type = "error"; }

                if (message) {
                    toast.innerText = message;
                    toast.className = "notification-toast " + type; 
                    toast.classList.add("show");
                    setTimeout(function(){ toast.classList.remove("show"); }, 3000);
                    window.history.replaceState({}, document.title, window.location.pathname);
                }
            }
        };

        function promoteAllStudents(year) {
            let msg = year ? "Promote all Year " + year + " students by 1 year?" : "Promote ALL students in the school by 1 year?";
            if (confirm(msg + "\n\nNote: Year 6 students will be marked as INACTIVE.")) {
                let url = "../StudentPromotionServlet?action=promoteAll";
                if (year) url += "&year=" + year;
                window.location.href = url;
            }
        }
        function openEditModal(ic, name, year, className) {
            document.getElementById('editStudIC').value = ic;
            document.getElementById('editICDisplay').value = ic;
            document.getElementById('editName').value = name;
            document.getElementById('editYear').value = year;
            
            filterClassesByYear();
            document.getElementById('editClassName').value = className;

            document.getElementById('editStudentModal').style.display = 'flex';
        }

        function closeEditModal() {
            document.getElementById('editStudentModal').style.display = 'none';
        }
        function filterClassesByYear() {
            const selectedYear = document.getElementById('editYear').value;
            const classSelect = document.getElementById('editClassName');
            const options = classSelect.querySelectorAll('option');

            let firstMatch = "";

            options.forEach(option => {
                const optionYear = option.getAttribute('data-year');
                
                if (!optionYear) {
                    option.style.display = "block";
                    return;
                }

                if (optionYear === selectedYear) {
                    option.style.display = "block";
                    if (firstMatch === "") firstMatch = option.value;
                } else {
                    option.style.display = "none";
                }
            });

            const currentSelection = classSelect.options[classSelect.selectedIndex];
            if (currentSelection.style.display === "none") {
                classSelect.value = ""; 
            }
        }

        document.getElementById('editYear').addEventListener('change', filterClassesByYear);
        
        let promotionYear = "";

        function promoteAllStudents(year) {
            promotionYear = year;
            const msgContainer = document.getElementById('promoteModalMessage');
            
            msgContainer.innerText = year ? 
                "Promote all Year " + year + " students to the next academic level?" : 
                "Promote ALL students in the entire school to the next academic level?";
            
            document.getElementById('promoteStudentModal').style.display = 'flex';
        }

        function closePromoteModal() {
            document.getElementById('promoteStudentModal').style.display = 'none';
        }

        document.getElementById('confirmPromoteBtn').addEventListener('click', function() {
            let url = "../StudentPromotionServlet?action=promoteAll";
            if (promotionYear) {
                url += "&year=" + promotionYear;
            }
            window.location.href = url;
        });

        window.onclick = function(event) {
            if (event.target == document.getElementById('editStudentModal')) closeEditModal();
            if (event.target == document.getElementById('deleteStudentModal')) closeDeleteModal();
            if (event.target == document.getElementById('promoteStudentModal')) closePromoteModal();
            if (event.target == document.getElementById('logoutModal')) {
                document.getElementById('logoutModal').style.display = 'none';
            }
        }
    </script>
</body>
</html>