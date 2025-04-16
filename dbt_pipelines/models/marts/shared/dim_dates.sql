WITH raw_generated_data as (
        {{ dbt_date.get_date_dimension("2021-01-01", "2030-12-31") }}
)






SELECT * FROM raw_generated_data