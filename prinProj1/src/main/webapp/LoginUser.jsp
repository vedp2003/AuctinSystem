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
    <title>User Login Portal</title>
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
        .sub-section {
            margin-left: 40px;
        }
        .tab {
            overflow: hidden;
            border: 1px solid #ccc;
            background-color: #f1f1f1;
        }
        .tab button {
            background-color: inherit;
            color: black;
            float: left;
            cursor: pointer;
            padding: 14px 16px;
            transition: 0.3s;
            font-size: 17px;
        }
        .tab button:hover {
            background-color: #1565c0; 
            color: black; 
        }
        .tab button.active {
            background-color: #1e88e5;
            color: black;
        }
        .content {
            display: none;
            padding: 6px 12px;
            border: 1px solid #ccc;
        }
    </style>
    <script>
    function openTab(evt, reportName) {
        var i, tabcontent, tablinks;
        tabcontent = document.getElementsByClassName("content");
        for (i = 0; i < tabcontent.length; i++) {
            tabcontent[i].style.display = "none";
        }
        tablinks = document.getElementsByClassName("tablinks");
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].className = tablinks[i].className.replace(" active", "");
        }
        document.getElementById(reportName).style.display = "block";
        evt.currentTarget.className += " active";
    }
    
    document.addEventListener("DOMContentLoaded", function() {
        document.querySelector(".tablinks").click();
    });
    </script>
</head>
<body>
    <div class="container">
        <h2>END-USER PORTAL</h2>
        <p><strong>( Name: <%= session.getAttribute("name") %> &amp; UserName: <%= session.getAttribute("user") %> )</strong></p>
        <hr>

        <div class="tab">
            <button class="tablinks active" onclick="openTab(event, 'SellingActions')">Selling Actions</button>
            <button class="tablinks" onclick="openTab(event, 'BuyingActions')">Buying Actions</button>
            <button class="tablinks" onclick="openTab(event, 'CommonActions')">Common Actions</button>
        </div>

        <div id="SellingActions" class="content">
            <div class="section">
                <b style="color: brown;">Selling Actions:</b>
                <div class="sub-section">
                    <b>ITEMS:</b><br>
                    <button onclick="location.href='Items.jsp'">View your items</button><br>
                    <button onclick="location.href='AddItem.jsp'">Add new item</button><br>
                    <button onclick="location.href='UpdateItem.jsp'">Update existing item</button><br>
                    <button onclick="location.href='DeleteItem.jsp'">Delete item</button>
                </div>

                <div class="sub-section">
                    <b>AUCTIONS:</b><br>
                    <button onclick="location.href='Auctions.jsp'">View your auctions</button><br>
                    <button onclick="location.href='StartAuction.jsp'">Start auction</button><br>
                    <button onclick="location.href='UpdateAuction.jsp'">Update auction</button>
                </div>
            </div>
        </div>

        <div id="BuyingActions" class="content">
            <div class="section">
                <b style="color: brown;">Buying Actions:</b><br>
                <button onclick="location.href='Wishlist.jsp'">Add Item to wishlist</button><br>
                <button onclick="location.href='PlaceBid.jsp'">Bidding</button><br>
                <button onclick="location.href='Autobid.jsp'">Auto-bidding</button>
            </div>
        </div>

        <div id="CommonActions" class="content">
            <div class="section">
                <b style="color: brown;">Common actions:</b><br>
                <button onclick="location.href='DeleteAccount.jsp'">Delete account</button><br>
                <button onclick="location.href='ChangePassword.jsp'">Change password</button><br>
                <button onclick="location.href='AskQuery.jsp'">Queries/Customer Service</button><br>
                <button onclick="location.href='BrowseQuestions.jsp'">Browse FAQs</button>
            </div>
        </div><br>

        <u>Notifications</u>:
        <div class="section">
            <%
            ApplicationDB db = new ApplicationDB();    
            Connection con = db.getConnection();
            Statement stmt = con.createStatement();
            String userName = session.getAttribute("user").toString();
            ResultSet rs = stmt.executeQuery("SELECT * FROM Alert WHERE endUserInfo='" + userName + "' ORDER BY alertTiming DESC");
            %>
            <table class="notifs">
                <thead>
                    <tr>
                        <th>Date and Time</th>
                        <th>Message</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    while (rs.next()) {
                        String alertTiming = rs.getString("alertTiming");
                        String message = rs.getString("message");
                        %>
                        <tr>
                            <td><%= alertTiming %></td>
                            <td><%= message %></td>
                        </tr>
                        <%
                    }
                    %>
                </tbody>
            </table>
        </div><br/>
        
        <br><button onclick="location.href='Login.jsp?logout=true'">Log out</button><br>
    </div>
</body>
</html>