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

@WebServlet("/DeleteAttendanceServlet")
public class DeleteAttendanceServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String classId = request.getParameter("classId");
        String mode = request.getParameter("mode");
        String value = request.getParameter("value");

        String sql = "";
        if ("day".equals(mode)) {
            sql = "DELETE FROM ATTENDANCE WHERE CLASS_ID = ? AND ATTENDANCE_DATE = TO_DATE(?, 'YYYY-MM-DD')";
        } else if ("month".equals(mode)) {
            sql = "DELETE FROM ATTENDANCE WHERE CLASS_ID = ? AND EXTRACT(MONTH FROM ATTENDANCE_DATE) = ? AND EXTRACT(YEAR FROM ATTENDANCE_DATE) = ?";
        } else if ("year".equals(mode)) {
            sql = "DELETE FROM ATTENDANCE WHERE CLASS_ID = ? AND ACADEMICYEAR = ?";
        }

        try (Connection conn = OracleDBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, Integer.parseInt(classId));
            if ("day".equals(mode) || "year".equals(mode)) {
                ps.setString(2, value);
            } else if ("month".equals(mode)) {
                ps.setInt(2, Integer.parseInt(value)); 
                ps.setInt(3, 2026); 
            }
            
            ps.executeUpdate();
            response.sendRedirect("admin/manageAttendance.jsp?classId=" + classId + "&success=deleted");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/manageAttendance.jsp?classId=" + classId + "&error=1");
        }
    }
}
