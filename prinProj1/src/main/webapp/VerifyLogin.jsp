<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
   pageEncoding="ISO-8859-1" import="samplePackage.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Welcome to Auction</title>
</head>
<body>
 
	<%
		String userName = request.getParameter("userName");
		String password = request.getParameter("password");
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement st = con.createStatement();
		ResultSet rs;
		rs = st.executeQuery("select * from User where userName='" + userName + "' and password='" + password + "'");
		if (rs.next()) {
			session.setAttribute("user", userName);
			session.setAttribute("name", rs.getString("name"));
			response.sendRedirect("SuccessLogin.jsp");
		} else {
			out.println("Invalid Login credentials<br/><a href='Login.jsp'>Try again</a>");
		}
	%>
        
</body>
</html>
