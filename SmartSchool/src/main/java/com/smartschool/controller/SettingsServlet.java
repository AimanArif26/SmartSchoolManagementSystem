package com.smartschool.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.smartschool.dao.UserDAO;

@WebServlet("/SettingsServlet")
public class SettingsServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String newType = request.getParameter("newExamType");
        UserDAO dao = new UserDAO();

        if (dao.updateActiveExamType(newType)) {
            response.sendRedirect("admin/adminSettings.jsp?success=true");
        } else {
            response.sendRedirect("admin/adminSettings.jsp?error=true");
        }
    }
}
