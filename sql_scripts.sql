
--Task 1 — Function: Calculate Order Total

create or replace function calculate_order_total(p_order_id int)
language plpgsql;
returns numeric as
$$
declare total numeric;
begin
	select coalesce(sum(oi.quantity*oi.price), 0) as total
	from order_items as oi
	where order_id = p_order_id;
	return total;
end;
$$




--Task 2 — Procedure: Create New Order
create or replace procedure create_order(p_customer_id int)
language plpgsql
AS $$
begin
	if not exists(
		select 1 from customers
		where customer_id = p_customer_id)
		then
			return;
	end if;
	insert into orders(customer_id, order_date, total_amount)
	values (p_customer_id, current_timestamp, 0);

end;
$$;

