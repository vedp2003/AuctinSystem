<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
   pageEncoding="ISO-8859-1" import="samplePackage.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.*, java.time.format.DateTimeFormatter"%>
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
    <title>Verify Update Item</title>
</head>
<body>
 
 	 <%
		
 		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
		Statement stmt = con.createStatement();

					
		try {
		
			String catID = request.getParameter("catID");
			String subID = request.getParameter("subID");
			String itemID = request.getParameter("itemID");
			String startTime = request.getParameter("startingTime");
			String closeTime = request.getParameter("closingTime");
			String initialPrice = request.getParameter("initialPrice");
			String incrementPrice = request.getParameter("increment");
			String minimumPrice = request.getParameter("minimumPrice");
			LocalDateTime now = LocalDateTime.now();
			
			

			boolean checker = true;

			ResultSet rs = stmt.executeQuery("SELECT * FROM Auction where catID='" + catID + "' and subID='" + subID+ "' and itemID='" + itemID+ "'");
			
			while (rs.next()) {
				String currentWinner = rs.getString("currentWinner");
				String closingTime = rs.getString("closingTime");

		        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.S");
		        LocalDateTime closingTime1 = LocalDateTime.parse(closingTime, formatter);

		        
			    if (closingTime1.isBefore(now) && currentWinner != null) {
			        checker = false;
			        break;
			    }
			}
			
			
			
			if(checker) {
				
				ResultSet rs3 = stmt.executeQuery("SELECT * FROM Auction where catID='" + catID + "' and subID='" + subID+ "' and itemID='" + itemID+ "' AND ((startingTime <= NOW() AND closingTime >= NOW()) OR (startingTime > NOW()))");
				
				if (rs3.next()) {
			        out.println("Item already on auction! <a href='StartAuction.jsp'>Go back.</a>");
			    }
				else {
					
					
					String insert = "INSERT INTO Auction(initialPrice, increment, minimumPrice, currentPrice, startingTime, closingTime, catID, subID, itemID)"
							+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
					PreparedStatement ps = con.prepareStatement(insert);
					
					if(!minimumPrice.isEmpty()){
						if(Double.parseDouble(minimumPrice) < Double.parseDouble(initialPrice)) {
							out.println("Auction Not Added. Minimum Selling Price has to be >= Initial Price. <br/><a href='StartAuction.jsp'>Go back</a>");
							return;
						}
					}
					
					ps.setString(1, initialPrice);
					ps.setString(2, incrementPrice);
					
					if (minimumPrice.isEmpty()) {
						ps.setString(3, initialPrice);
					} else {
						ps.setString(3, minimumPrice);
					}
					
					ps.setString(4, initialPrice);
					ps.setString(5, startTime);
					ps.setString(6, closeTime);
					ps.setString(7, catID);
					ps.setString(8, subID);
					ps.setString(9, itemID);
					ps.executeUpdate();
					
		
					Statement stmt1 = con.createStatement();
					ResultSet rs1 = stmt1.executeQuery("SELECT * from Wishlist where catID='" + catID+ "' and subID='" + subID+ "' and itemID='" + itemID+"'");
					while (rs1.next()) {
						String insert1 = "INSERT IGNORE INTO Alert(message, alertTiming, endUserInfo)"
								+ "VALUES (?, ?, ?)";
						PreparedStatement ps1 = con.prepareStatement(insert1);
						ps1.setString(1, "Your wishlist item " + catID+ "-" + subID+ "-" + itemID+ " is up on auction from " + startTime+ " to " + closeTime+ ".");
						ps1.setString(2, LocalDateTime.now().toString());
						ps1.setString(3, rs1.getString("userName"));
						ps1.executeUpdate();
					}
					
					out.println("Auction added successfully! <a href='Auctions.jsp'>Go to Auctions page.</a>");
					return;
					
				}
				
	        	
	        }
			else {
				out.println("Item already Sold on Auction. <a href='StartAuction.jsp'>Go back.</a>");
				return;
			}
			
		} catch (SQLException e) {
			e.getMessage();
			out.println("Error while adding auction. Enter correct info. Please try again. <a href='StartAuction.jsp'>Try again.</a>");
			
		}
		finally {
			if (con != null) try { con.close(); } catch (SQLException ignore) {
				
			}
		}
	%>
        
</body>
</html>
