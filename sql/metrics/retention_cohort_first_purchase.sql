-- Retention cohort: first purchase date as cohort
WITH first_purchase AS (
  SELECT
    user_id,
    MIN(DATE(created_at)) AS cohort_date
  FROM `bigquery-public-data.thelook_ecommerce.events`
  WHERE user_id IS NOT NULL
    AND LOWER(event_type) = 'purchase'
  GROUP BY 1
),
activity AS (
  SELECT
    user_id,
    DATE(created_at) AS activity_date
  FROM `bigquery-public-data.thelook_ecommerce.events`
  WHERE user_id IS NOT NULL
),
cohort_activity AS (
  SELECT
    f.cohort_date,
    a.user_id,
    DATE_DIFF(a.activity_date, f.cohort_date, DAY) AS day_n
  FROM first_purchase f
  JOIN activity a
    ON a.user_id = f.user_id
  WHERE a.activity_date BETWEEN f.cohort_date AND DATE_ADD(f.cohort_date, INTERVAL 30 DAY)
)
SELECT
  cohort_date,
  COUNT(DISTINCT IF(day_n = 0,  user_id, NULL)) AS cohort_size,
  COUNT(DISTINCT IF(day_n = 1,  user_id, NULL)) AS d1_users,
  COUNT(DISTINCT IF(day_n = 7,  user_id, NULL)) AS d7_users,
  COUNT(DISTINCT IF(day_n = 30, user_id, NULL)) AS d30_users,
  SAFE_DIVIDE(COUNT(DISTINCT IF(day_n = 1,  user_id, NULL)),
              COUNT(DISTINCT IF(day_n = 0,  user_id, NULL))) AS d1_retention,
  SAFE_DIVIDE(COUNT(DISTINCT IF(day_n = 7,  user_id, NULL)),
              COUNT(DISTINCT IF(day_n = 0,  user_id, NULL))) AS d7_retention,
  SAFE_DIVIDE(COUNT(DISTINCT IF(day_n = 30, user_id, NULL)),
              COUNT(DISTINCT IF(day_n = 0,  user_id, NULL))) AS d30_retention
FROM cohort_activity
GROUP BY 1
ORDER BY cohort_date;
