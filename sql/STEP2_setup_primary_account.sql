-- Run this code in your PRIMARY Account
-- Make sure you update the four variables below: email_var, firstname_var, lastname_var, pwd_var

USE ROLE accountadmin;

-- Use the same name and email for all accounts
set email_var = 'FILL_IN_YOUR_EMAIL';
set firstname_var  = 'FILL_IN_YOUR_FIRST_NAME';
set lastname_var  = 'FILL_IN_YOUR_LAST_NAME';

-- Use the same password for users in all accounts
set pwd_var = 'FILL_IN_YOUR_PASSWORD';

CREATE OR REPLACE WAREHOUSE compute_wh WAREHOUSE_SIZE=xsmall INITIALLY_SUSPENDED=TRUE;
GRANT ALL ON WAREHOUSE compute_wh TO ROLE public;

--  Create a user and role for the sales domain:
USE ROLE accountadmin;
CREATE OR REPLACE ROLE sales_data_scientist_role;

SET my_user_var = CURRENT_USER();
ALTER USER identifier($my_user_var) SET DEFAULT_ROLE = sales_data_scientist_role;

CREATE OR REPLACE USER sales_admin
  PASSWORD = $pwd_var
  LOGIN_NAME = sales_admin
  DISPLAY_NAME = sales_admin
  FIRST_NAME = $firstname_var
  LAST_NAME = $lastname_var
  EMAIL = $email_var
  MUST_CHANGE_PASSWORD = FALSE
  DEFAULT_WAREHOUSE = compute_wh
  DEFAULT_ROLE = sales_data_scientist_role
  COMMENT = 'Sales domain admin';

GRANT ROLE sales_data_scientist_role TO USER sales_admin;
GRANT ROLE accountadmin              TO USER sales_admin;  -- for simplicity in this lab
GRANT CREATE SHARE ON ACCOUNT                    TO ROLE sales_data_scientist_role;
GRANT CREATE ORGANIZATION LISTING ON ACCOUNT     TO ROLE sales_data_scientist_role;
GRANT MANAGE LISTING AUTO FULFILLMENT ON ACCOUNT TO ROLE sales_data_scientist_role;


-- Next, create a user and role for the marketing domain:
USE ROLE accountadmin;
CREATE OR REPLACE ROLE marketing_analyst_role;

CREATE OR REPLACE USER marketing_admin
  PASSWORD = $pwd_var
  LOGIN_NAME = marketing_admin
  DISPLAY_NAME = marketing_admin
  FIRST_NAME = $firstname_var
  LAST_NAME = $lastname_var
  EMAIL = $email_var
  MUST_CHANGE_PASSWORD = FALSE
  DEFAULT_WAREHOUSE = compute_wh
  DEFAULT_ROLE = marketing_analyst_role
  COMMENT = 'Marketing domain admin';

GRANT ROLE marketing_analyst_role TO USER marketing_admin;
GRANT CREATE SHARE ON ACCOUNT                    TO ROLE marketing_analyst_role;
GRANT CREATE ORGANIZATION LISTING ON ACCOUNT     TO ROLE marketing_analyst_role;
GRANT MANAGE LISTING AUTO FULFILLMENT ON ACCOUNT TO ROLE sales_data_scientist_role;


-- Continue to run this code in your PRIMARY account
-- Create a secondary account in the same region (default!):
USE ROLE orgadmin;

CREATE ACCOUNT hol_account2
  admin_name = supply_chain_admin
  admin_password = $pwd_var
  first_name = $firstname_var
  last_name = $lastname_var 
  email = $email_var
  must_change_password = false
  edition = enterprise;

-- Create an organization account for admin purposes:
CREATE ORGANIZATION ACCOUNT hol_org_account
  admin_name = org_admin
  admin_password = $pwd_var
  first_name = $firstname_var
  last_name = $lastname_var 
  email = $email_var
  must_change_password = false
  edition = enterprise; 

-- Get an overview of all the accounts in the organization.
-- This SHOW command should return 3 rows:

SHOW ACCOUNTS;
