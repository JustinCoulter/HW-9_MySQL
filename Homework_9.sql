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
SELECT film.film_id, film.title, SUM(film_actor.actor_id)
FROM film
INNER JOIN film_actor
ON film.film_id = film_actor.film_id
GROUP BY film.film_id;
#6d
SELECT film_id, title
FROM sakila.film
where title = 'Hunchback Impossible';
SELECT SUM(inventory.film_id)
FROM inventory
WHERE film_id = 439;
#6e
USE sakila;
SELECT payment.customer_id, customer.first_name, customer.last_name, SUM(payment.amount)
FROM  payment 
INNER JOIN customer 
ON payment.customer_id = customer.customer_id
GROUP BY payment.customer_id
ORDER BY last_name;





