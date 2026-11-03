<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartschool.model.*, java.util.List"%>

<%
    Guardian guardian = (Guardian) session.getAttribute("guardian");
    Student student = (Student) request.getAttribute("studentDetails");
    List<Attendance> attendanceList = (List<Attendance>) request.getAttribute("attendanceList");
    String selectedMonth = (String) request.getAttribute("selectedMonth");

    if (guardian == null || student == null) {
        response.sendRedirect(request.getContextPath() + "/guardian/guardianHomepage.jsp");
        return;
    }

    int presentCount = 0;
    int totalDays = (attendanceList != null) ? attendanceList.size() : 0;
    if (attendanceList != null) {
        for (Attendance a : attendanceList) {
            if ("Present".equalsIgnoreCase(a.getStatus())) presentCount++;
        }
    }
    double rate = (totalDays > 0) ? ((double) presentCount / totalDays * 100) : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Attendance Record - <%= student.getStudName() %></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/homepage.css">
    <link rel="icon" type="image/webp" href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">
    <style>
        html, body { height: auto; overflow-y: auto; background-color: #f8f9fa; margin: 0; }
        .main-container { display: flex; flex-direction: column; align-items: center; padding: 40px 20px; min-height: 100vh; }
        .content-wrapper { width: 100%; max-width: 900px; }
        
        .attendance-header { background: white; padding: 30px; border-radius: 20px; border: 1px solid #e7d6c8; margin-bottom: 25px; display: flex; justify-content: space-between; align-items: center; }
        .status-badge { padding: 5px 15px; border-radius: 20px; font-weight: bold; font-size: 0.8rem; }
        .status-present { background: #d4edda; color: #155724; }
        .status-absent { background: #f8d7da; color: #721c24; }	
    </style>
</head>
<body>
    <header class="header">
        <div class="header-left">
            <i style="cursor:pointer; margin-right:15px;"></i>
            <span>Smart School System</span>
        </div>
        <div class="header-right">
            <div class="profile-area" id="profileBtn" style="cursor: pointer;">
                <span class="user-name">Guardian</span>
                <img src="${pageContext.request.contextPath}/assets/image/adminICON.png" class="profile-image">
            </div>
            <div class="profile-menu" id="profileMenu" style="display: none;">
                <p id="logoutOption"><i class="fas fa-sign-out-alt"></i> Logout</p>
            </div>
        </div>
    </header>
    
    <div class="main-container" style="background: linear-gradient(rgba(255, 255, 255, 0.7), rgba(255, 255, 255, 0.7)), 
             url('<%=request.getContextPath()%>/assets/image/background2.jpg') no-repeat center center fixed; 
             background-size: cover; min-height: 120vh;">
        <div class="content-wrapper">
			<div
				style="background: white; border-radius: 15px; border: 1px solid #e7d6c8; margin-bottom: 20px; overflow: hidden; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.03);">
				<table
					style="width: 100%; border-collapse: collapse; table-layout: fixed;">
					<tr>
						<td
							style="padding: 15px; text-align: center; border-right: 1px solid #f0f0f0;">
							<span
							style="font-size: 0.7rem; color: #8c8279; display: block; margin-bottom: 5px; font-weight: bold; text-transform: uppercase;">Present</span>
							<span
							style="font-size: 1.2rem; font-weight: bold; color: #28a745;"><%=presentCount%>
								Days</span>
						</td>
						<td
							style="padding: 15px; text-align: center; border-right: 1px solid #f0f0f0;">
							<span
							style="font-size: 0.7rem; color: #8c8279; display: block; margin-bottom: 5px; font-weight: bold; text-transform: uppercase;">Absent</span>
							<span
							style="font-size: 1.2rem; font-weight: bold; color: #dc3545;"><%=totalDays - presentCount%>
								Days</span>
						</td>
						<td style="padding: 15px; text-align: center;"><span
							style="font-size: 0.7rem; color: #8c8279; display: block; margin-bottom: 5px; font-weight: bold; text-transform: uppercase;">Rate</span>
							<span
							style="font-size: 1.2rem; font-weight: bold; color: <%=(rate < 80) ? "#dc3545" : "#5a4a42"%>;"><%=(int) rate%>%</span>
						</td>
					</tr>
				</table>
			</div>
			<div class="attendance-header">
				<div>
					<h3 style="margin: 0; color: #5a4a42;"><%=student.getStudName().toUpperCase()%></h3>
					<%
					// Array to map month numbers to names
					String[] monthNames = { "January", "February", "March", "April", "May", "June", "July", "August", "September",
							"October", "November", "December" };
					String displayMonth = "Whole Year";
					if (!"ALL".equals(selectedMonth)) {
						int monthIndex = Integer.parseInt(selectedMonth) - 1;
						displayMonth = monthNames[monthIndex];
					}
					%>
					<small>Viewing records for: <strong><%=displayMonth%></strong></small>
				</div>

				<form
					action="${pageContext.request.contextPath}/GuardianAttendanceServlet"
					method="get">
					<input type="hidden" name="id" value="<%=student.getStudIC()%>">
					<select name="month" onchange="this.form.submit()"
						style="padding: 8px 15px; border-radius: 10px; border: 1px solid #8c8279; background: white; cursor: pointer;">
						<option value="ALL" <%="ALL".equals(selectedMonth) ? "selected" : ""%>>All
							Months</option>
						<%
						for (int i = 0; i < 12; i++) {
							String mVal = String.format("%02d", i + 1); // Format as 01, 02, etc.
						%>
						<option value="<%=mVal%>"
							<%=mVal.equals(selectedMonth) ? "selected" : ""%>><%=monthNames[i]%></option>
						<%
						}
						%>
					</select>
				</form>
			</div>

			<div class="table-box" style="background:white; border-radius:20px; padding:20px; box-shadow:0 4px 15px rgba(0,0,0,0.05);">
                <table class="data-table" style="width:100%; border-collapse:collapse;">
                    <thead>
                        <tr style="border-bottom:2px solid #f0f0f0;">
                            <th style="padding:15px; text-align:left;">Date</th>
                            <th style="padding:15px; text-align:center;">Status</th>
                            <th style="padding:15px; text-align:left;">Remarks/Notes</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (attendanceList != null && !attendanceList.isEmpty()) { 
                            for (Attendance a : attendanceList) { %>
                        <tr style="border-bottom:1px solid #f9f9f9;">
                            <td style="padding:15px;"><%= a.getDate() %></td>
                            <td style="text-align:center; padding:15px;">
                                <span class="status-badge <%= a.getStatus().equalsIgnoreCase("Present") ? "status-present" : "status-absent" %>">
                                    <%= a.getStatus() %>
                                </span>
                            </td>
                            <td style="padding:15px; color:#666;"><%= (a.getNotes() == null || a.getNotes().isEmpty()) ? "-" : a.getNotes() %></td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="3" style="text-align:center; padding:40px; color:#999;">No records found for this period.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <div style="margin-top: 30px; display: flex; justify-content: flex-end">
                <a href="${pageContext.request.contextPath}/StudentProfileServlet?id=<%=student.getStudIC()%>" class="btn-back" style="text-decoration:none; background:#333; color:white; padding:10px 30px; border-radius:25px; font-weight:bold;">
                    Back
                </a>
            </div>
        </div>
    </div>
	
	<div id="logoutModal" class="modal-overlay">
		<div class="modal-box">
			<h3>Confirm Logout</h3>
			<p>Do you want to logout from this account?</p>
			<div class="modal-buttons">
				<button class="modal-btn btn-cancel" id="cancelLogout">Cancel</button>
				<button class="modal-btn btn-reject" id="confirmLogout">Logout</button>
			</div>
		</div>
	</div>
	
		<script>
        document.getElementById("profileBtn").addEventListener("click", function() {
            const menu = document.getElementById("profileMenu");
            menu.style.display = (menu.style.display === "block") ? "none" : "block";
        });

        const logoutOption = document.getElementById('logoutOption');
        const logoutModal = document.getElementById('logoutModal');
        const cancelLogout = document.getElementById('cancelLogout');
        const confirmLogout = document.getElementById('confirmLogout');

        logoutOption.addEventListener('click', () => logoutModal.style.display = 'flex');
        cancelLogout.addEventListener('click', () => logoutModal.style.display = 'none');
        confirmLogout.addEventListener('click', () => window.location.href = '../choice.html');

        window.onclick = function(event) {
            if (!event.target.matches('#profileBtn') && !event.target.matches('.profile-image') && !event.target.matches('.user-name')) {
                document.getElementById("profileMenu").style.display = "none";
            }
        }
    </script>
</body>
</html>