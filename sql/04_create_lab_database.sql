-- Run this in HOL_ACCOUNT1
-- This script creates tables with data by copying from the shared TCP-H Data in the SNOWFLAKE_SAMPLE_DATA Share


USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;

CREATE DATABASE tpch;
CREATE SCHEMA tpch.sf1;

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

GRANT USAGE ON DATABASE tpch TO ROLE marketing_analyst_role WITH GRANT OPTION;
GRANT USAGE ON schema SF1    TO ROLE marketing_analyst_role WITH GRANT OPTION;
GRANT ALL ON ALL tables    IN DATABASE tpch TO ROLE marketing_analyst_role WITH GRANT OPTION;
GRANT ALL ON ALL views     IN DATABASE tpch TO ROLE marketing_analyst_role WITH GRANT OPTION;
GRANT ALL ON ALL functions IN DATABASE tpch TO ROLE marketing_analyst_role WITH GRANT OPTION;
