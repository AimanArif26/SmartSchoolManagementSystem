package com.smartschool.model;

/**
 * Model representing an individual examination record for a student.
 */
public class Examination {
    private int examId;
    private int ClassID;
    private String studIC;
    private int subjectId;
    private String examType;
    private double examMark;
    private String examDate;
    private String academicYear;
    private String examGrade;
    private String subjectName;

    public Examination() {}

    public Examination(int ClassID, String studIC, int subjectId, String examType, 
                       double examMark, String examDate, String academicYear, String examGrade, String subjectName) {
        this.ClassID = ClassID;
        this.studIC = studIC;
        this.subjectId = subjectId;
        this.examType = examType;
        this.examMark = examMark;
        this.examDate = examDate;
        this.academicYear = academicYear;
        this.examGrade = examGrade;
        this.subjectName = subjectName;
    }

    // --- Getters and Setters ---

    public int getExamId() { return examId; }
    public void setExamId(int examId) { this.examId = examId; }

    public int getClassID() { return ClassID; }
    public void setClassID(int ClassID) { this.ClassID = ClassID; }

    public String getStudIC() { return studIC; }
    public void setStudIC(String studIC) { this.studIC = studIC; }

    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }

    public String getExamType() { return examType; }
    public void setExamType(String examType) { this.examType = examType; }

    public double getExamMark() { return examMark; }
    public void setExamMark(double examMark) { this.examMark = examMark; }

    public String getExamDate() { return examDate; }
    public void setExamDate(String examDate) { this.examDate = examDate; }

    public String getAcademicYear() { return academicYear; }
    public void setAcademicYear(String academicYear) { this.academicYear = academicYear; }

    public String getExamGrade() { return examGrade; }
    public void setExamGrade(String examGrade) { this.examGrade = examGrade; }

    public String getSubjectName() { return subjectName; }
	public void setSubjectName(String subjectName) { this.subjectName = subjectName;	}
}