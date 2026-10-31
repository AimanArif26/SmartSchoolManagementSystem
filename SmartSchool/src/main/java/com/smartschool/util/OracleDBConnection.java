package com.smartschool.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class OracleDBConnection {
    // Oracle connection details
    private static final String DRIVER = "oracle.jdbc.driver.OracleDriver";
    private static final String URL = "jdbc:oracle:thin:@//localhost:1521/FREEPDB1";
    private static final String USER = "system"; 
    private static final String PASS = "oracle"; 

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName(DRIVER);
            conn = DriverManager.getConnection(URL, USER, PASS);
            System.out.println("Connected to Oracle successfully!");
        } catch (ClassNotFoundException e) {
            System.out.println("Oracle Driver not found! Make sure ojdbc.jar is in lib.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Connection to Oracle failed!");
            e.printStackTrace();
        }
        return conn;
    }
}