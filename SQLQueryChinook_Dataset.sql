create database Chinook_Dataset
use Chinook_Dataset

ALTER TABLE Album
ALTER COLUMN AlbumId INT NOT NULL;
Alter TABLE Album
ADD CONSTRAINT PK_Album PRIMARY KEY (AlbumId)

select * from Album

ALTER TABLE Artist
ALTER COLUMN ArtistId INT NOT NULL;
Alter TABLE Artist
ADD CONSTRAINT PK_Artist PRIMARY KEY (ArtistId)

ALTER TABLE Customer
ALTER COLUMN CustomerId INT NOT NULL;
Alter TABLE Customer
ADD CONSTRAINT PK_Customer PRIMARY KEY (CustomerId)

ALTER TABLE Employee
ALTER COLUMN EmployeeId INT NOT NULL;
Alter TABLE Employee
ADD CONSTRAINT PK_Employee PRIMARY KEY (EmployeeId)

ALTER TABLE Genre
ALTER COLUMN GenreId INT NOT NULL;
Alter TABLE Genre
ADD CONSTRAINT PK_Genre PRIMARY KEY (GenreId)

ALTER TABLE Invoice
ALTER COLUMN InvoiceId INT NOT NULL;
Alter TABLE Invoice
ADD CONSTRAINT PK_Invoice PRIMARY KEY (InvoiceId)

ALTER TABLE InvoiceLine
ALTER COLUMN InvoiceLineId INT NOT NULL;
Alter TABLE InvoiceLine
ADD CONSTRAINT PK_InvoiceLine PRIMARY KEY (InvoiceLineId)

ALTER TABLE MediaType
ALTER COLUMN MediaTypeId INT NOT NULL;
Alter TABLE MediaType
ADD CONSTRAINT PK_MediaType PRIMARY KEY (MediaTypeId)

ALTER TABLE Playlist
ALTER COLUMN PlaylistId INT NOT NULL;
Alter TABLE Playlist
ADD CONSTRAINT PK_Playlist PRIMARY KEY (PlaylistId)

ALTER TABLE Track
ALTER COLUMN TrackId INT NOT NULL;
Alter TABLE Track
ADD CONSTRAINT PK_Track PRIMARY KEY (TrackId)

ALTER TABLE Album
ALTER COLUMN ArtistID INT
ALTER TABLE Album
ADD CONSTRAINT FK_Album_Artist
FOREIGN KEY (ArtistID)
REFERENCES Artist(ArtistId);

Alter table Track
Alter column AlbumId Int
ALTER TABLE Track
ADD CONSTRAINT FK_Track_Album
FOREIGN KEY (AlbumID)
REFERENCES Album(AlbumId);

Alter table Track
Alter column GenreId Int
ALTER TABLE Track
ADD CONSTRAINT FK_Track_Genre
FOREIGN KEY (GenreID)
REFERENCES Genre(GenreId);

Alter table Track
Alter column MediaTypeId Int
ALTER TABLE Track
ADD CONSTRAINT FK_Track_MediaType
FOREIGN KEY (MediaTypeID)
REFERENCES MediaType(MediaTypeId);

Alter table Invoice
Alter column CustomerId Int
ALTER TABLE Invoice
ADD CONSTRAINT FK_Invoice_Customer
FOREIGN KEY (CustomerID)
REFERENCES Customer(CustomerId);

Alter table InvoiceLine
Alter column InvoiceId Int
ALTER TABLE InvoiceLine
ADD CONSTRAINT FK_InvoiceLine_Invoice
FOREIGN KEY (InvoiceID)
REFERENCES Invoice(InvoiceId);

Alter table InvoiceLine
Alter column TrackId Int
ALTER TABLE InvoiceLine
ADD CONSTRAINT FK_InvoiceLine_Track
FOREIGN KEY (TrackID)
REFERENCES Track(TrackId);

Alter table Customer
Alter column SupportRepId Int
ALTER TABLE Customer
ADD CONSTRAINT FK_Customer_Employee
FOREIGN KEY (SupportRepId)
REFERENCES Employee(EmployeeId);

Alter table PlaylistTrack
Alter column PlaylistId int
Alter table PlaylistTrack
Alter column TrackId int

Alter table PlaylistTrack
Add constraint FK_PlaylistTrack_Playlist
FOREIGN KEY (PlaylistID)
REFERENCES Playlist(PlaylistId)

Alter table PlaylistTrack
Add constraint FK_PlaylistTrack_Track
FOREIGN KEY (TrackID)
REFERENCES Track(TrackId)

-- Top Selling Tracks
SELECT 
    il.TrackId, 
    t.Name AS TrackName, 
    SUM(il.Quantity) AS TotalUnitsSold,
    SUM(il.UnitPrice * il.Quantity) AS Total_Revenue
FROM 
    InvoiceLine il 
inner join
    Track t ON il.TrackID = t.TrackId
GROUP BY 
    il.TrackId, 
    t.Name
order by
    Total_Revenue desc

-- Revenue accoding to country
SELECT 
    BillingCountry,
    COUNT(DISTINCT CustomerId) AS NumCustomers,  
    COUNT(*) AS NumInvoices,                      
    SUM(Total) AS TotalRevenue                   
FROM Invoice
GROUP BY BillingCountry
ORDER BY TotalRevenue DESC;


--Top-selling artists
select al.ArtistId, ar.Name as Artist_Name,
sum (il.UnitPrice * il.Quantity) as Total_Sales,
count (Distinct al.Title) as No_of_Album
from Album al 
inner join Artist ar on al.ArtistID = ar.ArtistId
inner join Track t on t.AlbumId = al.AlbumId
inner join InvoiceLine il on il.TrackID = t.TrackId
Group by al.ArtistId, ar.Name
order by Total_Sales desc

--Most Popular Tracks
select t.Name as Track ,al.Title as Album_Name,
count (distinct pt.PlaylistId) as Playlist_Count
from Track t 
inner join Album al on t.AlbumId = al.AlbumId
inner join Artist ar on al.ArtistId = ar.ArtistId
inner join PlaylistTrack pt on pt.TrackId = t.TrackId
group by t.Name, al.Title
order by Playlist_Count desc

--Monthly Performance of Sales 
SELECT  
    i.InvoiceDate as Date,
    al.Title as Album_Name,
    SUM(il.UnitPrice * il.Quantity) AS Monthly_Sales
FROM Invoice i
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t ON il.TrackId = t.TrackId
JOIN Album al ON t.AlbumId = al.AlbumId
GROUP BY  i.InvoiceDate, al.Title 
ORDER BY i.InvoiceDate DESC;

--Top 5 Albums Sales (Monthly Performance of Sales )
SELECT TOP 5
    al.Title AS Album_Name,
    SUM(il.UnitPrice * il.Quantity) AS Total_Sales
FROM Invoice i
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t ON il.TrackId = t.TrackId
JOIN Album al ON t.AlbumId = al.AlbumId
GROUP BY al.Title
ORDER BY Total_Sales DESC;

--Top Genre
SELECT g.Name AS Genre, 
       SUM(il.UnitPrice * il.Quantity) AS TotalRevenue
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
GROUP BY g.Name
ORDER BY TotalRevenue DESC;

--Genre with Artist Name
SELECT 
    ar.Name AS Artist_Name,
    g.Name AS Genre,
    COUNT(t.TrackId) AS Total_Tracks
FROM Artist ar
JOIN Album al ON ar.ArtistId = al.ArtistId
JOIN Track t ON al.AlbumId = t.AlbumId
JOIN Genre g ON t.GenreId = g.GenreId
GROUP BY ar.Name, g.Name
ORDER BY ar.Name;

--Genre with specific Artists
SELECT 
    ar.Name AS Artist_Name,
    g.Name AS Genre,
    COUNT(t.TrackId) AS Total_Tracks
FROM Artist ar
JOIN Album al ON ar.ArtistId = al.ArtistId
JOIN Track t ON al.AlbumId = t.AlbumId
JOIN Genre g ON t.GenreId = g.GenreId
WHERE ar.Name IN ('Iron Maiden', 'U2', 'Metallica')
GROUP BY ar.Name, g.Name
ORDER BY ar.Name;