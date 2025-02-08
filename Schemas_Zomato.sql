CREATE DATABASE zomato_db;

---Zomato Data Analysis Using SQL

-- Create customers table
DROP Table IF Exists customers
CREATE TABLE customers (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_name VARCHAR(25) NOT NULL,
    reg_date DATE
);
--Create restaurant Table
DROP Table IF EXISTS restaurants
CREATE TABLE restaurants (
    restaurant_id INT IDENTITY(1,1) PRIMARY KEY,
    restaurant_name VARCHAR(55) NOT NULL,
    city VARCHAR(15),
    opening_hours VARCHAR(55)
);

--Create Table Orders
DROP Table IF EXISTS Orders
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    order_item VARCHAR(55),
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    order_status VARCHAR(55) ,
    total_amount FLOAT NOT NULL);
  
  --Adding FK CONSTRAINT
  ALTER TABLE orders
  ADD CONSTRAINT fk_customers
  FOREIGN KEY (customer_id)
  REFERENCES customers(customer_id)

--Adding FK CONSTRAINT
ALTER TABLE orders
ADD CONSTRAINT fk_restaurants
FOREIGN KEY(restaurant_id)
REFERENCES restaurants(restaurant_id);

  -- Create riders table
  DROP TABLE IF EXISTS RIDERS
CREATE TABLE riders (
    rider_id INT IDENTITY(1,1) PRIMARY KEY,
    rider_name VARCHAR(55) NOT NULL,
    sign_up DATE
);
  
   -- Create deliveries table
   DROP TABLE IF EXISTS deliveries;
CREATE TABLE deliveries (
    delivery_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    delivery_status VARCHAR(35) DEFAULT 'Pending',
    delivery_time TIME,
    rider_id INT,
	CONSTRAINT fk_orders FOREIGN KEY (order_id ) REFERENCES orders(order_id),
	CONSTRAINT fk_riders FOREIGN KEY (rider_id ) REFERENCES riders(rider_id)
	);

