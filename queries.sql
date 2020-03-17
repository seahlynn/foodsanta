--list of food solds for individual restaurant (r1)

create view allFood (foodid, price, availability) AS
	select distinct F.foodid, F.price, F.availability
	from Food F
	where F.restid = r1;


--