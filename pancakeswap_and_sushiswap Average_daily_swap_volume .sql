WITH cake_base_table AS (
  SELECT
    DATE_TRUNC('day', block_time) AS day,
    AVG(amount_usd) AS avg_daily_swap_vol,
    APPROX_PERCENTILE(amount_usd, 0.5) AS median_daily_swap_vol
  FROM pancakeswap.trades
  WHERE
    block_date > CURRENT_TIMESTAMP - INTERVAL '180' day
  GROUP BY 1
  ORDER BY 1 DESC
),

sushi_base_table AS (
  SELECT
    DATE_TRUNC('day', block_time) AS day,
     AVG(amount_usd) AS avg_daily_swap_vol,
    APPROX_PERCENTILE(amount_usd, 0.5) AS median_daily_swap_vol
  FROM sushiswap.trades
  WHERE
    block_date > CURRENT_TIMESTAMP - INTERVAL '180' day
  GROUP BY 1
  ORDER BY 1 DESC
)

SELECT
*
FROM (
  SELECT 
    day,
    'pancakeswap' AS dex,
    avg_daily_swap_vol,
    median_daily_swap_vol
  FROM cake_base_table
)

UNION ALL 

SELECT
*
FROM (
  SELECT 
    day,
    'sushiswap' AS dex,
    avg_daily_swap_vol,
    median_daily_swap_vol
  FROM sushi_base_table
)
  ORDER BY day 
  



