
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


--Task 4 — Trigger: Update Order Total
create or replace function fnc_recalculat_total_amound()
returns trigger
language plpgsql
as
$$
begin
	update orders
	set total_amount = calculate_order_total(coalesce(new.order_id, old.order_id))
-- coalesce тут для того щоб вибирав не null, бо при ibsert існує тільки new,при update both, при delete тільки old
	where order_id = coalesce(new.order_id, old.order_id);
	return null;
end;
$$;

create or replace trigger trg_recalculat_total_amound
after insert or update or delete
on order_items
for each row
execute function fnc_recalculat_total_amound();



--Task 5 — Trigger: Order Audit Log

create or replace function fnc_order_audit_log()
returns trigger
language plpgsql
as
$$
begin
	insert into order_log(order_id, customer_id, action, log_date)
	values (new.order_id, new.customer_id, 'created', current_timestamp);
	return null;
end;
$$;


create or replace trigger trg_order_audit_log
after insert
on orders
for each row
execute function fnc_order_audit_log();



--Task 6 — Testing

--1)customers can be created;
insert into customers (full_name, email, balance)
values ('Puhach Olha', 'puhach.olha@kse', 1780);
select*
from customers;
-- прицює в таблиці з'явився новий кастомер


--2)products can be created;
insert into products(product_name, price, stock_quantity)
values ('iphone', 47000, 100);

select*
from products;
-- працює в таблиці з'явився новий продукт


--3)orders can be created using the procedure;
call create_order(1);
select*
from orders;
-- додає замовлення з поточним часом


--4)products can be added to orders using the procedure;
call add_product_to_order(1,2,4);
select*
from order_items;
-- спрацбовує і додає  в order_items нове з ціною попереднього


--5) order totals are updated automatically;

SELECT order_id, total_amount
FROM orders
where order_id = 1 ;
-- так після зміни oreder_items oreder total перерахувалось автоматино

--6) product stock decreases correctly;

select product_name, stock_quantity
from products;
-- перевірили скільки було до
call add_product_to_order(1, 1, 2);
-- додаємо в замовлення щоб кількість змінилась
select product_name, stock_quantity
from products;
-- перевірили так кількість змінилась було 9 стало 7


--7)order creation is logged in order_log.
select*
from order_log;
-- так після перевірки створення замовлення в таблицю додалися значення

