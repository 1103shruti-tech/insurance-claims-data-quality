CREATE TABLE claims_final AS
WITH base AS (
    SELECT
        CAST(policy_number AS INTEGER) AS policy_number,
        CAST(months_as_customer AS INTEGER) AS months_as_customer,
        CAST(age AS INTEGER) AS age,
        policy_state,
        policy_csl,
        CAST(policy_deductable AS INTEGER) AS policy_deductible,
        CAST(policy_annual_premium AS REAL) AS policy_annual_premium,
        CAST(umbrella_limit AS INTEGER) AS umbrella_limit,
        insured_sex,
        insured_education_level,
        insured_occupation,
        insured_hobbies,
        policy_bind_date,
        incident_date,
        incident_type,

        CASE
            WHEN collision_type IN ('?', '') OR collision_type IS NULL
            THEN 'Unknown'
            ELSE collision_type
        END AS collision_type,

        incident_severity,
        authorities_contacted,
        incident_state,
        incident_city,
        CAST(incident_hour_of_the_day AS INTEGER) AS incident_hour,
        CAST(number_of_vehicles_involved AS INTEGER) AS vehicles_involved,

        CASE
            WHEN property_damage IN ('?', '') OR property_damage IS NULL
            THEN 'Unknown'
            ELSE property_damage
        END AS property_damage,

        CAST(bodily_injuries AS INTEGER) AS bodily_injuries,
        CAST(witnesses AS INTEGER) AS witnesses,

        CASE
            WHEN police_report_available IN ('?', '')
                 OR police_report_available IS NULL
            THEN 'Unknown'
            ELSE police_report_available
        END AS police_report_available,

        CAST(total_claim_amount AS REAL) AS total_claim_amount,
        CAST(injury_claim AS REAL) AS injury_claim,
        CAST(property_claim AS REAL) AS property_claim,
        CAST(vehicle_claim AS REAL) AS vehicle_claim,
        auto_make,
        auto_model,
        CAST(auto_year AS INTEGER) AS auto_year,
        fraud_reported,

        CASE
            WHEN collision_type IN ('?', '') OR collision_type IS NULL
            THEN 1 ELSE 0
        END AS f_collision_missing,

        CASE
            WHEN property_damage IN ('?', '') OR property_damage IS NULL
            THEN 1 ELSE 0
        END AS f_property_damage_missing,

        CASE
            WHEN police_report_available IN ('?', '')
                 OR police_report_available IS NULL
            THEN 1 ELSE 0
        END AS f_police_report_missing,

        CASE
            WHEN ABS(
                CAST(total_claim_amount AS REAL)
                - (
                    CAST(injury_claim AS REAL)
                    + CAST(property_claim AS REAL)
                    + CAST(vehicle_claim AS REAL)
                )
            ) > 0.01
            THEN 1 ELSE 0
        END AS f_claim_sum_mismatch,

        CASE
            WHEN incident_date < policy_bind_date
            THEN 1 ELSE 0
        END AS f_incident_before_policy,

        CASE
            WHEN CAST(umbrella_limit AS INTEGER) < 0
            THEN 1 ELSE 0
        END AS f_negative_umbrella

    FROM raw_claims
)
SELECT
    *,
    (
        f_collision_missing
        + f_property_damage_missing
        + f_police_report_missing
        + f_claim_sum_mismatch
        + f_incident_before_policy
        + f_negative_umbrella
    ) AS total_issues,

    CASE
        WHEN total_claim_amount < 20000 THEN '1. Under 20k'
        WHEN total_claim_amount < 50000 THEN '2. 20k to 50k'
        WHEN total_claim_amount < 80000 THEN '3. 50k to 80k'
        ELSE '4. 80k and above'
    END AS claim_size_band

FROM base;