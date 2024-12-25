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
    <title>Remove from Wishlist</title>
</head>
<body>
 
	<%
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
		Statement stmt = con.createStatement();
		String userName = request.getParameter("userName");
		String catID = request.getParameter("catID");
		String subID = request.getParameter("subID");
		String itemID = request.getParameter("itemID");
		
		ResultSet current_wishlist = stmt.executeQuery("SELECT * FROM Wishlist where userName ='" + userName + "' and catID ='" + catID + "' and subID ='" + subID + "' and itemID ='" + itemID + "'");
		
		

		String str = "DELETE FROM Wishlist where userName=? AND catID=? AND subID=? AND itemID=?";

		PreparedStatement ps = con.prepareStatement(str);
		ps.setString(1, userName);
		ps.setString(2, catID);
		ps.setString(3, subID);
		ps.setString(4, itemID);
		ps.executeUpdate();
		
	
		
		out.println("Item removed from WishList successfully!");
		
		
		out.println("<br><a href='Wishlist.jsp'>Go back</a>");
	
			
		con.close();
	%>
        
</body>
</html>
