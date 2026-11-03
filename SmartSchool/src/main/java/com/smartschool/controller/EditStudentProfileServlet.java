package com.smartschool.controller;

import com.smartschool.dao.UserDAO;
import com.smartschool.model.Student;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/editStudentProfile")
public class EditStudentProfileServlet extends HttpServlet {
	private UserDAO userDAO;

	@Override
	public void init() {
		userDAO = new UserDAO();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String studIC = request.getParameter("id");

		if (studIC == null || studIC.trim().isEmpty()) {
			response.sendRedirect(request.getContextPath() + "/guardian/GuardianHomepage.jsp");
			return;
		}

		Student student = userDAO.getStudentDetailsByIC(studIC);

		if (student == null) {
			response.sendRedirect(request.getContextPath() + "/error.jsp");
			return;
		}

		request.setAttribute("student", student);
		request.getRequestDispatcher("/guardian/editStudentProfile.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    String studIC = request.getParameter("studIC");
	    String newAddress = request.getParameter("address");

	    UserDAO dao = new UserDAO();
	    boolean updated = dao.updateStudentAddress(studIC, newAddress);

	    if (updated) {
	        response.sendRedirect("editStudentProfile?id=" + studIC + "&success=1");
	    } else {
	        response.sendRedirect("editStudentProfile?id=" + studIC + "&error=1");
	    }
	}
}