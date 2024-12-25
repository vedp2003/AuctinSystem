# Online Auction System

## Description
The **Online Auction System** is a fully functional, web-based application designed to facilitate online auctions. Inspired by platforms like eBay, this system allows users to buy and sell items through a seamless and intuitive interface. The project integrates **HTML**, **Java**, **JavaScript**, **JDBC**, and **MySQL**, leveraging a relational database to handle auction data efficiently. **Apache Tomcat** serves as the web server for hosting the application locally.

---

## Features

### General
- User account management: Create, delete, login, and logout functionality.
- Secure bidding mechanism: Manual and automatic bidding with secret upper limits.
- Real-time notifications and alerts.
- Advanced search and browsing capabilities.

### Auctions
- Sellers can:
  - Post items for auction with details like initial price, bidding increment, and end time.
  - Set a reserve price (hidden) for the auction.
- Buyers can:
  - Place bids manually or configure automatic bidding with an upper limit.
  - Receive alerts for higher bids or if an upper limit is exceeded.
- Auction closure:
  - If the reserve price is not met, the item remains unsold.
  - The highest bidder wins if the reserve price is met or exceeded.
  - Notifications are sent to winners and sellers.

### Browsing and Search
- Search items by category, keyword, or advanced filters.
- View complete bidding history for specific auctions.
- Check participation history for buyers and sellers.
- Find similar items from past auctions based on predefined similarity criteria.
- Configure alerts for specific items or categories of interest.

### Administrative Functions
- Admins can:
  - Create and manage accounts for customer representatives.
  - Generate detailed sales reports:
    - Total earnings.
    - Earnings by item, category, or user.
    - Best-selling items and highest-spending users.
- Customer representatives can:
  - Respond to user queries and assist with account or auction-related issues.
  - Remove illegal or inappropriate auctions.
  - Reset user passwords.

---

## Getting Started

### Prerequisites
Before running the project, ensure you have the following installed:
- **Java Runtime Environment (JRE)**
- **Integrated Development Environment (IDE):** Eclipse IDE for Java EE Developers
- **MySQL Server:** Version 8.0.21 or later
- **Apache Tomcat Server:** Version 8.5 or later
- **JDBC Driver**

### Installation Steps
1. **Install MySQL Server:**
   - Download and install [MySQL Server](https://dev.mysql.com/downloads/mysql/).
   - Launch MySQL Workbench and establish a connection to your local MySQL server.
   - Import the schema:
     ```plaintext
     File → Open SQL script → Select "OnlineAuctionProject.sql" → Execute script.
     ```

2. **Install Eclipse IDE:**
   - Download and install [Eclipse IDE](https://eclipse.org/downloads/eclipse-packages/).
   - Import the project:
     ```plaintext
     File → Import → General → Existing Projects into Workspace → Select Project Folder.
     ```

3. **Install Apache Tomcat:**
   - Download and install [Apache Tomcat](https://tomcat.apache.org/download-80.cgi).
   - Configure the server in Eclipse:
     ```plaintext
     Preferences → Server → Runtime Environment → Add → Apache Tomcat v8.5.
     ```

4. **Configure Database Connection:**
   - Edit `ApplicationDB.java` and update the database credentials:
     ```java
     connection = DriverManager.getConnection(connectionUrl,"USERNAME", "PASSWORD"); // Edit the USERNAME and PASSWORD to match the database crendentials 
     ```

5. **Run the Application:**
   - Start the application in Eclipse:
     ```plaintext
     Right-click on the project → Run As → Run on Server → Apache Tomcat v8.5.
     ```
---

## Tools and Technologies
- **Frontend:** HTML, JavaScript
- **Backend:** Java, JDBC
- **Database:** MySQL
- **Server:** Apache Tomcat

---

## Database Schema
The schema includes tables for:
1. **User**: Stores general user details (administrators, customer representatives, and end users).
2. **AdministrativeStaffMember**: Contains administrator-specific accounts.
3. **CustomerRepresentative**: Manages customer service representatives.
4. **EndUser**: Handles end-user accounts, including anonymity preferences.
5. **Query**: Tracks user queries and their resolution status.
6. **Alert**: Sends notifications to end users about auctions or system events.
7. **Category & Subcategory**: Organizes items into hierarchical categories (e.g., Phones under Devices).
8. **Item**: Stores details of items listed for auction.
9. **WishList**: Manages user-specific wish lists for items of interest.
10. **Auction**: Tracks auction details, including bidding increments and reserve prices.
11. **AutoBid**: Supports automatic bidding with user-defined upper limits.
12. **Bidding**: Logs individual bids placed on auctions.

---

## Key Functionalities
### For Buyers
- Place manual or automated bids.
- Receive alerts about auctions of interest.
- View auction history and personal participation details.

### For Sellers
- List items for sale with custom auction settings.
- Monitor active auctions and bids.
- Manage post-auction notifications for winning bids.

### For Administrators
- Manage customer representative accounts.
- Monitor and moderate platform activity.
- Generate comprehensive sales reports.

### For Customer Representatives
- Handle user queries and support.
- Modify or delete auction entries if necessary.

---

