create table Orders (
	orderid				INTEGER,
	customerid			INTEGER,
	ordercreatedtime	DATE, 
	deliveryfee			INTEGER not null,
	totalcost			INTEGER not null,
	fdspromoid			INTEGER,

	primary key (orderid),
	foreign key (reid) references Reviews,
	foreign key (customerid) references Customers
	foreign key (fdspromoid) references FDSPromo
)

-- each customer has an entry in Locations but it uses customerid
create table Customers (
	customerid		INTEGER,
	points			INTEGER,

	primary key (customerid)
)

-- need to enforce that customerid has made the order that has the same orderid
create table Reviews (
	orderid			INTEGER,
	reviewdesc		varchar(100),

	primary key (orderid),
	foreign key (orderid) from Orders
)

-- before insertion, check that customers only has less than 5
-- if not, delete the one with the earliest dateadded and add new one
create table Locations (
	customerid 		INTEGER,
	location		varchar(50),
	dateadded		DATE not null,

	primary key (customerid),
	foreign key (customerid) references Customers
)

-- this is so that each customer can have multiple payment methods
-- for every order that requires payment, must look up this table and check customerid must be the same 
create table PaymentMethods (
	paymentmethodid	INTEGER,
	customerid 		INTEGER,
	cardInfo		varchar(60),

	primary key (paymentmethodid),
	foreign key (customerid) references Customers
)

create table Delivers (
	orderid					INTEGER,
	rating					INTEGER check ((rating <= 5) and (rating >= 0)),
	location 				varchar(50) not null,
	timedeparttolocation	DATE not null,
	timearrivedatrestaurant	DATE not null,
	timeorderdelivered		DATE not null,
	paymentmethodid			INTEGER, 			

	primary key (orderid),
	foreign key (orderid) references Orders
	foreign key (paymentmethodid) references PaymentMethods
)

