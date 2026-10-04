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

/*
Hypothesis: Malaysian listings on Shopee drive higher sales volume than Overseas Listings
H0: Malaysia mean sales volume = overseas mean sales volume
H1: Malaysia means sales volume != overseas mean sales volume
*/

-- calculate mean, variance, sample size of both Malaysian and overseas listings for two-sample z test using 1% significance level
select avg(f.total_sold) as avg_sales_volume, variance(f.total_sold) as sales_variance, count(f.product_id) as total_volume, l.origin_type
from dim_locations l
join fact_products f
on f.location_id = l.location_id
group by l.origin_type;

/*
by two-sample z test, since the computed z-score of 14.3 is way higher than that of 2.33 thus we reject null hypothesis, 
the data proves that the Malaysian vendors have significantly higher sales volume than that of overseas vendors.
Recommendation: Since Malaysian vendors are driving sales volumes more, Shopee should incentivise Malaysian vendors by 
decreasing commissioning fees for example to boost overall GMV.
*/

/* Catalog Saturation
To see if there's any catalog saturation or white spaces we need to find the categories with the highest/lowest saturation of 
items by taking total items sold per product divided by the total number of products in that category.
*/

select sum(total_sold) / count(distinct product_id) as prod_saturation, category_id 
from fact_products
group by category_id
order by prod_saturation desc;

/*
By looking at prod_saturation, we can see that the category with id 502 has a very high saturation ratio indicating that there
is a lot of white space in this category, while category 857 has the lowest saturation ratio indicating that there the category
is highly saturated with sellers.
Recommendation: Shopee should focus its business development on category 502,219 and 987 while pouring less resources into the
highly saturated categories like 857, 967 1016.
*/

/*
We need to find outliers to find out which sellers are undercutting or pricing goods at prices way higher than the mean and find
out if they are selling counterfeit products and selling goods at exorbitant prices, to do this we make use of z-scores by
calculating the number of standard deviations a product is from the mean price of that good's category. We will use a threshold
of Z < -2 and Z > 2 to determine the outliers.
*/

WITH ProductStats AS (
    SELECT 
        product_id,
        title,
        category_id,
        price_actual,
        -- Calculate the mean for the specific category
        AVG(price_actual) OVER (PARTITION BY category_id) AS cat_mean,
        -- Calculate the standard deviation for the specific category
        STDDEV(price_actual) OVER (PARTITION BY category_id) AS cat_stddev
    FROM fact_products
    WHERE category_id IS NOT NULL 
)
SELECT 
    product_id,
    title,
    category_id,
    price_actual,
    cat_mean,
    -- The Z-Score Formula: (Price - Mean) / Standard Deviation
    (price_actual - cat_mean) / NULLIF(cat_stddev, 0) AS z_score
FROM ProductStats
-- Filter immediately for anomalies
-- WHERE (price_actual - cat_mean) / NULLIF(cat_stddev, 0) <= -2 
--    OR (price_actual - cat_mean) / NULLIF(cat_stddev, 0) >= 2
ORDER BY z_score DESC;

/*
By filtering products which prices are 2 standard deviations away from the mean, we can find out which sellers are
undercharging or overcharging prices allowing Shopee to take action by investigating these sellers for counterfeit products
or ensuring that their product is legitimately worth an exorbitant amount of money easily.
*/

/*
To identify which categories drive the highest market value we can find out which categories make up 80% of total market value
of Shopee so that Shopee will be able to allocate more budget to these specific categories to optimise spending.
*/

with cte as (select sum(f.price_actual*f.total_sold) as gross_market_value, c.main_category 
from fact_products f
join dim_categories c
on c.category_id = f.category_id
group by c.main_category
order by gross_market_value desc),
cte2 as (select sum(gross_market_value) as total_value
from cte)
select cte.main_category, cte.gross_market_value, 
sum(cte.gross_market_value) over (order by cte.gross_market_value desc) as cumulative_gmv,
(sum(cte.gross_market_value) over (order by cte.gross_market_value desc)/cte2.total_value) as cumulative_percentage
from cte 
cross join cte2
order by cte.gross_market_value desc;

/*
When using the above query, the top categories that make up 82% of total market value are Home Appliances, Health and Beauty,
Mobile and Accessories, Baby and Toys, Groceries and Pets, and Home and Living, thus, Shopee should focus on these categories
to optimise spending and budget to produce the highest market value.
*/






