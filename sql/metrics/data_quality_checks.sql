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
