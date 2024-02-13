create table if not exists customer_20240101 (
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

create table if not exists transaction_20240101 (
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

select distinct brand
from transaction_20240101 
where standard_cost > 1500

select *
from transaction_20240101 
where order_status = 'Approved' 
      and to_date(transaction_date, 'DD/MM/YYYY') between '2017-04-01' and '2017-04-09'
      
select distinct job_title
from customer_20240101
where job_industry_category in ('IT', 'Financial Services')
      and job_title like 'Senior%'
      
select distinct brand
from transaction_20240101 tr
where tr.customer_id in (select c.customer_id from customer_20240101 c where c.job_industry_category = 'Financial Services')
      and tr.brand != ''
      
select c.customer_id, c.first_name, c.last_name
from customer_20240101 c
where c.customer_id in (
	select tr.customer_id 
	from transaction_20240101 tr 
	where tr.online_order = 'True'
		  and tr.brand in ('Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles')
	)
limit 10

select *
from customer_20240101 c
left join transaction_20240101 tr on c.customer_id = tr.customer_id
where transaction_id is null

select *
from customer_20240101 c
inner join transaction_20240101 tr on c.customer_id = tr.customer_id
where c.job_industry_category = 'IT'
	  and tr.standard_cost = (select max(standard_cost) from transaction_20240101)
	  
select distinct c.customer_id, c.first_name, c.last_name
from customer_20240101 c
inner join transaction_20240101 tr on c.customer_id = tr.customer_id
where c.job_industry_category in ('IT', 'Health')
	  and tr.order_status = 'Approved' 
      and to_date(tr.transaction_date, 'DD/MM/YYYY') between '2017-07-07' and '2017-07-17'