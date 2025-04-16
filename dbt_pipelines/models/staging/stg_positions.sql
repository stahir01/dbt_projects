WITH raw_values AS (
    SELECT * FROM {{ref('positions')}}    
),

data_cleaning AS (
    SELECT 
        CASE
            WHEN id = 'NULL' THEN NULL
            ELSE TRY_CAST(id AS INTEGER)
        END AS id,
        CASE
            WHEN ReId = 'NULL' THEN NULL
            ELSE TRY_CAST(ReId AS INTEGER)
        END AS ReId,        
        CASE
            WHEN KdNr = 'NULL' THEN NULL
            ELSE TRY_CAST(KdNr AS DECIMAL(5,0))
        END AS KdNr,        
        CASE
            WHEN Nettobetrag = 'NULL' THEN NULL
            ELSE TRY_CAST(Nettobetrag AS DECIMAL(10,4))
        END AS Nettobetrag,        
        CASE
            WHEN Bildnummer = 'NULL' THEN NULL
            ELSE TRY_CAST(Bildnummer AS INTEGER)
        END AS Bildnummer,        
        CASE 
            WHEN Bildnummer = 'NULL' THEN NULL
            WHEN TRY_CAST(Bildnummer AS INTEGER) = 100000000 THEN TRUE 
            ELSE FALSE 
        END AS is_placeholder,
        CASE 
            WHEN VerDatum = 'NULL' THEN NULL
            ELSE TRY_CAST(VerDatum AS DATE)
        END AS VerDatum
    FROM raw_values
)

SELECT * FROM data_cleaning