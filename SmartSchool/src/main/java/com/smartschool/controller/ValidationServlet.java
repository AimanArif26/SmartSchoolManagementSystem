package com.smartschool.controller;

import jakarta.servlet.ServletException;

import com.smartschool.dao.UserDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import com.smartschool.util.OracleDBConnection;

@WebServlet("/ValidationServlet")
public class ValidationServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sharedIdStr = request.getParameter("userId");
        String action = request.getParameter("action");
        String headIdStr = request.getParameter("headId"); 
        String redirectStatus = "fail";

        try (Connection conn = OracleDBConnection.getConnection()) {
            int teacherId = Integer.parseInt(sharedIdStr);
            
            if ("approve".equals(action)) {
                conn.setAutoCommit(false);
                try {
                    // Updated SQL to include TEACHER_ROLE
                    String sqlTeacher = "UPDATE TEACHER SET HEAD_TEACHER_ID = ?, STATUS = 'approved', TEACHER_ROLE = ? WHERE TEACHER_ID = ?";
                    PreparedStatement ps1 = conn.prepareStatement(sqlTeacher);
                    
                    int headId = Integer.parseInt(headIdStr);
                    String roleName;

                    if (headId == 0) {
                        ps1.setNull(1, java.sql.Types.INTEGER); 
                        roleName = "Head of Subject"; 
                    } else {
                        ps1.setInt(1, headId);
                        roleName = "Standard Teacher"; 
                    }

                    ps1.setString(2, roleName);    
                    ps1.setInt(3, teacherId);      
                    ps1.executeUpdate();

                    conn.commit();
                    redirectStatus = "success";
                } catch (Exception inner) {
                    conn.rollback();
                    throw inner;
                }
                
            } else if ("reject".equals(action)) {
                conn.setAutoCommit(false); 
                try {

                    String deleteTeacher = "DELETE FROM TEACHER WHERE TEACHER_ID = ?";
                    PreparedStatement ps1 = conn.prepareStatement(deleteTeacher);
                    ps1.setInt(1, teacherId);
                    ps1.executeUpdate();

                    // Note: If teacherId is the same as userId, this works:
                    String deleteUser = "DELETE FROM USERS WHERE USER_ID = ?";
                    PreparedStatement ps2 = conn.prepareStatement(deleteUser);
                    ps2.setInt(1, teacherId);
                    ps2.executeUpdate();

                    conn.commit(); 
                    redirectStatus = "rejected";
                } catch (Exception inner) {
                    conn.rollback(); 
                    throw inner;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin/validateTeacher.jsp?status=" + redirectStatus);
    }
}