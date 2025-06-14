<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page import="utils.DBConnection" %>
<%
    String staffNo = (String) session.getAttribute("staffNo"); // admin performing the action
    String requestId = request.getParameter("request_id");
    String action = request.getParameter("action");
    if (requestId == null || requestId.isEmpty() || action == null || action.isEmpty()) {
        out.println("<p style='color:red;'>Invalid request. Missing required parameters.</p>");
        return;
    }

    String reason = request.getParameter("reason");

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        conn = DBConnection.getConnection();
        
        if ("approve".equalsIgnoreCase(action)) {
            String sql = "UPDATE vehicle_entry_requests SET status = 'Admin Approved', admin_approved_by = ?, admin_approved_at = NOW() WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, staffNo);
            ps.setInt(2, Integer.parseInt(requestId));
            ps.executeUpdate();
        } else if ("reject".equalsIgnoreCase(action)) {
            String sql = "UPDATE vehicle_entry_requests SET status = 'Rejected by Admin', rejection_reason = ?, admin_approved_by = ?, admin_approved_at = NOW() WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, reason);
            ps.setString(2, staffNo);
            ps.setInt(3, Integer.parseInt(requestId));
            ps.executeUpdate();
        }
        response.sendRedirect("pending_requests.jsp");
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
