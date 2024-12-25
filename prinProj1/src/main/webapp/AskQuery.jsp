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
    <title>Query</title>
</head>
<body>

	<h2>User Queries and Additional Support Forum</h2><hr>
	
	<br><b>Raise Query:</b>
	<form action="VerifyQuery.jsp" method="POST" style="display: flex; align-items: center;">
	    <label for="description" style="margin-right: 10px;">Description:</label>
	    <input type="text" name="detailsText" id="detailsText" required>
	    <input type="submit" value="Submit" style="margin-left: 10px;">
	</form>
	<p>*Note: Include Auction ID number if you wish to request to remove an auction or bid.</p>
	
	<br><br>
	<b>Your queries:</b>
	<table style="width: 100%; border-collapse: collapse; border: 1px solid #ddd; font-family: Arial, sans-serif;">
	    <tr style="background-color: #f2f2f2;">
	        <th style="padding: 8px; border: 1px solid #ddd;">Answering Customer Rep ID</th>
	        <th style="padding: 8px; border: 1px solid #ddd;">Query ID</th>
	        <th style="padding: 8px; border: 1px solid #ddd;">Asked Question Text</th>
	        <th style="padding: 8px; border: 1px solid #ddd;">Response Text</th>
	        <th style="padding: 8px; border: 1px solid #ddd;">Status</th>
	        <th style="padding: 8px; border: 1px solid #ddd;">Time Asked</th>
	        <th style="padding: 8px; border: 1px solid #ddd;">Time Resolved</th>
	    </tr>
	    <%
	        String userName = session.getAttribute("user").toString();
	        Connection con = null;
	        PreparedStatement stmt = null;
	        ResultSet rs = null;
	        try {
	            ApplicationDB db = new ApplicationDB();  
	            con = db.getConnection();
	            String str = "SELECT * FROM Query WHERE endUserInfo = ?";
	            stmt = con.prepareStatement(str);
	            stmt.setString(1, userName);
	            rs = stmt.executeQuery();
	            while (rs.next()) {
	                String customerRep = rs.getString("customerRepresentationInfo");
	                String queryID = rs.getString("queryID");
	                String question = rs.getString("askDetailsText");
	                String answer = rs.getString("resolveText");
	                String status = rs.getString("resolveStatus");
	                Timestamp timeAsked = rs.getTimestamp("askTiming");
	                Timestamp timeResolved = rs.getTimestamp("resolveTiming");
	                %>
	                    <tr>
	                        <td style="padding: 8px; border: 1px solid #ddd;"><%=customerRep%></td>
	                        <td style="padding: 8px; border: 1px solid #ddd;"><%=queryID%></td>
	                        <td style="padding: 8px; border: 1px solid #ddd;"><%=question%></td>
	                        <td style="padding: 8px; border: 1px solid #ddd;"><%=answer%></td>
	                        <td stgv v  yle="padding: 8px; border: 1px solid #ddd;"><%=status%></td>
	                        <td style="padding: 8px; border: 1px solid #ddd;"><%=timeAsked%></td>
	                        <td style="padding: 8px; border: 1px solid #ddd;"><%=timeResolved%></td>
	                    </tr>
	                <%
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        } finally {
	            try { rs.close(); } catch (Exception e) {}
	            try { stmt.close(); } catch (Exception e) {}
	            try { con.close(); } catch (Exception e) {}
	        }
	    %>
	</table><br/>	
	
	<br><a href='LoginUser.jsp'>Go back to Main Page</a><br/><br/>
	
        
</body>
</html>
