<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartschool.model.Guardian"%>
<%@ page import="com.smartschool.model.Student"%>
<%@ page import="java.util.List"%>
<%@ page import="com.smartschool.dao.UserDAO"%>

<%
    // 1. Session Validation
    Guardian guardian = (Guardian) session.getAttribute("guardian");
    if (guardian == null) {
        response.sendRedirect(request.getContextPath() + "/guardian/guardianLogin.jsp");
        return;
    }

    // 2. Data Retrieval
    UserDAO dao = new UserDAO();
    // Ensure your DAO JOINs with CLASSROOM to get ClassName and Year
    List<Student> studentList = dao.getStudentsByGuardian(guardian.getGuardianID());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart School System - Guardian Dashboard</title>
	<link rel="icon" type="image/webp" href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/validate.css" />

    <style>
        body {
            background-color: #f8f9fa; 
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .main-container {
            padding: 40px 20px;
            display: flex;
            flex-direction: column;
            align-items: center; 
            height: auto; 
    		overflow: visible;
        }

        .content-wrapper {
            width: 100%;
            max-width: 1200px;
        }

        .dashboard-header {
            margin-bottom: 30px;
        }

        .breadcrumb {
            font-size: 0.9rem;
            color: #8c8279;
            margin-bottom: 10px;
        }

        .current-page {
            font-weight: bold;
            color: #333;
        }

        .student-card-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
            margin-top: 20px;
        }

        .student-card {
            background: #ffffff;
            border-radius: 20px;
            padding: 35px 20px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
            border: 1px solid #eee;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .student-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
        }

        .student-photo {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: #f0f0f0;
            padding: 10px;
            margin-bottom: 20px;
            object-fit: contain;
        }

        .student-name {
            font-size: 1.2rem;
            font-weight: 700;
            color: #444;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .student-meta {
            margin-bottom: 25px;
        }

        .tag {
            display: inline-block;
            background: #fdfaf8;
            color: #8c8279;
            padding: 5px 12px;
            border-radius: 12px;
            font-size: 0.85rem;
            font-weight: 600;
            border: 1px solid #e7d6c8;
            margin: 2px;
        }

        .see-more-btn {
            background-color: #8c8279;
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
            text-transform: uppercase;
            font-size: 0.85rem;
            width: 80%;
        }

        .see-more-btn:hover {
            background-color: #746260;
        }

        .empty-state {
            text-align: center;
            padding: 50px;
            color: #999;
            grid-column: 1 / -1;
        }
        #preloader {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background-color: #fcfbf9;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            transition: opacity 0.5s ease-out, visibility 0.5s;
        }

        .loader-logo {
            width: 100px;
            margin-bottom: 25px;
            animation: breathe 2s infinite ease-in-out;
            filter: drop-shadow(0 5px 15px rgba(90, 74, 66, 0.2));
        }

        .loader-ring {
            width: 45px; height: 45px;
            border: 3px solid rgba(90, 74, 66, 0.15);
            border-top: 3px solid #5a4a42;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin { 100% { transform: rotate(360deg); } }
        @keyframes breathe { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.05); } }
    </style>
</head>

<body>
	<div id="preloader">
		<img src="../assets/image/sksmLOGO.webp" alt="Loading..."
			class="loader-logo">
		<div class="loader-ring"></div>
	</div>
	<header class="header">
        <div class="header-left">
            <i style="margin-right: 10px;"></i>
            <span>Smart School System</span>
        </div>

        <div class="header-right">
            <div class="profile-area" id="profileBtn" style="cursor: pointer;">
                <span class="user-name">Guardian</span> 
                <img src="${pageContext.request.contextPath}/assets/image/adminICON.png" class="profile-image" />
            </div>

            <div class="profile-menu" id="profileMenu" style="display: none;">
                <p id="logoutOption" style="cursor: pointer;">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </p>
            </div>
        </div>
    </header>

    <div class="main-container" style="background: linear-gradient(rgba(255, 255, 255, 0.7), rgba(255, 255, 255, 0.7)), 
             url('<%=request.getContextPath()%>/assets/image/background2.jpg') no-repeat center center fixed; 
             background-size: cover; min-height: 120vh;">
    
        <div class="content-wrapper">
            <div class="student-card-container">
                <%
                if (studentList != null && !studentList.isEmpty()) {
                    for (Student s : studentList) {
                %>
                <div class="student-card">
                    <img src="${pageContext.request.contextPath}/assets/image/adminICON.png" class="student-photo" />

                    <div class="student-name"><%= s.getStudName() %></div>
                    
                    <div class="student-meta">
                        <span class="tag">Year <%= s.getStudYear() %></span>
                    </div>

                    <button class="see-more-btn"
                        onclick="location.href='${pageContext.request.contextPath}/StudentProfileServlet?id=<%= s.getStudIC() %>'">
                        SEE PROFILE
                    </button>
                </div>
                <%
                    }
                } else {
                %>
                <div class="empty-state">
                    <i class="fas fa-users-slash fa-4x" style="margin-bottom: 20px; opacity: 0.3;"></i>
                    <h3>No students linked.</h3>
                    <p>Please contact the school admin to link your children to this account.</p>
                </div>
                <%
                }
                %>
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
        const profileBtn = document.getElementById("profileBtn");
        const profileMenu = document.getElementById("profileMenu");

        profileBtn.onclick = (e) => {
            e.stopPropagation();
            profileMenu.style.display = profileMenu.style.display === "block" ? "none" : "block";
        };

        window.onclick = () => {
            profileMenu.style.display = "none";
        };

        const logoutOption = document.getElementById('logoutOption');
        const logoutModal = document.getElementById('logoutModal');
        const cancelLogout = document.getElementById('cancelLogout');
        const confirmLogout = document.getElementById('confirmLogout');

        logoutOption.addEventListener('click', () => logoutModal.style.display = 'flex');
        cancelLogout.addEventListener('click', () => logoutModal.style.display = 'none');
        confirmLogout.addEventListener('click', () => window.location.href = '../choice.html');
        window.addEventListener('load', () => {
            const loader = document.getElementById('preloader');
            setTimeout(() => {
                loader.style.opacity = '0'; 
                setTimeout(() => {
                    loader.style.visibility = 'hidden'; 
                }, 800); 
            }, 1500); 
        });
    </script>

</body>
</html>