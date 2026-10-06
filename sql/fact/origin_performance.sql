
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
by two-sample z test, since the computed z-score of 14.3 is way higher than that of 2.576 thus we reject null hypothesis, 
the data proves that the Malaysian vendors have significantly higher sales volume than that of overseas vendors.
Recommendation: Since Malaysian vendors are driving sales volumes more, Shopee should incentivise Malaysian vendors by 
decreasing commissioning fees for example to boost overall GMV.
*/