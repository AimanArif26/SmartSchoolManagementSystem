<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartschool.model.Guardian"%>
<%@ page import="com.smartschool.model.Student"%>

<%
    // 1. Session and Data Validation
    Guardian guardian = (Guardian) session.getAttribute("guardian");
    Student student = (Student) request.getAttribute("studentDetails");

    if (guardian == null) {
        response.sendRedirect("guardianLogin.jsp");
        return;
    }
    
    // Safety check in case studentDetails is null
    if (student == null) {
        response.sendRedirect(request.getContextPath() + "/guardian/guardianHomepage.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Smart School System - Student Profile</title>
	<link rel="icon" type="image/webp" href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/validate.css" />

    <style>
        html, body {
            height: auto;
            overflow-y: auto;
            background-color: #f8f9fa;
            margin: 0;
        }

        .main-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 40px 20px;
            min-height: calc(100vh - 70px);
            height: auto;
        }

        .content-wrapper {
            width: 100%;
            max-width: 1000px;
        }

        .profile-banner {
            background: #ffffff;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            margin-bottom: 30px;
            text-align: center;
            border: 1px solid #eee;
        }

        .student-title {
            font-size: 1.5rem;
            font-weight: 800;
            color: #5a4a42;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            width: 100%;
        }

        .dashboard-card {
            background: white;
            padding: 40px 20px;
            border-radius: 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 1px solid #eee;
            box-shadow: 0 6px 15px rgba(0,0,0,0.03);
        }

        .dashboard-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 25px rgba(0,0,0,0.08);
            border-color: #e7d6c8;
        }

        .dashboard-card i {
            font-size: 45px;
            color: #8c8279;
            margin-bottom: 20px;
        }

        .dashboard-card p {
            font-weight: 700;
            color: #444;
            margin: 0;
            font-size: 1.1rem;
        }

        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.5);
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        .logout-modal {
            background: white;
            padding: 35px;
            border-radius: 25px;
            width: 400px;
            text-align: center;
            box-shadow: 0 20px 50px rgba(0,0,0,0.2);
        }

        .modal-buttons {
            display: flex;
            gap: 15px;
            margin-top: 25px;
        }

        .btn-modal {
            flex: 1;
            padding: 12px;
            border-radius: 50px;
            font-weight: bold;
            border: none;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-cancel { background: #f0f0f0; color: #555; }
        .btn-logout { background: #8c8279; color: white; }
    </style>
</head>

<body>

    <header class="header">
        <div class="header-left">
            <i style="cursor:pointer; margin-right:15px;"></i>
            <span>Smart School System</span>
        </div>

        <div class="header-right">
            <div class="profile-area" id="profileBtn" style="cursor:pointer;">
                <span class="user-name">Guardian</span> 
                <img src="${pageContext.request.contextPath}/assets/image/adminICON.png" class="profile-image" />
            </div>

			<div class="profile-menu" id="profileMenu">
				<p id="logoutOption">
					<i class="fas fa-sign-out-alt"></i> Logout
				</p>
			</div>
		</div>
    </header>

    <div class="main-container" style="background: linear-gradient(rgba(255, 255, 255, 0.7), rgba(255, 255, 255, 0.7)), 
             url('<%=request.getContextPath()%>/assets/image/background2.jpg') no-repeat center center fixed; 
             background-size: cover; min-height: 120vh;">
        <div class="content-wrapper">
            <div class="profile-banner">
                <div class="student-title">
                    <i class="fas fa-user-graduate" style="margin-right: 10px;"></i>
                    <%= student.getStudName().toUpperCase() %>
                </div>
            </div>

            <% String sid = student.getStudIC(); %>

            <div class="card-grid">
                <div class="dashboard-card" onclick="location.href='${pageContext.request.contextPath}/editStudentProfile?id=<%=sid%>'">
                    <i class="fas fa-id-card"></i>
                    <p>Student Profile</p>
                </div>

                <div class="dashboard-card" onclick="location.href='${pageContext.request.contextPath}/GuardianExaminationServlet?id=<%=sid%>'">
                    <i class="fas fa-chart-line"></i>
                    <p>Academic Results</p>
                </div>

				<div class="dashboard-card"
					onclick="location.href='${pageContext.request.contextPath}/GuardianAttendanceServlet?id=<%=sid%>'">
					<i class="fas fa-calendar-check"></i>
					<p>Attendance Record</p>
				</div>
			</div>
			 <div style="margin-top: 30px; display: flex; justify-content: flex-end">
                <a href="guardian/guardianHomepage.jsp" class="btn-back" style="text-decoration:none; background:#333; color:white; padding:10px 30px; border-radius:25px; font-weight:bold;">
                    Back
                </a>
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

    profileBtn.addEventListener("click", (e) => {
        e.stopPropagation(); 
        profileMenu.style.display = (profileMenu.style.display === "block") ? "none" : "block";
    });

    document.addEventListener("click", () => {
        profileMenu.style.display = "none";
    });

    const logoutOption = document.getElementById('logoutOption');
    const logoutModal = document.getElementById('logoutModal');
    const cancelLogout = document.getElementById('cancelLogout');
    const confirmLogout = document.getElementById('confirmLogout');

    if (logoutOption) {
        logoutOption.addEventListener('click', (e) => {
            e.preventDefault();
            logoutModal.style.display = 'flex';
        });
    }

    if (cancelLogout) {
        cancelLogout.addEventListener('click', () => {
            logoutModal.style.display = 'none';
        });
    }

    if (confirmLogout) {
        confirmLogout.addEventListener('click', () => {
            window.location.href = '${pageContext.request.contextPath}/choice.html';
        });
    }
</script>

</body>
</html>