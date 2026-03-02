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


Data model & grain

stg_users: 1 row per user

dim_users: 1 row per user

stg_orders: 1 row per order

fct_orders: 1 row per order (+ revenue aggregated from order_items)

dim_products: 1 row per product

fct_order_items: 1 row per order item
