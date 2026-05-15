INSERT INTO northwind.categories (category_id, category_name, description) VALUES
    (1, 'Beverages', 'Soft drinks, coffees, teas, beers, and ales'),
    (2, 'Condiments', 'Sweet and savory sauces, relishes, spreads, and seasonings'),
    (3, 'Confections', 'Desserts, candies, and sweet breads'),
    (4, 'Dairy Products', 'Cheeses'),
    (5, 'Grains/Cereals', 'Breads, crackers, pasta, and cereal'),
    (6, 'Meat/Poultry', 'Prepared meats'),
    (7, 'Produce', 'Dried fruit and bean curd'),
    (8, 'Seafood', 'Seaweed and fish')
ON CONFLICT (category_id) DO NOTHING;

INSERT INTO northwind.suppliers (
    supplier_id, company_name, contact_name, contact_title, city, region, country, phone
) VALUES
    (1, 'Exotic Liquids', 'Charlotte Cooper', 'Purchasing Manager', 'London', NULL, 'UK', '(171) 555-2222'),
    (2, 'New Orleans Cajun Delights', 'Shelley Burke', 'Order Administrator', 'New Orleans', 'LA', 'USA', '(100) 555-4822'),
    (3, 'Grandma Kelly''s Homestead', 'Regina Murphy', 'Sales Representative', 'Ann Arbor', 'MI', 'USA', '(313) 555-5735'),
    (4, 'Tokyo Traders', 'Yoshi Nagase', 'Marketing Manager', 'Tokyo', NULL, 'Japan', '(03) 3555-5011'),
    (5, 'Cooperativa de Quesos Las Cabras', 'Antonio del Valle Saavedra', 'Export Administrator', 'Oviedo', 'Asturias', 'Spain', '(98) 598 76 54'),
    (6, 'Pavlova, Ltd.', 'Ian Devling', 'Marketing Representative', 'Melbourne', 'Victoria', 'Australia', '(03) 444-2343'),
    (7, 'Specialty Biscuits, Ltd.', 'Peter Wilson', 'Sales Representative', 'Manchester', NULL, 'UK', '(161) 555-4448'),
    (8, 'Bigfoot Breweries', 'Cheryl Saylor', 'Regional Account Rep.', 'Bend', 'OR', 'USA', '(503) 555-9931'),
    (9, 'Nord-Ost-Fisch Handelsgesellschaft mbH', 'Sven Petersen', 'Coordinator Foreign Markets', 'Cuxhaven', NULL, 'Germany', '(04721) 8713')
ON CONFLICT (supplier_id) DO NOTHING;

INSERT INTO northwind.customers (
    customer_id, company_name, contact_name, contact_title, city, region, country, phone, fax
) VALUES
    ('ALFKI', 'Alfreds Futterkiste', 'Maria Anders', 'Sales Representative', 'Berlin', NULL, 'Germany', '030-0074321', '030-0076545'),
    ('ANATR', 'Ana Trujillo Emparedados y helados', 'Ana Trujillo', 'Owner', 'Mexico D.F.', NULL, 'Mexico', '(5) 555-4729', '(5) 555-3745'),
    ('AROUT', 'Around the Horn', 'Thomas Hardy', 'Sales Representative', 'London', NULL, 'UK', '(171) 555-7788', '(171) 555-6750'),
    ('BERGS', 'Berglunds snabbkop', 'Christina Berglund', 'Order Administrator', 'Lulea', NULL, 'Sweden', '0921-12 34 65', '0921-12 34 67'),
    ('BLONP', 'Blondesddsl pere et fils', 'Frederique Citeaux', 'Marketing Manager', 'Strasbourg', NULL, 'France', '88.60.15.31', '88.60.15.32'),
    ('BONAP', 'Bon app''', 'Laurence Lebihan', 'Owner', 'Marseille', NULL, 'France', '91.24.45.40', '91.24.45.41'),
    ('BOTTM', 'Bottom-Dollar Markets', 'Elizabeth Lincoln', 'Accounting Manager', 'Tsawassen', 'BC', 'Canada', '(604) 555-4729', '(604) 555-3745'),
    ('CHOPS', 'Chop-suey Chinese', 'Yang Wang', 'Owner', 'Bern', NULL, 'Switzerland', '0452-076545', NULL),
    ('ERNSH', 'Ernst Handel', 'Roland Mendel', 'Sales Manager', 'Graz', NULL, 'Austria', '7675-3425', '7675-3426'),
    ('FRANK', 'Frankenversand', 'Peter Franken', 'Marketing Manager', 'Munchen', NULL, 'Germany', '089-0877310', '089-0877451'),
    ('HUNGO', 'Hungry Owl All-Night Grocers', 'Patricia McKenna', 'Sales Associate', 'Cork', 'Co. Cork', 'Ireland', '2967 542', '2967 3333'),
    ('QUICK', 'QUICK-Stop', 'Horst Kloss', 'Accounting Manager', 'Cunewalde', NULL, 'Germany', '0372-035188', NULL),
    ('SAVEA', 'Save-a-lot Markets', 'Jose Pavarotti', 'Sales Representative', 'Boise', 'ID', 'USA', '(208) 555-8097', NULL),
    ('WOLZA', 'Wolski Zajazd', 'Zbyszek Piestrzeniewicz', 'Owner', 'Warszawa', NULL, 'Poland', '(26) 642-7012', '(26) 642-7012')
ON CONFLICT (customer_id) DO NOTHING;

INSERT INTO northwind.employees (
    employee_id, last_name, first_name, title, title_of_courtesy, birth_date, hire_date, city, region, country, reports_to
) VALUES
    (1, 'Davolio', 'Nancy', 'Sales Representative', 'Ms.', '1948-12-08', '1992-05-01', 'Seattle', 'WA', 'USA', NULL),
    (2, 'Fuller', 'Andrew', 'Vice President, Sales', 'Dr.', '1952-02-19', '1992-08-14', 'Tacoma', 'WA', 'USA', NULL),
    (3, 'Leverling', 'Janet', 'Sales Representative', 'Ms.', '1963-08-30', '1992-04-01', 'Kirkland', 'WA', 'USA', 2),
    (4, 'Peacock', 'Margaret', 'Sales Representative', 'Mrs.', '1937-09-19', '1993-05-03', 'Redmond', 'WA', 'USA', 2),
    (5, 'Buchanan', 'Steven', 'Sales Manager', 'Mr.', '1955-03-04', '1993-10-17', 'London', NULL, 'UK', 2),
    (6, 'Suyama', 'Michael', 'Sales Representative', 'Mr.', '1963-07-02', '1993-10-17', 'London', NULL, 'UK', 5),
    (7, 'King', 'Robert', 'Sales Representative', 'Mr.', '1960-05-29', '1994-01-02', 'London', NULL, 'UK', 5),
    (8, 'Callahan', 'Laura', 'Inside Sales Coordinator', 'Ms.', '1958-01-09', '1994-03-05', 'Seattle', 'WA', 'USA', 2),
    (9, 'Dodsworth', 'Anne', 'Sales Representative', 'Ms.', '1966-01-27', '1994-11-15', 'London', NULL, 'UK', 5)
ON CONFLICT (employee_id) DO NOTHING;

INSERT INTO northwind.shippers (shipper_id, company_name, phone) VALUES
    (1, 'Speedy Express', '(503) 555-9831'),
    (2, 'United Package', '(503) 555-3199'),
    (3, 'Federal Shipping', '(503) 555-9931')
ON CONFLICT (shipper_id) DO NOTHING;

INSERT INTO northwind.products (
    product_id, product_name, supplier_id, category_id, quantity_per_unit, unit_price,
    units_in_stock, units_on_order, reorder_level, discontinued
) VALUES
    (1, 'Chai', 1, 1, '10 boxes x 20 bags', 18.00, 39, 0, 10, FALSE),
    (2, 'Chang', 1, 1, '24 - 12 oz bottles', 19.00, 17, 40, 25, FALSE),
    (3, 'Aniseed Syrup', 1, 2, '12 - 550 ml bottles', 10.00, 13, 70, 25, FALSE),
    (4, 'Chef Anton''s Cajun Seasoning', 2, 2, '48 - 6 oz jars', 22.00, 53, 0, 0, FALSE),
    (5, 'Chef Anton''s Gumbo Mix', 2, 2, '36 boxes', 21.35, 0, 0, 0, TRUE),
    (6, 'Grandma''s Boysenberry Spread', 3, 2, '12 - 8 oz jars', 25.00, 120, 0, 25, FALSE),
    (7, 'Uncle Bob''s Organic Dried Pears', 3, 7, '12 - 1 lb pkgs.', 30.00, 15, 0, 10, FALSE),
    (8, 'Northwoods Cranberry Sauce', 3, 2, '12 - 12 oz jars', 40.00, 6, 0, 0, FALSE),
    (9, 'Mishi Kobe Niku', 4, 6, '18 - 500 g pkgs.', 97.00, 29, 0, 0, TRUE),
    (10, 'Ikura', 4, 8, '12 - 200 ml jars', 31.00, 31, 0, 0, FALSE),
    (11, 'Queso Cabrales', 5, 4, '1 kg pkg.', 21.00, 22, 30, 30, FALSE),
    (12, 'Queso Manchego La Pastora', 5, 4, '10 - 500 g pkgs.', 38.00, 86, 0, 0, FALSE),
    (16, 'Pavlova', 6, 3, '32 - 500 g boxes', 17.45, 29, 0, 10, FALSE),
    (17, 'Alice Mutton', 6, 6, '20 - 1 kg tins', 39.00, 0, 0, 0, TRUE),
    (19, 'Teatime Chocolate Biscuits', 7, 3, '10 boxes x 12 pieces', 9.20, 25, 0, 5, FALSE),
    (20, 'Sir Rodney''s Marmalade', 7, 3, '30 gift boxes', 81.00, 40, 0, 0, FALSE),
    (34, 'Sasquatch Ale', 8, 1, '24 - 12 oz bottles', 14.00, 111, 0, 15, FALSE),
    (35, 'Steeleye Stout', 8, 1, '24 - 12 oz bottles', 18.00, 20, 0, 15, FALSE),
    (36, 'Inlagd Sill', 9, 8, '24 - 250 g jars', 19.00, 112, 0, 20, FALSE),
    (37, 'Gravad lax', 9, 8, '12 - 500 g pkgs.', 26.00, 11, 50, 25, FALSE)
ON CONFLICT (product_id) DO NOTHING;

-- Additional referenced rows keep this seed compact while preserving realistic joins.
INSERT INTO northwind.customers (customer_id, company_name, contact_name, city, region, country) VALUES
    ('TOMSP', 'Toms Spezialitaten', 'Karin Josephs', 'Munster', NULL, 'Germany'),
    ('HANAR', 'Hanari Carnes', 'Mario Pontes', 'Rio de Janeiro', 'RJ', 'Brazil'),
    ('VICTE', 'Victuailles en stock', 'Mary Saveley', 'Lyon', NULL, 'France'),
    ('SUPRD', 'Supremes delices', 'Pascale Cartrain', 'Charleroi', NULL, 'Belgium'),
    ('RICSU', 'Richter Supermarkt', 'Michael Holz', 'Geneve', NULL, 'Switzerland'),
    ('LINOD', 'LINO-Delicateses', 'Felipe Izquierdo', 'I. de Margarita', 'Nueva Esparta', 'Venezuela')
ON CONFLICT (customer_id) DO NOTHING;

INSERT INTO northwind.products (
    product_id, product_name, supplier_id, category_id, quantity_per_unit, unit_price,
    units_in_stock, units_on_order, reorder_level, discontinued
) VALUES
    (24, 'Guarana Fantastica', 1, 1, '12 - 355 ml cans', 4.50, 20, 0, 0, TRUE),
    (28, 'Rassle Sauerkraut', 7, 7, '25 - 825 g cans', 45.60, 26, 0, 0, TRUE),
    (31, 'Gorgonzola Telino', 5, 4, '12 - 100 g pkgs', 12.50, 0, 70, 20, FALSE),
    (58, 'Escargots de Bourgogne', 6, 8, '24 pieces', 13.25, 62, 0, 20, FALSE),
    (59, 'Raclette Courdavault', 5, 4, '5 kg pkg.', 55.00, 79, 0, 0, FALSE),
    (63, 'Vegie-spread', 6, 2, '15 - 625 g jars', 43.90, 24, 0, 5, FALSE)
ON CONFLICT (product_id) DO NOTHING;

INSERT INTO northwind.orders (
    order_id, customer_id, employee_id, order_date, required_date, shipped_date,
    ship_via, freight, ship_name, ship_city, ship_region, ship_country
) VALUES
    (10248, 'WOLZA', 5, '1996-07-04', '1996-08-01', '1996-07-16', 3, 32.38, 'Wolski Zajazd', 'Warszawa', NULL, 'Poland'),
    (10249, 'TOMSP', 6, '1996-07-05', '1996-08-16', '1996-07-10', 1, 11.61, 'Toms Spezialitaten', 'Munster', NULL, 'Germany'),
    (10250, 'HANAR', 4, '1996-07-08', '1996-08-05', '1996-07-12', 2, 65.83, 'Hanari Carnes', 'Rio de Janeiro', 'RJ', 'Brazil'),
    (10251, 'VICTE', 3, '1996-07-08', '1996-08-05', '1996-07-15', 1, 41.34, 'Victuailles en stock', 'Lyon', NULL, 'France'),
    (10252, 'SUPRD', 4, '1996-07-09', '1996-08-06', '1996-07-11', 2, 51.30, 'Supremes delices', 'Charleroi', NULL, 'Belgium'),
    (10253, 'HANAR', 3, '1996-07-10', '1996-07-24', '1996-07-16', 2, 58.17, 'Hanari Carnes', 'Rio de Janeiro', 'RJ', 'Brazil'),
    (10254, 'CHOPS', 5, '1996-07-11', '1996-08-08', '1996-07-23', 2, 22.98, 'Chop-suey Chinese', 'Bern', NULL, 'Switzerland'),
    (10255, 'RICSU', 9, '1996-07-12', '1996-08-09', '1996-07-15', 3, 148.33, 'Richter Supermarkt', 'Geneve', NULL, 'Switzerland'),
    (10335, 'HUNGO', 7, '1996-11-15', '1996-12-13', '1996-11-21', 2, 42.11, 'Hungry Owl All-Night Grocers', 'Cork', 'Co. Cork', 'Ireland'),
    (10360, 'BLONP', 4, '1996-11-22', '1996-12-20', '1996-12-02', 3, 131.70, 'Blondesddsl pere et fils', 'Strasbourg', NULL, 'France'),
    (10400, 'ERNSH', 1, '1997-01-01', '1997-01-29', '1997-01-16', 3, 83.93, 'Ernst Handel', 'Graz', NULL, 'Austria'),
    (10420, 'WOLZA', 3, '1997-01-21', '1997-02-18', '1997-01-27', 1, 44.12, 'Wolski Zajazd', 'Warszawa', NULL, 'Poland'),
    (10485, 'LINOD', 4, '1997-03-25', '1997-04-22', '1997-03-31', 2, 64.45, 'LINO-Delicateses', 'I. de Margarita', 'Nueva Esparta', 'Venezuela'),
    (10515, 'QUICK', 2, '1997-04-23', '1997-05-07', '1997-05-23', 1, 204.47, 'QUICK-Stop', 'Cunewalde', NULL, 'Germany'),
    (10540, 'QUICK', 3, '1997-05-19', '1997-06-16', '1997-06-13', 3, 100.97, 'QUICK-Stop', 'Cunewalde', NULL, 'Germany'),
    (10643, 'ALFKI', 6, '1997-08-25', '1997-09-22', '1997-09-02', 1, 29.46, 'Alfreds Futterkiste', 'Berlin', NULL, 'Germany'),
    (10692, 'ALFKI', 4, '1997-10-03', '1997-10-31', '1997-10-13', 2, 61.02, 'Alfreds Futterkiste', 'Berlin', NULL, 'Germany'),
    (10702, 'ALFKI', 4, '1997-10-13', '1997-11-24', '1997-10-21', 1, 23.94, 'Alfreds Futterkiste', 'Berlin', NULL, 'Germany'),
    (10835, 'ALFKI', 1, '1998-01-15', '1998-02-12', '1998-01-21', 3, 69.53, 'Alfreds Futterkiste', 'Berlin', NULL, 'Germany'),
    (10952, 'ALFKI', 1, '1998-03-16', '1998-04-27', '1998-03-24', 1, 40.42, 'Alfreds Futterkiste', 'Berlin', NULL, 'Germany'),
    (11011, 'ALFKI', 3, '1998-04-09', '1998-05-07', '1998-04-13', 1, 1.21, 'Alfreds Futterkiste', 'Berlin', NULL, 'Germany')
ON CONFLICT (order_id) DO NOTHING;

INSERT INTO northwind.order_details (order_id, product_id, unit_price, quantity, discount) VALUES
    (10248, 11, 14.00, 12, 0.000),
    (10248, 16, 9.80, 10, 0.000),
    (10248, 37, 26.00, 5, 0.000),
    (10249, 2, 19.00, 9, 0.000),
    (10249, 3, 10.00, 10, 0.000),
    (10250, 4, 22.00, 35, 0.150),
    (10250, 7, 30.00, 15, 0.150),
    (10250, 11, 21.00, 25, 0.000),
    (10251, 2, 19.00, 6, 0.050),
    (10251, 16, 17.45, 15, 0.050),
    (10251, 35, 18.00, 20, 0.000),
    (10252, 20, 81.00, 40, 0.050),
    (10252, 36, 19.00, 25, 0.050),
    (10253, 31, 12.50, 20, 0.000),
    (10254, 24, 4.50, 15, 0.150),
    (10255, 2, 19.00, 20, 0.000),
    (10335, 2, 19.00, 7, 0.200),
    (10335, 11, 21.00, 12, 0.000),
    (10360, 34, 14.00, 10, 0.000),
    (10360, 35, 18.00, 30, 0.100),
    (10400, 1, 18.00, 21, 0.000),
    (10400, 35, 18.00, 35, 0.000),
    (10420, 9, 97.00, 20, 0.100),
    (10420, 16, 17.45, 20, 0.000),
    (10485, 11, 21.00, 20, 0.000),
    (10485, 37, 26.00, 12, 0.000),
    (10515, 2, 19.00, 50, 0.000),
    (10515, 11, 21.00, 20, 0.000),
    (10540, 3, 10.00, 60, 0.000),
    (10540, 20, 81.00, 21, 0.000),
    (10643, 28, 45.60, 15, 0.250),
    (10692, 63, 43.90, 20, 0.000),
    (10702, 3, 10.00, 6, 0.000),
    (10835, 59, 55.00, 15, 0.000),
    (10952, 6, 25.00, 16, 0.050),
    (11011, 58, 13.25, 40, 0.050)
ON CONFLICT (order_id, product_id) DO NOTHING;

-- Idempotent duplicates for clarity when this file is read independently.
INSERT INTO northwind.customers (customer_id, company_name, contact_name, city, country) VALUES
    ('TOMSP', 'Toms Spezialitaten', 'Karin Josephs', 'Munster', 'Germany'),
    ('HANAR', 'Hanari Carnes', 'Mario Pontes', 'Rio de Janeiro', 'Brazil'),
    ('VICTE', 'Victuailles en stock', 'Mary Saveley', 'Lyon', 'France'),
    ('SUPRD', 'Supremes delices', 'Pascale Cartrain', 'Charleroi', 'Belgium'),
    ('RICSU', 'Richter Supermarkt', 'Michael Holz', 'Geneve', 'Switzerland'),
    ('LINOD', 'LINO-Delicateses', 'Felipe Izquierdo', 'I. de Margarita', 'Venezuela')
ON CONFLICT (customer_id) DO NOTHING;

INSERT INTO northwind.products (
    product_id, product_name, supplier_id, category_id, quantity_per_unit, unit_price,
    units_in_stock, units_on_order, reorder_level, discontinued
) VALUES
    (24, 'Guarana Fantastica', 1, 1, '12 - 355 ml cans', 4.50, 20, 0, 0, TRUE),
    (28, 'Rassle Sauerkraut', 7, 7, '25 - 825 g cans', 45.60, 26, 0, 0, TRUE),
    (31, 'Gorgonzola Telino', 5, 4, '12 - 100 g pkgs', 12.50, 0, 70, 20, FALSE),
    (58, 'Escargots de Bourgogne', 6, 8, '24 pieces', 13.25, 62, 0, 20, FALSE),
    (59, 'Raclette Courdavault', 5, 4, '5 kg pkg.', 55.00, 79, 0, 0, FALSE),
    (63, 'Vegie-spread', 6, 2, '15 - 625 g jars', 43.90, 24, 0, 5, FALSE)
ON CONFLICT (product_id) DO NOTHING;

INSERT INTO northwind.regions (region_id, region_description) VALUES
    (1, 'Eastern'),
    (2, 'Western'),
    (3, 'Northern'),
    (4, 'Southern')
ON CONFLICT (region_id) DO NOTHING;

INSERT INTO northwind.territories (territory_id, territory_description, region_id) VALUES
    ('01581', 'Westboro', 1),
    ('01730', 'Bedford', 1),
    ('01833', 'Georgetow', 1),
    ('02116', 'Boston', 1),
    ('95054', 'Santa Clara', 2),
    ('95060', 'Santa Cruz', 2)
ON CONFLICT (territory_id) DO NOTHING;

INSERT INTO northwind.employee_territories (employee_id, territory_id) VALUES
    (1, '01581'),
    (2, '01730'),
    (3, '01833'),
    (4, '02116'),
    (5, '95054'),
    (6, '95060')
ON CONFLICT (employee_id, territory_id) DO NOTHING;

SELECT setval(pg_get_serial_sequence('northwind.categories', 'category_id'), COALESCE(MAX(category_id), 1), TRUE) FROM northwind.categories;
SELECT setval(pg_get_serial_sequence('northwind.suppliers', 'supplier_id'), COALESCE(MAX(supplier_id), 1), TRUE) FROM northwind.suppliers;
SELECT setval(pg_get_serial_sequence('northwind.employees', 'employee_id'), COALESCE(MAX(employee_id), 1), TRUE) FROM northwind.employees;
SELECT setval(pg_get_serial_sequence('northwind.shippers', 'shipper_id'), COALESCE(MAX(shipper_id), 1), TRUE) FROM northwind.shippers;
SELECT setval(pg_get_serial_sequence('northwind.products', 'product_id'), COALESCE(MAX(product_id), 1), TRUE) FROM northwind.products;
SELECT setval(pg_get_serial_sequence('northwind.orders', 'order_id'), COALESCE(MAX(order_id), 1), TRUE) FROM northwind.orders;
