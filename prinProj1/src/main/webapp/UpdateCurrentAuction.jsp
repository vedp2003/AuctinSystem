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
    <title>Update Current Auction</title>
</head>
<body>
 
	<%
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
		Statement stmt = con.createStatement();
		String auctionID = request.getParameter("auctionID");
		String closingTime = request.getParameter("closingTime");
		String incrementPrice = request.getParameter("increment");
		String minimumPrice = request.getParameter("minimumPrice");
		
		ResultSet rs = stmt.executeQuery("SELECT * FROM Auction WHERE auctionID='" + auctionID + "'");
		if(!rs.next()){
			out.println("Auction not found. <a href='UpdateAuction.jsp'>Go back.</a>");
			return; 
		}
		
		String str = "UPDATE Auction SET closingTime=?, increment=?, minimumPrice=? WHERE auctionID=?";
		PreparedStatement ps = con.prepareStatement(str);
		if(!minimumPrice.isEmpty()){
			if(Double.parseDouble(minimumPrice) < Double.parseDouble(rs.getString("initialPrice"))) {
				out.println("Auction Update Unsuccessful. Minimum Selling Price has to be >= Initial Price. <br/><a href='UpdateAuction.jsp'>Go back</a>");
				return;
			}
		}
		if (closingTime.isEmpty()) {
			ps.setString(1, rs.getString("closingTime"));
		} else {
			ps.setString(1, closingTime);
		}
		if (incrementPrice.isEmpty()) {
			ps.setString(2, rs.getString("increment"));
		} else {
			ps.setString(2, incrementPrice);
		}
		if (minimumPrice.isEmpty()) {
			ps.setString(3, rs.getString("minimumPrice"));
		} else {
			
			ps.setString(3, minimumPrice);
		}
		ps.setString(4, auctionID);
		ps.executeUpdate();
		
		out.println("Auction updated successfully! <br/><a href='LoginUser.jsp'>Go back to Main Page</a>");

		con.close();
	%>
	
        
</body>
</html>
