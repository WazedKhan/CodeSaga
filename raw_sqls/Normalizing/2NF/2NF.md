**Objective of 2NF**

To achieve **Second Normal Form**, we must:

1. **Eliminate Partial Dependency**: A table is in 2NF if it is in 1NF and **every non-key attribute is fully dependent on the entire primary key**.
2. **Remove attributes that do not depend on the primary key** in the case of composite keys.

---

### **Explanation with Our Example**

#### **Our Current Tables (After 1NF)**

1. **`Customers` Table**:| customer_id | customer_name | customer_address |
   | ----------- | ------------- | ---------------- |
   | 1           | Alice         | 123 Main St      |
   | 2           | Bob           | 456 Park Ave     |
   | 3           | Charlie       | 789 Elm St       |
2. **`Products` Table**:| product_id | product_name | product_price |
   | ---------- | ------------ | ------------- |
   | 1          | Laptop       | 1000.00       |
   | 2          | Smartphone   | 700.00        |
   | 3          | Tablet       | 300.00        |
3. **`Orders` Table**:| order_id | customer_id | product_id | quantity | order_date |
   | -------- | ----------- | ---------- | -------- | ---------- |
   | 1        | 1           | 1          | 1        | 2024-11-01 |
   | 2        | 2           | 2          | 2        | 2024-11-02 |
   | 3        | 1           | 3          | 1        | 2024-11-03 |
   | 4        | 3           | 1          | 1        | 2024-11-04 |
   | 5        | 2           | 3          | 2        | 2024-11-05 |

#### **Identifying Partial Dependency**

In our `Orders` table:

- The primary key is `order_id`, and there are no composite keys here, so the table already meets the condition for **2NF** since there are no non-key attributes that are only partially dependent on a subset of a composite key.

However, let's consider a more complex scenario to better illustrate **2NF** by adding a new table.

---

### **New Example: OrdersDetails Table**

Suppose we have a table called `OrderDetails` that initially looks like this:

| order_id | product_id | product_name | product_price | quantity |
| -------- | ---------- | ------------ | ------------- | -------- |
| 1        | 1          | Laptop       | 1000.00       | 1        |
| 2        | 2          | Smartphone   | 700.00        | 2        |
| 3        | 3          | Tablet       | 300.00        | 1        |
| 4        | 1          | Laptop       | 1000.00       | 1        |
| 5        | 3          | Tablet       | 300.00        | 2        |

#### **Identifying Partial Dependency**

In the `OrderDetails` table:

- The primary key is the combination of `order_id` and `product_id`.
- The attributes `product_name` and `product_price` depend only on `product_id` and **not** on the combination of `order_id` and `product_id`.

This means `product_name` and `product_price` are **partially dependent** on the composite primary key, violating **2NF**.

---

### **Steps to Achieve 2NF**

1. **Separate the partially dependent attributes into a new table.**
2. **Create relationships to maintain data integrity.**

#### **Normalization Steps**

1. **Create a new `Products` Table (if it didn't already exist):**

   ```sql
   CREATE TABLE products (
       product_id SERIAL PRIMARY KEY,
       product_name VARCHAR(100) NOT NULL,
       product_price NUMERIC(10, 2) NOT NULL
   );

   -- Insert unique product data
   INSERT INTO products (product_id, product_name, product_price) VALUES
   (1, 'Laptop', 1000.00),
   (2, 'Smartphone', 700.00),
   (3, 'Tablet', 300.00);
   ```
2. **Update the `OrderDetails` Table:**

   ```sql
   CREATE TABLE order_details (
       order_id INT NOT NULL,
       product_id INT NOT NULL,
       quantity INT,
       PRIMARY KEY (order_id, product_id),
       FOREIGN KEY (product_id) REFERENCES products(product_id)
   );

   -- Insert normalized data into OrderDetails table
   INSERT INTO order_details (order_id, product_id, quantity) VALUES
   (1, 1, 1), -- Order 1 contains Laptop
   (2, 2, 2), -- Order 2 contains Smartphone
   (3, 3, 1), -- Order 3 contains Tablet
   (4, 1, 1), -- Order 4 contains Laptop
   (5, 3, 2); -- Order 5 contains Tablet
   ```

---

### **Resulting Tables (After 2NF)**

1. **`Products` Table**:| product_id | product_name | product_price |
   | ---------- | ------------ | ------------- |
   | 1          | Laptop       | 1000.00       |
   | 2          | Smartphone   | 700.00        |
   | 3          | Tablet       | 300.00        |
2. **`OrderDetails` Table**:| order_id | product_id | quantity |
   | -------- | ---------- | -------- |
   | 1        | 1          | 1        |
   | 2        | 2          | 2        |
   | 3        | 3          | 1        |
   | 4        | 1          | 1        |
   | 5        | 3          | 2        |

---

### **Benefits Achieved by 2NF**

1. **Eliminated Partial Dependencies**: `product_name` and `product_price` are now stored only in the `Products` table, reducing data redundancy.
2. **Improved Data Integrity**: Any changes to product details (e.g., changing the price of a product) need to be made in one place (the `Products` table), ensuring consistency across all orders.


### **Cons of Achieving 2NF**

1. **Increased Complexity in Queries**

   - As we normalize data across multiple tables, **queries become more complex**. This is because information that was previously in a single table is now spread across multiple related tables. Retrieving data often involves performing **joins** across tables, which can increase query complexity and decrease readability.
   - For example, to retrieve an order’s details including product information, we now need to join `OrderDetails` and `Products` instead of querying a single table.

   ```sql
   SELECT od.order_id, p.product_name, p.product_price, od.quantity
   FROM order_details od
   JOIN products p ON od.product_id = p.product_id
   WHERE od.order_id = 1;
   ```

   This query is more complex than simply fetching all the data from a denormalized `OrderDetails` table.
2. **Potential Performance Impact**

   - **Joins are computationally expensive**, especially when tables grow in size or when you have to join multiple tables to get a complete view of data.
   - This can lead to a decrease in **response time** for read-heavy operations where many users or processes are requesting data simultaneously.
   - Database indexing and optimization strategies can mitigate some of this impact, but it introduces further complexity to database management.
3. **Data Access Latency**

   - When data is distributed across different tables, every data retrieval operation may involve **accessing multiple disk locations** (if data isn't fully cached). This can increase data access latency for queries compared to a denormalized structure where all required data may be stored together.
   - For applications that require **very fast reads** with low latency, normalization might introduce unwanted delays.
4. **Difficulty in Understanding Data Models**

   - For some teams or projects, normalized databases can be **harder to understand and work with**, especially if you have many tables with complex relationships.
   - Training new team members or getting them up to speed with a highly normalized database can take longer, leading to potential slowdowns in development and data access improvements.
5. **Write Performance Considerations**

   - **Writing data to normalized tables** often involves more operations compared to a denormalized structure. This is because related data may need to be updated across multiple tables, especially if there are `INSERT`, `UPDATE`, or `DELETE` operations.
   - For example, when adding a new product, you may need to ensure consistency across both `Products` and any `OrderDetails` references.

---

### **Trade-offs and Real-World Considerations**

- In some applications, **denormalization** is used in **read-heavy** environments to reduce response time, minimize joins, and simplify query complexity. This can be common in **data warehouses, analytics systems, and caching layers**.
- However, for systems requiring **data consistency** and **integrity**, normalization (such as achieving 2NF) is usually preferred.

### **Balancing Normalization and Performance**

In practice, database design often involves **striking a balance** between normalization and denormalization:

- For critical data that must remain **accurate and consistent**, normalization is essential.
- For data that is accessed frequently and needs to be quickly retrieved, denormalization or creating **read-optimized views or tables** can be more beneficial.

This balance ensures that we leverage the strengths of both approaches, depending on the needs of the application. For example, we might have a normalized database for transactional data but use **materialized views** or **caching strategies** for commonly accessed queries.
