WITH cake_base_table AS (
  SELECT
    'pancakeswap' AS dex,
    token_pair AS trading_pair,
    SUM(amount_usd) AS token_pair_volume
  FROM pancakeswap.trades
  WHERE
    block_date > CURRENT_TIMESTAMP - INTERVAL '180' day
  GROUP BY 1,2
  ORDER BY 3 DESC
  LIMIT 10
), 

pair_vol_ten AS (
  SELECT
    SUM(token_pair_volume) AS top_ten_pair_vol
  FROM cake_base_table
)

SELECT
  cb.trading_pair,
  cb.token_pair_volume,
  ROUND((cb.token_pair_volume / pv.top_ten_pair_vol) * 100, 2) AS percentage_volume
FROM cake_base_table AS cb
JOIN pair_vol_ten AS pv
  ON TRUE 
  
