#  Retail Sales & Profitability Analytics Dashboard

**Live dashboard:** [https://public.tableau.com/app/profile/veeresh.belkeri/viz/RetailSalesProfitabilityAnalytics_17892328618090/RetailSalesProfitabilityAnalytics](https://public.tableau.com/app/profile/veeresh.belkeri/viz/RetailSalesProfitabilityAnalytics_17892328618090/RetailSalesProfitabilityAnalytics)
**Dataset:** Sample Superstore — 9,994 real US retail transactions (2014–2017)

## Problem
A retail business wants to understand where it makes money, where it loses money, and why — across regions, product categories, and discounting strategy — to guide pricing and inventory decisions.

## Approach
1. **Data cleaning:** Loaded and validated 9,994 transaction records (0 nulls, 0 duplicates). Parsed order/ship dates, calculated shipping duration, profit margin %, and monthly/yearly time features.
2. **Database:** Loaded the cleaned data into a SQLite database (`orders` table) to run real, production-style SQL — not just pandas filtering.
3. **SQL analysis:** Wrote 9 analytical queries covering KPIs, regional performance, category profitability, discount impact, customer value, shipping performance, and year-over-year growth (see `sql/analysis_queries.sql`).
4. **Dashboard:** Built an interactive Tableau dashboard on top of the cleaned data, visualizing sales/profit by region, category trends, the discount-vs-margin relationship, and monthly sales trends.

## Key Findings

| Finding | Detail |
|---|---|
| **Discounting kills margin** | Orders with 0% discount average **+34.0%** profit margin. Orders with 40%+ discount average **-108.9%** margin — deeply unprofitable. |
| **Tables are a loss leader** | Despite $206,965 in sales, the Tables sub-category lost **-$17,725** overall, driven by an average 26.1% discount. |
| **Central region underperforms** | Central has the lowest profit margin (7.92%) of all four regions, despite $501K in sales — West leads at 14.94% margin. |
| **Strong recent growth** | Sales grew 29.5% YoY in 2016 and 20.4% YoY in 2017, following a slight dip in 2015. |
| **Standard Class dominates shipping** | 60% of orders ship via Standard Class, averaging 5.0 days — the slowest option, a potential customer experience lever. |

## Tech stack
Python · Pandas · SQLite · SQL (aggregation, window functions, CASE logic) · Tableau

## Project structure
```
├── data/
│   ├── superstore.csv           # raw data
│   ├── superstore_clean.csv     # cleaned + feature-engineered
│   └── superstore.db            # SQLite database (orders table)
├── sql/
│   └── analysis_queries.sql     # 9 analytical SQL queries
├── outputs/
│   ├── region_summary.csv
│   ├── subcategory_summary.csv
│   ├── monthly_trend.csv
│   ├── discount_band_analysis.csv
│   └── top_customers.csv
├── notebooks/
│   └── 01_clean_and_load.py
└── README.md
```

## Run locally
```bash
git clone <your-repo-url>
cd sales-analytics-dashboard
pip install pandas
python notebooks/01_clean_and_load.py
# Then open data/superstore.db in any SQL tool, or superstore_clean.csv in Tableau
```
