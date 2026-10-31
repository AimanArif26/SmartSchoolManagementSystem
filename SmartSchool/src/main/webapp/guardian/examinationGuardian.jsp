<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.smartschool.dao.UserDAO"%>
<%@ page import="com.smartschool.model.Guardian"%>
<%@ page import="com.smartschool.model.Student"%>
<%@ page import="com.smartschool.model.Examination"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashSet"%>

<%
    Guardian guardian = (Guardian) session.getAttribute("guardian");
    String studIC = request.getParameter("id"); 
    String examType = request.getParameter("examType") != null ? request.getParameter("examType") : "Mid-Term";
    String academicYear = (String) request.getAttribute("currentAcademicYear");
    if (academicYear == null) {
        academicYear = "2026"; 
    }
    
    UserDAO dao = new UserDAO(); 
    
    if (guardian == null || studIC == null) {
        response.sendRedirect(request.getContextPath() + "/guardian/guardianHomepage.jsp");
        return;
    }

    List<Examination> examList = dao.getStudentExamsByIC(studIC, examType, academicYear);
    List<Examination> allExams = (List<Examination>) request.getAttribute("allExams");
    Student student = dao.getStudentDetailsByIC(studIC);
    
    // Statistics Logic
    double currentTotal = 0;
    int subjectCount = 0;
    if (examList != null && !examList.isEmpty()) {
        subjectCount = examList.size();
        for (Examination e : examList) { currentTotal += e.getExamMark(); }
    }
    double currentAvg = (subjectCount > 0) ? (currentTotal / subjectCount) : 0;
    
    List<String> yearList = dao.getDistinctAcademicYearsByStudent(studIC);
    String selectedYear = request.getParameter("academicYear") != null ? 
                         request.getParameter("academicYear") : "2026";
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Academic Results - <%= student != null ? student.getStudName() : "" %></title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/homepage.css"><link rel="icon" type="image/webp" href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">
<style>
/* Shared Styles */
html, body {
	height: auto;
	overflow-y: auto;
	background-color: #f8f9fa;
	margin: 0;
}

.main-container {
	display: flex;
	flex-direction: column;
	align-items: center;
	padding: 40px 20px;
	min-height: 100vh;
}

.content-wrapper {
	width: 100%;
	max-width: 900px;
}

.report-header-box {
	background: white;
	padding: 30px;
	border-radius: 20px;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
	margin-bottom: 25px;
	border: 1px solid #e7d6c8;
}

.student-meta-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 15px;
	margin-top: 15px;
}

.results-card {
	background: white;
	border-radius: 20px;
	padding: 20px;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
	border: 1px solid #eee;
}

.grade-circle {
	width: 40px;
	height: 40px;
	border-radius: 50%;
	background: #8c8279;
	color: white;
	display: flex;
	align-items: center;
	justify-content: center;
	font-weight: bold;
	margin: 0 auto;
}

.filter-container {
	display: flex;
	justify-content: flex-end;
	margin: 20px 0;
}

.segmented-control {
	display: flex;
	background: #eeeae6;
	padding: 5px;
	border-radius: 50px;
	position: relative;
}

.segmented-control input[type="radio"] {
	display: none;
}

.segmented-control label {
	padding: 10px 25px;
	cursor: pointer;
	border-radius: 50px;
	font-size: 0.9rem;
	font-weight: 600;
	color: #8c8279;
	transition: 0.3s;
}

.segmented-control input[type="radio"]:checked+label {
	color: white;
	background: #5a4a42;
}

.btn-back {
	background: #333;
	color: white;
	padding: 10px 25px;
	border-radius: 25px;
	text-decoration: none;
	font-weight: bold;
}

/* Modal Fix */
.modal-overlay {
	display: none;
	position: fixed;
	inset: 0;
	background: rgba(0, 0, 0, 0.5);
	justify-content: center;
	align-items: center;
	z-index: 1000;
}

.modal-box {
	background: #e6d7cb;
	padding: 30px;
	border-radius: 15px;
	text-align: center;
}
/* Container for the filter */
.filter-wrapper {
    display: flex;
    align-items: center;
    background: #fdfaf8;
    padding: 10px 20px;
    border-radius: 50px;
    border: 1px solid #e7d6c8;
    box-shadow: 0 2px 8px rgba(0,0,0,0.02);
    display: inline-flex;
}

.filter-label {
    font-size: 0.9rem;
    font-weight: 700;
    color: #5a4a42;
    margin-right: 15px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.filter-select {
    padding: 8px 15px;
    border-radius: 12px;
    border: 1px solid #dcd0c5;
    background-color: white;
    color: #5a4a42;
    font-family: 'Inter', sans-serif;
    font-weight: 600;
    cursor: pointer;
    outline: none;
    transition: all 0.3s ease;
    min-width: 180px;
}

.filter-select:hover {
    border-color: #8c8279;
    background-color: #faf8f6;
}

.filter-select:focus {
    border-color: #5a4a42;
    box-shadow: 0 0 0 3px rgba(140, 130, 121, 0.1);
}
</style>
</head>
<body>

	<header class="header">
		<div class="header-left">
			<i style="cursor: pointer; margin-right: 15px;"></i> <span>Smart
				School System</span>
		</div>
		<div class="header-right">
			<div class="profile-area" id="profileBtn">
				<span class="user-name">Guardian</span> <img
					src="${pageContext.request.contextPath}/assets/image/adminICON.png"
					class="profile-image">
			</div>
			<div class="profile-menu" id="profileMenu" style="display: none;">
				<p id="logoutOption">
					<i class="fas fa-sign-out-alt"></i> Logout
				</p>
			</div>
		</div>
	</header>

	<div class="main-container"
		style="background: linear-gradient(rgba(255, 255, 255, 0.7), rgba(255, 255, 255, 0.7)), 
             url('<%=request.getContextPath()%>/assets/image/background2.jpg') no-repeat center center fixed; 
             background-size: cover; min-height: 120vh;">
		<div class="content-wrapper">
			<div
				style="display: flex; justify-content: center; margin-bottom: 20px;">
				<div class="segmented-control">
					<input type="radio" name="viewType" value="table" id="viewTable"
						checked onclick="toggleView('table')"> <label
						for="viewTable"><i class="fas fa-table"></i> Result</label> <input
						type="radio" name="viewType" value="graph" id="viewGraph"
						onclick="toggleView('graph')"> <label for="viewGraph"><i
						class="fas fa-chart-bar"></i> Graph</label>
				</div>
			</div>

			<div id="graphView" style="display: none;">
				<div style="margin-bottom: 20px; text-align: left;">
					<label class="filter-label"> <i style="margin-right: 8px;"></i> Track Subject Progress:
					</label> <select id="subjectGraphFilter"
						onchange="updateChartBySubject()" class="filter-select">
						<%
    List<Examination> allExamsList = (List<Examination>) request.getAttribute("allExams");
    if (allExamsList != null && !allExamsList.isEmpty()) {
        Set<String> uniqueSubjects = new HashSet<>();
        for (Examination e : allExamsList) {
            uniqueSubjects.add(e.getSubjectName()); 
        }
        for (String subName : uniqueSubjects) {
    %>
						<option value="<%= subName %>"><%= subName %></option>
						<% 
        }
    } else { 
    %>
						<option value="">No Subjects Found</option>
						<% } %>
					</select>
				</div>
				<div
					style="background: white; padding: 20px; border-radius: 20px; border: 1px solid #eee;">
					<canvas id="performanceChart" height="120"></canvas>
				</div>
			</div>

			<div id="tableView">
				<div class="report-header-box">
					<div
						style="display: flex; justify-content: space-between; align-items: flex-start;">
						<h2 style="margin: 0; color: #5a4a42;">
							<i class="fas fa-file-invoice" style="margin-right: 10px;"></i>Academic
							Results
						</h2>

						<form
							action="${pageContext.request.contextPath}/GuardianExaminationServlet"
							method="get" id="yearForm">
							<input type="hidden" name="id" value="<%=studIC%>"> <input
								type="hidden" name="examType" value="<%=examType%>"> <label
								style="font-weight: bold; color: #8c8279; font-size: 0.8rem;">SELECT
								YEAR:</label> <select name="academicYear" onchange="this.form.submit()"
								style="padding: 5px 15px; border-radius: 50px; border: 1px solid #e7d6c8; background: #fdfaf8; font-weight: bold; color: #5a4a42;">
								<%
								for (String yr : yearList) {
								%>
								<option value="<%=yr%>"
									<%=yr.equals(selectedYear) ? "selected" : ""%>><%=yr%></option>
								<%
								}
								%>
							</select>
						</form>
					</div>

					<div class="student-meta-grid">
						<div><strong>STUDENT NAME:</strong><br><%=student.getStudName().toUpperCase()%></div><div>
						</div>
					</div>
				</div>
				<div class="filter-container">
					<form
						action="${pageContext.request.contextPath}/GuardianExaminationServlet"
						method="get">
						<input type="hidden" name="id" value="<%=studIC%>"> <input
							type="hidden" name="academicYear" value="<%=selectedYear%>">

						<div class="segmented-control">
							<input type="radio" name="examType" value="Ujian 1" id="ujian1"
								<%="Ujian 1".equals(examType) ? "checked" : ""%>
								onchange="this.form.submit()"> <label for="ujian1">Ujian
								1</label> <input type="radio" name="examType" value="Mid-Term"
								id="midterm" <%="Mid-Term".equals(examType) ? "checked" : ""%>
								onchange="this.form.submit()"> <label for="midterm">Mid-Term</label>

							<input type="radio" name="examType" value="Final Exam" id="final"
								<%="Final Exam".equals(examType) ? "checked" : ""%>
								onchange="this.form.submit()"> <label for="final">Final
								Exam</label>
						</div>
					</form>
				</div>
				<div class="results-card">
					<table style="width: 100%; border-collapse: collapse;">
						<thead>
							<tr style="border-bottom: 2px solid #f0f0f0;">
								<th style="text-align: left; padding: 15px;">Subject Name</th>
								<th style="text-align: center; padding: 15px;">Marks</th>
								<th style="text-align: center; padding: 15px;">Grade</th>
							</tr>
						</thead>
						<tbody>
							<% if(examList != null && !examList.isEmpty()) { 
                                for(Examination e : examList) { %>
							<tr style="border-bottom: 1px solid #f9f9f9;">
								<td style="padding: 15px;"><strong><%= dao.getSubjectNameByID(e.getSubjectId()) %></strong></td>
								<td style="text-align: center; padding: 15px;"><%= (int) e.getExamMark() %></td>
								<td style="text-align: center; padding: 15px;"><div
										class="grade-circle"><%= e.getExamGrade() %></div></td>
							</tr>
							<% } } else { %>
							<tr>
								<td colspan="3"
									style="text-align: center; padding: 40px; color: #999;">No
									marks recorded for <%= examType %> yet.
								</td>
							</tr>
							<% } %>
						</tbody>
					</table>
				</div>
			</div>

			<div
				style="margin-top: 30px; display: flex; justify-content: flex-end;">
				<a
					href="${pageContext.request.contextPath}/StudentProfileServlet?id=<%=studIC%>"
					class="btn-back">Back</a>
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

	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<script>
const currentYear = "<%= request.getAttribute("currentAcademicYear") %>";
    
    const allExamsData = [
        <% 
        if(allExamsList != null) {
            for(Examination e : allExamsList) { 
        %>
        {
            subject: "<%= e.getSubjectName() %>",
            type: "<%= e.getExamType() %>",
            mark: <%= e.getExamMark() %>,
            year: "<%= e.getAcademicYear() %>"
        },
        <% 
            } 
        } 
        %>
    ].filter(item => item.year === currentYear);

    let myChart;

    function toggleView(view) {
        document.getElementById('tableView').style.display = (view === 'table') ? 'block' : 'none';
        document.getElementById('graphView').style.display = (view === 'graph') ? 'block' : 'none';
        
        if(view === 'graph') {
            // Delay slightly to ensure the DOM is visible before Chart.js renders
            setTimeout(() => {
                updateChartBySubject();
            }, 100);
        }
    }

    function renderChart(labels, marks, subjectName) {
        const ctx = document.getElementById('performanceChart').getContext('2d');
        if (myChart) myChart.destroy();
        myChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: subjectName + ' Progress',
                    data: marks,
                    backgroundColor: '#8c8279',
                    borderRadius: 5
                }]
            },
            options: { scales: { y: { beginAtZero: true, max: 100 } } }
        });
    }
    function updateChartBySubject() {
        const selectedSub = document.getElementById('subjectGraphFilter').value;
        if (!selectedSub) {
            showNoDataState();
            return;
        }

        const categories = ["Ujian 1", "Mid-Term", "Final Exam"];
        const chartMap = { "Ujian 1": 0, "Mid-Term": 0, "Final Exam": 0 };

        allExamsData.forEach(d => {
            if (d.subject === selectedSub && categories.includes(d.type)) {
                chartMap[d.type] = d.mark; 
            }
        });
        const labels = categories;
        const marks = categories.map(cat => chartMap[cat]);

        const hasData = marks.some(m => m > 0);

        if (!hasData) {
            showNoDataState();
        } else {
            document.getElementById('performanceChart').style.display = 'block';
            const oldMsg = document.getElementById('noDataMsg');
            if(oldMsg) oldMsg.remove();
            
            renderChart(labels, marks, selectedSub);
        }
    }
    function showNoDataState() {
        if (myChart) {
            myChart.destroy();
            myChart = null; // Ensure it's fully cleared
        }
        document.getElementById('performanceChart').style.display = 'none';
        
        let msgDiv = document.getElementById('noDataMsg');
        if (!msgDiv) {
            msgDiv = document.createElement('div');
            msgDiv.id = 'noDataMsg';
            msgDiv.className = 'results-card'; // Use your existing CSS for styling
            msgDiv.style.textAlign = 'center';
            msgDiv.style.padding = '40px';
            msgDiv.innerHTML = '<i class="fas fa-chart-area fa-3x" style="color:#ccc; margin-bottom:15px; display:block;"></i>' +
                               '<p>No progress data recorded for this subject yet.</p>';
            document.getElementById('performanceChart').parentNode.appendChild(msgDiv);
        }
    }
    // Profile Menu Logic
    const profileBtn = document.getElementById("profileBtn");
    const profileMenu = document.getElementById("profileMenu");
    profileBtn.onclick = (e) => {
        e.stopPropagation();
        profileMenu.style.display = profileMenu.style.display === "block" ? "none" : "block";
    };
    document.addEventListener("click", () => profileMenu.style.display = "none");
    document.getElementById('logoutOption').onclick = () => document.getElementById('logoutModal').style.display = 'flex';
    
 // Logout 
    const logoutOption = document.getElementById('logoutOption');
    const logoutModal = document.getElementById('logoutModal');
    const cancelLogout = document.getElementById('cancelLogout');
    const confirmLogout = document.getElementById('confirmLogout');

    logoutOption.addEventListener('click', () => logoutModal.style.display = 'flex');
    cancelLogout.addEventListener('click', () => logoutModal.style.display = 'none');
    confirmLogout.addEventListener('click', () => window.location.href = 'choice.html');

    // Close menu if clicking outside
    window.onclick = function(event) {
        if (!event.target.matches('#profileBtn') && !event.target.matches('.profile-image') && !event.target.matches('.user-name')) {
            document.getElementById("profileMenu").style.display = "none";
        }
    }
    </script>
</body>
</html>