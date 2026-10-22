/*=============================================================
DDL Script: Create Gold views
=============================================================
scrpit purpose: this script crates views for the gold layer in the data warehouse.
  the gold layer represents the final dimension and fact tables(star schema)

each view performs transformations and combines data from the silver layer 
to produce a clear, enriched,a nd business-ready dataset.


usage:
-these views can be queried directly for analytics and reporting.
  =============================================================
*/

-- =============================================================
-- Create Dimension: Gold.dim_customers
-- =============================================================

 DROP VIEW IF EXISTS gold.gold_dim_customers;

CREATE VIEW gold.gold_dim_customers AS
SELECT 
    ROW_NUMBER() OVER(ORDER BY customer_id) AS customer_key,
    customer_id,
    customer_number,
    first_name,
    last_name,
    country,
    marital_status,
    gender,
    birth_date,
    create_date
FROM (
    
    SELECT 
        ci.cst_id AS customer_id,
        ci.cst_key AS customer_number,
        ci.cst_firstname AS first_name,
        ci.cst_lastname AS last_name,
        la.cntry AS country,
        ci.cst_marital_status AS marital_status,
        CASE 
            WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr 
            ELSE COALESCE(ca.gen, 'n/a')
        END AS gender,
        ca.bdate AS birth_date,
        ci.cst_create_date AS create_date
    FROM silver.crm_cust_info ci
    LEFT JOIN (
        SELECT cid, MAX(gen) AS gen, MAX(bdate) AS bdate 
        FROM silver.erp_cust_az12 
        GROUP BY cid
    ) ca ON ci.cst_key = ca.cid
    LEFT JOIN (
        SELECT cid, MAX(cntry) AS cntry 
        FROM silver.erp_loc_a101 
        GROUP BY cid
    ) la ON ci.cst_key = la.cid
) AS base_data;


-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
create view gold.dim_products as 
select
row_number() over(order by pn.prd_start_dt, pn.prd_key) as product_key,
	pn.prd_id as product_id,
	pn.prd_key as product_number,
	pn.prd_nm as product_name,
	pn.cat_id as category_id,
	pc.cat as category,
    pc.subcat as subcategory,
    pc.maintenance,
	pn.prd_cost as cost,
	pn.prd_line as product_line,
	pn.prd_start_dt as start_Date

from silver.crm_prd_info pn
left join silver.erp_px_cat_g1v2 pc
on pn.cat_id=pc.id
where prd_end_dt is null

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================

create view gold.fact_sales as
select
sd.sls_ord_num as order_numebr,
pr.product_key,
cu.customer_key,
sd.sls_order_dt as order_date,
sd.sls_ship_dt as shipping_date,
sd.sls_due_dt as due_date,
sd.sls_sales as sales_amount,
sd.sls_quantity as quantity,
sd.sls_price
from silver.crm_sales_details sd
left join gold.dim_products pr
on sd.sls_prd_key = pr.product_number
left join gold.gold_dim_customers cu
on sd.sls_cust_id=cu.customer_id

