WITH cake_base_table AS (
  SELECT
    'pancakeswap' AS dex,
    COUNT (tx_hash) AS total_of_swaps,
    AVG(amount_usd ) AS average_swap_size,
    APPROX_PERCENTILE(amount_usd, 0.5) AS median_swap_size
  FROM pancakeswap.trades
  WHERE
    block_date > NOW() - INTERVAL '180' day
),

sushi_base_table AS (
  SELECT
    'sushiswap' AS dex,
    COUNT (tx_hash) AS total_of_swaps,
    AVG(amount_usd ) AS average_swap_size,
    APPROX_PERCENTILE(amount_usd, 0.5) AS median_swap_size
  FROM sushiswap.trades
  WHERE
    block_date > NOW() - INTERVAL '180' day
) 


SELECT 
*
FROM cake_base_table

UNION ALL

SELECT 
*
FROM sushi_base_table
