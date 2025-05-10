-- sql/STEP6(HOL_ACCOUNT1)_create_lab_database.sql
-- Run this in HOL_ACCOUNT1 as user sales_admin
-- This script creates tables with data by copying from the shared TCP-H Data in the SNOWFLAKE_SAMPLE_DATA Share


USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;

CREATE DATABASE tpch;
CREATE SCHEMA tpch.sf1;

USE TPCH.SF1;

CREATE OR REPLACE TABLE PART AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.PART;
CREATE OR REPLACE TABLE PARTSUPP AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.PARTSUPP;

CREATE OR REPLACE TABLE REGION AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.REGION;

CREATE OR REPLACE TABLE SUPPLIER AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.SUPPLIER;

CREATE OR REPLACE TABLE LINEITEM AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM;

CREATE OR REPLACE TABLE NATION 
COMMENT='The nation paper contains our enterprise wide standardized nation keys as well as full country names. This table can be joined to the regions table to summarize countries by continent. By the nation key it can also be joined to the customer and supplier tables.'
AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION; 
  
CREATE OR REPLACE TABLE CUSTOMER (
	C_CUSTKEY NUMBER(38,0)   COMMENT 'PK: unique customer identifier, join with the order table.',
	C_NAME VARCHAR(25)       COMMENT 'Full name for billing and shipment.',
	C_ADDRESS VARCHAR(40)    COMMENT 'Full address of the customer including postal code.',
	C_NATIONKEY NUMBER(38,0) COMMENT 'Country indicator, FK into the nation table.',
	C_PHONE VARCHAR(15)      COMMENT 'Phone number including country code and area code.',
	C_ACCTBAL NUMBER(12,2)   COMMENT 'Current account balance of the customer with us.',
	C_MKTSEGMENT VARCHAR(10) COMMENT 'Customer segmentation details.',
	C_COMMENT VARCHAR(117)   COMMENT 'Optional comment pertaining to this customer.'
)COMMENT='This table contains our customer master data including names, addresses, phone number, and other customer attributes. The customer key is unique and can be joined with the orders table to obtain all orders of any given customer.'
AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;

CREATE OR REPLACE TABLE ORDERS (
	O_ORDERKEY NUMBER(38,0) COMMENT 'Unique order identifier',
	O_CUSTKEY NUMBER(38,0) COMMENT 'FK - Identifier of the client who placed the order',
	O_ORDERSTATUS VARCHAR(1) COMMENT 'O = ORDERS, P = PROCESSING, F = FULFILLIED',
	O_TOTALPRICE NUMBER(12,2) COMMENT '$-amount of the total order value',
	O_ORDERDATE DATE COMMENT 'Date when the order was placed by the customer',
	O_ORDERPRIORITY VARCHAR(15) COMMENT 'Internal processing priority for the order',
	O_CLERK VARCHAR(15) COMMENT 'Employee (if any) who processed the order',
	O_SHIPPRIORITY NUMBER(38,0) COMMENT 'Standard, express, or premium shipping',
	O_COMMENT VARCHAR(79) COMMENT 'Optional comment on the order'
) COMMENT='This table is the complete set of all orders that are pending, processing or completed. This table can be joined to the customer table to obtain any related customer details for the order. The table can also be joined to the lineitem table via the order key, to obtain the details of all items included in a given order.'
AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS;

-- A secure view that we want to share
create or replace secure view TPCH.SF1.ORDER_SUMMARY(
	O_ORDERKEY   COMMENT 'Order identifier from the order entry system',
	O_CUSTKEY    COMMENT 'FK: Customer identifier for the order',
    N_NAME       COMMENT 'Customer country of residence',
	O_ORDERDATE  COMMENT 'Data when the order was placed by the client',
	NUM_ITEMS    COMMENT 'Number of products in the order',
	ORDER_AMOUNT COMMENT 'Sum of prices of all items in the order'
) COPY GRANTS
COMMENT='This view provides a total number of items and the total item cost for each order. This is based on a view of the order and line item base tables, computing the sum of the item prices and grouping by the order key.'
 as
  SELECT o_orderkey, o_custkey, n_name, o_orderdate, max(l_linenumber) as num_items, sum(l_extendedprice) as order_amount
  FROM orders, lineitem , customer, nation
  WHERE o_orderkey = l_orderkey
    AND o_custkey = c_custkey
    AND c_nationkey = n_nationkey
  GROUP BY o_orderkey, o_custkey, o_orderdate, n_name;
  

  
-- A function that we want to share
CREATE OR REPLACE SECURE FUNCTION orders_per_customer 
  ( input_customer_id INTEGER )
RETURNS TABLE (customer_name VARCHAR, country VARCHAR, orderkey INTEGER, orderdate DATE, AMOUNT NUMBER)
AS 'SELECT c.c_name, n.n_name, os.o_orderkey, 
           os.o_orderdate, os.order_amount
      FROM customer c, order_summary os, nation n
      WHERE c.c_custkey = os.o_custkey
        AND c.c_nationkey = n.n_nationkey
        AND c.c_custkey = input_customer_id
      ORDER BY os.o_orderkey';


GRANT USAGE ON DATABASE tpch TO ROLE sales_data_scientist_role WITH GRANT OPTION;
GRANT USAGE ON schema SF1    TO ROLE sales_data_scientist_role WITH GRANT OPTION;
GRANT ALL ON ALL tables    IN DATABASE tpch TO ROLE sales_data_scientist_role WITH GRANT OPTION;
GRANT ALL ON ALL views     IN DATABASE tpch TO ROLE sales_data_scientist_role WITH GRANT OPTION;
GRANT ALL ON ALL functions IN DATABASE tpch TO ROLE sales_data_scientist_role WITH GRANT OPTION;
GRANT ALL ON ALL tables    IN SCHEMA tpch.sf1 TO ROLE sales_data_scientist_role WITH GRANT OPTION;
GRANT ALL ON ALL views     IN SCHEMA tpch.sf1 TO ROLE sales_data_scientist_role WITH GRANT OPTION;
GRANT ALL ON ALL functions IN SCHEMA tpch.sf1 TO ROLE sales_data_scientist_role WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON ALL SCHEMAS IN DATABASE TPCH TO ROLE sales_data_scientist_role;

GRANT USAGE ON DATABASE tpch TO ROLE marketing_analyst_role WITH GRANT OPTION;
GRANT USAGE ON schema SF1    TO ROLE marketing_analyst_role WITH GRANT OPTION;
GRANT ALL ON ALL tables    IN DATABASE tpch TO ROLE marketing_analyst_role WITH GRANT OPTION;
GRANT ALL ON ALL views     IN DATABASE tpch TO ROLE marketing_analyst_role WITH GRANT OPTION;
GRANT ALL ON ALL functions IN DATABASE tpch TO ROLE marketing_analyst_role WITH GRANT OPTION;
GRANT ALL ON ALL tables    IN SCHEMA tpch.sf1 TO ROLE marketing_analyst_role WITH GRANT OPTION;
GRANT ALL ON ALL views     IN SCHEMA tpch.sf1 TO ROLE marketing_analyst_role WITH GRANT OPTION;
GRANT ALL ON ALL functions IN SCHEMA tpch.sf1 TO ROLE marketing_analyst_role WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON ALL SCHEMAS IN DATABASE TPCH TO ROLE marketing_analyst_role;


-------------------------------------------
-- Create Sample Listing 1 in hol_accoun1
-- Login into hol_account1 as sales_admin
--------------------------------------------

use role sales_data_scientist_role;

CREATE OR REPLACE SHARE share_customer360;
GRANT USAGE ON DATABASE tpch TO SHARE share_customer360;
GRANT USAGE ON SCHEMA tpch.sf1 TO SHARE share_customer360;
GRANT SELECT ON TABLE tpch.sf1.customer TO SHARE share_customer360;
GRANT SELECT ON TABLE tpch.sf1.nation TO SHARE share_customer360;
GRANT USAGE ON FUNCTION tpch.sf1.ORDERS_PER_CUSTOMER(NUMBER) TO SHARE share_customer360;


CREATE ORGANIZATION LISTING CUSTOMER360_LIGHT
SHARE share_customer360
AS $$
title: "Customer360 Light"
description: "# Business Description:\n\nThis data product offers a holistic view\
  \ of our customers, integrating data from various touchpoints. Over time this data\
  \ product will include transactional history (orders), engagement metrics (website\
  \ visits), demographic information (age, location), and support interactions (tickets,\
  \ chat logs). This comprehensive profile enables a deeper understanding of customer\
  \ behavior, preferences, and needs, facilitating personalized experiences and improved\
  \ decision-making across sales, marketing, and customer service."
resources:
  documentation: "http://www.snowflake.com/data-mesh"
listing_terms:
  type: "CUSTOM"
  link: "https://www.snowflake.com/resource/how-to-knit-your-data-mesh-on-snowflake/"
auto_fulfillment:
  refresh_type: "SUB_DATABASE"
  refresh_schedule: "1 MINUTE"
data_dictionary:
  featured:
    database: "TPCH"
    objects:
    - schema: "SF1"
      domain: "TABLE"
      name: "CUSTOMER"
data_preview:
  has_pii: false
usage_examples:
- title: "Get orders for one customer"
  description: ""
  query: "SELECT customer_name, country, orderkey, orderdate, AMOUNT\nFROM TABLE(sf1.orders_per_customer(60001));"
- title: "Get Customer Info"
  description: ""
  query: "select *\nfrom sf1.customer, sf1.nation\nwhere c_nationkey = n_nationkey\n\
    limit 100;\n"
data_attributes:
  refresh_rate: "WEEKLY"
  geography:
    geo_option: "NOT_APPLICABLE"
  time:
    granularity: "EVENT_BASED"
    time_range:
      time_frame: "LAST"
      units: "MONTHS"
      value: 1
organization_profile: "SALES"
organization_targets:
  discovery:
  - all_internal_accounts: true
locations:
  access_regions:
  - name: "ALL"
request_approval_type: "REQUEST_AND_APPROVE_IN_SNOWFLAKE"
$$;
