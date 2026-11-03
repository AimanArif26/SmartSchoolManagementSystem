<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Set New Password | Smart School</title>
    <link rel="stylesheet" href="assets/css/login.css">
    <link rel="icon" type="image/webp" href="assets/image/sksmLOGO.webp">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
       <style>
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
        <img src="assets/image/sksmLOGO.webp" alt="Loading..." class="loader-logo">
        <div class="loader-ring"></div>
    </div>
    <%
        // Security: Ensure user passed OTP verification
        if (session.getAttribute("resetUserId") == null) {
            response.sendRedirect("forgotPassword.jsp");
            return;
        }
    %>
    <div class="container">
        <div class="left-panel">
            <p><a class="home-link" href="choice.html">← Cancel Reset</a></p>
            <div class="title-logo">
                <span class="system-title">Smart School System</span> 
                <img src="assets/image/sksmLOGO.webp" alt="School Logo" class="school-logo">
            </div>
            <p class="welcome-text">Secure Your Account</p>
            <p style="color: #666; font-size: 0.95rem; line-height: 1.6; margin-top: 10px;">
                Almost there! Choose a strong password to ensure your account remains safe.
            </p>
        </div>

        <div class="login-box">
            <h2>Create New Password</h2>
            <form action="ResetPasswordServlet" method="POST" onsubmit="return validatePasswords()">
                
                <div class="input-group password-group">
                    <input type="password" name="newPassword" id="newPassword" 
                           placeholder="Enter new password" required 
                           style="width: 100%; box-sizing: border-box;">
                    <i id="toggleNew" class="fa-solid fa-eye-slash toggle-icon" style="font-size: 14px;"></i>
                </div>

                <div class="input-group password-group" style="margin-top: 15px;">
                    <input type="password" id="confirmPassword" 
                           placeholder="Confirm new password" required 
                           style="width: 100%; box-sizing: border-box;">
                    <i id="toggleConfirm" class="fa-solid fa-eye-slash toggle-icon" style="font-size: 14px;"></i>
                </div>
                
                <div id="pwError" style="display: none; color: red; font-size: 12px; margin-top: 8px; text-align: left;">
                    Passwords do not match!
                </div>

                <button type="submit" class="login-button" style="margin-top: 25px;">Update Password</button>
            </form>
        </div>
	</div>

    <script>
        function validatePasswords() {
            const pass = document.getElementById('newPassword').value;
            const confirm = document.getElementById('confirmPassword').value;
            const errorDiv = document.getElementById('pwError');

            if (pass !== confirm) {
                errorDiv.style.display = 'block';
                return false;
            }
            return true;
        }

        function setupToggle(toggleId, inputId) {
            const toggle = document.getElementById(toggleId);
            const input = document.getElementById(inputId);
            
            toggle.addEventListener('click', function() {
                const type = input.getAttribute('type') === 'password' ? 'text' : 'password';
                input.setAttribute('type', type);
                this.classList.toggle('fa-eye');
                this.classList.toggle('fa-eye-slash');
            });
        }

        setupToggle('toggleNew', 'newPassword');
        setupToggle('toggleConfirm', 'confirmPassword');
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