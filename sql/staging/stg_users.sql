CREATE OR REPLACE VIEW `thelook-ae-portfolio.thelook_portfolio.stg_users` AS
SELECT
  id AS user_id,
  gender,
  age,
  country,
  state,
  city,
  traffic_source,
  TIMESTAMP(created_at) AS user_created_ts,
  DATE(created_at) AS user_created_date,
  latitude,
  longitude
FROM `bigquery-public-data.thelook_ecommerce.users`;
