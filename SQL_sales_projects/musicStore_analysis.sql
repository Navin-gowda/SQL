Q1.who is the senior most employee based on job title
select * from emplyoee
order by levels desc limit 1
Q2.Which country has most invoice
select count(*) as total,billing_country from
	invoice group by 
	billing_country order by total desc;
Q3.What are top three values of total invoice
select total from invoice order by total desc limit 3
q4.city which has highest sum of invoice total.return both city and all invoice 
select sum(total) as invoice_total,billing_city
from invoice group by billing_city
order by invoice_total desc limit 2;
Q5.who is the besr customer?the customer who has spent the most  money will be declared the best customer
select 
	customer.customer_id,
	customer.first_name,
	customer.last_name,
	sum(invoice.total) as total from
 customer 
join
invoice on 
customer.customer_id=invoice.customer_id 
group by 
	customer.customer_id,customer.first_name,customer.last_name
	order by total desc
	limit 5;

Q6.Write query to return the email,f_name last name & genre of all rock music listners.return your list orderd alphabetically by email starting with A.
select email,first_name,last_name
from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
where track_id in(
	select track_id from tracks
	join genre on tracks.genre_id=genre.genre_id
	where genre.name like 'Rock'
)
order by email;
Q7.write a query that return artist name and totalt track count of music in top 10 rock bands
select artist.artist_id,artist.name,count(artist.artist_id) as number_of_songs
from tracks
join album2 on album2.album_id=tracks.album_id
join artist on artist.artist_id=album2.artist_id
join genre on genre.genre_id=tracks.genre_id 
	where genre.name='Rock'
group by artist.artist_id order by number_of_songs desc
	limit 10;
Q8.Return all the track names that have a song length longer than the average song length.REturn the Name and Millisenconds for each track.Order by the song length with the longest songs listed first
 
select name, milliseconds from tracks where milliseconds>(
select avg(milliseconds) from tracks)
order by milliseconds desc;

Q9.find how much amount spent by each customer on artist?rite a query to return customer name, srtisr name and total spent
with best_selling_artist AS(
	select artist.artist_id AS artist_id,artist.name AS artist_name,
	sum(invoice_line.unit_prise*invoice_line.quantity) AS total_sales
	from invoice_line
	join tracks on tracks.track_id=invoice_line.track_id
	join album2 on album2.album_id=tracks.album_id
	join artist on artist.artist_id=album2.artist_id
	group by 1,2
	order by 3
)
	
select c.customer_id,c.first_name,c.last_name,bsa.artist_name,
sum(il.unit_prise*il.quantity) as amount_spent
from invoice i
join customer c on c.customer_id=i.customer_id
join invoice_line il on il.invoice_id=i.invoice_id
join tracks t on t.track_id=il.track_id
join album2 alb on alb.album_id=t.album_id
join best_selling_artist bsa ON bsa.artist_id=alb.artist_id
group by 1,2,3,4
order by 5 desc;

Q10.We want to find out the most popular music genre for each country. we determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top genre.For countries where the maximum number of purchase is shared return all genres.

with popular_genre as(
	select count(invoice_line.quantity) as purchace,customer.country,genre.name,genre.genre_id,
	row_number() over(partition by customer.country order by count(invoice_line.quantity) desc) as rowNO
	from invoice_line
	join invoice on invoice.invoice_id=invoice_line.invoice_id
 	join customer on invoice.customer_id=customer.customer_id
	join tracks on tracks.track_id=invoice_line.track_id
	join genre on genre.genre_id=tracks.genre_id
	group by 2,3,4
	order by 2 asc,1 desc
	) 
select * from popular_genre where rowNo<=1

Q11.write a query that determines the customer that has spent the most on music for each country. write a query that returns the country along with the top customer and how much they spent. for countries where the top amount spent is shared, provide all customers who spent this amount


with customer_with_country as(
	select customer.customer_id,first_name,last_name,country,sum(total) as total_spending,
	row_number() over(partition by country order by sum(total) desc) as rowNo
	from invoice
	join customer on customer.customer_id=invoice.customer_id
	group by 1,2,3,4
	order by 4 asc,5 desc
)
select *from customer_with_country
