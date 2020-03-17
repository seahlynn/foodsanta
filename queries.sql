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
create view seeReviews (reviewdesc, ordercreatedtime) as 
    select reviewdesc, ordercreatedtime
    from Reviews natural join Orders
    where Orders.restid = r2;

-- see reviews written by themselves (customer c3)
create view seeOwnReviews (reviewdesc, ordercreatedtime) as
    select reviewdesc, ordercreatedtime
    from Reviews natural join Orders
    where Orders.customerid = c3;

-- see registered payment methods by customer (c1)
create view custPaymentMethods (cardinfo) as
    select cardinfo
    from PaymentMethods 
    where customerid = c1;

-- see points of customer (c2)
create view custPoints (points) as
    select points
    from Customers
    where customerid = c2;

-- see locations of customer (c4) 
create view seeLocations (location, dateadded) as    
    select (location, dateadded) 
    from Locations 
    where customerid = c4
    order by dateadded asc;

-- see current promotions acc to current time (t1) 
create view seePromotions(promodesc) as
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
create view seeCurrentOrder(orderid, ordercreatedtime, timedeparttorestaurant, 
    timearrivedatrestaurant, cardinfo) as   
    select distinct Orders.orderid, Orders.ordercreatedtime, 
        Delivers.timedeparttorestaurant, Delivers.timearrivedatrestaurant,
        PaymentMethods.cardinfo 
    from (Orders natural join Delivers) natural join PaymentMethods
    where Delivers.timeorderdelivered = null
    and Orders.customer = c5;

-- see all previous orders made by customer (c6)
create view seePastOrders(orderid, ordercreatedtime, timedeparttorestaurant, 
    timearrivedatrestaurant, timeorderdelivered, cardinfo) as 
    select distinct Orders.orderid, Orders.ordercreatedtime, 
        Delivers.timedeparttorestaurant, Delivers.timearrivedatrestaurant,
        Delivers.timeorderdelivered, PaymentMethods.cardinfo 
    from (Orders natural join Delivers) natural join PaymentMethods
    where Delivers.timeorderdelivered <> null
    and Orders.customer = c6;


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
	select S.totalorderscost
	from RestaurantsStats S
	where S.restid = r1
	and month = 2
	and year = 2020;

--total orders for restaurant r1
create view totalRevenue(revenue) AS
	select S.totalorderscost
	from RestaurantsStats S
	where S.restid = r1
	and month = 2
	and year = 2020;

