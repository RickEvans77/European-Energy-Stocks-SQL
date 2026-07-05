CREATE OR REPLACE VIEW daily_returns AS
SELECT
    ticker,
    trade_date,
    close,
    LAG(close) OVER (PARTITION BY ticker ORDER BY trade_date) AS prev_close,
    LN(close / LAG(close) OVER (PARTITION BY ticker ORDER BY trade_date)) AS log_return
FROM prices;

SELECT * FROM daily_returns WHERE ticker = 'BP.L' ORDER BY trade_date LIMIT 5;