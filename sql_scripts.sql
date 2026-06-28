
--Task 1 — Function: Calculate Order Total

create or replace function calculate_order_total(p_order_id int)
returns numeric
language plpgsql
as
$$
declare total numeric;
begin
	select coalesce(sum(oi.quantity*oi.price), 0)
	into total
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

-- Task 3 — Procedure: Add Product to Order

create or replace procedure add_product_to_order(
    p_order_id int,
    p_product_id int,
    p_quantity int
)
language plpgsql
AS $$
declare
	intermediate_price numeric(10,2);
	intermediate_stock_quantity int;
begin
	if  p_quantity <= 0
-- перевірка щоб не додати нульове або від'ємне quantity
		then
			return;
	end if;

	select stock_quantity, price
	into intermediate_stock_quantity, intermediate_price
	from products
	where product_id = p_product_id;

	if intermediate_stock_quantity < p_quantity
-- перевірка на Prevent adding a product if there is not enough stock.
		then
			return;
	end if;

	insert into order_items(order_id, product_id, quantity, price)
	values (p_order_id, p_product_id, p_quantity, intermediate_price);
--Use the current product price from the products table.

	update products
	set stock_quantity = stock_quantity -p_quantity
--Decrease products.stock_quantity.
	where product_id = p_product_id;

end;
$$;

