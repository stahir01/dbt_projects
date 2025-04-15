WITH raw_values AS (
    SELECT * FROM {{ref('positions')}}    
),


data_cleaning AS (
    SELECT 
        CAST(id AS INTEGER) AS id,
        CAST(ReId AS INTEGER) AS ReId,
        CASE
            WHEN TRY_CAST(KdNr AS DECIMAL(5,0)) IS NOT NULL 
            THEN CAST(KdNr AS DECIMAL(5,0))
            ELSE NULL
        END AS KdNr,
        CAST(Nettobetrag AS DECIMAL(19,4)) AS Nettobetrag,
        CAST(Bildnummer AS INTEGER) AS Bildnummer,
        CASE 
            WHEN CAST(Bildnummer AS INTEGER) = 100000000 THEN TRUE 
            ELSE FALSE 
        END AS is_placeholder
        CAST(VerDatum AS DATE) AS VerDatum
    FROM raw_values

)

SELECT * FROM data_cleaning