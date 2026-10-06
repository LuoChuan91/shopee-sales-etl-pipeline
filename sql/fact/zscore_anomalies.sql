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
        AVG(price_actual) OVER (PARTITION BY category_id) AS cat_mean,
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