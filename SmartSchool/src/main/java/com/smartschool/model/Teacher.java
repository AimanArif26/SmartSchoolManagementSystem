package com.smartschool.model;

import java.util.List;

public class Teacher extends User {
    private int TeacherID;
    private int userID;
    private String TeacherName;
    private String certNumber;
    private String TeacherPhoneNum;
    private String teacherRole;
    private String TeacherEmail;
    private String Password;
    private String Status;
    private List<String> assignedSubjects;

    public int getTeacherID() { return TeacherID; }
    public void setTeacherID(int teacherID) { this.TeacherID = teacherID; }

    public int getUserID() { return userID; }
    public void setUserID(int userID) { this.userID = userID; }

    public String getTeacherName() { return TeacherName; }
    public void setTeacherName(String TeacherName) { this.TeacherName = TeacherName; }

    public String getCertNumber() { return certNumber; }
    public void setCertNumber(String certNumber) { this.certNumber = certNumber; }
    
    public String getTeacherPhoneNum() { return TeacherPhoneNum; }
    public void setTeacherPhoneNum(String teacherPhoneNum) { this.TeacherPhoneNum = teacherPhoneNum; }
    
    public String getTeacherRole() { return teacherRole; }
    public void setTeacherRole(String teacherRole) { this.teacherRole = teacherRole; }
    
    public String getTeacherEmail() { return TeacherEmail; }
    public void setTeacherEmail(String TeacherEmail) { this.TeacherEmail = TeacherEmail; }
    
    public String getPasword() { return Password; }
    public void setPassword(String Password) { this.Password = Password; }
    
    public String getStatus() { return Status; }
    public void setStatus(String Status) { this.Status = Status; }
    
    public List<String> getAssignedSubjects() { return assignedSubjects; }
    public void setAssignedSubjects(List<String> assignedSubjects) { this.assignedSubjects = assignedSubjects; }
}