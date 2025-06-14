<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page import="utils.DBConnection" %>
<%
    String requestId = request.getParameter("id");

   
    Connection conn = null;
    PreparedStatement ps = null;

    try {
        conn = DBConnection.getConnection();
   
        String updateSql = "UPDATE vehicle_entry_requests SET editstatus = 'Approved' WHERE id = ?";
        ps = conn.prepareStatement(updateSql);
        ps.setInt(1, Integer.parseInt(requestId));
        ps.executeUpdate();

        response.sendRedirect("edit_requests.jsp"); // redirect back after update
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error approving edit request: " + e.getMessage() + "</p>");
    } finally {
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
