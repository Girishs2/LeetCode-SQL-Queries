create database Leetcode
-----------------------------------------------------------------------------------------------------------------------------------------------------
create table Orders(order_number int primary key, customer_number int)
insert into Orders values(1,1),(2,2),(3,3),(4,3)
select * from Orders

--Q1)Write an SQL query to find the customer_number for the customer who has placed the largest number of orders.

with cte5 as(
select customer_number, count(order_number) as order_number from Orders
group by customer_number)
select customer_number from cte5
where order_number = (select max(order_number) from cte5 )

--OR--

select customer_number from Orders
where order_number = (select max(order_number) from Orders)

------------------------------------------------------------------------------------------------------------------------------------------------------

create table customers(id int, name varchar(10))
insert into customers values(1,'joe'),(2,'henry'),(3,'sam'),(4,'max')
create table orders1(id int, customer_id int)
insert into orders1 values(1,3),(2,1)

select * from customers
select * from orders1

--Q2)Write an SQL query to report all customers who never order anything.

select name from customers where id not in (
select customer_id from orders1)

---------------------------------------------------------------------------------------------------------------------------------------------------------

create table Employee (id int, name varchar(10), salary int, departmentId int)
create table [Department](id int, dep_name varchar(10))

insert into Employee values(1, 'Joe', 70000, 1), (2, 'Jim', 90000, 1), (3, 'Henry', 80000, 2), (4, 'Sam', 60000, 2),
(5, 'Max', 90000, 1)
insert into [Department] values(1, 'IT'), (2, 'Sales')

select * from Employee
select * from [Department]

--Q3)Write an SQL query to find employees who have the highest salary in each of the departments.
--  Return the result table in any order.

with cte1 as(
select E.departmentId, E.name, E.salary, d.dep_name, Rank() over(partition by departmentId order by salary desc) as rn
from Employee E left join [Department] d on E.departmentId = d.id
)
select dep_name, name, salary from cte1
where rn =1

-------------------------------------------------------------------------------------------------------------------------------------------------------------

create table Employee1 (id int, name varchar(10), salary int, departmentId int)
create table [Department1](id int, dep_name varchar(10))
insert into Employee1 values(1, 'Joe', 85000, 1), (2, 'Henry', 80000, 2), (3, 'sam', 60000, 2), (4, 'Max', 90000, 1),
(5, 'Janet', 69000, 1),(6,'Randy',85000,1),(7,'Will',70000,1)
insert into [Department1] values(1, 'IT'), (2, 'Sales')
select * from Employee1
select * from [Department1]

--Q4)Write an SQL query to find the employees who are high earners in each of the departments
with cte3 as(
select e.name as Employee, salary, d.dep_name as Department, DENSE_RANK() over(partition by departmentId order by salary desc) as ranks
from Employee1 e left join Department1 d on e.departmentId = d.id)
select Department, Employee, salary from cte3
where ranks <=3

-----------------------------------------------------------------------------------------------------------------------------------------------------------

create table person(person_id int, lastname varchar(10), firstname varchar(10))
create table [address1](addressid int, person_id int, city varchar(10), state varchar(10))
insert into person values(1, 'wang', 'allen'),(2, 'Alice','Bob')
insert into [address1] values(1,2,'New_York_City', 'New_York'),(2,3,'Leetcode','California')
select * from person
select * from address1

---Q5)Write an SQL query to report the first name, last name, city, and state of each person in the Person table.
----If the address of a personId is not present in the Address table, report null instead.
select p.firstname, p.lastname, a.city, a.state from person p left join address1 a on p.person_id = a.person_id

------------------------------------------------------------------------------------------------------------------------------------------------------------

create table Logs(id int identity(1,1), num int)
insert into Logs values(1),(1),(1),(2),(1),(2),(2)
select * from Logs

---Q6)Write an SQL query to find all numbers that appear at least three times consecutively.

select distinct num from(
select num, lag(num) over(order by id) as lag, lead(num) over(order by id) as lead from Logs) a
where num = lag and num = lead

-------------------------------------------------------------------------------------------------------------------------------------------------------------

create table Employee5(id int, name varchar(10), salary int, managerId int)
insert into Employee5 values(1, 'Joe', 70000, 3), (2, 'Henry', 80000, 4), (3, 'Sam', 60000, null),
(4, 'Max', 90000, null)
select * from Employee5

---Q7)Write an SQL query to find the employees who earn more than their managers.

select e1.name from Employee5 e1 inner join	Employee5 e2 on e1.managerId = e2.id
where e1.salary > e2.salary

---------------------------------------------------------------------------------------------------------------------------------------------------------------

create table person3(id int identity(1,1), email varchar(20))
insert into person3 values('john@example.com'),('bob.example.com'),('john@example.com')
select * from person3

---Q8)Write an SQL query to delete all the duplicate emails, 
----keeping only one unique email with the smallest id.
----Note that you are supposed to write a DELETE statement and not a SELECT one

with cte3 as(
select id, email, ROW_NUMBER() over(partition by email order by id) as rn from person2)
delete from cte3
where rn >1 

--OR---

delete p2 from person3 p1 join person3 p2 on p1.email = p2.email and p1.id < p2.id
select * from person3

--------------------------------------------------------------------------------------------------------------------------------------------------------------

create table weather1(id int identity(1,1), Recorddate date, temperature int)
insert into weather1 values('2015-01-01', 10),('2015-01-02', 25),('2015-01-03', 20),('2015-01-04',30)
select * from weather1

----Q9) Write an SQL query to find all dates' Id with higher temperatures compared to its previous dates (yesterday).

select id from (
select id, Recorddate, temperature, lag(temperature) over(order by Recorddate) as previous_day_temp from weather1) a
where temperature > previous_day_temp

select w.id from weather1 w, weather1 w2 where w.temperature > w2.temperature and DATEDIFF(day,  w2.recordDate, w.recordDate) = 1

-------------------------------------------------------------------------------------------------------------------------------------------------------------

create table trips(id int, client_id int, driver_id int, city_id int, status varchar(20), request_at date)
insert into trips values(1, 1, 10, 1, 'completed', '2013-10-01'),
(2, 2, 11, 1, 'cancelled_by_driver', '2013-10-01'),
(3, 3, 12, 6, 'completed', '2013-10-01'), 
(4, 4, 13, 6, 'cancelled_by_client','2013-10-01'),
(5, 1, 10, 1, 'completed', '2013-10-02'),
(6, 2, 11, 6, 'completed', '2013-10-02'),
(7, 3, 12, 6, 'completed', '2013-10-02'),
(8, 2, 12, 12, 'completed', '2013-10-03'),
(9, 3, 10, 12, 'completed', '2013-10-03'),
(10, 4, 13, 12, 'cancelled_by_driver', '2013-10-03')
select * from trips

create table users(user_id int, banned varchar(10), role varchar(10))
insert into users values(1, 'No', 'client'), (2,'Yes', 'client'),
(3, 'No', 'client'), (4, 'No', 'client'),
(10, 'No', 'driver'), (11, 'No', 'driver'), 
(12, 'No', 'driver'), (13, 'No', 'driver')
select * from trips
select * from users

----Q10) The cancellation rate is computed by dividing the number of canceled (by client or driver) requests with unbanned users by 
----	 the total number of requests with unbanned users on that day.

----Write a SQL query to find the cancellation rate of requests with unbanned users (both client and driver must not be banned) 
----each day between "2013-10-01" and "2013-10-03". Round Cancellation Rate to two decimal points.

select request_at, cast(avg(case when status = 'completed' then 0.0 else 1.0 end) as decimal(4,2))as [cancellation Rate] from trips t 
where request_at between '2013-10-01' and '2013-10-03'
and driver_id in( select user_id from users where banned = 'No' and role = 'driver')
and client_id in(select user_id from users where banned ='No' and role ='client')
group by request_at

----------------------------------------------------------------------------------------------------------------------------------------------------------

create table stadium(id int identity(1,1), visit_date date, people int)
insert into stadium values('2017-01-01', 10), ('2017-01-02', 109), ('2017-01-03', 150),
('2017-01-04', 99), ('2017-01-05', 145), ('2017-01-06', 1455), ('2017-01-07', 199), ('2017-01-09', 188)
select * from stadium

-- Q11) Write an SQL query to display the records with three or more rows with consecutive id's,
--and the number of people is greater than or equal to 100 for each.
--Return the result table ordered by visit_date in ascending order.

select id, visit_date, people from stadium 
where people>=100
and ((id+1 in (select id from stadium where people>=100) and id+2 in(select id from stadium where people >=100))
or (id+1 in (select id from stadium where people >= 100) and id-1 in (select id from stadium where people >=100))
or (id-1 in (select id from stadium where people >= 100) and id-2 in (select id from stadium where people >= 100)))

--OR--

with cte6 as
(select id, visit_date, people, lag(people,2) over(order by id) as bef_yestday, lag(people) over(order by id) as ystday,
lead(people) over(order by id) as tomrw, lead(people,2) over(order by id) as aft_tomrw from stadium)
select id, visit_date, people from cte6
where (people>=100 and bef_yestday >=100 and ystday >=100)
or (people>=100 and ystday >=100 and tomrw>=100)
or (people >=100 and tomrw>=100 and aft_tomrw >=100)

----------------------------------------------------------------------------------------------------------------------------------------------------------

create table ActorDirector(actor_id int, director_id int, timestamp int)
insert into ActorDirector values(1,1,0),(1,1,1),(1,1,2),(1,2,3),(1,2,4),(2,1,5),(2,1,6)
select * from ActorDirector

--Q12)Write a SQL query for a report that provides the pairs (actor_id, director_id) 
--  where the actor has cooperated with the director at least three times

select actor_id, director_id from(
select actor_id, director_id, count(director_id) as cnt from ActorDirector
group by actor_id, director_id)a
where a.cnt >=3

----------------------------------------------------------------------------------------------------------------------------------------------------------

create table Salesperson(sales_id int, [name] varchar(10))
insert into  Salesperson values(1,'john'),(2,'amy'),(3,'mark'),(4,'pam'),(5,'alex')

create table company(com_id int identity(1,1), name varchar(10))
insert into company values('RED'),('ORANGE'),('YELLOW'),('GREEN')

create table orders2(order_id int identity(1,1), com_id int, sales_id int)
insert into orders2 values(3,4),(4,5),(1,1),(1,4)

select * from Salesperson
select * from company
select * from orders2

---Q13) Write an SQL query to report the names of all the salespersons who did not have any orders related to the company with the name "RED".

select name from Salesperson where sales_id not in(
select sales_id from orders2 o left join company c on  o.com_id = c.com_id
where c.name = 'RED')

---------------------------------------------------------------------------------------------------------------------------------------------------------

create table tree(id int, p_id int)
insert into tree values(1,null),(2,1),(3,1),(4,2),(5,2)
SELECT * from tree

-----Q14) Each node in the tree can be one of three types:

----"Leaf": if the node is a leaf node.
----"Root": if the node is the root of the tree.
----"Inner": If the node is neither a leaf node nor a root node.

----Write an SQL query to report the type of each node in the tree.
----Return the result table ordered by id in ascending order.

select id,
			case when p_id is null then 'root'
				when id in (
							select distinct p_id from tree
							) 
							then 'inner' else 'leaf' end as [type] from tree
							order by id;

-----------------------------------------------------------------------------------------------------------------------------------------------

create table seat(id int identity(1,1), student varchar(10))
insert into seat values('Abbot'),('Doris'),('Emerson'),('Green'),('Jeams')
select * from seat

--Q15) Write an SQL query to swap the seat id of every two consecutive students. 
------If the number of students is odd, the id of the last student is not swapped.
------Return the result table ordered by id in ascending order

select id,
		case when (id % 2 != 0) then coalesce(lead(student) over(order by id),student)
		when id%2 = 0 then lag(student) over(order by id) end as student 
	from seat order by id














