-- Create Database
CREATE OR REPLACE DATABASE BLINKIT_DW;

-- Use Database
USE DATABASE BLINKIT_DW;

-- Create Schemas
CREATE OR REPLACE SCHEMA RAW;
CREATE OR REPLACE SCHEMA STAGING;
CREATE OR REPLACE SCHEMA ANALYTICS;

-- Create Internal Stage
USE SCHEMA RAW;

CREATE OR REPLACE STAGE BLINKIT_STAGE
COMMENT = 'Stage for Blinkit CSV Files';

CREATE OR REPLACE STAGE blinkit_stage;

COPY INTO blinkit_orders
FROM @blinkit_stage/blinkit_orders.csv
FILE_FORMAT = blinkit_csv_file_format
ON_ERROR = 'CONTINUE';

-- A️ Standard CSV Format (Orders, Marketing, Order Items)
CREATE OR REPLACE FILE FORMAT BLINKIT_CSV_FF
TYPE = 'CSV'
FIELD_DELIMITER = ','
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
TRIM_SPACE = TRUE
EMPTY_FIELD_AS_NULL = TRUE
NULL_IF = ('NULL', 'null', '')
DATE_FORMAT = 'DD-MM-YYYY'
TIMESTAMP_FORMAT = 'DD-MM-YYYY HH24:MI'
ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE;

-- ISO Timestamp Format (Delivery Performance)
CREATE OR REPLACE FILE FORMAT BLINKIT_CSV_ISO_FF
TYPE = 'CSV'
FIELD_DELIMITER = ','
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
TRIM_SPACE = TRUE
EMPTY_FIELD_AS_NULL = TRUE
NULL_IF = ('NULL', 'null', '')
TIMESTAMP_FORMAT = 'YYYY-MM-DD HH24:MI:SS'
ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE;

CREATE OR REPLACE TABLE RAW.BLINKIT_ORDERS (
    order_id                 NUMBER(12,0) NOT NULL,
    customer_id              NUMBER(12,0) NOT NULL,
    order_date               TIMESTAMP_NTZ,
    promised_delivery_time   TIMESTAMP_NTZ,
    actual_delivery_time     TIMESTAMP_NTZ,
    delivery_status          VARCHAR(50),
    order_total              NUMBER(12,2),
    payment_method           VARCHAR(30),
    delivery_partner_id      NUMBER(12,0),
    store_id                 NUMBER(12,0),
    CONSTRAINT pk_orders PRIMARY KEY (order_id)
);

CREATE OR REPLACE TABLE RAW.BLINKIT_ORDER_ITEMS (
    order_id        NUMBER(12,0) NOT NULL,
    product_id      NUMBER(12,0) NOT NULL,
    quantity        NUMBER(10,0),
    unit_price      NUMBER(10,2),
    total_price     NUMBER(12,2) AS (quantity * unit_price),
    CONSTRAINT pk_order_items PRIMARY KEY (order_id, product_id)
);

CREATE OR REPLACE TABLE RAW.BLINKIT_DELIVERY_PERFORMANCE (
    order_id                NUMBER(12,0) NOT NULL,
    delivery_partner_id     NUMBER(12,0),
    promised_time           TIMESTAMP_NTZ,
    actual_time             TIMESTAMP_NTZ,
    delivery_time_minutes   NUMBER(6,2) 
        AS (DATEDIFF('minute', promised_time, actual_time)),
    distance_km             NUMBER(6,2),
    delivery_status         VARCHAR(50),
    reasons_if_delayed      VARCHAR(200),
    CONSTRAINT pk_delivery PRIMARY KEY (order_id)
);

CREATE OR REPLACE TABLE RAW.BLINKIT_MARKETING_PERFORMANCE (
    campaign_id        NUMBER(10,0),
    campaign_name      VARCHAR(200),
    date               DATE,
    target_audience    VARCHAR(100),
    channel            VARCHAR(50),
    impressions        NUMBER(12,0),
    clicks             NUMBER(12,0),
    conversions        NUMBER(12,0),
    spend              NUMBER(12,2),
    revenue_generated  NUMBER(12,2),
    roas               NUMBER(5,2),
    CONSTRAINT pk_campaign PRIMARY KEY (campaign_id, date)
);

COPY INTO RAW.BLINKIT_ORDERS
FROM @RAW.BLINKIT_STAGE/blinkit_orders.csv
FILE_FORMAT = BLINKIT_CSV_FF
ON_ERROR = 'CONTINUE';

COPY INTO RAW.BLINKIT_ORDER_ITEMS
FROM @RAW.BLINKIT_STAGE/blinkit_order_items.csv
FILE_FORMAT = BLINKIT_CSV_FF
ON_ERROR = 'CONTINUE';

COPY INTO RAW.BLINKIT_DELIVERY_PERFORMANCE
FROM @RAW.BLINKIT_STAGE/blinkit_delivery_performance.csv
FILE_FORMAT = BLINKIT_CSV_ISO_FF
ON_ERROR = 'CONTINUE';

COPY INTO RAW.BLINKIT_MARKETING_PERFORMANCE
FROM @RAW.BLINKIT_STAGE/blinkit_marketing_performance.csv
FILE_FORMAT = BLINKIT_CSV_FF
ON_ERROR = 'CONTINUE';

