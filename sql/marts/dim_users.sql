-- dim_users: cleaned user dimension for analysis
SELECT
  user_id,
  gender,
  age,
  country,
  state,
  city,
  traffic_source,
  user_created_date
FROM `thelook-ae-portfolio.thelook_portfolio.stg_users`;
