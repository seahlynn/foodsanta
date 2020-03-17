create table Uaers (
    userid              INTEGER,
    name                varchar(20),
    password            varchar(10),

    primary key (userid)
)

create table Orders (
	orderid				INTEGER,
	customerid			INTEGER,
	ordercreatedtime	DATE, 
	deliveryfee			INTEGER not null,
	totalcost			INTEGER not null,
	fdspromoid			INTEGER,
    preparedbyrest      boolean not null,
    restid              INTEGER not null,

	primary key (orderid),
	foreign key (reid) references Reviews,
	foreign key (customerid) references Customers,
    foreign key (restid) references Restaurants,
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
	cardinfo		varchar(60),

	primary key (paymentmethodid),
	foreign key (customerid) references Customers
)

create table Delivers (
	orderid					INTEGER,
	rating					INTEGER check ((rating <= 5) and (rating >= 0)),
	location 				varchar(50) not null,
	timedeparttorestaurant	DATE not null,
	timearrivedatrestaurant	DATE not null,
	timeorderdelivered		DATE not null,
	paymentmethodid			INTEGER, 			

	primary key (orderid),
	foreign key (orderid) references Orders
	foreign key (paymentmethodid) references PaymentMethods
)

create table CustomersStats (
    customerid          INTEGER,
    totalnumorders      INTEGER,
    totalcostorders     INTEGER,

    primary key (customerid),
    foreign key (customerid) from Customers
)

-- for the FDS manager
create table AllStats (
    monthid             INTEGER,
    totalnewcust        INTEGER,
    totalorderscost     INTEGER,

    primary key (monthid)
)

create table RestaurantsStats (
    restid              INTEGER,
    numcompletedorders  INTEGER,
    totalorderscost     INTEGER,
    month               INTEGER,
    year                INTEGER,

    primary key (restid, month, year),
    foreign key (restid) from Restaurants
)

create table Food ( 
    foodid          integer,
    description     varchar(50),
    price           float not null,
    availability    integer not null,
    category        varchar(20),
    restid          integer not null,
    timesorderd     integer not null,

    primary key(foodid, restid),
    foreign key (restid) from Restaurants
);

insert into Food(foodid, price, availability, category) values
(1, 5, 100, 'Western'),
(2, 3.5, 100, 'Western'),
(3, 4.2, 100, 'Chinese'),
(4, 7.5, 100, 'Japanese'),
(5, 2, 100, 'Korean'),
(6, 3.6, 100, 'Chinese'),
(7, 5, 100, 'Western');

--insertion of food into Contains table has to decrease availability by one (use trigger under contains)
-----------------------------------------------
create table Restaurants (
    restid      INTEGER
    restname    varchar(50)
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
%% language plpgsql;

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
CREATE TABLE RiderStats (
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
     startday           INTEGER NOT NULL
                        CHECK (startday in (1, 2, 3, 4, 5, 6, 7)),
     mwshours           INTEGER NOT NULL
                        CHECK (totalhours = 40),
     fwsid              INTEGER NOT NULL,

     PRIMARY KEY (mwsid),
     FOREIGN KEY (fwsid) REFERENCES FixedWeeklySchedule
);

CREATE TABLE FixedWeeklySchedule (
    fwsid               INTEGER,
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
);

CREATE TABLE WeeklyWorkSchedule (
    wwsid               INTEGER,
    wwshours            INTEGER,

    PRIMARY KEY (wwsid)
);

CREATE TABLE DailyWorkShift (
    dwsid               INTEGER,
    starthour           INTEGER,
                        CHECK (starthour >= 10 AND starthour <= 22)
    duration            INTEGER,
                        CHECK (duration in (1, 2, 3, 4))
    wwsid               INTEGER,

    PRIMARY KEY (dwsid, starthour),
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
        and   ((dws.starthour <= new.starthour and new.starthour <= dws.starthour + dws.duration)
        or    (dws.starthour <= new.starthour + new.duration and new.starthour + new.duration <= dws.starthour + dws.duration))
    if dwsid is not null then
        raise exception 'Hours clash with an existing shift' 
        end if;
        return null;
end;
%% language plpgsql;
