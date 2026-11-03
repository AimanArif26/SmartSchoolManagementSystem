package com.smartschool.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import com.smartschool.util.OracleDBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AssignServlet")
public class AssignServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String teacherId = request.getParameter("teacherId");
        String subjectId = request.getParameter("subjectId");
        String classId = request.getParameter("classId");
        String academicYear = request.getParameter("academicYear");

        if (teacherId == null || subjectId == null || classId == null || academicYear == null) {
            response.sendRedirect("admin/assignment.jsp?error=missing");
            return;
        }

        String sql = "INSERT INTO TEACHER_ASSIGNMENT (TEACHER_ID, SUBJECT_ID, CLASS_ID, ACADEMIC_YEAR) VALUES (?, ?, ?, ?)";

        try (Connection conn = OracleDBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, Integer.parseInt(teacherId));
            ps.setInt(2, Integer.parseInt(subjectId));
            ps.setInt(3, Integer.parseInt(classId));
            ps.setString(4, academicYear);
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("admin/assignment.jsp?status=1");
            } else {
                response.sendRedirect("admin/assignment.jsp?status=failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/assignment.jsp?status=duplicate");
        }
    }
}