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
    <title>All Auctions</title>
</head>
<body>
 	<h2>View all Your Auctions</h2><hr>
 	
 	 <%
 		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		Statement stmt = con.createStatement();
		
		
		ResultSet rs = stmt.executeQuery("SELECT * FROM Auction WHERE closingTime < NOW() AND currentWinner IS NOT NULL");
		
		while (rs.next()) {
			double minimumPrice = Double.parseDouble(rs.getString("minimumPrice"));
			double currentPrice = Double.parseDouble(rs.getString("currentPrice"));
			if (currentPrice<minimumPrice) {
				String str = "UPDATE Auction SET currentWinner=NULL WHERE auctionID=?";
				PreparedStatement ps = con.prepareStatement(str);
				ps.setString(1, rs.getString("auctionID"));
				ps.executeUpdate();
			} else {
				
				String str = "INSERT IGNORE INTO Alert(message, alertTiming, endUserInfo)"
						+ "VALUES (?, ?, ?)";
				PreparedStatement ps = con.prepareStatement(str);
				ps.setString(1, "Congrats! You won Auction "+rs.getString("auctionID")+" for $"+rs.getString("currentPrice")+".");
				ps.setString(2, rs.getString("closingTime"));
				ps.setString(3, rs.getString("currentWinner"));
				ps.executeUpdate();
				
		
			}
		}
		
		Statement stmt0 = con.createStatement();
		ResultSet result = stmt0.executeQuery("SELECT * FROM Auction a JOIN Item i USING (itemID, catID, subID) WHERE i.addedBySellerInfo='" + session.getAttribute("user").toString() + "' AND a.closingTime<NOW()");
		
		out.println("<b>Past auctions:</b><br/>");
		out.println("<table id='pastAuctionsTable' style='border-collapse: collapse; width: 100%;'>");
		out.println("<tr style='background-color: #f2f2f2;'>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"pastAuctionsTable\",0)'>Auction ID</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"pastAuctionsTable\",1)'>Category ID</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"pastAuctionsTable\",2)'>Subcategory ID</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"pastAuctionsTable\",3)'>Item ID</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"pastAuctionsTable\",4)'>Name</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"pastAuctionsTable\",5)'>Type</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"pastAuctionsTable\",6)'>Year</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"pastAuctionsTable\",7)'>Starting time</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"pastAuctionsTable\",8)'>Closing time</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"pastAuctionsTable\",9)'>Initial price</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"pastAuctionsTable\",10)'>Increment price</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"pastAuctionsTable\",11)'>Minimum price</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"pastAuctionsTable\",12)'>Winner</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"pastAuctionsTable\",13)'>Price sold</th>");
		out.println("</tr>");
		while (result.next()) {
		    out.println("<tr>");
		    out.print("<td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result.getString("auctionID"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result.getString("catID"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result.getString("subID"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result.getString("itemID"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result.getString("name"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result.getString("type"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result.getString("year"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result.getString("startingTime"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result.getString("closingTime"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result.getString("initialPrice"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result.getString("increment"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result.getString("minimumPrice"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result.getString("currentWinner"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    if(result.getString("currentWinner") == null) {
		    	out.print("Not Sold");
		    }
		    else {
		    	out.print(result.getString("currentPrice"));
		    }
		    out.println("</td></tr>");
		}
		out.println("</table><br/><br/>");
		
		Statement stmt1 = con.createStatement();
		ResultSet result1 = stmt1.executeQuery("SELECT * FROM Auction a JOIN Item i USING (itemID, catID, subID) WHERE i.addedBySellerInfo='" + session.getAttribute("user").toString() + "' AND a.startingTime<= NOW() AND a.closingTime>=NOW()");

		
		out.println("<b>Current auctions:</b><br/>");
		out.println("<table id='currAuctionsTable' style='border-collapse: collapse; width: 100%;'>");
		out.println("<tr style='background-color: #f2f2f2;'>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"currAuctionsTable\",0)'>Auction ID</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"currAuctionsTable\",1)'>Category ID</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"currAuctionsTable\",2)'>Subcategory ID</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"currAuctionsTable\",3)'>Item ID</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"currAuctionsTable\",4)'>Name</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"currAuctionsTable\",5)'>Type</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"currAuctionsTable\",6)'>Year</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"currAuctionsTable\",7)'>Starting time</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"currAuctionsTable\",8)'>Closing time</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"currAuctionsTable\",9)'>Initial price</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"currAuctionsTable\",10)'>Increment price</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"currAuctionsTable\",11)'>Minimum price</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"currAuctionsTable\",12)'>Current winner</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"currAuctionsTable\",13)'>Current price</th>");
		out.println("</tr>");
		while (result1.next()) {
		    out.println("<tr>");
		    out.print("<td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result1.getString("auctionID"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result1.getString("catID"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result1.getString("subID"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result1.getString("itemID"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result1.getString("name"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result1.getString("type"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result1.getString("year"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result1.getString("startingTime"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result1.getString("closingTime"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result1.getString("initialPrice"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result1.getString("increment"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result1.getString("minimumPrice"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result1.getString("currentWinner"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result1.getString("currentPrice"));
		    out.println("</td></tr>");
		}
		out.println("</table><br/><br/>");
		
		Statement stmt2 = con.createStatement();
		ResultSet result2 = stmt2.executeQuery("SELECT * FROM Auction a JOIN Item i USING (itemID, catID, subID) WHERE i.addedBySellerInfo='" + session.getAttribute("user").toString() + "' AND a.startingTime>NOW()");

		
		out.println("<b>Future auctions:</b><br/>");
		out.println("<table id='futureAuctionsTable' style='border-collapse: collapse; width: 100%;'>");
		out.println("<tr style='background-color: #f2f2f2;'>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"futureAuctionsTable\",0)'>Auction ID</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"futureAuctionsTable\",1)'>Category ID</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"futureAuctionsTable\",2)'>Subcategory ID</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"futureAuctionsTable\",3)'>Item ID</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"futureAuctionsTable\",4)'>Name</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"futureAuctionsTable\",5)'>Brand</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"futureAuctionsTable\",6)'>Year</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"futureAuctionsTable\",7)'>Starting time</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"futureAuctionsTable\",8)'>Closing time</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"futureAuctionsTable\",9)'>Initial price</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"futureAuctionsTable\",10)'>Increment price</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(\"futureAuctionsTable\",11)'>Minimum price</th>");
		out.println("</tr>");
		while (result2.next()) {
		    out.println("<tr>");
		    out.print("<td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result2.getString("auctionID"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result2.getString("catID"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result2.getString("subID"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result2.getString("itemID"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result2.getString("name"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result2.getString("type"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result2.getString("year"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result2.getString("startingTime"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result2.getString("closingTime"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result2.getString("initialPrice"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result2.getString("increment"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(result2.getString("minimumPrice"));
		    out.println("</td></tr>");
		}
		out.println("</table><br/><br/>");
		
		
		con.close();
	%>
	
	<br><a href='LoginUser.jsp'>Go back to Main Page</a>
	
	<script>
	function sortTable(tableName, n) {
	    var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
	    table = document.getElementById(tableName);
	    switching = true;
	    dir = "asc"; 
	    
	    while (switching) {
	        switching = false;
	        rows = table.rows;
	        
	        for (i = 1; i < (rows.length - 1); i++) {
	            shouldSwitch = false;
	            x = rows[i].getElementsByTagName("TD")[n];
	            y = rows[i + 1].getElementsByTagName("TD")[n];
	            
	            if (x && y) {
	                var xValue = x.innerHTML.toLowerCase();
	                var yValue = y.innerHTML.toLowerCase();

	                var compareResult;
	                if (isNaN(xValue) || isNaN(yValue)) {
	                    compareResult = xValue.localeCompare(yValue);
	                } else {
	                    var xNum = parseFloat(xValue);
	                    var yNum = parseFloat(yValue);

	                    if (xValue === "Not Sold" || xValue === "null") {
	                        xNum = -Infinity;
	                    }
	                    if (yValue === "Not Sold" || yValue === "null") {
	                        yNum = -Infinity;
	                    }

	                    compareResult = xNum - yNum;
	                }

	                if (dir == "asc") {
	                    shouldSwitch = compareResult > 0;
	                } else if (dir == "desc") {
	                    shouldSwitch = compareResult < 0;
	                }
	            }

	            if (shouldSwitch) {
	                rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
	                switching = true;
	                switchcount ++;      
	                break; 
	            }
	        }
	        
	        if (!shouldSwitch && switchcount == 0 && dir == "asc") {
	            dir = "desc";
	            switching = true;
	        }
	    }
	}
	</script>
        
</body>
</html>
