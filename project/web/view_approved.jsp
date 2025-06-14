<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page import="utils.DBConnection" %>
<%
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Approved Vehicle Requests</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
<div class="page-wrapper">
    <jsp:include page="navbar.jsp" />
    <div class="container">
        
        <div style="display: flex; align-items: center; margin-bottom: 20px;">
            <img src="images/bhel_logo.png" alt="BHEL Logo" class="logo" style=" margin-top: 25px;">
            <h1>Approved Vehicle Requisition Requests</h1>
        </div>
        <table border="1" cellpadding="10" cellspacing="0" style="width:100%; text-align:left;">
            <tr style="background-color:#f0f0f0;">
                <th>ID</th>
                <th>Employee</th>
                <th>Vehicle No</th>
                <th>Type</th>
                <th>Valid From</th>
                <th>Valid To</th>
                <th>Status</th>
                <th>Approved By</th>
                <th>Final Approval</th>
            </tr>
    <%
        try {
            conn = DBConnection.getConnection();

            String sql = "SELECT * FROM vehicle_entry_requests WHERE status = 'Final Approved' ORDER BY senior_admin_approved_at DESC";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
    %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("employee_name") %></td>
                <td><%= rs.getString("vehicle_no") %></td>
                <td><%= rs.getString("vehicle_type") %></td>
                <td><%= rs.getDate("validity_from") %></td>
                <td><%= rs.getDate("validity_to") %></td>
                <td><%= rs.getString("status") %></td>
                <td><%= rs.getString("admin_approved_by") != null ? rs.getString("admin_approved_by") : "-" %></td>
                <td><%= rs.getString("senior_admin_approved_by") != null ? rs.getString("senior_admin_approved_by") : "-" %></td>
            </tr>
    <%
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='9' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (ps != null) try { ps.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    %>
        </table>
        <div class="options">
            <input type="button" value="Print" onclick="window.print()" class="btn">
            <a href="admin_home.jsp">Back to Dashboard</a>
        </div>
    </div>
    <jsp:include page="footer.jsp" />
</div>
</body>
</html>
