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
 
	<%if ((session.getAttribute("user") == null)) {%>
		You are not logged in<br/><a href="Login.jsp">Please Login</a>
	<%} else if (session.getAttribute("user").toString().equals("admin1")) {%>
		<jsp:include page='LoginAdmin.jsp'/>
	<%} else if (session.getAttribute("user").toString().contains("rep")) {%>
		<jsp:include page='LoginRep.jsp'/>
	<%} else {%>
		<jsp:include page='LoginUser.jsp'/>
	<%}%>
        
</body>
</html>
