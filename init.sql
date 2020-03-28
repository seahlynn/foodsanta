create table Users (
    userid              INTEGER,
    name                varchar(20),
    password            varchar(10),

    primary key (userid)
)

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
	foreign key (reid) references Reviews,
	foreign key (userid) references Customers,
    foreign key (restid) references Restaurants,
	foreign key (fdspromoid) references FDSPromo
)

-- each customer has an entry in Locations but it uses userid
create table Customers (
	userid		INTEGER,
	points			INTEGER,

	primary key (userid)
)

-- need to enforce that userid has made the order that has the same orderid
create table Reviews (
	orderid			INTEGER,
	reviewDesc		varchar(100),

	primary key (orderid),
	foreign key (orderid) from Orders
)

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

-- before insertion, check that customers only has less than 5
-- if not, delete the one with the earliest dateadded and add new one
create table Locations (
	userid 		    INTEGER,
	location		varchar(50),
	dateAdded		DATE not null,

	primary key (userid),
	foreign key (userid) references Customers
)

-- this is so that each customer can have multiple payment methods
-- for every order that requires payment, must look up this table and check userid must be the same 
create table PaymentMethods (
	paymentmethodid	INTEGER,
	userid  		INTEGER,
	cardInfo		varchar(60),

	primary key (paymentmethodid),
	foreign key (userid) references Customers
)

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
	foreign key (orderid) references Orders
    foreign key (userid) references DeliveryRiders
	foreign key (paymentmethodid) references PaymentMethods
)

create table CustomersStats (
    userid              INTEGER,
    monthid             INTEGER,
    totalNumOrders      INTEGER,
    totalCostOfOrders     INTEGER,

    primary key (userid, monthid),
    foreign key (userid) from Customers
)

/*create or replace function update_customer_stats() returns trigger
    as $$
begin
    update CustomerStats C
    set totalNumOrders = totalNumOrders + 1,
        totalCostOfOrders = totalCostOfOrders + select O.totalCost from Orders O where O.userid = C.userid 
    return null;
end;
%% language plpgsql;

drop trigger if exists update_trigger ON CustomerStats;
create trigger update_trigger
    after insert on Contains
    for each STATEMENT
    execute function update_customer_stats();*/

-- for the FDS manager
create table AllStats (
    monthid             INTEGER,
    totalNewCust        INTEGER,
    totalNumOrders      INTEGER,  ## should be the total of all restaurant
    totalCostOfOrders   INTEGER,

    primary key (monthid)
)

create or replace function increase_customer() returns trigger
    as $$
begin
    update AllStats
    set totalNewCust = totalNewCust + 1
        
    return null;
end;
$$ language plpgsql;

drop trigger if exists increase_customer_trigger ON AllStats;
create trigger increase_customer_trigger
    after insert on Users
    for each STATEMENT
    execute function increase_customer();

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
    for each STATEMENT
    execute function update_overall_stats();*/


create table RestaurantsStats (
    restid              INTEGER,
    numCompletedOrders  INTEGER,
    totalOrdersCost     INTEGER,
    month               INTEGER,
    year                INTEGER,

    primary key (restid, month, year),
    foreign key (restid) from Restaurants
)

/*create or replace function update_rest_stats() returns trigger
    as $$
begin
    update RestaurantStats R
    set numCompletedOrders = NumCompletedOrders + 1,
        totalCostOfOrders = totalCostOfOrders + select O.totalCost from Orders O where O.restid = R.restid / new.totalCost
    return null;
end;
%% language plpgsql;

drop trigger if exists update_trigger ON RestaurantStats;
create trigger update_trigger
    after update of preparedByRest on Orders
    for each STATEMENT
    execute function update_rest_stats();*/


create table Food ( 
    foodid          integer,
    description     varchar(50),
    price           float not null,
    availability    integer not null 
                    check availability >= 0,
    category        varchar(20),
    restid          integer not null,
    timesorderd     integer not null,

    primary key(foodid, restid),
    foreign key (restid) from Restaurants
);

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
    for each STATEMENT /*row??*/
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

--insertion of food into Contains table has to decrease availability by one (use trigger under contains)
-----------------------------------------------
create table Restaurants (
    restid      INTEGER
    restName    varchar(50)
    minAmt      INTEGER not null

    primary key(restid)
);

insert into Restaurants(restid, restname, minAmt) values
(1, '4Fingers', 15),
(2, 'RiRi Mala', 15),
(3, 'Yoogane', 25),
(4, 'SushiTei', 40),
(5, 'KFC', 10),
(6, 'Ah Bear Mookata', 20),
(7, 'Marche', 50),
(8, 'HaiDiLao', 80);

----------------------------------------------
create table RestaurantPromo (
    description     varchar(50)
    restpromoid     INTEGER
    startTime       DATE
    endTime         DATE
    restid          INTEGER not null

    primary key(restpromoid)     
);

insert into RestaurantPromo(restpromoid, restid, description, startTime, endTime) values
(1, 1, '20% off orders exceeding $50'),
(2, 2, '50% off'),
(3, 3, 'free delivery'),
(4, 4, '$5 off min. purchase of $30'),
(5, 5, 'buy 1 free 1 cheese fries');

------------------------------------------------------
create table Contains (
    orderid     INTEGER not null,
    restid      INTEGER not null,
    foodid      INTEGER not null,
    description varchar(50) not null,
    quantity    INTEGER not null,

    primary key (orderid, foodid),
    foreign key(foodid, restid) references Food,
    foreign key(orderid) references Orders
);

insert into Contains(orderid, restid, foodid) values
(1, 2, 5),
(1, 2, 7),
(1, 2, 8),
(2, 5, 9),
(2, 5, 11),
(2, 5, ),
(3, 3, 5);

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
    execute function check_order_constraint();


--insertion into from table needs to check if restid is same as all other restid
----------------------------------------------------
create table FDSPromo (
    description     varchar(50),
    fdspromoid      integer,
    orderid         integer not null,
    startTime       DATE,
    endTime         DATE,

    primary key(fdspromoid),
    foreign key(orderid) references Campaigns
);

insert into FDSPromo(fdspromoid, orderid, description) values
(1, 1, '10% off first order'),
(2, 2, '30% off minimum order $80'),
(3, 3, 'free delivery from when to when'),
(4, 4, '$5 off min. order of $30'),
(5, 5, '20% more points from purchase');

CREATE TABLE DeliveryRiders (
    userid              INTEGER,
    PRIMARY KEY (userid),
    FOREIGN KEY (userid) REFERENCES Users
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
                       CHECK (startday in (1, 2, 3, 4, 5, 6, 7),
    mwsHours           INTEGER NOT NULL
                       CHECK (totalhours = 40),
    completed          BOOLEAN NOT NULL,

    PRIMARY KEY (mwsid),
    FOREIGN KEY (userid) REFERENCES FullTimeRiders
);

CREATE TABLE FixedWeeklySchedule (
    fwsid               INTEGER,
    mwsid               INTEGER,
    day1                INTEGER NOT NULL
                        CHECK (day1 in (1, 2, 3, 4),
    day2                INTEGER NOT NULL
                        CHECK (day2 in (1, 2, 3, 4),
    day3                INTEGER NOT NULL
                        CHECK (day3 in (1, 2, 3, 4),
    day4                INTEGER NOT NULL
                        CHECK (day4 in (1, 2, 3, 4),
    day5                INTEGER NOT NULL
                        CHECK (day5 in (1, 2, 3, 4),

    PRIMARY KEY (fwsid)
    FOREIGN KEY (mwsid) REFERENCES MonthlyWorkSchedule
);

CREATE TABLE WeeklyWorkSchedule (
    wwsid               INTEGER,
    userid              INTEGER,
    startDate           DATE,
    wwsHours            INTEGER,
    completed          BOOLEAN NOT NULL,

    PRIMARY KEY (wwsid)
    FOREIGN KEY (userid) REFERENCES PartTimeRiders
);

CREATE TABLE DailyWorkShift (
    dwsid               INTEGER,
    startHour           INTEGER,
                        CHECK (startHour >= 10 AND startHour <= 22)
    duration            INTEGER,
                        CHECK (duration in (1, 2, 3, 4))
    wwsid               INTEGER,

    PRIMARY KEY (dwsid, startHour),
    FOREIGN KEY (wwsid) REFERENCES WeeklyWorkSchedule
)

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