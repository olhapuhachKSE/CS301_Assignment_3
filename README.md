# CS301_Assignment_3
# I create a small database system for managing orders in an online store.

## The goal of this assignment is to practice:
* SQL functions  
* SQL procedures  
* triggers  
* audit logging  
* testing database logic  
* basic Git workflow  
* basic query analysis with EXPLAIN ANALYZE  

---

## Created tables
* **customers** – stores customer data (name, email, balance)  
* **products** – stores product information and stock quantity  
* **orders** – date and total amount  
* **order_items** – stores products inside orders  
* **order_log** – stores logs about created orders  

---

## Main tasks

* **Function calculate_order_total** – calculates total price of an order using quantity × price  

* **Procedure create_order** – creates a new order for a customer  

* **Procedure add_product_to_order** – adds product to order, checks stock, and decreases stock quantity  

* **Trigger recalculat_total_amound** – automatically updates total_amount when order_items changes  

* **Trigger order audit log** – saves information about created orders into order_log  

---

## Testing
I tested the system by:
* creating customers and products  
* creating orders using procedures  
* adding products to orders  
* checking automatic calculation of order total  
* checking stock decrease  
* checking order logs  

Everything works correctly.


