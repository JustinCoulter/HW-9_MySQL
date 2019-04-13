# 1a. 
SELECT first_name, last_name FROM sakila.actor;
# 1b. 
USE sakila;
ALTER TABLE actor
ADD Actor_Name varchar(30);
SET SQL_SAFE_UPDATES=0;
UPDATE actor SET Actor_Name = CONCAT(first_name, ' ', last_name);
SELECT Actor_Name FROM sakila.actor;

#2a.
SELECT actor_id, first_name, last_name
FROM sakila.actor
WHERE first_name = 'JOE';
#2b.
SELECT Actor_Name FROM sakila.actor
where last_name LIKE '%GEN%';
#2c.
SELECT * FROM sakila.actor
where last_name LIKE '%LI%'
ORDER BY first_name;
SELECT * FROM sakila.actor
where last_name LIKE '%LI%'
ORDER BY last_name;
#2d.
SELECT country_id, country FROM sakila.country
where country IN ('Afghanistan','Bangladesh', 'China');

#3a.
ALTER TABLE actor
ADD description BLOB;
SELECT * FROM sakila.actor;
#3b.
ALTER TABLE actor
DROP description;
SELECT * FROM sakila.actor;

#4a.
SELECT last_name, COUNT(last_name) AS counts
FROM sakila.actor
GROUP BY last_name;
#4b.
SELECT last_name, COUNT(last_name) AS counts 
FROM sakila.actor
GROUP BY last_name
HAVING COUNT(last_name) > 1;
#4c.
SET SQL_SAFE_UPDATES=0;
UPDATE actor
SET first_name = 'Harpo', Actor_Name = 'Harpo Williams'
WHERE Actor_Name = 'GROUCHO WILLIAMS';
SELECT *
FROM sakila.actor
WHERE Actor_Name like 'Harpo Williams';
#4d.
UPDATE actor
SET first_name = 'Groucho', Actor_Name = 'Groucho Williams'
WHERE Actor_Name  = 'Harpo Williams';

#5a.
SHOW CREATE TABLE address;

#6a.
USE sakila;
SELECT staff.first_name, staff.last_name, address.address
FROM staff 
JOIN address 
ON staff.address_id = address.address_id;
#6b.
CREATE TABLE staff_payment
SELECT staff.staff_id, staff.first_name, staff.last_name, SUM(payment.amount)
FROM staff
JOIN payment
ON staff.staff_id = payment.staff_id
GROUP BY staff_id;
#6c.
USE sakila;
SELECT film.film_id, film.title, COUNT(film_actor.actor_id) AS number_of_actors
FROM film
INNER JOIN film_actor
ON film.film_id = film_actor.film_id
GROUP BY film.film_id;
#6d
SELECT film_id, title
FROM sakila.film
where title = 'Hunchback Impossible';
SELECT COUNT(inventory.film_id)
FROM inventory
WHERE film_id = 439;
#6e
USE sakila;
SELECT payment.customer_id, customer.first_name, customer.last_name, SUM(payment.amount) AS total_paid
FROM  payment 
INNER JOIN customer 
ON payment.customer_id = customer.customer_id
GROUP BY payment.customer_id
ORDER BY last_name;

#7a.
USE sakila;
SELECT title
FROM film
WHERE (title LIKE 'K%' or title LIKE 'Q%') and language_id = 1;

#7b.
SELECT first_name, last_name
FROM actor 
WHERE actor_id IN (
	SELECT actor_id 
	FROM film_actor
	WHERE film_id =(
		SELECT film_id 
		FROM film 
		WHERE title = 'Alone Trip'));
        
#7c.
SELECT a.first_name, a.last_name, a.email
FROM customer a
JOIN address b
ON a.address_id = b.address_id
WHERE b.address_id IN (
	SELECT b.address_id
	FROM city a
	JOIN address b
	ON a.city_id = b.city_id
	WHERE country_id = (SELECT country_id
		FROM country
		WHERE country = 'Canada'));
        
#7d.
SELECT title 
FROM film
WHERE film_id IN (
	SELECT film_id
	FROM film_category
	WHERE category_id IN (
		SELECT category_id
		FROM category
		WHERE name = 'family'));
        
#7e.
USE sakila;
CREATE VIEW rental_count AS
SELECT a.film_id, count(a.film_id) AS rental_count
FROM inventory a
JOIN rental b
ON a.inventory_id = b.inventory_id
GROUP BY film_id;

SELECT a.title, b.film_id, b.rental_count
FROM film a
JOIN rental_count b
ON a.film_id = b.film_id
ORDER BY rental_count DESC;

#7f.
USE sakila;
SELECT sales_by_store.store, CONCAT('$', sales_by_store.total_sales) AS total_sales
FROM sales_by_store;

#7g.

CREATE VIEW store_address AS
SELECT a.store_id, a.address_id, b.address, b.city_id, b.district
FROM store a
JOIN address b
ON a.address_id = b.address_id;
CREATE VIEW store_city AS
SELECT city.city, store_address.store_id, store_address.address, store_address.district, store_address.city_id, city.country_id
FROM store_address
LEFT JOIN city
ON store_address.city_id = city.city_id;
SELECT a.store_id, a.city, b.country
FROM store_city a
JOIN country b
ON a.country_id = b.country_id;

#7h. (easy way)
SELECT category, total_sales
FROM sales_by_film_category
ORDER BY total_sales DESC
LIMIT 5;

#7h. (hard way)
USE sakila;
SELECT category.name, SUM(payment.amount) AS total_sales
FROM rental
JOIN payment ON rental.rental_id = payment.rental_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film_category ON film_category.film_id = inventory.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY total_sales DESC
LIMIT 5;

#8a.(easy way)
CREATE VIEW top_five_genres AS
SELECT category, total_sales
FROM sales_by_film_category
ORDER BY total_sales DESC
LIMIT 5;

#8a.(hard way)
CREATE VIEW top_five_genres_1 AS
SELECT category.name, SUM(payment.amount) AS total_sales
FROM rental
JOIN payment ON rental.rental_id = payment.rental_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film_category ON film_category.film_id = inventory.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY total_sales DESC
LIMIT 5;

#8b.
SELECT * FROM top_five_genres;

#8c
DROP VIEW top_five_genres;
