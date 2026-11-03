package com.smartschool.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Random;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.smartschool.util.OracleDBConnection;
import com.smartschool.util.EmailUtil;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        
        try (Connection conn = com.smartschool.util.OracleDBConnection.getConnection()) {
            String sql = "SELECT USER_ID FROM USERS WHERE EMAIL = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String otp = String.format("%06d", new java.util.Random().nextInt(1000000));
                
                HttpSession session = request.getSession();
                session.setAttribute("generatedOTP", otp);
                session.setAttribute("resetUserId", rs.getInt("USER_ID"));
                
                String subject = "Your Smart School OTP";
                String body = "Your 6-digit code is: " + otp;
                com.smartschool.util.EmailUtil.sendEmail(email, subject, body);
                
                response.sendRedirect("verifyOTP.jsp");
            } else {
                response.sendRedirect("forgotPassword.jsp?status=notfound");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("forgotPassword.jsp?status=error");
        }
    }
}