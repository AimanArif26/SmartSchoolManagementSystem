package com.smartschool.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.smartschool.dao.UserDAO;
import com.smartschool.model.Guardian;

@WebServlet("/GuardianLoginServlet")
public class GuardianLoginServlet extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String email = request.getParameter("email");
		String password = request.getParameter("password");

		UserDAO dao = new UserDAO();
		Guardian guardian = dao.loginGuardian(email, password);

		if (guardian != null) {
			HttpSession session = request.getSession();
			session.setAttribute("guardian", guardian);

			response.sendRedirect(request.getContextPath() + "/guardian/guardianHomepage.jsp");
		} else {
			response.sendRedirect(request.getContextPath() + "/guardian/guardianLogin.html?error=1");
		}
	}
}