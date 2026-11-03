<%@ page import="com.smartschool.dao.UserDAO"%>
<%@ page import="com.smartschool.model.Classroom"%>
<%@ page import="com.smartschool.model.Student"%>
<%@ page import="com.smartschool.model.User"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
    com.smartschool.model.User currentUser = (com.smartschool.model.User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("../choice.html.jsp");
        return;
    }

    String classIdStr = request.getParameter("classId");
    String subjectIdStr = request.getParameter("subjectId");
    String className = request.getParameter("className");
    String subjectName = request.getParameter("subjectName");
    String academicYear = request.getParameter("academicYear");

    if (className != null) className = java.net.URLDecoder.decode(className, "UTF-8");
    else className = "N/A";
    
    if (subjectName != null) subjectName = java.net.URLDecoder.decode(subjectName, "UTF-8");
    else subjectName = "N/A";
    
    if (classIdStr == null || subjectIdStr == null) {
        response.sendRedirect("examSelection.jsp");
        return;
    }

    int classId = Integer.parseInt(classIdStr);
    int subjectId = Integer.parseInt(subjectIdStr);

    UserDAO dao = new UserDAO();
    String activeExam = dao.getActiveExamType();
    List<Student> studentList = dao.getStudentsByClass(classId);
    Map<String, Double> existingMarks = dao.getExistingMarks(classId, subjectId, academicYear, activeExam);
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Smart School System - Enter Marks</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="../assets/css/homepage.css">
<link rel="icon" type="image/webp"
	href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">
<style>
.info-bar {
	background: #fdfaf8;
	padding: 15px 25px;
	border-radius: 12px;
	border: 1px solid #e6d7cb;
	margin-bottom: 20px;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.info-item {
	font-weight: bold;
	color: #8c8279;
}

.score-input {
	width: 80px;
	padding: 8px;
	text-align: center;
	border: 1px solid #d0d0d0;
	border-radius: 6px;
	font-weight: bold;
}

.grade-badge {
	display: inline-block;
	padding: 5px 15px;
	border-radius: 20px;
	font-weight: bold;
	background: #eee;
	min-width: 45px;
	text-align: center;
}

.submit-container {
	margin-top: 30px;
	display: flex;
	justify-content: flex-end;
	gap: 10px;
}

.btn-primary {
	background-color: #8c8279;
	color: white;
	padding: 12px 35px;
	border: none;
	border-radius: 25px;
	font-weight: bold;
	cursor: pointer;
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

.floating-note {
	position: fixed;
	bottom: 20px;
	left: 50%;
	transform: translateX(-50%);
	width: 90%;
	max-width: 800px;
	background: #fdfaf8;
	padding: 15px 25px;
	border-radius: 12px;
	border: 1px solid #e6d7cb;
	color: #746260;
	display: flex;
	justify-content: space-between;
	align-items: center;
	gap: 15px;
	box-shadow: 0 -4px 15px rgba(0, 0, 0, 0.1);
	z-index: 1000;
	transition: transform 0.5s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.4s
		ease;
}

.note-content {
	display: flex;
	align-items: center;
	gap: 12px;
}

.close-note-btn {
	background: transparent;
	border: none;
	color: #8c8279;
	font-size: 1.2rem;
	cursor: pointer;
	transition: 0.3s;
	padding: 5px;
	display: flex;
	align-items: center;
	justify-content: center;
}

.close-note-btn:hover {
	color: #ef4444;
	transform: scale(1.1);
}

.note-slide-down {
	transform: translate(-50%, 150%) !important;
	opacity: 0;
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
				<span class="user-name"><%=currentUser.getName()%></span> <img
					src="../assets/image/adminICON.png" alt="Profile Icon"
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
				<li><a href="examSelection.jsp" class="menu-item active"><i
						class="fas fa-file-invoice icon"></i> <span class="link-text">Examination</span></a></li>
				<li><a href="classTeacher.jsp" class="menu-item"><i
						class="fas fa-school icon"></i> <span class="link-text">Class</span></a></li>
			</ul>
		</aside>

		<main class="content"
			style="background: linear-gradient(rgba(255, 255, 255, 0.7), rgba(255, 255, 255, 0.7)), 
             url('<%=request.getContextPath()%>/assets/image/background1.png') no-repeat center center fixed; 
             background-size: cover; min-height: 100vh;">

			<div class="breadcrumb">
				Hi,
				<%= currentUser.getName() %>
				<span class="breadcrumb-separator">&gt;</span> <a
					href="examSelection.jsp"
					style="text-decoration: none; color: inherit;">Examination</a> <span
					class="breadcrumb-separator">&gt;</span> <span class="current-page">Enter
					Marks</span>
			</div>

			<div class="info-bar">
				<div>
					Subject: <span class="info-item"><%= subjectName %></span>
				</div>
				<div>
					Class: <span class="info-item"><%= className %></span>
				</div>
				<div>
					Session: <span class="info-item"
						style="color: #ef4444; text-transform: uppercase;"><%= activeExam %></span>
				</div>
				<div>
					Year: <span class="info-item"><%= academicYear %></span>
				</div>
			</div>

			<form action="../ExamServlet" method="POST" id="examForm">
				<input type="hidden" name="classId" value="<%= classId %>">
				<input type="hidden" name="subjectId" value="<%= subjectId %>">
				<input type="hidden" name="academicYear" value="<%= academicYear %>">
				<input type="hidden" name="examType" value="<%= activeExam %>">

				<div class="table-box">
					<table class="data-table">
						<thead>
							<tr>
								<th style="width: 60px;">No.</th>
								<th>Student Name</th>
								<th style="width: 150px; text-align: center;">Score (0-100)</th>
								<th style="width: 150px; text-align: center;">Grade</th>
							</tr>
						</thead>
						<tbody>
							<% if (studentList != null) {
                                for (int i = 0; i < studentList.size(); i++) {
                                    Student s = studentList.get(i); 
                                    Double existingMark = existingMarks.get(s.getStudIC());
                                    String markVal = (existingMark != null) ? String.format("%.0f", existingMark) : "";
                                    
                                    // Initial Grade Calculation
                                    String initialGrade = "-";
                                    if (existingMark != null) {
                                        if (existingMark >= 80) initialGrade = "A";
                                        else if (existingMark >= 70) initialGrade = "B";
                                        else if (existingMark >= 60) initialGrade = "C";
                                        else if (existingMark >= 40) initialGrade = "D";
                                        else initialGrade = "E";
                                    }
                            %>
							<tr>
								<td><%= i + 1 %></td>
								<td><%= s.getStudName() %></td>
								<input type="hidden" name="StudIC" value="<%= s.getStudIC() %>">
								<td style="text-align: center;"><input type="number"
									name="marks" class="score-input" min="0" max="100"
									placeholder="0" required value="<%= markVal %>"
									onkeypress="return (event.charCode >= 48 && event.charCode <= 57)">
								</td>
								<td style="text-align: center;"><span class="grade-badge"><%= initialGrade %></span>
									<input type="hidden" name="grades" class="grade-input"
									value="<%= initialGrade %>"></td>
							</tr>
							<% } } %>
						</tbody>
						<div id="tableErrorMessage"
							style="color: #dc3545; font-weight: bold; margin-top: 15px; display: none; padding: 10px; background-color: #f8d7da; border-radius: 8px; border: 1px solid #f5c6cb; text-align: center;">
							<i class="fas fa-exclamation-circle"></i> <span id="errorText"></span>
						</div>
					</table>
				</div>

				<div class="submit-container">
					<button type="button" class="btn-second"
						onclick="location.href='examSelection.jsp'">Back</button>
					<button type="button" class="btn-primary"
						onclick="showSubmitModal()">Submit Marks</button>
				</div>
			</form>
		</main>
	</div>

	<div id="floatingNote" class="info-note floating-note">
		<div class="note-content">
			<i class="fas fa-info-circle"></i> <span><strong>Note:</strong>
				If you have already submitted records for this class, simply fill in
				the details and submit again to <strong>update</strong> the existing
				records.</span>
		</div>
		<button type="button" class="close-note-btn" onclick="closeNote()">
			<i class="fas fa-times"></i>
		</button>
	</div>

	<div id="confirmSubmitModal" class="modal-overlay">
		<div class="modal-box">
			<h3>Confirm Submission</h3>
			<p>Are you sure you want to save the exam mark for this student?</p>
			<div class="modal-buttons">
				<button type="button" onclick="hideModal()"
					class="modal-btn btn-cancel">CANCEL</button>
				<button type="button" onclick="processSubmit()"
					class="modal-btn btn-reject" style="background-color: #8c8279;">CONFIRM</button>
			</div>
		</div>
	</div>

	<div id="successSubmitModal" class="modal-overlay">
		<div class="modal-box">
			<div style="font-size: 3rem; color: #28a745; margin-bottom: 10px;">✓</div>
			<h3>Marks Saved Successfully!</h3>
		</div>
	</div>

	<div id="logoutModal" class="modal-overlay">
		<div class="modal-box">
			<h3>Confirm Logout</h3>
			<p>Do you want to logout?</p>
			<div class="modal-buttons">
				<button type="button" class="modal-btn btn-cancel" id="cancelLogout">Cancel</button>
				<button type="button" class="modal-btn btn-reject"
					id="confirmLogout">Logout</button>
			</div>
		</div>
	</div>

	<script>
    document.querySelectorAll('.score-input').forEach(input => {
        input.addEventListener('input', function () {
            const row = this.closest('tr');
            const gradeBadge = row.querySelector('.grade-badge');
            const gradeInput = row.querySelector('.grade-input');
            const score = parseFloat(this.value);
            let grade = "-";
            if (!isNaN(score)) {
                if (score >= 80) grade = "A";
                else if (score >= 70) grade = "B";
                else if (score >= 60) grade = "C";
                else if (score >= 40) grade = "D";
                else grade = "E";
            }
            gradeBadge.innerText = grade;
            gradeInput.value = grade; 
        });
    });

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

    document.addEventListener('click', () => profileMenu.style.display = 'none');

    const logoutOption = document.getElementById('logoutOption');
    const logoutModal = document.getElementById('logoutModal');
    const cancelLogout = document.getElementById('cancelLogout');
    
    logoutOption.addEventListener('click', () => logoutModal.style.display = 'flex');
    cancelLogout.addEventListener('click', () => logoutModal.style.display = 'none');
    document.getElementById('confirmLogout').addEventListener('click', () => {
        window.location.href = '../choice.html';
    });
    
    const confirmModal = document.getElementById('confirmSubmitModal');
    const successModal = document.getElementById('successSubmitModal');

    function showSubmitModal() {
        confirmModal.style.display = 'flex';
    }

    function hideModal() {
        confirmModal.style.display = 'none';
    }

    function processSubmit() {
        const scoreInputs = document.querySelectorAll('.score-input');
        let isValid = true;
        let errorMessage = "";

        scoreInputs.forEach((input, index) => {
            const score = input.value.trim();
            const studentName = input.closest('tr').cells[1].innerText;

            if (score === "") {
                isValid = false;
                errorMessage = `Error: Score for ${studentName} is empty.`;
                input.style.borderColor = "red";
            } 
            else if (parseFloat(score) < 0 || parseFloat(score) > 100) {
                isValid = false;
                errorMessage = `Error: Score for ${studentName} must be between 0 and 100.`;
                input.style.borderColor = "red";
            } else {
                input.style.borderColor = "#d0d0d0";
            }
        });

        if (!isValid) {
            const errorDiv = document.getElementById('tableErrorMessage');
            document.getElementById('errorText').innerText = errorMessage;
            errorDiv.style.display = "block";
            
            hideModal();
            return;
        }

        confirmModal.style.display = 'none';
        document.getElementById('examForm').submit();
    }

	window.onload = function() {
    	const urlParams = new URLSearchParams(window.location.search);
    
    	if (urlParams.get('success') === '1') {
        	const successModal = document.getElementById('successSubmitModal');
        
        	successModal.style.display = 'flex';
        
        	setTimeout(() => {
            	successModal.style.display = 'none';
            	window.location.href = 'examSelection.jsp';
        	}, 2000); 
    	}
	}
	function closeNote() {
	    const note = document.getElementById('floatingNote');
	    note.classList.add('note-slide-down');
	    
	    setTimeout(() => {
	        note.style.display = 'none';
	    }, 500);
	}
</script>
</body>
</html>