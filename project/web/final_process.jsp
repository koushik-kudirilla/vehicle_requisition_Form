<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page import="utils.DBConnection" %>
<%
    String staffNo = (String) session.getAttribute("staffNo"); // Senior admin performing action
    String requestId = request.getParameter("request_id");
    String action = request.getParameter("action");
    String reason = request.getParameter("reason");

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        conn = DBConnection.getConnection();

        if ("approve".equalsIgnoreCase(action)) {
            String sql = "UPDATE vehicle_entry_requests SET status = 'Final Approved', senior_admin_approved_by = ?, senior_admin_approved_at = NOW() WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, staffNo);
            ps.setInt(2, Integer.parseInt(requestId));
            ps.executeUpdate();
        } else if ("reject".equalsIgnoreCase(action)) {
            String sql = "UPDATE vehicle_entry_requests SET status = 'Rejected by Senior Admin', rejection_reason = ?, senior_admin_approved_by = ?, senior_admin_approved_at = NOW() WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, reason);
            ps.setString(2, staffNo);
            ps.setInt(3, Integer.parseInt(requestId));
            ps.executeUpdate();
        }
        response.sendRedirect("final_approvals.jsp");
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
