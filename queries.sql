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



