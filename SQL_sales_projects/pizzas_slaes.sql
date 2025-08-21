----Retrieve the total number of orders placed.----
select count(order_id) as total_orders from orders;

----Calculate the total revenue generated from pizza sales.-----
SELECT  ROUND(SUM(order_details.quantity * pizzas.price),2) AS total_revenue
FROM order_details JOIN 
pizzas ON pizzas.pizza_id = order_details.pizza_id;

----Identify the highest-priced pizza.
select pizza_types.name,pizzas.price
from pizza_types,pizzas
where
pizza_types.pizza_type_id=pizzas.pizza_type_id
order by pizzas.price desc
limit 1;

----Identify the most common pizza size ordered.
select pizzas.size,count(order_details.pizza_id) from pizzas
join order_details on
pizzas.pizza_id=order_details.pizza_id
group by pizzas.size;

----List the top 5 most ordered pizza types along with their quantities.
select pizza_types.name,sum(order_details.quantity) as quantity from pizza_types join 
pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id join 
order_details on order_details.pizza_id = pizzas.pizza_id 
group by 
pizza_types.name order by quantity desc
limit 5;


-- Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category,sum(order_details.quantity) as quantity from pizza_types join
pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id join
order_details on 
order_details.pizza_id=pizzas.pizza_id
group by 
pizza_types.category order by quantity desc;


-- Determine the distribution of orders by hour of the day.
 select hour(order_time),count(order_id) from orders group by hour(order_time);

-- Join relevant tables to find the category-wise distribution of pizzas.
select category,count(pizza_type_id) as t from 
pizza_types group by category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(quantity),2) from (select orders.order_date,sum(order_details.quantity) as quantity from 
orders join order_details on orders.order_id=order_details.order_id
group by 
order_date) as order_quantity;

-- Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name,sum(order_details.quantity * pizzas.price) as revenue from pizza_types join
pizzas on pizzas.pizza_type_id=pizza_types.pizza_type_id join
order_details on order_details.pizza_id=pizzas.pizza_id
group by 
pizza_types.name order by revenue desc limit 3;


-- Calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.category,round((sum(order_details.quantity * pizzas.price) / 
(select sum(order_details.quantity*pizzas.price) from order_details join
 pizzas on order_details.pizza_id=pizzas.pizza_id)*100),2) as total_sales
 from pizza_types join
pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id join 
order_details on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT name,revenue from(SELECT category, name,
        revenue ,rank() over(partitiON by category ORDER BY  revenue desc) AS rn 
from
(SELECT pizza_types.category,
        pizza_types.name,
        sum(order_details.quantity * pizzas.price) AS revenue
    FROM pizza_types join
pizzas
    ON pizza_types.pizza_type_id=pizzas.pizza_type_id
JOIN order_details 
ON order_details.pizza_id=pizzas.pizza_id 
GROUP BY pizza_types.category,pizza_types.name) AS a) AS b
WHERE rn<3 limit 3;