<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Smart School System - edit student profile</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <link rel="stylesheet" href="../assets/css/homepage.css" />
    <link rel="icon" type="image/webp" href="<%=request.getContextPath()%>/assets/image/sksmLOGO.webp">
    <style>
      /* PROFILE SPECIFIC STYLES */
      .profile-grid {
        display: grid;
        grid-template-columns: 320px 1fr;
        gap: 30px;
        max-width: 1100px;
        margin: 0 auto;
      }

      /* Left Side Card */
      .profile-card-left {
        background: white;
        padding: 40px 20px;
        border-radius: 20px;
        text-align: center;
        border: 1px solid #e6d7cb;
        height: fit-content;
      }

      .profile-img-container {
        position: relative;
        width: 160px;
        height: 160px;
        margin: 0 auto 20px;
      }

      .profile-img-large {
        width: 100%;
        height: 100%;
        border-radius: 50%;
        object-fit: cover;
        border: 4px solid #8c8279;
      }

      .profile-card-left h2 {
        font-size: 1.4rem;
        color: #333;
        margin-bottom: 5px;
      }

      .profile-card-left p {
        color: #888;
        font-size: 0.9rem;
        margin-bottom: 20px;
      }

      /* Right Side Details */
      .profile-details-right {
        background: white;
        padding: 40px;
        border-radius: 20px;
        border: 1px solid #e6d7cb;
      }

      .info-row {
        display: grid;
        grid-template-columns: 200px 1fr;
        padding: 15px 0;
        border-bottom: 1px solid #f0f0f0;
        align-items: center;
      }

      .info-row:last-child {
        border-bottom: none;
      }

      .label {
        font-weight: 600;
        color: #8c8279;
        text-transform: uppercase;
        font-size: 0.8rem;
        letter-spacing: 0.5px;
      }

      .value {
        color: #333;
        font-size: 1rem;
      }

      .password-display {
        font-family: monospace;
        background: #f9f9f9;
        padding: 4px 8px;
        border-radius: 4px;
      }

      /* Action Buttons */
      .profile-actions {
        margin-top: 30px;
        display: flex;
        gap: 15px;
        justify-content: flex-end;
      }

      .btn-edit {
        background-color: #8c8279;
        color: white;
        padding: 12px 25px;
        border: none;
        border-radius: 25px;
        font-weight: bold;
        cursor: pointer;
        transition: 0.3s;
        display: flex;
        align-items: center;
        gap: 10px;
      }

      .btn-edit:hover {
        background-color: #746260;
        transform: translateY(-2px);
      }

      /* Responsive */
      @media (max-width: 850px) {
        .profile-grid {
          grid-template-columns: 1fr;
        }
      }
    </style>
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
            alt="Profile"
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
             background-size: cover; min-height: 80vh;">
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
          <span class="current-page">Edit Student Profile</span>
        </div>
        <div class="profile-header">
          <div class="student-info">STUDENT NAME: ISMID SUMBUL BIN FARIS</div>
        </div>

        <div class="profile-grid">
          <div class="profile-card-left">
            <div class="profile-img-container">
              <img
                src="../assets/image/adminICON.png"
                alt="Teacher"
                class="profile-img-large"
              />
            </div>
            <h2>ISMID SUMBUL</h2>
            <p>Student</p>
            <hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0" />
            <p style="color: #555">Member since Jan 2024</p>
          </div>

          <div class="profile-details-right">
            <div class="info-row">
              <div class="label">Full Name</div>
              <div class="value">ISMID SUMBUL BIN FARIS</div>
            </div>
            <div class="info-row">
              <div class="label">Identity Card (IC) Number</div>
              <div class="value">180111-05-0047</div>
            </div>
            <div class="info-row">
              <div class="label">Year</div>
              <div class="value">1</div>
            </div>
            <div class="info-row">
              <div class="label">Class</div>
              <div class="value">IBNU SINAR</div>
            </div>
            <div class="info-row">
              <div class="label">Date of Birth</div>
              <div class="value">1 November 2018</div>
            </div>
            <div class="info-row">
              <div class="label">Gender</div>
              <div class="value">MALE</div>
            </div>
            <div class="info-row">
              <div class="label">Address</div>
              <div id="displayAddress" class="value">
                NO. 69, JALAN BAHAGIA SELALU, 75460 MELAKA
              </div>
            </div>

            <div class="profile-actions">
              <button class="btn-edit" onclick="openEditModal()">
                <i class="fas fa-user-edit"></i> Update Profile
              </button>
            </div>
          </div>
        </div>
        <div class="student-exam-footer-actions">
          <button
            class="student-exam-btn-back"
            onclick="location.href='studentProfile.html'"
          >
            BACK
          </button>
        </div>
      </main>
    </div>

    <div id="editProfileModal" class="modal-overlay">
      <div class="modal-box" style="width: 450px; text-align: left">
        <h3 style="margin-bottom: 20px; text-align: center">Update Profile</h3>

        <div class="filter-group" style="margin-bottom: 15px">
          <label>Address</label>
          <input
            type="text"
            id="editAddress"
            value=""
            style="
              width: 100%;
              padding: 10px;
              border-radius: 8px;
              border: 1px solid #ddd;
            "
          />
        </div>

        <div class="modal-buttons" style="justify-content: flex-end; gap: 10px">
          <button class="modal-btn btn-cancel" onclick="closeEditModal()">
            Cancel
          </button>
          <button
            class="modal-btn btn-approve"
            onclick="saveProfile()"
            style="background-color: #8c8279"
          >
            Save Changes
          </button>
        </div>
      </div>
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
      // --- SIDEBAR & MENU LOGIC ---
      const menuToggle = document.getElementById("menu-toggle");
      const sidebar = document.getElementById("sidebar");

      menuToggle.addEventListener("click", () =>
        sidebar.classList.toggle("collapsed")
      );

      const profileBtn = document.getElementById("profileBtn");
      const profileMenu = document.getElementById("profileMenu");

      profileBtn.addEventListener("click", (e) => {
        e.stopPropagation();
        profileMenu.style.display =
          profileMenu.style.display === "block" ? "none" : "block";
      });

      document.addEventListener(
        "click",
        () => (profileMenu.style.display = "none")
      );

      // --- LOGOUT LOGIC ---
      const logoutOption = document.getElementById("logoutOption");
      const logoutModal = document.getElementById("logoutModal");

      logoutOption.addEventListener(
        "click",
        () => (logoutModal.style.display = "flex")
      );

      document.getElementById("cancelLogout").addEventListener("click", () => {
        logoutModal.style.display = "none";
      });

      document.getElementById("confirmLogout").addEventListener("click", () => {
        window.location.href = "../choice.html";
      });

      // --- DARK MODE ---
      document.getElementById("darkToggle").addEventListener("click", () => {
        document.body.classList.toggle("dark-theme");
      });

      // --- PROFILE UPDATE LOGIC ---
      const editModal = document.getElementById("editProfileModal");

      /**
       * Opens the edit modal and pre-fills the input with
       * the current address displayed on the page.
       */
      function openEditModal() {
        // Find the current address on the screen
        // We use index [6] because Address is the 7th '.value' element
        const currentAddress = document
          .querySelectorAll(".value")[6]
          .innerText.trim();

        // Set the input field to match current address
        document.getElementById("editAddress").value = currentAddress;

        editModal.style.display = "flex";
      }

      /**
       * Closes the edit modal.
       */
      function closeEditModal() {
        editModal.style.display = "none";
      }

      /**
       * Saves the new address to the UI.
       */
      function saveProfile() {
        const newAddress = document.getElementById("editAddress").value;

        if (newAddress.trim() === "") {
          alert("Please enter a valid address.");
          return;
        }

        // Update the UI: Index 6 corresponds to the Address row
        const valueElements = document.querySelectorAll(".value");
        if (valueElements[6]) {
          valueElements[6].innerText = newAddress;
          alert("Profile Updated Successfully!");
        }

        closeEditModal();
      }

      // Close modal if user clicks anywhere outside of the modal box
      window.onclick = function (event) {
        if (event.target == editModal) {
          closeEditModal();
        }
        if (event.target == logoutModal) {
          logoutModal.style.display = "none";
        }
      };
    </script>
  </body>
</html>
