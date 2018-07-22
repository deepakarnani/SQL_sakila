use sakila;
-- 1a
select * from actor;
-- 1b
select concat(upper(first_name),' ',upper(last_name)) as 'Actor Name' from actor;
-- 2a
select * from actor where first_name = 'Joe';
-- 2b
select * from actor where last_name like '%GEN%';
-- 2c
select last_name, first_name from actor where last_name like '%LI%';
-- 2d
select * from country where country IN('Afghanistan', 'Bangladesh', 'China');
-- 3a
alter table actor add middle_name varchar(30) after first_name;
-- 3b
select * from actor;
alter table actor modify column middle_name blob;
desc actor;
-- 3c
alter table actor drop column middle_name;
select * from actor;
-- 4a
SELECT COUNT(last_name), last_name
FROM actor
GROUP BY last_name;
-- 4b
SELECT COUNT(last_name) as last_name_count, last_name
FROM actor
GROUP BY last_name
having last_name_count >= 2;
-- 4c
update actor
set first_name = 'Harpo'
where first_name = 'GROUCHO' and last_name = 'WILLIAMS';
-- 4d skipped
 
-- 5a
show create table address;
desc address;

select st.first_name, st.last_name, ad.address, ad.address2, ad.district, ad.city_id, ad.postal_code 
from staff st
inner join address ad on st.address_id = ad.address_id
;

select st.staff_id, st.first_name, st.last_name, pay.amount 
from staff st
inner join payment pay on st.staff_id = pay.staff_id
group by st.staff_id
;
-- 6c. List each film and the number of actors who are listed for that film.
select f.title, count(fa.actor_id)
from film_actor fa
inner join film f on fa.film_id = f.film_id
group by f.title
;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select f.film_id, f.title, count(i.inventory_id)
from inventory i
inner join film f on i.film_id = f.film_id
where f.title = 'Hunchback Impossible'
;

-- list the total paid by each customer. List the customers alphabetically by last name:

select p.customer_id, last_name, sum(amount)
from payment p
join customer c on p.customer_id = c.customer_id
group by 1, 2 
;

-- 7adisplay movies starting letters K and Qlanguage is English.
select f.film_id, f.title
from film f
where f.title like 'Q%' or 'K%' in
(
select f.language_id
from film f
inner join language l on l.language_id = f.language_id
where l.name = 'English'
)
;

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select a.first_name, a.last_name
from film_actor fa
inner join actor a on a.actor_id = fa.actor_id
where fa.film_id in
(
select f.film_id
from film f
where title = 'Alone Trip'
)
;

-- 7c names and email addresses of all Canadian customers.
select c.customer_id, c.first_name, c.last_name, c.email, country
from customer c
inner join address a on c.address_id = a.address_id
inner join city on city.city_id = a.city_id
inner join country on city.country_id = country.country_id
where country = 'Canada';

-- 7d movies categorized as family films.
/*select f.film_id, f.title
from category c
inner join film_category fc on c.category_id = fc.category_id
inner join film_text ft on ft.film_id = fc.film_id
inner join film f on ft.film_id = f.film_id
where c.category_id in
(
select c.name
from category c
where c.name = "%family%"
)
;*/


SELECT title, category
FROM film_list
WHERE category='Family';

-- 7e. Display the most frequently rented movies in descending order.
SELECT f.title, COUNT(r.inventory_id) AS Rental_Count
from inventory i
inner join rental r on r.inventory_id = i.inventory_id
inner join film f on f.film_id = i.film_id
group by 1
ORDER BY 2 DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.

create view total_sales as (

SELECT s.store_id, SUM(amount) AS Gross
             FROM payment p
             JOIN rental r
             ON (p.rental_id = r.rental_id)
             JOIN inventory i
             ON (i.inventory_id = r.inventory_id)
             JOIN store s
             ON (s.store_id = i.store_id)
             GROUP BY s.store_id
             )
             ;
             
select * from total_sales
;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, city, country
FROM store s
INNER JOIN customer cu ON s.store_id = cu.store_id
INNER JOIN address a ON cu.address_id = a.address_id
INNER JOIN city ci ON a.city_id = ci.city_id
INNER JOIN country coun ON ci.country_id = coun.country_id;

-- 7h. List the top five genres in gross revenue in descending order. 
SELECT c.category_id, c.name
FROM category c
inner join film_category fc on c.category_id = fc.category_id
INNER JOIN inventory i on i.film_id = fc.film_id
INNER JOIN rental r ON r.inventory_id = i.inventory_id
INNER JOIN payment p ON p.rental_id = r.rental_id
GROUP BY c.name
LIMIT 5;



-- Create view and display of 7h
create view top_five_genres as
(
SELECT c.category_id, c.name
		FROM category c
		inner join film_category fc on c.category_id = fc.category_id
		INNER JOIN inventory i on i.film_id = fc.film_id
		INNER JOIN rental r ON r.inventory_id = i.inventory_id
		INNER JOIN payment p ON p.rental_id = r.rental_id
		GROUP BY c.name
		LIMIT 5
)
;

select * from top_five_genres;

-- 8c
drop view top_five_genres;
-- ------------------------------------------------------------------------------
