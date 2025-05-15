-- Create database
CREATE DATABASE fashion_shop;


-- Create table addresses
CREATE TABLE addresses (
    id BIGSERIAL PRIMARY KEY,
    street VARCHAR(255) NOT NULL,
    district VARCHAR(255) NOT NULL,
    ward VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    full_address VARCHAR(255),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION
);

-- Create table attributes
CREATE TABLE attributes (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT
);

-- Create table attributes_values
CREATE TABLE attributes_values (
    id BIGSERIAL PRIMARY KEY,
    value_name VARCHAR(255) NOT NULL,
    value_img VARCHAR(255),
    sort_order INTEGER,
    attribute_id BIGINT NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    FOREIGN KEY (attribute_id) REFERENCES attributes(id) ON DELETE CASCADE
);

-- Create table attribute_value_pattern
CREATE TABLE attribute_value_pattern (
    id BIGSERIAL PRIMARY KEY,
    pattern_name VARCHAR(255) NOT NULL,
    pattern_type VARCHAR(255) NOT NULL,
    is_active BOOLEAN NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT
);

-- Create table pattern_attribute_value (Many-to-Many)
CREATE TABLE pattern_attribute_value (
    pattern_id BIGINT NOT NULL,
    attribute_value_id BIGINT NOT NULL,
    PRIMARY KEY (pattern_id, attribute_value_id),
    FOREIGN KEY (pattern_id) REFERENCES attribute_value_pattern(id) ON DELETE CASCADE,
    FOREIGN KEY (attribute_value_id) REFERENCES attributes_values(id) ON DELETE CASCADE
);

-- Create table banners
CREATE TABLE banners (
    id BIGSERIAL PRIMARY KEY,
    logo_url VARCHAR(255),
    media_url VARCHAR(255),
    redirect_url VARCHAR(255),
    is_active BOOLEAN NOT NULL,
    activation_date TIMESTAMP,
    end_date TIMESTAMP,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT
);

-- Create table languages
CREATE TABLE languages (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT
);

-- Create table banners_translations
CREATE TABLE banners_translations (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    subtitle VARCHAR(255) NOT NULL,
    banner_id BIGINT NOT NULL,
    language_id BIGINT NOT NULL,
    FOREIGN KEY (banner_id) REFERENCES banners(id) ON DELETE CASCADE,
    FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE NO ACTION
);

-- Create table roles
CREATE TABLE roles (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Create table users
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE,
    date_of_birth TIMESTAMP,
    gender VARCHAR(20),
    is_active BOOLEAN NOT NULL,
    google_account_id VARCHAR(255) UNIQUE,
    otp_request_time TIMESTAMP,
    one_time_password VARCHAR(10),
    verify BOOLEAN,
    role_id BIGINT NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE NO ACTION
);

-- Create table categories
CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,
    image_url VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    parent_id BIGINT,
    version BIGINT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- Create table categories_translations
CREATE TABLE categories_translations (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category_id BIGINT NOT NULL,
    language_id BIGINT NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE NO ACTION
);

-- Create table promotions
CREATE TABLE promotions (
    id BIGSERIAL PRIMARY KEY,
    discount_percentage DOUBLE PRECISION NOT NULL,
    descriptions VARCHAR(255),
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    is_active BOOLEAN NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT
);

-- Create table reviews
CREATE TABLE reviews (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255),
    comment VARCHAR(255),
    purchased_size VARCHAR(255),
    fit VARCHAR(255),
    nickname VARCHAR(255),
    gender VARCHAR(255),
    age_group VARCHAR(255),
    height VARCHAR(255),
    weight VARCHAR(255),
    shoe_size VARCHAR(255),
    location VARCHAR(255),
    review_rate VARCHAR(255),
    product_id BIGINT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT
);

-- Create table products
CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    status VARCHAR(255) NOT NULL,
    base_price DOUBLE PRECISION NOT NULL,
    is_active BOOLEAN NOT NULL,
    promotion_id BIGINT,
    review_id BIGINT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    FOREIGN KEY (promotion_id) REFERENCES promotions(id) ON DELETE SET NULL,
    FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE SET NULL
);

-- Add foreign key from reviews to products after products table is created
ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_product_id
FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE SET NULL;

-- Create table products_categories (Many-to-Many)
CREATE TABLE products_categories (
    product_id BIGINT NOT NULL,
    category_id BIGINT NOT NULL,
    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

-- Create table products_translations
CREATE TABLE products_translations (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    material VARCHAR(255),
    care VARCHAR(255),
    product_id BIGINT NOT NULL,
    language_id BIGINT NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE NO ACTION
);

-- Create table product_variants
CREATE TABLE product_variants (
    id BIGSERIAL PRIMARY KEY,
    sale_price DOUBLE PRECISION NOT NULL,
    color_value_id BIGINT,
    size_value_id BIGINT,
    product_id BIGINT NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    FOREIGN KEY (color_value_id) REFERENCES attributes_values(id) ON DELETE SET NULL,
    FOREIGN KEY (size_value_id) REFERENCES attributes_values(id) ON DELETE SET NULL,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Create table product_media
CREATE TABLE product_media (
    id BIGSERIAL PRIMARY KEY,
    media_url VARCHAR(255) NOT NULL,
    media_type VARCHAR(255) NOT NULL,
    sort_order INTEGER,
    model_height INTEGER,
    color_value_id BIGINT,
    product_id BIGINT NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    FOREIGN KEY (color_value_id) REFERENCES attributes_values(id) ON DELETE SET NULL,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Create table media_variants (Many-to-Many)
CREATE TABLE media_variants (
    product_media_id BIGINT NOT NULL,
    product_variant_id BIGINT NOT NULL,
    PRIMARY KEY (product_media_id, product_variant_id),
    FOREIGN KEY (product_media_id) REFERENCES product_media(id) ON DELETE CASCADE,
    FOREIGN KEY (product_variant_id) REFERENCES product_variants(id) ON DELETE CASCADE
);

-- Create table coupons
CREATE TABLE coupons (
    id BIGSERIAL PRIMARY KEY,
    discount_type VARCHAR(255) NOT NULL,
    discount_value REAL NOT NULL,
    min_order_value REAL NOT NULL,
    expiration_date TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    code VARCHAR(255) NOT NULL,
    image_url VARCHAR(255),
    is_global BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT
);

-- Create table coupon_translations
CREATE TABLE coupon_translations (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    coupon_id BIGINT NOT NULL,
    language_id BIGINT NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    FOREIGN KEY (coupon_id) REFERENCES coupons(id) ON DELETE CASCADE,
    FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE NO ACTION
);

-- Create table coupon_user_restriction
CREATE TABLE coupon_user_restriction (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    coupon_id BIGINT NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (coupon_id) REFERENCES coupons(id) ON DELETE CASCADE
);

-- Create table user_coupon_usage
CREATE TABLE user_coupon_usage (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    coupon_id BIGINT NOT NULL,
    used BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    UNIQUE (user_id, coupon_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (coupon_id) REFERENCES coupons(id) ON DELETE CASCADE
);

-- Create table coupon_config
CREATE TABLE coupon_config (
    id BIGSERIAL PRIMARY KEY,
    type VARCHAR(255),
    discount_type VARCHAR(255),
    discount_value REAL,
    min_order_value REAL,
    expiration_days INTEGER,
    image_url VARCHAR(255)
);

-- Create table currencies
CREATE TABLE currencies (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    symbol VARCHAR(10),
    rate_to_base DOUBLE PRECISION,
    is_base BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT
);

-- Create table holidays
CREATE TABLE holidays (
    id BIGSERIAL PRIMARY KEY,
    holiday_name VARCHAR(255) NOT NULL,
    date DATE,
    is_fixed BOOLEAN,
    description VARCHAR(255) NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT
);

-- Create table holiday_coupon_translation
CREATE TABLE holiday_coupon_translation (
    id BIGSERIAL PRIMARY KEY,
    coupon_type VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(300) NOT NULL,
    language_code VARCHAR(10) NOT NULL
);

-- Create table stores
CREATE TABLE stores (
    id BIGSERIAL PRIMARY KEY,
    address_id BIGINT NOT NULL,
    name VARCHAR(255),
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(255),
    is_active BOOLEAN,
    open_hour TIMESTAMP,
    close_hour TIMESTAMP,
    FOREIGN KEY (address_id) REFERENCES addresses(id) ON DELETE NO ACTION
);

-- Create table warehouses
CREATE TABLE warehouses (
    id BIGSERIAL PRIMARY KEY,
    address_id BIGINT NOT NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(15),
    is_active BOOLEAN NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    FOREIGN KEY (address_id) REFERENCES addresses(id) ON DELETE NO ACTION
);

-- Create table inventories
CREATE TABLE inventories (
    id BIGSERIAL PRIMARY KEY,
    product_variant_id BIGINT NOT NULL,
    warehouse_id BIGINT,
    store_id BIGINT,
    quantity_in_stock INTEGER NOT NULL,
    delta_quantity INTEGER,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    FOREIGN KEY (product_variant_id) REFERENCES product_variants(id) ON DELETE CASCADE,
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(id) ON DELETE SET NULL,
    FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE SET NULL
);

-- Create table inventory_transfers
CREATE TABLE inventory_transfers (
    id BIGSERIAL PRIMARY KEY,
    warehouse_id BIGINT NOT NULL,
    store_id BIGINT NOT NULL,
    status VARCHAR(50),
    message VARCHAR(255),
    is_return BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(id) ON DELETE NO ACTION,
    FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE NO ACTION
);

-- Create table inventory_transfers_items
CREATE TABLE inventory_transfers_items (
    id BIGSERIAL PRIMARY KEY,
    transfer_id BIGINT NOT NULL,
    product_variant_id BIGINT NOT NULL,
    quantity INTEGER NOT NULL,
    FOREIGN KEY (transfer_id) REFERENCES inventory_transfers(id) ON DELETE CASCADE,
    FOREIGN KEY (product_variant_id) REFERENCES product_variants(id) ON DELETE CASCADE
);

-- Create table order_status
CREATE TABLE order_status (
    id BIGSERIAL PRIMARY KEY,
    status_name VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT
);

-- Create table shipping_method
CREATE TABLE shipping_method (
    id BIGSERIAL PRIMARY KEY,
    method_name VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL
);

-- Create table orders
CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT,
    coupon_id BIGINT,
    total_price DOUBLE PRECISION NOT NULL,
    total_amount DOUBLE PRECISION NOT NULL,
    status_id BIGINT NOT NULL,
    shipping_address VARCHAR(255) NOT NULL,
    shipping_method_id BIGINT,
    shipping_fee DOUBLE PRECISION,
    tax_amount DOUBLE PRECISION,
    transaction_id VARCHAR(255),
    store_id BIGINT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (coupon_id) REFERENCES coupons(id) ON DELETE SET NULL,
    FOREIGN KEY (status_id) REFERENCES order_status(id) ON DELETE NO ACTION,
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(id) ON DELETE SET NULL,
    FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE SET NULL
);

-- Create table orders_details
CREATE TABLE orders_details (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL,
    product_variant_id BIGINT NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price DOUBLE PRECISION NOT NULL,
    total_price DOUBLE PRECISION NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_variant_id) REFERENCES product_variants(id) ON DELETE NO ACTION
);

-- Create table payment_method
CREATE TABLE payment_method (
    id BIGSERIAL PRIMARY KEY,
    method_name VARCHAR(255) NOT NULL
);

-- Create table payment
CREATE TABLE payment (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL,
    payment_method_id BIGINT NOT NULL,
    payment_date DATE NOT NULL,
    amount DOUBLE PRECISION NOT NULL,
    status VARCHAR(255) NOT NULL,
    transaction_code VARCHAR(255) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (payment_method_id) REFERENCES payment_method(id) ON DELETE NO ACTION
);

-- Create table cart
CREATE TABLE cart (
    id BIGSERIAL PRIMARY KEY,
    session_id VARCHAR(255) UNIQUE,
    user_id BIGINT UNIQUE,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create table cart_item
CREATE TABLE cart_item (
    id BIGSERIAL PRIMARY KEY,
    product_variant_id BIGINT,
    cart_id BIGINT,
    quantity INTEGER,
    FOREIGN KEY (product_variant_id) REFERENCES product_variants(id) ON DELETE SET NULL,
    FOREIGN KEY (cart_id) REFERENCES cart(id) ON DELETE CASCADE
);

-- Create table wishlist
CREATE TABLE wishlist (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create table wishlist_item
CREATE TABLE wishlist_item (
    id BIGSERIAL PRIMARY KEY,
    product_variant_id BIGINT,
    wishlist_id BIGINT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    FOREIGN KEY (product_variant_id) REFERENCES product_variants(id) ON DELETE SET NULL,
    FOREIGN KEY (wishlist_id) REFERENCES wishlist(id) ON DELETE CASCADE
);

-- Create table notification
CREATE TABLE notification (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT,
    type VARCHAR(255) NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    redirect_url VARCHAR(255),
    image_url VARCHAR(255),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Create table notification_translations
CREATE TABLE notification_translations (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    message VARCHAR(255) NOT NULL,
    notification_id BIGINT NOT NULL,
    language_id BIGINT NOT NULL,
    FOREIGN KEY (notification_id) REFERENCES notification(id) ON DELETE CASCADE,
    FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE NO ACTION
);

-- Create table secure_token
CREATE TABLE secure_token (
    id BIGSERIAL PRIMARY KEY,
    token VARCHAR(255) UNIQUE,
    timestamp TIMESTAMP,
    expired_at TIMESTAMP,
    user_id BIGINT NOT NULL,
    is_expired BOOLEAN,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create table tokens
CREATE TABLE tokens (
    id BIGSERIAL PRIMARY KEY,
    token VARCHAR(255),
    refresh_token VARCHAR(255),
    token_type VARCHAR(50),
    expiration_date TIMESTAMP,
    refresh_expiration_date TIMESTAMP,
    is_mobile BOOLEAN,
    revoked BOOLEAN,
    expired BOOLEAN,
    user_id BIGINT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create table staff
CREATE TABLE staff (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    store_id BIGINT NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE CASCADE
);

-- Create table user_address
CREATE TABLE user_address (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    address_id BIGINT NOT NULL,
    is_default BOOLEAN,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    phone VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (address_id) REFERENCES addresses(id) ON DELETE CASCADE
);