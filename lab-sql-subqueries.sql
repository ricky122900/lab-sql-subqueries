USE sakila;

-- #1 
SELECT COUNT(*) AS number_of_copies 
FROM inventory 
WHERE 
    film_id = (SELECT film_id FROM film WHERE title = 'Hunchback Impossible');

-- #2 
SELECT title, length 
FROM film 
WHERE 
    length > (SELECT AVG(length) FROM film);

-- #3 
SELECT a.first_name, a.last_name 
FROM actor AS a 
WHERE 
    a.actor_id IN (SELECT fa.actor_id 
                   FROM film_actor AS fa 
                   JOIN film AS f ON fa.film_id = f.film_id 
                   WHERE f.title = 'Alone Trip');

-- BONUS 
-- #4
SELECT title AS family_films
FROM film 
WHERE 
    film_id IN (
        SELECT fc.film_id 
        FROM film_category AS fc 
        JOIN category AS c ON fc.category_id = c.category_id 
        WHERE c.name = 'Family'
    );

-- #5 
SELECT first_name, last_name, email 
FROM customer 
WHERE 
    address_id IN (SELECT address_id 
                   FROM address 
                   WHERE city_id IN (SELECT city_id 
                                     FROM city 
                                     WHERE country_id = (SELECT country_id 
                                                         FROM country 
                                                         WHERE country = 'Canada')));

SELECT c.first_name, c.last_name, c.email 
FROM customer AS c 
JOIN 
    address AS a ON c.address_id = a.address_id 
JOIN 
    city AS ci ON a.city_id = ci.city_id 
JOIN 
    country AS co ON ci.country_id = co.country_id 
WHERE 
    co.country = 'Canada';

-- #6 
SELECT actor_id 
FROM film_actor 
GROUP BY actor_id 
ORDER BY 
    COUNT(film_id) DESC 
LIMIT 1;

SELECT f.title 
FROM film AS f 
JOIN 
    film_actor AS fa ON f.film_id = fa.film_id 
WHERE 
    fa.actor_id = (SELECT actor_id 
                   FROM film_actor 
                   GROUP BY actor_id 
                   ORDER BY COUNT(film_id) DESC 
                   LIMIT 1);

-- #7 
SELECT customer_id 
FROM payment 
GROUP BY customer_id 
ORDER BY SUM(amount) DESC 
LIMIT 1;

SELECT f.title 
FROM film AS f 
JOIN 
    inventory AS i ON f.film_id = i.film_id 
JOIN 
    rental AS r ON i.inventory_id = r.inventory_id 
WHERE 
    r.customer_id = (SELECT customer_id 
                     FROM payment 
                     GROUP BY customer_id 
                     ORDER BY SUM(amount) DESC 
                     LIMIT 1);

-- #8 
SELECT AVG(total_amount) 
FROM 
    (SELECT 
         customer_id, 
         SUM(amount) AS total_amount 
     FROM payment 
     GROUP BY customer_id) AS avg_total;

SELECT customer_id, 
    SUM(amount) AS total_amount_spent 
FROM payment 
GROUP BY customer_id 
HAVING 
    total_amount_spent > (SELECT AVG(total_amount) 
                          FROM 
                              (SELECT customer_id, 
                                   SUM(amount) AS total_amount 
                               FROM payment 
                               GROUP BY customer_id) AS avg_total);