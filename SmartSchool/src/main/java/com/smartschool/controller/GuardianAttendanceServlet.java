package com.smartschool.controller;

import com.smartschool.dao.UserDAO;
import com.smartschool.model.Attendance;
import com.smartschool.model.Student;
import com.smartschool.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/GuardianAttendanceServlet") 
public class GuardianAttendanceServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() { userDAO = new UserDAO(); }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("guardian") == null) {
            response.sendRedirect(request.getContextPath() + "/guardian/guardianLogin.jsp");
            return;
        }

        String studIC = request.getParameter("id"); 
        String month = request.getParameter("month");

        if (month == null || month.isEmpty()) { month = "ALL"; }

        Student student = userDAO.getStudentDetailsByIC(studIC);
        List<Attendance> attendanceList = userDAO.getStudentAttendanceByGuardian(studIC, month);

        request.setAttribute("studentDetails", student);
        request.setAttribute("attendanceList", attendanceList);
        request.setAttribute("selectedMonth", month);

        request.getRequestDispatcher("/guardian/attendanceGuardian.jsp").forward(request, response);
    }
}