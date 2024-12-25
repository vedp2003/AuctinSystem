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
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>User List</title>
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

    <div class="container">
        <h2>List of End Users</h2>
        <%
            ApplicationDB db = new ApplicationDB();
            Connection con = null;
            Statement stmt = null;
            ResultSet rs = null;
            try {
                con = db.getConnection();
                stmt = con.createStatement();
                String str = "SELECT * " +
                                      "FROM User u JOIN EndUser e USING(userName)";
                rs = stmt.executeQuery(str);
        %>
        <table>
            <tr>
                <th>Name</th>
                <th>Username</th>
                <th>Email</th>
                <th>Password</th>
            </tr>
            <%
                while(rs.next()) {
                    String name = rs.getString("name");
                    String userName = rs.getString("userName");
                    String email = rs.getString("email");
                    String password = rs.getString("password");
            %>
            <tr>
                <td><%= name %></td>
                <td><%= userName %></td>
                <td><%= email %></td>
                <td><%= password %></td>
            </tr>
            <%
                }
                rs.close();
            %>
        </table>
        <%
            } catch(SQLException se) {
                out.println("Error Exception: " + se.getMessage());
            } finally {
                try {
                    if(stmt != null) stmt.close();
                    if(con != null) db.closeConnection(con);
                } catch(SQLException se) {
                    out.println("Error Exception: " + se.getMessage());
                }
            }
            %>
    </div>

    <div class="container">
        <h2>List of Customer Representatives</h2>
        <%
            try {
                con = db.getConnection();
                stmt = con.createStatement();
                String str = "SELECT * " +
                                          "FROM User u JOIN CustomerRepresentative c USING(userName)";
                rs = stmt.executeQuery(str);
        %>
        <table>
            <tr>
                <th>Name</th>
                <th>Username</th>
                <th>Email</th>
                <th>Password</th>
            </tr>
            <%
                while(rs.next()) {
                    String name = rs.getString("name");
                    String userName = rs.getString("userName");
                    String email = rs.getString("email");
                    String password = rs.getString("password");
            %>
            <tr>
                <td><%= name %></td>
                <td><%= userName %></td>
                <td><%= email %></td>
                <td><%= password %></td>
            </tr>
            <%
                }
            } catch(SQLException se) {
                out.println("Error Exception: " + se.getMessage());
            } finally {
                try {
                    if(rs != null) rs.close();
                    if(stmt != null) stmt.close();
                    if(con != null) db.closeConnection(con);
                } catch(SQLException se) {
                    out.println("Error Exception: " + se.getMessage());
                }
            }
            %>
        </table>
    </div>
    
    <br><a href='LoginAdmin.jsp'>Go back to Main Page</a><br><br>

</body>
</html>