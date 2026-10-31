package com.smartschool.model;

public class Attendance {
    private int attendanceID;
    private String date;
    private int ClassID;
    private String academicYear; 
    private String StudIC;
    private String status;
    private String notes;
    private String mcImage;

    // Empty Constructor
    public Attendance() {}

    public Attendance(String date, int ClassID, String academicYear, String StudIC, String status, String notes) {
        this.date = date;
        this.ClassID = ClassID;
        this.academicYear = academicYear;
        this.StudIC = StudIC;
        this.status = status;
        this.notes = notes;
    }

    // Getters and Setters
    public int getAttendanceID() { return attendanceID; }
    public void setAttendanceID(int attendanceID) { this.attendanceID = attendanceID; }

    public String getDate() { return date; }
    public void setDate(String date) { this.date = date; }

    public int getClassID() { return ClassID; }
    public void setClassID(int ClassID) { this.ClassID = ClassID; }

    public String getAcademicYear() { return academicYear; }
    public void setAcademicYear(String academicYear) { this.academicYear = academicYear; }

    public String getStudIC() { return StudIC; }
    public void setStudIC(String StudIC) { this.StudIC = StudIC; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    
    public String getMcImage() { return mcImage; }
    public void setMcImage(String mcImage) { this.mcImage = mcImage; }
}