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
    <title>Similar Items</title>
</head>
<body>
 	
 	<h2>Similar Items</h2><hr>
	<%
	ApplicationDB db = new ApplicationDB();    
	Connection con = db.getConnection();

	String catID = request.getParameter("catID");
	String subID = request.getParameter("subID");
	String itemID = request.getParameter("itemID");

	String query = "SELECT * " +
					"FROM Auction a JOIN Item i ON a.itemID = i.itemID " +
		            "WHERE i.catID = ? AND i.subID = ? AND a.closingTime >= NOW() - INTERVAL 1 MONTH AND a.closingTime <= NOW() " +
		            "AND i.itemID != ? ORDER BY a.closingTime DESC";

	PreparedStatement stmt = con.prepareStatement(query);
	stmt.setString(1, catID);
	stmt.setString(2, subID);
	stmt.setString(3, itemID);

	ResultSet result = stmt.executeQuery();

	out.println("<b>Similar Items on Auction in Previous Month:</b><br/>");
	out.println("<table style='width: 100%; border-collapse: collapse;'>");
	out.println("<tr style='background-color: #f2f2f2;'>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Auction ID</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Category ID</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Subcategory ID</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Item ID</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Name</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Type</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Starting Time</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Closing Time</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Initial Price</th>");
	out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Selling Price</th>");
	out.println("</tr>");

	while (result.next()) {
	    out.println("<tr>");
	    out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("auctionID"));
	    out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("catID"));
	    out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("subID"));
	    out.println("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("itemID"));
	    out.println("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("name"));
	    out.println("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("type"));
	    out.println("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getTimestamp("startingTime"));
	    out.println("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getTimestamp("closingTime"));
	    out.println("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    out.print(result.getString("initialPrice"));
	    out.println("</td><td style='border: 1px solid #dddddd; padding: 8px;'>");
	    if (result.getString("currentWinner")==null) {
			out.print("Not sold");
		} else {
			out.print(result.getString("currentPrice"));
		}
	    out.println("</td></tr>");
	}

	out.println("</table><br/><br/>");
	
	String clickedFile = request.getParameter("clickedFile");
	out.println("<a href='" + clickedFile + "'>Go back</a>");

	con.close();
	
	%>
	        
</body>
</html>
