WITH cake_first_time AS (
  SELECT 
    DISTINCT taker AS trader,
    MIN(block_time) AS first_week
  FROM pancakeswap.trades
  WHERE block_date > NOW() - INTERVAL '180' day
  GROUP BY 1
),

new_tra AS (
  SELECT
    DATE_TRUNC('week', first_week) AS "Date(week)",
    COUNT(trader) AS new_traders
  FROM cake_first_time
  GROUP BY 1
),

returning_tra AS (
  SELECT
    DATE_TRUNC('week', pt.block_time) AS "Date(week)",
    COUNT(DISTINCT pt.taker) AS returning_traders
  FROM pancakeswap.trades pt
  JOIN cake_first_time cf ON pt.taker = cf.trader
  WHERE pt.block_time > cf.first_week
    AND pt.block_date > NOW() - INTERVAL '180' day
  GROUP BY 1
),

curr_traders AS (
  SELECT
    DATE_TRUNC('week', block_time) AS "Date(week)",
    COUNT(DISTINCT taker) AS current_traders
  FROM pancakeswap.trades
  WHERE block_date > NOW() - INTERVAL '180' day
  GROUP BY 1
),

active_later AS (
  SELECT DISTINCT taker AS trader
  FROM pancakeswap.trades pt
  JOIN cake_first_time cf ON pt.taker = cf.trader
  WHERE pt.block_time > cf.first_week
),

churned_traders AS (
  SELECT
    DATE_TRUNC('week', first_week) AS "Date(week)",
    -COUNT(cf.trader) AS churned_traders  -- negative count here
  FROM cake_first_time cf
  LEFT JOIN active_later al ON cf.trader = al.trader
  WHERE al.trader IS NULL
  GROUP BY 1
)

SELECT 
  COALESCE(n."Date(week)", r."Date(week)") AS "Date(week)",
  COALESCE(n.new_traders, 0) AS new_traders,
  COALESCE(r.returning_traders, 0) AS returning_traders,
  COALESCE(c.current_traders, 0) AS current_traders,
  COALESCE(ch.churned_traders, 0) AS churned_traders
FROM new_tra n
FULL OUTER JOIN returning_tra r ON n."Date(week)" = r."Date(week)"
FULL OUTER JOIN curr_traders c ON n."Date(week)" = c."Date(week)"
FULL OUTER JOIN churned_traders ch ON n."Date(week)" = ch."Date(week)"
ORDER BY "Date(week)"
