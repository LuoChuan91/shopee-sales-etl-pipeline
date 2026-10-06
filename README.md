# Shopee Market Analysis: Pricing Integrity & Growth Opportunities

## 📌 Executive Summary
This project provides an end-to-end data pipeline and visual analytics dashboard designed to identify market gaps, evaluate seller saturation, and detect pricing anomalies across the Shopee e-commerce platform. The insights are structured to advise strategic decisions for enterprise clients (e.g., KPMG), focusing on maximizing Gross Market Value (GMV) and uncovering "white space" opportunities.

**🔗 [https://public.tableau.com/app/profile/luo.chuan.seow7056/viz/shopee-sales-dashboard/ShopeeMarketAnalysisPricingIntegrityGrowthOpportunities]**

![Dashboard Screenshot](/dashboard/shopee-dashboard.png)

## 🎯 Key Business Questions Answered
1. **Pricing Anomalies:** Which product categories contain statistically significant price manipulations or extreme outliers using $Z$-score analysis?
2. **Market Saturation (White Space):** Where is buyer demand outpacing seller supply? (Calculated via Average Sales Volume per Listing).
3. **Revenue Concentration:** Which core categories drive 80% of the platform's total GMV? (Pareto Analysis).
4. **Geographic Performance:** Do domestic or overseas sellers drive higher transaction volume vs. overall revenue?

## 🛠 Technical Architecture
* **ETL Pipeline (Python/SQL):** Raw data extraction, cleaning, and transformation into a normalized relational model.
* **Data Modeling:** Designed a Star Schema consisting of a central `fact_products` table joined to `dim_categories` and `dim_locations` to optimize query performance.
* **Data Visualization (Tableau):** Created a 4-quadrant interactive dashboard utilizing LOD expressions, dual-axis charts, and calculated parameters for dynamic filtering.

## 📂 Repository Structure
* `/sql`: Contains the core transformation logic, including the $Z$-score anomaly calculations, Pareto cumulative percentages, and demand-to-supply ratio queries.
* `/scripts`: Python ETL scripts for raw data ingestion and initial cleaning (`load_shopee_data.py`).
* `/data`: Directory for the generated `.csv` extracts used for Tableau (raw data ignored via `.gitignore`).
* `/notebooks`: Jupyter notebooks for exploratory data analysis (EDA) prior to formal database loading.
* `/dashboard`: Placeholder for Tableau packaged workspace files (if applicable, though live link is preferred).

## 🚀 How to Run the SQL Queries
The analysis relies on a normalized Star Schema. To replicate the metrics:
1. Ensure your database contains `fact_products`, `dim_categories`, and `dim_locations`.
2. Run the queries located in the `/sql` folder. The primary analytical queries include:
   - `shopee_zscore_anomalies.sql`
   - `shopee_pareto_gmv.sql`
   - `shopee_saturation_matrix.sql`
   - `shopee_origin_performance.sql`