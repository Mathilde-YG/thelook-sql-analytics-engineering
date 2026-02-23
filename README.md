# thelook-sql-analytics-engineering

## What this project demonstrates
- Clean SQL modeling on BigQuery using theLook dataset
- Layered approach: staging → marts → metrics
- Product analytics KPIs: session-based funnel + retention cohort
- Data quality mindset: reusable QA checks (nulls, duplicates, sanity)

## Models
### Staging
- `stg_events`, `stg_users`, `stg_order_items`

### Marts
- `dim_users`, `fct_order_items`

### Metrics
- `funnel_sessions_daily` (daily conversion rates)
- `retention_cohort_first_purchase` (D1/D7/D30 retention)
- `data_quality_checks` (QA checklist)
