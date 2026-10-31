<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartschool.dao.UserDAO"%>
<%@ page import="com.smartschool.model.TeacherAssign"%>
<%@ page import="com.smartschool.model.User"%>
<%@ page import="java.util.List"%>
<%@ page import="java.net.URLEncoder"%>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("../choice.html");
        return;
    }

    UserDAO dao = new UserDAO();
    int teacherId = currentUser.getTeacherID();
    
    // 2. Fetch Global System Settings
    String activeExam = dao.getActiveExamType();
    boolean isLocked = "LOCKED".equalsIgnoreCase(activeExam); // Boolean flag for locking logic
    
    List<TeacherAssign> assignments = dao.getTeacherAssignments(teacherId);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart School System - Examination</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/homepage.css"><link rel="icon" type="image/webp" href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">
    <style>
        .assignment-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        .assignment-card {
            background: #e6d7cb;
            padding: 20px;
            border-radius: 15px;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
            border: 1px solid #d6c7bb;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .assignment-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            background-color: #d6c7bb;
        }
        .card-icon { font-size: 2rem; color: #8c8279; }
        .success-msg {
            background: #d4edda; color: #155724; padding: 10px;
            border-radius: 8px; margin-bottom: 20px; border: 1px solid #c3e6cb;
        }
    </style>
</head>
<body>

    <header class="header">
        <div class="header-left">
            <i class="fas fa-bars menu-toggle-icon" id="menu-toggle"></i> 
            <span>Smart School System</span>
        </div>
        <div class="header-right">
            <div class="profile-area" id="profileBtn" style="cursor: pointer;">
                <span class="user-name"><%= currentUser.getName() %></span>
                <img src="../assets/image/adminICON.png" alt="Profile" class="profile-image">
            </div>
            <div class="profile-menu" id="profileMenu" style="display:none;">
                <p onclick="location.href='teacherProfile.jsp'"><i class="fas fa-user"></i> My Profile</p>
                <p id="logoutOption"><i class="fas fa-sign-out-alt"></i> Logout</p>
            </div>
        </div>
    </header>

    <div class="main-container">
        <aside class="sidebar" id="sidebar">
            <ul class="sidebar-menu">
                <li><a href="teacherHomepage.jsp" class="menu-item"><i class="fas fa-home icon"></i> <span class="link-text">Home</span></a></li>
                <li><a href="attendance.jsp" class="menu-item"><i class="fas fa-calendar-check icon"></i> <span class="link-text">Attendance</span></a></li>
                <li><a href="examSelection.jsp" class="menu-item active"><i class="fas fa-file-invoice icon"></i> <span class="link-text">Examination</span></a></li>
                <li><a href="classTeacher.jsp" class="menu-item"><i class="fas fa-school icon"></i> <span class="link-text">Class</span></a></li>            
            </ul>
        </aside>

		<main class="content" style="background: linear-gradient(rgba(255, 255, 255, 0.7), rgba(255, 255, 255, 0.7)), 
             url('<%=request.getContextPath()%>/assets/image/background1.png') no-repeat center center fixed; 
             background-size: cover; min-height: 100vh;">
            
            <div class="breadcrumb">
                Hi, <%= currentUser.getName() %>
                <span class="breadcrumb-separator">&gt;</span> 
                <span class="current-page">Examination</span>
            </div>

            <% if (isLocked) { %>
                <div style="background: #f8d7da; color: #721c24; padding: 12px 20px; border-radius: 10px; border: 1px solid #f5c6cb; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-lock"></i> 
                    <span>The marking session is currently <strong>LOCKED</strong>. Access to entry forms is restricted.</span>
                </div>
                
            <% } else { %>
                <div style="background: #fff3e0; padding: 12px 20px; border-radius: 10px; border: 1px solid #ffe0b2; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-bullhorn" style="color: black;"></i> 
                    <span>Current Active Marking Session: <strong style="color: black; text-transform: uppercase;"><%=activeExam%></strong></span>
                </div>
            <% } %>

            <% if ("1".equals(request.getParameter("success"))) { %>
                <div class="success-msg"><i class="fas fa-check-circle"></i> Marks saved successfully!</div>
            <% } %>

            <div class="assignment-container">
                <% if (assignments == null || assignments.isEmpty()) { %>
                    <div class="no-data" style="text-align: center; margin-top: 50px;">
                        <i class="fas fa-folder-open fa-3x" style="color: #ccc;"></i>
                        <h3>No Assignments Found</h3>
                        <p>Please contact the Admin for subject assignment.</p>
                    </div>
                <% } else { 
                    for (TeacherAssign ta : assignments) { 
                        String encClassName = URLEncoder.encode(ta.getClassName(), "UTF-8");
                        String encSubName = URLEncoder.encode(ta.getSubjectName(), "UTF-8");
                %>
                <div class="assignment-card <%= isLocked ? "locked" : "" %>"
                    <% if (!isLocked) { %>
                        onclick="location.href='examination.jsp?classId=<%=ta.getClassId()%>&subjectId=<%=ta.getSubjectId()%>&className=<%=encClassName%>&subjectName=<%=encSubName%>&academicYear=<%=ta.getAcademicYear()%>'"
                    <% } else { %>
                    <% } %>>
                    
                    <div class="card-icon">
                        <i class="fas <%= isLocked ? "fa-lock" : "fa-book" %>"></i>
                    </div>
                    <div class="card-details">
                        <h3><%=ta.getSubjectName()%></h3>
                        <p>Class: <%=ta.getClassName()%></p>
                    </div>
                </div>
                <% } } %>
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