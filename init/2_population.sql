-- population.sql
-- Populate Date Dimension (example for 2000-2050)
INSERT INTO
    dim_date
SELECT
    date_id,
    EXTRACT(
        DAY
        FROM date_id
    )::INTEGER,
    EXTRACT(
        MONTH
        FROM date_id
    )::INTEGER,
    EXTRACT(
        YEAR
        FROM date_id
    )::INTEGER,
    EXTRACT(
        QUARTER
        FROM date_id
    )::INTEGER,
    EXTRACT(
        DOW
        FROM date_id
    )::INTEGER,
    TO_CHAR(date_id, 'Day'),
    TO_CHAR(date_id, 'Month'),
    EXTRACT(
        DOW
        FROM date_id
    ) IN (0, 6) -- Sunday=0, Saturday=6
FROM generate_series(
        '2000-01-01'::date, '2050-12-31'::date, '1 day'::interval
    ) date_id
ON CONFLICT (date_id) DO NOTHING;

-- Populate Customer Dimension
INSERT INTO
    dim_customer (
        first_name,
        last_name,
        age,
        email,
        country,
        postal_code,
        pet_type,
        pet_name,
        pet_breed
    )
SELECT DISTINCT
    customer_first_name,
    customer_last_name,
    customer_age,
    customer_email,
    customer_country,
    customer_postal_code,
    customer_pet_type,
    customer_pet_name,
    customer_pet_breed
FROM mock
ON CONFLICT (email) DO NOTHING;

-- Populate Seller Dimension
INSERT INTO
    dim_seller (
        first_name,
        last_name,
        email,
        country,
        postal_code
    )
SELECT DISTINCT
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_country,
    seller_postal_code
FROM mock
ON CONFLICT (email) DO NOTHING;

-- Populate Product Dimension
INSERT INTO
    dim_product (
        name,
        category,
        price,
        weight,
        color,
        size,
        brand,
        material,
        description,
        rating,
        reviews,
        release_date,
        expiry_date,
        pet_category
    )
SELECT DISTINCT
    product_name,
    product_category,
    product_price,
    product_weight,
    product_color,
    product_size,
    product_brand,
    product_material,
    product_description,
    product_rating,
    product_reviews,
    product_release_date,
    product_expiry_date,
    pet_category
FROM mock
ON CONFLICT (name, category) DO NOTHING;

-- Populate Store Dimension
INSERT INTO
    dim_store (
        name,
        location,
        city,
        state,
        country,
        phone,
        email
    )
SELECT DISTINCT
    store_name,
    store_location,
    store_city,
    store_state,
    store_country,
    store_phone,
    store_email
FROM mock
ON CONFLICT (name, location) DO NOTHING;

-- Populate Supplier Dimension
INSERT INTO
    dim_supplier (
        name,
        contact,
        email,
        phone,
        address,
        city,
        country
    )
SELECT DISTINCT
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    supplier_city,
    supplier_country
FROM mock
ON CONFLICT (email) DO NOTHING;

-- Populate Fact Sales Table
INSERT INTO
    fact_sales (
        customer_id,
        seller_id,
        product_id,
        store_id,
        supplier_id,
        sale_date,
        quantity,
        total_price,
        product_quantity
    )
SELECT c.customer_id, s.seller_id, p.product_id, st.store_id, sp.supplier_id, m.sale_date, m.sale_quantity, m.sale_total_price, m.product_quantity
FROM
    mock m
    JOIN dim_customer c ON m.customer_email = c.email
    JOIN dim_seller s ON m.seller_email = s.email
    JOIN dim_product p ON m.product_name = p.name
    AND m.product_category = p.category
    JOIN dim_store st ON m.store_name = st.name
    AND m.store_location = st.location
    JOIN dim_supplier sp ON m.supplier_email = sp.email;