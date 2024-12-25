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
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
		Statement stmt = con.createStatement();
		String userName = session.getAttribute("user").toString();
		String oldPassword = request.getParameter("oldPassword");
		String newPassword = request.getParameter("newPassword");
		
		ResultSet rs = stmt.executeQuery("SELECT * FROM User WHERE userName='" + userName + "' AND password='" + oldPassword+ "'");
		if (rs.next()) {
			if (oldPassword.equals(newPassword)) {
				out.println("New password needs be different from current password! <a href='ChangePassword.jsp'>Go back.</a>");
			} else {
				String str = "UPDATE User SET password=? WHERE userName=?";
				PreparedStatement ps = con.prepareStatement(str);
				ps.setString(1, newPassword);
				ps.setString(2, userName);
				ps.executeUpdate();
				out.println("Password changed successfully! <a href='Login.jsp'>Go to login.</a>");
			}
		} else {
			out.println("The two passwords do not match! <a href='ChangePassword.jsp'>Go back.</a>");
		}
	
		con.close();
	%>
        
</body>
</html>
