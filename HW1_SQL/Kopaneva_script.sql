create table if not exists transaction (
  transaction_id int PRIMARY KEY
  ,product_unic_id int 
  ,customer_id int not null
  ,transaction_date timestamp not null 
  ,online_order bool 
  ,order_status text not null
  ,list_price float not null
);

create table if not exists customer (
  customer_id int PRIMARY KEY
  ,first_name varchar not null
  ,last_name varchar 
  ,gender varchar(10)
  ,DOB timestamp
  ,job_title text
  ,job_industry_category text
  ,wealth_segment text not null
  ,deceased_indicator varchar(10) not null
  ,owns_car varchar(10)
  ,address text
  ,postcode int
  ,state text
  ,country text
  ,property_valuation int
);

create table if not exists product (
   product_unic_id int PRIMARY KEY
  ,product_id int not null
  ,brand text not null
  ,product_line_id int not null
  ,product_class_id int not null
  ,product_size_id int not null
  ,standard_cost float not null
);

create table if not exists product_line (
   product_line_id int PRIMARY KEY 
  ,product_line varchar(20) not null
);

create table if not exists product_class (
   product_class_id int PRIMARY KEY
  ,product_class varchar(20) not null
);

create table if not exists product_size (
  product_size_id int PRIMARY KEY
  ,product_size varchar(20)
);

alter table product
alter column product_id DROP NOT NULL;

alter table transaction
alter column transaction_date type date;

alter table transaction 
add foreign key ("customer_id") references "customer" ("customer_id");

alter table transaction 
add foreign key ("product_unic_id") references "product" ("product_unic_id");

alter table product 
add foreign key ("product_line_id") references "product_line" ("product_line_id");

alter table product
add foreign key ("product_class_id") references "product_class" ("product_class_id");

alter table product
add foreign key ("product_size_id") references "product_size" ("product_size_id");