drop table if exists fact_products;
drop table if exists dim_categories;
drop table if exists dim_locations;

create table dim_categories (
category_id int auto_increment primary key,
main_category varchar(255),
sub_category1 varchar(255),
sub_category2 varchar(255)
);

insert into dim_categories (main_category, sub_category1, sub_category2)
select distinct 
main_category,
sub_category1,
sub_category2
from raw_shopee_sales
where main_category is not null;

create table dim_locations (
location_id int auto_increment primary key,
ori_shipping_location varchar(255),
origin_type varchar(255)
);

insert into dim_locations (ori_shipping_location, origin_type)
select distinct
raw_location, 
origin_type
from raw_shopee_sales
where raw_location is not null;

create table fact_products ( 
product_id varchar(50) primary key,
title text,
price_ori decimal(20,2),
price_actual decimal(20,2),
total_sold int,
timestamp datetime,
w_date date,
category_id int,
location_id int,
foreign key (category_id) references dim_categories(category_id),
foreign key (location_id) references dim_locations(location_id)
);

insert into fact_products (product_id, title, price_ori, price_actual, total_sold, timestamp, w_date, category_id, location_id)
select
r.idElastic,
r.title,
r.price_ori,
r.price_actual,
r.total_sold,
r.timestamp,
r.w_date,
c.category_id,
l.location_id
from raw_shopee_sales r
left join dim_categories c
on r.main_category <=> c.main_category
and r.sub_category1 <=> c.sub_category1
and r.sub_category2 <=> c.sub_category2
left join dim_locations l
on r.raw_location = l.ori_shipping_location
and r.origin_type = l.origin_type;