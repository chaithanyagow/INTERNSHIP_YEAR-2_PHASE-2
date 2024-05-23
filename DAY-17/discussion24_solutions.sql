-- 1.Updatable View:
    --Create an updatable view that includes customerNumber, customerName, contactLastName, and contactFirstName from the customers table. 
create view customer_view as select customerNumber,customerName,contactLastName,contactFirstName from customers;
    --Updating the contactFirstName for a specific customerNumber.
update customer_view set contactFirstName = "NewFirstName" where customerNumber = 121;

-- 2.Read-Only View:
    --Create a read-only view that joins the orderdetails table and the products table on productCode and includes orderNumber, productName, and quantityOrdered. 
create view order_product_view as select od.orderNumber,p.productName,od.quantityOrdered from orderdetails od inner join products p on od.productCode = p.productCode;
    --Updating the quantityOrdered for a specific orderNumber.
update order_product_view set quantityOrdered = 40 where orderNumber = 10102;

-- 3.Inline View:
    --Write a query that uses an inline view to get the total number of orders for each customer. 
    --The inline view should select customerNumber and orderNumber from the orders table. The main query should then group by customerNumber.
select customerNumber,count(orderNumber) from (select customerNumber,orderNumber from orders) as inline_view group by customerNumber;

-- 4.Materialized View:
    --Note that MySQL does not natively support materialized views, but you can mimic them with a combination of stored procedures and triggers. 
    --The task here would be to create a stored procedure that creates a new table with productName and totalQuantityOrdered (this total should be aggregated from the orderdetails table).  
delimiter &
create procedure refresh_materialized_view()
    begin
    create table materialized_view as select p.productName,sum(od.quantityOrdered) as total_quantity_ordered from orderdetails od join products p on od.productCode = p.productCode group by p.productName;
    end &
    delimiter ;
    --Create an AFTER INSERT trigger on the orderdetails table that calls this stored procedure to update the table (acting as a materialized view) whenever a new order detail is inserted.
create trigger orderdetails_after_insert after insert on orderdetails for each row call refresh_materialized_view();