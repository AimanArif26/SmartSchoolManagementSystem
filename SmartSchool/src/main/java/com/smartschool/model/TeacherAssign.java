package com.smartschool.model;

public class TeacherAssign {
    private int assignId;
    private int TeacherID;
    private int ClassID;
    private int subjectId;
    private String academicYear;
    
    private String ClassName;
    private String subjectName;

    public int getAssignId() { return assignId; }
    public void setAssignId(int assignId) { this.assignId = assignId; }
    public int getTeacherId() { return TeacherID; }
    public void setTeacherId(int TeacherID) { this.TeacherID = TeacherID; }
    public int getClassId() { return ClassID; }
    public void setClassId(int ClassID) { this.ClassID = ClassID; }
    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }
    public String getClassName() { return ClassName; }
    public void setClassName(String ClassName) { this.ClassName = ClassName; }
    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }
    public String getAcademicYear() { return academicYear; }
    public void setAcademicYear(String academicYear) { this.academicYear = academicYear; }
}