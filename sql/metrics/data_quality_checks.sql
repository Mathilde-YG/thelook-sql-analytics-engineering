WITH checks AS (
  -- 1) Null checks
  SELECT
    'stg_events.user_id_null' AS check_name,
    COUNTIF(user_id IS NULL) AS issue_count
  FROM `thelook-ae-portfolio.thelook_portfolio.stg_events`

  UNION ALL
  SELECT
    'stg_users.user_id_null',
    COUNTIF(user_id IS NULL)
  FROM `thelook-ae-portfolio.thelook_portfolio.stg_users`

  UNION ALL
  SELECT
    'stg_order_items.order_item_id_null',
    COUNTIF(order_item_id IS NULL)
  FROM `thelook-ae-portfolio.thelook_portfolio.stg_order_items`

  -- 2) Duplicate key checks
  UNION ALL
  SELECT
    'stg_events.event_id_duplicates',
    COUNT(*) - COUNT(DISTINCT event_id)
  FROM `thelook-ae-portfolio.thelook_portfolio.stg_events`

  UNION ALL
  SELECT
    'stg_users.user_id_duplicates',
    COUNT(*) - COUNT(DISTINCT user_id)
  FROM `thelook-ae-portfolio.thelook_portfolio.stg_users`

  UNION ALL
  SELECT
    'stg_order_items.order_item_id_duplicates',
    COUNT(*) - COUNT(DISTINCT order_item_id)
  FROM `thelook-ae-portfolio.thelook_portfolio.stg_order_items`

  -- 3) Basic value sanity checks
  UNION ALL
  SELECT
    'stg_order_items.sale_price_negative',
    COUNTIF(sale_price < 0)
  FROM `thelook-ae-portfolio.thelook_portfolio.stg_order_items`
)
SELECT
  check_name,
  issue_count,
  IF(issue_count = 0, 'PASS', 'FAIL') AS status
FROM checks
ORDER BY status DESC, check_name;


-- stg_orders: null / duplicate
SELECT 'stg_orders' AS table_name, 'null_order_id' AS check_name, COUNT(*) AS issue_count
FROM (SELECT CAST(order_id AS INT64) AS order_id FROM `bigquery-public-data.thelook_ecommerce.orders`)
WHERE order_id IS NULL

UNION ALL
SELECT 'stg_orders', 'duplicate_order_id', COUNT(*) 
FROM (
  SELECT CAST(order_id AS INT64) AS order_id
  FROM `bigquery-public-data.thelook_ecommerce.orders`
)
GROUP BY order_id
HAVING COUNT(*) > 1

UNION ALL
-- dim_products: null / duplicate
SELECT 'dim_products', 'null_product_id', COUNT(*) 
FROM (SELECT CAST(id AS INT64) AS product_id FROM `bigquery-public-data.thelook_ecommerce.products`)
WHERE product_id IS NULL

UNION ALL
SELECT 'dim_products', 'duplicate_product_id', COUNT(*)
FROM (
  SELECT CAST(id AS INT64) AS product_id
  FROM `bigquery-public-data.thelook_ecommerce.products`
)
GROUP BY product_id
HAVING COUNT(*) > 1

UNION ALL
-- fct_orders: negative revenue sanity (order_items)
SELECT 'fct_orders', 'negative_revenue_orders', COUNT(*)
FROM (
  SELECT
    CAST(order_id AS INT64) AS order_id,
    SUM(CAST(sale_price AS FLOAT64)) AS gross_revenue
  FROM `bigquery-public-data.thelook_ecommerce.order_items`
  GROUP BY order_id
)
WHERE gross_revenue < 0;
