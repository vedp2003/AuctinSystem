<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
   pageEncoding="ISO-8859-1" import="samplePackage.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Register</title>
</head>
<body>
 
 <%
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
		Statement stmt = con.createStatement();
		Statement stmt1 = con.createStatement();
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		String userName = request.getParameter("userName");
		String password = request.getParameter("password");
		
		String registrationAttempt = request.getParameter("registrationAttempt");

		
		if("true".equals(registrationAttempt) && session.getAttribute("user") != null && session.getAttribute("user").toString().equals("admin1")){
			if(!userName.contains("rep"))
			{
				out.println("Error Creating Account -A Customer Representive Account cannot be made without the word rep being in the username. <a href='RegisterFormRep.jsp'>Register Again</a>");
				out.flush();
				return;
			}
			String str = "SELECT * FROM CustomerRepresentative WHERE userName='" + userName + "'";
			ResultSet result = stmt.executeQuery(str);
	
			if (result.next()) {
				out.println("Username is already taken. Please create a new username. <a href='RegisterFormRep.jsp'>Register Again</a>");
				out.flush();
				return;
			}
			
			
			String insert = "INSERT INTO User(name, userName, email, password)"
					+ "VALUES (?, ?, ?, ?)";
			PreparedStatement ps = con.prepareStatement(insert);
			ps.setString(1, name);
			ps.setString(2, userName);
			ps.setString(3, email);
			ps.setString(4, password);
			ps.executeUpdate();
			
			insert = "INSERT INTO CustomerRepresentative(userName)"
					+ "VALUES (?)";
			ps = con.prepareStatement(insert);
			ps.setString(1, userName);
			ps.executeUpdate();
			
			out.println("Account Successfully Created! Go back to your <a href='LoginAdmin.jsp'>main page</a>.");
			out.flush();
		}
		
		else if (!userName.contains("rep") && !userName.contains("admin")){
			
			String str = "SELECT * FROM user WHERE email='" + email + "'";
			ResultSet result = stmt.executeQuery(str);
			String str1 = "SELECT * FROM user WHERE userName='" + userName + "'";
			ResultSet result1 = stmt1.executeQuery(str1);
			
			if (result.next()) {
				out.println("Account with this email already exists. Please <a href='Login.jsp'>log In</a>.");
				out.flush();
			}
			else if (result1.next()) {
				out.println("Username is already taken. Please create a new username. <a href='RegisterForm.jsp'>Register Again</a>");
				out.flush();
			}
			else {
				String insert = "INSERT INTO User(name, userName, email, password)"
						+ "VALUES (?, ?, ?, ?)";
				PreparedStatement ps = con.prepareStatement(insert);
				ps.setString(1, name);
				ps.setString(2, userName);
				ps.setString(3, email);
				ps.setString(4, password);
				ps.executeUpdate();
				
				insert = "INSERT INTO EndUser(userName)"
						+ "VALUES (?)";
				ps = con.prepareStatement(insert);
				ps.setString(1, userName);
				ps.executeUpdate();
				
				out.println("Account Successfully Created! Please <a href='Login.jsp'>log in</a> to your account.");
				out.flush();
			}
		}
		
		else if (userName.contains("rep")){
			out.println("Error Creating Account - Only an admin can register customer reps! Go back to <a href='RegisterForm.jsp'>register page</a>.");
			out.flush();
		}
		else if (userName.contains("admin")){
			out.println("Error Creating Account - Creating admin username account not permitted! Go back to <a href='RegisterForm.jsp'>register page</a>.");
			out.flush();
		}
		else {
			out.println("Error Creating Account - Try Again Differently! Go back to <a href='RegisterForm.jsp'>register page</a>.");
			out.flush();
		}
		
			
		con.close();
	%>
 

        
</body>
</html>
