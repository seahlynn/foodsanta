DROP TABLE IF EXISTS Users CASCADE;
DROP TABLE IF EXISTS Orders CASCADE;
DROP TABLE IF EXISTS Customers CASCADE;
DROP TABLE IF EXISTS FDSManagers CASCADE;
DROP TABLE IF EXISTS RestaurantStaff CASCADE;
DROP TABLE IF EXISTS CustomerStats CASCADE;
DROP TABLE IF EXISTS Restaurants CASCADE;
DROP TABLE IF EXISTS RestaurantStats CASCADE;
DROP TABLE IF EXISTS RestaurantPromo CASCADE;
DROP TABLE IF EXISTS Reviews CASCADE;
DROP TABLE IF EXISTS Delivers CASCADE;
DROP TABLE IF EXISTS DeliveryRiders CASCADE;
DROP TABLE IF EXISTS Locations CASCADE;
DROP TABLE IF EXISTS PaymentMethods CASCADE;
DROP TABLE IF EXISTS AllStats CASCADE;
DROP TABLE IF EXISTS Food CASCADE;
DROP TABLE IF EXISTS Contains CASCADE;
DROP TABLE IF EXISTS FDSPromo CASCADE;
DROP TABLE IF EXISTS FullTimeRiders CASCADE;
DROP TABLE IF EXISTS PartTimeRiders CASCADE;
DROP TABLE IF EXISTS RidersStats CASCADE;
DROP TABLE IF EXISTS WeeklyWorkSchedule CASCADE;
DROP TABLE IF EXISTS FixedWeeklySchedule CASCADE;
DROP TABLE IF EXISTS MonthlyWorkSchedule CASCADE;
DROP TABLE IF EXISTS DailyWorkShift CASCADE;

create table Users (
    username            varchar(30),    
    name                varchar(30),
    password            varchar(15),
    phoneNumber         varchar(8),
    dateCreated			date,
    primary key (username)
);

-- each customer has an entry in Locations but it uses username
create table Customers (
	username            varchar(30),
	points		        INTEGER default 0,
	primary key (username),
    FOREIGN KEY (username) REFERENCES Users
);


CREATE TABLE DeliveryRiders (
    username    varchar(30),
    PRIMARY KEY (username),
    FOREIGN KEY (username) REFERENCES Users
);

create table FDSManagers (
    username              varchar(30),
    PRIMARY KEY (username),
    FOREIGN KEY (username) REFERENCES Users
);


-- before insertion, check that customers only has less than 5
-- if not, delete the one with the earliest dateadded and add new one
create table Locations (
	username 		varchar(30),
	location		varchar(100),
	dateAdded		DATE not null,

	primary key (username, location),
	foreign key (username) references Customers
);

-- this is so that each customer can have multiple payment methods
-- for every order that requires payment, must look up this table and check username must be the same 
create table PaymentMethods (
	paymentmethodid	INTEGER,
	username  		varchar(30),
	cardInfo		varchar(60),

	primary key (paymentmethodid),
	foreign key (username) references Customers
);

--insertion of food into Contains table has to decrease availability by one (use trigger under contains)
CREATE TABLE Restaurants (
    restid      INTEGER,
    restName    varchar(50),
    minAmt      INTEGER NOT NULL,
    location    varchar(100) NOT NULL,

    PRIMARY KEY (restid)
);

create table RestaurantStaff (
    username              varchar(30),
    restid                INTEGER default null,
    PRIMARY KEY (username),
    FOREIGN KEY (username) REFERENCES Users,
    FOREIGN KEY (restid) REFERENCES Restaurants
);

create table Food ( 
    foodid          integer,
    description     varchar(50),
    price           float NOT NULL,
    availability    INTEGER NOT NULL CHECK (availability >= 0),
    category        varchar(20),
    restid          INTEGER NOT NULL,
    timesordered    INTEGER NOT NULL,
    PRIMARY KEY (foodid),
    FOREIGN KEY (restid) REFERENCES Restaurants
);

--insertion into from table needs to check if restid is same as all other restid
CREATE TABLE FDSPromo (
    description     varchar(50),
    fdspromoid      INTEGER,
    orderid         INTEGER NOT NULL,
    startTime       DATE,
    endTime         DATE,

    PRIMARY KEY (fdspromoid)
);

CREATE TABLE Orders (
	orderid				INTEGER,
    username			varchar(30),
    custLocation        varchar(100) NOT NULL,
	orderCreatedTime	TIMESTAMP, 
	totalCost			INTEGER NOT NULL,
	fdspromoid			INTEGER,
    paymentmethodid     INTEGER,
    preparedByRest      boolean NOT NULL default False,
    collectedByRider    boolean NOT NULL default False,
    restid              INTEGER NOT NULL,

	primary key (orderid),
	foreign key (username) references Customers,
    foreign key (restid) references Restaurants,
	foreign key (fdspromoid) references FDSPromo
);

-- need to enforce that username has made the order that has the same orderid
CREATE TABLE Reviews (
	orderid			INTEGER,
	reviewDesc		varchar(100),

	PRIMARY KEY (orderid),

	FOREIGN KEY (orderid) REFERENCES Orders
);

create table Contains (
    orderid     INTEGER not null,
    foodid      INTEGER not null,
    username    varchar(30) not null,
    description varchar(50) not null,
    quantity    INTEGER not null,
    PRIMARY KEY (orderid, foodid),
    FOREIGN KEY (foodid) REFERENCES Food,
    FOREIGN KEY (username) REFERENCES Users
);


CREATE TABLE Delivers (
	orderid					INTEGER,
    username                varchar(30),
	rating					INTEGER check ((rating <= 5) and (rating >= 0)),
	location 				varchar(50) NOT NULL,
    deliveryFee             INTEGER NOT NULL,
	timeDepartToRestaurant	DATE NOT NULL,
	timeArrivedAtRestaurant	DATE NOT NULL,
	timeOrderDelivered		DATE NOT NULL,
	paymentmethodid			INTEGER, 			

	primary key (orderid),
	foreign key (orderid) references Orders,
    foreign key (username) references DeliveryRiders,
	foreign key (paymentmethodid) references PaymentMethods
);


CREATE TABLE RestaurantPromo (
    description     varchar(50),
    restpromoid     INTEGER,
    startTime       DATE,
    endTime         DATE,
    restid          INTEGER NOT NULL,

    PRIMARY KEY (restpromoid)     
);


CREATE TABLE FullTimeRiders (
    username              varchar(30),
    PRIMARY KEY (username),
    FOREIGN KEY (username) REFERENCES DeliveryRiders
);

CREATE TABLE PartTimeRiders (
    username              varchar(30),
    PRIMARY KEY (username),
    FOREIGN KEY (username) REFERENCES DeliveryRiders
);

CREATE TABLE MonthlyWorkSchedule (
    mwsid              INTEGER,
    username             varchar(30),
    mnthStartDay       DATE NOT NULL,
    wkStartDay         INTEGER NOT NULL
                       CHECK (wkStartDay in (1, 2, 3, 4, 5, 6, 7)),
    mwsHours           INTEGER NOT NULL
                       CHECK (mwsHours = 40),
    completed          BOOLEAN NOT NULL,

    PRIMARY KEY (mwsid),
    FOREIGN KEY (username) REFERENCES FullTimeRiders
);

CREATE TABLE FixedWeeklySchedule (
    fwsid               INTEGER,
    mwsid               INTEGER,
    day1                INTEGER NOT NULL
                        CHECK (day1 in (1, 2, 3, 4)),
    day2                INTEGER NOT NULL
                        CHECK (day2 in (1, 2, 3, 4)),
    day3                INTEGER NOT NULL
                        CHECK (day3 in (1, 2, 3, 4)),
    day4                INTEGER NOT NULL
                        CHECK (day4 in (1, 2, 3, 4)),
    day5                INTEGER NOT NULL
                        CHECK (day5 in (1, 2, 3, 4)),

    PRIMARY KEY (fwsid),

    FOREIGN KEY (mwsid) REFERENCES MonthlyWorkSchedule
);

CREATE TABLE WeeklyWorkSchedule (
    wwsid               INTEGER,
    username              varchar(30),
    startDate           DATE,
    wwsHours            INTEGER,
    completed           BOOLEAN NOT NULL,

    PRIMARY KEY (wwsid),
    FOREIGN KEY (username) REFERENCES PartTimeRiders
);

CREATE TABLE DailyWorkShift (
    dwsid               INTEGER,
    startHour           INTEGER
                        CHECK (startHour >= 10 AND startHour <= 22),
    duration            INTEGER
                        CHECK (duration in (1, 2, 3, 4)),
    wwsid               INTEGER,

    PRIMARY KEY (dwsid, startHour),

    FOREIGN KEY (wwsid) REFERENCES WeeklyWorkSchedule
);

-- FDS Manager purposes

create table CustomerStats (
    username              varchar(30),
    monthid             INTEGER,
    totalNumOrders      INTEGER,
    totalCostOfOrders   INTEGER,

    primary key (username, monthid),
    foreign key (username) references Customers
);

CREATE TABLE RestaurantStats (
    restid              INTEGER,
    numCompletedOrders  INTEGER,
    totalOrdersCost     INTEGER,
    month               INTEGER,
    year                INTEGER,

    PRIMARY KEY (restid, month, year),

    FOREIGN KEY (restid) REFERENCES Restaurants
);

--use trigger to update the attributes every time the rider delivers an order, or updates his work schedule
CREATE TABLE RidersStats (
	username 			varchar(30),
	totalOrders		INTEGER,
	totalHours		INTEGER,
	totalSalary		INTEGER,
    month           INTEGER,
    year            INTEGER,

    primary key(username, month, year),
	foreign key(username)	references DeliveryRiders
);

CREATE TABLE AllStats (
    monthid             INTEGER,
    totalNewCust        INTEGER,
    totalNumOrders      INTEGER, --should be total num of restuarants--
    totalCostOfOrders   INTEGER,

    PRIMARY KEY (monthid)
);

------------------------- TRIGGER STATEMENTS -------------------------

/* Updates customer's total number of orders and total cost spent on orders 
or inserts new tuple if it is a new customer */
/*
create or replace function updateCustomerStatsFunction()
returns trigger as $$
begin
    update CustomerStats C
    set totalNumOrders = totalNumOrders + 1,
        totalCostOfOrders = totalCostOfOrders 
        + select O.totalCost from Orders O where O.orderid = C.orderid 
    where username = NEW.username
    order by monthid desc
    limit 1
    return null;
end;
%% language plpgsql;
# if it is a new customer
if (not exists(
    select 1
    from CustomerStats C
    where C.username = NEW.username)) then
    insert into CustomerStats values(NEW.username, NEW.totalCost);
else 
# if it is a nn existing customer 
    update CustomerStats
        set CustomerStats.totalNumOrders = CustomerStats.totalNumOrders + 1,
            CustomerStats.totalCostOfOrders = CustomerStats.totalCostOfOrders + NEW.totalCostOfOrders
        where CustomerStats.username = NEW.username;
    return new;
endif;    
end; $$ language plpgsql;        

drop trigger if exists updateCustomerStatsTrigger on CustomerStats;
create trigger updateCustomerStatsTrigger
    before insert on Orders
    for each row
    execute function updateCustomerStatsFunction();

# Increments the total number of distinct customers 
create or replace function addNewCustomer() 
returns trigger as $$
begin
if (not exists(
    select 1 
    from CustomerStats C
    where C.username = NEW.username))
then 
    update AllStats
    set totalNewCust = totalNewCust + 1;
end if;
return new;
end; $$ language plpgsql;

drop trigger if exists addNewCustomerTrigger ON AllStats;
create trigger addNewCustomerTrigger
    after insert on Orders
    for each row
    execute function addNewCustomer();

create or replace function dailyShiftConstraint() returns trigger
    as $$
declare 
    dwsid       integer;
begin
    select dws.dwsid into dwsid
        from DailyWorkShift dws 
        where new.dwsid = dws.dwsid
        and   ((dws.startHour <= new.startHour and new.startHour <= dws.startHour + dws.duration)
        or    (dws.startHour <= new.startHour + new.startHour and new.startHour + new.duration <= dws.startHour + dws.duration));
    if dwsid is not null then
        raise exception 'Hours clash with an existing shift';
    end if;
    return null;
end;
$$ language plpgsql;

create trigger dailyShiftConstraint_trigger
    after update of dwsid, starthour, duration OR insert on DailyWorkShift
    for each ROW
    execute function dailyShiftConstraint();

*/

/* NOTE THAT ALL THESE TRIGGERS HAVE NOT BEEN EDITED*/
-- need to check if it is a new location
/*create or replace function add_new_address() returns trigger as $$
begin
	-- insert function for locations
	return null;
end;
$$ language plpgsql;	

drop trigger if exists add_new_address_trigger ON Locations	
create trigger add_new_address_trigger
	after insert on Locations
	for each row 
	when (NEW.location exists in 
		select OLD.location
		where OLD.username = NEW.username)
	execute function add_new_address();

--have to update the most recent tuple */
/*create or replace function update_overall_stats() returns trigger
    as $$
begin
    update AllStats A
    set totalNumOrders = totalNumOrders + 1,
        totalCostOfOrders = totalCostOfOrders + new.totalCost (from orders help la how does new work)
    return null;
end;
%% language plpgsql;

drop trigger if exists update_trigger ON AllStats;
create trigger update_trigger
    after update of preparedByRest on Orders
    for each row
    execute function update_overall_stats();*/	

/*create or replace function update_rest_stats() returns trigger
    as $$
begin
    update RestaurantStats R
    set numCompletedOrders = NumCompletedOrders + 1,
        totalCostOfOrders = totalCostOfOrders 
        + select O.totalCost from Orders O where O.restid = R.restid order by order_created_time desc limit 1
    where restid = NEW.restid
    order by (month, year) desc
    limit 1
    return null;
end;
$$ language plpgsql;

drop trigger if exists update_trigger ON RestaurantStats;
create trigger update_trigger
    after update of preparedByRest on Orders
    for each row
    execute function update_rest_stats();


create or replace function update_avail() returns trigger
    as $$
declare 
    quantity integer
begin
    select C.quantity into quantity
        from Contains C 
        where F.restid = new.restid AND F.foodid = new.foodid

    update Food F
    set availability = availability - quantity
    where F.foodid = NEW.foodid AND F.restid = NEW.restid 
    return null;
end;
$$ language plpgsql;

drop trigger if exists update_avail_trigger ON Food;
create trigger update_avail_trigger
    after insert on Contains
    for each row 
    execute function update_avail();

create or replace function check_avail_constraint() returns trigger
    as $$
declare 
    avail  integer;
    quantity integer;
    description varchar(50)
begin
    select F.availability into avail, F.description into description 
        from Food F
        where F.restid = new.restid AND F.foodid = new.foodid
    select C.quantity into quantity
        from Contains C 
        where F.restid = new.restid AND F.foodid = new.foodid
    if avail < quantity then
        raise exception 'Item % is out of stock', description
        end if;
        return null;
end;
$$ language plpgsql;

drop trigger if exists check_avail_trigger ON Contains CASCADE;
create trigger check_avail_trigger
    after update of restid, foodid, orderid OR insert on Contains
    for each ROW
    execute function check_order_constraint();

create or replace function check_order_constraint() returns trigger
    as $$
declare 
    restid  integer;
    num   integer;
begin
    select C.restid into restid
        from Contains C 
        where C.restid = new.restid
    select count(*) into num
    from Contains C
    group by C.restid
    if restid is null && num != 0 then
        raise exception 'Food can only be ordered from the same restaurant' 
        end if;
        return null;
end;
$$ language plpgsql;

drop trigger if exists contains_trigger ON Contains CASCADE;
create trigger contains_trigger
    after update of restid, foodid, orderid OR insert on Contains
    for each ROW
    execute function check_order_constraint();*/

------------------------- INSERT STATEMENTS -------------------------


