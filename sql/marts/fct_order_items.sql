-- fct_order_items: order item level fact table
WITH order_items AS (
  SELECT
    order_item_id,
    order_id,
    user_id,
    product_id,
    order_item_created_date,
    order_item_status,
    sale_price,
    returned_ts
  FROM `thelook-ae-portfolio.thelook_portfolio.stg_order_items`
)
SELECT
  order_item_id,
  order_id,
  user_id,
  product_id,
  order_item_created_date,
  order_item_status,
  sale_price,
  (returned_ts IS NOT NULL OR LOWER(order_item_status) = 'returned') AS is_returned
FROM order_items;
