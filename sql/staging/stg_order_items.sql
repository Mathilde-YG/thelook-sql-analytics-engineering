CREATE OR REPLACE VIEW `thelook-ae-portfolio.thelook_portfolio.stg_order_items` AS
SELECT
  id AS order_item_id,
  order_id,
  user_id,
  product_id,
  inventory_item_id,
  status AS order_item_status,
  sale_price,
  TIMESTAMP(created_at) AS order_item_created_ts,
  DATE(created_at) AS order_item_created_date,
  TIMESTAMP(shipped_at) AS shipped_ts,
  TIMESTAMP(delivered_at) AS delivered_ts,
  TIMESTAMP(returned_at) AS returned_ts
FROM `bigquery-public-data.thelook_ecommerce.order_items`;
