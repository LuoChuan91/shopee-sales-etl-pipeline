-- listed products from the data that was listed during May 2023
select count(distinct title) as num_products from raw_shopee_sales
where year(timestamp) = 2023 and month(timestamp) = 05;

-- Show how many products are crawled each date.
select count(distinct title) as num_products, w_date from raw_shopee_sales
where year(w_date) = 2023 and month(w_date) = 05
group by w_date
order by w_date;

-- Show number of listing products based on main category.
select count(distinct title) as num_products, main_category
from raw_shopee_sales
group by main_category;

-- For the top 3 main categories, show the top 5 subcategory 1 for that main category based on number of products
with cte as (select count(distinct title) as num_products, main_category from raw_shopee_sales
where year(timestamp) = 2023 and month(timestamp) = 05
group by main_category
order by num_products desc limit 3),
cte2 as (select count(distinct title) as num_products, sub_category1, main_category, row_number() over (partition by main_category order by count(distinct title) desc) as sub_rank from raw_shopee_sales
where main_category in (select main_category from cte) and year(timestamp) = 2023 and month(timestamp) = 05
group by sub_category1, main_category)
select * from cte2
where sub_rank <= 5;

-- Show price range for each main category
select min(price_actual), max(price_actual), main_category from raw_shopee_sales
group by main_category;

-- Show the revenue for each main category in descending order
select sum(price_actual*total_sold) as total_revenue, main_category from raw_shopee_sales
group by main_category
order by total_revenue desc;

select sum(f.price_actual*f.total_sold) as gross_market_value, d.origin_type
from dim_locations d
join fact_products f
on d.location_id = f.location_id
group by d.origin_type;