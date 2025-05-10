-- sql/STEP7b(HOL_ACCOUNT2)_create_sample_listing.sql
-------------------------------------------
-- Create Sample Listing 3 in hol_account2
-- Login into hol_account2 as supply_chain_admin
--------------------------------------------
use role supply_chain_admin_role;
use warehouse compute_wh;

-- Import sample data so that we have something to share
CREATE DATABASE SNOWFLAKE_SAMPLE_DATA FROM SHARE SFC_SAMPLES.SAMPLE_DATA;
GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE_SAMPLE_DATA TO ROLE PUBLIC;

create or replace database supply_chain_db;
create or replace schema supply_chain_db.supplier_details;

use database supply_chain_db;
use schema supplier_details;

CREATE OR REPLACE TABLE PART (
	P_PARTKEY NUMBER(38,0) COMMENT 'Unique part ID',
	P_NAME VARCHAR(55) COMMENT 'Name of the part',
	P_MFGR VARCHAR(25) COMMENT 'Original manufacturer of the part',
	P_BRAND VARCHAR(10) COMMENT 'The make or brand of the part.',
	P_TYPE VARCHAR(25) COMMENT 'Category or type of part',
	P_SIZE NUMBER(38,0) COMMENT 'Size or volume information, e.g. number of container in p_container column',
	P_CONTAINER VARCHAR(10) COMMENT 'Type of container used for shipment (e.g. box, bag, drum, etc.)',
	P_RETAILPRICE NUMBER(12,2) COMMENT 'Suggested retail price',
	P_COMMENT VARCHAR(23) COMMENT 'Optional comment describing the part.'
)COMMENT='Detailed information of the different types of parts that we are receiving from our suppliers. It includes manufacturer, brand, size, pricing information, and more.'
AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.PART;

CREATE OR REPLACE TABLE PARTSUPP 
COMMENT='This table represents the money to many relationship between parts and suppliers. It also provides the quantity available for a given part from a given supplier.'
AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.PARTSUPP;

CREATE OR REPLACE TABLE SUPPLIER (
	S_SUPPKEY NUMBER(38,0) COMMENT 'Supplier ID. Join with PARTSUPP table.',
	S_NAME VARCHAR(25) COMMENT 'Supplier legal name',
	S_ADDRESS VARCHAR(40) COMMENT 'Mailing and billing address',
	S_NATIONKEY NUMBER(38,0) COMMENT 'Suppliers HQ country of residence',
	S_PHONE VARCHAR(15) COMMENT 'Phone of the supplier''s contact person for us',
	S_ACCTBAL NUMBER(12,2) COMMENT 'The supplier''s account balance with us',
	S_COMMENT VARCHAR(101) COMMENT 'Optional comment or description'
)COMMENT='This table is an inventory of all our global suppliers including their contact information, address, and their account balance with us.'
AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.SUPPLIER;


-- Now that we have supplier to share, lets publish a data product:

use role supply_chain_admin_role;

CREATE OR REPLACE SHARE share_global_supplier_details;
GRANT USAGE ON DATABASE supply_chain_db TO SHARE share_global_supplier_details;
GRANT USAGE ON SCHEMA supplier_details TO SHARE share_global_supplier_details;
GRANT SELECT ON TABLE supply_chain_db.supplier_details.part TO SHARE share_global_supplier_details;
GRANT SELECT ON TABLE supply_chain_db.supplier_details.supplier TO SHARE share_global_supplier_details;
GRANT SELECT ON TABLE supply_chain_db.supplier_details.partsupp TO SHARE share_global_supplier_details;


CREATE ORGANIZATION LISTING global_supplier_details
SHARE share_global_supplier_details
AS $$
title: "Global Supplier Details"
description: "## About our Supplier Data:\n\nThis dataset provides a consolidated\
  \ view of our **global supplier network** and the components they provide. It includes\
  \ key supplier details such as unique Supplier ID, Name, Location (City, Country),\
  \ and Contact Information (Address, Phone). Linked to each supplier are the **specific\
  \ Part IDs and Part Names** they deliver, along with potential information like\
  \ Lead Time (in days) and Unit Price (in a generic currency).\n\n## Purpose:\n\n\
  This data can be used for ***supplier relationship management***, ***procurement\
  \ analysis***, and ***supply chain optimization***."
resources:
  documentation: "https://www.snowflake.com/resource/how-to-knit-your-data-mesh-on-snowflake/"
listing_terms:
  type: "CUSTOM"
  link: "http://www.snowflake.com/data-mesh"
auto_fulfillment:
  refresh_type: "SUB_DATABASE"
  refresh_schedule: "1440 MINUTE"
data_dictionary:
  featured:
    database: "SUPPLY_CHAIN_DB"
    objects:
    - schema: "SUPPLIER_DETAILS"
      domain: "TABLE"
      name: "PART"
    - schema: "SUPPLIER_DETAILS"
      domain: "TABLE"
      name: "SUPPLIER"
data_preview:
  has_pii: false
usage_examples:
- title: "Minimum Cost Supplier"
  description: "This query finds which supplier should be selected to place an order\
    \ for a given part."
  query: "select\n  s_acctbal,\n  s_name,\n  p_partkey,\n  p_mfgr,\n  s_address,\n\
    \  s_phone,\n  s_comment\nfrom\n  supplier_details.part,\n  supplier_details.supplier,\n\
    \  supplier_details.partsupp\nwhere\n  p_partkey = ps_partkey\n  and s_suppkey\
    \ = ps_suppkey\n  and p_size = 15\n  and p_type like '%BRASS'\n  and ps_supplycost\
    \ = (\n    select\n      min(ps_supplycost)\n    from\n      supplier_details.partsupp,\n\
    \      supplier_details.supplier\n    where\n      p_partkey = ps_partkey\n  \
    \    and s_suppkey = ps_suppkey)\norder by\n  s_acctbal desc,\n  s_name,\n  p_partkey\n\
    limit 100;\n"
data_attributes:
  refresh_rate: "DAILY"
  geography:
    geo_option: "GLOBAL"
    granularity:
    - "COUNTRY"
  time:
    granularity: "EVENT_BASED"
    time_range:
      time_frame: "LAST"
      units: "DAYS"
      value: 7
organization_profile: "SUPPLYCHAIN"
organization_targets:
  discovery:
  - all_internal_accounts: true
locations:
  access_regions:
  - name: "ALL"
request_approval_type: "REQUEST_AND_APPROVE_IN_SNOWFLAKE"
$$;

describe listing global_supplier_details;
