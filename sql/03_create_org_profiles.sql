-----------------------------------------------
-- Create data provider profiles
-- Each team or business unit that shares data products 
-- on the internal marketplace should have one profile
-- RUN THIS CODE IN THE HOL_ORG_ACCOUNT
--
-- Replace the red youremail@whatever.com with your
-- actual email address (6 times).
------------------------------------------------

USE ROLE globalorgadmin;
USE WAREHOUSE COMPUTE_WH;


CREATE OR REPLACE DATABASE OrgProfileDB;
CREATE OR REPLACE STAGE org_profile_stage;

-- Profile of the sales domain:
COPY INTO @org_profile_stage/profile_sales/manifest.yml
FROM (
  SELECT $$
title: "Sales"
description: "This is the profile of the global sales organization in the company. This includes account executives, sales engineers, sales analysts, and all the back office functions for the sales operations. Sales analysts and related back office teams are the primary owners of data products published by the sales domain.
\n
We provide various types of sales analytics data, sales forcast data and projections, as well as different types of historical sales analysis. We are also planning to share ML models as a product for teams to perform self-service sales forecast exercises.

\n - Business Domain Owner: James Kirk
\n - Domain Data Steward:  Leonard McCoy
\n - Lead Data Engineer:   Nyota Uhura
\n
 For data product Q&A please join the Slack channel:  #sales-data-products
\n For any other question please contact us at: captain.kirk@snowflake.com.
\n
"
contact: "youremail@whatever.com"
approver_contact: "youremail@whatever.com"
allowed_publishers:
  access:
    - all_internal_accounts: "true"
logo: "urn:icon:diamond:orange"
  $$
) SINGLE = TRUE
  OVERWRITE = TRUE
  FILE_FORMAT = (COMPRESSION = NONE ESCAPE_UNENCLOSED_FIELD = NONE);


-- Profile of the supply chain domain:  
COPY INTO @org_profile_stage/profile_supply/manifest.yml
FROM (
  SELECT $$
title: "Supply Chain"
description: "Welcome to the Supply Chain domain! This is the home of all supply chain related data products that we make available throughout the company. 
\n
The Supply Chain department is responsible for the end-to-end flow of our products, from the initial sourcing of raw materials through to the delivery of finished goods to our resellers. Our scope encompasses planning, procurement, manufacturing coordination, warehousing, transportation, and distribution. We are dedicated to ensuring efficiency, minimizing costs, mitigating risks, and ultimately ensuring production speed and quality through a reliable and optimized supply chain.
\n
Our Key Responsibilities Include:
\n	- Sourcing & Procurement: managing our network of suppliers to secure quality materials at competitive prices.
\n	- Logistics & Distribution: Managing warehousing, transportation, and delivery of materials and goods.
\n	- Inventory Management: Optimizing inventory levels to balance supply and demand while minimizing holding costs.
\n	- Supplier Relationship Management: Building and maintaining strong relationships with our key suppliers.
\n	- Supply Chain Optimization: Continuously identifying and implementing improvements to our processes and network.
\n	- Risk Management: Identifying and mitigating potential disruptions within the supply chain.
\n
To support other departments in making informed decisions, we maintain various types of data products, such as:
\n	- Inventory Reports & Dashboards: Real-time visibility into stock levels and potential shortages.
\n	- Order Status & Tracking: Information on the progress of purchase orders and shipment tracking details.
\n	- Supplier Performance Metrics: Data on supplier delivery performance, quality, and cost adherence.
\n	- Transportation & Logistics Reports: Data on shipping costs and on-time delivery rates.
\n  
Please reach out to the Supply Chain department if you have any other data needs related to our operations. We are here to support your success!
"
contact: "youremail@whatever.com"
approver_contact: "youremail@whatever.com"
allowed_publishers:
  access:
    - account: "HOL_ACCOUNT2"
logo: "urn:icon:blocks:aqua"
  $$
) SINGLE = TRUE
  OVERWRITE = TRUE
  FILE_FORMAT = (COMPRESSION = NONE ESCAPE_UNENCLOSED_FIELD = NONE);

-- Profile of the marketing domain:
COPY INTO @org_profile_stage/profile_marketing/manifest.yml
FROM (
  SELECT $$
title: "Marketing Team"
description: "Your Marketing Department: Driving Growth Through Customer Connection & Insights
\n\n
Who We Are: Your Marketing Department is dedicated to understanding our customers and the market to effectively promote our offerings, build our brand, and ultimately drive organizational growth. We are the team responsible for creating compelling messaging, engaging with our target audiences across various channels, and fostering strong customer relationships.
\n\nWhat Data We Provide: We are a key source of valuable data that informs strategic decisions across the organization. We provide insights on:

\n- Customer Understanding: Demographics, behaviors, preferences, feedback, and purchase history.
\n- Campaign Performance: Effectiveness of marketing initiatives, including reach, engagement, conversions, and ROI.
\n- Market & Competitive Landscape: Trends, competitor activities, and opportunities within our industry.
\n- Digital Performance: Website traffic, user behavior, and online engagement metrics.
\n- Lead Generation: Tracking and analyzing the flow of potential customers.
\n
How Our Data Helps You: Our data empowers informed decision-making in areas such as product development, sales strategies, customer service improvements, and overall business planning. By understanding our customers and the impact of our marketing efforts, we contribute directly to the company success!
\n"
contact: "youremail@whatever.com"
approver_contact: "youremail@whatever.com"
allowed_publishers:
  access:
    - account: "HOL_ACCOUNT1"
logo: "urn:icon:team:pink"
  $$
) SINGLE = TRUE
  OVERWRITE = TRUE
  FILE_FORMAT = (COMPRESSION = NONE ESCAPE_UNENCLOSED_FIELD = NONE);


-- Create the 3 profiles for the 3 domains:
CREATE ORGANIZATION PROFILE sales FROM @org_profile_stage/profile_sales/ PUBLISH = TRUE;


CREATE ORGANIZATION PROFILE supplychain FROM @org_profile_stage/profile_supply/ PUBLISH = TRUE;


CREATE ORGANIZATION PROFILE marketing FROM @org_profile_stage/profile_marketing/ PUBLISH = TRUE;

SHOW ORGANIZATION PROFILES;
-- You should see a result similar to this:
-----------------------------------------------
-- Create data provider profiles
-- Each team or business unit that shares data products 
-- on the internal marketplace should have one profile
-- RUN THIS CODE IN THE HOL_ORG_ACCOUNT
--
-- Replace the red youremail@whatever.com with your
-- actual email address (6 times).
------------------------------------------------

USE ROLE globalorgadmin;
USE WAREHOUSE COMPUTE_WH;


CREATE OR REPLACE DATABASE OrgProfileDB;
CREATE OR REPLACE STAGE org_profile_stage;

-- Profile of the sales domain:
COPY INTO @org_profile_stage/profile_sales/manifest.yml
FROM (
  SELECT $$
title: "Sales"
description: "This is the profile of the global sales organization in the company. This includes account executives, sales engineers, sales analysts, and all the back office functions for the sales operations. Sales analysts and related back office teams are the primary owners of data products published by the sales domain.
\n
We provide various types of sales analytics data, sales forcast data and projections, as well as different types of historical sales analysis. We are also planning to share ML models as a product for teams to perform self-service sales forecast exercises.

\n - Business Domain Owner: James Kirk
\n - Domain Data Steward:  Leonard McCoy
\n - Lead Data Engineer:   Nyota Uhura
\n
 For data product Q&A please join the Slack channel:  #sales-data-products
\n For any other question please contact us at: captain.kirk@snowflake.com.
\n
"
contact: "youremail@whatever.com"
approver_contact: "youremail@whatever.com"
allowed_publishers:
  access:
    - all_internal_accounts: "true"
logo: "urn:icon:diamond:orange"
  $$
) SINGLE = TRUE
  OVERWRITE = TRUE
  FILE_FORMAT = (COMPRESSION = NONE ESCAPE_UNENCLOSED_FIELD = NONE);


-- Profile of the supply chain domain:  
COPY INTO @org_profile_stage/profile_supply/manifest.yml
FROM (
  SELECT $$
title: "Supply Chain"
description: "Welcome to the Supply Chain domain! This is the home of all supply chain related data products that we make available throughout the company. 
\n
The Supply Chain department is responsible for the end-to-end flow of our products, from the initial sourcing of raw materials through to the delivery of finished goods to our resellers. Our scope encompasses planning, procurement, manufacturing coordination, warehousing, transportation, and distribution. We are dedicated to ensuring efficiency, minimizing costs, mitigating risks, and ultimately ensuring production speed and quality through a reliable and optimized supply chain.
\n
Our Key Responsibilities Include:
\n	- Sourcing & Procurement: managing our network of suppliers to secure quality materials at competitive prices.
\n	- Logistics & Distribution: Managing warehousing, transportation, and delivery of materials and goods.
\n	- Inventory Management: Optimizing inventory levels to balance supply and demand while minimizing holding costs.
\n	- Supplier Relationship Management: Building and maintaining strong relationships with our key suppliers.
\n	- Supply Chain Optimization: Continuously identifying and implementing improvements to our processes and network.
\n	- Risk Management: Identifying and mitigating potential disruptions within the supply chain.
\n
To support other departments in making informed decisions, we maintain various types of data products, such as:
\n	- Inventory Reports & Dashboards: Real-time visibility into stock levels and potential shortages.
\n	- Order Status & Tracking: Information on the progress of purchase orders and shipment tracking details.
\n	- Supplier Performance Metrics: Data on supplier delivery performance, quality, and cost adherence.
\n	- Transportation & Logistics Reports: Data on shipping costs and on-time delivery rates.
\n  
Please reach out to the Supply Chain department if you have any other data needs related to our operations. We are here to support your success!
"
contact: "youremail@whatever.com"
approver_contact: "youremail@whatever.com"
allowed_publishers:
  access:
    - account: "HOL_ACCOUNT2"
logo: "urn:icon:blocks:aqua"
  $$
) SINGLE = TRUE
  OVERWRITE = TRUE
  FILE_FORMAT = (COMPRESSION = NONE ESCAPE_UNENCLOSED_FIELD = NONE);

-- Profile of the marketing domain:
COPY INTO @org_profile_stage/profile_marketing/manifest.yml
FROM (
  SELECT $$
title: "Marketing Team"
description: "Your Marketing Department: Driving Growth Through Customer Connection & Insights
\n\n
Who We Are: Your Marketing Department is dedicated to understanding our customers and the market to effectively promote our offerings, build our brand, and ultimately drive organizational growth. We are the team responsible for creating compelling messaging, engaging with our target audiences across various channels, and fostering strong customer relationships.
\n\nWhat Data We Provide: We are a key source of valuable data that informs strategic decisions across the organization. We provide insights on:

\n- Customer Understanding: Demographics, behaviors, preferences, feedback, and purchase history.
\n- Campaign Performance: Effectiveness of marketing initiatives, including reach, engagement, conversions, and ROI.
\n- Market & Competitive Landscape: Trends, competitor activities, and opportunities within our industry.
\n- Digital Performance: Website traffic, user behavior, and online engagement metrics.
\n- Lead Generation: Tracking and analyzing the flow of potential customers.
\n
How Our Data Helps You: Our data empowers informed decision-making in areas such as product development, sales strategies, customer service improvements, and overall business planning. By understanding our customers and the impact of our marketing efforts, we contribute directly to the company success!
\n"
contact: "youremail@whatever.com"
approver_contact: "youremail@whatever.com"
allowed_publishers:
  access:
    - account: "HOL_ACCOUNT1"
logo: "urn:icon:team:pink"
  $$
) SINGLE = TRUE
  OVERWRITE = TRUE
  FILE_FORMAT = (COMPRESSION = NONE ESCAPE_UNENCLOSED_FIELD = NONE);


-- Create the 3 profiles for the 3 domains:
CREATE ORGANIZATION PROFILE sales FROM @org_profile_stage/profile_sales/ PUBLISH = TRUE;


CREATE ORGANIZATION PROFILE supplychain FROM @org_profile_stage/profile_supply/ PUBLISH = TRUE;


CREATE ORGANIZATION PROFILE marketing FROM @org_profile_stage/profile_marketing/ PUBLISH = TRUE;

SHOW ORGANIZATION PROFILES;
