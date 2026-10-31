package com.smartschool.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.smartschool.dao.UserDAO;
import com.smartschool.model.Teacher;

@WebServlet("/admin/TeacherListServlet")
public class TeacherListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public TeacherListServlet() {
        super();
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String status = request.getParameter("status");

        if (status == null || status.isEmpty() || status.startsWith("success") || "fail".equals(status) || "error".equals(status)) {
            status = "ACTIVE"; 
        }

        List<Teacher> list = userDAO.getTeachersByStatus(status);
        
        request.setAttribute("teacherList", list);
        request.setAttribute("currentStatus", status); 
        
        request.getRequestDispatcher("/admin/teacherList.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String redirectUrl = "TeacherListServlet"; 

        try {
            if ("delete".equals(action)) {
                // --- DELETE ACTION ---
                String idStr = request.getParameter("teacherId");
                int teacherId = Integer.parseInt(idStr);
                
                boolean success = userDAO.deleteTeacher(teacherId);
                
                if (success) {
                    response.sendRedirect(redirectUrl + "?status=successDelete");
                } else {
                    response.sendRedirect(redirectUrl + "?status=fail");
                }

            } else if ("edit".equals(action)) {
                // --- UPDATE LOGIC ---
                int id = Integer.parseInt(request.getParameter("editTeacherId"));
                String phone = request.getParameter("editPhone");
                
                String password = request.getParameter("editPassword");

                boolean success = userDAO.updateTeacherDetails(id, phone, password);

                if (success) {
                    response.sendRedirect(redirectUrl + "?status=success");
                } else {
                    response.sendRedirect(redirectUrl + "?status=fail");
                }
            } else {
                // Fallback
                response.sendRedirect(redirectUrl);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(redirectUrl + "?status=error");
        }
    }
}