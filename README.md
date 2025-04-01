# Blinkist Engagement Metrics dbt Project

This project builds a data pipeline using dbt (Data Build Tool) with DuckDB as the underlying database. The goal is to ingest, transform, and produce a final table that captures core engagement metrics from Blinkist mobile and web events.

---

## Table of Contents

- [Setup and Running the Project](#setup-and-running-the-project)
- [Project Structure and Decisions](#project-structure-and-decisions)
- [Challenges and Assumptions](#challenges-and-assumptions)
- [Additional Analyses and Metrics](#additional-analyses-and-metrics)

---

## Setup and Running the Project

1. **Create a Python Environment:**  
   It is recommended to use a Python virtual environment (using `pyenv` or `venv`) to manage dependencies. For example:

   ```bash
   python -m venv dbt_env
   source dbt_env/bin/activate  # On Windows: dbt_env\Scripts\activate
    ```


2. **Install Dependencies:**  
    Install the required dbt packages using pip:

   ```bash
   python -m pip install dbt-core dbt-duckdb
    ```

3. **Configure  `profiles.yml`:**  
    To use dbt, you need to configure the `profiles.yml` file. Follow the steps based on your operating system:
    
    <b>Windows</b>
    
    Store the  `profiles.yml` file in `C:\Users\<YourUsername>\.dbt\`.

    <b>Mac/Linux</b>

    To set up dbt, follow these steps:
    1. Create the `.dbt` directory (if it doesn’t already exist):
    
    ```bash
    mkdir -p ~/.dbt
    ```

    2. Copy the required configuration files into `.dbt/`:
    
    ```bash
    cp profiles/profiles.yml ~/.dbt/profiles.yml
    cp profiles/.user.yml ~/.dbt/.user.yml
    ```

4. **Verify Installation:** 
    To ensure everything is set up correctly, run:

    ```bash
   dbt debug
    ```
    If everything is correctly configured, you should see a success message confirming that your profiles are set up properly.

5. **Load Sample Data:**  

   ```bash
   dbt seed
    ```

6. **Run the Models:**  
    To build your models and materialize the engagement metrics table, run:

   ```bash
   dbt run
   ```

    Alternatively, you can run a specific model:

    ```bash
    dbt run -m mart_engagement
    ```

---

## Project Structure and Decisions

## Layered Architecture

### Seeds
The CSV files act as the raw ingestion layer.

### Staging Models (models/staging/)
These models clean and standardize the raw data from the seeds. We created `stg_mobile_events.sql` and `stg_web_events.sql` for this purpose.

### Data Marts (models/marts/)
The final engagement metrics are built in `mart_engagement.sql`. This model aggregates key metrics such as:
- **Daily Active Users (DAU):** Unique users per day from both mobile and web interactions.
- **Daily Active Learners (DAL):** Unique users per day who interacted with Blinkist content.
- **Content Completions (Web):** Count of web events with the event name `'item-finished'`.
- **Regional Activity (DACH):** Unique mobile users from the DACH region in the last 30 days.

### Materialization Choices
Each model is materialized as a table rather than a view. This decision supports a Lakehouse-like architecture where data is stored persistently for further querying and analysis. Although larger projects may include a base layer, this task was kept simple by using only staging and marts.

### Schema Configuration
The `dbt_project.yml` file includes schema configuration to separate staging and analytics:

```yaml
models:
  dbt_pipelines:
    staging:
      +materialized: table
      +schema: staging
    marts:
      +materialized: table
      +schema: analytics
```

This ensures that raw/staging models and final analytical models are stored in their respective schemas.

---