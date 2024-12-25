<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
   pageEncoding="ISO-8859-1" import="samplePackage.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.LocalDateTime"%>
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
    <title>Add to Wishlist</title>
</head>
<body>
    <%
    ApplicationDB db = new ApplicationDB();    
    Connection con = db.getConnection();    
    
    String userName = request.getParameter("userName");
    String catID = request.getParameter("catID");
    String subID = request.getParameter("subID");
    String itemID = request.getParameter("itemID");
    
    try (Statement stmt = con.createStatement()) {
        ResultSet current_wishlist = stmt.executeQuery("SELECT * FROM Wishlist WHERE userName ='" + userName + "' AND catID ='" + catID + "' AND subID ='" + subID + "' AND itemID ='" + itemID + "'");
        if (current_wishlist.next()) {
            %>
            <script>
                alert('Item already in wishlist!');
                window.location.href = 'Wishlist.jsp';
            </script>
            <%
        } else {
            PreparedStatement ps = con.prepareStatement("INSERT INTO Wishlist(userName, catID, subID, itemID) VALUES (?, ?, ?, ?)");
            ps.setString(1, userName);
            ps.setString(2, catID);
            ps.setString(3, subID);
            ps.setString(4, itemID);
            ps.executeUpdate();

            LocalDateTime now = LocalDateTime.now();
            ResultSet result = stmt.executeQuery("SELECT * FROM Auction WHERE catID='" + catID + "' AND subID='" + subID+ "' AND itemID='" + itemID +"' AND closingTime > NOW()");
            while (result.next()) {
                PreparedStatement ps1 = con.prepareStatement("INSERT IGNORE INTO Alert(endUserInfo, alertTiming, message) VALUES (?, ?, ?)");
                ps1.setString(1, userName);
                ps1.setString(2, now.toString());
                ps1.setString(3, "Your desired wishlist item " + catID + "-" + subID + "-" + itemID + " is available for auction. <a href='PlaceBid.jsp'>Place your bids here</a>.");
                ps1.executeUpdate();
            }
            %>
            <script>
                alert('Item added to Wishlist successfully!');
                window.location.href = 'Wishlist.jsp';
            </script>
            <%
        }
    } catch (SQLException e) {
        e.printStackTrace();
        %>
        <script>
            alert('Error processing your request: <%= e.getMessage() %>');
            window.location.href = 'Wishlist.jsp';
        </script>
        <%
    } finally {
        if (con != null) try { con.close(); } catch (SQLException e) { /* Ignored */ }
    }
    %>
</body>
</html>
