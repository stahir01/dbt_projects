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
## Challenges and Assumptions

### Initial Setup
Configuring DuckDB was a unique challenge compared to service-based systems. DuckDB creates a file (e.g., `dev.duckdb`), which required careful management to avoid file locking issues (for instance, ensuring that DBeaver or similar tools are closed while running dbt commands).

### Assumptions
- The CSV files accurately simulate the raw event data from Blinkist’s backend.
- The DACH region is defined by the country codes: 'DE', 'AT', and 'CH'.
- Timestamps are cast to dates to aggregate daily metrics, which meets our reporting needs.

### Model Development
Early iterations faced challenges with model references and SQL syntax (e.g., proper usage of `ref()` and removal of unsupported clauses such as `ORDER BY` in CTAS). Resolving these issues led to a more stable and robust data pipeline.

---
## Additional Analyses and Metrics

Now that the project has produced a table capturing core engagement metrics, further analyses could provide deeper insights into user behavior. With additional data sources (such as detailed user behavior logs, subscription changes, content categories, etc.), potential next steps include:

### User Journey and Funnel Analysis
Analyzing the complete user journey—from initial interaction to content engagement and conversion—could help identify drop-off points and optimize user experience.

### Cohort Analysis
Segmenting users by sign-up date or first interaction date to monitor retention and engagement over time. This analysis can reveal the long-term impact of product changes.

### Subscription and Revenue Metrics
Correlating subscription changes with engagement data to understand the behavior differences between free and premium users, thereby informing targeted marketing strategies.

### Content Performance Analysis
Evaluating which content categories (e.g., books, articles, podcasts) drive the most engagement. This insight would be valuable for content curation and strategy.

### Predictive Analytics
Building models to predict churn, user lifetime value, or content completion likelihood based on historical engagement data. This could enable proactive retention strategies.

### Personalization and Segmentation
Using detailed user behavior logs to segment users by interests and activity patterns, leading to more personalized content recommendations and improved user experience.

These analyses would not only deepen our understanding of user engagement but also help optimize strategies for better retention and growth.
