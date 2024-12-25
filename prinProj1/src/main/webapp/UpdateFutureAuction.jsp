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
    <title>Update Future Auction</title>
</head>
<body>
 
	<%
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
		Statement stmt = con.createStatement();
		String auctionID = request.getParameter("auctionID");
		String startingTime = request.getParameter("startingTime");
		String closingTime = request.getParameter("closingTime");
		String initialPrice = request.getParameter("initialPrice");
		String incrementPrice = request.getParameter("increment");
		String minimumPrice = request.getParameter("minimumPrice");
		
		ResultSet rs = stmt.executeQuery("SELECT * FROM Auction WHERE auctionID='" + auctionID + "'");
		if(!rs.next()){
			out.println("Auction not found. <a href='UpdateAuction.jsp'>Go back.</a>");
			return; 
		}
		
		String str = "UPDATE Auction SET startingTime=?, closingTime=?, initialPrice=?, increment=?, minimumPrice=?, currentPrice=? WHERE auctionID=?";
		PreparedStatement ps = con.prepareStatement(str);
		
		if(!minimumPrice.isEmpty() && !initialPrice.isEmpty()){
			if(Double.parseDouble(minimumPrice) < Double.parseDouble(initialPrice)) {
				out.println("Auction Update Unsuccessful. Minimum Selling Price has to be >= Initial Price. <br/><a href='UpdateAuction.jsp'>Go back</a>");
				return;
			}
		}
		if(!minimumPrice.isEmpty() && initialPrice.isEmpty()){
			if(Double.parseDouble(minimumPrice) < Double.parseDouble(rs.getString("initialPrice"))) {
				out.println("Auction Update Unsuccessful. Minimum Selling Price has to be >= Initial Price. <br/><a href='UpdateAuction.jsp'>Go back</a>");
				return;
			}
		}
		
		if (startingTime.isEmpty()) {
			ps.setString(1, rs.getString("startingTime"));
		} else {
			ps.setString(1, startingTime);
		}
		if (closingTime.isEmpty()) {
			ps.setString(2, rs.getString("closingTime"));
		} else {
			ps.setString(2, closingTime);
		}
		if (initialPrice.isEmpty()) {
			ps.setString(3, rs.getString("initialPrice"));
			ps.setString(6, rs.getString("initialPrice"));
		} else {
			ps.setString(3, initialPrice);
			ps.setString(6, initialPrice);
		}
		if (incrementPrice.isEmpty()) {
			ps.setString(4, rs.getString("increment"));
		} else {
			ps.setString(4, incrementPrice);
		}
		
		if (minimumPrice.isEmpty()) {
			if (initialPrice.isEmpty()) {
				ps.setString(5, rs.getString("minimumPrice"));
			} 
			else {
				
				if(Double.parseDouble(initialPrice) >= Double.parseDouble(rs.getString("minimumPrice"))){
					ps.setString(5, rs.getString("minimumPrice"));
				}
				else {
					ps.setString(5, initialPrice);
				}
			}
		} 
		else {
			ps.setString(5, minimumPrice);
		}
		
		
		
		ps.setString(7, auctionID);
		ps.executeUpdate();
		
		out.println("Auction updated successfully! <br/><a href='LoginUser.jsp'>Go back to Main Page</a>");

		con.close();
	%>
	
        
</body>
</html>
