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

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role"); 

        UserDAO userDao = new UserDAO();
        User user = userDao.loginCheck(email, password, role);

        if (user != null) {
            // --- LOGIN SUCCESS ---
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", user);
            session.setAttribute("TeacherID", user.getUserId());
            
            response.sendRedirect(role + "/" + role + "Homepage.jsp"); 
        } else {
            
            if ("teacher".equals(role)) {

                response.sendRedirect("teacher/teacherLogin.html?error=1");
            } 
            else if ("admin".equals(role)) {
                response.sendRedirect("admin/adminLogin.html?error=1");
            } 
        }
    }
}