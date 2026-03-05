## Project: thelook SQL Analytics Engineering (BigQuery)

Goal: Build BI-ready datasets (staging → marts → metrics) from thelook_ecommerce in BigQuery.

Outputs: dim/fct tables + fct_daily_revenue + KPI queries (funnel/retention) + data quality checks.

Focus: data modeling (grain/keys) + reliability (null/duplicate/sanity checks).

### Goal
Build BI-ready datasets from **thelook_ecommerce** (BigQuery public dataset) using a layered approach:
**staging → marts (dim/fct) → metrics + data quality checks**.

### Data Source
`bigquery-public-data.thelook_ecommerce.*`

### What’s inside (Layers)
- **staging/**: standardized, analysis-friendly views (clean naming/casting, minimal transformations)
- **marts/**: BI-ready models (dimensions & facts) for reporting and dashboards
- **metrics/**: KPI queries (funnel, retention) + data quality checks

### Data model & grain (very important)
- **dim_users**: 1 row per user (PK: user_id)
- **dim_products**: 1 row per product (PK: product_id)
- **fct_orders**: 1 row per order (PK: order_id)
- **fct_order_items**: 1 row per order item (PK: order_item_id / or composite key depending on source)
- **fct_daily_revenue**: 1 row per day (PK: order_date)

### Key outputs
- Daily performance table: `fct_daily_revenue`
- User/product/order analysis-ready marts: dim/fct tables above
- KPI queries: `funnel_sessions_daily`, `retention_cohort_first_purchase`
- Reliability guardrails: `data_quality_checks.sql` (null/duplicate/sanity checks)

### How to run (BigQuery)
Run SQL files in this order:
1) `staging/*`
2) `marts/*`
3) `metrics/*`

### Data quality approach
Quality checks are designed to detect:
- null / duplicate keys (PK integrity)
- sanity issues (e.g., negative revenue)
- consistency issues across core entities

### Next steps (optional)
- migrate models to **dbt** (tests: not_null/unique/relationships, docs)
- schedule runs (daily) + alerting on failed quality checks
