--- Create the initial unnormalized Orders table

CREATE TABLE orders (
	order_id SERIAL PRIMARY KEY,
	customer_name VARCHAR(100),
	customer_address VARCHAR(255),
	product_name VARCHAR(100),
	product_price NUMERIC(10, 2),
	quantity INT,
	order_date DATE
);

-- Insert sample data with redundancy
INSERT INTO orders (customer_name, customer_address, product_name, product_price, quantity, order_date) VALUES
('Alice', '123 Main St', 'Laptop', 1000.00, 1, '2024-11-01'),
('Bob', '456 Park Ave', 'Smartphone', 700.00, 2, '2024-11-02'),
('Alice', '123 Main St', 'Tablet', 300.00, 1, '2024-11-03'),
('Charlie', '789 Elm St', 'Laptop', 1000.00, 1, '2024-11-04'),
('Bob', '456 Park Ave', 'Tablet', 300.00, 2, '2024-11-05');

