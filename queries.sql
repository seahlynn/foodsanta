--list of food solds for individual restaurant (r1)

create view allFood (foodid, price, availability) AS
	select distinct F.foodid, F.price, F.availability
	from Food F
	where F.restid = r1;


--

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
		select sum(duration) as hours
		from WeeklyWorkSchedule wws, DailyWorkShift dws
		where wws.userid = d1
		and   dws.wwsid = wws.wwsid),
	ftViews as (
		select mwshours as hours
		from MonthlyWorkSchedule mws
		where mws.userid = d1)