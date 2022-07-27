CREATE TABLE dimDate(
    date_key INT PRIMARY KEY,
    `date` DATE NOT NULL,
    `year` SMALLINT	NOT NULL,
    quarter SMALLINT NOT NULL,
    `month` SMALLINT NOT NULL,
    `day` SMALLINT NOT NULL,
    `week` SMALLINT NOT NULL,
    is_weekend BOOLEAN NOT NULL
);

CREATE TABLE dimCustomer(
    customer_key Int PRIMARY KEY,
    customer_id SMALLINT NOT NULL,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    email VARCHAR(50),
    address VARCHAR(50) NOT NULL,
    address2 VARCHAR(50),
    `district` VARCHAR(30) NOT NULL,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    postal_code VARCHAR(10),
    phone VARCHAR(20) NOT NULL,
    active SMALLINT NOT NULL,
    create_date TIMESTAMP NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

CREATE TABLE dimMovie(
    movie_key INT PRIMARY KEY,
    film_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    release_year YEAR,
    `language` VARCHAR(20) NOT NULL,
    original_language VARCHAR(20),
    rental_duration SMALLINT NOT NULL,
    `length` SMALLINT NOT NULL,
    rating VARCHAR(5) NOT NULL,
    special_features VARCHAR(60) NOT NULL
);

CREATE TABLE dimStore(
    store_key INT PRIMARY KEY,
    store_id SMALLINT NOT NULL,
    address VARCHAR(50) NOT NULL,
    address2 VARCHAR(50),
    `district` VARCHAR(30) NOT NULL,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    postal_code VARCHAR(10),
    manager_first_name VARCHAR(45) NOT NULL,
    manager_last_name VARCHAR(45) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

CREATE TABLE fact_sales(
    sales_key INT Auto_Increment PRIMARY KEY,
    date_key INT NOT NULL,
    customer_key INT NOT NULL,
    movie_key INT NOT NULL,
    store_key INT NOT NULL,
    sales_amount FLOAT NOT NULL,
    FOREIGN KEY(date_key) REFERENCES dimDate(date_key),
    FOREIGN KEY(customer_key) REFERENCES dimCustomer(customer_key),
    FOREIGN KEY(movie_key) REFERENCES dimMovie(movie_key),
    FOREIGN KEY(store_key) REFERENCES dimStore(store_key)
);
