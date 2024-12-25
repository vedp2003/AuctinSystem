DROP DATABASE IF EXISTS OnlineAuction;
CREATE DATABASE IF NOT EXISTS OnlineAuction;
USE OnlineAuction;

CREATE TABLE User (
    name VARCHAR(45) NOT NULL,
    userName VARCHAR(15) PRIMARY KEY NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(15) NOT NULL
);

INSERT INTO User VALUES ('Admin Jimmy','admin1','admin1@gmail.com','abcd123');
INSERT INTO User VALUES ('Rep Bobby','rep','rep@gmail.com','abcd123');

CREATE TABLE AdministrativeStaffMember (
    userName VARCHAR(15) PRIMARY KEY NOT NULL UNIQUE,
    FOREIGN KEY (userName) REFERENCES User (userName) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO AdministrativeStaffMember VALUES ('admin1');


CREATE TABLE CustomerRepresentative (
    userName VARCHAR(15) PRIMARY KEY NOT NULL UNIQUE,
    FOREIGN KEY (userName) REFERENCES User (userName) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO CustomerRepresentative VALUES ('rep');

CREATE TABLE EndUser (
    userName VARCHAR(15) PRIMARY KEY NOT NULL UNIQUE,
    anonymous BOOLEAN NOT NULL DEFAULT 0,
    FOREIGN KEY (userName) REFERENCES User (userName) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Query (
    queryID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    resolveStatus ENUM('pending', 'denied', 'resolved') NOT NULL DEFAULT 'pending',
    resolveTiming DATETIME,
    resolveText VARCHAR(400),
    askTiming DATETIME NOT NULL,
    askDetailsText VARCHAR(400) NOT NULL,
    customerRepresentationInfo VARCHAR(15),
    endUserInfo VARCHAR(15) NOT NULL,
    FOREIGN KEY (customerRepresentationInfo) REFERENCES CustomerRepresentative (userName) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (endUserInfo) REFERENCES EndUser (userName) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Alert (
    message VARCHAR(400) NOT NULL,
    alertTiming DATETIME NOT NULL,
    endUserInfo VARCHAR(15) NOT NULL,
    PRIMARY KEY (endUserInfo, message),
    FOREIGN KEY (endUserInfo) REFERENCES EndUser (userName) ON DELETE CASCADE ON UPDATE CASCADE
);



CREATE TABLE Category (
    catID VARCHAR(8) PRIMARY KEY NOT NULL UNIQUE,
    name VARCHAR(25) NOT NULL
);

INSERT INTO Category VALUES ('DEVS' , 'Devices');

CREATE TABLE Subcategory (
    subID VARCHAR(8) NOT NULL,
    name VARCHAR(25) NOT NULL,
    catID VARCHAR(8) NOT NULL,
    PRIMARY KEY (catID, subID),
    FOREIGN KEY (catID) REFERENCES Category (catID) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Subcategory VALUES ('PHON' , 'Phones' , 'DEVS'), ('TABL', 'Tablets' , 'DEVS'), ('TELE' , 'Televisions', 'DEVS'), ('WATC' , 'Watches', 'DEVS');

CREATE TABLE Item (
    itemID INT NOT NULL AUTO_INCREMENT,
    shortDescription VARCHAR(80),
    middleDescription VARCHAR(90),
    longDescription VARCHAR(100),
    name VARCHAR(30) NOT NULL,
    type VARCHAR(30) NOT NULL,
    year CHAR(4) NOT NULL,
    catID VARCHAR(8) NOT NULL,
    subID VARCHAR(8) NOT NULL,
    addedBySellerInfo VARCHAR(15) NOT NULL,
    PRIMARY KEY (itemID, catID, subID),
    FOREIGN KEY (catID, subID) REFERENCES Subcategory (catID, subID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (addedBySellerInfo) REFERENCES EndUser (userName) ON DELETE CASCADE ON UPDATE CASCADE
); 

CREATE TABLE WishList (
    userName VARCHAR(15) NOT NULL,
    catID VARCHAR(8) NOT NULL,
    subID VARCHAR(8) NOT NULL,
    itemID INT NOT NULL,
    PRIMARY KEY (userName, catID, subID, itemID),
    FOREIGN KEY (userName) REFERENCES EndUser (userName) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (itemID, catID, subID) REFERENCES Item (itemID, catID, subID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Auction (
    auctionID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    initialPrice DOUBLE NOT NULL,
    increment DOUBLE NOT NULL,
    minimumPrice DOUBLE,
    currentPrice DOUBLE,
    currentWinner VARCHAR(15),
    startingTime DATETIME NOT NULL,
    closingTime DATETIME NOT NULL,
    catID VARCHAR(8) NOT NULL,
    subID VARCHAR(8) NOT NULL,
    itemID INT NOT NULL,
    FOREIGN KEY (currentWinner) REFERENCES EndUser (userName) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (itemID, catID, subID) REFERENCES Item (itemID, catID, subID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE AutoBid (
    startTime DATETIME NOT NULL,
    lastUpdatedTime DATETIME,
    upperLimit DOUBLE NOT NULL,
    userName VARCHAR(15) NOT NULL,
    auctionID INT NOT NULL,
    PRIMARY KEY (userName, auctionID),
    FOREIGN KEY (userName) REFERENCES EndUser (userName) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (auctionID) REFERENCES Auction (auctionID) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE Bidding (
    bidID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    amount DOUBLE NOT NULL,
    bidTiming DATETIME NOT NULL,
    userName VARCHAR(15) NOT NULL,
    auctionID INT NOT NULL,
    FOREIGN KEY (userName) REFERENCES EndUser (userName) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (auctionID) REFERENCES Auction (auctionID) ON DELETE CASCADE ON UPDATE CASCADE
);


