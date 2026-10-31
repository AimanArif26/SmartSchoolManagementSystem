package com.smartschool.controller;

import com.smartschool.dao.UserDAO;
import com.smartschool.model.Student;
import com.smartschool.model.Guardian;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/StudentProfileServlet")
public class StudentProfileServlet extends HttpServlet {
	private UserDAO userDAO = new UserDAO();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		Guardian guardian = (Guardian) session.getAttribute("guardian");

		if (guardian == null) {
			response.sendRedirect("guardian/guardianLogin.jsp");
			return;
		}

		String studIC = request.getParameter("id");

		if (studIC != null && !studIC.isEmpty()) {
			Student student = userDAO.getStudentDetailsByIC(studIC);

			request.setAttribute("studentDetails", student);
			request.getRequestDispatcher("guardian/guardianStudentProfile.jsp").forward(request, response);
		} else {
			response.sendRedirect(request.getContextPath() + "/GuardianHomeServlet");
		}
	}
}