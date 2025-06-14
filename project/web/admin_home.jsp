<%@ page session="true" %>

<%
    String name = (String) session.getAttribute("employeeName");
    String staffNo = (String) session.getAttribute("staffNo");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
<div class="page-wrapper">
    <jsp:include page="navbar.jsp" />

    <div class="content-wrapper">
        <div class="container">
            <h1>Welcome, <%= name %> (Staff No: <%= staffNo %>)</h1>
            <h2>Admin Portal</h2>
            <div class="options">
                <a href="pending_requests.jsp">Approve/Reject Requests</a>
                <a href="view_approved.jsp">View Approved List</a>
                <a href="edit_requests.jsp">Edit Requests</a>
                <a href="logout.jsp" style ="background-color: red;">Logout</a>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</div>
</body>

</html>
