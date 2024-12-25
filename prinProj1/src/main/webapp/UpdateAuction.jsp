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
    <title>Update Auction</title>
</head>
<body>
 	
 	<h2>Update Your Auctions</h2><hr>
 	
 	 <%
 		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		
		Statement stmt1 = con.createStatement();
		ResultSet result1 = stmt1.executeQuery("SELECT * FROM Auction a JOIN Item i USING (itemID, catID, subID) WHERE i.addedBySellerInfo='" + session.getAttribute("user").toString() + "' AND a.startingTime<= NOW() AND a.closingTime>=NOW()");

		
		out.println("<b>Your Current auctions:</b><br/>");
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
		
		out.println("<b>Update current auction:</b><br/>");
		out.println("<form action='UpdateCurrentAuction.jsp' method='POST'>");
		out.println("<table>");
		out.println("<tr><td>Auction ID:</td><td><input type='text' name='auctionID' required/></td></tr>");
		out.println("<tr><td>Closing time:</td><td><input type='datetime-local' id='closeTime' name='closingTime'/></td></tr>");
		out.println("<tr><td>Minimum increment price:</td><td><input type='number' name='increment'/></td></tr>");
		out.println("<tr><td>Minimum selling price:</td><td><input type='number' name='minimumPrice'/></td></tr>");
		out.println("</table>&nbsp;<br/> <input type='submit' value='Submit'>");
		out.println("</form><br/><br/>");
		
		
		Statement stmt2 = con.createStatement();
		ResultSet result2 = stmt2.executeQuery("SELECT * FROM Auction a JOIN Item i USING (itemID, catID, subID) WHERE i.addedBySellerInfo='" + session.getAttribute("user").toString() + "' AND a.startingTime>NOW()");

		
		out.println("<b>Your Future auctions:</b><br/>");
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
		
		out.println("<b>Update future auction:</b><br/>");
		out.println("<form action='UpdateFutureAuction.jsp' method='POST'>");
		out.println("<table>");
		out.println("<tr><td>Auction ID:</td><td><input type='text' name='auctionID' required/></td></tr>");
		out.println("<tr><td>Starting time:</td><td><input type='datetime-local' id='startTime' name='startingTime'/></td></tr>");
		out.println("<tr><td>Closing time:</td><td><input type='datetime-local' id='closeTime' name='closingTime'/></td></tr>");
		out.println("<tr><td>Initial price:</td><td><input type='number' name='initialPrice'/></td></tr>");
		out.println("<tr><td>Minimum increment price:</td><td><input type='number' name='increment'/></td></tr>");
		out.println("<tr><td>Minimum selling price:</td><td><input type='number' name='minimumPrice'/></td></tr>");
		out.println("</table>&nbsp;<br/> <input type='submit' value='Submit'>");
		out.println("</form><br/><br/>");
		
		
		con.close();
	%>
	
	
	<a href='LoginUser.jsp'>Go back to Main Page</a><br/>
	
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
		      if (dir == "asc") {
		        if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
		          shouldSwitch= true;
		          break;
		        }
		      } else if (dir == "desc") {
		        if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
		          shouldSwitch= true;
		          break;
		        }
		      }
		    }
		    if (shouldSwitch) {
		      rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
		      switching = true;
		      switchcount ++;      
		    } else {
		      if (switchcount == 0 && dir == "asc") {
		        dir = "desc";
		        switching = true;
		      }
		    }
		  }
		}
	</script>
        

        
</body>
</html>
