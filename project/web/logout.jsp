<%@ page session="true" %>
<%
    session.invalidate(); // Ends the current session
    response.sendRedirect("index.html"); // Redirects to login page
%>
