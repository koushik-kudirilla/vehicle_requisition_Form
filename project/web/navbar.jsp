<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" %>
<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>
<%
    String userRole = (String) session.getAttribute("designation");
    String userStaffNo = (String) session.getAttribute("staffNo");
    if (userRole == null) userRole = "guest";

    boolean navbarHasApproved = false;
    boolean navbarAllowEdit = false;
    String navbarApprovedRequestId = null;
    String navbarEditRequestId = null;

    if ("user".equalsIgnoreCase(userRole) && userStaffNo != null) {
        Connection navbarConn = null;
        PreparedStatement navbarPs = null;
        ResultSet navbarRs = null;

        try {
            navbarConn = DBConnection.getConnection();

            // Check for approved request
            String approvedSql = "SELECT id FROM vehicle_entry_requests WHERE staff_no = ? AND status = 'Final Approved'";
            navbarPs = navbarConn.prepareStatement(approvedSql);
            navbarPs.setString(1, userStaffNo);
            navbarRs = navbarPs.executeQuery();
            if (navbarRs.next()) {
                navbarHasApproved = true;
                navbarApprovedRequestId = navbarRs.getString("id");
            }

            navbarRs.close();
            navbarPs.close();

            // Check for editable request
            String editSql = "SELECT id FROM vehicle_entry_requests WHERE staff_no = ? AND status != 'Final Approved'";
            navbarPs = navbarConn.prepareStatement(editSql);
            navbarPs.setString(1, userStaffNo);
            navbarRs = navbarPs.executeQuery();
            if (navbarRs.next()) {
                navbarAllowEdit = true;
                navbarEditRequestId = navbarRs.getString("id");
            }

        } catch (Exception e) {
            out.println("<p style='color:red;'>Navbar error: " + e.getMessage() + "</p>");
        } finally {
            try { if (navbarRs != null) navbarRs.close(); } catch (Exception e) {}
            try { if (navbarPs != null) navbarPs.close(); } catch (Exception e) {}
            try { if (navbarConn != null) navbarConn.close(); } catch (Exception e) {}
        }
    }
%>

<head>
    <style>
        .navbar {
            background-color: #003366;
            color: white;
            padding: 10px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .navbar-logo {
            height: 50px;
        }

        .brand-text {
            font-size: 20px;
            font-weight: bold;
            color: white;
        }

        .nav-links a {
            color: white;
            margin-left: 20px;
            text-decoration: none;
            font-weight: 500;
        }

        .nav-links a:hover {
            text-decoration: underline;
        }

        .footer {
            text-align: center;
            padding: 15px;
            font-size: 14px;
            margin-top: 40px;
            color: #333;
        }
        .navbar-left {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .nav-item.user-dropdown {
            position: relative;
            display: flex;
            align-items: center;
            gap: 8px;
            color: white;
            cursor: pointer;
            font-weight: 500;
            padding: 8px 12px;
            border-radius: 4px;
            transition: background-color 0.3s;
        }

        .user-avatar {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            object-fit: cover;
            border: 1px solid #fff;
        }

        .dropdown-menu {
            display: none;
            position: absolute;
            top: 100%;
            right: 0;
            background-color: white;
            color: #333;
            border-radius: 6px;
            min-width: 160px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            z-index: 100;
        }

        .dropdown-menu a {
            display: block;
            padding: 12px 16px;
            text-decoration: none;
            color: #333;
            font-size: 14px;
        }

        .dropdown-menu a:hover {
            background-color: #f5f5f5;
        }

        .user-dropdown.open .dropdown-arrow {
            transform: rotate(90deg);
        }



    </style>
</head>
<div class="navbar">
    <div class="navbar-left">
        <img src="images/bhel_logo.png" alt="BHEL Logo" class="navbar-logo">
        <span class="brand-text">BHEL Vehicle Pass System</span>
    </div>
    <div class="nav-links" style="display: flex; align-items: center; gap: 20px; position: relative;">
    <% if ("user".equalsIgnoreCase(userRole)) { %>
        <a href="user_home.jsp">Home</a>
        <a href="form.jsp">Request Pass</a>
        <a href="view_status.jsp">My Requests</a>
        <% if (navbarHasApproved) { %>
            <a href="vehicle_log_sheet.jsp?id=<%= navbarApprovedRequestId %>">Log Sheet</a>
        <% } %>
        <% if (navbarAllowEdit && !navbarHasApproved) { %>
            <a href="editform.jsp?id=<%= navbarEditRequestId %>">Edit Form</a>
        <% } %>
    <% } else if ("admin".equalsIgnoreCase(userRole)) { %>
        <a href="admin_home.jsp">Home</a>
        <a href="pending_requests.jsp">Pending Requests</a>
        <a href="edit_requests.jsp">Edit Requests</a>
    <% } else if ("senior admin".equalsIgnoreCase(userRole)) { %>
        <a href="senior_admin_home.jsp">Home</a>
        <a href="final_approvals.jsp">Final Approvals</a>
        <a href="report.jsp">Reports</a>
    <% } %>

    <!-- User dropdown here -->
    <div class="nav-item user-dropdown" onclick="toggleDropdown(event)">
        <img src="images/profile.png" alt="User Avatar" class="user-avatar">
        <span class="dropdown-arrow" id="dropdownArrow">▶</span>
        <span class="user-name"><%= session.getAttribute("employeeName") != null ? session.getAttribute("employeeName") : "Santhosh" %></span>

        <div class="dropdown-menu" id="dropdownMenu">
            <a href="profile.jsp">👤 Profile</a>
            <a href="settings.jsp">⚙️ Settings</a>
            <a href="logout.jsp">🚪 Logout</a>
        </div>
    </div>
</div>

</div>
<script>
    function toggleDropdown(e) {
        const dropdown = e.currentTarget;
        const menu = dropdown.querySelector(".dropdown-menu");
        const arrow = dropdown.querySelector(".dropdown-arrow");

        const isOpen = dropdown.classList.contains("open");

        document.querySelectorAll(".user-dropdown").forEach(d => {
            d.classList.remove("open");
            d.querySelector(".dropdown-menu").style.display = "none";
        });

        if (!isOpen) {
            dropdown.classList.add("open");
            menu.style.display = "block";
        } else {
            dropdown.classList.remove("open");
            menu.style.display = "none";
        }
    }

    document.addEventListener("click", function (event) {
        if (!event.target.closest('.user-dropdown')) {
            document.querySelectorAll(".user-dropdown").forEach(d => {
                d.classList.remove("open");
                d.querySelector(".dropdown-menu").style.display = "none";
            });
        }
    });
</script>
