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
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Wishlist</title>
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
</head>
<body> 	
 	<h2>Add Item to Wishlist</h2><hr>
 	<%
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		Statement stmt = con.createStatement();
		
	
		String userName = session.getAttribute("user").toString();
		String checker = request.getParameter("check");
		String catID = request.getParameter("category");
		String subID = request.getParameter("subcategory");
		String name = request.getParameter("name");
		String type = request.getParameter("type");
		String exactYear = request.getParameter("eyear");
		String newerYear = request.getParameter("nyear");
		String olderYear = request.getParameter("oyear");
		String color = request.getParameter("color");
		String weight = request.getParameter("weight");
		String size = request.getParameter("size");
		
		
		String query = "SELECT * FROM Item WHERE addedBySellerInfo !='" + userName + "'";
		
		if(checker!=null && !checker.matches("true")){
		
			if(!catID.isEmpty()){
				query += " AND catID LIKE '" + catID + "'";
			}
			if(subID!=null && !subID.isEmpty()){
				query += " AND subID LIKE '" + subID + "'";
			}
			if(!name.isEmpty()){
				query += " AND name LIKE '%" + name + "%'";
			}
			if(!type.isEmpty()){
				query += " AND type LIKE '%" + type + "%'";
			}
			if(!exactYear.isEmpty()){
			    query += " AND year = '" + exactYear + "'";
			}
			if(!olderYear.isEmpty()){
			    query += " AND year < '" + olderYear + "'";
			}
			if(!newerYear.isEmpty()){
			    query += " AND year > '" + newerYear + "'";
			}
			if(!color.isEmpty()){
				query += " AND shortDescription LIKE '%" + color + "%'";
			}
			if(!weight.isEmpty()){
				query += " AND middleDescription LIKE '%" + weight + "%'";
			}
			if(!size.isEmpty()){
				query += " AND longDescription LIKE '%" + size + "%'";
			}
		}
		
		ResultSet rs = stmt.executeQuery(query);
		
		if (rs.next() == false) {
			out.println("No items in the inventory<br/><br/>");
		}
		else {
			
			
			out.println("<b>All available items:</b><br/>");
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
			out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;' onclick='sortTable(9)'>Seller</th>");
			out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>Add to Wishlist</th>");
			out.println("</tr>");

			
			
			do {
				
				String itemID = rs.getString("itemID");
				catID = rs.getString("catID");
				subID = rs.getString("subID");
				
				
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
			    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
			    out.print(rs.getString("addedBySellerInfo"));
			    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");

			    
			    out.println("<form action='AddWishlist.jsp' method='POST'>");
				out.println("<input type='hidden' name='userName' value='" + userName + "' >");
				out.println("<input type='hidden' name='catID' value='" + catID + "' >");
				out.println("<input type='hidden' name='itemID' value='" + itemID + "' >");
				out.println("<input type='hidden' name='subID' value='" + subID + "' >");
				out.println("<input type='submit' value='Add to Wishlist'>");
				out.println("</form>");
			    
			    out.println("</td></tr>");
			} while (rs.next());
			rs.close();
			out.println("</table><br/><br/>");
			
		}
		
		
		catID = request.getParameter("category") != null ? request.getParameter("category") : "";
		subID = request.getParameter("subcategory") != null ? request.getParameter("subcategory") : "";
		name = request.getParameter("name") != null ? request.getParameter("name") : "";
		type = request.getParameter("type") != null ? request.getParameter("type") : "";
		exactYear = request.getParameter("eyear") != null ? request.getParameter("eyear") : "";
		olderYear = request.getParameter("oyear") != null ? request.getParameter("oyear") : "";
		newerYear = request.getParameter("nyear") != null ? request.getParameter("nyear") : "";

		color = request.getParameter("color") != null ? request.getParameter("color") : "";
		weight = request.getParameter("weight") != null ? request.getParameter("weight") : "";
		size = request.getParameter("size") != null ? request.getParameter("size") : "";
		
		out.println("<b>Active Filters:</b><br/>");
		if (!catID.isEmpty() || !subID.isEmpty() || !name.isEmpty() || !type.isEmpty() || !exactYear.isEmpty() || !newerYear.isEmpty() || !olderYear.isEmpty() || !color.isEmpty() || !weight.isEmpty() || !size.isEmpty()) {
	        out.println("<ul>");
	        if (!catID.isEmpty()) out.println("<li>Category: " + catID + "</li>");
	        if (!subID.isEmpty()) out.println("<li>Subcategory: " + subID + "</li>");
	        if (!name.isEmpty()) out.println("<li>Name: " + name + "</li>");
	        if (!type.isEmpty()) out.println("<li>Type: " + type + "</li>");
	        if (!exactYear.isEmpty()) out.println("<li>Exact Year: " + exactYear + "</li>");
	        if (!olderYear.isEmpty()) out.println("<li>Older than Year: " + olderYear + "</li>");
	        if (!newerYear.isEmpty()) out.println("<li>Newer than Year: " + newerYear + "</li>");
	        if (!color.isEmpty()) out.println("<li>Color: " + color + "</li>");
	        if (!weight.isEmpty()) out.println("<li>Weight: " + weight + "</li>");
	        if (!size.isEmpty()) out.println("<li>Screen Size: " + size + "</li>");
	        out.println("</ul>");
	    } else {
	        out.println("No filters applied.<br/>");
	    }
		out.println("<br>");

	    
	    
	    out.println("<b>Filters:</b><br/>");
		out.println("<form action='Wishlist.jsp' method='POST'>");
		out.println("<table>");
		out.println("<tr><td>Category:</td><td><select id='category' name='category' size=1 onclick='initializeDropper()' onchange='initializeDropper()'>");
		
		out.println("<option value='' selected>Select Category</option>");
		out.println("<option value='DEVS'>Devices</option>");
	
		out.println("</select></td></tr>");
		out.println("<tr><td>Subcategory:</td><td><select id='subcategory' name='subcategory' size=1></select></td></tr>");

		out.println("<tr><td>Name:</td><td><input type='text' name='name'/></td></tr>");
		out.println("<tr><td>Type:</td><td><input type='text' name='type'/></td></tr>");
		out.println("<tr><td>Exact Year:</td><td><input type='number' name='eyear'/></td></tr>");
		out.println("<tr><td>Older than Year:</td><td><input type='number' name='oyear'/></td></tr>");
		out.println("<tr><td>Newer than Year:</td><td><input type='number' name='nyear'/></td></tr>");
		out.println("<tr><td>Color:</td><td><input type='text' name='color'/></td></tr>");
		out.println("<tr><td>Weight:</td><td><input type='text' name='weight'/></td></tr>");
		out.println("<tr><td>Screen Size:</td><td><input type='text' name='size'/></td></tr>");
		out.println("<input type='hidden' name='check' value='false'>");
		out.println("</table>&nbsp;<br/> <input type='submit' value='Submit'>");
		out.println("</form>");
		out.println("<br>");
		
		out.println("<a href='Wishlist.jsp'>Clear all filters</a><br/>");
		out.println("<br><br>");


		ResultSet rs1 = stmt.executeQuery("SELECT * FROM Wishlist w INNER JOIN Item i USING (itemID) WHERE userName ='" + userName + "'");
		if (!rs1.isBeforeFirst()) {
			out.println("Your Wishlist Items:<br>No Items<br/><br/>");
		}
		else {
			
			out.println("<b>Your Wishlist Items:</b><br/>");
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
			out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>Seller</th>");
			out.println("<th style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>Remove from Wishlist</th>");
			out.println("</tr>");
			
			while (rs1.next()) {
				String itemID = rs1.getString("itemID");
				catID = rs1.getString("catID");
				subID = rs1.getString("subID");
				
				
			    out.println("<tr>");
			    out.print("<td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
			    out.print(rs1.getString("catID"));
			    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
			    out.print(rs1.getString("subID"));
			    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
			    out.print(rs1.getString("itemID"));
			    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
			    out.print(rs1.getString("name"));
			    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
			    out.print(rs1.getString("type"));
			    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
			    out.print(rs1.getString("year"));
			    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
			    out.print(rs1.getString("shortDescription"));
			    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
			    out.print(rs1.getString("middleDescription"));
			    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
			    out.print(rs1.getString("longDescription"));
			    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");
			    out.print(rs1.getString("addedBySellerInfo"));
			    out.print("</td><td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>");

			    
			    out.println("<form action='RemoveWishlist.jsp' method='POST'>");
				out.println("<input type='hidden' name='userName' value='" + userName + "' >");
				out.println("<input type='hidden' name='catID' value='" + catID + "' >");
				out.println("<input type='hidden' name='itemID' value='" + itemID + "' >");
				out.println("<input type='hidden' name='subID' value='" + subID + "' >");
				out.println("<input type='submit' value='Remove From Wishlist'>");
				out.println("</form>");
			    
			    out.println("</td></tr>");
				
			}
			out.println("</table><br/><br/>");
		}
		
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
	

	<script>
		function initializeDropper() {
			    const categoryDropdown = document.getElementById("category");
			    const subcategoryDropdown = document.getElementById("subcategory");
			    const selectedCategory = categoryDropdown.value;
			    const categoryMap = {
			        "DEVS": [
			            { value: "PHON", text: "Phones" },
			            { value: "TABL", text: "Tablets" },
			            { value: "TELE", text: "Televisions" },
			            { value: "WATC", text: "Watches" }
			        ]
			    };
			    subcategoryDropdown.innerHTML = "";
			    if (categoryMap[selectedCategory]) {
			        categoryMap[selectedCategory].forEach(sub => {
			            const option = document.createElement("option");
			            option.value = sub.value;
			            option.text = sub.text;
			            subcategoryDropdown.add(option);
			        });
			    } else {
			        const defaultOption = document.createElement("option");
			        defaultOption.value = "";
			        defaultOption.text = "Select a subcategory";
			        subcategoryDropdown.add(defaultOption);
			    }
			}

		</script>
	
        
</body>
</html>
