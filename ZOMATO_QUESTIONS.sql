🟢 
  5 Basic Questions (Filters, Aggregations & Joins)
1. Gold Member Count: Find the total number of users who are Zomato Gold members (is_gold_member).
2. Top Cuisines: List all unique cuisine types available in the zomato_restaurants table, sorted alphabetically.
3. High-Value Orders: Select the order_id, amount, and order_status for all orders where the total amount spent is greater than ₹1,000.
4. City-Wise Restaurants: Write a query to find the total number of restaurants present in each city.
5. User Order History: Write a query to join zomato_users and zomato_orders to show the name of the user, their email, and their corresponding order_id.

🟡 
   5 Medium Questions (Grouping, Subqueries & Date Functions)
1. Popular Payment Methods: Find the most frequently used payment_mode and the total revenue generated through that specific payment mode.
2. Average Costly Dining: List all restaurants that have an average_cost_for_two higher than the overall average cost of all restaurants in the database.
3. Monthly Order Trends: Calculate the total number of orders placed and the total revenue generated for each month in the dataset.
4. Disgruntled Customers: Find the names and emails of users who left a review rating of 1 or 2 stars (zomato_reviews), along with their specific review_text.
5. Delivery Efficiency: Calculate the average delivery_time_mins for each city. Exclude orders that were Cancelled. [1]

🔴 
   5 Advanced (but Accessible) Questions (Window Functions & Complex Joins)
1. Top Spender in Each City: Find the user (name and city) who has spent the highest total amount on orders in their respective home city. (Hint: Use DENSE_RANK() or ROW_NUMBER()).
2. Order Sequencing: Display every order ID, its order date, and the date of the previous order placed by that exact same user. (Hint: Use the LAG() window function).
3. Restaurant Revenue Contribution: For each restaurant, display its name, city, total revenue, and the percentage contribution of that restaurant's revenue to its city's total revenue.
4. Consistent Regulars: Identify users who have placed at least 3 orders within the exact same calendar month.
5. Gold vs. Non-Gold Behavior: Compare the average order amount and average delivery time between Zomato Gold members and non-Gold members.
