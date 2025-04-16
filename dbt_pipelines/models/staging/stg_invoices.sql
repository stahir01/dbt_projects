WITH raw_values AS (
    SELECT * FROM {{ref('invoices')}}    
),

data_cleaning AS (
    SELECT
        CAST(ReNummer AS INTEGER) AS ReNummer,
        CAST(SummeNetto AS DECIMAL(10,2)) AS SummeNetto,
        CAST(MwStSatz AS DECIMAL(5,2)) AS MwStSatz,
        CASE
            WHEN ZahlungsbetragBrutto = 'NULL' THEN NULL
            ELSE TRY_CAST(ZahlungsbetragBrutto AS DECIMAL(10,4))
        END AS ZahlungsbetragBrutto,        
        CASE
            WHEN Kdnr = 'NULL' THEN NULL
            WHEN TRY_CAST(Kdnr AS DECIMAL(5,0)) IS NOT NULL 
            THEN CAST(Kdnr AS DECIMAL(5,0))
            ELSE NULL
        END AS Kdnr,
        CASE
            WHEN Summenebenkosten = 'NULL' THEN NULL
            ELSE CAST(Summenebenkosten AS DECIMAL(10,4))
        END AS Summenebenkosten,
        CASE 
            WHEN ReDatum = 'NULL' THEN NULL
            ELSE CAST(ReDatum AS DATE)
        END AS ReDatum,
        CASE 
            WHEN Zahlungsdatum = 'NULL' THEN NULL
            ELSE CAST(Zahlungsdatum AS DATE)
        END AS Zahlungsdatum
    FROM raw_values
)

SELECT * FROM data_cleaning