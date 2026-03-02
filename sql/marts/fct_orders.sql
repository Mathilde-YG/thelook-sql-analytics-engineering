-- fct_orders.sql
-- Grain: 1 row per order
-- Adds order-level measures aggregated from order_items

WITH orders AS (
  SELECT
    CAST(order_id AS INT64) AS order_id,
    CAST(user_id AS INT64)  AS user_id,
    status,
    created_at,
    DATE(created_at) AS order_date,
    shipped_at,
    delivered_at,
    returned_at,
    CAST(num_of_item AS INT64) AS num_of_item
  FROM `bigquery-public-data.thelook_ecommerce.orders`
),

order_items AS (
  SELECT
    CAST(order_id AS INT64) AS order_id,
    CAST(user_id AS INT64)  AS user_id,
    CAST(product_id AS INT64) AS product_id,
    CAST(sale_price AS FLOAT64) AS sale_price,
    status AS item_status,
    created_at AS item_created_at,
    shipped_at AS item_shipped_at,
    delivered_at AS item_delivered_at,
    returned_at AS item_returned_at
  FROM `bigquery-public-data.thelook_ecommerce.order_items`
),

agg_items AS (
  SELECT
    order_id,
    COUNT(*) AS items_count,
    SUM(sale_price) AS gross_revenue,
    AVG(sale_price) AS avg_item_price,
    COUNTIF(item_returned_at IS NOT NULL OR LOWER(item_status) = 'returned') AS returned_items_count
  FROM order_items
  GROUP BY order_id
)

SELECT
  o.order_id,
  o.user_id,
  o.status AS order_status,
  o.created_at AS order_created_at,
  o.order_date,
  o.shipped_at,
  o.delivered_at,
  o.returned_at,
  o.num_of_item,
  -- measures
  a.items_count,
  a.gross_revenue,
  a.avg_item_price,
  a.returned_items_count
FROM orders o
LEFT JOIN agg_items a USING(order_id);
