-- Login to the Organization Account HOL_ORG_ACCOUNT and execute the following commands in a worksheet.

USE ROLE accountadmin;

CREATE OR REPLACE WAREHOUSE compute_wh WAREHOUSE_SIZE=xsmall INITIALLY_SUSPENDED=TRUE;
GRANT ALL ON WAREHOUSE compute_wh TO ROLE public;

-- Rename the Primary Account:
USE ROLE globalorgadmin;


-- execute the following two commands together, 
-- no other commands in between:

  show accounts;
  SET my_curr_account = (SELECT "account_name" FROM TABLE(RESULT_SCAN(LAST_QUERY_ID())) order by "created_on" ASC LIMIT 1);

-- View and rename the account:
SELECT $my_curr_account;

ALTER ACCOUNT identifier($my_curr_account) 
  RENAME TO hol_account1 SAVE_OLD_URL = true;

-- Enable users with the ACCOUNTADMIN role to set up Cross-Cloud Auto-Fulfillmen
SELECT SYSTEM$ENABLE_GLOBAL_DATA_SHARING_FOR_ACCOUNT('hol_account1');
SELECT SYSTEM$ENABLE_GLOBAL_DATA_SHARING_FOR_ACCOUNT('hol_account2');

  
SHOW ACCOUNTS;

-- You should see 3 rows similar to the image below.
-- Make a note of your account names, URLs, and passwords!