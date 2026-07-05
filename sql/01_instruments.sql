CREATE TABLE IF NOT EXISTS instruments (
    ticker      VARCHAR(15) PRIMARY KEY,
    name        VARCHAR(100),
    country     VARCHAR(50),
    sector      VARCHAR(50),
    is_benchmark BOOLEAN DEFAULT FALSE
);

UPDATE instruments SET name = 'E.ON SE', country = 'Germany', sector = 'Utilities' WHERE ticker = 'EOAN.DE';
UPDATE instruments SET name = 'Iberdrola', country = 'Spain', sector = 'Utilities' WHERE ticker = 'IBE.MC';
UPDATE instruments SET name = 'Engie', country = 'France', sector = 'Utilities' WHERE ticker = 'ENGI.PA';
UPDATE instruments SET name = 'TotalEnergies', country = 'France', sector = 'Oil & Gas' WHERE ticker = 'TTE.PA';
UPDATE instruments SET name = 'BP plc', country = 'UK', sector = 'Oil & Gas' WHERE ticker = 'BP.L';
UPDATE instruments SET name = 'Equinor', country = 'Norway', sector = 'Oil & Gas' WHERE ticker = 'EQNR.OL';
UPDATE instruments SET name = 'OMX Paris Oil & Gas Index', is_benchmark = TRUE WHERE ticker = 'OIL.PA';
UPDATE instruments SET sector = 'Benchmark' WHERE ticker = 'OIL.PA'