SELECT 
  DISTINCT blockchain AS chain,
  SUM(amount_usd) AS chain_volume,
  ROUND(SUM(amount_usd) * 100 / SUM(SUM(amount_usd)) OVER(), 2) AS volume_percentage
FROM sushiswap.trades
WHERE block_date > NOW() - INTERVAL '180' day
GROUP BY 1
ORDER BY 2 DESC;

