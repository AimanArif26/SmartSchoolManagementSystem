package com.smartschool.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.smartschool.util.OracleDBConnection;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("resetUserId");
        String newPassword = request.getParameter("newPassword");

        if (userId == null) {
            response.sendRedirect("forgotPassword.jsp");
            return;
        }

        try (Connection conn = OracleDBConnection.getConnection()) {
            // Update the password for the specific User ID
            String sql = "UPDATE USERS SET PASSWORD = ? WHERE USER_ID = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newPassword);
            ps.setInt(2, userId);
            
            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                // Clear the temporary session and redirect to choice page with success
                session.removeAttribute("resetUserId");
                response.sendRedirect("choice.html?status=success");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("resetPassword.jsp?status=error");
        }
    }
}