
/*


create or replace function dailyShiftConstraint() returns trigger
    as $$
declare 
    dwsid       integer;
begin
    select dws.dwsid into dwsid
        from DailyWorkShift dws 
        where new.dwsid = dws.dwsid
        and   ((dws.startHour <= new.startHour and new.startHour <= dws.startHour + dws.duration)
        or    (dws.startHour <= new.startHour + new.startHour and new.startHour + new.duration <= dws.startHour + dws.duration));
    if dwsid is not null then
        raise exception 'Hours clash with an existing shift';
    end if;
    return null;
end;
$$ language plpgsql;

create trigger dailyShiftConstraint_trigger
    after update of dwsid, starthour, duration OR insert on DailyWorkShift
    for each ROW
    execute function dailyShiftConstraint();

*/

/* NOTE THAT ALL THESE TRIGGERS HAVE NOT BEEN EDITED*/
/* need to check if it is a new location
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
		where OLD.username = NEW.username)
	execute function add_new_address();

--have to update the most recent tuple */
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
    for each row
    execute function update_overall_stats();*/	

/*create or replace function update_rest_stats() returns trigger
    as $$
begin
    update RestaurantStats R
    set numCompletedOrders = NumCompletedOrders + 1,
        totalCostOfOrders = totalCostOfOrders 
        + select O.totalCost from Orders O where O.restid = R.restid order by order_created_time desc limit 1
    where restid = NEW.restid
    order by (month, year) desc
    limit 1
    return null;
end;
$$ language plpgsql;

drop trigger if exists update_trigger ON RestaurantStats;
create trigger update_trigger
    after update of preparedByRest on Orders
    for each row
    execute function update_rest_stats();


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
    for each row 
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
    execute function check_order_constraint();*/

------------------------- INSERT STATEMENTS -------------------------


