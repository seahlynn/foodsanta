DROP TABLE IF EXISTS Users CASCADE;
DROP TABLE IF EXISTS Orders CASCADE;
DROP TABLE IF EXISTS Customers CASCADE;
DROP TABLE IF EXISTS CustomersStats CASCADE;
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
    userid              INTEGER,
    name                varchar(20),
    password            varchar(10),
    dateCreated			date,
    
    primary key (userid)
);

-- each customer has an entry in Locations but it uses userid
create table Customers (
	userid		INTEGER,
	points		INTEGER,

	primary key (userid)
);


CREATE TABLE DeliveryRiders (
    userid              INTEGER,
    PRIMARY KEY (userid),
    FOREIGN KEY (userid) REFERENCES Users
);

-- before insertion, check that customers only has less than 5
-- if not, delete the one with the earliest dateadded and add new one
create table Locations (
	userid 		    INTEGER,
	location		varchar(50),
	dateAdded		DATE not null,

	primary key (userid),
	foreign key (userid) references Customers
);

-- this is so that each customer can have multiple payment methods
-- for every order that requires payment, must look up this table and check userid must be the same 
create table PaymentMethods (
	paymentmethodid	INTEGER,
	userid  		INTEGER,
	cardInfo		varchar(60),

	primary key (paymentmethodid),
	foreign key (userid) references Customers
);

--insertion of food into Contains table has to decrease availability by one (use trigger under contains)
create table Restaurants (
    restid      INTEGER,
    restName    varchar(50),
    minAmt      INTEGER not null,

    primary key(restid)
);

create table Food ( 
    foodid          integer,
    description     varchar(50),
    price           float not null,
    availability    integer not null
                    check (availability >= 0),
    category        varchar(20),
    restid          integer not null,
    timesorderd     integer not null,

    primary key(foodid, restid),
    foreign key (restid) references Restaurants
);

--insertion into from table needs to check if restid is same as all other restid
create table FDSPromo (
    description     varchar(50),
    fdspromoid      integer,
    orderid         integer not null,
    startTime       DATE,
    endTime         DATE,

    primary key(fdspromoid)
);


create table Orders (
	orderid				INTEGER,
	userid			    INTEGER,
	orderCreatedTime	DATE, 
	deliveryFee			INTEGER not null,
	totalCost			INTEGER not null,
	fdspromoid			INTEGER,
    preparedByRest      boolean not null,
    restid              INTEGER not null,

	primary key (orderid),
	foreign key (userid) references Customers,
    foreign key (restid) references Restaurants,
	foreign key (fdspromoid) references FDSPromo
);


-- need to enforce that userid has made the order that has the same orderid
create table Reviews (
	orderid			INTEGER,
	reviewDesc		varchar(100),

	primary key (orderid),
	foreign key (orderid) references Orders
);



create table Contains (
    orderid     INTEGER not null,
    restid      INTEGER not null,
    foodid      INTEGER not null,
    userid 		INTEGER not null,
    description varchar(50) not null,
    quantity    INTEGER not null,

    primary key (orderid, foodid),
    foreign key(foodid, restid) references Food(foodid, restid),
    foreign key(orderid) references Orders
);


create table Delivers (
	orderid					INTEGER,
    userid                  INTEGER,
	rating					INTEGER check ((rating <= 5) and (rating >= 0)),
	location 				varchar(50) not null,
	timeDepartToRestaurant	DATE not null,
	timeArrivedAtRestaurant	DATE not null,
	timeOrderDelivered		DATE not null,
	paymentmethodid			INTEGER, 			

	primary key (orderid),
	foreign key (orderid) references Orders,
    foreign key (userid) references DeliveryRiders,
	foreign key (paymentmethodid) references PaymentMethods
);


create table RestaurantPromo (
    description     varchar(50),
    restpromoid     INTEGER,
    startTime       DATE,
    endTime         DATE,
    restid          INTEGER not null,

    primary key(restpromoid)     
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
    completed          BOOLEAN NOT NULL,

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

create table CustomersStats (
    userid              INTEGER,
    monthid             INTEGER,
    totalNumOrders      INTEGER,
    totalCostOfOrders     INTEGER,

    primary key (userid, monthid),
    foreign key (userid) references Customers
);

create table RestaurantStats (
    restid              INTEGER,
    numCompletedOrders  INTEGER,
    totalOrdersCost     INTEGER,
    month               INTEGER,
    year                INTEGER,

    primary key (restid, month, year),
    foreign key (restid) references Restaurants
);

--use trigger to update the attributes every time the rider delivers an order, or updates his work schedule
CREATE TABLE RidersStats (
	userid 			INTEGER,
	totalOrders		INTEGER,
	totalHours		INTEGER,
	totalSalary		INTEGER,
    month           INTEGER,
    year            INTEGER,

    primary key(userid, month, year),
	foreign key(userid)	references DeliveryRiders
);

create table AllStats (
    monthid             INTEGER,
    totalNewCust        INTEGER,
    totalNumOrders      INTEGER, --should be total num of restuarants--
    totalCostOfOrders   INTEGER,

    primary key (monthid)
);

------------------------- TRIGGER STATEMENTS -------------------------

/*create or replace function update_customer_stats() returns trigger
    as $$
begin
    update CustomerStats C
    set totalNumOrders = totalNumOrders + 1,
        totalCostOfOrders = totalCostOfOrders 
        + select O.totalCost from Orders O where O.orderid = C.orderid 
    where userid = NEW.userid
    order by monthid desc
    limit 1
    return null;
end;
%% language plpgsql;

drop trigger if exists update_trigger ON CustomerStats;
create trigger update_trigger
    after insert on Contains
    for each row
    execute function update_customer_stats();    

create or replace function check_dailyshift_constraint() returns trigger
    as $$
declare 
    dwsid       integer;
begin
    select dws.dwsid into dwsid
        from DailyWorkShift dws 
        where new.dwsid = dws.dwsid
        and   ((dws.startHour <= new.startHour and new.startHour <= dws.startHour + dws.duration)
        or    (dws.startHour <= new.startHour + new.startHour and new.startHour + new.duration <= dws.startHour + dws.duration))
    if dwsid is not null then
        raise exception 'Hours clash with an existing shift' 
        end if;
        return null;
end;
$$ language plpgsql;

drop trigger if exists dailyshift_trigger ON DailyWorkShift CASCADE;
create trigger dailyshift_trigger
    after update of dwsid, starthour, duration OR insert on DailyWorkShift
    for each ROW
    execute function check_dailyshift_constraint();

-- need to check if it is a new location
create or replace function add_new_address() returns trigger as $$
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

--have to update the most recent tuple
create or replace function increase_customer() returns trigger
    as $$
begin
    update AllStats
    set totalNewCust = totalNewCust + 1
    order by monthid desc
    limit 1
        
    return null;
end;
$$ language plpgsql;


drop trigger if exists increase_customer_trigger ON AllStats;
create trigger increase_customer_trigger
    after insert on Users
    for each row
    execute function increase_customer();*/

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

insert into Restaurants(restid, restname, minAmt) values
(1, '4Fingers', 15),
(2, 'Yoogane', 25),
(3, 'SushiTei', 40),
(4, 'KFC', 10),
(5, 'RiRi Mala', 15),
(6, 'Ah Bear Mookata', 20),
(7, 'Marche', 50),
(8, 'HaiDiLao', 80);    

--times ordered starts at 0 an availability at 100 for all food items currently)
insert into Food(foodid, description, restid, price, availability, category, timesordered) values
(1, ‘soy sauce wings’, 1, 12, 100, ‘Korean’, 0)
(2, ‘spicy drumlets, 1, 12, 100, ‘Korean’, 0)
(3, ‘army stew’, 2, 8, 24, ‘Korean’, 0)
(4, ‘kimchi pancakes’, 6, 8, 100, ‘Korean’, 0)
(5, ‘unagi sushi’, 3, 6, 100, ‘Japanese’, 0)
(6, ‘chawanmushi’, 3, 3, 100, ‘Japanese’, 0)
(7, ‘chicken katsu’, 3, 8, 100, ‘Japanese’, 0)
(8, ‘cheese fries’, 4, 4.5, 100, ‘FastFood’, 0)
(9, ‘popcorn chicken’, 4.2, 8, 100, ‘FastFood’, 0)
(10, ‘lime froyo’, 4, 2, 100, ‘FastFood’, 0)
(11, ‘zhong la mala hotpot’, 15, 8, 100, ‘Chinese’, 0)
(12, ‘da la mala hotpot’, 5, 17, 100, ‘Chinese’, 0)
(13, ‘smoked duck’, 6, 2.5, 100, ‘Sharing’, 0)
(14, ‘luncheon meat’, 6, 2, 100, ‘Sharing’, 0)
(15, ‘black pepper pork belly’, 6, 2, 100, ‘Sharing’, 0)
(16, ‘thai milk tea’, 6, 3, 100, ‘Beverage’, 0)
(17, ‘rosti’, 7, 8.90, 100, ‘Western’, 0)
(18, ‘pork knuckles’, 7, 16.50, 100, ‘Western’, 0)
(19, ‘smoked salmon pizza’, 7, 22.90, 100, ‘Western’, 0)
(20, ‘beef schnitzel’, 7, 19.90, 100, ‘Western’, 0)
(21, ‘prawn paste’, 8, 12, 100, ‘Chinese’, 0)
(22, ‘golden man tou’, 8, 8, 100, ‘Chinese’, 0);
