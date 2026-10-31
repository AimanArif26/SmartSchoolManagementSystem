package com.smartschool.model;

public class Classroom {
    private int ClassID;
    private String ClassName; 
    private int TeacherID;  
    private int AcademicYear;
    private int classYear;
    private String teacherName;
    
    // Empty Constructor
    public Classroom() {}

    // Constructor with fields
    public Classroom(int ClassID, String ClassName, int TeacherId, int classYear, int AcademicYear) {
        this.ClassID = ClassID;
        this.ClassName = ClassName;
        this.TeacherID = TeacherId;
        this.classYear = classYear;
        this.AcademicYear = AcademicYear;
    }

    // Getters and Setters
    public int getClassID() {
        return ClassID;
    }

    public void setClassID(int ClassID) {
        this.ClassID = ClassID;
    }

    public String getClassName() {
        return ClassName;
    }

    public void setClassName(String ClassName) {
        this.ClassName = ClassName;
    }

    public int getTeacherID() {
        return TeacherID;
    }

    public void setTeacherID(int TeacherID) {
        this.TeacherID = TeacherID;
    }
    
    public int getAcademicYear() {
    	return AcademicYear;
    }
    
	public void setAcademicYear(int AcademicYear) {		
	}
	
	public int getClassYear() {
        return classYear;
    }

    public void setClassYear(int classYear) {
        this.classYear = classYear;
    }
	public String getTeacherName() {
        return teacherName;
    }

    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }
}