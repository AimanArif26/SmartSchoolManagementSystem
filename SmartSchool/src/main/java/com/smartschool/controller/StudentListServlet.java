package com.smartschool.controller;

import java.io.IOException;
import java.util.List;

import com.smartschool.dao.UserDAO;
import com.smartschool.model.Classroom;
import com.smartschool.model.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/StudentListServlet")
public class StudentListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public StudentListServlet() {
        super();
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            action = "list"; 
        }

        try {
            switch (action) {
                case "showAddForm":
                    showAddStudentForm(request, response);
                    break;
                    
                case "delete":
                    deleteSingleStudent(request, response);
                    break;
                case "deleteAll":
                    deleteAllStudents(request, response);
                    break;
                    
                default:
                    listStudents(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("student.jsp?status=error");
        }
    }
    
    private void listStudents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String yearStr = request.getParameter("searchYear");
        List<Student> list;

        if (yearStr != null && !yearStr.isEmpty()) {
            int year = Integer.parseInt(yearStr);
            list = userDAO.getStudentsByYear(year); 
        } else {
            list = userDAO.getAllStudents(); 
        }

        request.setAttribute("studentList", list);
        request.getRequestDispatcher("student.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addNewStudent(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void showAddStudentForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Classroom> classList = userDAO.getAllClasses();
        request.setAttribute("classList", classList);
        request.getRequestDispatcher("addStudent.jsp").forward(request, response);
    }

    private void addNewStudent(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            String studIC = request.getParameter("studIC");
            String studName = request.getParameter("studName");
            String yearStr = request.getParameter("studYear");
            int studYear = Integer.parseInt(yearStr); 

            String dobStr = request.getParameter("dob");
            String address = request.getParameter("address");
            String gender = request.getParameter("gender");
            String guardianIC = request.getParameter("guardianIC"); 
            int classId = Integer.parseInt(request.getParameter("classId"));

            java.sql.Date sqlDate = null;
            if (dobStr != null && !dobStr.isEmpty()) {
                try {
                    sqlDate = java.sql.Date.valueOf(dobStr);
                } catch (IllegalArgumentException e) {
                    System.out.println("Error parsing date: " + dobStr);
                }
            }

            Student s = new Student();
            s.setStudIC(studIC);
            s.setStudName(studName);
            s.setStudYear(studYear);
            s.setDateOfBirth(sqlDate);
            s.setAddress(address);
            s.setStudGender(gender);
            s.setGuardianIC(guardianIC);
            s.setClassId(classId);

            boolean isAdded = userDAO.addStudent(s);

            if (isAdded) {
                response.sendRedirect("student.jsp?searchYear=" + studYear + "&status=successAdd");
            } else {
                response.sendRedirect("StudentListServlet?action=showAddForm&status=fail");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("student.jsp?status=error");
        }
    }

    private void deleteSingleStudent(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String ic = request.getParameter("studIC");
        boolean isDeleted = false;

        if (ic != null && !ic.isEmpty()) {
            isDeleted = userDAO.deleteStudent(ic);
        }

        if (isDeleted) {
            response.sendRedirect("student.jsp?status=success");
        } else {
            response.sendRedirect("student.jsp?status=fail");
        }
    }

    private void deleteAllStudents(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String yearStr = request.getParameter("year");
        boolean isDeleted = false;

        if (yearStr != null && !yearStr.isEmpty()) {
            int year = Integer.parseInt(yearStr);
            isDeleted = userDAO.deleteStudentsByYear(year);
        } else {
            isDeleted = userDAO.deleteAllStudents();
        }

        if (isDeleted) {
            String redirectUrl = "student.jsp?status=success";
            if (yearStr != null && !yearStr.isEmpty()) {
                redirectUrl += "&searchYear=" + yearStr;
            }
            response.sendRedirect(redirectUrl);
        } else {
            response.sendRedirect("student.jsp?status=fail");
        }
    }
}