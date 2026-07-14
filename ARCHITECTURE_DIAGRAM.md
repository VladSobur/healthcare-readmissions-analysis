# Architecture Diagram

```mermaid
flowchart TD

    A[CSV Dataset] --> B[SQL Server Raw Table<br/>dbo.raw_diabetes_readmissions]
    B --> C[Cleaned Staging View<br/>dbo.stg_readmissions]

    C --> D[Star Schema]
    D --> D1[dim_patient]
    D --> D2[dim_diagnosis]
    D --> D3[fact_readmissions]

    C --> E[Analytics Views]

    E --> E1[vw_readmission_by_age]
    E --> E2[vw_readmission_by_race]
    E --> E3[vw_readmission_by_los]
    E --> E4[vw_readmission_by_admission_type]
    E --> E5[vw_readmission_by_med_change]
    E --> E6[vw_readmission_by_med_group]
    E --> E7[vw_readmission_by_complexity]
    E --> E8[vw_top10_specialty_readmission]

    E --> F[Power BI Semantic Model]
    F --> G[Three-Page Power BI Dashboard]

    C --> H[Stored Procedure<br/>usp_ReadmissionSummary]

    I[Validation Script<br/>06_Validation.sql]
    I -. validates .-> B
    I -. validates .-> C
    I -. validates .-> D
    I -. validates .-> E
    I -. validates .-> H
```

## Architecture Summary

The project uses a SQL-first analytics architecture:

1. The source CSV dataset is loaded into the SQL Server raw table `dbo.raw_diabetes_readmissions`.
2. The staging view `dbo.stg_readmissions` cleans and standardizes the raw data and creates the 30-day readmission flag.
3. A star schema containing `dim_patient`, `dim_diagnosis`, and `fact_readmissions` supports dimensional modeling and encounter-level analysis.
4. Business-focused analytics views are created directly from the staging layer.
5. Power BI consumes the analytics views through its semantic model and presents the results in a three-page dashboard.
6. The stored procedure `usp_ReadmissionSummary` provides reusable summary-level reporting.
7. `06_Validation.sql` validates the raw table, staging view, star schema, analytics views, and stored procedure.
