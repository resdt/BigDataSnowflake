-- Dimension Tables
DROP TABLE IF EXISTS dim_customer CASCADE;

CREATE TABLE dim_customer (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    age INTEGER,
    email VARCHAR(100) UNIQUE,
    country VARCHAR(100),
    postal_code VARCHAR(20),
    pet_type VARCHAR(50),
    pet_name VARCHAR(100),
    pet_breed VARCHAR(100)
);

DROP TABLE IF EXISTS dim_seller CASCADE;

CREATE TABLE dim_seller (
    seller_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    country VARCHAR(100),
    postal_code VARCHAR(20)
);

DROP TABLE IF EXISTS dim_product CASCADE;

CREATE TABLE dim_product (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(100),
    price DECIMAL(10, 2),
    weight DECIMAL(10, 2),
    color VARCHAR(50),
    size VARCHAR(20),
    brand VARCHAR(100),
    material VARCHAR(100),
    description TEXT,
    rating DECIMAL(2, 1),
    reviews INTEGER,
    release_date DATE,
    expiry_date DATE,
    pet_category VARCHAR(50),
    CONSTRAINT uq_product UNIQUE (name, category)
);

DROP TABLE IF EXISTS dim_store CASCADE;

CREATE TABLE dim_store (
    store_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    CONSTRAINT uq_store UNIQUE (name, location)
);

DROP TABLE IF EXISTS dim_supplier CASCADE;

CREATE TABLE dim_supplier (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    contact VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(100),
    country VARCHAR(100)
);

-- Fact Table
DROP TABLE IF EXISTS fact_sales CASCADE;

CREATE TABLE fact_sales (
    sale_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES dim_customer (customer_id),
    seller_id INTEGER REFERENCES dim_seller (seller_id),
    product_id INTEGER REFERENCES dim_product (product_id),
    store_id INTEGER REFERENCES dim_store (store_id),
    supplier_id INTEGER REFERENCES dim_supplier (supplier_id),
    sale_date DATE,
    quantity INTEGER,
    total_price DECIMAL(10, 2),
    product_quantity INTEGER
);

-- Indexes
CREATE INDEX idx_fact_sales_customer ON fact_sales (customer_id);
CREATE INDEX idx_fact_sales_product ON fact_sales (product_id);
CREATE INDEX idx_fact_sales_seller ON fact_sales (seller_id);
CREATE INDEX idx_fact_sales_store ON fact_sales (store_id);
CREATE INDEX idx_fact_sales_supplier ON fact_sales (supplier_id);
CREATE INDEX idx_fact_sales_date ON fact_sales (sale_date);