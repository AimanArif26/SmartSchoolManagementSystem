package com.smartschool.controller;

import java.io.IOException;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.smartschool.dao.UserDAO;

@WebServlet("/RegisterGuardianServlet")
public class RegisterGuardianServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String guardianIC = request.getParameter("guardianIC");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword"); 

        if (guardianIC == null || email == null || password == null) {
            response.sendRedirect("guardian/registerGuardian.jsp?error=emptyFields");
            return;
        }
        
        if (password == null || !password.equals(confirmPassword)) {
            response.sendRedirect("guardian/registerGuardian.jsp?error=passwordMismatch");
            return; 
        }

        UserDAO dao = new UserDAO();
        String result = dao.registerGuardian(email, password, guardianIC);

        if ("SUCCESS".equals(result)) {
            response.sendRedirect("guardian/registerGuardian.jsp?success=1");
        } else if ("IC_NOT_FOUND".equals(result)) {
            response.sendRedirect("guardian/registerGuardian.jsp?error=icNotFound&guardianIC=" + guardianIC);
        } else if ("ALREADY_REGISTERED".equals(result)) {
            response.sendRedirect("guardian/guardianLogin.html?error=alreadyRegistered");
        } else if ("EMAIL_TAKEN".equals(result)) {
            String encodedEmail = URLEncoder.encode(email, StandardCharsets.UTF_8);
            response.sendRedirect("guardian/registerGuardian.jsp?error=emailTaken&guardianIC=" + guardianIC + "&email=" + encodedEmail);
        } else {
            response.sendRedirect("guardian/registerGuardian.jsp?error=fail");
        }
    }
}