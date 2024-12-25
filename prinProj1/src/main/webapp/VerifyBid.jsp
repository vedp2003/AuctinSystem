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
    <title>Verify Bid</title>
</head>
<body>
 
	<%
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
		Statement stmt = con.createStatement();
		String auctionID = request.getParameter("auctionID");
		String amount = request.getParameter("amount");
		
		ResultSet result = stmt.executeQuery("SELECT * FROM Auction WHERE auctionID='" + auctionID+"'");
		if(!result.next()){
			out.println("Invalid auction ID entered! <a href='PlaceBid.jsp'>Go back.</a>");
			return;
		}
		double increment = Double.parseDouble(result.getString("currentPrice")) + Double.parseDouble(result.getString("increment"));
		
		if (Double.parseDouble(amount) < increment) {
			out.println("Invalid amount! <a href='PlaceBid.jsp'>Go back.</a>");
		} else {
			LocalDateTime now = LocalDateTime.now();
			String insert = "INSERT INTO Bidding(amount, bidTiming, userName, auctionID)"
					+ "VALUES (?, ?, ?, ?)";
			PreparedStatement ps = con.prepareStatement(insert);
			ps.setString(1, amount);
			ps.setString(2, now.toString());
			ps.setString(3, session.getAttribute("user").toString());
			ps.setString(4, auctionID);
			ps.executeUpdate();
			
			String update = "UPDATE Auction SET currentWinner=?, currentPrice=? WHERE auctionID=?";
			ps = con.prepareStatement(update);
			ps.setString(1, session.getAttribute("user").toString());
			ps.setString(2, amount);
			ps.setString(3, auctionID);
			ps.executeUpdate();
			
			Statement stmt1 = con.createStatement();
			ResultSet result1 = stmt1.executeQuery("SELECT * from AutoBid where auctionID='" + auctionID +"' ORDER BY upperLimit DESC, startTime ASC");
			if (result1.next()) {
				double amount_autobid = Double.parseDouble(result1.getString("upperLimit"));
				String winner_autobid = result1.getString("userName");
				if (!winner_autobid.equals(session.getAttribute("user").toString())) {
					increment = Double.parseDouble(amount) + Double.parseDouble(result.getString("increment"));
					if (increment<=amount_autobid) {
						String update1 = "UPDATE Auction SET currentWinner=?, currentPrice=? WHERE auctionID=?";
						PreparedStatement ps1 = con.prepareStatement(update1);
						ps1.setString(1, winner_autobid);
						ps1.setString(2, Double.toString(increment));
						ps1.setString(3, auctionID);
						ps1.executeUpdate();
						
						String insert1 = "INSERT INTO Bidding(amount, bidTiming, userName, auctionID)"
								+ "VALUES (?, ?, ?, ?)";
						ps1 = con.prepareStatement(insert1);
						ps1.setString(1, Double.toString(increment));
						ps1.setString(2, now.toString());
						ps1.setString(3, winner_autobid);
						ps1.setString(4, auctionID);
						ps1.executeUpdate();
					}
				}
			}
			
			Statement stmt2 = con.createStatement();
			ResultSet result2 = stmt2.executeQuery("SELECT * from Auction WHERE auctionID='" + auctionID + "'");
			result2.next();
			String curr_winner = result2.getString("currentWinner");
			String curr_price = result2.getString("currentPrice");
			Statement stmt3 = con.createStatement();
			ResultSet result3 = stmt3.executeQuery("SELECT DISTINCT userName from Bidding WHERE auctionID='" + auctionID + "' and userName!='" + curr_winner+ "'");
			while (result3.next()) {
				String insert2 = "INSERT IGNORE INTO Alert(message, alertTiming, endUserInfo)"
						+ "VALUES (?, ?, ?)";
				PreparedStatement ps2 = con.prepareStatement(insert2);
				ps2.setString(1, "Higher bid placed for Auction " + auctionID + " for $" + curr_price+ ". <a href='PlaceBid.jsp'>Manage your bids</a>.");
				ps2.setString(2, now.toString());
				ps2.setString(3, result3.getString("userName"));
				ps2.executeUpdate();
			}
			Statement stmt4 = con.createStatement();
			ResultSet result4 = stmt4.executeQuery("SELECT DISTINCT userName from AutoBid where auctionID='" + auctionID + "' and userName!='" + curr_winner+ "' and upperLimit<='" + curr_price+ "'");
			while (result4.next()) {
				String insert2 = "INSERT IGNORE INTO Alert(message, alertTiming, endUserInfo)"
						+ "VALUES (?, ?, ?)";
				PreparedStatement ps2 = con.prepareStatement(insert2);
				ps2.setString(1, "The upper limit of your autobid has been outbid for Auction " + auctionID + ". <a href='Autobid.jsp'>Manage your bids</a>.");
						
				ps2.setString(2, now.toString());
				ps2.setString(3, result4.getString("userName"));
				ps2.executeUpdate();
			}
			
			out.println("Bid added successfully!<br/><a href='PlaceBid.jsp'>Go back</a>");
		}
		con.close();
	%>
        
</body>
</html>
