package com.smartschool.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import com.smartschool.dao.UserDAO;
import com.smartschool.model.User;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        
        UserDAO dao = new UserDAO();
        boolean updated = dao.updateProfile(currentUser.getUserId(), currentUser.getTeacherID(), phone, password);
        
        if (updated) {
            session.setAttribute("currentUser", currentUser);
            response.sendRedirect("teacher/teacherProfile.jsp?success=1");
        } else {
            response.sendRedirect("teacher/teacherProfile.jsp?error=1");
        }
    }
}