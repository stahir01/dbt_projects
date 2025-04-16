WITH raw_values AS (
    SELECT * FROM {{ref('customers')}}
),

data_cleaning AS (
    SELECT 
        CAST(id AS INTEGER) AS id,
        -- Enforce 5-digit numeric constraint
        CASE
            WHEN TRY_CAST(Kdnr AS DECIMAL(5,0)) IS NOT NULL 
            THEN CAST(Kdnr AS DECIMAL(5,0))
            ELSE NULL
        END AS Kdnr,
        CAST(Verlagsname AS STRING) AS Verlagsname,
        COALESCE(NULLIF(NULLIF(UPPER(TRIM(Region)), 'NULL'), ''), 'Unknown') AS Region   
     FROM raw_values
    )

SELECT * FROM data_cleaning