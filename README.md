# dbt Project
This project is a dbt (data build tool) project designed to transform and analyze data. It includes various models, seeds, and tests to ensure data quality and integrity. The project is structured to follow best practices in dbt development, including a layered architecture for data transformation.

---

## Table of Contents

- [Setup and Running the Project](#setup-and-running-the-project)
- [Project Structure and Decisions](#project-structure-and-decisions)

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
   pip install dbt-core dbt-duckdb
    ```

3. **Instal requirements.txt:**  
    Install the required packages using pip:

   ```bash
   pip install -r requirements.txt
    ```

    This will install all the necessary dependencies for the project.

4. **Configure  `profiles.yml`:**  
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

5. **Install Dependencies:**:*
    Before running the project, install all required packages:

    ```bash
   dbt deps
    ```

6. **Verify Installation:** 
    To ensure everything is set up correctly, run:

    ```bash
   dbt debug
    ```
    If everything is correctly configured, you should see a success message confirming that your profiles are set up properly.

7. **Load Sample Data:**  

   ```bash
   dbt seed
    ```

8. **Run the Test:**  
    Validate data quality with:

   ```bash
   dbt test
    ```

    Alternatively, you can run a specific model:

    ```bash
    dbt test --select model_name
    ```
9. **Run the Models:**  
    To run your models and materialize the engagement metrics table, run:

   ```bash
   dbt run
   ```

    Alternatively, you can run a specific model:

    ```bash
    dbt run -m model_name
    ```

10. **Build the Models:**  
    To build your models and materialize the engagement metrics table, run:

  ```bash
   dbt run
  ```

  ```bash
    dbt build -m model_name
  ```

---

## Project Structure and Decisions

## Layered Architecture

### Seeds
Used as the base layer where raw data is initially stored. In production, this would include data from various sources like Excel files, Google Sheets, and external databases. All are stored in their original, unprocessed form.

### Staging Models (models/staging/)
Materialized as views, this layer focuses on:

- **Data Quality:** Ensuring the data is clean and adheres to the expected schema.
- **Data Transformation:** Applying necessary transformations to prepare the data for analysis.
- **Data Enrichment:** Adding additional context or derived fields to the data.
- **Data Validation:** Ensuring the data meets certain quality standards.

### Data Marts (models/marts/)
Materialized as tables, this layer contains:

- Dimension tables (descriptive attributes)
- Fact tables (quantitative data)
- Business-ready aggregated metrics
- Domain-specific datasets for BI tools and analytics


### Materialization Choices
The project follows a layered materialization approach where staging models are implemented as views while marts are materialized as tables. This structure aligns with dbt's recommended best practices and closely resembles the Medallion architecture pattern. The staging views handle initial data cleaning and standardization, serving as a lightweight transformation layer. Meanwhile, the marts tables persist optimized datasets for analytical consumption, ensuring performant queries for end users. This separation of concerns between transformation

### Schema Configuration
The `dbt_project.yml` file includes schema configuration to separate staging and analytics:

```yaml
models:
  dbt_pipelines:
    staging:
      +schema: staging
    marts:
      +materialized: table
      +schema: analytics
```

This ensures that raw/staging models and final analytical models are stored in their respective schemas.

---