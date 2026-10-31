package com.smartschool.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import com.smartschool.dao.UserDAO;
import com.smartschool.model.Attendance;
import com.smartschool.model.User;

@WebServlet("/AttendanceServlet")
@MultipartConfig(
	    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
	    maxFileSize = 1024 * 1024 * 10,      // 10MB
	    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AttendanceServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserDAO dao = new UserDAO();
        
        int classID = Integer.parseInt(request.getParameter("ClassID"));
        String attendanceDate = request.getParameter("attendanceDate");
        String academicYear = request.getParameter("academicYear");
        String[] studICs = request.getParameterValues("StudIC");
        java.sql.Date selectedDate = java.sql.Date.valueOf(attendanceDate);
        java.sql.Date today = new java.sql.Date(System.currentTimeMillis());

        List<Attendance> list = new ArrayList<>();

        if (studICs != null) {
            for (String ic : studICs) {
                Attendance a = new Attendance();
                a.setStudIC(ic);
                a.setClassID(classID);
                a.setDate(attendanceDate);
                a.setAcademicYear(academicYear);
                a.setStatus(request.getParameter("Status_" + ic));
                a.setNotes(request.getParameter("Notes_" + ic));
                a.setMcImage(null); 
                
                list.add(a);
            }
        }

        boolean alreadyExists = dao.checkAttendanceExists(classID, attendanceDate);
        boolean success;

        if (alreadyExists) {
            success = dao.updateAttendance(list);
        } else {
            success = dao.insertAttendance(list);
        }

        if (success) {
            response.sendRedirect("teacher/attendance.jsp?success=1");
        } else {
            response.sendRedirect("teacher/attendance.jsp?error=failed");
        }
    }
}