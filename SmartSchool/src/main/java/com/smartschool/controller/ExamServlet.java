package com.smartschool.controller;

import com.smartschool.dao.UserDAO;

import com.smartschool.model.Examination;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ExamServlet")
public class ExamServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Get Batch Info
        int ClassID = Integer.parseInt(request.getParameter("classId"));
        int subjectId = Integer.parseInt(request.getParameter("subjectId"));
        String academicYear = request.getParameter("academicYear");
        String examType = request.getParameter("examType");
        String examDate = new java.sql.Date(System.currentTimeMillis()).toString(); 

        // 2. Get Student Arrays
        String[] studentICs = request.getParameterValues("StudIC");
        String[] marks = request.getParameterValues("marks");
        String[] grades = request.getParameterValues("grades");

        List<Examination> examList = new ArrayList<>();

        if (studentICs != null) {
            for (int i = 0; i < studentICs.length; i++) {
                Examination exam = new Examination();
                exam.setClassID(ClassID);
                exam.setSubjectId(subjectId);
                exam.setStudIC(studentICs[i]);
                exam.setExamType(examType);
                exam.setExamMark(Double.parseDouble(marks[i]));
                exam.setExamGrade(grades[i]);
                exam.setExamDate(examDate);
                exam.setAcademicYear(academicYear);
                examList.add(exam);
            }
        }

        // 3. Save to DB
        UserDAO dao = new UserDAO();
        boolean isSaved = dao.saveExaminationMarks(examList);

        if (isSaved) {
        	response.sendRedirect("teacher/examination.jsp?classId=" + ClassID + "&subjectId=" + subjectId  + "&academicYear=" + academicYear + "&success=1");
        } else {
            response.sendRedirect("teacher/examSelection.jsp?error=1&classId=" + ClassID + "&subjectId=" + subjectId);
        }
    }
}