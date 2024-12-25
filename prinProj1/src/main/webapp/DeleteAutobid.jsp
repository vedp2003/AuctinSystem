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
    <title>Delete AutoBid</title>
</head>
<body>
	<%
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
		Statement stmt = con.createStatement();
		String auctionID = request.getParameter("auctionID");
		String userName = session.getAttribute("user").toString();
				
		ResultSet rs = stmt.executeQuery("SELECT * from AutoBid WHERE userName='" + userName +"' AND auctionID='" + auctionID+"'");
		
		if (rs.next()) {
			String str = "DELETE FROM AutoBid WHERE userName='" + userName + "' AND auctionID='" + auctionID+ "'";
			PreparedStatement ps = con.prepareStatement(str);
			ps.executeUpdate();
			out.println("Autobid deleted successfully! <a href='LoginUser.jsp'> Go back to main page</a>.");
		} else {	
			out.println("Autobid does not exist! <a href='Autobid.jsp'>Go back</a>.");
		}
		
		con.close();
	%>
        
</body>
</html>
