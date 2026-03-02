-- dim_products.sql
-- Grain: 1 row per product

WITH products AS (
  SELECT *
  FROM `bigquery-public-data.thelook_ecommerce.products`
)

SELECT
  CAST(id AS INT64) AS product_id,
  name,
  brand,
  category,
  department,
  sku,
  CAST(cost AS FLOAT64) AS cost,
  CAST(retail_price AS FLOAT64) AS retail_price,
  CAST(retail_price AS FLOAT64) - CAST(cost AS FLOAT64) AS unit_margin,
  CAST(distribution_center_id AS INT64) AS distribution_center_id
FROM products;
