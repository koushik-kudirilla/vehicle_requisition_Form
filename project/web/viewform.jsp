<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page import="utils.DBConnection" %>

<%
    String staffNo = (String) session.getAttribute("staffNo");
    String designation = (String) session.getAttribute("designation");
    String requestId = request.getParameter("id");
    
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String employeeName = "";
    String requesterStaffNo = "";
    String requesterDesignation = "";
    String department = "";
    String vehicleNo = "";
    String vehicleType = "";
    String validFrom = "";
    String validTo = "";
    String justification = "";

    try {
        conn = DBConnection.getConnection();

        String sql = "SELECT * FROM vehicle_entry_requests WHERE id = ?";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, Integer.parseInt(requestId));
        rs = ps.executeQuery();

        if (rs.next()) {
            employeeName = rs.getString("employee_name");
            requesterStaffNo = rs.getString("staff_no");
            requesterDesignation = rs.getString("designation");
            department = rs.getString("department");
            vehicleNo = rs.getString("vehicle_no");
            vehicleType = rs.getString("vehicle_type");
            validFrom = rs.getString("validity_from");
            validTo = rs.getString("validity_to");
            justification = rs.getString("justification");
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Review Vehicle Request</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />
<div class="container">
    
    
    <div class="header">
            <img src="images/bhel_logo.png" alt="BHEL Logo" class="logo">
            <h1>BHARAT HEAVY ELECTRICALS LTD.</h1>
            <h2>HPVP, VISAKHAPATNAM – 530012</h2>
            <h3>(HUMAN RESOURCE MANAGEMENT)</h3>
            <h2 class="form-title">Review Vehicle Entry Request</h2>
      </div>
    <form action="<%= ("Senior Admin".equalsIgnoreCase(designation)) ? "final_process.jsp" : "process_request.jsp" %>" method="post">
        <input type="hidden" name="request_id" value="<%= requestId %>">

        <label>Name of Employee:</label>
        <input type="text" value="<%= employeeName %>" readonly>

        <label>Staff No:</label>
        <input type="text" value="<%= requesterStaffNo %>" readonly>

        <label>Designation / Grade:</label>
        <input type="text" value="<%= requesterDesignation %>" readonly>

        <label>Department:</label>
        <input type="text" value="<%= department %>" readonly>

        <label>Vehicle No:</label>
        <input type="text" value="<%= vehicleNo %>" readonly>

        <label>Type of Vehicle:</label>
        <input type="text" value="<%= vehicleType %>" readonly>

        <label>Validity From:</label>
        <input type="text" value="<%= validFrom %>" readonly>

        <label>Validity To:</label>
        <input type="text" value="<%= validTo %>" readonly>

        <label>Justification:</label>
        <textarea rows="4" readonly><%= justification %></textarea>

        <input type="hidden" name="action" value="approve">
        <input type="submit" value="Approve">
    </form>
    <br>
    <form id="rejectForm" action="<%= ("Senior Admin".equalsIgnoreCase(designation)) ? "final_process.jsp" : "process_request.jsp" %>" method="post">
        <input type="hidden" name="request_id" value="<%= requestId %>">
        <input type="hidden" name="action" value="reject">

        <!-- Initially hidden -->
        <div id="rejectionReasonWrapper" style="display:none; margin-top:10px; grid-column: span 2; align-items: center;">
            <label for="reason" style="width: 160px; font-weight: 600;">Rejection Reason:</label>
            <textarea name="reason" id="reasonInput" required style="width: 100%; resize: vertical;"></textarea>
        </div>

        <button type="button" id="rejectButton" onclick="showRejectionReason()">Reject</button>
        <button type="submit" id="confirmRejectButton" style="display:none;">Confirm Reject</button>
    </form>   
    
</div>
        <jsp:include page="footer.jsp" />

<script>
    function showRejectionReason() {
        // Show the rejection reason form and hide the reject button
        document.getElementById("rejectionReasonWrapper").style.display = "flex"; // Show the reason input
        document.getElementById("rejectButton").style.display = "none";  // Hide the Reject button
        document.getElementById("confirmRejectButton").style.display = "inline-block";  // Show the confirm button
    }
</script>


</body>
</html>
