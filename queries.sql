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

