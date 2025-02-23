WITH all_events AS (
    SELECT 
        CAST(event_timestamp as date) AS event_date,
        user_id
    FROM {{ref('stg_web_events')}}

    UNION ALL 

    SELECT 
        CAST(event_timestamp as date) AS event_date,
        user_id
    FROM {{ref('stg_mobile_events')}}

),

content_events AS (
    SELECT
        CAST(event_timestamp as date) AS event_date,
        user_id
    FROM {{ref('stg_web_events')}}
    WHERE item_id IS NOT NULL

    UNION ALL 

    SELECT
        CAST(event_timestamp as date) AS event_date,
        user_id
    FROM {{ref('stg_mobile_events')}}
    WHERE item_id IS NOT NULL
),


dau AS (
    SELECT
        event_date,
        COUNT(DISTINCT user_id) AS dau
    FROM all_events
    GROUP BY 1
), 


dal AS (
    SELECT
        event_date,
        COUNT(DISTINCT user_id) AS dal
    FROM content_events
    GROUP BY 1
),

web_completions AS (
    SELECT 
        CAST(event_timestamp as date) AS event_date,
        COUNT(*) AS web_completions
    FROM {{ref('stg_web_events')}}
    WHERE event_name = 'item-finished'
    GROUP BY 1
),

dach_interaction AS (
    SELECT 
        CAST(event_timestamp as date) AS event_date,
        COUNT(DISTINCT user_id) AS dach_interaction
    FROM {{ref('stg_mobile_events')}}
    WHERE device_locale_country in ('DE', 'AT', 'CH') AND event_timestamp >= (current_date - interval '30' day)
    group by event_date
),

final AS (
    SELECT
        COALESCE(dau.event_date, dal.event_date, wc.event_date, di.event_date) AS event_date,
        COALESCE(dau.dau,0) AS daily_active_users,
        COALESCE(dal.dal,0) AS daily_active_learners,
        COALESCE(wc.web_completions,0) AS content_completions,
        COALESCE(di.dach_interaction,0) AS dach_interactions
    FROM dau
    FULL OUTER JOIN dal ON dau.event_date = dal.event_date
    FULL OUTER JOIN web_completions wc ON COALESCE(dau.event_date, dal.event_date) = wc.event_date
    FULL OUTER JOIN dach_interaction di ON COALESCE(dau.event_date, dal.event_date, wc.event_date) = di.event_date
)

SELECT *
FROM final
ORDER BY event_date
