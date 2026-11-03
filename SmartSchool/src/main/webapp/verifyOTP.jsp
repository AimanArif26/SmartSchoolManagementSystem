<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify OTP | Smart School</title>
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
        if (session.getAttribute("generatedOTP") == null) {
            response.sendRedirect("forgotPassword.jsp");
            return;
        }
    %>
    <div class="container">
        <div class="left-panel">
            <p><a class="home-link" href="forgotPassword.jsp">← Back to Email</a></p>
            <div class="title-logo">
                <span class="system-title">Smart School System</span> 
                <img src="assets/image/sksmLOGO.webp" alt="School Logo" class="school-logo">
            </div>
            <p class="welcome-text">OTP Verification</p>
            <p style="color: #666; font-size: 0.95rem; line-height: 1.6; margin-top: 10px;">
                Check your inbox! We've sent a 6-digit code. Please enter it to continue.
            </p>
        </div>

        <div class="login-box">
            <h2>Verify your identity</h2>
            <form action="VerifyOTPServlet" method="POST">
                <div class="input-group">
                    <input type="text" name="otp" id="otp" placeholder="000000" maxlength="6" required 
                           style="width: 100%; box-sizing: border-box; text-align: center; letter-spacing: 10px; font-size: 1.5rem; font-weight: bold;">
                </div>

                <% if ("error".equals(request.getParameter("1"))) { %>
                    <div style="color: red; font-size: 12px; margin-top: 5px; text-align: left;">
                        ⚠️ Invalid code. Please check your email and try again.
                    </div>
                <% } %>

                <button type="submit" class="login-button" style="margin-top: 20px;">Verify & Continue</button>
            </form>
            <div style="text-align: center; margin-top: 20px;">
                <p style="font-size: 12px; color: grey;">Didn't get the code? <a href="forgotPassword.jsp" style="color: #8c8279; text-decoration: none; font-weight: 600;">Resend OTP</a></p>
            </div>
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