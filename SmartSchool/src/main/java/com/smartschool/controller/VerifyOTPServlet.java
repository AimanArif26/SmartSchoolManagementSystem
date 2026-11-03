package com.smartschool.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/VerifyOTPServlet")
public class VerifyOTPServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String enteredOtp = request.getParameter("otp");
        HttpSession session = request.getSession();
        
        String sessionOtp = (String) session.getAttribute("generatedOTP");

        if (sessionOtp != null && sessionOtp.equals(enteredOtp)) {
            session.removeAttribute("generatedOTP"); 
            response.sendRedirect("resetPassword.jsp");
        } else {
            response.sendRedirect("verifyOTP.jsp?error=1");
        }
    }
}