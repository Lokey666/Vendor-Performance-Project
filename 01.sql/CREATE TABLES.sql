-- Table 1: Inventory snapshot at start date
CREATE TABLE begin_inventory (
    inventory_id VARCHAR(50) NOT NULL PRIMARY KEY,
    store INTEGER NOT NULL,
    city VARCHAR(100) NOT NULL,
    brand INTEGER NOT NULL,
    description TEXT NOT NULL,
    size VARCHAR(50) NOT NULL,
    on_hand INTEGER NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    start_date DATE NOT NULL
);

-- Table 2: Inventory snapshot at end date  
CREATE TABLE end_inventory (
    inventory_id VARCHAR(50) NOT NULL PRIMARY KEY,
    store INTEGER NOT NULL,
    city VARCHAR(100),
    brand INTEGER NOT NULL,
    description TEXT NOT NULL,
    size VARCHAR(50) NOT NULL,
    on_hand INTEGER NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    end_date DATE NOT NULL
);

-- Table 3: Product master data
CREATE TABLE purchase_price (
    brand INTEGER NOT NULL PRIMARY KEY,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    size VARCHAR(50),
    volume VARCHAR(50),
    classification INTEGER NOT NULL,
    purchase_price DECIMAL(10,2) NOT NULL,
    vendor_number INTEGER NOT NULL,
    vendor_name VARCHAR(100) NOT NULL
);

-- Table 4: Purchase transactions
CREATE TABLE purchases (
    inventory_id VARCHAR(50) NOT NULL,
    store INTEGER NOT NULL,
    brand INTEGER NOT NULL,
    description TEXT NOT NULL,
    size VARCHAR(50),
    vendor_number INTEGER NOT NULL,
    vendor_name VARCHAR(100) NOT NULL,
    po_number INTEGER NOT NULL,
    po_date DATE,
    receiving_date DATE,
    invoice_date DATE,
    pay_date DATE,
    purchase_price DECIMAL(10,2) NOT NULL,
    quantity INTEGER NOT NULL,
    dollars DECIMAL(12,2) NOT NULL,
    classification INTEGER NOT NULL
);

-- Table 5: Sales transactions
CREATE TABLE sales (
    inventory_id VARCHAR(50) NOT NULL,
    store INTEGER NOT NULL,
    brand INTEGER NOT NULL,
    description TEXT NOT NULL,
    size VARCHAR(50) NOT NULL,
    sales_quantity INTEGER NOT NULL,
    sales_dollars DECIMAL(12,2) NOT NULL,
    sales_price DECIMAL(10,2) NOT NULL,
    sales_date DATE NOT NULL,
    volume DECIMAL(10,2) NOT NULL,
    classification INTEGER NOT NULL,
    excise_tax DECIMAL(10,2) NOT NULL,
    vendor_number INTEGER NOT NULL,
    vendor_name VARCHAR(100) NOT NULL
);

-- Table 6: Vendor invoices
CREATE TABLE vendor_invoice (
    vendor_number INTEGER NOT NULL,
    vendor_name VARCHAR(100) NOT NULL,
    invoice_date DATE NOT NULL,
    po_number INTEGER NOT NULL,
    po_date DATE NOT NULL,
    pay_date DATE NOT NULL,
    quantity INTEGER NOT NULL,
    dollars DECIMAL(12,2) NOT NULL,
    freight DECIMAL(10,2) NOT NULL,
    approval VARCHAR(50)
);
