<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password | Smart School</title>
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
    <div class="container">
        <div class="left-panel">
            <p><a class="home-link" href="choice.html">← Back to Selection</a></p>
            <div class="title-logo">
                <span class="system-title">Smart School System</span> 
                <img src="assets/image/sksmLOGO.webp" alt="School Logo" class="school-logo">
            </div>
            <p class="welcome-text">Account Recovery</p>
            <p style="color: #666; font-size: 0.95rem; line-height: 1.6; margin-top: 10px;">
                Enter your email and we'll send a 6-digit code to verify your identity.
            </p>
        </div>

        <div class="login-box">
            <h2>Reset your password</h2>
            <form action="ForgotPasswordServlet" method="POST">
                <div class="input-group">
                    <input type="email" name="email" id="email" placeholder="Enter your registered email" required 
                           style="width: 100%; box-sizing: border-box;">
                </div>

                <% if ("notfound".equals(request.getParameter("status"))) { %>
                    <div style="color: red; font-size: 12px; margin-top: 5px; text-align: left;">
                        ⚠️ This email is not registered in our system.
                    </div>
                <% } %>

                <button type="submit" class="login-button" style="margin-top: 20px;">Send OTP</button>
            </form>
            <a href="choice.html" class="register-link">Return to Login</a>
        </div>
    </div>
	<script>        
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