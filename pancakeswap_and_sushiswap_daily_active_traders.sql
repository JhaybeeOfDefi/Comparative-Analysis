WITH cake_base_table AS (
  SELECT
    DATE_TRUNC('day', block_time) AS day,
    taker AS trader
  FROM pancakeswap.trades
  WHERE
    block_date > NOW() - INTERVAL '180' day
), 

sushi_base_table AS (
  SELECT
    DATE_TRUNC('day', block_time) AS day,
    taker AS trader
  FROM sushiswap.trades
  WHERE
    block_date > NOW() - INTERVAL '180' day
), 

dau_cake AS (
  SELECT
    day,
    'pancakeswap' AS dex,
    COUNT(DISTINCT trader) AS daily_active_traders
  FROM cake_base_table
  GROUP BY 1,2
  ORDER BY 1
), 

dau_sushi AS (
  SELECT
    day,
    'sushiswap' AS dex,
    COUNT(DISTINCT trader) AS daily_active_traders
  FROM sushi_base_table
  GROUP BY 1, 2
  ORDER BY 1
)

SELECT
  *
FROM (
  SELECT
    *
  FROM dau_cake
  UNION ALL
  SELECT
    *
  FROM dau_sushi
)
ORDER BY dex ASC
