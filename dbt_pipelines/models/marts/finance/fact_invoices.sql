WITH cleaned_customers AS (
    SELECT 
        Kdnr,
        Verlagsname,
        Region
    FROM {{ ref('stg_customers') }}
),

cleaned_invoices AS (
    SELECT
        ReNummer,
        Kdnr,
        ReDatum,
        Zahlungsdatum,
        SummeNetto
    FROM {{ ref('stg_invoices') }}
    WHERE ReNummer IS NOT NULL
),

cleaned_positions AS (
    SELECT 
        id,
        ReId,
        KdNr,
        Nettobetrag,
        Bildnummer,
        VerDatum,
    FROM {{ ref('stg_positions') }}
    WHERE id IS NOT NULL
),

date_dimension AS (
    SELECT 
        date_day,
        month_name
    FROM {{ ref('dim_dates') }}
)

SELECT
    cleaned_positions.id,
    cleaned_positions.Bildnummer,
    cleaned_positions.Nettobetrag,
    date_dimension.month_name,
    cleaned_invoices.ReNummer,
    cleaned_invoices.ReDatum,
    cleaned_invoices.Zahlungsdatum,
    cleaned_invoices.SummeNetto,
    cleaned_customers.Kdnr,
    cleaned_customers.Verlagsname,
    cleaned_customers.Region
FROM cleaned_positions
JOIN cleaned_invoices ON cleaned_positions.ReId = cleaned_invoices.ReNummer
JOIN cleaned_customers ON cleaned_positions.KdNr = cleaned_customers.Kdnr
LEFT JOIN date_dimension ON CAST(cleaned_positions.VerDatum AS DATE) = date_dimension.date_day