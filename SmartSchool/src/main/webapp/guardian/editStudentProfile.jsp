<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartschool.model.Guardian"%>
<%@ page import="com.smartschool.model.Student"%>

<%
    Guardian guardian = (Guardian) session.getAttribute("guardian");
    Student student = (Student) request.getAttribute("student");

    if (guardian == null || student == null) {
        response.sendRedirect(request.getContextPath() + "/guardian/guardianLogin.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart School System - Student Information</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/homepage.css">
	<link rel="icon" type="image/webp" href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">
    <style>
/* SCROLL & LAYOUT FIX */
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
	min-height: 100vh;
}

.content-wrapper {
	width: 100%;
	max-width: 1100px;
}

/* PROFILE GRID */
.profile-grid {
	display: grid;
	grid-template-columns: 320px 1fr;
	gap: 30px;
}

@media ( max-width : 768px) {
	.profile-grid {
		grid-template-columns: 1fr;
	}
}

.profile-card-left {
	background: white;
	padding: 40px 20px;
	border-radius: 20px;
	text-align: center;
	border: 1px solid #e6d7cb;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
	height: fit-content;
}

.profile-details-right {
	background: white;
	padding: 40px;
	border-radius: 20px;
	border: 1px solid #e6d7cb;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
}

.info-row {
	display: grid;
	grid-template-columns: 200px 1fr;
	padding: 18px 0;
	border-bottom: 1px solid #f5f5f5;
}

.label {
	font-weight: 700;
	color: #8c8279;
	text-transform: uppercase;
	font-size: 0.75rem;
	letter-spacing: 0.5px;
}

.value {
	font-size: 1rem;
	color: #333;
}

.btn-edit {
	background-color: #8c8279;
	color: white;
	padding: 12px 30px;
	border: none;
	border-radius: 25px;
	cursor: pointer;
	font-weight: bold;
	transition: 0.3s;
}

.btn-edit:hover {
	background-color: #746260;
}

/* MODAL FIXES */
.modal-overlay {
	position: fixed;
	inset: 0;
	background: rgba(0, 0, 0, 0.5);
	display: none;
	align-items: center;
	justify-content: center;
	z-index: 2000;
}

.modal-box {
  background-color: #e6d7cb;
  padding: 30px;
  border-radius: 15px;
  width: 350px;
  text-align: center;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
  animation: fadeIn 0.3s;
}

.form-control {
	width: 100%;
	padding: 12px;
	border-radius: 8px;
	border: 1px solid #ddd;
	margin-top: 8px;
	box-sizing: border-box;
}

.btn-back {
	background-color: #333;
	/* Dark grey to contrast with the 'Update' button */
	color: white;
	padding: 12px 30px;
	border-radius: 25px;
	font-weight: bold;
	display: inline-block;
	transition: background 0.3s ease;
	font-size: 0.85rem;
}

.btn-back:hover {
	background-color: #555;
	color: white;
}
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
                <img src="<%=request.getContextPath()%>/assets/image/adminICON.png" class="profile-image" />
            </div>
            <div class="profile-menu" id="profileMenu" style="display:none;">
                <p id="logoutOption" style="cursor:pointer;"><i class="fas fa-sign-out-alt"></i> Logout</p>
            </div>
        </div>
    </header>

     <div class="main-container" style="background: linear-gradient(rgba(255, 255, 255, 0.7), rgba(255, 255, 255, 0.7)), 
             url('<%=request.getContextPath()%>/assets/image/background2.jpg') no-repeat center center fixed; 
             background-size: cover; min-height: 120vh;">
        <div class="content-wrapper">
			<div class="profile-grid">
				<div class="profile-card-left">
					<img src="<%=request.getContextPath()%>/assets/image/adminICON.png"
						style="width: 120px; border-radius: 50%; margin-bottom: 20px; border: 4px solid #fdfaf8;">
					<h2 style="color: #5a4a42; margin: 10px 0;"><%=student.getStudName()%></h2>
					<p style="color: #8c8279; font-weight: 600;">
						Year
						<%=student.getStudYear()%></p>
				</div>

				<div class="profile-details-right">
					<h3
						style="margin-top: 0; color: #5a4a42; border-bottom: 2px solid #fdfaf8; padding-bottom: 10px;">Student
						Profile</h3>

					<div class="info-row">
						<div class="label">Student IC</div>
						<div class="value"><%=student.getStudIC()%></div>
					</div>
					<div class="info-row">
						<div class="label">Gender</div>
						<div class="value"><%=student.getStudGender() != null ? student.getStudGender() : "-"%></div>
					</div>
					<div class="info-row">
						<div class="label">Date of Birth</div>
						<div class="value"><%=student.getDateOfBirth() != null ? student.getDateOfBirth() : "-"%></div>
					</div>
					<div class="info-row">
						<div class="label">Current Class</div>
						<div class="value"><%=student.getClassName() != null ? student.getClassName() : "Unassigned"%></div>
					</div>

					<div class="info-row" style="border-bottom: none;">
						<div class="label">Home Address</div>
						<div class="value">
							<%=student.getAddress() != null ? student.getAddress() : "No address recorded."%>
							<div
								style="margin-top: 25px; display: flex; justify-content: flex-end; gap: 10px;">
								<a
									href="<%=request.getContextPath()%>/StudentProfileServlet?id=<%=student.getStudIC()%>"
									class="btn-back" style="text-decoration: none;"> Back </a>
								<button class="btn-edit" type="button" onclick="openEditModal()">
									Update Profile</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
    </div>

    <div id="editStudentModal" class="modal-overlay">
        <div class="modal-box">
            <form method="post" action="<%=request.getContextPath()%>/editStudentProfile">
                <h3 style="color: #5a4a42; margin-top: 0;">Update Profile</h3>
                <p style="font-size: 0.9rem; color: #666;">Please provide the latest residential address.</p>
                
                <input type="hidden" name="studIC" value="<%=student.getStudIC()%>">

                <div style="margin-bottom: 25px;">
                    <label class="label">Full Address</label>
                    <textarea name="address" class="form-control" rows="4" required><%=student.getAddress() != null ? student.getAddress() : ""%></textarea>
                </div>

                <div class="modal-buttons">
                    <button type="button" class="modal-btn btn-cancel" onclick="closeEditModal()">Cancel</button>
                    <button type="submit" class="modal-btn btn-approve" style="background-color: #8c8279; color:white;">Confirm</button>
                </div>
            </form>
        </div>
    </div>
	<div id="successSubmitModal" class="modal-overlay">
		<div class="modal-box">
			<div style="font-size: 3rem; color: #28a745; margin-bottom: 10px;">✓</div>
			<h3 id="successMessage">Profile Updated Successfully!</h3>
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
    // --- Existing Profile Dropdown & Modal Logic ---
    const profileBtn = document.getElementById("profileBtn");
    const profileMenu = document.getElementById("profileMenu");
    
    profileBtn.onclick = (e) => {
        e.stopPropagation();
        profileMenu.style.display = profileMenu.style.display === "block" ? "none" : "block";
    };
    
    document.addEventListener("click", () => profileMenu.style.display = "none");

    const editModal = document.getElementById("editStudentModal");
    function openEditModal() { editModal.style.display = "flex"; }
    function closeEditModal() { editModal.style.display = "none"; }

    // --- SUCCESS POPUP LOGIC (Copied from Teacher Profile) ---
    window.onload = function() {
        const urlParams = new URLSearchParams(window.location.search);
        
        if (urlParams.get('success') === '1') {
            const successModal = document.getElementById('successSubmitModal');
            if(successModal) {
                successModal.style.display = 'flex';
                                setTimeout(() => {
                    successModal.style.display = 'none';
                    const cleanUrl = window.location.pathname + "?id=" + urlParams.get('id');
                    window.history.replaceState({}, document.title, cleanUrl);
                }, 2500);
            }
        }
    }

    // --- Logout Logic ---
    document.getElementById("logoutOption").onclick = () => {
        document.getElementById("logoutModal").style.display = "flex";
    };
    document.getElementById("cancelLogout").onclick = () => {
        document.getElementById("logoutModal").style.display = "none";
    };
    document.getElementById("confirmLogout").onclick = () => {
        window.location.href = "<%=request.getContextPath()%>/choice.html";
    };
</script>
</body>
</html>