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
    <title>Delete Account</title>
</head>
<body>
 
	<%
			String userName = (String)session.getAttribute("user");
    		String str = "DELETE FROM User WHERE userName=?";
            ApplicationDB db = new ApplicationDB();
            Connection con = null;
            PreparedStatement stmt = null;
            try {
                con = db.getConnection();
                stmt = con.prepareStatement(str);
                stmt.setString(1, userName);
                stmt.executeUpdate();
                
                session.invalidate();
        		response.sendRedirect("Login.jsp");
                
        
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
        
</body>
</html>
