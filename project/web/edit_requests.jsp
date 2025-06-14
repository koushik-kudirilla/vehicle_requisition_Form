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
    <title>Edit Requests - Admin</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
<div class="page-wrapper">
    <jsp:include page="navbar.jsp" />
    <div class="container">
        <h1>Requested Edits - Vehicle Requisitions</h1>
        <table border="1" cellpadding="10" cellspacing="0" style="width:100%; text-align:left;">
            <tr style="background-color:#f0f0f0;">
                <th>ID</th>
                <th>Employee</th>
                <th>Vehicle No</th>
                <th>Type</th>
                <th>Valid From</th>
                <th>Valid To</th>
                <th>Justification</th>
                <th>Action</th>
            </tr>
    <%
        try {
            conn = DBConnection.getConnection();
     
            String sql = "SELECT * FROM vehicle_entry_requests WHERE editstatus = 'Requested'";
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
                <td><%= rs.getString("justification") %></td>
                <td>
                    <a href="approve_edit.jsp?id=<%= rs.getInt("id") %>" class="button-link">Approve Edit</a>
                </td>
            </tr>
    <%
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='8' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (ps != null) try { ps.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    %>
        </table>
        <div class="options">
            <a href="admin_home.jsp">Back to Dashboard</a>
        </div>
    </div>
    <jsp:include page="footer.jsp" />
</div>
</body>
</html>
