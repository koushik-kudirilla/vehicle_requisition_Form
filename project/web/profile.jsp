<%@ page session="true" %>
<%
    String employeeName = (String) session.getAttribute("employeeName");
    String designation = (String) session.getAttribute("designation");
    String staffNo = (String) session.getAttribute("staffNo");
    String department = (String) session.getAttribute("department");
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Profile</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f4f9ff;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 700px;
            margin: 40px auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h2 {
            color: #003366;
            text-align: center;
        }
        .profile-item {
            margin-bottom: 20px;
        }
        .profile-item label {
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
        }
        .profile-item span {
            color: #555;
        }
        .btn-back {
            display: inline-block;
            padding: 10px 20px;
            background-color: #005a9e;
            color: white;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            margin-top: 20px;
        }
        .btn-back:hover {
            background-color: #003e73;
        }
    </style>
</head>
<body>
 <jsp:include page="navbar.jsp" />
<div class="container">
    <h2>My Profile</h2>
    <div class="profile-item">
        <label>Name:</label>
        <span><%= employeeName != null ? employeeName : "N/A" %></span>
    </div>
    <div class="profile-item">
        <label>Staff No:</label>
        <span><%= staffNo != null ? staffNo : "N/A" %></span>
    </div>
    <div class="profile-item">
        <label>Designation:</label>
        <span><%= designation != null ? designation : "N/A" %></span>
    </div>
    <div class="profile-item">
        <label>Department:</label>
        <span><%= department != null ? department : "N/A" %></span>
    </div>

    <a href="user_home.jsp" class="btn-back">Back to Home</a>
</div>
<jsp:include page="footer.jsp" />
</body>
</html>
