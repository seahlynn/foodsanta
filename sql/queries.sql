-- Customers

-- view all restaurants
create view allRestaurants (restid) as
    select distinct restid
    from Restaurants;

-- view menu of particular restaurant (r1) with price
create view restaurantMenuItems (foodid) as
    select distinct foodid, description, price
    from Food
    where restid = r1
    and availability > 0;

-- see reviews of a particular restaurant (r2) written by others 
-- and when it was created
create view seeReviews (reviewDesc, orderCreatedTime) as
    select reviewDesc, orderCreatedTime
    from Reviews natural join Orders
    where Orders.restid = r2;

-- see reviews written by themselves (customer c3)
create view seeOwnReviews (reviewDesc, orderCreatedTime) as
    select reviewDesc, orderCreatedTime
    from Reviews natural join Orders
    where Orders.userid = c3;

-- see registered payment methods by customer (c1)
create view custPaymentMethods (cardInfo) as
    select cardInfo
    from PaymentMethods 
    where userid = c1;

-- see points of customer (c2)
create view custPoints (points) as
    select points
    from Customers
    where userid = c2;

-- see locations of customer (c4) 
create view seeLocations (location, dateAdded) as    
    select (location, dateAdded) 
    from Locations 
    where customerid = c4
    order by dateAdded asc;

-- see current promotions acc to current time (t1) 
create view seePromotions (promodesc) as
    select distinct description
    from FDSPromo
    where startTime <= t1
    and endTime >= t1
    union
    select distinct description
    from RestaurantPromo
    where startTime <= t1
    and endTime >= t1;

-- see current order being made acc to current time (t2) by customer (c5)
-- if time delivered is not null, then order has been delivered
create view seeCurrentOrder (orderid, orderCreatedTime, timeDepartToRestaurant, 
    timeArrivedAtRestaurant, cardinfo) as   
    select distinct Orders.orderid, Orders.orderCreatedTime, 
        Delivers.timeDepartToRestaurant, Delivers.timeArrivedAtRestaurant,
        PaymentMethods.cardinfo 
    from (Orders natural join Delivers) natural join PaymentMethods
    where Delivers.timeOrderDelivered = null
    and Orders.userid = c5;

-- see all previous orders made by customer (c6)
create view seePastOrders (orderid, orderCreatedTime, timeDepartToRestaurant, 
    timeArrivedAtRestaurant, timeOrderDelivered, cardinfo) as 
    select distinct Orders.orderid, Orders.orderCreatedTime, 
        Delivers.timeDepartToRestaurant, Delivers.timeArrivedAtRestaurant,
        Delivers.timeOrderDelivered, PaymentMethods.cardinfo 
    from (Orders natural join Delivers) natural join PaymentMethods
    where Delivers.timeOrderDelivered <> null
    and Orders.userid = c6;


--Restaurants    

--list of food solds for individual restaurant (r1)
create view allFood (foodid, price, availability) AS
	select distinct F.foodid, F.price, F.availability
	from Food F
	where F.restid = r1;

--Restaurant r1 views all the food ordered by customers from r1
--need to check where to get order status from
create view foodOrdered(orderid, foodid, description, quantity) AS
	select C.orderid, C.foodid, C.description, C.quantity
	from Contains C, Orders 
	where C.restid = r1
	and (O.orderid = C.orderid and O.preparedbyrest = FALSE);


--revenue for restaurant r1 of for feb of 2020
create view totalRevenue(revenue) AS
	select S.totalCostOfOrders
	from RestaurantsStats S
	where S.restid = r1
	and month = 2
	and year = 2020;

--total orders for restaurant r1
create view totalOrders(numOrders) AS
	select S.numcompletedorders
	from RestaurantsStats S
	where S.restid = r1
	and month = 2
	and year = 2020;

--five most popular orders for restaurant r1
create view mostPopularItems(foodid) AS
	select F.foodid
	from Foods F
	where F.restid = r1
	order by timesorderd
	limit 5;

-- campaigns and their durations for rest r1
create view durationCampaigns(restpromoid, duration) AS
	with Duration as (
		select P.restpromoid, datediff(day, P.startTime, P.endTime) as duration
		from RestaurantPromo P
		group by P.restpromoid)

	select P.restpromoid, D.duration
	from RestaurantPromo P, D.duration
	where P.restid = r1
	and P.restpromoid = D.restpromoid;
	

create view avgOrdersPerCampaign(restpromoid, avgOrders) AS
	with Duration as (
		select P.restpromoid, datediff(day, P.startTime, P.endTime) as duration
		from RestaurantPromo P
		group by P.restpromoid),
	with TotalOrders as (
		SELECT O.restpromoid, count(*) as totalOrders
		from Orders
		group by O.restpromoid)


	select O.restpromoid, (T.totalOrders / D.duration) as avgOrders
	from Duration D, TotalOrders T
	where D.restpromoid = T.restpromoid

-- RIDERS TO COLLECT ORDERS
-- 1. to see the orders that they can deliver
create view ordersToPickUp(orderid, custLocation, restLocation) AS
	select orderid, custLocation, (select location from Restaurants where Restaurants.restid = Orders.restid)
	from Orders 
	where preparedByRest = TRUE 
	and collectedByRider = FALSE;

-- 2. after selecting particular order o1, update the order
update Orders
	set collectedByRider = TRUE
	where Orders.orderid = o1.orderid;

-- 3. create new entry in Delivers d31 for that particular order o1 by rider dr1
-- currentTime for when it is collected
-- other 2 times are null 
insert into Delivers
	values (o1.orderid, 'this rider id', null, o1.custLocation, 'currentTime', null, null, o1.paymentmethodid);

-- 4. when order de1 is collected at restaurant
update Delivers
	set timeArrivedAtRestaurant = 'currentTime'
	where Delivers.orderid = de1.orderid;

-- 5. when order de1 is delivered to customer
update Delivers
	set timeOrderDelivered = 'currentTime'
	where Delivers.orderid = de1.orderid;

-- 6. update stats of driver who delivered it 	
update RidersStats
	set totalOrders = totalOrders + 1
	where RidersStats.userid = dr1.userid;	

-- FDS Manager

-- see stats for the month (m1)
create view seeMonthlyStats (totalNewCust, totalNumOrders, 
    totalCostOfOrders) as
    select totalNewCust, totalNumOrders, totalCostOfOrders
    from AllStats
    where monthid = m1;

-- see each customer stats for the month (m2)
create view seeEachCustomerStats (userid, totalNumOrders, totalCostOfOrders) as
    select userid, totalNumOrders, totalCostOfOrders
    from CustomersStats
    where monthid = m2;

--orders assigned to a delivery rider (d1)
create view allDeilveryOrders (orderid) as
	select D.orderid
	from Delivers D
	where D.userid = d1
	and   D.timeorderdelivered = null

--timings of an order (o1)
create view orderTimings (ordercreatedtime, timedeparttolocation, timearrivedatrestaurant, timeorderdelivered) as
	select O.ordercreatedtime, D.timeorderdelivered, D.timearrivedatrestaurant, D.timeorderdelivered
	from Orders O, Delivers D
	where O.orderid = o1
	and   D.orderid = o1

--past orders assigned to a rider (d1)
create view pastOrders (orderid) as
	select D.orderid
	from Delievers D
	where D.userid = d1
	and   D.timeorderdelivered not null

--past work schedules of a rider (d1)
create view pastWorkSchedules (wwsid) as
	with
	ptViews as (
		select wws.wsid as scheduleid
		from WeeklyWorkSchedule wws
		where wws.userid = d1
		and   wws.completed = true),
	ftViews as (
		select mws.wsid as scheduleid
		from MonthlyWorkSchedule mws
		where mws.userid = d1
		and   mws.completed = true),
	select scheduleid
	from ptViews union ftViews

--current work schedyles of a rider d1
create view currWorkSchedules (wwsid) as
	with
	ptViews as (
		select wws.wsid as scheduleid
		from WeeklyWorkSchedule wws
		where wws.userid = d1
		and   wws.completed = false),
	ftViews as (
		select mws.wsid as scheduleid
		from MonthlyWorkSchedule mws
		where mws.userid = d1
		and   mws.completed = false),
	select scheduleid
	from ptViews union ftViews

--monthly delivery history for rider d1, month m1, year y1
create view monthlyDeliveryHistory (orderid) as
	select D.orderid
	from Delivers D
	where D.userid = d1
	and	  D.timeorderdelivered not null
	and   YEAR(D.timeorderdelivered) = y1
	and   MONTH(D.timeorderdelivered) = m1
    
-- see eacg rider stats for the month (m3)
create view seeEachRidersStats (userid, totalOrders, totalHours, totalSalary) as
    select userid, totalOrders, totalHours, totalSalary
    from RidersStats
    where monthid = m3;

--monthly number of deliveries for rider d1, month m1, year y1
create view monthlyDeliveryCount (orderid) as
	select count(*)
	from Delivers D
	where D.userid = d1
	and	  D.timeorderdelivered not null
	and   YEAR(D.timeorderdelivered) = y1
	and   MONTH(D.timeorderdelivered) = m1

--monthly number of hours worked for rider d1, month m1, year y1
create view monthlyHoursWorked (hours) as
	with
	ptViews as (
		select sum(dws.duration) as hours
		from WeeklyWorkSchedule wws, DailyWorkShift dws
		where wws.userid = d1
		and   dws.wwsid = wws.wwsid
		and   MONTH(wws.startDate) = m1
		and   YEAR(wws.startDate) = y1),
	ftViews as (
		select mws.mwsHours as hours
		from MonthlyWorkSchedule mws
		where mws.userid = d1
		and MONTH(mws.mnthStartDay) = m1
		and YEAR(mws.mnthStartDay) = y1)
	select (PT.hours + FT.hours) as hours
	from ptViews PT, ftViews FT

--salary of rider r1, month m1, year y1
create view riderSalary (salary) as
	select RS.totalSalary
	from RidersStats RT
	where RT.userid = r1
	and RS.month = m1
	and RS.year = y1

--total salary earned in month m1, year y1
create view montlySalary (salary) as
	select sum(RS.totalSalary)
	from RidersStats RT
	where RS.month = m1
	and RS.year = y1
