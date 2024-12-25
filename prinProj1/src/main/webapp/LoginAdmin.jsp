<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
   pageEncoding="ISO-8859-1" import="samplePackage.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<% 
if ("true".equals(request.getParameter("logout"))) {
    session.invalidate();
    session.removeAttribute("user"); 
    response.sendRedirect("Login.jsp");
    return;
} 
if (session.getAttribute("user") == null) {
    response.sendRedirect("Login.jsp");
    return;
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Admin Account</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            text-align: center;
        }
        h4 {
            margin-bottom: 20px;
        }
        a {
            color: #007BFF;
            font-size: 18px;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
    
    	<h2>ADMIN PORTAL</h2>
		<p><strong>( Name: <%= session.getAttribute("name") %> &amp; UserName: <%= session.getAttribute("user") %> )</strong></p>
		<hr>
		
        <div><a href='RegisterFormRep.jsp'>Create customer representative account</a></div>
        <div><a href='SalesReport.jsp'>Generate Sales Reports</a></div><br>
        <div><a href='ShowUsers.jsp'>Show System Accounts Information</a></div><br>
        <div><a href="Login.jsp?logout=true">Log out</a></div>
    </div>
</body>
</html>
