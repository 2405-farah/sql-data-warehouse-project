/*
===============================================================================
Create Bronze Tables
===============================================================================
    This script creates tables in the 'bronze' schema, dropping existing tables
    if they already exist.
      Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

create table if not exists bronze.crm_cust_info(
cst_id int,
cst_key varchar (50),
cst_firstname varchar (50),
cst_lastname varchar (50),
cst_marital_status varchar (50),
cst_gndr varchar (50),
cst_create_date date
);

create table bronze.crm_prd_info(
prd_id int,
prd_key varchar(50),
prd_nm varchar(50),
prd_cost int,
prd_line varchar(50),
prd_start_dt datetime,
prd_end_dt datetime
);

create table bronze.crm_sales_details(
sls_ord_num varchar(50),
sls_prd_key varchar(50),
sls_cust_id int,
sls_order_dt int,
sls_ship_dt int,
sls_due_dt int,
sls_sales int,
sls_quantity int,
sls_price int
);

create table bronze.erp_CUST_AZ12(
CID varchar(50),
BDATE date,
GEN varchar(50)
);

create table bronze.erp_LOC_A101(
CID varchar(50),
CNTRY varchar(50)
);

create table bronze.erp_PX_CAT_G1V2(
ID varchar(50),
CAT varchar(50),
SUBCAT varchar(50),
MAINTENANCE varchar(50)
);



