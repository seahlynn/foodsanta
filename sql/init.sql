DROP TABLE IF EXISTS Users CASCADE;
DROP TABLE IF EXISTS Orders CASCADE;
DROP TABLE IF EXISTS Customers CASCADE;
DROP TABLE IF EXISTS CustomerStats CASCADE;
DROP TABLE IF EXISTS FDSManagers CASCADE;
DROP TABLE IF EXISTS RestaurantStaff CASCADE;
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
DROP TABLE IF EXISTS UsersPromo CASCADE;
DROP TABLE IF EXISTS DeliveryPromo CASCADE;
DROP TABLE IF EXISTS UsersDeliveryPromo CASCADE;
DROP TABLE IF EXISTS FullTimeRiders CASCADE;
DROP TABLE IF EXISTS PartTimeRiders CASCADE;
DROP TABLE IF EXISTS RiderStats CASCADE;
DROP TABLE IF EXISTS WeeklyWorkSchedule CASCADE;
DROP TABLE IF EXISTS FixedWeeklySchedule CASCADE;
DROP TABLE IF EXISTS MonthlyWorkSchedule CASCADE;
DROP TABLE IF EXISTS DailyWorkShift CASCADE;
DROP TABLE IF EXISTS Latest CASCADE;


CREATE TABLE Users (
    username            VARCHAR(30),    
    name                VARCHAR(30),
    password            VARCHAR(15),
    phoneNumber         VARCHAR(8),
    dateCreated			date,

    PRIMARY KEY (username)
);

-- each customer has an entry in Locations but it uses username
CREATE TABLE Customers (
	username            VARCHAR(30),
	points		        INTEGER default 0,
	
    PRIMARY KEY (username),
    
    FOREIGN KEY (username) REFERENCES Users
);


CREATE TABLE DeliveryRiders (
    username    VARCHAR(30),
    
    PRIMARY KEY (username),
    
    FOREIGN KEY (username) REFERENCES Users
);

CREATE TABLE FDSManagers (
    username              VARCHAR(30),

    PRIMARY KEY (username),
    
    FOREIGN KEY (username) REFERENCES Users
);


-- before insertion, check that customers only has less than 5
-- if not, delete the one with the earliest dateadded and add new one
CREATE TABLE Locations (
	username 		varchar(30),
	location		varchar(100),
	dateAdded		DATE NOT NULL,

	PRIMARY KEY (username, location),

	FOREIGN KEY (username) REFERENCES Customers
);

-- this is so that each customer can have multiple payment methods
-- for every order that requires payment, must look up this table and check username must be the same 
-- but payment method can also be cash.. then how? can set paymentmethodid = 1 for cash? 2 onwards is for card
CREATE TABLE PaymentMethods (
	paymentmethodid	INTEGER,
	username  		VARCHAR(30),
	cardInfo		VARCHAR(60),

	PRIMARY KEY (paymentmethodid),

	FOREIGN KEY (username) REFERENCES Customers
);

--insertion of food into Contains table has to decrease availability by one (use trigger under contains)
CREATE TABLE Restaurants (
    restid      INTEGER,
    restName    VARCHAR(50),
    minAmt      INTEGER NOT NULL,
    location    VARCHAR(100) NOT NULL,

    PRIMARY KEY (restid)
);

CREATE TABLE RestaurantStaff (
    username              VARCHAR(30),
    restid                INTEGER DEFAULT NULL,

    PRIMARY KEY (username),
    
    FOREIGN KEY (username) REFERENCES Users,
    FOREIGN KEY (restid) REFERENCES Restaurants
);

CREATE TABLE Food ( 
    foodid          INTEGER,
    description     VARCHAR(50),
    price           decimal NOT NULL,
    dailylimit		INTEGER NOT NULL CHECK (dailylimit >= 0),
    availability    INTEGER NOT NULL CHECK (availability >= 0),
    category        VARCHAR(20),
    restid          INTEGER NOT NULL,
    timesordered    INTEGER NOT NULL DEFAULT 0,

    PRIMARY KEY (foodid),

    FOREIGN KEY (restid) REFERENCES Restaurants
);

--insertion into from table needs to check if restid is same as all other restid
CREATE TABLE FDSPromo (
    fdspromoid      INTEGER,
    description     VARCHAR(200) NOT NULL,
    type 			VARCHAR(50) NOT NULL,
    CONSTRAINT chck_type CHECK (type IN ('percentoff', 'amountoff')),
    value 			INTEGER CHECK (value > 0 AND value <100),
	minAmnt			INTEGER DEFAULT 0,
	appliedto		VARCHAR,
	CONSTRAINT chck_appliedto CHECK (appliedto IN ('total', 'delivery')),
    startTime       DATE NOT NULL,
    endTime         DATE NOT NULL,
    points 			INTEGER default 0,

    PRIMARY KEY (fdspromoid)
);

CREATE TABLE DeliveryPromo (
    deliverypromoid      INTEGER,
    description     VARCHAR(200) NOT NULL,
    amount 			INTEGER not null,
    points 			INTEGER default 0,

    PRIMARY KEY (deliverypromoid)
);

CREATE TABLE UsersPromo (
	fdspromoid		INTEGER,
	username		VARCHAR(30),

	FOREIGN KEY (fdspromoid) REFERENCES FDSPromo ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (username) REFERENCES Customers  ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (fdspromoid, username)
);

CREATE TABLE UsersDeliveryPromo (
	deliverypromoid		INTEGER,
	username		VARCHAR(30),

	FOREIGN KEY (deliverypromoid) REFERENCES DeliveryPromo ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (username) REFERENCES Customers  ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (deliverypromoid, username)
);

CREATE TABLE RestaurantPromo (
	fdspromoid		INTEGER,
	restid 			INTEGER,

    PRIMARY KEY (fdspromoid, restid),
    FOREIGN KEY(fdspromoid) REFERENCES FDSPromo ON DELETE CASCADE
);

CREATE TABLE Orders (
	orderid				INTEGER,
    username			VARCHAR(30),
    custLocation        VARCHAR(100) NOT NULL,
	orderCreatedTime	TIMESTAMP,
	totalCost			decimal NOT NULL,
	fdspromoid			INTEGER,
    paymentmethodid     INTEGER NOT NULL,
    preparedByRest      BOOLEAN NOT NULL DEFAULT False, -- should this be null / datetime instead
    selectedByRider     BOOLEAN NOT NULL DEFAULT False,
    restid              INTEGER NOT NULL,
    delivered   		BOOLEAN NOT NULL DEFAULT FALSE,

	PRIMARY KEY (orderid),

	FOREIGN KEY (username) REFERENCES Customers,
    FOREIGN KEY (restid) REFERENCES Restaurants,
	FOREIGN KEY (fdspromoid) REFERENCES FDSPromo
);

-- need to enforce that username has made the order that has the same orderid
CREATE TABLE Reviews (
	orderid			INTEGER,
	reviewDesc		VARCHAR(100),

	PRIMARY KEY (orderid),

	FOREIGN KEY (orderid) REFERENCES Orders
);

CREATE TABLE Contains (
    orderid     INTEGER NOT NULL,
    foodid      INTEGER NOT NULL,
    quantity    INTEGER NOT NULL,

    PRIMARY KEY (orderid, foodid),

    FOREIGN KEY (foodid) REFERENCES Food
);

CREATE TABLE Delivers (
	orderid					INTEGER,
    username                VARCHAR(30), 
	rating					INTEGER CHECK ((rating <= 5) AND (rating >= 0)),
	location 				VARCHAR(100) NOT NULL,
    deliveryFee             DECIMAL NOT NULL,
	timeDepartToRestaurant	TIMESTAMP,
	timeArrivedAtRestaurant	TIMESTAMP,
	timeOrderDelivered		TIMESTAMP,
	paymentmethodid			INTEGER not null, 			

	PRIMARY KEY (orderid),

	FOREIGN KEY (orderid) REFERENCES Orders,
    FOREIGN KEY (username) REFERENCES DeliveryRiders,
	FOREIGN KEY (paymentmethodid) REFERENCES PaymentMethods
);

CREATE TABLE FullTimeRiders (
    username              VARCHAR(30),

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
    username           VARCHAR(30),
    mnthStartDay       DATE NOT NULL,
    wkStartDay         INTEGER NOT NULL
                       CHECK (wkStartDay in (0, 1, 2, 3, 4, 5, 6)),
    completed          BOOLEAN NOT NULL,

    PRIMARY KEY (mwsid),

    FOREIGN KEY (username) REFERENCES FullTimeRiders
);

CREATE TABLE FixedWeeklySchedule (
    fwsid               INTEGER,
    mwsid               INTEGER,
    day1                INTEGER NOT NULL
                        CHECK (day1 in (0, 1, 2, 3)),
    day2                INTEGER NOT NULL
                        CHECK (day2 in (0, 1, 2, 3)),
    day3                INTEGER NOT NULL
                        CHECK (day3 in (0, 1, 2, 3)),
    day4                INTEGER NOT NULL
                        CHECK (day4 in (0, 1, 2, 3)),
    day5                INTEGER NOT NULL
                        CHECK (day5 in (0, 1, 2, 3)),

    PRIMARY KEY (fwsid),

    FOREIGN KEY (mwsid) REFERENCES MonthlyWorkSchedule
);

CREATE TABLE WeeklyWorkSchedule (
    wwsid               INTEGER,
    username            VARCHAR(30),
    startDate           DATE,
    wwsHours            INTEGER,
    completed           BOOLEAN NOT NULL,

    PRIMARY KEY (wwsid),

    FOREIGN KEY (username) REFERENCES PartTimeRiders
);

CREATE TABLE DailyWorkShift (
    dwsid               INTEGER,
    wwsid               INTEGER,
    day                 INTEGER,
    startHour           INTEGER
                        CHECK (startHour >= 10 AND startHour <= 22),
    duration            INTEGER
                        CHECK (duration in (1, 2, 3, 4)),

    PRIMARY KEY (dwsid, startHour),

    FOREIGN KEY (wwsid) REFERENCES WeeklyWorkSchedule
);

-- FDS Manager purposes

CREATE TABLE CustomerStats (
    username            VARCHAR(30),
    month            	INTEGER,
    year 				INTEGER,
    totalNumOrders      INTEGER,
    totalCostOfOrders   INTEGER,

    PRIMARY KEY (username, month, year),

    FOREIGN KEY (username) REFERENCES Customers
);

CREATE TABLE RestaurantStats (
    restid              INTEGER,
    month               INTEGER,
    year                INTEGER,
    numCompletedOrders  INTEGER,
    totalOrdersCost     INTEGER,

    PRIMARY KEY (restid, month, year),

    FOREIGN KEY (restid) REFERENCES Restaurants
);

--use trigger to update the attributes every time the rider delivers an order, or updates his work schedule
CREATE TABLE RiderStats (
	month           INTEGER,
    year            INTEGER,
	username 	    VARCHAR(30),
	totalOrders		INTEGER,
	totalHours		INTEGER,
	totalSalary		INTEGER,
    
    PRIMARY KEY (username, month, year),

	FOREIGN KEY (username) REFERENCES DeliveryRiders
);

CREATE TABLE AllStats (
    month               INTEGER,
    year                INTEGER,
    totalNewCust        INTEGER,
    totalNumOrders      INTEGER, --should be total num of restuarants--
    totalCostOfOrders   INTEGER,

    PRIMARY KEY (month, year)
);

CREATE TABLE Latest (
	orderid			INTEGER,
	restid 			INTEGER,

	primary key (orderid),
	foreign key (restid) references Restaurants
	
);

------------------------- TRIGGER STATEMENTS -------------------------

/* Updates customer's total number of orders and total cost spent on orders or inserts new tuple if it is a new customer */ 
create or replace function updateCustomerStatsFunction()
returns trigger as $$
begin
    /* new customer  */
    if (not exists(
        select 1
        from CustomerStats C1
        where C1.username = NEW.username
        and C1.month = (select extract(month from current_timestamp))
        and C1.year = (select extract(year from current_timestamp)))) then
        insert into CustomerStats values(NEW.username, (select extract(month from current_timestamp)), (select extract(year from current_timestamp)), 1, NEW.totalCost);
    /* existing customer */
    else 
        update CustomerStats C2
        set totalNumOrders = totalNumOrders + 1,
            totalCostOfOrders = totalCostOfOrders + NEW.totalCost
        where C2.username = NEW.username
        and C2.month = (select extract(month from current_timestamp))
        and C2.year = (select extract(year from current_timestamp)); /* TO CHECK FOR CURRENT MONTH */
end if;    
return new;
end; $$ language plpgsql;        

drop trigger if exists updateCustomerStatsTrigger on CustomerStats;
create trigger updateCustomerStatsTrigger
    before insert on Orders
    for each row
    execute function updateCustomerStatsFunction();

/* Updates restaurant's total number of orders and total cost spent on orders */
create or replace function updateRestaurantStatsFunction()
returns trigger as $$
begin
    /* restid first entry */
    if (not exists(
        select 1
        from RestaurantStats R1
        where R1.restid = NEW.restid
        and R1.month = (select extract(month from current_timestamp))
        and R1.year = (select extract(year from current_timestamp)))) then
        insert into RestaurantStats values(NEW.restid, (select extract(month from current_timestamp)), (select extract(year from current_timestamp)), 1, NEW.totalCost);
    /* restid not first entry of monthyear */
    else
        update RestaurantStats R2
        set numCompletedOrders = numCompletedOrders + 1,
            totalOrdersCost = totalOrdersCost + NEW.totalCost
        where R2.restid = NEW.restid
        and R2.month = (select extract(month from current_timestamp))
        and R2.year = (select extract(year from current_timestamp)); 
end if;    
return new;
end; $$ language plpgsql;

drop trigger if exists updateRestaurantStatsTrigger on RestaurantStats;
create trigger updateRestaurantStatsTrigger
    before insert on Orders
    for each row
    execute function updateRestaurantStatsFunction();

/* Increments the total number of distinct customers */
create or replace function addNewCustomerFunction() 
returns trigger as $$
begin
    if (not exists(
        select 1 
        from Customers C
        where C.username = NEW.username))
    then
        if (not exists (
            select 1
            from AllStats
            where month = (select extract(month from current_timestamp))
            and year = (select extract(year from current_timestamp)))) 
        then insert into AllStats values ((select extract(month from current_timestamp)), (select extract(year from current_timestamp)), 0, 0, 0); 
        end if;

        update AllStats
        set totalNewCust = totalNewCust + 1
        where month = (select extract(month from current_timestamp))
        and year = (select extract(year from current_timestamp));
end if;
return new;
end; $$ language plpgsql;

drop trigger if exists addNewCustomerTrigger ON AllStats;
create trigger addNewCustomerTrigger
    after insert on Customers
    for each row
    execute function addNewCustomerFunction(); 

/* Updates allstats with +1 total num of orders and + total cost*/ 
create or replace function updateAllStatsFunction()
returns trigger as $$
begin
    /* new stats for the month  */
    if (not exists (
            select 1
            from AllStats
            where month = (select extract(month from current_timestamp))
            and year = (select extract(year from current_timestamp)))) 
            then insert into AllStats values ((select extract(month from current_timestamp)), (select extract(year from current_timestamp)), 0, 1, NEW.totalCost);
    /* existing customer */
    else 
        update AllStats
        set totalNumOrders = totalNumOrders + 1,
            totalCostOfOrders = totalCostOfOrders + NEW.totalCost
        where month = (select extract(month from current_timestamp))
        and year = (select extract(year from current_timestamp)); /* TO CHECK FOR CURRENT MONTH */
    end if; 

return new;
end; $$ language plpgsql;        

drop trigger if exists updateAllStatsTrigger on AllStats;
create trigger updateAllStatsTrigger
    before insert on Orders
    for each row
    execute function updateAllStatsFunction();

/* Updates rider's total salary after completing a delivery order (fixed delivery bonus = 5)*/
create or replace function updateRiderDeliveryBonusFunction()
returns trigger as $$
begin
    update RiderStats
    set totalSalary = totalSalary + 5; 
return new;
end; $$ language plpgsql;

drop trigger if exists updateRiderDeliveryBonusTrigger on RiderStats;
create trigger updateRiderDeliveryBonusTrigger
    after update of totalOrders on RiderStats
    for each row
    execute function updateRiderDeliveryBonusFunction();

/* update Locations for top 5 locations*/ 
create or replace function updateLocationFunction()
returns trigger as $$
begin
    /* check if location already inside  */
    if (not exists (select 1 from Locations where username = NEW.username and location = NEW.custLocation)) then
        /* still got space to add more locations */
        if ((select count(*) from Locations where username = NEW.username) < 5) then
            insert into Locations values (NEW.username, NEW.custLocation, (select current_date));
        /* existing customer */
        else
            update Locations
            set location = NEW.custLocation, dateAdded = current_date
            where location = (select location from Locations order by dateAdded limit 1) and username = NEW.username;
        end if; 
    end if;   
return new;
end; $$ language plpgsql;        

drop trigger if exists updateLocationTrigger on AllStats;
create trigger updateLocationTrigger
    before insert on Orders
    for each row
    execute function updateLocationFunction();

/* update availability of food items*/ 
/*create or replace function updateAvailFoodFunction()
returns trigger as $$
DECLARE 
containrow RECORD;
begin
    for containrow in
        (select foodid, quantity from Contains C where C.orderid = NEW.orderid)
    loop
        update Food
        set availability = availability - containrow.quantity
        where foodid = containrow.foodid;
    end loop;
return new;
end; $$ language plpgsql;        

drop trigger if exists updateAvailFoodTrigger on Food;
create trigger updateAvailFoodTrigger
    before insert on Orders
    for each row
    execute function updateAvailFoodFunction();*/

/* update availability of food items*/ 
create or replace function decreaseAvailFoodFunction()
returns trigger as $$
begin
    update Food
    set availability = availability - 1
    where foodid = NEW.foodid;
return new;
end; $$ language plpgsql;        

drop trigger if exists decreaseAvailFoodTrigger on Food;
create trigger decreaseAvailFoodTrigger
    before insert on Contains
    for each row
    execute function decreaseAvailFoodFunction();

/* update availability of food items*/ 
create or replace function increaseAvailFoodFunction()
returns trigger as $$
begin
    update Food
    set availability = availability + 1
    where foodid = NEW.foodid;
return new;
end; $$ language plpgsql;        

drop trigger if exists increaseAvailFoodTrigger on Food;
create trigger increaseAvailFoodTrigger
    before delete on Contains
    for each row
    execute function increaseAvailFoodFunction();

/* update availability of food items*/ 
create or replace function updateAvailFoodFunction()
returns trigger as $$
begin
	if (OLD.quantity > NEW.quantity) then
	    update Food
	    set availability = availability + 1
	    where foodid = NEW.foodid;
	else 
		update Food
	    set availability = availability - 1
	    where foodid = NEW.foodid;
	end if;
return new;
end; $$ language plpgsql;        

drop trigger if exists updateAvailFoodTrigger on Food;
create trigger updateAvailFoodTrigger
    before update on Contains
    for each row
    execute function updateAvailFoodFunction();

/* update points for Customers*/ 
create or replace function updatePointsFunction()
returns trigger as $$
begin
    update Customers
    set points = points + cast(NEW.totalCost as int)
    where username = NEW.username;
return new;
end; $$ language plpgsql;        

drop trigger if exists updatePointsTrigger on Customers;
create trigger updatePointsTrigger
    after insert on Orders
    for each row
    execute function updatePointsFunction();

/* add default cash on delivery payment method for customer*/ 
create or replace function addCashMethodFunction()
returns trigger as $$
DECLARE
paymentmethodid INTEGER;
begin
    if ((select count(*) from PaymentMethods) = 0) then 
        paymentmethodid = 1;
    else
        paymentmethodid = cast((select P.paymentmethodid from PaymentMethods P order by paymentmethodid desc limit 1) as int) + 1;
    end if;

    insert into PaymentMethods values (paymentmethodid, NEW.username, 'cash on delivery');
return new;
end; $$ language plpgsql;        

drop trigger if exists addCashMethodTrigger on Customers;
create trigger addCashMethodTrigger
    after insert on Customers
    for each row
    execute function addCashMethodFunction();


/* deduct customer's points after purchase of promo*/ 
create or replace function deductPointsPromoFunction()
returns trigger as $$
DECLARE
pointsused INTEGER;
begin
    select into pointsused (select points from FDSPromo where fdspromoid = NEW.fdspromoid);

    update Customers C set points = points - pointsused where C.username = NEW.username;
return new;
end; $$ language plpgsql;        

drop trigger if exists deductPointsPromoTrigger on Customers;
create trigger deductPointsPromoTrigger
    after insert on UsersPromo
    for each row
    execute function deductPointsPromoFunction();

/* deduct customer's points after purchase of promo*/ 
create or replace function deductPointsDeliveryFunction()
returns trigger as $$
DECLARE
pointsused INTEGER;
begin
    select into pointsused (select points from DeliveryPromo where deliverypromoid = NEW.deliverypromoid);

    update Customers C set points = points - pointsused where C.username = NEW.username;
return new;
end; $$ language plpgsql;        

drop trigger if exists deductPointsDeliveryTrigger on Customers;
create trigger deductPointsDeliveryTrigger
    after insert on UsersDeliveryPromo
    for each row
    execute function deductPointsDeliveryFunction();

/*add promotions under user's promo if points needed to buy is 0*/
create or replace function addUsersPromoFunction()
returns trigger as $$
DECLARE
pointsused INTEGER;
customer RECORD;
begin
    select into pointsused (select points from FDSPromo where fdspromoid = NEW.fdspromoid);

    if pointsused = 0 then
	    for customer in
	        (select username from Customers)
	    loop
	    	insert into UsersPromo values (NEW.fdspromoid, customer.username);
	    end loop;
	end if;
return new;
end; $$ language plpgsql;        

drop trigger if exists addUsersPromoTrigger on UsersPromo;
create trigger addUsersPromoTrigger
    after insert on FDSPromo
    for each row
    execute function addUsersPromoFunction();

/*add times ordered of food*/
create or replace function incrementTimesOrderedFoodFunction()
returns trigger as $$
DECLARE
foodrec RECORD;
begin
    for foodrec in
		(select foodid from Contains natural join Orders where orderid = NEW.orderid and username = NEW.username)
	loop
		update Food set timesOrdered = timesOrdered + 1 where foodid = foodrec.foodid;
	end loop;

return new;
end; $$ language plpgsql;

drop trigger if exists incrementTimesOrderdFoodTrigger on Orders;
create trigger incrementTimesOrderedFoodTrigger
    after insert on Orders
    for each row
    execute function incrementTimesOrderedFoodFunction();



