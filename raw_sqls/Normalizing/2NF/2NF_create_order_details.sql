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
