package com.smartschool.util;

import java.sql.Connection;
import com.smartschool.util.OracleDBConnection;

public class TestConnection {
    public static void main(String[] args) {
        System.out.println("--- Starting Oracle Connection Test ---");
        
        // Attempt to get a connection from your DBConnection utility
        Connection conn = OracleDBConnection.getConnection();
        
        if (conn != null) {
            System.out.println("SUCCESS: Your project is successfully talking to Oracle!");
            try {
                conn.close(); // Always close test connections
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            System.out.println("FAILURE: Connection is null. Check your Driver, URL, and Credentials.");
        }
    }
}