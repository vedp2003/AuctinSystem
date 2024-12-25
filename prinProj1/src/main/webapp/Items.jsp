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
    <title>Items</title>
</head>
<body>
    <h2>View Your Items</h2><hr>
    Filter Options: 
    <form action="Items.jsp" method="get">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" value="<%= request.getParameter("name") != null ? request.getParameter("name") : "" %>" placeholder="Search by name...">
        <br>
        <label for="year">Year:</label>
        <input type="text" id="year" name="year" value="<%= request.getParameter("year") != null ? request.getParameter("year") : "" %>" placeholder="Search by year...">
        <input type="submit" value="Filter">
        <input type="button" value="Reset" onclick="window.location.href='Items.jsp';">
    </form>
    <br></br>
    

    <%
        ApplicationDB db = new ApplicationDB();    
        Connection con = db.getConnection();
        String name = request.getParameter("name");
        String year = request.getParameter("year");
        String sqlQuery = "SELECT * FROM Item WHERE addedBySellerInfo='" + session.getAttribute("user").toString() + "'";

        if (name != null && !name.isEmpty()) {
            sqlQuery += " AND name LIKE '%" + name + "%'";
        }
        if (year != null && !year.isEmpty()) {
            sqlQuery += " AND year='" + year + "'";
        }

        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery(sqlQuery);

        out.println("<b>Your items:</b><br/>");
        out.println("<table id='itemsTable' style='border-collapse: collapse; width: 100%;'>");
        out.println("<tr style='background-color: #f2f2f2;'>");
        out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(0)'>CategoryID</th>");
        out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(1)'>SubcategoryID</th>");
        out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(2)'>ItemID</th>");
        out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(3)'>Name</th>");
        out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(4)'>Type</th>");
        out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(5)'>Year</th>");
        out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(6)'>Color</th>");
        out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(7)'>Weight</th>");
        out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(8)'>Screen Size</th>");
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
        con.close();
    %>

    <a href='LoginUser.jsp'>Go back to Main Page</a>

    <script>
    function sortTable(n) {
        var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
        table = document.getElementById("itemsTable");
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
