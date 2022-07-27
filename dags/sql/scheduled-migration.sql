INSERT INTO
    dimDate(
    	`date_key`,
        `date`,
        `year`,
        `quarter`,
        `month`,
        `day`,
        `week`,
        `is_weekend`
    )
SELECT
	DISTINCT CAST(DATE_FORMAT(payment_date, "%y%m%d") AS UNSIGNED) as `date_key`,
    date(payment_date) as `date`,
    YEAR(payment_date) as `year`,
    QUARTER(payment_date) as `quarter`,
    MONTH(payment_date) as `month`,
    DAY(payment_date) as `day`,
    Week(payment_date) as `week`,
    IF(Weekday(payment_date) IN (6, 7), True, False) as `is_weekend`
FROM
    payment
WHERE
    DATE_FORMAT(payment_date, "%Y-%m-%d") = '{{ prev_ds }}';

INSERT INTO
    dimMovie(
        movie_key,
        film_id,
        title,
        description,
        release_year,
        `language`,
        original_language,
        rental_duration,
        `length`,
        rating,
        special_features
    )
SELECT
    film_id as `movie_key`,
    film_id,
    title,
    description,
    release_year,(
        SELECT
            name
        FROM
            language
        WHERE
            `language_id` = f.language_id
    ) as `language`,(
        SELECT
            name
        FROM
            language
        WHERE
            `language_id` = f.original_language_id
    ) as original_language,
    rental_duration,
    `length`,
    rating,
    special_features
FROM
    payment P
    INNER JOIN rental r ON (r.rental_id = P.rental_id)
    INNER JOIN inventory i ON(i.inventory_id = r.inventory_id)
    INNER Join film f ON(f.film_id = i.film_id)
WHERE
    DATE_FORMAT(P.payment_date, "%Y-%m-%d") = '{{ prev_ds }}'
ON DUPLICATE KEY UPDATE;

INSERT INTO
    dimStore(store_key,store_id,address,address2,district,city,country,postal_code,manager_first_name,
    manager_last_name)
SELECT
	St.store_id as `store_key`,
    St.store_id,
    ad.address,
    ad.address2,
    ad.district,
    c.city,
    con.country,
    ad.postal_code,
    Sta.first_name,
    Sta.last_name
FROM
    payment P
    INNER JOIN rental r ON (r.rental_id = P.rental_id)
    INNER JOIN inventory i ON (i.inventory_id = r.inventory_id)
    INNER Join store St ON (St.store_id = i.store_id)
    INNER Join address ad ON (St.address_id = ad.address_id)
    INNER Join city c ON (c.city_id = ad.city_id)
    INNER Join country con ON (con.country_id = c.country_id)
    INNER Join staff Sta ON (Sta.staff_id = St.manager_staff_id)
WHERE
    DATE_FORMAT(P.payment_date, "%Y-%m-%d") = '{{ prev_ds }}'
ON DUPLICATE KEY UPDATE;

INSERT INTO
    dimCustomer(customer_key,customer_id,first_name,last_name,email,address,address2,district,city,
    country,postal_code,phone,active,create_date)
SELECT
	cus.customer_id as `customer_key`,
    cus.customer_id,
    cus.first_name,
    cus.last_name,
    cus.email,
    ad.address,
    ad.address2,
    ad.district,
    ci.city,
    con.country,
    ad.postal_code,
    ad.phone,
    cus.active,
    cus.create_date
FROM
    customer cus
    INNER JOIN address ad ON (ad.address_id = cus.address_id)
    INNER JOIN city ci ON (ci.city_id = ad.city_id)
    INNER JOIN country con ON (con.country_id = ci.country_id)
    INNER JOIN payment ON (payment.customer_id = cus.customer_id)
WHERE
    DATE_FORMAT(payment_date, "%Y-%m-%d") = '{{ prev_ds }}'
ON DUPLICATE KEY UPDATE;

INSERT INTO
    fact_sales(
        date_key,
        customer_key,
        movie_key,
        store_key,
        sales_amount
    )
SELECT
    CAST(DATE_FORMAT(P.payment_date, "%y%m%d") AS UNSIGNED) as `date_key`,
    P.customer_id as `customer_key`,
    f.film_id as `movie_key`,
    i.store_id as `store_key`,
    P.amount as `sales_amount`
FROM
    payment P
    INNER JOIN rental r ON (r.rental_id = P.rental_id)
    INNER JOIN inventory i ON (i.inventory_id = r.inventory_id)
    INNER Join film f ON (f.film_id = i.film_id)
WHERE
    DATE_FORMAT(P.payment_date, "%Y-%m-%d") = '{{ prev_ds }}';
