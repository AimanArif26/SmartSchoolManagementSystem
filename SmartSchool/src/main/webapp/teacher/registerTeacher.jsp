<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
    // Handle error or success messages from URL parameters
    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register Teacher</title>
<link rel="stylesheet" href="../assets/css/register.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="icon" type="image/webp" href="../assets/image/sksmLOGO.webp">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
<link rel="icon" type="image/webp" href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">
<style>
    .modal-overlay {
        position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(0, 0, 0, 0.5); display: none; justify-content: center;
        align-items: center; z-index: 1000;
    }
    .modal-box {
        background: #fff; padding: 30px; border-radius: 20px;
        max-width: 500px; width: 85%; text-align: center;
        position: relative; box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        display: flex; flex-direction: column; align-items: center; gap: 15px;
    }
    
    .modal-box h2 {
        font-family: 'Inter', sans-serif; font-size: 1.5rem; color: #3e2723;
        margin: 0; font-weight: 700; text-transform: uppercase;
    }
    .modal-box p {
        font-family: 'Inter', sans-serif; font-size: 1rem; line-height: 1.5; 
        color: #555; margin: 0 auto;
    }
    
    .modal-ok-btn {
        background-color: #C4A484; 
        color: #3e2723;            
        border: none;
        padding: 6px 20px;         
        font-size: 0.85rem;        
        font-family: 'Inter', sans-serif;
        font-weight: 700;
        border-radius: 50px;       
        cursor: pointer;
        transition: transform 0.2s, background-color 0.2s;
        margin-top: 10px;
        box-shadow: 0 3px 5px rgba(0,0,0,0.1);
    }
    .modal-ok-btn:hover {
        background-color: #b08d6e;
        transform: scale(1.05);    
    }
</style>
</head>

<body>
    <% if ("1".equals(success)) { %>
    <div id="successModal" class="modal-overlay" style="display: flex;">
        <div class="modal-box">
            <h2>REGISTRATION SUBMITTED!</h2>
            <p>To ensure the security and integrity of our platform, new teacher accounts require administrator verification. Our team will review your details as soon as possible.</p>
            
            <button class="modal-ok-btn" onclick="redirectToLogin()">OK</button>
        </div>
    </div>
    <% } %>

	<div class="container">
		<h1 class="title">CREATE ACCOUNT</h1>
		<p class="subtitle">It is quick and easy.</p>

		<div class="register-box">
			<form action="../RegisterServlet" method="post">
                <input type="hidden" name="role" value="teacher">

                <input type="text" name="TeacherName" placeholder="Teacher Name" required
                       value="<%= request.getParameter("TeacherName") != null ? request.getParameter("TeacherName") : "" %>"> 
                
                <input type="text" name="CertNumber" placeholder="Certificate Number" required
                       value="<%= request.getParameter("CertNumber") != null ? request.getParameter("CertNumber") : "" %>"> 
				
                <input type="tel" name="TeacherPhoneNum" placeholder="Phone Number (e.g. 0123456789)" required
                       maxlength="11"
                       minlength="9"
                       pattern="^0[0-9]{8,10}$"
                       title="Please enter a valid Malaysian phone number starting with 0 (9-11 digits)"
                       oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                       value="<%= request.getParameter("TeacherPhoneNum") != null ? request.getParameter("TeacherPhoneNum") : "" %>">
				
                <input type="email" name="email" placeholder="Email" required
                       pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$"
                       title="Please enter a valid email address (e.g., user@email.com)"
                       value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
                       style="<%= "fail".equals(error) ? "border: 1px solid red; margin-bottom: 5px;" : "" %>">

                <% if ("fail".equals(error)) { %>
                    <div style="color: red; font-size: 12px; margin-bottom: 15px; text-align: left; padding-left: 5px;">
                        Account with this email already exists.
                    </div>
                <% } %>

				<div class="password-wrap">
                    <input type="password" name="password" placeholder="Password" required
                           style="<%= "passwordMismatch".equals(error) ? "border: 1px solid red;" : "" %>">
                    <i class="fa-solid fa-eye-slash toggle-icon"></i>
                </div>

                <div class="password-wrap">
                    <input type="password" name="confirmPassword" placeholder="Confirm Password" required
                           style="<%= "passwordMismatch".equals(error) ? "border: 1px solid red; margin-bottom: 5px;" : "" %>">
                    <i class="fa-solid fa-eye-slash toggle-icon"></i>
                </div>

                <% if ("passwordMismatch".equals(error)) { %>
                    <div style="color: red; font-size: 12px; margin-bottom: 15px; text-align: left; padding-left: 5px;">
                        Passwords do not match.
                    </div>
                <% } %>

				<button type="submit" class="register-btn">Register</button>
				<a href="teacherLogin.html" class="login-link">Already have an account?</a>
			</form>
		</div>
	</div>

    <script>
        function redirectToLogin() {
            window.location.href = 'teacherLogin.html';
        }

        document.addEventListener('DOMContentLoaded', function() {
            const toggles = document.querySelectorAll('.toggle-icon');
            toggles.forEach(icon => {
                icon.addEventListener('click', function() {
                    const input = this.parentElement.querySelector('input');
                    if (input) {
                        const type = input.getAttribute('type') === 'password' ? 'text' : 'password';
                        input.setAttribute('type', type);
                        this.classList.toggle('fa-eye');
                        this.classList.toggle('fa-eye-slash');
                    }
                });
            });
        });
    </script>
</body>
</html>