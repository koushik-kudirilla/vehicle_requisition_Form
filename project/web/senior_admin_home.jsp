<%@ page session="true" %>
<%
    String name = (String) session.getAttribute("employeeName");
    String staffNo = (String) session.getAttribute("staffNo");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Senior Admin Dashboard</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
<div class="page-wrapper">
    <jsp:include page="navbar.jsp" />
    <div class="container">
        <h1>Welcome, <%= name %> (Staff No: <%= staffNo %>)</h1>
        <h2>Senior Admin Portal</h2>
        <div class="options">
            <a href="final_approvals.jsp">Final Approvals</a>
            <a href="report.jsp">Reports</a>
            <a href="logout.jsp" style ="background-color: red;">Logout</a>
        </div>
    </div>
    <jsp:include page="footer.jsp" />
</div>
</body>
</html>
