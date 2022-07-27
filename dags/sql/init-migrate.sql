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
    payment;

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
        From
            language
        Where
            `language_id` = f.language_id
    ) as `language`,(
        SELECT
            name
        From
            language
        Where
            `language_id` = f.original_language_id
    ) as original_language,
    rental_duration,
    `length`,
    rating,
    special_features
From
    film f;

INSERT INTO
    dimStore(store_key,store_id,address,address2,district,city,country,postal_code,manager_first_name,
    manager_last_name,start_date,end_date)
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
    Sta.last_name,
    now(),
    now()
From
    store St
    Inner Join address ad On (St.address_id = ad.address_id)
    Inner Join city c On (c.city_id = ad.city_id)
    Inner Join country con On (con.country_id = c.country_id)
    Inner Join staff Sta On (Sta.staff_id = St.manager_staff_id);

INSERT into
    dimCustomer(customer_key,customer_id,first_name,last_name,email,address,address2,district,city,
    country,postal_code,phone,active,create_date,start_date,end_date)
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
    cus.create_date,
    Now(),
    Now()
From
    customer cus
    Inner JOIN address ad On (ad.address_id = cus.address_id)
    Inner Join city ci On(ci.city_id = ad.city_id)
    INNER Join country con On(con.country_id = ci.country_id);

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
From
    payment P
    Inner JOIN rental r on (r.rental_id = P.rental_id)
    inner JOIN inventory i On(i.inventory_id = r.inventory_id)
    Inner Join film f On(f.film_id = i.film_id);
