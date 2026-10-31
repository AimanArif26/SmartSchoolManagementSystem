package com.smartschool.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.smartschool.dao.UserDAO;
import com.smartschool.model.User;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword"); 
        String name = request.getParameter("TeacherName");
        String CertNumber = request.getParameter("CertNumber");
        String TeacherPhoneNum = request.getParameter("TeacherPhoneNum");

        if (password == null || !password.equals(confirmPassword)) {
            response.sendRedirect("teacher/registerTeacher.jsp?error=passwordMismatch");
            return; 
        }

        UserDAO userDao = new UserDAO();

        boolean success = userDao.registerTeacher(email, password, "teacher", name, CertNumber, TeacherPhoneNum);

        if (success) {
            response.sendRedirect("teacher/registerTeacher.jsp?success=1");
        } else {
            response.sendRedirect("teacher/registerTeacher.jsp?error=fail");
        }
    }
}