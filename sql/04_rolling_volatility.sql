DROP VIEW IF EXISTS rolling_volatility;

CREATE VIEW rolling_volatility AS
SELECT
    ticker,
    trade_date,
    log_return,
    STDDEV_POP(log_return) OVER (
        PARTITION BY ticker
        ORDER BY trade_date
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    )::numeric AS rolling_vol_30d
FROM daily_returns;