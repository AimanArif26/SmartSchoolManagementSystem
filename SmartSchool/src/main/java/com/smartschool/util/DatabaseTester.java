package com.smartschool.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class DatabaseTester {
    public static void main(String[] args) {
        System.out.println("--- Starting Connection Test ---");
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("1. [SUCCESS] Java reached XAMPP!");
                
                // Let's try to actually query your USER table
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS total FROM user");
                
                if (rs.next()) {
                    System.out.println("2. [SUCCESS] Query successful! Found " + rs.getInt("total") + " users.");
                }
            }
        } catch (Exception e) {
            System.err.println("--- [FAILURE] ---");
            System.err.println("Error Message: " + e.getMessage());
            System.err.println("\nPossible Fixes:");
            System.err.println("- Check if XAMPP MySQL is GREEN (Running).");
            System.err.println("- Ensure your database name in DBConnection matches phpMyAdmin exactly.");
            e.printStackTrace();
        }
    }
}