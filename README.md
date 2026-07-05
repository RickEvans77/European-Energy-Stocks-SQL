# European Energy Stocks — SQL Data Pipeline
A PostgreSQL/Supabase data pipeline that transforms the European Energy Stocks portfolio dataset into a relational database, with analytical views for daily returns, rolling volatility, and beta — feeding a downstream Power BI dashboard.

## Motivation
This project extends the original [European Energy Stocks Portfolio Analysis](https://github.com/RickEvans77/European-Energy-Stocks-Portfolio-Analysis) by building the data infrastructure layer that a real-world analytics workflow requires: instead of keeping the dataset in memory within a notebook, the data is migrated into a relational database, structured with normalized tables and SQL views, and made ready for consumption by a BI tool. The objective is to demonstrate an end-to-end pipeline — from raw market data to a queryable, production-style data layer.

## What the Project Does
The pipeline is divided into four main stages:

### 1. Data Extraction & Transformation (Python)
Historical daily price and volume data for the same six European energy companies is reshaped from wide format (one column per ticker) into long format (`ticker`, `trade_date`, `close`, `volume`), using `pandas.melt()`, to match a relational database schema:
* E.ON (EOAN.DE)
* Iberdrola (IBE.MC)
* TotalEnergies (TTE.PA)
* BP (BP.L)
* Engie (ENGI.PA)
* Equinor (EQNR.OL)
* OMX Paris Oil & Gas Index (OIL.PA) — benchmark

### 2. Database Schema (PostgreSQL / Supabase)
Two normalized tables store the core data:
* `instruments` — ticker metadata (name, country, sector, benchmark flag)
* `prices` — daily close price and volume per ticker, with a `UNIQUE (ticker, trade_date)` constraint to prevent duplicate records

Data is loaded via SQLAlchemy using idempotent `INSERT ... ON CONFLICT DO NOTHING` statements, so the pipeline can be safely re-run without creating duplicate rows.

### 3. Analytical Views (SQL)
Three SQL views compute the core financial metrics directly in the database:
* `daily_returns` — daily log returns per ticker, using window functions (`LAG`, `LN`)
* `rolling_volatility` — 30-day rolling standard deviation of log returns, using a `ROWS BETWEEN 29 PRECEDING AND CURRENT ROW` window frame
* `beta` — asset beta relative to the OIL.PA benchmark, computed with `COVAR_POP` / `VAR_POP`

### 4. BI Consumption (Power BI)
The views are designed to be queried directly by Power BI, enabling a live dashboard on top of the database rather than a static export.
<!-- Cuando tengas el dashboard: <img width="XXXX" alt="powerbi_dashboard" src="LINK_DE_LA_CAPTURA" /> -->

## Design Decisions
* **Idempotent loads:** all insert operations use `ON CONFLICT DO NOTHING`, so the notebook can be re-run against the same database without errors or duplicate data.
* **Credentials handling:** the database connection string is never hardcoded. It is loaded from a local `.env` file (excluded via `.gitignore`) using `python-dotenv`. See `.env.example` for the required format.
* **View-based analytics:** rolling volatility and beta are computed as SQL views rather than in Python, so any BI tool connecting to the database gets consistent, always-up-to-date metrics without re-running the notebook.

## Tech Stack
* Python (pandas, SQLAlchemy)
* PostgreSQL (Supabase)
* Power BI
* yfinance

## Repository Structure
```
├── sql/
│   ├── 01_instruments.sql
│   ├── 02_prices.sql
│   ├── 03_daily_log_returns.sql
│   ├── 04_rolling_volatility.sql
│   └── 05_beta.sql
├── Portfolio Energy Companies + SQL.ipynb
├── .env.example
├── .gitignore
├── LICENSE
└── README.md
```
