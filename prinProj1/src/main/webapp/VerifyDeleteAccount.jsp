<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
   pageEncoding="ISO-8859-1" import="samplePackage.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%
	
	if (session.getAttribute("user") == null) {
    response.sendRedirect("Login.jsp");
    return;
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Delete Account</title>
</head>
<body>
 
	<%
	String userName = (String)session.getAttribute("user");
	if (request.getMethod().equals("POST")) {
	  String passwordTyped = request.getParameter("password");
	  
	  ApplicationDB db = new ApplicationDB();	
	  Connection con = db.getConnection();
	  Statement st = con.createStatement();
	  ResultSet rs;
	  rs = st.executeQuery("select password from User where userName='" + userName+"'");
	  if(rs.next())
	  {
		  String password = rs.getString("password");
		  
		  if (passwordTyped.equals(password)) {
		      response.sendRedirect("SuccessDeleteAccount.jsp");
		  } 
		  else {
			
			  out.println("Error deleting - Make sure correct password is entered!<br/><a href='LoginUser.jsp'>Go back to Main Page</a>");
		  }
	  }
	  st.close();
	  con.close();
	}
	%>
        
</body>
</html>
