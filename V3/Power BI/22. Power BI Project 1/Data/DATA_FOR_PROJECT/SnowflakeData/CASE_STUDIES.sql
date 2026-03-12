/* ============================================================
   BLINKIT ADVANCED BUSINESS SQL CASE STUDIES
   Author: AnalyticsWithAnand
   Database: BLINKIT_DW
   Schema: RAW
   ============================================================ */


/* ============================================================
   SECTION 1: MARKETING PERFORMANCE ANALYSIS
   ============================================================ */

-- 1. Which campaign has the highest ROI?
SELECT 
    campaign_name,
    SUM(revenue_generated) / NULLIF(SUM(spend),0) AS roi
FROM RAW.BLINKIT_MARKETING_PERFORMANCE
GROUP BY campaign_name
ORDER BY roi DESC;


-- 2. Which channel gives the best conversion rate?
SELECT 
    channel,
    SUM(conversions) * 100.0 / NULLIF(SUM(clicks),0) AS conversion_rate
FROM RAW.BLINKIT_MARKETING_PERFORMANCE
GROUP BY channel
ORDER BY conversion_rate DESC;


-- 3. Detect underperforming campaigns (ROAS < 2)
SELECT *
FROM RAW.BLINKIT_MARKETING_PERFORMANCE
WHERE roas < 2;


-- 4. Daily marketing spend trend
SELECT 
    date,
    SUM(spend) AS total_spend
FROM RAW.BLINKIT_MARKETING_PERFORMANCE
GROUP BY date
ORDER BY date;


-- 5. Cost per conversion by campaign
SELECT 
    campaign_name,
    SUM(spend) / NULLIF(SUM(conversions),0) AS cost_per_conversion
FROM RAW.BLINKIT_MARKETING_PERFORMANCE
GROUP BY campaign_name;



/* ============================================================
   SECTION 2: ORDERS ANALYSIS
   ============================================================ */

-- 6. Monthly revenue trend
SELECT 
    DATE_TRUNC('MONTH', order_date) AS month,
    SUM(order_total) AS revenue
FROM RAW.BLINKIT_ORDERS
GROUP BY month
ORDER BY month;


-- 7. Top 10 customers by revenue
SELECT 
    customer_id,
    SUM(order_total) AS total_spent
FROM RAW.BLINKIT_ORDERS
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;


-- 8. Payment method distribution
SELECT 
    payment_method,
    COUNT(*) AS orders_count
FROM RAW.BLINKIT_ORDERS
GROUP BY payment_method;


-- 9. Repeat customers
SELECT 
    customer_id,
    COUNT(order_id) AS total_orders
FROM RAW.BLINKIT_ORDERS
GROUP BY customer_id
HAVING COUNT(order_id) > 1;


-- 10. Average Order Value (AOV)
SELECT 
    AVG(order_total) AS avg_order_value
FROM RAW.BLINKIT_ORDERS;



/* ============================================================
   SECTION 3: ORDER ITEMS ANALYSIS
   ============================================================ */

-- 11. Top selling products by quantity
SELECT 
    product_id,
    SUM(quantity) AS total_quantity
FROM RAW.BLINKIT_ORDER_ITEMS
GROUP BY product_id
ORDER BY total_quantity DESC
LIMIT 10;


-- 12. Revenue by product
SELECT 
    product_id,
    SUM(total_price) AS total_revenue
FROM RAW.BLINKIT_ORDER_ITEMS
GROUP BY product_id
ORDER BY total_revenue DESC;


-- 13. Average basket size
SELECT 
    AVG(item_count) AS avg_items_per_order
FROM (
    SELECT 
        order_id, 
        COUNT(*) AS item_count
    FROM RAW.BLINKIT_ORDER_ITEMS
    GROUP BY order_id
);



/* ============================================================
   SECTION 4: DELIVERY PERFORMANCE ANALYSIS
   ============================================================ */

-- 14. On-time delivery percentage
SELECT 
    COUNT_IF(delivery_status = 'On Time') * 100.0 / COUNT(*) 
        AS on_time_percentage
FROM RAW.BLINKIT_DELIVERY_PERFORMANCE;


-- 15. Average delivery time by partner
SELECT 
    delivery_partner_id,
    AVG(delivery_time_minutes) AS avg_delivery_time
FROM RAW.BLINKIT_DELIVERY_PERFORMANCE
GROUP BY delivery_partner_id
ORDER BY avg_delivery_time;


-- 16. Most common delay reason
SELECT 
    reasons_if_delayed,
    COUNT(*) AS occurrences
FROM RAW.BLINKIT_DELIVERY_PERFORMANCE
WHERE delivery_status <> 'On Time'
GROUP BY reasons_if_delayed
ORDER BY occurrences DESC;


-- 17. Correlation between distance and delivery time
SELECT 
    CORR(distance_km, delivery_time_minutes) AS correlation_value
FROM RAW.BLINKIT_DELIVERY_PERFORMANCE;



/* ============================================================
   SECTION 5: CROSS-TABLE BUSINESS ANALYSIS
   ============================================================ */

-- 18. Revenue impact of late deliveries
SELECT 
    d.delivery_status,
    SUM(o.order_total) AS total_revenue
FROM RAW.BLINKIT_ORDERS o
JOIN RAW.BLINKIT_DELIVERY_PERFORMANCE d
    ON o.order_id = d.order_id
GROUP BY d.delivery_status;


-- 19. Marketing spend vs orders generated (daily)
SELECT 
    m.date,
    SUM(m.spend) AS total_spend,
    COUNT(o.order_id) AS total_orders
FROM RAW.BLINKIT_MARKETING_PERFORMANCE m
LEFT JOIN RAW.BLINKIT_ORDERS o
    ON DATE(o.order_date) = m.date
GROUP BY m.date
ORDER BY m.date;


-- 20. Conversion funnel summary
SELECT 
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(conversions) AS total_conversions
FROM RAW.BLINKIT_MARKETING_PERFORMANCE;


-- 21. Store performance ranking
SELECT 
    store_id,
    SUM(order_total) AS total_revenue,
    RANK() OVER (ORDER BY SUM(order_total) DESC) AS store_rank
FROM RAW.BLINKIT_ORDERS
GROUP BY store_id;


-- 22. Customer Lifetime Value (CLV)
SELECT 
    customer_id,
    SUM(order_total) AS lifetime_value
FROM RAW.BLINKIT_ORDERS
GROUP BY customer_id
ORDER BY lifetime_value DESC;


-- 23. Delivery SLA breach percentage
SELECT 
    COUNT_IF(delivery_time_minutes > 0) * 100.0 / COUNT(*) 
        AS sla_breach_percentage
FROM RAW.BLINKIT_DELIVERY_PERFORMANCE;


-- 24. Most profitable marketing channel
SELECT 
    channel,
    SUM(revenue_generated) - SUM(spend) AS net_profit
FROM RAW.BLINKIT_MARKETING_PERFORMANCE
GROUP BY channel
ORDER BY net_profit DESC;


-- 25. Peak order hour analysis
SELECT 
    EXTRACT(HOUR FROM order_date) AS order_hour,
    COUNT(*) AS total_orders
FROM RAW.BLINKIT_ORDERS
GROUP BY order_hour
ORDER BY total_orders DESC;
