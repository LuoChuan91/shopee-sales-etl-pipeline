/* Catalog Saturation
To see if there's any catalog saturation or white spaces we need to find the categories with the highest/lowest saturation of 
items by taking total items sold per product divided by the total number of products in that category.
*/

select sum(total_sold) / count(distinct product_id) as prod_saturation, category_id 
from fact_products
group by category_id
order by prod_saturation desc;

select sum(f.total_sold) / count(distinct f.product_id) as prod_saturation, c.main_category
from fact_products f
join dim_categories c on c.category_id = f.category_id
group by c.main_category
order by prod_saturation desc;

/*
By looking at prod_saturation, we can see that the 'Home and Living' category has a very high saturation ratio indicating that there
is a lot of white space in this category, while 'Tickets & Vouchers' has the lowest saturation ratio indicating that there the category
is highly saturated with sellers.
Recommendation: Shopee should focus its business development on category 'Home and Living' while pouring less resources into the
highly saturated categories like 'Tickets & Vouchers'.
*/