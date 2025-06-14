<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>
<%
    String staffNo = request.getParameter("staffNo");
    String password = request.getParameter("password");


    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    boolean isValidUser = false;

    try {
        conn = DBConnection.getConnection();
        String query = "SELECT * FROM employee WHERE StaffNo = ? AND password = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, staffNo);
        pstmt.setString(2, password);

        rs = pstmt.executeQuery();

        if (rs.next()) {
            isValidUser = true;
            session.setAttribute("employeeName", rs.getString("NameOfEmployee"));       // or adjust to exact column name
            session.setAttribute("staffNo", rs.getString("StaffNo"));
            session.setAttribute("designation", rs.getString("Designation_Grade")); // or "Designation_Grade" if that?s the column name
            session.setAttribute("department", rs.getString("Department"));
            String role = rs.getString("Designation_Grade");
            if ("user".equalsIgnoreCase(role)) {
                response.sendRedirect("user_home.jsp");
            } else if ("admin".equalsIgnoreCase(role)) {
                response.sendRedirect("admin_home.jsp");
            } else if ("Senior Admin".equalsIgnoreCase(role)) {
                response.sendRedirect("senior_admin_home.jsp");
            } else {
                response.sendRedirect("index.html"); // Fallback
            }
            return; 
        }
         else {
            out.println("<script>alert('Invalid login credentials'); location.href='index.html';</script>");
        }
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
