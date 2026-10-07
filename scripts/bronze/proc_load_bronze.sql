/*
================================================================================
  Stored procedure: load bronze layer (source -> bronze)
================================================================================
  script purpose:
  this stored procedure load data into the 'bronze' schema frm external csv files.
  it performs the following actions:
  -truncates the bronze tables before loading data.
  -uses the 'bilk insert' command to load data from csv files to bronze tables.

  parameters:
  none.

  this stored procedure does not accept any parameters or return any values.

  usage example;
call bronze.load_bronze;

================================================================================
  */

SET GLOBAL local_infile = 1;

DROP PROCEDURE IF EXISTS bronze.load_bronze;

DELIMITER //

CREATE PROCEDURE bronze.load_bronze()
BEGIN
    
    DECLARE v_start_time DATETIME(3);
    DECLARE v_end_time DATETIME(3);
    DECLARE v_batch_start_time DATETIME(3);
    DECLARE v_batch_end_time DATETIME(3);
    
    
    DECLARE v_sql_state VARCHAR(5);
    DECLARE v_error_msg TEXT;

    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_error_code = MYSQL_ERRNO,
            v_sql_state = RETURNED_SQLSTATE,
            v_error_msg = MESSAGE_TEXT;

        SELECT '==========================================' AS message
        UNION ALL SELECT 'ERROR OCCURRED DURING LOADING BRONZE LAYER'
        UNION ALL SELECT CONCAT('Error Message: ', v_error_msg)
        UNION ALL SELECT CONCAT('Error Code: ', v_error_code)
        UNION ALL SELECT CONCAT('SQL State: ', v_sql_state)
        UNION ALL SELECT '==========================================';
    END;

   
    SET v_batch_start_time = NOW(3);

   
    SELECT '================================================' AS message
    UNION ALL SELECT 'Loading Bronze Layer'
    UNION ALL SELECT '================================================'
    UNION ALL SELECT '------------------------------------------------'
    UNION ALL SELECT 'Loading CRM Tables'
    UNION ALL SELECT '------------------------------------------------';

    
    SET v_start_time = NOW(3);
    SELECT '>> Truncating Table: bronze.crm_cust_info' AS message;
    DELETE FROM bronze.crm_cust_info WHERE 1=1;

    SELECT '>> Inserting Data Into: bronze.crm_cust_info' AS message;
    SET @sql1 = "LOAD DATA LOCAL INFILE '/Users/farahzarzuela/Downloads/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
                 INTO TABLE bronze.crm_cust_info
                 FIELDS TERMINATED BY ','
                 OPTIONALLY ENCLOSED BY '\"'
                 LINES TERMINATED BY '\n'
                 IGNORE 1 LINES;";
    PREPARE stmt1 FROM @sql1;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET v_end_time = NOW(3);
    SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, v_start_time, v_end_time), ' seconds') AS message
    UNION ALL SELECT '>> -------------';

    
    SET v_start_time = NOW(3);
    SELECT '>> Truncating Table: bronze.crm_prd_info' AS message;
    DELETE FROM bronze.crm_prd_info WHERE 1=1;

    SELECT '>> Inserting Data Into: bronze.crm_prd_info' AS message;
    SET @sql2 = "LOAD DATA LOCAL INFILE '/Users/farahzarzuela/Downloads/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
                 INTO TABLE bronze.crm_prd_info
                 FIELDS TERMINATED BY ','
                 OPTIONALLY ENCLOSED BY '\"'
                 LINES TERMINATED BY '\n'
                 IGNORE 1 LINES;";
    PREPARE stmt2 FROM @sql2;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;

    SET v_end_time = NOW(3);
    SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, v_start_time, v_end_time), ' seconds') AS message
    UNION ALL SELECT '>> -------------';

    
    SET v_start_time = NOW(3);
    SELECT '>> Truncating Table: bronze.crm_sales_details' AS message;
    DELETE FROM bronze.crm_sales_details WHERE 1=1;

    SELECT '>> Inserting Data Into: bronze.crm_sales_details' AS message;
    SET @sql3 = "LOAD DATA LOCAL INFILE '/Users/farahzarzuela/Downloads/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
                 INTO TABLE bronze.crm_sales_details
                 FIELDS TERMINATED BY ','
                 OPTIONALLY ENCLOSED BY '\"'
                 LINES TERMINATED BY '\n'
                 IGNORE 1 LINES;";
    PREPARE stmt3 FROM @sql3;
    EXECUTE stmt3;
    DEALLOCATE PREPARE stmt3;

    SET v_end_time = NOW(3);
    SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, v_start_time, v_end_time), ' seconds') AS message
    UNION ALL SELECT '>> -------------';

    
    SELECT '------------------------------------------------' AS message
    UNION ALL SELECT 'Loading ERP Tables'
    UNION ALL SELECT '------------------------------------------------';

   
    SET v_start_time = NOW(3);
    SELECT '>> Truncating Table: bronze.erp_loc_a101' AS message;
    DELETE FROM bronze.erp_loc_a101 WHERE 1=1;

    SELECT '>> Inserting Data Into: bronze.erp_loc_a101' AS message;
    SET @sql4 = "LOAD DATA LOCAL INFILE '/Users/farahzarzuela/Downloads/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv'
                 INTO TABLE bronze.erp_loc_a101
                 FIELDS TERMINATED BY ','
                 OPTIONALLY ENCLOSED BY '\"'
                 LINES TERMINATED BY '\n'
                 IGNORE 1 LINES;";
    PREPARE stmt4 FROM @sql4;
    EXECUTE stmt4;
    DEALLOCATE PREPARE stmt4;

    SET v_end_time = NOW(3);
    SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, v_start_time, v_end_time), ' seconds') AS message
    UNION ALL SELECT '>> -------------';

    
    SET v_start_time = NOW(3);
    SELECT '>> Truncating Table: bronze.erp_cust_az12' AS message;
    DELETE FROM bronze.erp_cust_az12 WHERE 1=1;

    SELECT '>> Inserting Data Into: bronze.erp_cust_az12' AS message;
    SET @sql5 = "LOAD DATA LOCAL INFILE '/Users/farahzarzuela/Downloads/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv'
                 INTO TABLE bronze.erp_cust_az12
                 FIELDS TERMINATED BY ','
                 OPTIONALLY ENCLOSED BY '\"'
                 LINES TERMINATED BY '\n'
                 IGNORE 1 LINES;";
    PREPARE stmt5 FROM @sql5;
    EXECUTE stmt5;
    DEALLOCATE PREPARE stmt5;

    SET v_end_time = NOW(3);
    SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, v_start_time, v_end_time), ' seconds') AS message
    UNION ALL SELECT '>> -------------';

    
    SET v_start_time = NOW(3);
    SELECT '>> Truncating Table: bronze.erp_px_cat_g1v2' AS message;
    DELETE FROM bronze.erp_px_cat_g1v2 WHERE 1=1;

    SELECT '>> Inserting Data Into: bronze.erp_px_cat_g1v2' AS message;
    SET @sql6 = "LOAD DATA LOCAL INFILE '/Users/farahzarzuela/Downloads/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv'
                 INTO TABLE bronze.erp_px_cat_g1v2
                 FIELDS TERMINATED BY ','
                 OPTIONALLY ENCLOSED BY '\"'
                 LINES TERMINATED BY '\n'
                 IGNORE 1 LINES;";
    PREPARE stmt6 FROM @sql6;
    EXECUTE stmt6;
    DEALLOCATE PREPARE stmt6;

    SET v_end_time = NOW(3);
    SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, v_start_time, v_end_time), ' seconds') AS message
    UNION ALL SELECT '>> -------------';

    
    SET v_batch_end_time = NOW(3);
    SELECT '==========================================' AS message
    UNION ALL SELECT 'Loading Bronze Layer is Completed'
    UNION ALL SELECT CONCAT(' - Total Load Duration: ', TIMESTAMPDIFF(SECOND, v_batch_start_time, v_batch_end_time), ' seconds')
    UNION ALL SELECT '==========================================';

END //

DELIMITER ;
