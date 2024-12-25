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
    <title>Delete Item</title>
</head>
<body>
	
	<h2>Delete Existing Item</h2><hr>

 	 <%
 		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		Statement stmt = con.createStatement();
		ResultSet rs = stmt.executeQuery("SELECT * FROM Item WHERE addedBySellerInfo='" + session.getAttribute("user").toString()+ "'");
		
		out.println("<b>Your items:</b><br/>");
		out.println("<table style='border-collapse: collapse; width: 100%;'>");
		out.println("<tr style='background-color: #f2f2f2;'>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>CategoryID</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>SubcategoryID</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>ItemID</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>Name</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>Type</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>Year</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>Color</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>Weight</th>");
		out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>Screen Size</th>");
		out.println("</tr>");
		while (rs.next()) {
		    out.println("<tr>");
		    out.print("<td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(rs.getString("catID"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(rs.getString("subID"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(rs.getString("itemID"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(rs.getString("name"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(rs.getString("type"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(rs.getString("year"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(rs.getString("shortDescription"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(rs.getString("middleDescription"));
		    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
		    out.print(rs.getString("longDescription"));
		    out.println("</td></tr>");
		}
		out.println("</table><br/><br/>");
		
		out.println("<b>Delete item:</b><br/>");
		out.println("<form action='VerifyDeleteItem.jsp' method='POST'>");
		out.println("<table>");

		out.println("<tr><td>CategoryID:</td><td><input type='text' name='catID' required/></td></tr>");
		out.println("<tr><td>SubcategoryID:</td><td><input type='text' name='subID' required/></td></tr>");
		out.println("<tr><td>ItemID:</td><td><input type='text' name='itemID' required/></td></tr>");
		
		out.println("</table>&nbsp;<br/> <input type='submit' value='Submit'>");
		out.println("</form>");
		
	
		con.close();
	%>
	
	<br><br><a href='LoginUser.jsp'>Go back to Main Page</a>
	
        
</body>
</html>
