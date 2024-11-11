### For  **First Normal Form (1NF)** , our main goal was to ensure that:

1. **All columns contain only atomic values (no repeating groups or arrays).**
2. **Each row remains unique and identifiable.**

### **Actions Taken for 1NF:**

1. **Separated data into related tables** : We created distinct tables for `Customers` and `Products`, removing redundant data that was previously stored in the `Orders` table.
2. **Ensured atomicity of data** : In the original `Orders` table, customer and product data were repeated across rows, leading to data redundancy. By splitting this data, we ensured that each column in the `Orders` table contains atomic values — for example, `customer_id` and `product_id` reference singular, unique customer and product data.
3. **Eliminated duplicate data** : Previously, customer and product information was repeated multiple times for different orders. After normalizing, each customer and product only exists once, and we use `customer_id` and `product_id` as references in the `Orders` table.

**Summary of 1NF Changes:**

* **Unnormalized `Orders` Table** : Stored customer name, address, product name, price, etc., redundantly in each row.
* **Normalized** :
* **`Customers` Table** with unique customer data (e.g., `customer_id`, `customer_name`, `customer_address`).
* **`Products` Table** with unique product data (e.g., `product_id`, `product_name`, `product_price`).
* **`Orders` Table** references customers and products using `customer_id` and `product_id`, ensuring atomic values for all fields.

This initial normalization helps lay the foundation for better data integrity, consistency, and reduced redundancy in the database. Would you like to explore the next steps in normalization?

---

### **Unnormalized `Orders` Table (Before 1NF)**

Here's an example of how our unnormalized `Orders` table looked:

| order_id | customer_name | customer_address | product_name | product_price | quantity | order_date |
| -------- | ------------- | ---------------- | ------------ | ------------- | -------- | ---------- |
| 1        | Alice         | 123 Main St      | Laptop       | 1000.00       | 1        | 2024-11-01 |
| 2        | Bob           | 456 Park Ave     | Smartphone   | 700.00        | 2        | 2024-11-02 |
| 3        | Alice         | 123 Main St      | Tablet       | 300.00        | 1        | 2024-11-03 |
| 4        | Charlie       | 789 Elm St       | Laptop       | 1000.00       | 1        | 2024-11-04 |
| 5        | Bob           | 456 Park Ave     | Tablet       | 300.00        | 2        | 2024-11-05 |

### **Issues with the Unnormalized Table**

1. **Data Redundancy**: Customer names, addresses, and product details are repeated across multiple rows.
2. **Data Inconsistency**: If `Alice` moves to a new address, we would need to update all rows where `Alice` appears, risking data inconsistency.
3. **Insertion Anomalies**: Adding a new order requires inserting all customer and product details again, even if they already exist.
4. **Deletion Anomalies**: Deleting an order might accidentally delete important customer or product information.

---

### **Steps Taken to Achieve 1NF**

1. **Created a `Customers` Table**:We moved the customer data to a separate table and assigned a unique `customer_id` to each customer.

   ```sql
   -- Create Customers table
   CREATE TABLE customers (
       customer_id SERIAL PRIMARY KEY,
       customer_name VARCHAR(100) NOT NULL,
       customer_address VARCHAR(255)
   );

   -- Insert unique customer data
   INSERT INTO customers (customer_name, customer_address) VALUES
   ('Alice', '123 Main St'),
   ('Bob', '456 Park Ave'),
   ('Charlie', '789 Elm St');
   ```

   **Resulting `Customers` Table**:

   | customer_id | customer_name | customer_address |
   | ----------- | ------------- | ---------------- |
   | 1           | Alice         | 123 Main St      |
   | 2           | Bob           | 456 Park Ave     |
   | 3           | Charlie       | 789 Elm St       |
2. **Created a `Products` Table**:We moved the product data to a separate table and assigned a unique `product_id` to each product.

   ```sql
   -- Create Products table
   CREATE TABLE products (
       product_id SERIAL PRIMARY KEY,
       product_name VARCHAR(100) NOT NULL,
       product_price NUMERIC(10, 2) NOT NULL
   );

   -- Insert unique product data
   INSERT INTO products (product_name, product_price) VALUES
   ('Laptop', 1000.00),
   ('Smartphone', 700.00),
   ('Tablet', 300.00);
   ```

   **Resulting `Products` Table**:

   | product_id | product_name | product_price |
   | ---------- | ------------ | ------------- |
   | 1          | Laptop       | 1000.00       |
   | 2          | Smartphone   | 700.00        |
   | 3          | Tablet       | 300.00        |
3. **Updated the `Orders` Table**:
   We modified the `Orders` table to reference customers and products using `customer_id` and `product_id`, thereby eliminating redundant data.

   ```sql
   -- Create new Orders table with references to Customers and Products
   CREATE TABLE orders_normalized (
       order_id SERIAL PRIMARY KEY,
       customer_id INT NOT NULL,
       product_id INT NOT NULL,
       quantity INT,
       order_date DATE,
       FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
       FOREIGN KEY (product_id) REFERENCES products(product_id)
   );

   -- Insert normalized data into Orders table
   INSERT INTO orders_normalized (customer_id, product_id, quantity, order_date) VALUES
   (1, 1, 1, '2024-11-01'), -- Alice ordered Laptop
   (2, 2, 2, '2024-11-02'), -- Bob ordered Smartphone
   (1, 3, 1, '2024-11-03'), -- Alice ordered Tablet
   (3, 1, 1, '2024-11-04'), -- Charlie ordered Laptop
   (2, 3, 2, '2024-11-05'); -- Bob ordered Tablet
   ```

   **Resulting `Orders` Table (Normalized)**:

   | order_id | customer_id | product_id | quantity | order_date |
   | -------- | ----------- | ---------- | -------- | ---------- |
   | 1        | 1           | 1          | 1        | 2024-11-01 |
   | 2        | 2           | 2          | 2        | 2024-11-02 |
   | 3        | 1           | 3          | 1        | 2024-11-03 |
   | 4        | 3           | 1          | 1        | 2024-11-04 |
   | 5        | 2           | 3          | 2        | 2024-11-05 |

---

### **Benefits of 1NF Achieved**

1. **Reduced Data Redundancy**: Customer and product data are now stored once, avoiding duplication.
2. **Improved Data Integrity**: Updates to customer or product details only need to be made in their respective tables.
3. **Easier Maintenance**: Changes, deletions, and additions of orders, customers, or products are more efficient.

This practical step of achieving 1NF sets the stage for further normalization (like 2NF and 3NF). Would you like to move forward with these additional normalization steps?
