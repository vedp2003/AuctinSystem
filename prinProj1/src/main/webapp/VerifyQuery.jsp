<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
   pageEncoding="ISO-8859-1" import="samplePackage.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.LocalDateTime"%>
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
    <title>Query</title>
</head>
<body>
 
	<%
	String userName = session.getAttribute("user").toString();
	String question = request.getParameter("detailsText");
	LocalDateTime now = LocalDateTime.now();
	
	
	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection();
	PreparedStatement stmt = null;

	try {
		    String str = "INSERT INTO Query (askDetailsText, resolveStatus, askTiming, endUserInfo) VALUES (?,'pending',?,?)";
		    
			stmt = con.prepareStatement(str);

			stmt.setString(1, question);
			stmt.setString(2, now.toString());
			stmt.setString(3, userName);
			stmt.executeUpdate();
	} catch (SQLException e) {
	    e.printStackTrace();
	} finally {
	    try { con.close(); } catch (Exception e) {}
	}
	 

	response.sendRedirect("AskQuery.jsp");
	%>
        
</body>
</html>
