
-- 1. Claims by incident type
SELECT
    incident_type,
    COUNT(*) AS total_claims,
    ROUND(AVG(total_claim_amount), 2) AS avg_claim_amount,
    ROUND(SUM(total_claim_amount), 2) AS total_claim_amount
FROM claims_final
GROUP BY incident_type
ORDER BY avg_claim_amount DESC;


-- 2. Claims by incident severity
SELECT
    incident_severity,
    COUNT(*) AS total_claims,
    ROUND(AVG(total_claim_amount), 2) AS avg_claim_amount,
    ROUND(SUM(total_claim_amount), 2) AS total_claim_amount
FROM claims_final
GROUP BY incident_severity
ORDER BY avg_claim_amount DESC;


-- 3. Claims by incident state
SELECT
    incident_state,
    COUNT(*) AS total_claims,
    ROUND(AVG(total_claim_amount), 2) AS avg_claim_amount,
    ROUND(SUM(total_claim_amount), 2) AS total_claim_amount
FROM claims_final
GROUP BY incident_state
ORDER BY total_claims DESC;


-- 4. Claims by fraud label
SELECT
    fraud_reported,
    COUNT(*) AS total_claims,
    ROUND(AVG(total_claim_amount), 2) AS avg_claim_amount,
    ROUND(SUM(total_claim_amount), 2) AS total_claim_amount
FROM claims_final
GROUP BY fraud_reported
ORDER BY fraud_reported;


-- 5. Claims by insured occupation
SELECT
    insured_occupation,
    COUNT(*) AS total_claims,
    ROUND(AVG(total_claim_amount), 2) AS avg_claim_amount,
    ROUND(SUM(total_claim_amount), 2) AS total_claim_amount
FROM claims_final
GROUP BY insured_occupation
ORDER BY avg_claim_amount DESC;


-- 6. Fraud labels by incident severity
SELECT
    incident_severity,
    COUNT(*) AS total_claims,
    SUM(CASE WHEN fraud_reported = 'Y' THEN 1 ELSE 0 END)
        AS fraud_reported_claims,
    ROUND(
        100.0 * SUM(CASE WHEN fraud_reported = 'Y' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS fraud_reported_pct
FROM claims_final
GROUP BY incident_severity
ORDER BY fraud_reported_pct DESC;


-- 7. Fraud labels by incident type
SELECT
    incident_type,
    COUNT(*) AS total_claims,
    SUM(CASE WHEN fraud_reported = 'Y' THEN 1 ELSE 0 END)
        AS fraud_reported_claims,
    ROUND(
        100.0 * SUM(CASE WHEN fraud_reported = 'Y' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS fraud_reported_pct
FROM claims_final
GROUP BY incident_type
ORDER BY fraud_reported_pct DESC;
