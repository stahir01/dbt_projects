WITH raw_values AS (
    SELECT * FROM {{ref('invoices')}}    
),

data_cleaning AS (
    CAST(ReNummer AS INTEGER) AS ReNummer,
    CAST(SummeNetto AS DECIMAL(10,2)) AS SummeNetto,
    CAST(MwStSatz AS DECIMAL(5,2)) AS MwStSatz,
    CAST(COALESCE(NULLIF(ZahlungsbetragBrutto, ''), '0') AS DECIMAL(19,4)) AS ZahlungsbetragBrutto, --Add it's test and tell that these values are zero and warn in test
    CASE
            WHEN TRY_CAST(Kdnr AS DECIMAL(5,0)) IS NOT NULL 
            THEN CAST(Kdnr AS DECIMAL(5,0))
            ELSE NULL
    END AS Kdnr,
    CAST(Summenebenkosten AS DECIMAL(19,4)) AS Summenebenkosten, 
    CASE 
        WHEN ReDatum = 'NAT' THEN NULL
        WHEN TRY_CAST(ReDatum AS DATE) IS NULL THEN NULL
        ELSE CAST(ReDatum AS DATE)
    END AS ReDatum
    CASE 
        WHEN Zahlungsdatum = 'NAT' THEN NULL
        WHEN TRY_CAST(Zahlungsdatum AS DATE) IS NULL THEN NULL
        ELSE CAST(Zahlungsdatum AS DATE)
    END AS Zahlungsdatum

)

SELECT * FROM data_cleaning
