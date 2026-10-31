package com.smartschool.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.smartschool.dao.UserDAO;
import com.smartschool.model.User;

@WebServlet("/UpdateProfileAdminServlet")
public class UpdateProfileAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect("choice.html");
            return;
        }

        UserDAO dao = new UserDAO();
        String role = currentUser.getRole();
        boolean updated = false;

        if ("admin".equalsIgnoreCase(role)) {
            String newPassword = request.getParameter("password");

            if (newPassword != null && !newPassword.trim().isEmpty()) {
                updated = dao.updateUserPassword(currentUser.getUserId(), newPassword);
            }

            if (updated) {
                response.sendRedirect("admin/adminProfile.jsp?status=success1");
            } else {
                response.sendRedirect("admin/adminProfile.jsp?status=error=1");
            }
        } 
    }
}