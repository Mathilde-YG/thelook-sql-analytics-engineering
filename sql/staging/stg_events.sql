CREATE OR REPLACE VIEW `thelook-ae-portfolio.thelook_portfolio.stg_events` AS
SELECT
  id AS event_id,
  user_id,
  session_id,
  sequence_number,
  TIMESTAMP(created_at) AS event_ts,
  DATE(created_at) AS event_date,
  LOWER(event_type) AS event_type,
  traffic_source,
  browser,
  uri,
  city,
  state,
  postal_code,
  ip_address
FROM `bigquery-public-data.thelook_ecommerce.events`
WHERE user_id IS NOT NULL;
