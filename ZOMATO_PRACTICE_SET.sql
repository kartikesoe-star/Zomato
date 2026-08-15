
-- Q1:- Find the total number of users who are Zomato Gold members (is_gold_member) 

WITH my_cte AS (
               SELECT 
                     user_id,
                     name,
                     city,
					 is_gold_member 
               FROM 
                     zomato.zomato_users
WHERE is_gold_member  = 1 ) 
SELECT
      user_id,
      name,
      city,
      is_gold_member AS 'Gold members' 
FROM 
      my_cte ;


-- Q2 ):- List all unique cuisine types available in the zomato_restaurants table, sorted alphabetically. 

SELECT 
      cuisine_type AS MENU 
FROM 
      zomato.zomato_restaurants 
GROUP BY 
      cuisine_type 
ORDER BY 
      cuisine_type;


-- q3 ):- Select the order_id, amount, and order_status for all orders where the total amount spent is greater than ₹1,000.

SELECT 
      order_id,
	  amount,
      order_status 
FROM 
      zomato.zomato_orders
where amount > 1000 ;


-- q4 ):- Write a query to find the total number of restaurants present in each city. 

SELECT 
      city , 
      COUNT(restaurant_name) AS TOTAL_restaurants  
FROM 
      zomato.zomato_restaurants 
GROUP BY 
	  city ;


-- q5 ):- Write a query to join zomato_users and zomato_orders to show the name of the user, their email, and their corresponding order_id.

SELECT 
      name ,
	  email,
      order_id 
FROM 
     zomato.zomato_orders AS O 
INNER JOIN zomato.zomato_users AS U
ON O.user_id = U.user_id ;
 
 
 
 -- medium 
 
 
 
-- q6 ):- Find the most frequently used payment_mode and the total revenue generated through that specific payment mode.

SELECT 
       payment_mode,
       round(sum(amount),2) AS total_revenue  
FROM 
	   zomato_orders 
WHERE payment_mode =  (SELECT 
                              payment_mode 
					   FROM 
                              zomato_orders 
					   WHERE order_status = 'Delivered' 
					   ORDER BY 
                                order_date DESC  
                                LIMIT 1)
 GROUP BY 
         payment_mode ;


-- q7 ) :- List all restaurants that have an average_cost_for_two higher than the overall average cost of all restaurants in the database.

SELECT restaurant_name,
       average_cost_for_two 
FROM 
      zomato.zomato_restaurants 
WHERE average_cost_for_two > ( SELECT AVG(average_cost_for_two) AS avg FROM zomato.zomato_restaurants ); 


-- q8 ):- Calculate the total number of orders placed and the total revenue generated for each month in the dataset.

WITH my_cte2 AS (
                SELECT DATE_FORMAT(order_date,'%Y-%m') AS order_date,
                       ROUND(SUM(amount),2) AS total_amount,
                       COUNT(order_id) AS total_orders 
                FROM 
                       zomato.zomato_orders  
                WHERE order_status = 'Delivered'
                GROUP BY
                        date_format(order_date,'%Y-%m')
				ORDER BY 
                        order_date DESC 
)
  
SELECT * FROM my_cte2 ;


-- q9 ):- Find the names and emails of users who left a review rating of 1 or 2 stars (zomato_reviews), along with their specific review_text.

SELECT name,
       email,
       rating,
       review_text 
FROM 
       zomato.zomato_users AS u1
INNER JOIN zomato.zomato_reviews AS r1
ON u1.user_id = r1.user_id 
WHERE rating <= 2 
ORDER BY 
        rating ;


-- q10 ):- Calculate the average delivery_time_mins for each city. Exclude orders that were Cancelled.

SELECT r2.city ,
       AVG(delivery_time_mins) AS AVG 
FROM 
       zomato.zomato_orders as o2
INNER JOIN zomato.zomato_restaurants as r2
ON o2.restaurant_id = r2.restaurant_id
WHERE order_status = 'Delivered' 
GROUP BY 
        r2.city ;



-- advance 



-- q11 ):- Find the user (name and city) who has spent the highest total amount on orders in their respective home city.
-- (Hint: Use DENSE_RANK() or ROW_NUMBER()).

WITH userspend AS (
SELECT u.name,
       u.city,
       sum(o.amount) AS total_spend ,
       DENSE_RANK() OVER(ORDER BY SUM(o.amount) DESC ) AS ranking  
FROM 
       zomato.zomato_users AS u
INNER JOIN zomato.zomato_orders AS o 
ON u.user_id = o.user_id 
INNER JOIN zomato.zomato_restaurants AS r
ON o.restaurant_id = r.restaurant_id
WHERE u.city = r.city 
GROUP BY 
        u.user_id,
        u.name,
        u.city
 )
SELECT 
      name , 
	  city , 
      total_spend 
FROM 
      userspend 
WHERE ranking = 1;


-- q12 ):- 2. Order Sequencing: Display every order ID, its order date, and the date of the previous order placed by that exact same user. 
-- (Hint: Use the LAG() window function).


SELECT o4.order_id,
       o4.order_date,
       u4.name,
       LAG(o4.order_date) OVER (PARTITION BY o4.user_id ORDER BY o4.order_date ) AS previous_order
FROM zomato.zomato_orders AS o4
JOIN zomato.zomato_users AS u4
ON o4.user_id = u4.user_id ;


-- q13 ):- 3. Restaurant Revenue Contribution: For each restaurant, display its name, city, total revenue, and 
-- the percentage contribution of that restaurant's revenue to its city's total revenue.


SELECT 
	  restaurant_name,
	  city ,
	  ROUND(SUM(amount),2) AS toatal ,
	  ROUND(SUM(amount)/SUM(SUM(amount)) OVER (PARTITION BY r6.city) * 100,2 ) AS percentage_city_revenue 
FROM 
       zomato.zomato_restaurants AS r6
INNER JOIN zomato.zomato_orders AS o6
ON r6.restaurant_id = o6.restaurant_id 
GROUP BY 
      r6.restaurant_name , r6.city 
ORDER BY
      city , 
      restaurant_name  ;


-- q14 ):- 4. Consistent Regulars: Identify users who have placed at least 3 orders within the exact same calendar month.

SELECT 
      user_id,
      DATE_FORMAT(order_date, '%Y-%m') AS calendar_month,
      COUNT(order_id) AS total_orders
FROM 
      zomato.zomato_orders 
GROUP BY 
      user_id, 
      DATE_FORMAT(order_date, '%Y-%m')
HAVING 
      COUNT(order_id) >= 3;


-- q15 ):- 5. Gold vs. Non-Gold Behavior: Compare the average order amount and
-- average delivery time between Zomato Gold members and non-Gold members.

WITH DRY AS (SELECT 'Gold' AS status,
 	   ROUND(AVG(o8.amount),2) AS avg_gold_amount ,
        ROUND(AVG(o8.delivery_time_mins),2) AS avg_delivery_time
FROM zomato.zomato_orders AS o8
INNER JOIN zomato.zomato_users AS u8
ON o8.user_id = u8.user_id
WHERE u8.is_gold_member = 1 AND o8.order_status = 'Delivered'
)
 ,
WET AS(SELECT 'non_gold' AS status,
      round(AVG(o9.amount),2) AS avg_amount_non_gold ,
      ROUND(AVG(o9.delivery_time_mins),2) AS avg_dilivered_time_non 
FROM 
      zomato.zomato_users AS u9
INNER JOIN zomato.zomato_orders AS o9
ON u9.user_id = o9.user_id
WHERE u9.is_gold_member = 0 
      AND 
      o9.order_status = 'Delivered')

SELECT 
      DRY.avg_gold_amount ,
      DRY.avg_delivery_time ,
      WET.avg_amount_non_gold ,
      WET.avg_dilivered_time_non
FROM 
      DRY,WET








