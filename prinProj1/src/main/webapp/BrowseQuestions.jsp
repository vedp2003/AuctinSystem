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

    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Browse Common Questions</title>
    <style>
        .highlight { background-color: yellow; }
    </style>
</head>
<body>
 
	<h2>Browse Common Questions</h2>
	<a href='LoginUser.jsp'>Go back to Main Page</a><br><br>
	
	FAQ Search: <input type="text" id="searchBar" onkeyup="search()">
	<ul id="faqs" style="list-style-type: none; padding: 0;">
	    <li>
	        <h4>How can I register an account on BuyMe?</h4>
	        <p>Registering on BuyMe is simple! Just fill out our online registration form with your full name, email address, userName, and a password of your choice.</p>
	    </li>
	    <li>
	        <h4>Can I save items to a WishList on BuyMe?</h4>
	        <p>Yes, you can easily add items to your wishlist by clicking the Add to WishList button on any items. This allows you to keep track of the wanted items and receive updates about their auction status.</p>
	    </li>
	    <li>
	        <h4>What is the process for submitting a bid on BuyMe?</h4>
	        <p>To place a bid, go to the Place Bid page, browse through items, enter your bid amount, and click Submit. Your bid must be at least the starting bid or higher than the current bid, adhering to the bid increment specified.</p>
	    </li>
	    <li>
	        <h4>Can I automatically bid up to a set price?</h4>
	        <p>Yes, our autobid feature allows you to set a maximum price you're willing to pay, and the system will automatically place bids for you, keeping you the highest bidder up to your specified limit.</p>
	    </li>
	    <li>
	        <h4>What if I change my mind after winning an auction?</h4>
	        <p>As per our terms of service, winning an auction creates a binding contract to purchase the item. If you cannot complete the transaction, it may result in a ban from future bidding.</p>
	    </li>
	    <li>
	    	<h4>How can I modify my account information such as my email or name?</h4>
	        <p>Users can reach out to a customer representative through the Queries/Customer Service page. The reps will be able to modify any account modifications.</p>
	    </li>
	    <li>
	        <h4>How quickly must I pay for an auction item I have won?</h4>
	        <p>Payment must be made within 48 hours of the auction's close to avoid penalties and ensure that you receive your item promptly.</p>
	    </li>
	    <li>
	        <h4>What payment options does BuyMe offer?</h4>
	        <p>BuyMe accepts several payment methods including credit cards, debit cards, PayPal, and direct bank transfers.</p>
	    </li>
	    <li>
	        <h4>How will items be delivered to me from BuyMe?</h4>
	        <p>Delivery options vary based on seller. Some may offer shipping while others might require pick-up. Reach out to reach for more delivery details.</p>
	    </li>
	    <li>
	        <h4>What should I do if an item isn't as advertised?</h4>
	        <p>Contact our query customer service team immediately. We are committed to ensuring a fair auction process and will help resolve disputes regarding item misrepresentation.</p>
	    </li>
	    <li>
	        <h4>Does BuyMe charge any fees for bidding?</h4>
	        <p>There are no fees for bidding.</p>
	    </li>
	    <li>
	    	<h4>Are there any restrictions on items that can be auctioned on BuyMe?</h4>
	        <p>Yes, BuyMe prohibits the auction of illegal items. Customer Reps will automatically delete such illegal auctions.</p>
	    </li>
	</ul>
	<p id="noResults" style="display:none;">No results found.</p>

	<script>
	function search() {
	    let input = document.getElementById("searchBar").value.trim().toLowerCase();
	    let faqs = document.getElementById("faqs");
	    let lis = faqs.getElementsByTagName("li");
	    let found = false;

	    Array.from(lis).forEach(li => {
            li.innerHTML = li.innerHTML.replace(/<span class="highlight">(.*?)<\/span>/gi, "$1");

	        let text = li.textContent.toLowerCase();
	        if (text.includes(input)) {
	            li.style.display = "";
	            highlightText(li, input);
	            found = true;
	        } else {
	            li.style.display = "none";
	        }
	    });

	    document.getElementById("noResults").style.display = found ? "none" : "block";
	}

	function highlightText(element, text) {
	    let innerHTML = element.innerHTML;
	    let index = innerHTML.toLowerCase().indexOf(text);
	    if (index >= 0) {
	        element.innerHTML = innerHTML.substring(0, index) + 
	        "<span class='highlight'>" + innerHTML.substring(index, index + text.length) + "</span>" + innerHTML.substring(index + text.length);
	    }
	}
	</script>

</body>
</html>
