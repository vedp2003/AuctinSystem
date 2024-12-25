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
    <title>Resolve Query</title>
</head>
<body>
 
	<%
	if (request.getMethod().equals("POST")) {
	    String queryID = request.getParameter("queryID");
	    String responseText = request.getParameter("response");
	    String status = "resolved";
	    String customerRepID = session.getAttribute("user").toString();
	    
	    ApplicationDB db = new ApplicationDB();
	    Connection con = db.getConnection();
	    PreparedStatement stmt=null;
	    LocalDateTime now = LocalDateTime.now();
	    
	    try {
	    	String checkQueryStatus = "SELECT resolveStatus FROM Query WHERE queryID=?";
            PreparedStatement psCheck = con.prepareStatement(checkQueryStatus);
            psCheck.setInt(1, Integer.parseInt(queryID));
            ResultSet rs = psCheck.executeQuery();

            if (!rs.next()) {
                out.println("Query ID is invalid. Enter correct QueryID to resolve! <a href='LoginRep.jsp'>Go back</a>.");
                return;
            }

            String resolveStatus = rs.getString("resolveStatus");
            if (!resolveStatus.equals("pending")) {
                out.println("Query ID is non-pending and cannot be resolved again! <a href='LoginRep.jsp'>Go back</a>.");
                return;
            }
	    
	        
	    
            String updateQuery = "UPDATE Query SET resolveText=?, resolveStatus=?, customerRepresentationInfo=?, resolveTiming=? WHERE queryID=?";

	        stmt = con.prepareStatement(updateQuery);
	        stmt.setString(1, responseText);
	        stmt.setString(2, status);
	        stmt.setString(3, customerRepID);
	        stmt.setString(4, now.toString());
	        stmt.setInt(5, Integer.parseInt(queryID));
	        stmt.executeUpdate();
	        
	        
	        String getUserQuery = "SELECT endUserInfo FROM Query WHERE queryID=?";
            stmt = con.prepareStatement(getUserQuery);
            stmt.setInt(1, Integer.parseInt(queryID));
            ResultSet rs1 = stmt.executeQuery();
            
            if (rs1.next()) {
                String userName = rs1.getString("endUserInfo");

                String insertAlert = "INSERT IGNORE INTO Alert (endUserInfo, alertTiming, message) VALUES (?, ?, ?)";
                PreparedStatement psAlert = con.prepareStatement(insertAlert);
                psAlert.setString(1, userName);
    			psAlert.setString(2, now.toString());
                psAlert.setString(3, "Your Query (ID " + queryID + ") has been answered!");
                psAlert.executeUpdate();
            }
	        
	        
	    } catch (Exception e) {
			out.println("Error trying to resolve Query. Try Again! <a href='LoginRep.jsp'>Go back</a>.");

	    } finally {
	        try { stmt.close(); } catch (Exception e) {}
	        try { con.close(); } catch (Exception e) {}
	    }
	    
	    response.sendRedirect("LoginRep.jsp");
	}
	%>
        
</body>
</html>
