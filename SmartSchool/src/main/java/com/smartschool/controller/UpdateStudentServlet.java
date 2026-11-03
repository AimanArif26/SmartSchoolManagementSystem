package com.smartschool.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.smartschool.util.OracleDBConnection;

@WebServlet("/admin/UpdateStudentServlet")
public class UpdateStudentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    	String studIC = request.getParameter("studIC");
    	String yearStr = request.getParameter("year");
    	String className = request.getParameter("className");

    	String sql = "UPDATE STUDENT SET STUD_YEAR = ?, " +
    	             "CLASS_ID = (SELECT CLASS_ID FROM CLASSROOM WHERE CLASS_NAME = ? AND CLASS_YEAR = ?) " +
    	             "WHERE STUD_IC = ?";

    	try (Connection conn = OracleDBConnection.getConnection();
    	     PreparedStatement ps = conn.prepareStatement(sql)) {
    	    ps.setInt(1, Integer.parseInt(yearStr));
    	    ps.setString(2, className);
    	    ps.setInt(3, Integer.parseInt(yearStr));
    	    ps.setString(4, studIC);

    	    int rowsAffected = ps.executeUpdate();
    	    boolean success = (rowsAffected > 0);
    	    
    	    if (success) {
    	    	response.sendRedirect(request.getContextPath() + "/admin/student.jsp?status=success1");
    	    } else {
    	    	response.sendRedirect(request.getContextPath() + "/admin/student.jsp?status=fail1");
    	    }
    	} catch (SQLException e) {
    	    e.printStackTrace();
    	    response.sendRedirect("admin/student.jsp?status=fail");
    	}
    }
}