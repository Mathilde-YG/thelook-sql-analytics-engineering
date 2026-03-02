-- stg_products.sql
-- Source: bigquery-public-data.thelook_ecommerce.products
-- Grain: 1 row per product

WITH source AS (
  SELECT *
  FROM `bigquery-public-data.thelook_ecommerce.products`
),

renamed AS (
  SELECT
    CAST(id AS INT64) AS product_id,
    name,
    brand,
    category,
    department,
    sku,
    CAST(cost AS FLOAT64) AS cost,
    CAST(retail_price AS FLOAT64) AS retail_price,
    CAST(distribution_center_id AS INT64) AS distribution_center_id
  FROM source
)

SELECT
  product_id,
  name,
  brand,
  category,
  department,
  sku,
  cost,
  retail_price,
  distribution_center_id
FROM renamed;
