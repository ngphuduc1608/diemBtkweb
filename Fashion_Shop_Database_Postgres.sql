-- Create database
CREATE DATABASE fashion_shop;
COMMENT ON DATABASE fashion_shop IS 'Database for an e-commerce fashion shop';

-- Connect to the database
\c fashion_shop

-- Create table roles
CREATE TABLE roles (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE roles IS 'Defines user roles (e.g., admin, customer, staff)';
COMMENT ON COLUMN roles.name IS 'Name of the role (e.g., Admin, Customer)';

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
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    google_account_id VARCHAR(255) UNIQUE,
    otp_request_time TIMESTAMP,
    one_time_password VARCHAR(10),
    verify BOOLEAN DEFAULT FALSE,
    role_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE NO ACTION,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE users IS 'Stores user information for customers and staff';
COMMENT ON COLUMN users.role_id IS 'References the role assigned to the user';

-- Create table addresses
CREATE TABLE addresses (
    id BIGSERIAL PRIMARY KEY,
    street VARCHAR(255) NOT NULL,
    district VARCHAR(255) NOT NULL,
    ward VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    full_address VARCHAR(255),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE addresses IS 'Stores physical addresses for stores, warehouses, and users';
COMMENT ON COLUMN addresses.full_address IS 'Concatenated full address for display';

-- Create table attributes
CREATE TABLE attributes (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE attributes IS 'Defines product attributes (e.g., color, size)';
COMMENT ON COLUMN attributes.name IS 'Name of the attribute (e.g., Color)';

-- Create table attributes_values
CREATE TABLE attributes_values (
    id BIGSERIAL PRIMARY KEY,
    value_name VARCHAR(255) NOT NULL,
    value_img VARCHAR(255),
    sort_order INTEGER,
    attribute_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_attribute FOREIGN KEY (attribute_id) REFERENCES attributes(id) ON DELETE CASCADE,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE attributes_values IS 'Stores values for attributes (e.g., Red, Blue for Color)';
COMMENT ON COLUMN attributes_values.attribute_id IS 'References the parent attribute';

-- Create table attribute_value_pattern
CREATE TABLE attribute_value_pattern (
    id BIGSERIAL PRIMARY KEY,
    pattern_name VARCHAR(255) NOT NULL,
    pattern_type VARCHAR(255) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE attribute_value_pattern IS 'Defines patterns for attribute values (e.g., striped, polka dot)';
COMMENT ON COLUMN attribute_value_pattern.pattern_name IS 'Name of the pattern';

-- Create table pattern_attribute_value
CREATE TABLE pattern_attribute_value (
    pattern_id BIGINT NOT NULL,
    attribute_value_id BIGINT NOT NULL,
    PRIMARY KEY (pattern_id, attribute_value_id),
    CONSTRAINT fk_pattern FOREIGN KEY (pattern_id) REFERENCES attribute_value_pattern(id) ON DELETE CASCADE,
    CONSTRAINT fk_attribute_value FOREIGN KEY (attribute_value_id) REFERENCES attributes_values(id) ON DELETE CASCADE
);
COMMENT ON TABLE pattern_attribute_value IS 'Many-to-Many relationship between patterns and attribute values';

-- Create table languages
CREATE TABLE languages (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE languages IS 'Stores supported languages for translations';
COMMENT ON COLUMN languages.code IS 'ISO language code (e.g., en, vi)';

-- Create table banners
CREATE TABLE banners (
    id BIGSERIAL PRIMARY KEY,
    logo_url VARCHAR(255),
    media_url VARCHAR(255),
    redirect_url VARCHAR(255),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    activation_date TIMESTAMP,
    end_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE banners IS 'Stores promotional banners for the shop';
COMMENT ON COLUMN banners.media_url IS 'URL to the banner media';

-- Create table banners_translations
CREATE TABLE banners_translations (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    subtitle VARCHAR(255) NOT NULL,
    banner_id BIGINT NOT NULL,
    language_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_banner FOREIGN KEY (banner_id) REFERENCES banners(id) ON DELETE CASCADE,
    CONSTRAINT fk_language FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE NO ACTION,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE banners_translations IS 'Translations for banners in different languages';

-- Create table categories
CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,
    image_url VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    parent_id BIGINT,
    version BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_parent_category FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE categories IS 'Stores product categories with hierarchical structure';
COMMENT ON COLUMN categories.parent_id IS 'References parent category for hierarchy';

-- Create table categories_translations
CREATE TABLE categories_translations (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category_id BIGINT NOT NULL,
    language_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    CONSTRAINT fk_language FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE NO ACTION,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE categories_translations IS 'Translations for category names';

-- Create table holidays
CREATE TABLE holidays (
    id BIGSERIAL PRIMARY KEY,
    holiday_name VARCHAR(255) NOT NULL,
    date DATE,
    is_fixed BOOLEAN,
    description VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE holidays IS 'Stores holidays for promotional events';
COMMENT ON COLUMN holidays.holiday_name IS 'Name of the holiday (e.g., Christmas)';

-- Create table promotions
CREATE TABLE promotions (
    id BIGSERIAL PRIMARY KEY,
    discount_percentage DOUBLE PRECISION NOT NULL,
    descriptions VARCHAR(255),
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    holiday_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_holiday FOREIGN KEY (holiday_id) REFERENCES holidays(id) ON DELETE SET NULL,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE promotions IS 'Stores promotional campaigns';
COMMENT ON COLUMN promotions.holiday_id IS 'References associated holiday';

-- Create table coupon_config
CREATE TABLE coupon_config (
    id BIGSERIAL PRIMARY KEY,
    type VARCHAR(255),
    discount_type VARCHAR(255),
    discount_value REAL,
    min_order_value REAL,
    expiration_days INTEGER,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE coupon_config IS 'Stores configurations for coupons';
COMMENT ON COLUMN coupon_config.discount_type IS 'Type of discount (e.g., percentage, fixed)';

-- Create table currencies
CREATE TABLE currencies (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    symbol VARCHAR(10),
    rate_to_base DOUBLE PRECISION,
    is_base BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE currencies IS 'Stores supported currencies for pricing';
COMMENT ON COLUMN currencies.code IS 'Currency code (e.g., USD, VND)';

-- Create table coupons
CREATE TABLE coupons (
    id BIGSERIAL PRIMARY KEY,
    discount_type VARCHAR(255) NOT NULL,
    discount_value REAL NOT NULL,
    min_order_value REAL NOT NULL,
    expiration_date TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    code VARCHAR(255) NOT NULL UNIQUE,
    image_url VARCHAR(255),
    is_global BOOLEAN DEFAULT FALSE,
    coupon_config_id BIGINT,
    promotion_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_coupon_config FOREIGN KEY (coupon_config_id) REFERENCES coupon_config(id) ON DELETE SET NULL,
    CONSTRAINT fk_promotion FOREIGN KEY (promotion_id) REFERENCES promotions(id) ON DELETE SET NULL,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE coupons IS 'Stores discount coupons';
COMMENT ON COLUMN coupons.code IS 'Unique coupon code';

-- Create table holiday_coupon_translation
CREATE TABLE holiday_coupon_translation (
    id BIGSERIAL PRIMARY KEY,
    coupon_type VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(300) NOT NULL,
    coupon_id BIGINT NOT NULL,
    language_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_coupon FOREIGN KEY (coupon_id) REFERENCES coupons(id) ON DELETE CASCADE,
    CONSTRAINT fk_language FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE NO ACTION,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE holiday_coupon_translation IS 'Translations for holiday-specific coupons';

-- Create table stores
CREATE TABLE stores (
    id BIGSERIAL PRIMARY KEY,
    address_id BIGINT NOT NULL,
    name VARCHAR(255),
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    open_hour TIMESTAMP,
    close_hour TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_address FOREIGN KEY (address_id) REFERENCES addresses(id) ON DELETE NO ACTION,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE stores IS 'Stores physical store locations';
COMMENT ON COLUMN stores.address_id IS 'References the store’s address';

-- Create table warehouses
CREATE TABLE warehouses (
    id BIGSERIAL PRIMARY KEY,
    address_id BIGINT NOT NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(15),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_address FOREIGN KEY (address_id) REFERENCES addresses(id) ON DELETE NO ACTION,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE warehouses IS 'Stores warehouse locations for inventory';
COMMENT ON COLUMN warehouses.address_id IS 'References the warehouse’s address';

-- Create table order_status
CREATE TABLE order_status (
    id BIGSERIAL PRIMARY KEY,
    status_name VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE order_status IS 'Stores possible order statuses (e.g., Pending, Shipped)';
COMMENT ON COLUMN order_status.status_name IS 'Name of the order status';

-- Create table shipping_method
CREATE TABLE shipping_method (
    id BIGSERIAL PRIMARY KEY,
    method_name VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE shipping_method IS 'Stores available shipping methods';
COMMENT ON COLUMN shipping_method.method_name IS 'Name of the shipping method';

-- Create table payment_method
CREATE TABLE payment_method (
    id BIGSERIAL PRIMARY KEY,
    method_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE payment_method IS 'Stores available payment methods';
COMMENT ON COLUMN payment_method.method_name IS 'Name of the payment method';

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
    user_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE reviews IS 'Stores customer reviews for products';
COMMENT ON COLUMN reviews.user_id IS 'References the user who wrote the review';

-- Create table products
CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    status VARCHAR(255) NOT NULL,
    base_price DOUBLE PRECISION NOT NULL,
    currency_id BIGINT NOT NULL,
    store_id BIGINT,
    banner_id BIGINT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    promotion_id BIGINT,
    review_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_currency FOREIGN KEY (currency_id) REFERENCES currencies(id) ON DELETE NO ACTION,
    CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE SET NULL,
    CONSTRAINT fk_banner FOREIGN KEY (banner_id) REFERENCES banners(id) ON DELETE SET NULL,
    CONSTRAINT fk_promotion FOREIGN KEY (promotion_id) REFERENCES promotions(id) ON DELETE SET NULL,
    CONSTRAINT fk_review FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE SET NULL,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE products IS 'Stores product information';
COMMENT ON COLUMN products.review_id IS 'References a featured review for the product';

-- Add foreign key from reviews to products
ALTER TABLE reviews
ADD CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE SET NULL;
COMMENT ON CONSTRAINT fk_product ON reviews IS 'References the product being reviewed';

-- Create table products_categories
CREATE TABLE products_categories (
    product_id BIGINT NOT NULL,
    category_id BIGINT NOT NULL,
    PRIMARY KEY (product_id, category_id),
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);
COMMENT ON TABLE products_categories IS 'Many-to-Many relationship between products and categories';

-- Create table products_translations
CREATE TABLE products_translations (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    material VARCHAR(255),
    care VARCHAR(255),
    product_id BIGINT NOT NULL,
    language_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT fk_language FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE NO ACTION,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE products_translations IS 'Translations for product details';

-- Create table product_variants
CREATE TABLE product_variants (
    id BIGSERIAL PRIMARY KEY,
    sale_price DOUBLE PRECISION NOT NULL,
    color_value_id BIGINT,
    size_value_id BIGINT,
    product_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_color_value FOREIGN KEY (color_value_id) REFERENCES attributes_values(id) ON DELETE SET NULL,
    CONSTRAINT fk_size_value FOREIGN KEY (size_value_id) REFERENCES attributes_values(id) ON DELETE SET NULL,
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE product_variants IS 'Stores variants of products (e.g., different colors or sizes)';
COMMENT ON COLUMN product_variants.product_id IS 'References the parent product';

-- Create table product_media
CREATE TABLE product_media (
    id BIGSERIAL PRIMARY KEY,
    media_url VARCHAR(255) NOT NULL,
    media_type VARCHAR(255) NOT NULL,
    sort_order INTEGER,
    model_height INTEGER,
    color_value_id BIGINT,
    product_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_color_value FOREIGN KEY (color_value_id) REFERENCES attributes_values(id) ON DELETE SET NULL,
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE product_media IS 'Stores media (images/videos) for products';
COMMENT ON COLUMN product_media.media_url IS 'URL to the media file';

-- Create table media_variants
CREATE TABLE media_variants (
    product_media_id BIGINT NOT NULL,
    product_variant_id BIGINT NOT NULL,
    PRIMARY KEY (product_media_id, product_variant_id),
    CONSTRAINT fk_product_media FOREIGN KEY (product_media_id) REFERENCES product_media(id) ON DELETE CASCADE,
    CONSTRAINT fk_product_variant FOREIGN KEY (product_variant_id) REFERENCES product_variants(id) ON DELETE CASCADE
);
COMMENT ON TABLE media_variants IS 'Many-to-Many relationship between product media and variants';

-- Create table coupon_translations
CREATE TABLE coupon_translations (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    coupon_id BIGINT NOT NULL,
    language_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_coupon FOREIGN KEY (coupon_id) REFERENCES coupons(id) ON DELETE CASCADE,
    CONSTRAINT fk_language FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE NO ACTION,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE coupon_translations IS 'Translations for coupon details';

-- Create table coupon_user_restriction
CREATE TABLE coupon_user_restriction (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    coupon_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_coupon FOREIGN KEY (coupon_id) REFERENCES coupons(id) ON DELETE CASCADE,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE coupon_user_restriction IS 'Restricts coupons to specific users';

-- Create table user_coupon_usage
CREATE TABLE user_coupon_usage (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    coupon_id BIGINT NOT NULL,
    used BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    UNIQUE (user_id, coupon_id),
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_coupon FOREIGN KEY (coupon_id) REFERENCES coupons(id) ON DELETE CASCADE,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE user_coupon_usage IS 'Tracks coupon usage by users';

-- Create table inventories
CREATE TABLE inventories (
    id BIGSERIAL PRIMARY KEY,
    product_variant_id BIGINT NOT NULL,
    warehouse_id BIGINT,
    store_id BIGINT,
    quantity_in_stock INTEGER NOT NULL,
    delta_quantity INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_product_variant FOREIGN KEY (product_variant_id) REFERENCES product_variants(id) ON DELETE CASCADE,
    CONSTRAINT fk_warehouse FOREIGN KEY (warehouse_id) REFERENCES warehouses(id) ON DELETE SET NULL,
    CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE SET NULL,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE inventories IS 'Tracks inventory for product variants';
COMMENT ON COLUMN inventories.quantity_in_stock IS 'Current stock quantity';

-- Create table inventory_transfers
CREATE TABLE inventory_transfers (
    id BIGSERIAL PRIMARY KEY,
    warehouse_id BIGINT NOT NULL,
    store_id BIGINT NOT NULL,
    status VARCHAR(50),
    message VARCHAR(255),
    is_return BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_warehouse FOREIGN KEY (warehouse_id) REFERENCES warehouses(id) ON DELETE NO ACTION,
    CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE NO ACTION,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE inventory_transfers IS 'Tracks inventory transfers between warehouses and stores';

-- Create table inventory_transfers_items
CREATE TABLE inventory_transfers_items (
    id BIGSERIAL PRIMARY KEY,
    transfer_id BIGINT NOT NULL,
    product_variant_id BIGINT NOT NULL,
    quantity INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_transfer FOREIGN KEY (transfer_id) REFERENCES inventory_transfers(id) ON DELETE CASCADE,
    CONSTRAINT fk_product_variant FOREIGN KEY (product_variant_id) REFERENCES product_variants(id) ON DELETE CASCADE,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE inventory_transfers_items IS 'Items included in inventory transfers';

-- Create table orders
CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT,
    coupon_id BIGINT,
    currency_id BIGINT NOT NULL,
    total_price DOUBLE PRECISION NOT NULL,
    total_amount DOUBLE PRECISION NOT NULL,
    status_id BIGINT NOT NULL,
    shipping_address VARCHAR(255) NOT NULL,
    shipping_method_id BIGINT,
    shipping_fee DOUBLE PRECISION,
    tax_amount DOUBLE PRECISION,
    transaction_id VARCHAR(255),
    store_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_coupon FOREIGN KEY (coupon_id) REFERENCES coupons(id) ON DELETE SET NULL,
    CONSTRAINT fk_currency FOREIGN KEY (currency_id) REFERENCES currencies(id) ON DELETE NO ACTION,
    CONSTRAINT fk_status FOREIGN KEY (status_id) REFERENCES order_status(id) ON DELETE NO ACTION,
    CONSTRAINT fk_shipping_method FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(id) ON DELETE SET NULL,
    CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE SET NULL,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE orders IS 'Stores customer orders';
COMMENT ON COLUMN orders.total_amount IS 'Total order amount including tax and shipping';

-- Create table orders_details
CREATE TABLE orders_details (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL,
    product_variant_id BIGINT NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price DOUBLE PRECISION NOT NULL,
    total_price DOUBLE PRECISION NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_product_variant FOREIGN KEY (product_variant_id) REFERENCES product_variants(id) ON DELETE NO ACTION,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE orders_details IS 'Details of items in an order';

-- Create table payment
CREATE TABLE payment (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL,
    payment_method_id BIGINT NOT NULL,
    payment_date DATE NOT NULL,
    amount DOUBLE PRECISION NOT NULL,
    status VARCHAR(255) NOT NULL,
    transaction_code VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_payment_method FOREIGN KEY (payment_method_id) REFERENCES payment_method(id) ON DELETE NO ACTION,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE payment IS 'Stores payment information for orders';

-- Create table cart
CREATE TABLE cart (
    id BIGSERIAL PRIMARY KEY,
    session_id VARCHAR(255) UNIQUE,
    user_id BIGINT UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE cart IS 'Stores user shopping carts';
COMMENT ON COLUMN cart.session_id IS 'Unique session ID for guest carts';

-- Create table cart_item
CREATE TABLE cart_item (
    id BIGSERIAL PRIMARY KEY,
    product_variant_id BIGINT,
    cart_id BIGINT,
    quantity INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_product_variant FOREIGN KEY (product_variant_id) REFERENCES product_variants(id) ON DELETE SET NULL,
    CONSTRAINT fk_cart FOREIGN KEY (cart_id) REFERENCES cart(id) ON DELETE CASCADE,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE cart_item IS 'Items in a user’s cart';

-- Create table wishlist
CREATE TABLE wishlist (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE wishlist IS 'Stores user wishlists';

-- Create table wishlist_item
CREATE TABLE wishlist_item (
    id BIGSERIAL PRIMARY KEY,
    product_variant_id BIGINT,
    wishlist_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_product_variant FOREIGN KEY (product_variant_id) REFERENCES product_variants(id) ON DELETE SET NULL,
    CONSTRAINT fk_wishlist FOREIGN KEY (wishlist_id) REFERENCES wishlist(id) ON DELETE CASCADE,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE wishlist_item IS 'Items in a user’s wishlist';

-- Create table notification
CREATE TABLE notification (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT,
    type VARCHAR(255) NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    redirect_url VARCHAR(255),
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE notification IS 'Stores user notifications';
COMMENT ON COLUMN notification.type IS 'Type of notification (e.g., order update)';

-- Create table notification_translations
CREATE TABLE notification_translations (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    message VARCHAR(255) NOT NULL,
    notification_id BIGINT NOT NULL,
    language_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_notification FOREIGN KEY (notification_id) REFERENCES notification(id) ON DELETE CASCADE,
    CONSTRAINT fk_language FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE NO ACTION,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE notification_translations IS 'Translations for notifications';

-- Create table secure_token
CREATE TABLE secure_token (
    id BIGSERIAL PRIMARY KEY,
    token VARCHAR(255) UNIQUE,
    timestamp TIMESTAMP,
    expired_at TIMESTAMP,
    user_id BIGINT NOT NULL,
    is_expired BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE secure_token IS 'Stores secure tokens for authentication';

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
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE tokens IS 'Stores authentication tokens';

-- Create table staff
CREATE TABLE staff (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    store_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE CASCADE,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE staff IS 'Stores staff assignments to stores';

-- Create table user_address
CREATE TABLE user_address (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    address_id BIGINT NOT NULL,
    is_default BOOLEAN,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_address FOREIGN KEY (address_id) REFERENCES addresses(id) ON DELETE CASCADE,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
COMMENT ON TABLE user_address IS 'Stores user addresses for shipping';
