create table if not exists customer_20240301 (
  customer_id int4 PRIMARY KEY
  ,first_name varchar(50)
  ,last_name varchar(50) 
  ,gender varchar(30)
  ,DOB varchar(50)
  ,job_title varchar(50)
  ,job_industry_category varchar(50)
  ,wealth_segment varchar(50)
  ,deceased_indicator varchar(50) 
  ,owns_car varchar(30)
  ,address varchar(50)
  ,postcode varchar(30)
  ,state varchar(30)
  ,country varchar(30)
  ,property_valuation int4
);

create table if not exists transaction_20240301 (
  transaction_id int4 PRIMARY KEY
  ,product_id int4 
  ,customer_id int4
  ,transaction_date varchar(30) 
  ,online_order varchar(30) 
  ,order_status varchar(30)
  ,brand varchar(30) 
  ,product_line varchar(30)
  ,product_class varchar(30)
  ,product_size varchar(30)
  ,list_price float4
  ,standard_cost float4
);


-- #1
select job_industry_category, count(*)
from customer_20240301
group by job_industry_category
order by count(*) desc; 

-- #2
select date_trunc('month', tr.transaction_date::date) as transaction_date_month
	, c.job_industry_category
	, sum(tr.list_price)
from transaction_20240301 tr join customer_20240301 c on c.customer_id = tr.customer_id
group by date_trunc('month', tr.transaction_date::date), c.job_industry_category
order by transaction_date_month, c.job_industry_category;

-- #3
select tr.brand, count(*)  
from transaction_20240301 tr join customer_20240301 c on c.customer_id = tr.customer_id
where c.job_industry_category = 'IT' 
	  and tr.online_order = 'True'
	  and tr.order_status = 'Approved'
group by tr.brand
order by count(*) desc;

-- #4_1
select tr.customer_id
	,sum(tr.list_price) as sum_tr
	,max(tr.list_price) as max_tr
	,min(tr.list_price) as min_tr
	,count(*)
from transaction_20240301 tr join customer_20240301 c on c.customer_id = tr.customer_id
group by tr.customer_id
order by sum_tr desc, count(*) desc;

-- #4_2
select tr.customer_id
	,sum(tr.list_price) over(partition by tr.customer_id) as sum_tr
	,max(tr.list_price) over(partition by tr.customer_id) as max_tr
	,min(tr.list_price) over(partition by tr.customer_id) as min_tr
	,count(tr.list_price) over(partition by tr.customer_id) as count_tr
from transaction_20240301 tr join customer_20240301 c on c.customer_id = tr.customer_id
order by sum_tr desc, count_tr desc;

-- #5_min
with agr_table as (
	select c.customer_id
		  ,c.first_name
		  ,c.last_name
		  ,sum(tr.list_price) as sum_tr
	from transaction_20240301 tr join customer_20240301 c on c.customer_id = tr.customer_id
	group by c.customer_id
)
select agr.customer_id
	  ,agr.first_name
	  ,agr.last_name
	  ,agr.sum_tr
from agr_table agr
where agr.sum_tr = (select min(agr.sum_tr) from agr_table agr) and agr.sum_tr is not null;

-- #5_max
with agr_table as (
	select c.customer_id
		  ,c.first_name
		  ,c.last_name
		  ,sum(tr.list_price) as sum_tr
	from transaction_20240301 tr join customer_20240301 c on c.customer_id = tr.customer_id
	group by c.customer_id
)
select agr.customer_id
	  ,agr.first_name
	  ,agr.last_name
	  ,agr.sum_tr
from agr_table agr
where agr.sum_tr = (select max(agr.sum_tr) from agr_table agr) and agr.sum_tr is not null;

-- #6
select distinct c.customer_id
	  ,first_value(tr.transaction_date::date) over(partition by tr.customer_id order by tr.transaction_date::date)
from transaction_20240301 tr join customer_20240301 c on c.customer_id = tr.customer_id
order by c.customer_id

-- #7
with date_table as (
	select c.customer_id
		  ,c.first_name
		  ,c.last_name
		  ,c.job_title
		  ,tr.transaction_date::date 
		  ,lag(tr.transaction_date::date) over(partition by tr.customer_id order by tr.transaction_date::date) as lag_
	from transaction_20240301 tr join customer_20240301 c on c.customer_id = tr.customer_id
)
select dt.customer_id
	  ,dt.first_name
	  ,dt.last_name
	  ,dt.job_title
	  ,dt.transaction_date::date - lag_ as diff
from date_table dt
where dt.transaction_date::date - lag_ = (
	select max(dt.transaction_date::date - lag_)
	from date_table dt
	where dt.lag_ is not null 
	);