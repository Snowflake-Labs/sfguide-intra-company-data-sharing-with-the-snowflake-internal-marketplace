-- Run this in hol_account2, logged in as supply_chain_admin user
-- Make sure you run this as ACCOUNTADMINUSE ROLE accountadmin;

CREATE OR REPLACE WAREHOUSE compute_wh WAREHOUSE_SIZE=small INITIALLY_SUSPENDED=TRUE;
GRANT ALL ON WAREHOUSE compute_wh TO ROLE public;

CREATE ROLE supply_chain_admin_role;
GRANT ROLE accountadmin TO ROLE supply_chain_admin_role; 
GRANT ROLE supply_chain_admin_role TO USER supply_chain_admin;

ALTER USER supply_chain_admin 
  SET DEFAULT_ROLE = supply_chain_admin_role;

USE ROLE supply_chain_admin_role;
CREATE DATABASE supply_chain_db;
