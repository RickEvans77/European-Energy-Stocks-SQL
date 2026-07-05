create or replace view beta as
select
   a.ticker,
   covar_pop(a.log_return, b.log_return) / var_pop(b.log_return) as beta
from daily_returns a
join daily_returns b
    on a.trade_date = b.trade_date
    and b.ticker = 'OIL.PA'
where a.ticker != 'OIL.PA'
group by a.ticker;

SELECT * FROM beta ORDER BY beta DESC;