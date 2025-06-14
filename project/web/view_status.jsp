<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page import="utils.DBConnection" %>
<%
    String staffNo = (String) session.getAttribute("staffNo");
    
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View My Vehicle Requests</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
<div class="page-wrapper">
    <jsp:include page="navbar.jsp" />
    <div class="container">
        <h1>My Vehicle Requisition Requests</h1>
        <table border="1" cellpadding="10" cellspacing="0" style="width:100%; text-align:left;">
            <tr style="background-color:#f0f0f0;">
                <th>Request ID</th>
                <th>Vehicle No</th>
                <th>Type</th>
                <th>Valid From</th>
                <th>Valid To</th>
                <th>Status</th>
            </tr>
    <%
        try {
            conn = DBConnection.getConnection();

            String sql = "SELECT id, vehicle_no, vehicle_type, validity_from, validity_to, status FROM vehicle_entry_requests WHERE staff_no = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, staffNo);
            rs = ps.executeQuery();

            while (rs.next()) {
    %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("vehicle_no") %></td>
                <td><%= rs.getString("vehicle_type") %></td>
                <td><%= rs.getDate("validity_from") %></td>
                <td><%= rs.getDate("validity_to") %></td>
                <td><%= rs.getString("status") != null ? rs.getString("status") : "Pending" %></td>
            </tr>
    <%
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='6' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (ps != null) try { ps.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    %>
        </table>
        <div class="options">
            <input type="button" value="Print" onclick="window.print()" class="btn">
            <a href="user_home.jsp">Back to Dashboard</a>
        </div>
    </div>
    <jsp:include page="footer.jsp" />
</div>
</body>
</html>
