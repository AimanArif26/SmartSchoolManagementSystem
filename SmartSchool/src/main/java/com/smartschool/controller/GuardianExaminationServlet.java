package com.smartschool.controller;

import com.smartschool.dao.UserDAO;
import com.smartschool.model.Examination;
import com.smartschool.model.Student;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/GuardianExaminationServlet")
public class GuardianExaminationServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String studIC = request.getParameter("id");
        String examType = request.getParameter("examType");
        String academicYear = request.getParameter("academicYear");

        if (examType == null || examType.trim().isEmpty()) {
            examType = "Mid-Term"; 
        }
        
        if (academicYear == null || academicYear.trim().isEmpty()) {
            academicYear = "2026";
        }

        if (studIC == null || studIC.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/guardian/guardianHomepage.jsp");
            return;
        }

        try {
            Student student = userDAO.getStudentDetailsByIC(studIC);
            
            List<Examination> examList = userDAO.getStudentExamsByIC(studIC, examType, academicYear);

            List<Examination> allExams = userDAO.getAllStudentExamsByIC(studIC);

            request.setAttribute("studentDetails", student);
            request.setAttribute("examList", examList);
            request.setAttribute("allExams", allExams); 
            request.setAttribute("currentExamType", examType);
            request.setAttribute("currentAcademicYear", academicYear);

            request.getRequestDispatcher("/guardian/examinationGuardian.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("DEBUG: ERROR OCCURRED!");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/choice.html");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}