-- sql/STEP7a(HOL_ACCOUNT1)_create_sample_listing.sql
-------------------------------------------
-- Create Sample Listing 2 in hol_account1
-- Login into hol_account1 as marketing_admin
--------------------------------------------

use role marketing_analyst_role;
use database tpch;
use schema sf1;

create or replace secure view TPCH.SF1.campaign_details(
	c_mktsegment COMMENT 'Market segment for campaign targeting',
	c_name       COMMENT 'Customer full name',
	c_address    COMMENT 'Customer mailing address for brochures',
	c_phone      COMMENT 'Customer phone number for cold calling',
	n_name       COMMENT 'Country name',
    n_regionkey  COMMENT 'Contnent code'
) COMMENT='This view provides critical marketing campaing management details, such as a detailed list of target customers in Europe.'
 as
  select c_mktsegment , c_name, c_address, c_phone, n_name, n_regionkey
  from sf1.customer, sf1.nation
  where c_nationkey = n_nationkey
  and n_regionkey = 3;


CREATE OR REPLACE SHARE share_campaign_details;
GRANT USAGE ON DATABASE tpch TO SHARE share_campaign_details;
GRANT USAGE ON SCHEMA tpch.sf1 TO SHARE share_campaign_details;
GRANT SELECT ON VIEW tpch.sf1.campaign_details TO SHARE share_campaign_details;

CREATE ORGANIZATION LISTING campaign_details
SHARE share_campaign_details
AS $$
title: "Campaign Details"
description: "# Overview:\n\nThis dataset contains details about marketing campaigns\
  \ for one or more market segments. It includes features such as customer demographics\
  \ (age, gender, location),  communication channel for the campaign (e.g., mail,\
  \ phone), and other groundbreaking information that you cannot find anywhere else\
  \ :-).\n\n**Purpose:**\n\nThis data can be used to plan and execute marketing campaigns\
  \ or to analyze the effectiveness of previous marketing strategies, understand customer\
  \ response patterns, and potentially build predictive models for future campaigns."
resources:
  documentation: "http://www.snowflake.com/data-mesh"
listing_terms:
  type: "CUSTOM"
  link: "https://www.snowflake.com/resource/how-to-knit-your-data-mesh-on-snowflake/"
data_dictionary:
  featured:
    database: "TPCH"
    objects:
    - schema: "SF1"
      domain: "VIEW"
      name: "CAMPAIGN_DETAILS"
data_preview:
  has_pii: false
usage_examples:
- title: "Review the details of targeted customers"
  description: "It doesn't get any simpler than this!"
  query: "select * from sf1.campaign_details limit 100;"
data_attributes:
  refresh_rate: "QUARTERLY"
  geography:
    geo_option: "GLOBAL"
    granularity:
    - "COUNTY"
  time:
    granularity: "EVENT_BASED"
    time_range:
      time_frame: "LAST"
      units: "MONTHS"
      value: 1
organization_profile: "MARKETING"
organization_targets:
  discovery:
  - account: "HOL_ACCOUNT1"
  - account: "HOL_ACCOUNT2"
locations:
  access_regions:
  - name: "ALL"
request_approval_type: "REQUEST_AND_APPROVE_IN_SNOWFLAKE"
$$;

