<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page import="utils.DBConnection" %>

<%
    String staffNo = (String) session.getAttribute("staffNo");

    String vehicleNo = request.getParameter("vehicleNo");
    String vehicleType = request.getParameter("vehicleType");
    String validFrom = request.getParameter("validFrom");
    String validTo = request.getParameter("validTo");
    String justification = request.getParameter("justification");

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        conn = DBConnection.getConnection();

        String updateSql = "UPDATE vehicle_entry_requests SET vehicle_no=?, vehicle_type=?, validity_from=?, validity_to=?, justification=?, editstatus='None' WHERE staff_no=?";
        ps = conn.prepareStatement(updateSql);
        ps.setString(1, vehicleNo);
        ps.setString(2, vehicleType);
        ps.setString(3, validFrom);
        ps.setString(4, validTo);
        ps.setString(5, justification);
        ps.setString(6, staffNo);

        int updated = ps.executeUpdate();
        if (updated > 0) {
            out.println("<p style='color: green; text-align: center;'><strong>Form updated successfully. Redirecting to Dashboard...</strong></p>");
            out.println("<script>setTimeout(() => { window.location.href = 'user_home.jsp'; }, 3000);</script>");
            
        } else {
            out.println("<p style='color:red;'>No record updated. Please try again or contact admin.</p>");
        }

    } catch (Exception e) {
        out.println("<p style='color:red;'>Error during update: " + e.getMessage() + "</p>");
    } finally {
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
