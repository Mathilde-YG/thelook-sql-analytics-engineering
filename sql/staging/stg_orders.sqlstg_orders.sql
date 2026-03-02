-- stg_orders.sql
-- Source: bigquery-public-data.thelook_ecommerce.orders
-- Grain: 1 row per order

WITH source AS (
  SELECT *
  FROM `bigquery-public-data.thelook_ecommerce.orders`
),

renamed AS (
  SELECT
    CAST(order_id AS INT64) AS order_id,
    CAST(user_id AS INT64)  AS user_id,
    status,
    created_at,
    shipped_at,
    delivered_at,
    returned_at,
    CAST(num_of_item AS INT64) AS num_of_item
  FROM source
)

SELECT
  order_id,
  user_id,
  status,
  created_at,
  DATE(created_at) AS order_date,
  shipped_at,
  delivered_at,
  returned_at,
  num_of_item,
  -- convenience flags
  shipped_at   IS NOT NULL AS is_shipped,
  delivered_at IS NOT NULL AS is_delivered,
  returned_at  IS NOT NULL AS is_returned
FROM renamed;
