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
    E --> E4[vw_readmission_by_med_group]
    E --> E5[vw_readmission_by_complexity]
    E --> E6[vw_top10_specialty_readmission]

    E --> F[Power BI Semantic Model]
    F --> G[Three-Page Power BI Dashboard]

    C --> H[Stored Procedure<br/>usp_ReadmissionSummary]

    I[Validation Script<br/>06_Validation.sql] -. validates .-> B
    I -. validates .-> C
    I -. validates .-> D
    I -. validates .-> E
    I -. validates .-> H
```

## Architecture Summary

The project uses a SQL-first analytics architecture.

1. The source CSV is imported into `dbo.raw_diabetes_readmissions`.
2. `dbo.stg_readmissions` standardizes data types and creates the 30-day readmission flag.
3. A star schema is created for dimensional-modeling practice and encounter-level analysis.
4. Business-focused analytics views are created directly from the staging layer and consumed by Power BI.
5. `usp_ReadmissionSummary` provides reusable executive KPIs.
6. `06_Validation.sql` verifies row counts, dimensional tables, analytics views, and stored-procedure results.
