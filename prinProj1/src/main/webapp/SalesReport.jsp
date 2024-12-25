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
    <title>Sales Report</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 20px;
            color: #333;
        }
        .tab {
            overflow: hidden;
            border: 1px solid #ccc;
            background-color: #f1f1f1;
        }
        .tab button {
            background-color: inherit;
            color: black;
            float: left;
            cursor: pointer;
            padding: 14px 16px;
            transition: 0.3s;
            font-size: 17px;
        }
        .tab button:hover {
            background-color: #1565c0; 
    		color: black; 
        }
        .tab button.active {
            background-color: #1e88e5;
   			color: black;
        }
        .content {
            display: none;
            padding: 6px 12px;
            border: 1px solid #ccc;
        }
        .eachTab {
            background-color: #555;
            color: white;
            float: left;
            cursor: pointer;
            padding: 14px 16px;
            font-size: 17px;
            width: 16.66%;
        }
        .eachTab:hover {
            background-color: #777;
        }

        
    </style>
</head>
<body>

    <h2>Generate Sales Reports</h2><hr>

	
	<div class="tab">
	  <button class="eachTab" onclick="openTab.call(this, 'TotalEarnings')">Total earnings</button>
	  <button class="eachTab" onclick="openTab.call(this, 'EarningsPerItem')">Earnings per item</button>
	  <button class="eachTab" onclick="openTab.call(this, 'EarningsPerItemType')">Earnings per item type</button>
	  <button class="eachTab" onclick="openTab.call(this, 'EarningsPerEndUser')">Earnings per end-user</button>
	  <button class="eachTab" onclick="openTab.call(this, 'BestSellingItems')">Best-selling items</button>
	  <button class="eachTab" onclick="openTab.call(this, 'BestBuyers')">Best buyers</button>
	</div>
	
	<div id="TotalEarnings" class="content">
	  <h3>Total Earnings</h3>
	  <%
	  ApplicationDB db = new ApplicationDB();  
	  Connection con = db.getConnection();
	  Statement st = con.createStatement();
	  ResultSet rs = null;
	    try {
	      rs = st.executeQuery("SELECT SUM(currentPrice) as totalEarn FROM Auction WHERE closingTime < NOW() AND currentWinner IS NOT NULL");
	      if (rs.next()) {
	        double totalEarn = rs.getDouble("totalEarn");
	  %>
	        <table style='width: 100%; border-collapse: collapse;'>
	          <tr style='background-color: #f2f2f2;'>
	            <th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Total Earnings</th>
	          </tr>
	          <tr>
	            <td style='border: 1px solid #dddddd; padding: 8px;'>$<%=totalEarn%></td>
	          </tr>
	        </table>
	  <%
	      }
	    } catch (SQLException e) {
	      e.printStackTrace();
	    } finally {
	      try {
	        if (rs != null) rs.close();
	        if (st != null) st.close();
	        if (con != null) con.close();
	      } catch (SQLException e) {
	        e.printStackTrace();
	      }
	    }
	  %>
	</div>
	
	<div id="EarningsPerItem" class="content">
	  <h3>Earnings Per Item</h3>
	  <%
	  db = new ApplicationDB();  
	  con = db.getConnection();
	  st = con.createStatement();
	  rs = null;
	  try {
	    rs = st.executeQuery("SELECT * FROM Auction WHERE closingTime < NOW() AND currentWinner IS NOT NULL ORDER BY currentPrice DESC");
	
	    out.println("<table style='width: 100%; border-collapse: collapse;'>");
	    out.println("<tr style='background-color: #f2f2f2;'>");
	    out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Auction ID</th>");
	    out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Category ID</th>");
	    out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Subcategory ID</th>");
	    out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Item ID</th>");
	    out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Initial Price</th>");
	    out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Increment Price</th>");
	    out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Minimum Price</th>");
	    out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Winner</th>");
	    out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Sold Price</th>");
	    out.println("</tr>");
	
	    while (rs.next()) {
	      int auctionID = rs.getInt("auctionID");
	      String catID = rs.getString("catID");
	      String subID = rs.getString("subID");
	      int itemID = rs.getInt("itemID");
	      int initialPrice = rs.getInt("initialPrice");
	      int increment = rs.getInt("increment");
	      int minimumPrice = rs.getInt("minimumPrice");
	      String currentWinner = rs.getString("currentWinner");
	      int currentPrice = rs.getInt("currentPrice");
	
	      out.println("<tr>");
	      out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + auctionID + "</td>");
	      out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + catID + "</td>");
	      out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + subID + "</td>");
	      out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + itemID + "</td>");
	      out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + initialPrice + "</td>");
	      out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + increment + "</td>");
	      out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + minimumPrice + "</td>");
	      out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + currentWinner + "</td>");
	      out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + currentPrice + "</td>");
	      out.println("</tr>");
	    }
	
	    out.println("</table>");
	  } catch (SQLException e) {
	    e.printStackTrace();
	  } finally {
	    try {
	      if (rs != null) rs.close();
	      if (st != null) st.close();
	      if (con != null) con.close();
	    } catch (SQLException e) {
	      e.printStackTrace();
	    }
	  }
	  %>
	</div>
	
	<div id="EarningsPerItemType" class="content">
	  <h3>Earnings Per Item Type</h3>
	  <%
	  db = new ApplicationDB();  
	  con = db.getConnection();
	  st = con.createStatement();
	  rs = null;
	    try {
	      rs = st.executeQuery("SELECT catID, subID, SUM(currentPrice) AS totalEarnItem FROM Auction WHERE closingTime < NOW() AND currentWinner IS NOT NULL GROUP BY catID, subID ORDER BY totalEarnItem DESC");
	  %>
	      <table style='width: 100%; border-collapse: collapse;'>
	        <tr style='background-color: #f2f2f2;'>
	          <th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Category ID</th>
	          <th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Subcategory ID</th>
	          <th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Total Earnings Per Item Type</th>
	        </tr>
	  <%
	      while (rs.next()) {
	        String catID = rs.getString("catID");
	        String subID = rs.getString("subID");
	        double earnItem = rs.getDouble("totalEarnItem");
	  %>
	        <tr>
	          <td style='border: 1px solid #dddddd; padding: 8px;'><%= catID %></td>
	          <td style='border: 1px solid #dddddd; padding: 8px;'><%= subID %></td>
	          <td style='border: 1px solid #dddddd; padding: 8px;'>$<%= earnItem %></td>
	        </tr>
	  <%
	      }
	  %>
	      </table>
	  <%
	    } catch (SQLException e) {
	      e.printStackTrace();
	    } finally {
	      try {
	        if (rs != null) rs.close();
	        if (st != null) st.close();
	        if (con != null) con.close();
	      } catch (SQLException e) {
	        e.printStackTrace();
	      }
	    }
	  %>
	</div>
	
	<div id="EarningsPerEndUser" class="content">
	  <h3>Earnings Per End User</h3>
	  <%
	  db = new ApplicationDB();  
	  con = db.getConnection();
	  st = con.createStatement();
	  rs = null;
	  try {
		rs = st.executeQuery("SELECT item.addedBySellerInfo as endUser, SUM(auction.currentPrice) AS earnUser FROM Auction INNER JOIN item USING (itemID, catID, subID) WHERE closingTime < NOW() AND currentWinner IS NOT NULL GROUP BY item.addedBySellerInfo ORDER BY earnUser DESC");
	
	    out.println("<table style='width: 100%; border-collapse: collapse;'>");
	    out.println("<tr style='background-color: #f2f2f2;'>");
	    out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>End User</th>");
	    out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Earnings Per End-User</th>");
	    out.println("</tr>");
	
	    while (rs.next()) {
	      String user = rs.getString("endUser");
	      double earnUser = rs.getDouble("earnUser");
	
	      out.println("<tr>");
	      out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + user + "</td>");
	      out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>$" + earnUser + "</td>");
	      out.println("</tr>");
	    }
	
	    out.println("</table>");
	  } catch (SQLException e) {
	    e.printStackTrace();
	  } finally {
	    try {
	      if (rs != null) rs.close();
	      if (st != null) st.close();
	      if (con != null) con.close();
	    } catch (SQLException e) {
	      e.printStackTrace();
	    }
	  }
	  %>
	</div>
	
	
	<div id="BestSellingItems" class="content">
	  <h3>Best Selling Items</h3>
	  <%
	  db = new ApplicationDB();  
	  con = db.getConnection();
	  st = con.createStatement();
	  rs = null;
	  try {
	    rs = st.executeQuery("SELECT auctionID, catID, subID, itemID, startingTime, closingTime, initialPrice, increment, minimumPrice, currentWinner, currentPrice AS bestSell FROM Auction WHERE closingTime < NOW() AND currentWinner IS NOT NULL ORDER BY bestSell DESC LIMIT 8");
	
	    out.println("<table style='width: 100%; border-collapse: collapse;'>");
	    out.println("<tr style='background-color: #f2f2f2;'>");
	    out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Auction ID</th>");
	    out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Category ID</th>");
	    out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Subcategory ID</th>");
	    out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Item ID</th>");
	    out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Initial Price</th>");
	    out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Increment Price</th>");
	    out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Minimum Price</th>");
	    out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Winner</th>");
	    out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Sold Price</th>");
	    out.println("</tr>");
	
	    while (rs.next()) {
	      int auctionID = rs.getInt("auctionID");
	      String catID = rs.getString("catID");
	      String subID = rs.getString("subID");
	      int itemID = rs.getInt("itemID");
	      int initialPrice = rs.getInt("initialPrice");
	      int increment = rs.getInt("increment");
	      int minimumPrice = rs.getInt("minimumPrice");
	      String currentWinner = rs.getString("currentWinner");
	      double bestSell = rs.getDouble("bestSell");
	
	      out.println("<tr>");
	      out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + auctionID + "</td>");
	      out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + catID + "</td>");
	      out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + subID + "</td>");
	      out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + itemID + "</td>");
	      out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + initialPrice + "</td>");
	      out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + increment + "</td>");
	      out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + minimumPrice + "</td>");
	      out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + currentWinner + "</td>");
	      out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + bestSell + "</td>");
	      out.println("</tr>");
	    }
	
	    out.println("</table>");
	  } catch (SQLException e) {
	    e.printStackTrace();
	  } finally {
	    try {
	      if (rs != null) rs.close();
	      if (st != null) st.close();
	      if (con != null) con.close();
	    } catch (SQLException e) {
	      e.printStackTrace();
	    }
	  }
	  %>
	</div>
	
	<div id="BestBuyers" class="content">
	  <h3>Best Buyers</h3>
	  <%
	  db = new ApplicationDB();  
	  con = db.getConnection();
	  st = con.createStatement();
	  rs = null;
	  try {
	    rs = st.executeQuery("SELECT auction.currentWinner AS buyer, SUM(auction.currentPrice) AS earningBest FROM Auction WHERE closingTime < NOW() and auction.currentWinner IS NOT NULL GROUP BY auction.currentWinner ORDER BY earningBest DESC LIMIT 8");
	
	    out.println("<table style='width: 100%; border-collapse: collapse;'>");
	    out.println("<tr style='background-color: #f2f2f2;'>");
	    out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Best Buyer</th>");
	    out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Total Purchases</th>");
	    out.println("</tr>");
	
	    while (rs.next()) {
	      String bestBuyer = rs.getString("buyer");
	      double earnBest = rs.getDouble("earningBest");
	
	      out.println("<tr>");
	      out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + bestBuyer + "</td>");
	      out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>$" + earnBest + "</td>");
	      out.println("</tr>");
	    }
	
	    out.println("</table>");
	  } catch (SQLException e) {
	    e.printStackTrace();
	  } finally {
	    try {
	      if (rs != null) rs.close();
	      if (st != null) st.close();
	      if (con != null) con.close();
	    } catch (SQLException e) {
	      e.printStackTrace();
	    }
	  }
	  %>
	</div>
	
	<br><br><br><a href='LoginAdmin.jsp'>Go back to Main Page</a> 
	
	
	<script>
	function openTab(reportName) {
	    var i, tabcontent, tablinks;
	    tabcontent = document.getElementsByClassName("content");
	    for (i = 0; i < tabcontent.length; i++) {
	        tabcontent[i].style.display = "none";
	    }
	    tablinks = document.getElementsByClassName("eachTab");
	    for (i = 0; i < tablinks.length; i++) {
	        tablinks[i].className = tablinks[i].className.replace(" active", "");
	    }
	    document.getElementById(reportName).style.display = "block";
	    this.className += " active";
	}
	</script>

        
</body>
</html>
