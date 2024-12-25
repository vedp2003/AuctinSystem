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
    <title>Non-Pending Queries</title>
</head>
<body>
 
	<%
	Connection con = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	ApplicationDB db = new ApplicationDB();
	try {
		  con = null;
		  stmt = null;
		  rs = null;
		  db = new ApplicationDB();
		  con = db.getConnection();
		  String str = "SELECT * FROM Query where resolveStatus='resolved' OR resolveStatus='denied' ORDER BY askTiming DESC";
		  
		  stmt = con.prepareStatement(str);
		  rs = stmt.executeQuery();
		  
		  out.println("<b>Non-Pending Queries:</b><br/>");
		  out.println("<table style='width: 100%; border-collapse: collapse;'>");
		  out.println("<tr style='background-color: #f2f2f2;'>");
		  out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Customer ID</th>");
		  out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Query ID</th>");
		  out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Query Text</th>");
		  out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Resolve Text</th>");
		  out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Customer Rep ID</th>");
		  out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Query Asked Timing</th>");
		  out.println("<th style='border: 1px solid #dddddd; padding: 8px; text-align: left;'>Query Resolved Timing</th>");

		  out.println("</tr>");
		
		  while (rs.next()) {
			  
			String endUserID = rs.getString("endUserInfo");
		    int queryID = rs.getInt("queryID");
			String queryText = rs.getString("askDetailsText");
			String queryResolveText = rs.getString("resolveText");
			String customerRepID = rs.getString("customerRepresentationInfo");
			Timestamp askTiming = rs.getTimestamp("askTiming");
			Timestamp resolveTiming = rs.getTimestamp("resolveTiming");

		    
		    out.println("<tr>");
		    out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + endUserID + "</td>");
		    out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + queryID + "</td>");
		    out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + queryText + "</td>");
		    out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + queryResolveText + "</td>");
		    out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + customerRepID + "</td>");
		    out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + askTiming + "</td>");
		    out.println("<td style='border: 1px solid #dddddd; padding: 8px;'>" + resolveTiming + "</td>");

		    out.println("</tr>");
		  }
		
		  out.println("</table>");
		} catch (SQLException e) {
		  e.printStackTrace();
		} finally {
		  try {
		    if (rs != null) rs.close();
		    if (stmt != null) stmt.close();
		    if (con != null) con.close();
		  } catch (SQLException e) {
		    e.printStackTrace();
		  }
		}
		out.println("<br>");
	
	%>
	
	<br><a href='LoginRep.jsp'>Go back to Main Page</a><br><br>
        
</body>
</html>
