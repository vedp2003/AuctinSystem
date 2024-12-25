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
    <title>Start Auction</title>
    <script>
        function validateTimes() {
            var startTime = document.getElementById('startTime').value;
            var closeTime = document.getElementById('closeTime').value;
            if (closeTime < startTime) {
                alert("Closing time must be after the current time and after the starting time.");
                return false;
            }
            return true;
        }
    </script>
    
</head>
<body>
    <h2>Start New Auction</h2><hr>
    <%
        ApplicationDB db = new ApplicationDB();    
        Connection con = db.getConnection();
        
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM Item WHERE addedBySellerInfo='" + session.getAttribute("user").toString() + "'");
        
        out.println("<b>Your items:</b><br/>");
        out.println("<table id='itemsTable' style='border-collapse: collapse; width: 100%;'>");
        out.println("<tr style='background-color: #f2f2f2;'>");
        out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(0)'>CategoryID</th>");
        out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(1)'>SubcategoryID</th>");
        out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(2)'>ItemID</th>");
        out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(3)'>Name</th>");
        out.println("<th style's border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(4)'>Type</th>");
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
        
        out.println("<b>Start auction for an item:</b><br/>");
        out.println("<form action='VerifyAuction.jsp' method='POST' onsubmit='return validateTimes();'>");
        out.println("<table>");
        out.println("<tr><td>Category ID:</td><td><input type='text' name='catID' required/></td></tr>");
        out.println("<tr><td>Subcategory ID:</td><td><input type='text' name='subID' required/></td></tr>");
        out.println("<tr><td>Item ID:</td><td><input type='text' name='itemID' required/></td></tr>");        
        out.println("<tr><td>Starting time:</td><td><input type='datetime-local' id='startTime' name='startingTime' required/></td></tr>");
        out.println("<tr><td>Closing time:</td><td><input type='datetime-local' id='closeTime' name='closingTime' required/></td></tr>");
        out.println("<tr><td>Initial price:</td><td><input type='number' name='initialPrice' required/></td></tr>");
        out.println("<tr><td>Minimum increment price:</td><td><input type='number' name='increment' required/></td></tr>");
        out.println("<tr><td>Minimum selling price (optional, not shown to buyer):</td><td><input type='number' name='minimumPrice'/></td></tr>");
        out.println("</table>&nbsp;<br/> <input type='submit' value='Submit'>");
        out.println("</form><br/>");

        con.close();
    %>
    
    <br><a href='LoginUser.jsp'>Go back to Main Page</a>
    
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
              if (switchcount == 0 and dir == "asc") {
                dir = "desc";
                switching = true;
              }
            }
          }
        }
    </script>

</body>
</html>
