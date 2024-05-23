-- 1. Write a query to find customers whose payments are greater than the average payment using a subquery.
select customernumber, checknumber, amount 
from payments 
where amount > (select avg(amount) from payments);

-- 2. Use a subquery with NOT IN operator to find the customers who have not placed any orders.
select customername 
from customers 
where customernumber not in (select customernumber from orders);

-- 3. Write a subquery that finds the maximum, minimum, and average number of items in sale orders from orderdetails.
select max(items), min(items), avg(items) 
from (select count(ordernumber) as items from orderdetails group by ordernumber) as derivedtable;

-- 4. Use a correlated subquery to select products whose buy prices are greater than the average buy price of all products in each product line.
select productname, buyprice 
from products 
where buyprice > (select avg(buyprice) from products);

-- 5. Write a query that finds sales orders whose total values are greater than 60K.
select ordernumber, sum(priceeach * quantityordered) as total 
from orderdetails 
inner join orders using (ordernumber) 
group by ordernumber 
having sum(priceeach * quantityordered) > 60000;

-- 6. Use the query in question no. 5 as a correlated subquery to find customers who placed at least one sales order with the total value greater than 60K by using the EXISTS operator.
select customernumber, customername 
from customers 
where exists (select ordernumber 
              from orderdetails 
              inner join orders using (ordernumber) 
              where customernumber = customers.customernumber 
              group by ordernumber 
              having sum(priceeach * quantityordered) > 60000);

-- 7. Write a query that gets the top five products by sales revenue in 2003 from the orders and orderdetails tables.
select productcode, sum(quantityordered * priceeach) as sales 
from orderdetails 
inner join orders using (ordernumber) 
where year(shippeddate) = 2003 
group by productcode 
order by sales desc 
limit 5;

-- 8. You can use the result of the previous query as a derived table called top5product2003 and join it with the products table using the productCode column. Then, find out the productName and sales of the top 5 products in 2003.
select productname, sales 
from (select productcode, sum(quantityordered * priceeach) as sales 
      from orderdetails 
      inner join orders using (ordernumber) 
      where year(shippeddate) = 2003 
      group by productcode 
      order by sales desc 
      limit 5) as top5product2003 
join products using (productcode);

-- 9. Suppose you have to label the customers who bought products in 2003 into 3 groups: platinum, gold, and silver with the following conditions:
-- Platinum customers who have orders with the volume greater than 100K.
-- Gold customers who have orders with the volume between 10K and 100K.
-- Silver customers who have orders with the volume less than 10K.
-- To form this query, you first need to put each customer into the respective group using CASE expression and GROUP BY to display the following:
select customernumber, sum(quantityordered * priceeach) as sales, 
       (case when (sum(quantityordered * priceeach)) > 100000 then 'Platinum' 
             when (sum(quantityordered * priceeach)) between 10000 and 100000 then 'Gold' 
             when (sum(quantityordered * priceeach)) < 10000 then 'Silver' 
        end) as customergroup 
from orderdetails 
inner join orders using (ordernumber) 
where year(shippeddate) = 2003 
group by customernumber 
order by customernumber;

-- 10. Use the previous query as the derived table to know the number of customers in each group: platinum, gold, and silver.
select customergroup, count(customergroup) as groupcount 
from (select customernumber, sum(quantityordered * priceeach) as sales, 
             (case when (sum(quantityordered * priceeach)) > 100000 then 'Platinum' 
                   when (sum(quantityordered * priceeach)) between 10000 and 100000 then 'Gold' 
                   when (sum(quantityordered * priceeach)) < 10000 then 'Silver' 
              end) as customergroup 
      from orderdetails 
      inner join orders using (ordernumber) 
      where year(shippeddate) = 2003 
      group by customernumber 
      order by customernumber) as derivedtable1 
group by customergroup;