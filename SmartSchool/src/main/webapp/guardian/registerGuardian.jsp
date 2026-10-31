<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = request.getParameter("error");
    String success = request.getParameter("success");
    String guardianIC = request.getParameter("guardianIC") != null ? request.getParameter("guardianIC") : "";
    String email = request.getParameter("email") != null ? request.getParameter("email") : "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register Guardian</title>
    <link rel="stylesheet" href="../assets/css/register.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="icon" type="image/webp" href="../assets/image/sksmLOGO.webp">
    <style>
        /* Existing Modal CSS */
        .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); display: none; justify-content: center; align-items: center; z-index: 1000; }
        .modal-box { background: #fff; padding: 30px; border-radius: 20px; max-width: 500px; width: 85%; text-align: center; display: flex; flex-direction: column; align-items: center; gap: 15px; }
        .modal-ok-btn { background-color: #C4A484; color: #3e2723; border: none; padding: 6px 20px; font-size: 0.85rem; font-family: 'Inter', sans-serif; font-weight: 700; border-radius: 50px; cursor: pointer; margin-top: 10px; }
        .error-text { color: red; font-size: 12px; margin-bottom: 15px; text-align: left; padding-left: 5px; display: block; }
    </style>
</head>

<body>
    <%-- SUCCESS POPUP --%>
    <% if ("1".equals(success)) { %>
    <div id="successModal" class="modal-overlay" style="display: flex;">
        <div class="modal-box">
            <h2>REGISTRATION SUBMITTED!</h2>
            <p>Your account has been created successfully. You can now log in.</p>
            <button class="modal-ok-btn" onclick="window.location.href='guardianLogin.html'">OK</button>
        </div>
    </div>
    <% } %>

    <div class="container">
        <h1 class="title">CREATE ACCOUNT</h1>
        <p class="subtitle">It is quick and easy.</p>

        <div class="register-box">
            <form action="../RegisterGuardianServlet" method="post">
                
                <%-- EMAIL FIELD --%>
                <input type="email" name="email" placeholder="Email" required 
                       value="<%= email %>"
                       style="<%= "emailTaken".equals(error) ? "border: 1px solid red; margin-bottom: 5px;" : "" %>">
                
                <% if ("emailTaken".equals(error)) { %>
                    <span class="error-text">Account with this email already exists.</span>
                <% } %>

                <%-- IC FIELD --%>
                <input type="text" name="guardianIC" placeholder="MyKad Number" required maxlength="12" 
                       value="<%= guardianIC %>"
                       oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                       style="<%= "icNotFound".equals(error) ? "border: 1px solid red; margin-bottom: 5px;" : "" %>">

                <% if ("icNotFound".equals(error)) { %>
                    <span class="error-text">MyKad number not found in student records.</span>
                <% } %>

                <%-- PASSWORD FIELDS --%>
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
                    <span class="error-text">Passwords do not match.</span>
                <% } %>

                <button type="submit" class="register-btn">Register</button>
                <a href="guardianLogin.html" class="login-link">Already have an account?</a>
            </form>
        </div>
    </div>

    <script>
        // Password visibility toggle
        document.querySelectorAll('.toggle-icon').forEach(icon => {
            icon.addEventListener('click', function() {
                const input = this.parentElement.querySelector('input');
                const isPassword = input.getAttribute('type') === 'password';
                input.setAttribute('type', isPassword ? 'text' : 'password');
                this.classList.toggle('fa-eye', isPassword);
                this.classList.toggle('fa-eye-slash', !isPassword);
            });
        });
    </script>
</body>
</html>