<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
   pageEncoding="ISO-8859-1" import="samplePackage.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<% 
if ("true".equals(request.getParameter("logout"))) {
    session.invalidate();
    response.sendRedirect("Login.jsp");
    return;
} 
if (session.getAttribute("user") == null) {
    response.sendRedirect("Login.jsp");
    return;
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Customer Rep Account</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 10px;
            display: flex;
            justify-content: center;
            align-items: flex-start;
        }
        .container {
            background: white;
            padding: 10px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            width: 80%;
            max-width: 800px;
        }
        h2, p {
            text-align: center;
            color: #333;
            margin: 5px 0;
        }
        .section {
            background-color: #f9f9f9;
            padding: 10px;
            margin-top: 10px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed; 
        }
        th, td {
            padding: 8px;
            border: 1px solid #ddd;
            text-align: left;
            font-size: 14px;
        }
        th {
            background-color: #f2f2f2;
        }
        input[type="number"], input[type="text"], input[type="submit"] {
            width: 100%;
            padding: 6px;
            margin-top: 4px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        input[type="submit"] {
            background-color: #007BFF;
            color: white;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        a {
            color: #007bff;
            text-decoration: none;
            margin: 5px 0;
            display: inline-block;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>CUSTOMER REP PORTAL</h2>
        <p><strong>( Name: <%= session.getAttribute("name") %> &amp; UserName: <%= session.getAttribute("user") %> )</strong></p>
        <hr>
        
        <%
        String userName = session.getAttribute("user").toString();
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        ApplicationDB db = new ApplicationDB();

        try {
            con = db.getConnection();
            String str = "SELECT * FROM Query where resolveStatus='pending'";
            stmt = con.prepareStatement(str);
            rs = stmt.executeQuery();

            out.println("<b>Pending Queries:</b><br/>");
            out.println("<table>");
            out.println("<tr><th>End-User ID</th><th>Query ID</th><th>Query Text</th><th>Query Ask Timing</th></tr>");
            while (rs.next()) {
                out.println("<tr><td>" + rs.getString("endUserInfo") + "</td><td>" + rs.getInt("queryID") +
                "</td><td>" + rs.getString("askDetailsText") + "</td><td>" + rs.getTimestamp("askTiming") + "</td></tr>");
            }
            out.println("</table>");
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (con != null) con.close();
        }
        out.println("<br>");

        out.println("<div class='section'>");
        out.println("<b>Resolve Query Actions:</b>");
        out.println("<form action='ResolveQuery.jsp' method='POST'><table>");
        out.println("<tr><td>Query ID:</td><td><input type='number' name='queryID' required/></td></tr>");
        out.println("<tr><td>Response Text:</td><td><input type='text' name='response' required/></td></tr>");
        out.println("</table><br/><input type='submit' value='Submit'></form>");
        out.println("</div>");

        out.println("<b>Resolve Query: Delete Requested Auction</b><br/>");
		out.println("<form action='VerifyDeleteAuction.jsp' method='POST'>");
		out.println("<table style='border-collapse: collapse;'>");
		out.println("<tr><td>Query ID:</td><td><input type='number' name='queryID' required/></td></tr>");
		out.println("<tr><td>Auction ID:</td><td><input type='number' name='auctionID' required/></td></tr>");
		out.println("<tr><td>Seller ID:</td><td><input type='text' name='userName' required/></td></tr>");
		out.println("</table>&nbsp;<br/> <input type='submit' value='Submit'>");
		out.println("</form><br/>");
		
		out.println("<b>Resolve Query: Delete Requested Bid</b><br/>");
		out.println("<form action='DeleteBid.jsp' method='POST'>");
		out.println("<table style='border-collapse: collapse;'>");
		out.println("<tr><td>Query ID:</td><td><input type='number' name='queryID' required/></td></tr>");
		out.println("<tr><td>Auction ID:</td><td><input type='number' name='auctionID' required/></td></tr>");
		out.println("</table>&nbsp;<br/> <input type='submit' value='Submit'>");
		out.println("</form><br/>");
		out.println("<br>");
		
		out.println("<b>Resolve Query: Modify User Information</b><br/>");
		out.println("<form action='ModifyInfo.jsp' method='POST'>");
		out.println("<table style='border-collapse: collapse;'>");
		out.println("<tr><td>Query ID:</td><td><input type='number' name='queryID' required/></td></tr>");
		out.println("</table>&nbsp;<br/> <input type='submit' value='Submit'>");
		out.println("</form><br/>");
		out.println("<br>");
		
		out.println("<b>Remove Illegal Auctions</b><br/>");
		out.println("<a href='ViewAllAuctions.jsp'>View All Auctions</a><br/><br/>");
		out.println("<form action='VerifyDeleteAuction.jsp' method='POST'>");
		out.println("<table style='border-collapse: collapse;'>");
		out.println("<tr><td>Auction ID:</td><td><input type='number' name='auctionID' required/></td></tr>");
		out.println("<tr><td>Seller ID:</td><td><input type='text' name='userName' required/></td></tr>");
		out.println("<input type='hidden' name='hiddenField' value='true'>");
		out.println("</table>&nbsp;<br/> <input type='submit' value='Submit'>");
		out.println("</form><br/>");
		out.println("<br><hr><br>");
		
		out.println("<a href='ViewNonPendingQuery.jsp'>View Non-Pending Queries</a><br/><br/>");
		
		
      

		%>
	        
		<a href="Login.jsp?logout=true">Log out</a>

        
    </div>
</body>
</html>
