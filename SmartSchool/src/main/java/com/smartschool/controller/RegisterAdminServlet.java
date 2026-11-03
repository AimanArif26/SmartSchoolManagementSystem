package com.smartschool.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.smartschool.model.User;
import com.smartschool.util.OracleDBConnection; 

@WebServlet("/RegisterAdminServlet")
public class RegisterAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null || currentUser.getUserId() != 1) {
            response.sendRedirect("admin/adminProfile.jsp?status=unauthorized");
            return;
        }
        
        String email = request.getParameter("adminEmail");
        String password = request.getParameter("adminPassword");

        boolean success = false;
        try {
            success = registerAdminTransaction(email, password);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (success) {
            response.sendRedirect("admin/adminProfile.jsp?status=adminAdded");
        } else {
            response.sendRedirect("admin/adminProfile.jsp?status=error");
        }
    }

    private boolean registerAdminTransaction(String email, String password) throws SQLException {
        Connection conn = null;
        PreparedStatement psUser = null;
        PreparedStatement psAdmin = null;
        ResultSet rs = null;

        String userSql = "INSERT INTO USERS (EMAIL, PASSWORD, ROLE) VALUES (?, ?, 'admin')";
        String adminSql = "INSERT INTO ADMIN (USER_ID) VALUES (?)";

        try {
            conn = OracleDBConnection.getConnection();
            conn.setAutoCommit(false);

            String[] generatedColumns = {"USER_ID"}; 
            psUser = conn.prepareStatement(userSql, generatedColumns);
            psUser.setString(1, email);
            psUser.setString(2, password);
            psUser.executeUpdate();

            rs = psUser.getGeneratedKeys();
            int newUserId = 0;
            if (rs.next()) {
                newUserId = rs.getInt(1);
            }

            if (newUserId > 0) {
                psAdmin = conn.prepareStatement(adminSql);
                psAdmin.setInt(1, newUserId);
                psAdmin.executeUpdate();

                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
            }

        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (psUser != null) psUser.close();
            if (psAdmin != null) psAdmin.close();
            if (conn != null) conn.close();
        }
    }
}