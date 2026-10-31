<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.smartschool.model.Classroom"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Smart School System - Add Student</title>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/studentList.css">
	<link rel="icon" type="image/webp" href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">

<style>
/* Local specific styles for the Form */
.form-container {
	width: 60%; /* Slightly wider for better look */
	margin: 0 auto; /* Center horizontally */
	padding: 40px;
	background: #fff;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15); /* Match Card shadow */
	border-radius: 15px;
	border: 1px solid #e5e7eb;
}

.form-group {
	margin-bottom: 20px;
}

.form-group label {
	display: block;
	margin-bottom: 8px;
	font-weight: 600;
	color: #5a4a42; /* Theme Color */
}

.form-control {
	width: 100%;
	padding: 12px;
	border: 1px solid #d4c4b7; /* Theme Border */
	border-radius: 8px;
	font-size: 14px;
}

/* Buttons */
.form-actions {
	margin-top: 30px;
	display: flex;
	gap: 15px;
	justify-content: flex-end; /* Buttons to right */
}

.btn-submit {
	background-color: #5a4a42; /* Theme Brown */
	color: white;
	border: none;
	padding: 12px 30px;
	cursor: pointer;
	border-radius: 50px;
	font-weight: bold;
	transition: 0.3s;
}

.btn-submit:hover {
	background-color: #3e322c;
	transform: translateY(-2px);
}

.btn-cancel {
	background-color: black;
	color: white;
	text-decoration: none;
	padding: 12px 30px;
	border-radius: 30px;
	font-weight: bold;
	display: inline-block;
	transition: 0.3s;
}

.btn-cancel:hover {
	background-color: #bbb;
	transform: translateY(-2px);
}
.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.6); /* Darker background */
    display: none; 
    justify-content: center;
    align-items: center;
    z-index: 2000;
}

.modal-box {
    background: #e6d7cb;
    padding: 30px;
    border-radius: 15px;
    text-align: center;
    width: 420px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.3);
}

.modal-buttons {
    display: flex;
    justify-content: center;
    gap: 15px;
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
				<li><a href="student.jsp" class="menu-item active"><i
						class="fas fa-user-graduate icon"></i> <span class="link-text">Student</span></a></li>
				<li><a href="validateTeacher.jsp" class="menu-item"><i
						class="fas fa-user-check icon"></i> <span class="link-text">Validate</span></a></li>
				<li><a href="teacherList.jsp" class="menu-item"><i
						class="fas fa-users-rectangle icon"></i> <span class="link-text">Teacher
							List</span></a></li>
				<li><a href="assignment.jsp" class="menu-item"><i
						class="fas fa-tasks icon"></i> <span class="link-text">Assignment</span></a></li>
				<li><a href="adminSettings.jsp" class="menu-item"><i
						class="fas fa-cog icon"></i> <span class="link-text">Settings</span></a></li>
			</ul>
		</aside>

		<main class="content">
			<div class="breadcrumb">
				<a href="student.jsp" style="text-decoration: none; color: inherit;">Student
					List</a> <span class="breadcrumb-separator">&gt;</span> <span
					class="current-page">Add New Student</span>
			</div>

			<div class="form-container">
				<h2
					style="margin-bottom: 25px; color: #5a4a42; border-bottom: 2px solid #f2e6d9; padding-bottom: 10px;">Register
					New Student</h2>

				<form action="StudentListServlet" method="post"
					onsubmit="return validateForm()">
					<input type="hidden" name="action" value="add">

					<div class="form-group">
						<label>Full Name</label> <input type="text" name="studName"
							required class="form-control">
					</div>

					<div class="form-group">
						<label>IC Number</label> <input type="text" name="studIC"
							id="studIC" placeholder="e.g. 123456011234" required
							onkeyup="extractDateFromIC()" maxlength="12"
							oninput="this.value = this.value.replace(/[^0-9]/g, '')"
							class="form-control">
					</div>

					<div class="form-group">
						<label>Gender</label> <select name="gender" class="form-control">
							<option value="Male">Male</option>
							<option value="Female">Female</option>
						</select>
					</div>

					<div class="form-group">
						<label>Date of Birth</label> <input type="date" name="dob"
							id="dob" required class="form-control">
					</div>

					<div class="form-group">
						<label>Address</label> <input type="text" name="address" required
							class="form-control">
					</div>

					<div class="form-group">
						<label>Guardian IC</label> <input type="text" name="guardianIC"
							id="guardianIC" placeholder="e.g. 123456011234" maxlength="12"
							required class="form-control"
							oninput="this.value = this.value.replace(/[^0-9]/g, '')">
					</div>

					<div class="form-group">
						<label>Year</label> <select name="studYear" id="yearSelect"
							onchange="filterClassDropdown()" required class="form-control">
							<option value="">-- Select Level --</option>
							<option value="1">Year 1</option>
							<option value="2">Year 2</option>
							<option value="3">Year 3</option>
							<option value="4">Year 4</option>
							<option value="5">Year 5</option>
							<option value="6">Year 6</option>
						</select>
					</div>

					<div class="form-group">
						<label>Class</label> <select name="classId" id="classSelect"
							required class="form-control">
							<option value="">-- Select Class --</option>
							<% 
                                List<Classroom> list = (List<Classroom>) request.getAttribute("classList");
                                if (list != null) {
                                    for (Classroom c : list) {
                            %>
							<option value="<%= c.getClassID() %>"
								data-level="<%= c.getClassYear() %>">
								<%= c.getClassName() %>
							</option>
							<% 
                                    } 
                                } 
                            %>
						</select>
					</div>

					<div class="form-actions">
						<a href="student.jsp" class="btn-cancel">Back</a>
						<button type="submit" class="btn-submit">Add Student</button>
					</div>
				</form>
			</div>
		</main>
	</div>
	<div id="confirmAddModal" class="modal-overlay" style="display: none;">
		<div class="modal-box">
			<h3 style="color: black; margin-bottom: 15px;">Confirm Student
				Registration</h3>
			<p>Are you sure you want to register this new student into the
				system?</p>
			<div class="modal-buttons" style="margin-top: 25px;">
				<button class="modal-btn btn-cancel" style="background-color: #ccc; color: black;"
					onclick="closeConfirmAddModal()">Cancel</button>
				<button class="modal-btn" id="finalSubmitBtn"
					style="background-color: #5a4a42; color: white; padding: 10px 25px; border-radius: 50px; border: none; font-weight: bold; cursor: pointer;">
					Confirm</button>
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
// Sidebar Toggle
const menuToggle = document.getElementById('menu-toggle');
const sidebar = document.getElementById('sidebar');
menuToggle.addEventListener('click', () => {
    sidebar.classList.toggle('collapsed');
});

// Profile Menu Toggle
const profileBtn = document.getElementById('profileBtn');
const profileMenu = document.getElementById('profileMenu');
profileBtn.addEventListener('click', (e) => {
    e.stopPropagation();
    profileMenu.style.display = profileMenu.style.display === 'block' ? 'none' : 'block';
});

// Close dropdown on outside click
window.addEventListener('click', () => {
    profileMenu.style.display = 'none';
});

// Logout Modal Logic
const logoutOption = document.getElementById('logoutOption');
const logoutModal = document.getElementById('logoutModal');
const cancelLogout = document.getElementById('cancelLogout');
const confirmLogout = document.getElementById('confirmLogout');

logoutOption.addEventListener('click', () => logoutModal.style.display = 'flex');
cancelLogout.addEventListener('click', () => logoutModal.style.display = 'none');
confirmLogout.addEventListener('click', () => window.location.href = '../LogoutServlet');

    
    // Filter Classes by Year
    function filterClassDropdown() {
        var yearSelect = document.getElementById("yearSelect");
        var selectedLevel = yearSelect.value;
        var classSelect = document.getElementById("classSelect");
        var options = classSelect.getElementsByTagName("option");

        classSelect.value = ""; // Reset selection

        for (var i = 0; i < options.length; i++) {
            var option = options[i];
            var classLevel = option.getAttribute("data-level");

            if (!classLevel) continue; 

            if (selectedLevel === "" || classLevel === selectedLevel) {
                option.style.display = "block";
                option.disabled = false; 
            } else {
                option.style.display = "none";
                option.disabled = true;  
            }
        }
    }

    // Auto-fill Date of Birth
    function extractDateFromIC() {
        var icInput = document.getElementById("studIC");
        var dobInput = document.getElementById("dob");

        if (!icInput || !dobInput) return;

        var val = icInput.value;
        var cleanIC = val.replace(/[^0-9]/g, '');
        if (cleanIC.length >= 6) {
            var yy = cleanIC.substring(0, 2);
            var mm = cleanIC.substring(2, 4);
            var dd = cleanIC.substring(4, 6);

            var prefix = (parseInt(yy) > 30) ? "19" : "20";
            var fullYear = prefix + yy;
            var dobValue = fullYear + "-" + mm + "-" + dd;
            
            if (mm > 0 && mm <= 12 && dd > 0 && dd <= 31) {
                dobInput.value = dobValue;
            }
        }
    }

    // Validate Helper
    function validateIC(icNumber, ownerName) {
        var cleanIC = icNumber.replace(/[^0-9]/g, '');
        if (cleanIC.length < 12) {
            alert("Invalid " + ownerName + " IC: Too short (Must be 12 digits).");
            return false;
        }

        var mm = parseInt(cleanIC.substring(2, 4));
        var dd = parseInt(cleanIC.substring(4, 6));

        if (mm < 1 || mm > 12) {
            alert("Invalid " + ownerName + " IC: Month " + mm + " does not exist.");
            return false;
        }

        var maxDays = 31;
        if (mm == 4 || mm == 6 || mm == 9 || mm == 11) maxDays = 30;
        if (mm == 2) maxDays = 29; 

        if (dd < 1 || dd > maxDays) {
            alert("Invalid " + ownerName + " IC: Day " + dd + " is invalid for Month " + mm + ".");
            return false;
        }

        return true;
    }

 // --- ADD STUDENT MODAL LOGIC ---

    function validateForm() {
        // 1. Run your existing IC validations first
        var studIC = document.getElementById("studIC").value;
        if (!validateIC(studIC, "Student")) return false;

        var guardianICInput = document.getElementById("guardianIC");
        if (guardianICInput && guardianICInput.value.trim() !== "") {
            if (!validateIC(guardianICInput.value, "Guardian")) return false;
        }

        // 2. If validation passes, show the custom modal instead of submitting
        showConfirmAddModal();
        return false; // Prevent form from submitting immediately
    }

    function showConfirmAddModal() {
        document.getElementById('confirmAddModal').style.display = 'flex';
    }

    function closeConfirmAddModal() {
        document.getElementById('confirmAddModal').style.display = 'none';
    }

    // 3. Handle the final confirmation click
    document.getElementById('finalSubmitBtn').addEventListener('click', function() {
        // Manually trigger the form submission
        document.querySelector('.form-container form').submit();
    });
</script>
</body>
</html>