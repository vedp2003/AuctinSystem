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
    <title>Verify New Item</title>
</head>
<body>
 
 	 <%
		
 		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
		Statement stmt = con.createStatement();
					
		try {
		
			String catID = request.getParameter("category");
			String subID = request.getParameter("subcategory");
			String name = request.getParameter("name");
			String type = request.getParameter("type");
			String year = request.getParameter("year");
			String desc1 = request.getParameter("desc1");
			String desc2 = request.getParameter("desc2");
			String desc3 = request.getParameter("desc3");
			
			String str = "INSERT INTO Item(shortDescription, middleDescription, longDescription, name, type, year, catID, subID, addedBySellerInfo)"
					+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
			PreparedStatement ps = con.prepareStatement(str);
			ps.setString(1, desc1);
			ps.setString(2, desc2);
			ps.setString(3, desc3);
			ps.setString(4, name);
			ps.setString(5, type);
			ps.setString(6, year);
			ps.setString(7, catID);
			ps.setString(8, subID);
			ps.setString(9, session.getAttribute("user").toString());
			ps.executeUpdate();
			
			out.println("Item added successfully! <a href='Items.jsp'>Go back to Items page.</a>");
			
		} catch (SQLException e) {
			out.println("Error while adding. Please try again. <a href='AddItem.jsp'>Try again.</a>");
		}
		finally {
			if (con != null) try { con.close(); } catch (SQLException ignore) {}
		}
	%>
        
</body>
</html>
