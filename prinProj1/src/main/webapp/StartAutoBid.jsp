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
    <title>Auto Bid</title>
</head>
<body>
 
	<%
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();	
	
	Statement stmt = con.createStatement();
	String auctionID = request.getParameter("auctionID");
	String amount = request.getParameter("upper");
	String userName = session.getAttribute("user").toString();

	LocalDateTime now = LocalDateTime.now();
	
	ResultSet result = stmt.executeQuery("SELECT * FROM AutoBid WHERE userName='" + userName +"' AND auctionID='" + auctionID+"'");
	
	if (result.next()) {
        %>
        <script>
            alert('Already enrolled in autobid for this auction!');
            window.location.href = 'Autobid.jsp';
        </script>
        <%
	} else {	
		Statement stmt1 = con.createStatement();
		ResultSet result1 = stmt1.executeQuery("SELECT * FROM AutoBid WHERE auctionID='" + auctionID+"' ORDER BY upperLimit DESC, startTime ASC");
		Statement stmt2 = con.createStatement();
		ResultSet result2 = stmt2.executeQuery("SELECT * FROM Auction WHERE auctionID='" + auctionID+"'");
		result2.next();
		
		double newAmount = Double.parseDouble(amount);
		double amountInAuction = Double.parseDouble(result2.getString("currentPrice"));
		double increment = Double.parseDouble(result2.getString("increment"));
		String currentlyWinning = result2.getString("currentWinner");
		
		if (newAmount<=amountInAuction) {
	        %>
	        <script>
	            alert('The highest bid is greater than the Upper Limit');
	            window.location.href = 'Autobid.jsp';
	        </script>
	        <%
	        return; 
		} else {
			if (result1.next()) {
				double oldAmount = Double.parseDouble(result1.getString("upperLimit"));
				String oldWinner = result1.getString("userName");
				if (oldAmount>newAmount) {
					double newamountWIncrement = newAmount + increment;
					if (newamountWIncrement<=oldAmount) {
						String update = "UPDATE Auction SET currentWinner=?, currentPrice=? WHERE auctionID=?";
						PreparedStatement ps = con.prepareStatement(update);
						ps.setString(1, oldWinner);
						ps.setString(2, Double.toString(newamountWIncrement));
						ps.setString(3, auctionID);
						ps.executeUpdate();
						
						String insert = "INSERT INTO Bidding(userName, auctionID, bidTiming, amount)"
								+ "VALUES (?, ?, ?, ?)";
						PreparedStatement ps1 = con.prepareStatement(insert);
						ps1.setString(1, oldWinner);
						ps1.setString(2, auctionID);
						ps1.setString(3, now.toString());
						ps1.setString(4, Double.toString(newamountWIncrement));
						ps1.executeUpdate();
					}
				} else if (amountInAuction>=oldAmount && !currentlyWinning.equals(userName)) {
					double newamountWIncrement = amountInAuction + increment;
					if (newamountWIncrement<=newAmount) {
						String update = "UPDATE auction SET currentWinner=?, currentPrice=? WHERE auctionID=?";
						PreparedStatement ps = con.prepareStatement(update);
						ps.setString(1, userName);
						ps.setString(2, Double.toString(newamountWIncrement));
						ps.setString(3, auctionID);
						ps.executeUpdate();
						
						String insert = "INSERT INTO Bidding(userName, auctionID, bidTiming, amount)"
								+ "VALUES (?, ?, ?, ?)";
						PreparedStatement ps1 = con.prepareStatement(insert);
						ps1.setString(1, userName);
						ps1.setString(2, auctionID);
						ps1.setString(3, now.toString());
						ps1.setString(4, Double.toString(newamountWIncrement));
						ps1.executeUpdate();
					}
				} else if (oldAmount>=amountInAuction) {
					double oldAmountWIncrement = oldAmount + increment;
					if (oldAmountWIncrement<=newAmount) {
						String update = "UPDATE Auction SET currentWinner=?, currentPrice=? WHERE auctionID=?";
						PreparedStatement ps = con.prepareStatement(update);
						ps.setString(1, userName);
						ps.setString(2, Double.toString(oldAmountWIncrement));
						ps.setString(3, auctionID);
						ps.executeUpdate();
							
						String insert = "INSERT INTO Bidding(userName, auctionID, bidTiming, amount)"
								+ "VALUES (?, ?, ?, ?)";
						PreparedStatement ps1 = con.prepareStatement(insert);
						ps1.setString(1, userName);
						ps1.setString(2, auctionID);
						ps1.setString(3, now.toString());
						ps1.setString(4, Double.toString(oldAmountWIncrement));
						ps1.executeUpdate();
					}
				}
			} else {
				double amountWIncrement = amountInAuction + increment;
				if (amountWIncrement<=newAmount && (currentlyWinning==null || !currentlyWinning.equals(userName))) {
					String update = "UPDATE Auction SET currentWinner=?, currentPrice=? WHERE auctionID=?";
					PreparedStatement ps = con.prepareStatement(update);
					ps.setString(1, userName);
					ps.setString(2, Double.toString(amountWIncrement));
					ps.setString(3, auctionID);
					ps.executeUpdate();
					
					String insert = "INSERT INTO Bidding(userName, auctionID, bidTiming, amount)"
							+ "VALUES (?, ?, ?, ?)";
					PreparedStatement ps1 = con.prepareStatement(insert);
					ps1.setString(1, userName);
					ps1.setString(2, auctionID);
					ps1.setString(3, now.toString());
					ps1.setString(4, Double.toString(amountWIncrement));
					ps1.executeUpdate();
				}
			}
			
			String insert = "INSERT INTO AutoBid(userName, auctionID, startTime, upperLimit)"
					+ "VALUES (?, ?, ?, ?)";
			PreparedStatement ps2 = con.prepareStatement(insert);
			ps2.setString(1, userName);
			ps2.setString(2, auctionID);
			ps2.setString(3, now.toString());
			ps2.setString(4, amount);
			ps2.executeUpdate();
			
			Statement stmt3 = con.createStatement();
			ResultSet result3 = stmt3.executeQuery("SELECT * FROM Auction WHERE auctionID='" + auctionID+ "'");
			result3.next();
			currentlyWinning = result3.getString("currentWinner");
			String curr_price = result3.getString("currentPrice");
			Statement stmt5 = con.createStatement();
			ResultSet result5 = stmt5.executeQuery("SELECT DISTINCT userName FROM AutoBid WHERE auctionID='" + auctionID+ "' AND userName!='" + currentlyWinning+ "' AND upperLimit<='" + curr_price+ "'");
			while (result5.next()) {
				String insert1 = "INSERT IGNORE INTO Alert(endUserInfo, alertTiming, message)"
						+ "VALUES (?, ?, ?)";
				PreparedStatement ps3 = con.prepareStatement(insert1);
				ps3.setString(1, result5.getString("userName"));
				ps3.setString(2, now.toString());
				ps3.setString(3, "The upper limit of your autobid has been outbid for Auction " + auctionID + ". <a href='Autobid.jsp'>Manage your bids</a>.");
				ps3.executeUpdate();
			}
			
	        %>
	        <script>
	            alert('Autobid has been succesfully started.');
	            window.location.href = 'Autobid.jsp';
	        </script>
	        <%
		}
		
	}
	con.close();
	%>
	
        
</body>
</html>