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
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        form {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            display: inline-block;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        input[type="submit"] {
            width: 100%;
            background-color: #007BFF;
            color: white;
            padding: 14px 20px;
            margin: 8px 0;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        a {
            display: inline-block;
            margin-top: 20px;
            color: #007BFF;
            text-decoration: none;
            font-size: 18px;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

	<div class="container">
    
        <%
            Connection con = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            ApplicationDB db = new ApplicationDB();
            String queryID = request.getParameter("queryID"); 

            try {
                con = db.getConnection();
                String str = "SELECT * FROM Query WHERE queryID='" + queryID + "'";
                stmt = con.prepareStatement(str);
                rs = stmt.executeQuery();
                
                if (!rs.next()) {
                    out.println("Query ID is invalid. Enter correct QueryID to resolve! <a href='LoginRep.jsp'>Go back</a>.");
                    return;
                }
                String resolveStatus = rs.getString("resolveStatus");
                if (!resolveStatus.equals("pending")) {
                    out.println("Query ID is non-pending and cannot be resolved again! <a href='LoginRep.jsp'>Go back</a>.");
                    return;
                }

                while (rs.next()) {
                	
                    String queryText = rs.getString("askDetailsText");
	                out.println("<div class='query-display'><b>User Account Modification Query:</b><br/>" + queryText + "</div><br>");

					
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            }
        %>
    
        <h2>Modify User Account Information / Reset Password</h2>
    
        <form action="VerifyModifyInfo.jsp" method="POST">
            <input type="hidden" name="queryID" value="<%= request.getParameter("queryID") %>" />
            <input type="text" name="newName" placeholder="New Name" />
            <input type="text" name="newEmail" placeholder="New Email" />
            <input type="text" name="newUserName" placeholder="New User-Name" />
            <input type="text" name="newPassword" placeholder="New Password" />
            <input type="submit" value="Submit"/>
            <a href='LoginRep.jsp'>Go back</a>
        </form>
    </div>
	        
</body>
</html>
