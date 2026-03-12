CREATE OR REPLACE TABLE blinkit_marketing_performance (
    
    campaign_id            NUMBER(10,0),
    campaign_name          VARCHAR(200),
    date                   DATE,
    target_audience        VARCHAR(100),
    channel                VARCHAR(50),
    
    impressions            NUMBER(12,0),
    clicks                 NUMBER(12,0),
    conversions            NUMBER(12,0),
    
    spend                  NUMBER(12,2),
    revenue_generated      NUMBER(12,2),
    roas                   NUMBER(5,2)
    
);

CREATE OR REPLACE TABLE blinkit_order_items (
    
    order_id        NUMBER(12,0),
    product_id      NUMBER(12,0),
    quantity        NUMBER(10,0),
    unit_price      NUMBER(10,2)
    
);

CREATE OR REPLACE TABLE blinkit_orders (
    
    order_id                 NUMBER(12,0),
    customer_id              NUMBER(12,0),
    
    order_date               TIMESTAMP_NTZ,
    promised_delivery_time   TIMESTAMP_NTZ,
    actual_delivery_time     TIMESTAMP_NTZ,
    
    delivery_status          VARCHAR(50),
    order_total              NUMBER(12,2),
    payment_method           VARCHAR(30),
    
    delivery_partner_id      NUMBER(12,0),
    store_id                 NUMBER(12,0)
    
);

CREATE OR REPLACE TABLE blinkit_delivery_performance (
    
    order_id                NUMBER(12,0) NOT NULL,
    delivery_partner_id     NUMBER(12,0) NOT NULL,
    
    promised_time           TIMESTAMP_NTZ NOT NULL,
    actual_time             TIMESTAMP_NTZ,
    
    delivery_time_minutes   NUMBER(6,2),
    distance_km             NUMBER(6,2),
    
    delivery_status         VARCHAR(50),
    reasons_if_delayed      VARCHAR(200),
    
    CONSTRAINT pk_delivery PRIMARY KEY (order_id)
);
