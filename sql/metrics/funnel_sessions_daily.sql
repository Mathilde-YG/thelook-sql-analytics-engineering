-- Daily session funnel based on theLook events
-- Note: event_type values must exist in the dataset (check Day1 query if needed)

WITH base_events AS (
  SELECT
    user_id,
    session_id,
    TIMESTAMP(created_at) AS event_ts,
    LOWER(event_type) AS event_type
  FROM `bigquery-public-data.thelook_ecommerce.events`
  WHERE user_id IS NOT NULL
    AND LOWER(event_type) IN ('home','product','cart','purchase')
),
session_events AS (
  SELECT
    user_id,
    session_id,
    MIN(IF(event_type='home', event_ts, NULL))     AS home_ts,
    MIN(IF(event_type='product', event_ts, NULL))  AS product_ts,
    MIN(IF(event_type='cart', event_ts, NULL))     AS cart_ts,
    MIN(IF(event_type='purchase', event_ts, NULL)) AS purchase_ts
  FROM base_events
  GROUP BY 1,2
),
daily AS (
  SELECT
    DATE(COALESCE(home_ts, product_ts, cart_ts, purchase_ts)) AS dt,
    COUNT(*) AS sessions_total,
    COUNTIF(home_ts IS NOT NULL) AS sessions_home,
    COUNTIF(product_ts IS NOT NULL) AS sessions_product,
    COUNTIF(cart_ts IS NOT NULL) AS sessions_cart,
    COUNTIF(purchase_ts IS NOT NULL) AS sessions_purchase
  FROM session_events
  GROUP BY 1
)
SELECT
  dt,
  sessions_total,
  sessions_home,
  sessions_product,
  sessions_cart,
  sessions_purchase,
  SAFE_DIVIDE(sessions_product, sessions_home)    AS home_to_product_rate,
  SAFE_DIVIDE(sessions_cart, sessions_product)    AS product_to_cart_rate,
  SAFE_DIVIDE(sessions_purchase, sessions_cart)   AS cart_to_purchase_rate,
  SAFE_DIVIDE(sessions_purchase, sessions_home)   AS home_to_purchase_rate
FROM daily
ORDER BY dt;
