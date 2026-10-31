package com.smartschool.model;

public class User {
    private int userId;
    private String email;
    private String role; 
    private String name; 

    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getTeacherID() { 
        return this.userId; 
    }
}