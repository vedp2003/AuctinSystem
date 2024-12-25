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
    <title>Verify Delete Item</title>
</head>
<body>
 
 	 <%
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
		Statement stmt = con.createStatement();
	
		String catID = request.getParameter("catID");
		String subID = request.getParameter("subID");
		String itemID = request.getParameter("itemID");
		
		String str = "DELETE FROM Item WHERE catID='" + catID + "' and subID='" + subID + "' and itemID='" + itemID + "'";
		
		try {
			PreparedStatement ps = con.prepareStatement(str);
			int rowsAffected = ps.executeUpdate();
			if (rowsAffected > 0) {
				out.println("Item deleted successfully! <a href='LoginUser.jsp'>Go to main page.</a>");
			} else {
				out.println("Item not deleted - Enter correct information! <a href='DeleteItem.jsp'>Try again.</a>");
			}
		} catch (SQLException e) {
			out.println("Error while deletion. Please try again. <a href='DeleteItem.jsp'>Try again.</a>");
		}
		finally {
			if (con != null) try { con.close(); } catch (SQLException ignore) {}
		}
	%>
        
</body>
</html>
