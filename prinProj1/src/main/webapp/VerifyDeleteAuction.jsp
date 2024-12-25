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
    <title>Verify Delete Auction</title>
</head>
<body>
 
	<%
		
		String hiddenFieldValue = request.getParameter("hiddenField");
		if (hiddenFieldValue != null && hiddenFieldValue.equals("true")) {
			
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			
			Statement stmt1 = con.createStatement();
			String auctionID = request.getParameter("auctionID");
			String userName = request.getParameter("userName");
			
	        ResultSet result = stmt1.executeQuery("SELECT * FROM Auction a JOIN item i ON a.itemID=i.itemID AND a.catID=i.catID AND a.subID=i.subID WHERE i.addedBySellerInfo='" + userName + "' AND a.auctionID='" + auctionID + "' AND a.closingTime>NOW()");

			if (result.next()) {
				String str = "DELETE FROM Auction WHERE auctionID='" + auctionID + "'";
				PreparedStatement ps = con.prepareStatement(str);
				ps.executeUpdate();
				
				PreparedStatement stmt=null;
				LocalDateTime now = LocalDateTime.now();
				String sendAlert = "INSERT IGNORE INTO Alert (endUserInfo, alertTiming, message) VALUES (?, ?, ?)";
	            stmt = con.prepareStatement(sendAlert);
	            stmt.setString(1, userName);
		        stmt.setString(2, now.toString());
	            stmt.setString(3, "Your Auction (ID " + auctionID + ") has been removed by a customer rep - It doesn't follow legal guidelines.");
	            stmt.executeUpdate();

				
				out.println("Auction deleted successfully! <br/><a href='LoginRep.jsp'>Go back</a>");
			} else {
				out.println("Auction cannot be deleted! <br/><a href='LoginRep.jsp'>Go back</a>");
			}
				
			con.close();
			
		} else {
	    
		
	
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			ResultSet rs = null;
			PreparedStatement stmt=null;
			String auctionID = request.getParameter("auctionID");
			String userName = request.getParameter("userName");
		    String queryID = request.getParameter("queryID");
		    LocalDateTime now = LocalDateTime.now();
	
			try{
				String checkQuery = "SELECT resolveStatus FROM Query WHERE queryID=?";
		        stmt = con.prepareStatement(checkQuery);
		        stmt.setInt(1, Integer.parseInt(queryID));
		        rs = stmt.executeQuery();
		
		        if (!rs.next()) {
		            out.println("Query ID is invalid. Enter correct QueryID to delete an auction! <a href='LoginRep.jsp'>Go back</a>.");
		            return;
		        }
		
		        String resolveStatus = rs.getString("resolveStatus");
		        if (!resolveStatus.equals("pending")) {
		            out.println("Query ID is non-pending and cannot be resolved again! <a href='LoginRep.jsp'>Go back</a>.");
		            return;
		        }
		        
		        Statement stmtR = con.createStatement();
		        ResultSet result = stmtR.executeQuery("SELECT * FROM Auction a JOIN item i ON a.itemID=i.itemID AND a.catID=i.catID AND a.subID=i.subID WHERE i.addedBySellerInfo='" + userName + "' AND a.auctionID='" + auctionID + "' AND a.closingTime>NOW()");
				if (result.next()) {
					String str = "DELETE FROM Auction WHERE auctionID='" + auctionID + "'";
					PreparedStatement ps = con.prepareStatement(str);
					ps.executeUpdate();
					
					
					
				    String status = "resolved";
				    String resolveText = "AuctionID " + auctionID + " deleted successfully!";
				    String customerRepID = session.getAttribute("user").toString();
				    
				    ApplicationDB db1 = new ApplicationDB();
				    Connection con1 = db1.getConnection();
				    PreparedStatement stmt1=null;
				    try {
					    str= "UPDATE Query SET resolveText = ?, resolveStatus = ?, customerRepresentationInfo = ?, resolveTiming = ? WHERE queryID = ?";
						
				        stmt1 = con.prepareStatement(str);
				        stmt1.setString(1, resolveText);
				        stmt1.setString(2, status);
				        stmt1.setString(3, customerRepID);
				        stmt1.setString(4, now.toString());
				        stmt1.setString(5, queryID);
				        stmt1.executeUpdate();
				        
				        
				        String sendAlert = "INSERT IGNORE INTO Alert (endUserInfo, alertTiming, message) VALUES (?, ?, ?)";
			            stmt = con.prepareStatement(sendAlert);
			            stmt.setString(1, userName);
				        stmt.setString(2, now.toString());
			            stmt.setString(3, "Your Query (ID " + queryID + ") has been answered!");
			            stmt.executeUpdate();
	
				        
				    } catch (Exception e) {
				        e.printStackTrace();
				    } finally {
				        try { stmt.close(); } catch (Exception e) {}
				        try { con.close(); } catch (Exception e) {}
				    }
				    
				    
				    
				    response.sendRedirect("LoginRep.jsp");
					
				} 
				else {
					
				    String status = "denied";
				    String resolveText = "AuctionID " + auctionID + " cannot be deleted. It is not a valid AuctionID.";
				    String customerRepID = session.getAttribute("user").toString();
				    
				    ApplicationDB db1 = new ApplicationDB();
				    Connection con1 = db1.getConnection();
				    PreparedStatement stmt1=null;
				    try {
					    String str= "UPDATE Query SET resolveText = ?, resolveStatus = ?, customerRepresentationInfo = ?, resolveTiming = ? WHERE queryID = ?";
						
				        stmt1 = con.prepareStatement(str);
				        stmt1.setString(1, resolveText);
				        stmt1.setString(2, status);
				        stmt1.setString(3, customerRepID);
				        stmt1.setString(4, now.toString());
				        stmt1.setString(5, queryID);
				        stmt1.executeUpdate();
				        
				        String sendAlert = "INSERT IGNORE INTO Alert (endUserInfo, alertTiming, message) VALUES (?, ?, ?)";
			            stmt = con.prepareStatement(sendAlert);
			            stmt.setString(1, userName);
				        stmt.setString(2, now.toString());
			            stmt.setString(3, "Your Query (ID " + queryID + ") has been answered!");
			            stmt.executeUpdate();
				        
				    } catch (Exception e) {
				        e.printStackTrace();
				    } finally {
				        try { stmt.close(); } catch (Exception e) {}
				        try { con.close(); } catch (Exception e) {}
				    }
				    
				    response.sendRedirect("LoginRep.jsp");
	
				}
		        
		        
	
			} catch (Exception e) {
		        e.printStackTrace();
		        out.println("Error processing your request. Please try again. <a href='LoginRep.jsp'>Go back</a>.");
		    } finally {
		        try { if (rs != null) rs.close(); } catch (Exception e) {}
		        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
		        try { if (con != null) con.close(); } catch (Exception e) {}
		    }
		}
		
			
	%>

        
</body>
</html>
