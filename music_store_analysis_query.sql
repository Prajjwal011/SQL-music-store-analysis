/* Q1: Who is the senior most employee based on job title ? */
select * from employee 
order by levels desc 
limit 1;

/* Q2: Which countries have the most invoices ? */
select billing_country, count(total) as total_invoice from invoice
group by billing_country 
order by total_invoice desc;


/* Q3 What are top 3 values of total invoice ? */
select total from invoice
order by total desc 
limit 3;

/* Q4 Which city has the best customers? We would like to throw a promotional 
Music Festival in the city we made the most money. Write a query that returns one 
city that has the highest sum of invoice totals.Return both the city name & sum of 
all invoice totals. 
*/

select billing_city, sum(total) as invoice_total from invoice
group by billing_city
order by invoice_total desc 
limit 1;

/* Q5: Who is the best customer? The customer who spent the most money will be 
declared the best customer. Write a query that returns the person who has the spent 
the most money
*/
select c.first_name, c.last_name, sum(i.total) as total_spent
from customer as c
inner join invoice as i
on c.customer_id = i.customer_id
group by 1,2
order by total_spent desc
limit 1;

/*
Q6: Write query to return the email,first name , last name, and Genre of all Rock 
Music listeners. Return your list ordered alphabetically by emial starting with A.
*/

select distinct c.email,c.first_name, c.last_name 
from customer as c
join invoice as n
on c.customer_id = n.customer_id
join invoice_line as nl
on n.invoice_id = nl.invoice_id
where track_id in(
	select track_id from track
	join genre
	on track.genre_id = genre.genre_id
	where genre.name like 'Rock'
)
order by c.email asc;

/*
Q.7: Let's invite the artist who have written the most rock music in our dataset.
Write a query that returns the Artist name and total track count of the top 10 rock 
bands.
*/

select count(name) from artist
group by artist_id
order by count(name) desc;
select * from track;

select a.artist_id, a.name, count(a.name) as total
from artist as a
join album as ab
on a.artist_id = ab.artist_id
join track
on ab.album_id = track.album_id
join genre as g
on track.genre_id = g.genre_id
where g.name like 'Rock'
group by a.artist_id
order by total desc
limit 10;

/*
Q.8: Return all the track names that have a song length longer than the average song
length. Return the Name and Milliseconds for each track. Order by the song length 
withthe longest songs listed first.
*/

select * from track
select name, milliseconds
from track
where milliseconds > (select avg(milliseconds ) from track as track_length)
order by milliseconds desc;


/*
Q9: Find how much amount spent by each customer on artists? Write a query to return 
customer name, artist name and total spent
*/

select c.first_name, c.last_name, art.name, sum(il.unit_price*il.quantity) as total_spent
from customer as c 
inner join invoice as i 
on c.customer_id = i.customer_id
inner join invoice_line as il
on i.invoice_id = il.invoice_id
inner join track as t
on il.track_id = t.track_id
inner join album as ab
on t.album_id = ab.album_id
inner join artist as art
on ab.artist_id = art.artist_id
group by c.first_name, c.last_name,art.name
order by total_spent desc;

/*
Q10: We want to find out the most popular music Genre for each country. We determine 
the most popular genre as the genre with the highest amount of purchases. Write a 
query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres
*/

with popular_genre as 
(
	SELECT COUNT(il.quantity) AS purchases,c.country,g.name,g.genre_id,
	ROW_NUMBER() OVER(PARTITION BY c.country ORDER BY COUNT(il.quantity) DESC) as rowNO
	FROM invoice_line as il
	JOIN invoice ON il.invoice_id = invoice.invoice_id
	JOIN customer AS C ON invoice.customer_id = c.customer_id 
	JOIN track AS t ON il.track_id = t.track_id
	JOIN genre AS g ON t.genre_id = g.genre_id
	GROUP BY c.country,g.name,g.genre_id
	ORDER BY 2 ASC, 1 DESC
)

SELECT * FROM popular_genre where rowno <= 1;

/* 
Q11: Write a query that determines the customer that has spent the most on music 
for each country. Write a query that returns the country along with the top 
customer and how much they spent. For countries where the top amount spent is 
shared, provide all customers who spent this amount */

WITH Customer_with_country AS(
	SELECT c.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) as rowNo
	FROM invoice as i
	JOIN customer as c ON c.customer_id = i.customer_id
	GROUP BY 1,2,3,4
	ORDER BY 4 ASC,5 DESC
)
SELECT * FROM Customer_with_country
WHERE rowNo <= 1

	
	
	
	
	
	