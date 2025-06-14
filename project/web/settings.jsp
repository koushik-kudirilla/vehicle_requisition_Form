<%@ page session="true" %>
<%
    String staffNo = (String) session.getAttribute("staffNo");
    String email = (String) session.getAttribute("email");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Account Settings</title>
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
            margin-bottom: 30px;
        }
        label {
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
        }
        input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }
        .btn-save {
            background-color: #005a9e;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
        }
        .btn-save:hover {
            background-color: #003e73;
        }
        .btn-back {
            margin-left: 15px;
            background-color: gray;
        }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp" />
<div class="container">
    <h2>Change Password</h2>
    <form action="update_password.jsp" method="post">
        <input type="hidden" name="staff_no" value="<%= staffNo %>">
        
        <label>Current Password</label>
        <input type="password" name="current_password" required>

        <label>New Password</label>
        <input type="password" name="new_password" required>

        <label>Confirm New Password</label>
        <input type="password" name="confirm_password" required>

        <button type="submit" class="btn-save">Update Password</button>
        <a href="user_home.jsp" class="btn-save btn-back">Cancel</a>
    </form>
</div>
<jsp:include page="footer.jsp" />
</body>
</html>
