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
    <title>Modify Account</title>
</head>
<body>

	<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String queryID = request.getParameter("queryID");
    String newEmail = request.getParameter("newEmail");
    String newUsername = request.getParameter("newUserName");
    String newDisplayName = request.getParameter("newName");
    String newPassword = request.getParameter("newPassword");
    LocalDateTime now = LocalDateTime.now();
    
    try {
        ApplicationDB db = new ApplicationDB();    
        con = db.getConnection();
        
        String fetchUserDetails = "SELECT u.email, u.userName FROM User u INNER JOIN EndUser e ON u.userName = e.userName "
                                + "INNER JOIN Query q ON e.userName = q.endUserInfo WHERE q.queryID = ?";
        ps = con.prepareStatement(fetchUserDetails);
        ps.setString(1, queryID);
        rs = ps.executeQuery();
        
        String currentUserEmail = "";
        String currentUserName = "";
        

        if (rs.next()) {
        	currentUserName = rs.getString("userName");
            currentUserEmail = rs.getString("email");
        } else {
            out.println("No user found for the given query ID. <a href='ModifyInfo.jsp'>Go back.</a>");
            return;
        }

        String sqlUpdate = "UPDATE User SET ";
        boolean needComma = false;

        if (newEmail != null && !newEmail.isEmpty()) {
            sqlUpdate += "email = ?";
            needComma = true;
        }
        if (newUsername != null && !newUsername.isEmpty()) {
            if (needComma) sqlUpdate += ", ";
            sqlUpdate += "userName = ?";
            needComma = true;
        }
        if (newDisplayName != null && !newDisplayName.isEmpty()) {
            if (needComma) sqlUpdate += ", ";
            sqlUpdate += "name = ?";
            needComma = true;
        }
        if (newPassword != null && !newPassword.isEmpty()) {
            if (needComma) sqlUpdate += ", ";
            sqlUpdate += "password = ?";
        }

        sqlUpdate += " WHERE email = ?";
        ps = con.prepareStatement(sqlUpdate);

        int index = 1;

        if (newEmail != null && !newEmail.isEmpty()) {
            ps.setString(index++, newEmail);
        }
        if (newUsername != null && !newUsername.isEmpty()) {
            ps.setString(index++, newUsername);
        }
        if (newDisplayName != null && !newDisplayName.isEmpty()) {
            ps.setString(index++, newDisplayName);
        }
        if (newPassword != null && !newPassword.isEmpty()) {
            ps.setString(index++, newPassword);
        }

        ps.setString(index, currentUserEmail);
        

        int affectedRows = ps.executeUpdate();
        
        
        if(affectedRows > 0) {
        	String resolveText = "User Account Info modified successfully!";
            String customerRepID = session.getAttribute("user").toString();
            ps = con.prepareStatement("UPDATE Query SET resolveText = ?, resolveStatus = ?, customerRepresentationInfo = ?, resolveTiming = ? WHERE queryID = ?");
            ps.setString(1, resolveText);
            ps.setString(2, "resolved");
            ps.setString(3, customerRepID);
            ps.setString(4, now.toString());
            ps.setString(5, queryID);
            ps.executeUpdate();
    		
            if (newUsername == null || newUsername.isEmpty()) {
                newUsername = currentUserName;
            }

            
            String sendAlert = "INSERT IGNORE INTO Alert (endUserInfo, alertTiming, message) VALUES (?, ?, ?)";
            ps = con.prepareStatement(sendAlert);
            ps.setString(1, newUsername);
            ps.setString(2, now.toString());
            ps.setString(3, "Your Query (ID " + queryID + ") has been answered!");
            ps.executeUpdate();
            
            response.sendRedirect("LoginRep.jsp");
        }
        else {
            out.println("Could not update Info. <a href='LoginRep.jsp'>Go back to main Page</a>");

        }
               
        
        
    } catch (SQLException e) {
        out.println("SQL Error: " + e.getMessage() + " <a href='ModifyUser.jsp'>Try again</a>");
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {  }
        if (ps != null) try { ps.close(); } catch (SQLException e) {  }
        if (con != null) try { con.close(); } catch (SQLException e) {  }
    }
%>
        
</body>
</html>