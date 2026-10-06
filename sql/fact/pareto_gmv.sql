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