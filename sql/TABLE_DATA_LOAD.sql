
COPY begin_inventory
FROM 'D:\vendor data\data\begin_inventory.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY end_inventory
FROM 'D:\vendor data\data\end_inventory.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY purchase_prices
FROM 'D:\vendor data\data\purchase_prices.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY purchases
FROM 'D:\vendor data\data\purchases.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY sales
FROM 'D:\vendor data\data\sales.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY vendor_invoice
FROM 'D:\vendor data\data\vendor_invoice.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');