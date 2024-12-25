<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
   pageEncoding="ISO-8859-1" import="samplePackage.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.time.LocalDateTime"%>
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
    <title>Delete Bid</title>
</head>
<body>
 
	<%
    ApplicationDB db = new ApplicationDB();    
    Connection con = db.getConnection();    
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        String auctionID = request.getParameter("auctionID");
        String queryID = request.getParameter("queryID");

        ps = con.prepareStatement("SELECT * FROM Bidding WHERE auctionID = ? ORDER BY amount DESC");
        ps.setString(1, auctionID);
        rs = ps.executeQuery();

        ArrayList<String> bidIDs = new ArrayList<>();
        ArrayList<String> userNames = new ArrayList<>();
        ArrayList<Double> amounts = new ArrayList<>();
		
        LocalDateTime now = LocalDateTime.now();
        while (rs.next()) {
            bidIDs.add(rs.getString("bidID"));
            userNames.add(rs.getString("userName"));
            amounts.add(rs.getDouble("amount"));
        }

        if (bidIDs.size() == 0) {
            out.println("No bids to delete. <a href='LoginRep.jsp'>Go back to Main Page.</a>");
        } else {
            ps = con.prepareStatement("DELETE FROM Bidding WHERE bidID = ?");
            ps.setString(1, bidIDs.get(0));
            ps.executeUpdate();

            if (bidIDs.size() > 1) {
                ps = con.prepareStatement("UPDATE Auction SET currentWinner = ?, currentPrice = ? WHERE auctionID = ?");
                ps.setString(1, userNames.get(1));
                ps.setDouble(2, amounts.get(1));
                ps.setString(3, auctionID);
                ps.executeUpdate();
            } else {
                ps = con.prepareStatement("UPDATE Auction SET currentWinner = NULL, currentPrice = initialPrice WHERE auctionID = ?");
                ps.setString(1, auctionID);
                ps.executeUpdate();
            }

            String resolveText = "bidID " + bidIDs.get(0) + " deleted successfully!";
            String customerRepID = session.getAttribute("user").toString();
            ps = con.prepareStatement("UPDATE Query SET resolveText = ?, resolveStatus = ?, customerRepresentationInfo = ?, resolveTiming = ? WHERE queryID = ?");
            ps.setString(1, resolveText);
            ps.setString(2, "resolved");
            ps.setString(3, customerRepID);
	        ps.setString(4, now.toString());
            ps.setString(5, queryID);
            ps.executeUpdate();

            String sendAlert = "INSERT IGNORE INTO Alert (endUserInfo, alertTiming, message) VALUES (?, ?, ?)";
            ps = con.prepareStatement(sendAlert);
            ps.setString(1, userNames.get(0));
	        ps.setString(2, now.toString());
            ps.setString(3, "Your Query (ID " + queryID + ") has been answered!");
            ps.executeUpdate();
            
            String redirectURL = "DeleteBid.jsp?auctionID=" + auctionID + "&queryID=" + queryID + "&bidDeleted=true";
            response.sendRedirect(redirectURL);
        }

    } catch (SQLException e) {
        out.println("SQL Error: " + e.getMessage() + " <a href='DeleteBid.jsp'>Go back</a>");
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
        if (con != null) try { con.close(); } catch (SQLException ignore) {}
    }
%>
        
</body>
</html>
