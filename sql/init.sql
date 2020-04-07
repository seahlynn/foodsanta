DROP TABLE IF EXISTS Users CASCADE;
DROP TABLE IF EXISTS Orders CASCADE;
DROP TABLE IF EXISTS Customers CASCADE;
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

CREATE TABLE Users (
    userid              INTEGER,
    name                varchar(20),
    password            varchar(10),
    dateCreated			DATE,
    
    PRIMARY KEY (userid)
);

-- each customer has an entry in Locations but it uses userid
CREATE TABLE Customers (
	userid		INTEGER,
	points		INTEGER,

	PRIMARY KEY (userid)
);


CREATE TABLE DeliveryRiders (
    userid          INTEGER,
    
    PRIMARY KEY (userid),

    FOREIGN KEY (userid) REFERENCES Users
);

-- before insertion, check that customers only has less than 5
-- if not, delete the one with the earliest dateadded and add new one
CREATE TABLE Locations (
	userid 		    INTEGER,
	location		varchar(50),
	dateAdded		DATE NOT NULL,

	PRIMARY KEY (userid),

	FOREIGN KEY (userid) REFERENCES Customers
);

-- this is so that each customer can have multiple payment methods
-- for every order that requires payment, must look up this table and check userid must be the same 
CREATE TABLE PaymentMethods (
	paymentmethodid	INTEGER,
	userid  		INTEGER,
	cardInfo		varchar(60),

	PRIMARY KEY (paymentmethodid),

	FOREIGN KEY (userid) REFERENCES Customers
);

--insertion of food into Contains table has to decrease availability by one (use trigger under contains)
CREATE TABLE Restaurants (
    restid      INTEGER,
    restName    varchar(50),
    minAmt      INTEGER NOT NULL,
    locations   varchar(50) NOT NULL,

    PRIMARY KEY (restid)
);

CREATE TABLE Food ( 
    foodid          INTEGER,
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
	userid			    INTEGER,
    custLocation        varchar(50) NOT NULL,
	orderCreatedTime	DATE, 
	totalCost			INTEGER NOT NULL,
	fdspromoid			INTEGER,
    paymentmethodid     INTEGER,
    preparedByRest      boolean NOT NULL default False,
    collectedByRider    boolean NOT NULL default False,
    restid              INTEGER NOT NULL,

	PRIMARY KEY (orderid),

	FOREIGN KEY (userid) REFERENCES Customers,
    FOREIGN KEY (restid) REFERENCES Restaurants,
	FOREIGN KEY (fdspromoid) REFERENCES FDSPromo
);

-- need to enforce that userid has made the order that has the same orderid
CREATE TABLE Reviews (
	orderid			INTEGER,
	reviewDesc		varchar(100),

	PRIMARY KEY (orderid),

	FOREIGN KEY (orderid) REFERENCES Orders
);

CREATE TABLE Contains (
    orderid         INTEGER NOT NULL,
    foodid          INTEGER NOT NULL,
    userid 		    INTEGER NOT NULL,
    description     varchar(50) NOT NULL,
    quantity        INTEGER NOT NULL,

    PRIMARY KEY (orderid, foodid),

    FOREIGN KEY (foodid) REFERENCES Food,
    FOREIGN KEY (orderid) REFERENCES Orders,
    FOREIGN KEY (userid) REFERENCES Users
);


CREATE TABLE Delivers (
	orderid					INTEGER,
    userid                  INTEGER,
	rating					INTEGER check ((rating <= 5) and (rating >= 0)),
	location 				varchar(50) NOT NULL,
    deliveryFee             INTEGER NOT NULL,
	timeDepartToRestaurant	DATE NOT NULL,
	timeArrivedAtRestaurant	DATE NOT NULL,
	timeOrderDelivered		DATE NOT NULL,
	paymentmethodid			INTEGER, 			

	PRIMARY KEY (orderid),

	FOREIGN KEY (orderid) REFERENCES Orders,
    FOREIGN KEY (userid) REFERENCES DeliveryRiders,
	FOREIGN KEY (paymentmethodid) REFERENCES PaymentMethods
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
    userid              INTEGER,

    PRIMARY KEY (userid),

    FOREIGN KEY (userid) REFERENCES DeliveryRiders
);

CREATE TABLE PartTimeRiders (
    userid              INTEGER,

    PRIMARY KEY (userid),

    FOREIGN KEY (userid) REFERENCES DeliveryRiders
);

CREATE TABLE MonthlyWorkSchedule (
    mwsid              INTEGER,
    userid             INTEGER,
    mnthStartDay       DATE NOT NULL,
    wkStartDay         INTEGER NOT NULL
                       CHECK (wkStartDay in (1, 2, 3, 4, 5, 6, 7)),
    mwsHours           INTEGER NOT NULL
                       CHECK (mwsHours = 40),
    completed          BOOLEAN NOT NULL,

    PRIMARY KEY (mwsid),

    FOREIGN KEY (userid) REFERENCES FullTimeRiders
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
    userid              INTEGER,
    startDate           DATE,
    wwsHours            INTEGER,
    completed           BOOLEAN NOT NULL,

    PRIMARY KEY (wwsid),

    FOREIGN KEY (userid) REFERENCES PartTimeRiders
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

CREATE TABLE CustomerStats (
    userid              INTEGER,
    monthid             INTEGER,
    totalNumOrders      INTEGER,
    totalCostOfOrders   INTEGER,

    PRIMARY KEY (userid, monthid),

    FOREIGN KEY (userid) REFERENCES Customers
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
	userid 			INTEGER,
	totalOrders		INTEGER,
	totalHours		INTEGER,
	totalSalary		INTEGER,
    month           INTEGER,
    year            INTEGER,

    PRIMARY KEY (userid, month, year),
    
	FOREIGN KEY (userid)	REFERENCES DeliveryRiders
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
create or replace function updateCustomerStatsFunction()
returns trigger as $$
begin
/* if it is an existing customer */ 
if (not exists(
    select 1
    from CustomerStats C
    where C.userid = NEW.userid))
then
    insert into CustomerStats values(NEW.userid, NEW.totalCost);
end if;
/* if it is a new customer */
update CustomerStats C1
    set C1.totalNumOrders = C1.totalNumOrders + 1
    where C1.userid = NEW.userid;
update CustomerStats C2
    set C2.totalCostOfOrders = C2.totalCostOfOrders + NEW.totalCostOfOrders
    where C2.userid = NEW.userid;
return new;
end; $$ language plpgsql;        

drop trigger if exists updateCustomerStatsTrigger on CustomerStats;
create trigger updateCustomerStatsTrigger
    before insert on Orders
    for each row
    execute function updateCustomerStatsFunction();

/* Increments the total number of distinct customers */
create or replace function addNewCustomer() 
returns trigger as $$
begin
if (not exists(
    select 1 
    from CustomerStats C
    where C.userid = NEW.userid))
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

/*
drop trigger if exists update_trigger ON CustomerStats;
create trigger update_trigger
    after insert on Contains
    for each row
    execute function update_customer_stats();    */

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
		where OLD.userid = NEW.userid)
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



