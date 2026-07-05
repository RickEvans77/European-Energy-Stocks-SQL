CREATE TABLE prices (
    id      SERIAL PRIMARY KEY,
    ticker  VARCHAR(15) REFERENCES instruments(ticker),
    trade_date DATE NOT NULL,
    close   NUMERIC(12,4),
    volume  BIGINT,
    UNIQUE (ticker, trade_date)
);