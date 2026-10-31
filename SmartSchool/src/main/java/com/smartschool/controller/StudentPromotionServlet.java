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

@WebServlet("/StudentPromotionServlet")
public class StudentPromotionServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String studIC = request.getParameter("studIC");
        String yearFilter = request.getParameter("year");
        
        boolean success = false;

        try {
            if ("promoteAll".equals(action)) {
                success = promoteAllStudents(yearFilter);
            }
            String contextPath = request.getContextPath();
            if (success) {
            	response.sendRedirect(contextPath + "/admin/StudentListServlet?status=successful");
            } else {
            	response.sendRedirect(contextPath + "/admin/StudentListServlet?status=fail");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("StudentPromotionServlet?status=fail");
        }
    }

    private boolean promoteAllStudents(String yearFilter) throws SQLException {
    	System.out.println("DEBUG: Starting Promotion Process...");
        String graduateSql = "UPDATE STUDENT SET STUD_STATUS = 'INACTIVE' WHERE STUD_YEAR = 6";
        String upgradeSql = "UPDATE STUDENT SET STUD_YEAR = STUD_YEAR + 1 WHERE STUD_YEAR < 6";

        // If a specific year is filtered (e.g., only promote Year 2s)
        if (yearFilter != null && !yearFilter.isEmpty()) {
            graduateSql += " AND STUD_YEAR = " + yearFilter;
            upgradeSql += " AND STUD_YEAR = " + yearFilter;
        }

        try (Connection conn = OracleDBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(graduateSql);
                 PreparedStatement ps2 = conn.prepareStatement(upgradeSql)) {
                
                ps1.executeUpdate();
                ps2.executeUpdate();
                
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }
}