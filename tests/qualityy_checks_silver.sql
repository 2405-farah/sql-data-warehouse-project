/*
====================================================================================
Quality Checks
====================================================================================
Script Purpose:
This script performs quality checks for data consistency, accuracy and standardization across the 'silver' schemas. it includes checks for:
-null or duplicates primary keys.
-unwanted spaces in string fields.
-invalid date ranges and orders.
-data consistency between realated fields.

usage notes:
-run these checks after data loading silver layer.
-investigate and resolve any discrepancies found during the checks.
=====================================================================================
*/
--===========================================================================
--checking 'silver.crm_cust_info'
--===========================================================================
--check for nulls or duplicates in primary key 
--expectation: no results

/* CHECK FOR INVALID DATES*/
select 
ifnull(sls_due_dt, 0)sls_due_dt
from bronze.crm_sales_Details
where sls_due_dt<=0
or length(sls_due_dt) != 8 
or sls_due_dt > 20500101
or sls_due_dt< 19000101;


/* CHECK FOR INVALID DATE ORDERS*/

select * 
from bronze.crm_sales_details
where sls_order_dt < sls_ship_dt;

/*identify out_of_range dates */
select distinct 
bdate
from silver.erp_cust_az12
where bdate<'1924-01-04' or bdate > now();

/*data standardization & consistency*/
select distinct gen
from silver.erp_cust_az12;

select * from silver.erp_cust_az12

/*insert into silver.erp_loc_a101(cid,cntry)*/
select distinct 
cntry
from silver.erp_loc_a101
order by cntry;

/* check for nulls or duplicates in primary key
expectation: no result*/

select
cst_id,
count(*)
from silver.crm_cust_info
group by cst_id
having count(*)>1 or cst_id is null;

/*check for unwanted spaces 
expectations:no result*/

select cst_lastname
from silver.crm_cust_info
where cst_lastname != trim(cst_lastname);

/*data standardization & consistency*/
select distinct cst_gndr
from silver.crm_cust_info;

select * from silver.crm_cust_info
