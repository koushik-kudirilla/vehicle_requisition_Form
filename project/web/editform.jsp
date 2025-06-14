<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>

<%
    String staffNo = (String) session.getAttribute("staffNo");
    String name = (String) session.getAttribute("employeeName");
    String designation = (String) session.getAttribute("designation");
    String department = (String) session.getAttribute("department");

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String vehicleNo = "", vehicleType = "", validFrom = "", validTo = "", justification = "";
    String editStatus = "None";
    boolean formVisible = false;

    // Handle 'Send Request to Edit' action
    if ("requestEdit".equals(request.getParameter("action"))) {
        try {
            conn = DBConnection.getConnection();
            String updateSql = "UPDATE vehicle_entry_requests SET editstatus = 'Requested' WHERE staff_no = ?";
            ps = conn.prepareStatement(updateSql);
            ps.setString(1, staffNo);
            ps.executeUpdate();
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error requesting edit: " + e.getMessage() + "</p>");
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    // Fetch current request and edit status
    try {
        conn = DBConnection.getConnection();
        String selectSql = "SELECT * FROM vehicle_entry_requests WHERE staff_no = ?";
        ps = conn.prepareStatement(selectSql);
        ps.setString(1, staffNo);
        rs = ps.executeQuery();
        if (rs.next()) {
            vehicleNo = rs.getString("vehicle_no");
            vehicleType = rs.getString("vehicle_type");
            validFrom = rs.getString("validity_from");
            validTo = rs.getString("validity_to");
            justification = rs.getString("justification");
            editStatus = rs.getString("editstatus");

            if ("Approved".equalsIgnoreCase(editStatus)) {
                formVisible = true;
            }
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error retrieving existing request: " + e.getMessage() + "</p>");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Vehicle Requisition</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
<div class="page-wrapper">
    <jsp:include page="navbar.jsp" />
    <div class="container">


        <% if (editStatus == null || "None".equalsIgnoreCase(editStatus)) { %>
            <form method="post">
                <h2>Edit Vehicle Requisition</h2>
                <input type="hidden" name="action" value="requestEdit">
                <input type="submit" value="Send Request to Edit">
            </form>
            <p>Status: <strong>None</strong></p>

        <% } else if ("Requested".equalsIgnoreCase(editStatus)) { %>
        
            <form >
                <h2>Edit Vehicle Requisition</h2>
                <button type="button" class="btn disabled" disabled style="background-color: #ccc; color: #666; cursor: not-allowed; grid-column: span 2;">Request Sent</button>
                <p>Status: <strong>Requested</strong></p>
            </form>

        <% } else if (formVisible) { %>
            <div class="header">
                <img src="images/bhel_logo.png" alt="BHEL Logo" class="logo">
                <h1>BHARAT HEAVY ELECTRICALS LTD.</h1>
                <h2>HPVP, VISAKHAPATNAM - 530012</h2>
                <h3>(HUMAN RESOURCE MANAGEMENT)</h3>
                <h2 class="form-title">Edit Vehicle Requisition</h2>
            </div>
            <form method="post" action="edit_submit.jsp">
                <label for="employeeName">Name of Employee:</label>
                <input type="text" value="<%= name %>" readonly>

                <label for="staffNo">Staff No:</label>
                <input type="text" value="<%= staffNo %>" readonly>

                <label for="designation">Designation:</label>
                <input type="text" value="<%= designation %>" readonly>

                <label for="department">Department:</label>
                <input type="text" value="<%= department %>" readonly>

                <label for="vehicleNo">Vehicle No:</label>
                <input type="text" name="vehicleNo" value="<%= vehicleNo %>" required>

                <label for="vehicleType">Vehicle Type:</label>
                <select name="vehicleType" required>
                    <option value="">-- Select --</option>
                    <option value="2-Wheeler" <%= "2-Wheeler".equals(vehicleType) ? "selected" : "" %>>2-Wheeler</option>
                    <option value="4-Wheeler" <%= "4-Wheeler".equals(vehicleType) ? "selected" : "" %>>4-Wheeler</option>
                </select>

                <label for="validFrom">Validity From:</label>
                <input type="date" name="validFrom" value="<%= validFrom %>" required>

                <label for="validTo">Validity To:</label>
                <input type="date" name="validTo" value="<%= validTo %>" required>

                <label for="justification">Justification:</label>
                <textarea name="justification" required><%= justification %></textarea>

                <input type="submit" value="Update Form">
            </form>
        <% } else { %>
            <p style="color: orange;">Waiting for edit approval...</p>
        <% } %>
    </div>
    <jsp:include page="footer.jsp" />
</div>
</body>
</html>
