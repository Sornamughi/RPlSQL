-- drop table  if exists customers;
-- drop table  if exists contacts;

create table customers(
 id int primary key,
	name varchar(20),
	area varchar(20)
);

create table contacts(
	id int,
	city varchar(25),
	constraint forKey_customers
	foreign key (id)
	references customers(id)
	
);

insert into customers values (1, 'vp', 'madurai');
insert into customers values (2, 'ramesh', 'chennai');
insert into customers values (3, 'vp-ram', 'zurich');
insert into customers values (4, 'ramvp', 'london');

insert into contacts values (1, 'TN');
insert into contacts values (2, 'IN');
insert into contacts values (3, 'SW');
insert into contacts values (4, 'UK');

select * from customers;

select * from contacts;

-- Left join print all the columns from both tables but full values from left table and matching values from right table and null values for the rest
select * from customers cu left join contacts ca on cu.id = ca.id and cu.id=1 ; 

-- Right join print all the columns from both tables but full values from right table and matching values from left table and null values for the rest
select * from customers cu right join contacts ca on cu.id = ca.id and cu.id=1 ; 

--inner join.. only take the matching fields from both table
select * from customers cu,contacts ca where cu.id = ca.id and cu.id=1

--union prints results from the tables where same columns are available
--union does not print duplicate values
select id from customers union 
select id from contacts; 

--union does print duplicate values as well
select id from customers union all
select id from contacts; 

-- case example
select 
	case 
		when id = 1 THEN 'first customer' 
		when id = 2 THEN 'second customer' 
		else 'Not a first two customers'
	end AS customer_identity 
from customers; -- case

 --Get distinct without distinct (from same table)
select contact_name from contacts union
select contact_name from contacts;

-- series generate
SELECT generate_series(1, 100); 

-- Example for the deletion of duplicate rows

drop table if exists basket;

CREATE TABLE basket(
    id SERIAL PRIMARY KEY,
    fruit VARCHAR(50) NOT NULL
);

INSERT INTO basket(fruit) values('apple');
INSERT INTO basket(fruit) values('apple');
INSERT INTO basket(fruit) values('orange');
INSERT INTO basket(fruit) values('orange');
INSERT INTO basket(fruit) values('orange');
INSERT INTO basket(fruit) values('banana');

select * from basket;

select fruit, count(fruit) from basket 
group by fruit having count(fruit) > 1 order by 2 desc;

-- deleting only the duplicate by implementing using function

delete FROM basket a using basket b WHERE a.id > b.id 
AND a.fruit = b.fruit;

select distinct fruit, id from basket;

--How to remove duplicate rows with temp
-- step 1: creating replica of the actual table
CREATE TABLE basket_temp (LIKE basket);
-- step 2
INSERT INTO basket_temp(fruit, id) SELECT DISTINCT ON (fruit) fruit, id FROM basket; 
-- step 3
DROP TABLE basket;
-- step 4
ALTER TABLE basket_temp RENAME TO basket;           

--  with provides auxilary statement to break down larger queries into simpler form
with cust_table as (select id,name from customers)
select * from cust_table;

