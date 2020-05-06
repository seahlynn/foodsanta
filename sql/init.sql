DROP TABLE IF EXISTS Users CASCADE;
DROP TABLE IF EXISTS Orders CASCADE;
DROP TABLE IF EXISTS Customers CASCADE;
DROP TABLE IF EXISTS CustomerStats CASCADE;
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
    name                VARCHAR(30) NOT NULL,
    password            VARCHAR(15) NOT NULL,
    phoneNumber         VARCHAR(8) NOT NULL,
    dateCreated			date NOT NULL,

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
	username  		VARCHAR(30) NOT NULL,
	cardInfo		VARCHAR(60) NOT NULL,

	PRIMARY KEY (paymentmethodid),

	FOREIGN KEY (username) REFERENCES Customers
);

--insertion of food into Contains table has to decrease availability by one (use trigger under contains)
CREATE TABLE Restaurants (
    restid      INTEGER,
    restName    VARCHAR(50) NOT NULL,
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
    description     VARCHAR(50) NOT NULL,
    price           decimal NOT NULL,
    dailylimit		INTEGER NOT NULL CHECK (dailylimit >= 0),
    availability    INTEGER NOT NULL CHECK (availability >= 0),
    category        VARCHAR(20) NOT NULL,
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
    username			VARCHAR(30) NOT NULL,
    custLocation        VARCHAR(100) NOT NULL,
	orderCreatedTime	TIMESTAMP NOT NULL, 
	totalCost			decimal NOT NULL,
	fdspromoid			INTEGER,
    paymentmethodid     INTEGER NOT NULL,
    preparedByRest      BOOLEAN NOT NULL DEFAULT FALSE, -- should this be null / datetime instead
    selectedByRider     BOOLEAN NOT NULL DEFAULT FALSE,
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
    orderid     INTEGER,
    foodid      INTEGER,
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
	paymentmethodid			INTEGER NOT NULL, 			

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

    PRIMARY KEY (mwsid),

    FOREIGN KEY (username) REFERENCES FullTimeRiders
);

-- CREATE TABLE FixedWeeklySchedule (
--     fwsid               INTEGER,
--     mwsid               INTEGER,
--     day1                INTEGER NOT NULL
--                         CHECK (day1 in (0, 1, 2, 3)),
--     day2                INTEGER NOT NULL
--                         CHECK (day2 in (0, 1, 2, 3)),
--     day3                INTEGER NOT NULL
--                         CHECK (day3 in (0, 1, 2, 3)),
--     day4                INTEGER NOT NULL
--                         CHECK (day4 in (0, 1, 2, 3)),
--     day5                INTEGER NOT NULL
--                         CHECK (day5 in (0, 1, 2, 3)),

--     PRIMARY KEY (fwsid),

--     FOREIGN KEY (mwsid) REFERENCES MonthlyWorkSchedule
-- );

CREATE TABLE WeeklyWorkSchedule (
    wwsid               INTEGER,
    username            VARCHAR(30),
    startDate           DATE NOT NULL,
    wwsHours            INTEGER NOT NULL,
    completed           BOOLEAN NOT NULL,

    PRIMARY KEY (wwsid),

    FOREIGN KEY (username) REFERENCES PartTimeRiders
);

CREATE TABLE DailyWorkShift (
    dwsid               INTEGER,
    wwsid               INTEGER,
<<<<<<< HEAD
    day                 INTEGER NOT NULL,
    startHour           INTEGER NOT NULL
=======
    day                 INTEGER
                        CHECK (day in (0, 1, 2, 3, 4, 5, 6)),
    startHour           INTEGER
>>>>>>> 72a108e4c992a992075a2548d2094e699d6a33cd
                        CHECK (startHour >= 10 AND startHour <= 22),
    duration            INTEGER NOT NULL
                        CHECK (duration in (1, 2, 3, 4)),

    PRIMARY KEY (dwsid, startHour),

    FOREIGN KEY (wwsid) REFERENCES WeeklyWorkSchedule
);

CREATE TABLE RiderPerHour (
    rphid               INTEGER,
    day                 DATE,
    hour                INTEGER,
    count               INTEGER,

    PRIMARY KEY (rphid)
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
    numCompletedOrders  INTEGER,
    totalOrdersCost     INTEGER,
    month               INTEGER,
    year                INTEGER,

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
    set totalSalary = totalSalary + 5
    where month = (select extract(month from current_timestamp)
    and year = (select extract(year from current_timestamp)
    and username = NEW.username; 
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
    where foodid = OLD.foodid;
return new;
end; $$ language plpgsql;        

drop trigger if exists increaseAvailFoodTrigger on Food;
create trigger increaseAvailFoodTrigger
    after delete on Contains
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
		(select foodid from Contains where orderid = NEW.orderid)
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


/* update weekly work schedule hours upon insertion*/ 
create or replace function updateWwsHoursOnInsertFunction()
returns trigger as $$
DECLARE
hours INTEGER;
existingDay TEXT;
begin
    update WeeklyWorkSchedule
    set wwsHours = wwsHours + NEW.duration
    where wwsid = NEW.wwsid;

    select wwsHours into hours
        from WeeklyWorkSchedule
        where wwsid = NEW.wwsid;

    select case when NEW.day = 0 then 'Monday' when NEW.day = 1 then 'Tuesday' when NEW.day = 2 then 'Wednesday' when NEW.day = 3 then 'Thursday' when NEW.day = 4 then 'Friday' when NEW.day = 5 then 'Saturday' when NEW.day = 6 then 'Sunday' end into existingDay
        from DailyWorkShift
        where wwsid = NEW.wwsid;
    if hours > 44 then
        raise exception 'FoodSanta: A shift you are trying to add (%hrs to %hrs on %) results in you working more than 48 hours this week! Ho ho ho!', NEW.startHour * 100, (NEW.startHour + NEW.duration) * 100, existingDay;
    end if;
return new;
end; $$ language plpgsql;        

drop trigger if exists updateWwsHoursOnInsertTrigger on DailyWorkShift;
create trigger updateWwsHoursOnInsertTrigger
    before insert on DailyWorkShift
    for each row
    execute function updateWwsHoursOnInsertFunction();

/* update weekly work schedule hours upon deletion*/ 
create or replace function updateWwsHoursOnDeleteFunction()
returns trigger as $$
DECLARE
hours INTEGER;
existingDay TEXT;
begin
    update WeeklyWorkSchedule
    set wwsHours = wwsHours - OLD.duration
    where wwsid = OLD.wwsid;

    select wwsHours into hours
        from WeeklyWorkSchedule
        where wwsid = OLD.wwsid;

    select case when OLD.day = 0 then 'Monday' when OLD.day = 1 then 'Tuesday' when OLD.day = 2 then 'Wednesday' when OLD.day = 3 then 'Thursday' when OLD.day = 4 then 'Friday' when OLD.day = 5 then 'Saturday' when OLD.day = 6 then 'Sunday' end into existingDay
        from DailyWorkShift
        where wwsid = OLD.wwsid;
    if hours < 10 then
        raise exception 'FoodSanta: A shift you are trying to delete (%hrs to %hrs on %) results in you working less than 10 hours this week! Ho ho ho!', OLD.startHour * 100, (OLD.startHour + OLD.duration) * 100, existingDay;
    end if;
return new;
end; $$ language plpgsql;        

drop trigger if exists updateWwsHoursOnDeleteTrigger on DailyWorkShift;
create trigger updateWwsHoursOnDeleteTrigger
    after delete on DailyWorkShift
    for each row
    execute function updateWwsHoursOnDeleteFunction();

/* check validity of a new part time shift hours*/
create or replace function validPartTimeShiftFunction()
returns trigger as $$
DECLARE
existingDay TEXT;
existingStartHour INTEGER;
existingDuration INTEGER;
begin
    select case when d1.day = 0 then 'Monday' when d1.day = 1 then 'Tuesday' when d1.day = 2 then 'Wednesday' when d1.day = 3 then 'Thursday' when d1.day = 4 then 'Friday' when d1.day = 5 then 'Saturday' when d1.day = 6 then 'Sunday' end, d1.startHour, d1.duration into existingDay, existingStartHour, existingDuration
        from DailyWorkShift d1, DailyWorkShift d2
        where d1.wwsid = NEW.wwsid and d1.day = NEW.day and d2.dwsid = new.dwsid and d1.dwsid <> d2.dwsid
        and   ((d1.startHour <= NEW.startHour and NEW.startHour <= d1.startHour + d1.duration)
        or    (d1.startHour <= NEW.startHour + NEW.duration and NEW.startHour + NEW.duration <= d1.startHour + d1.duration));
    if existingStartHour is not null then
        raise exception 'FoodSanta: A shift you are trying to add (%hrs to %hrs on %) clashes with an existing shift (%hrs to %hrs)! Ho ho ho!', NEW.startHour * 100, (NEW.startHour + NEW.duration) * 100, existingDay, existingStartHour * 100, (existingStartHour + existingDuration) * 100;
    end if;
    return null;
end; $$ language plpgsql;        

drop trigger if exists validPartTimeShiftTrigger on DailyWorkShift;
create trigger validPartTimeShiftTrigger
    after insert on DailyWorkShift
    for each row
    execute function validPartTimeShiftFunction();

/* check if a new part time shift hours exceeds 10pm*/
create or replace function tenPmPartTimeShiftFunction()
returns trigger as $$
DECLARE
day TEXT;
startHour INTEGER;
duration INTEGER;
begin
    select case when d1.day = 0 then 'Monday' when d1.day = 1 then 'Tuesday' when d1.day = 2 then 'Wednesday' when d1.day = 3 then 'Thursday' when d1.day = 4 then 'Friday' when d1.day = 5 then 'Saturday' when d1.day = 6 then 'Sunday' end, d1.startHour, d1.duration into day, startHour, duration
        from DailyWorkShift d1
        where d1.dwsid = NEW.dwsid
        and   (NEW.startHour + NEW.duration) > 22;
    if startHour is not null then
        raise exception 'FoodSanta: A shift you are trying to add (%hrs to %hrs on %) exceeds the working hours of 2200hrs! Ho ho ho!', NEW.startHour * 100, ((NEW.startHour + NEW.duration) % 24) * 100, day;
    end if;
    return null;
end; $$ language plpgsql;        

drop trigger if exists tenPmPartTimeShiftTrigger on DailyWorkShift;
create trigger tenPmPartTimeShiftTrigger
    after insert on DailyWorkShift
    for each row
    execute function tenPmPartTimeShiftFunction();
