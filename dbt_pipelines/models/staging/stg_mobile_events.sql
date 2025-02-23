WITH raw AS (
    SELECT * FROM {{ref('mobile_events')}}
)

select
    event_name,
    application_version_code,
    application_version_name,
    cast(arrival_timestamp as timestamp) as arrival_timestamp,
    category,
    client_id,
    device_locale_code,
    device_locale_country,
    device_locale_language,
    device_make,
    device_platform_name,
    cast(event_timestamp as timestamp) as event_timestamp,
    event_version,
    session_id,
    user_access_type,
    user_id,
    item_id,
    item_type,
    item_title
from raw 
