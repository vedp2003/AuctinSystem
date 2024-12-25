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
<style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 20px;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #ffffff;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #dddddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #90caf9;
            color: #ffffff;
        }
        tr:nth-child(even) {
            background-color: #f1f1f1;
        }
        input[type="text"], input[type="number"], select {
            width: 95%;
            padding: 10px;
            margin: 8px 0;
            display: inline-block;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        input[type="submit"], button {
            background-color: #1e88e5;
            border: none;
            color: white;
            padding: 12px 20px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 4px 2px;
            cursor: pointer;
            border-radius: 4px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }
        input[type="submit"]:hover, button:hover {
            background-color: #1565c0;
        }
        .footer {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #ccc;
        }
        a {
            color: #0277bd;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Auto Bid</title>
</head>
<body>
 
 	<h2>Auction Auto-bidding</h2><hr>
	<%
	ApplicationDB db = new ApplicationDB();    
	Connection con = db.getConnection();

	Statement stmt = con.createStatement();
	ResultSet result = stmt.executeQuery("SELECT * FROM Auction a JOIN Item i USING (itemID, catID, subID) WHERE a.startingTime<=NOW() AND a.closingTime>=NOW() AND i.addedBySellerInfo!='" + session.getAttribute("user").toString() + "'");

	out.println("<b>Live auctions:</b><br/>");
	out.println("<table style='width: 100%; border-collapse: collapse;'>");
	out.println("<tr style='background-color: #f2f2f2;'>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Auction ID</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Category ID</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Subcategory ID</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Item ID</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Name</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Type</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Starting time</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Closing time</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Initial price</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Increment price</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Current price</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Similar items and Bidding History</th>");
	
	out.println("</tr>");
	while (result.next()) {
	    String itemID = result.getString("itemID");
	    String catID = result.getString("catID");
	    String subID = result.getString("subID");
	    String auctionID = result.getString("auctionID");

	    out.println("<tr>");
	    out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("auctionID"));
	    out.println("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(catID);
	    out.println("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(subID);
	    out.println("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(itemID);
	    out.println("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("name"));
	    out.println("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("type"));
	    out.println("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("startingTime"));
	    out.println("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("closingTime"));
	    out.println("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("initialPrice"));
	    out.println("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("increment"));
	    out.println("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("currentPrice"));
	    out.println("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");

	    out.println("<form action='SimilarItems.jsp' method='POST'>");
	    out.println("<input type='hidden' name='category_id' value='" + catID + "' >");
	    out.println("<input type='hidden' name='item_id' value='" + itemID + "' >");
	    out.println("<input type='hidden' name='subcategory_id' value='" + subID + "' >");
	    out.println("<input type='hidden' name='clickedFile' value='Autobid.jsp'>");
	    out.println("<input type='submit' value='View Similar items'>");
	    out.println("</form>");
	    
	    out.println("<form action='BidHistory.jsp' method='GET'>");
	    out.println("<input type='hidden' name='auctionID' value='" + auctionID + "' >");
	    out.println("<input type='hidden' name='clickedFile' value='Autobid.jsp'>");
	    out.println("<input type='submit' value='View Bidding History'>");
	    out.println("</form>");

	    out.println("</td></tr>");
	    
	 
	}
	out.println("</table><br/><br/>");
	
	
	out.println("<b>Auctions you participated in:</b><br/>");
	out.println("<table style='width: 100%; border-collapse: collapse;'>");
	out.println("<tr style='background-color: #f2f2f2;'>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Auction ID</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Category ID</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Subcategory ID</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Item ID</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Name</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Type</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Year</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Current/selling price</th>");
	out.println("</tr>");

	result = stmt.executeQuery("SELECT DISTINCT i.itemID, i.name, i.type, i.year, i.catID, i.subID, a.auctionID, a.currentPrice FROM Bidding b JOIN auction a using (auctionID) JOIN item i using (itemID) WHERE userName='" + session.getAttribute("user").toString() + "'");
	while (result.next()) {
	    out.println("<tr>");
	    out.print("<td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("auctionID"));
	    out.print("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("catID"));
	    out.print("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("subID"));
	    out.print("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("itemID"));
	    out.print("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("name"));
	    out.print("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("type"));
	    out.print("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("year"));
	    out.print("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("currentPrice"));
	    out.println("</td></tr>");
	}
	out.println("</table><br/><br/>");


	out.println("<b>Your AutoBids:</b><br/>");
	out.println("<table style='width: 100%; border-collapse: collapse;'>");
	out.println("<tr style='background-color: #f2f2f2;'>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Auction ID</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Upper Limit</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Last Updated Time</th>");
	out.println("</tr>");

	result = stmt.executeQuery("SELECT * FROM AutoBid WHERE userName='" + session.getAttribute("user").toString()+"'");
	while (result.next()) {
	    out.println("<tr>");
	    out.print("<td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("auctionID"));
	    out.print("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("upperLimit"));
	    out.print("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("startTime"));
	    out.print("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    
	    out.println("</td></tr>");
	}
	out.println("</table><br/><br/>");

	out.println("<b>Start autobid:</b><br/>");
	out.println("<form action='StartAutoBid.jsp' method='POST'>");
	out.println("<table>");
	out.println("<tr><td>Auction ID:</td><td><input type='text' name='auctionID' required/></td></tr>");
	out.println("<tr><td>Desired Upper Limit:</td><td><input type='number' name='upper' required/></td></tr>");
	out.println("</table>&nbsp;<br/> <input type='submit' value='Submit'>");
	out.println("</form><br/><br/>");
	
	out.println("<b>Update autobid:</b><br/>");
	out.println("<form action='UpdateAutobid.jsp' method='POST'>");
	out.println("<table>");
	out.println("<tr><td>Auction ID:</td><td><input type='text' name='auctionID' required/></td></tr>");
	out.println("<tr><td>Updated Upper Limit:</td><td><input type='number' name='upper' required/></td></tr>");
	out.println("</table>&nbsp;<br/> <input type='submit' value='Submit'>");
	out.println("</form><br/><br/>");
	
	out.println("<b>Delete autobid:</b><br/>");
	out.println("<form action='DeleteAutobid.jsp' method='POST'>");
	out.println("<table>");
	out.println("<tr><td>Auction ID:</td><td><input type='text' name='auctionID' required/></td></tr>");
	out.println("</table>&nbsp;<br/> <input type='submit' value='Submit'>");
	out.println("</form><br/><br/>");

	con.close();
	%>
	
	<a href='LoginUser.jsp'>Go back to Main Page</a>
        
</body>
</html>
