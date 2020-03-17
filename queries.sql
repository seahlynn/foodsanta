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
