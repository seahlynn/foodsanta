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


/*create view avgOrdersPerCampaign(restpromoid, avgOrders) AS
	with Duration as (
		select P.restpromoid, datediff(day, P.startTime, P.endTime) as duration
		from RestaurantPromo P
		group by P.restpromoid)



	with AverageOrders as (
		select P.restpromoid, count(*) as totalOrders, datediff(day, P.startTime, P.endTime) as totalTime
		from RestaurantPromo P
		where P.restid = r1
		group by P.restpromoid)*/

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

-- see eacg rider stats for the month (m3)
create view seeEachRiderStats (userid, totalOrders, totalHours, totalSalary) as
    select userid, totalOrders, totalHours, totalSalary
    from RiderStats
    where monthid = m3;
