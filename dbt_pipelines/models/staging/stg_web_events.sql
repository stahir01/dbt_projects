with raw as (
    select * from {{ ref('web_events') }}
)
select
    event_name,
    cast(event_timestamp as timestamp) as event_timestamp,
    user_id,
    fingerprint,
    cast(arrival_timestamp as timestamp) as arrival_timestamp,
    browser_name,
    browser_version,
    language,
    screen_resolution,
    device_type,
    cookies_enabled,
    session_id,
    user_access_type,
    country_code,
    referrer,
    item_id,
    item_type,
    item_title
from raw