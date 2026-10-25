SELECT
    fraud_reported,
    COUNT(*) AS claim_count
FROM raw_claims
GROUP BY fraud_reported;