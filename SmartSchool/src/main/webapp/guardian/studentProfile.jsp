<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Smart School System - Guardian Student Profile</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <link rel="stylesheet" href="../assets/css/validate.css" />
    <link rel="icon" type="image/webp" href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">
  </head>

  <body>
    <header class="header">
      <div class="header-left">
        <i class="fas fa-bars menu-toggle-icon" id="menu-toggle"></i>
        <span>Smart School System</span>
      </div>
      <div class="header-right">
        <div class="profile-area" id="profileBtn">
          <span class="user-name">Guardian</span>
          <img
            src="../assets/image/adminICON.png"
            alt="Admin Profile"
            class="profile-image"
          />
        </div>
        <div class="profile-menu" id="profileMenu">
          <p id="darkToggle"><i class="fas fa-moon"></i> Dark Mode</p>
          <p id="logoutOption"><i class="fas fa-sign-out-alt"></i> Logout</p>
        </div>
      </div>
    </header>

     <div class="main-container" style="background: linear-gradient(rgba(255, 255, 255, 0.7), rgba(255, 255, 255, 0.7)), 
             url('<%=request.getContextPath()%>/assets/image/background2.jpg') no-repeat center center fixed; 
             background-size: cover; min-height: 120vh;">
      <aside class="sidebar" id="sidebar">
        <ul class="sidebar-menu">
          <li>
            <a href="guardianHomepage.html" class="menu-item"
              ><i class="fas fa-home icon"></i>
              <span class="link-text">Home</span></a
            >
          </li>
        </ul>
      </aside>

      <main class="content">
        <div class="breadcrumb-studentProfile">
          Hi, Guardian <span class="breadcrumb-separator">&gt;</span>
          <span class="current-page">Student Profile</span>
        </div>
        <div class="profile-header">
          <div class="student-info">STUDENT NAME: ISMID SUMBUL BIN FARIS</div>
        </div>

        <div class="card-grid">
          <div
            class="dashboard-card profile-card"
            onclick="location.href='studentProfileEdit.html'"
          >
            <div class="card-icon"><i class="fas fa-user-check"></i></div>
            <p>View Student Profile</p>
          </div>

          <div
            class="dashboard-card exam-card"
            onclick="location.href='examinationGuardian.html'"
          >
            <div class="card-icon"><i class="fas fa-file-alt"></i></div>
            <p>View Examination Mark</p>
          </div>

          <div
            class="dashboard-card attendance-card"
            onclick="location.href='attendanceGuardian.html'"
          >
            <div class="card-icon"><i class="fas fa-clipboard-list"></i></div>
            <p>View Attendance Record</p>
          </div>
        </div>
      </main>
    </div>

    <div id="logoutModal" class="modal-overlay">
      <div class="modal-box">
        <h3>Confirm Logout</h3>
        <p>Do you want to logout from this account?</p>
        <div class="modal-buttons">
          <button class="modal-btn btn-cancel" id="cancelLogout">Cancel</button>
          <button class="modal-btn btn-reject" id="confirmLogout">
            Logout
          </button>
        </div>
      </div>
    </div>

    <script>
      // Sidebar Toggle
      const menuToggle = document.getElementById("menu-toggle");
      const sidebar = document.getElementById("sidebar");
      menuToggle.addEventListener("click", () => {
        sidebar.classList.toggle("collapsed");
      });

      // Profile Menu Toggle
      const profileBtn = document.getElementById("profileBtn");
      const profileMenu = document.getElementById("profileMenu");
      profileBtn.addEventListener("click", (e) => {
        e.stopPropagation();
        profileMenu.style.display =
          profileMenu.style.display === "block" ? "none" : "block";
      });

      // Close dropdown on outside click
      window.addEventListener("click", () => {
        profileMenu.style.display = "none";
      });

      // Logout
      const logoutOption = document.getElementById("logoutOption");
      const logoutModal = document.getElementById("logoutModal");
      const cancelLogout = document.getElementById("cancelLogout");
      const confirmLogout = document.getElementById("confirmLogout");

      logoutOption.addEventListener(
        "click",
        () => (logoutModal.style.display = "flex")
      );
      cancelLogout.addEventListener(
        "click",
        () => (logoutModal.style.display = "none")
      );
      confirmLogout.addEventListener(
        "click",
        () => (window.location.href = "../choice.html")
      );

      // Dark Mode Toggle
      document.getElementById("darkToggle").addEventListener("click", () => {
        document.body.classList.toggle("dark-theme");
      });
    </script>
  </body>
</html>
