<!DOCTYPE html>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="utils.DBConnection" %>
<%
    String employeeName = (String) session.getAttribute("employeeName");
    String staffNo = (String) session.getAttribute("staffNo");
    if (employeeName == null || staffNo == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String designation = (String) session.getAttribute("designation");
    String department = (String) session.getAttribute("department");
%>

<html>
<head>
    <title>Vehicle Entry Requisition</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
   
</head>
<body>
<div class="page-wrapper">
    <jsp:include page="navbar.jsp" />
    <div class="container">
        <%
            boolean alreadySubmitted = false; 
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                conn = DBConnection.getConnection();


                String checkSql = "SELECT COUNT(*) FROM vehicle_entry_requests WHERE staff_no = ?";
                ps = conn.prepareStatement(checkSql);
                ps.setString(1, staffNo);
                rs = ps.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    alreadySubmitted = true;
                }
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error checking request: " + e.getMessage() + "</p>");
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (ps != null) ps.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }

            if (alreadySubmitted) {
        %>
                <h2 style="text-align:center; color: orange;">You have already submitted a vehicle entry request.</h2>
                <p style="text-align:center;">Redirecting to dashboard...</p>
                <script>setTimeout(() => { window.location.href = 'user_home.jsp'; }, 3000);</script>
        <%
            } else {
        %>
        <div class="header">
            <img src="images/bhel_logo.png" alt="BHEL Logo" class="logo">
            <h1>BHARAT HEAVY ELECTRICALS LTD.</h1>
            <h2>HPVP, VISAKHAPATNAM – 530012</h2>
            <h3>(HUMAN RESOURCE MANAGEMENT)</h3>
            <h2 class="form-title">REQUISITION FOR VEHICLE ENTRY PASS</h2>
        </div>

        <form method="post">
            <label for="employeeName">Name of Employee:</label>
            <input type="text" id="employeeName" name="employeeName" value="<%= employeeName %>" readonly required>

            <label for="staffNo">Staff No:</label>
            <input type="text" id="staffNo" name="staffNo" value="<%= staffNo %>" readonly required>

            <label for="designation">Designation / Grade:</label>
            <input type="text" id="designation" name="designation" value="<%= designation %>" readonly required>

            <label for="department">Department:</label>
            <input type="text" id="department" name="department" value="<%= department %>" readonly required>

            <label for="vehicleNo">Vehicle No:</label>
            <input type="text" id="vehicleNo" name="vehicleNo" required>

            <label for="vehicleType">Type of Vehicle:</label>
            <select id="vehicleType" name="vehicleType" required>
                <option value="">-- Select Type --</option>
                <option value="2-Wheeler">2-Wheeler</option>
                <option value="4-Wheeler">4-Wheeler</option>
            </select>

            <label for="validFrom">Validity From:</label>
            <input type="date" id="validFrom" name="validFrom" required>

            <label for="validTo">Validity To:</label>
            <input type="date" id="validTo" name="validTo" required>

            <label for="justification">Justification:</label>
            <textarea id="justification" name="justification" rows="4" required></textarea>

            <input type="submit" value="Submit Request">
        </form>
        <%
            } 
        %>

    <%
        if ("post".equalsIgnoreCase(request.getMethod()) && !alreadySubmitted) {

            String vehicleNo = request.getParameter("vehicleNo");
            String vehicleType = request.getParameter("vehicleType");
            String validFrom = request.getParameter("validFrom");
            String validTo = request.getParameter("validTo");
            String justification = request.getParameter("justification");


            try {
                conn = DBConnection.getConnection();
                
                String sql = "INSERT INTO vehicle_entry_requests (employee_name, staff_no, designation, department, vehicle_no, vehicle_type, validity_from, validity_to, justification) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                ps = conn.prepareStatement(sql);
                ps.setString(1, employeeName);
                ps.setString(2, staffNo);
                ps.setString(3, designation);
                ps.setString(4, department);
                ps.setString(5, vehicleNo);
                ps.setString(6, vehicleType);
                ps.setString(7, validFrom);
                ps.setString(8, validTo);
                ps.setString(9, justification);

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    out.println("<p style='color: green; text-align: center;'><strong>Form submitted successfully. Redirecting to Dashboard...</strong></p>");
                    out.println("<script>setTimeout(() => { window.location.href = 'user_home.jsp'; }, 3000);</script>");
                } else {
                    out.println("<p style='color: red; text-align: center;'><strong>Submission failed. Try again.</strong></p>");
                }
            } catch (Exception e) {
                out.println("<p style='color: red; text-align: center;'>Error: " + e.getMessage() + "</p>");
            } finally {
                try { if (ps != null) ps.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        }
    %>
    </div>
    <jsp:include page="footer.jsp" />
</div>
</body>
</html>
