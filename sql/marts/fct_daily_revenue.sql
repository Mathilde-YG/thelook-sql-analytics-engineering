-- fct_daily_revenue.sql
-- Grain: 1 row per day

WITH fct_orders AS (
  SELECT
    o.order_id,
    o.user_id,
    o.created_at,
    a.gross_revenue,
    a.items_count
  FROM `bigquery-public-data.thelook_ecommerce.orders` o
  LEFT JOIN (
    SELECT
      CAST(order_id AS INT64) AS order_id,
      SUM(CAST(sale_price AS FLOAT64)) AS gross_revenue,
      COUNT(*) AS items_count
    FROM `bigquery-public-data.thelook_ecommerce.order_items`
    GROUP BY order_id
  ) a
  ON CAST(o.order_id AS INT64) = a.order_id
)

SELECT
  DATE(created_at) AS order_date,
  COUNT(DISTINCT order_id) AS orders_count,
  COUNT(DISTINCT user_id)  AS buyers_count,
  SUM(gross_revenue) AS gross_revenue,
  SUM(items_count) AS items_count,
  SAFE_DIVIDE(SUM(gross_revenue), COUNT(DISTINCT order_id)) AS avg_order_value
FROM fct_orders
GROUP BY order_date
ORDER BY order_date DESC;
