<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>

<%
    String name = (String) session.getAttribute("employeeName");
    String staffNo = (String) session.getAttribute("staffNo");
    String editRequestId = null;
    String approvedRequestId = null;
    boolean allowEdit = false;
    boolean hasApproved = false;
    
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Dashboard</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
<div class="page-wrapper">
    <jsp:include page="navbar.jsp" />

    <div class="container">
        <h1>Welcome, <%= name %> (Staff No: <%= staffNo %>)</h1>
        <h2>User Portal</h2>
        <div class="options">
        <a href="form.jsp">Submit Vehicle Requisition</a>
        <a href="view_status.jsp">View My Requests</a>

        <%

            try {
                Connection  conn = DBConnection.getConnection();
                String sql = "SELECT * FROM vehicle_entry_requests WHERE staff_no = ? AND status = 'Final Approved'";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, staffNo);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    hasApproved = true;
                    approvedRequestId  = rs.getString("id"); 
                }

                rs.close();
                ps.close();
                conn.close();
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error checking approval status: " + e.getMessage() + "</p>");
            }

            if (hasApproved) {
        %>
            <a href="vehicle_log_sheet.jsp?id=<%= approvedRequestId  %>">Fill Vehicle Log Sheet</a>
        <%
            }
        %>

         <%

            try {
                Connection conn = DBConnection.getConnection();
                String editCheckSql = "SELECT * FROM vehicle_entry_requests WHERE staff_no = ? AND status != 'Final Approved'";
                PreparedStatement editPs = conn.prepareStatement(editCheckSql);
                editPs.setString(1, staffNo);
                ResultSet editRs = editPs.executeQuery();
                if (editRs.next()) {
                    allowEdit = true;
                    editRequestId  = editRs.getString("id");
                }

                editRs.close();
                editPs.close();
                conn.close();
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error checking editable request: " + e.getMessage() + "</p>");
            }

            if (allowEdit && !hasApproved) {
        %>
            <a href="editform.jsp?id=<%= editRequestId %>">Edit Form</a>
        <%
            }
        %>

        <a href="logout.jsp" style ="background-color: red;">Logout</a>
    </div>

    </div>
    <jsp:include page="footer.jsp" />
</div>
</body>
</html> 