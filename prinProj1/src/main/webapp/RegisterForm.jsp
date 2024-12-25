<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
   pageEncoding="ISO-8859-1" import="samplePackage.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

 <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Register</title>
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
        }
        h2 {
            text-align: center;
            color: #333;
        }
        form {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        input[type="text"],
        input[type="email"],
        input[type="password"] {
            margin: 10px 0;
            padding: 8px;
            width: 200px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        input[type="submit"] {
            background-color: #007BFF;
            color: white;
            border: none;
            padding: 10px 20px;
            margin-top: 20px;
            cursor: pointer;
            border-radius: 5px;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        a {
            color: #007BFF;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Register for BuyMe</h2>
        
        <form action="RegisterUser.jsp" method="post">
            Name: <input type="text" name="name" required><br>
            Email: <input type="email" name="email" required><br>
            Username: <input type="text" name="userName" required><br>
            Password: <input type="password" name="password" required><br>
            <input type="hidden" name="registrationAttempt" value="false">
            <input type="submit" value="Register">
        </form>
        
        <p>Already registered: <a href="Login.jsp">Click to Login Here</a>.</p>
    </div>
</body>
</html>

