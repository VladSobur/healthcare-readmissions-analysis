# Architecture Diagram

```mermaid
flowchart TD

    A[Source CSV<br/>Diabetes 130-US Hospitals]
    B[SQL Server Database<br/>Healthcare_Readmissions]
    C[Raw Imported Table<br/>dbo.raw_diabetes_readmissions]
    D[Cleaned Staging View<br/>dbo.stg_readmissions]

    A -->|Manual CSV import| C
    B --- C
    C --> D

    subgraph MODELING["Dimensional Modeling Layer"]
        E[dim_patient]
        F[dim_diagnosis]
        G[fact_readmissions]
    end

    D --> E
    D --> F
    D --> G
    E -->|Patient foreign key| G

    subgraph REPORTING["SQL Reporting Layer"]
        H[vw_readmission_by_age]
        I[vw_readmission_by_race]
        J[vw_readmission_by_los]
        K[vw_readmission_by_medications]
        L[vw_readmission_by_med_group]
        M[vw_readmission_by_med_change]
        N[vw_readmission_by_admission_type]
        O[vw_readmission_by_specialty]
        P[vw_top10_specialty_readmission]
        Q[vw_readmission_by_num_diagnoses]
        R[vw_readmission_by_complexity]
        S[vw_readmission_by_gender]
        T[vw_readmission_by_a1c]
    end

    D --> H
    D --> I
    D --> J
    D --> K
    D --> L
    D --> M
    D --> N
    D --> O
    O --> P
    D --> Q
    D --> R
    D --> S
    D --> T

    U[Stored Procedure<br/>dbo.usp_ReadmissionSummary]
    D --> U

    subgraph POWERBI["Power BI"]
        V[Power BI Semantic Model<br/>SQL Views + DAX Measures]
        W[Hospital Readmission Overview]
        X[Clinical Drivers of Readmission]
        Y[Patient Risk Factors]
    end

    D --> V
    H --> V
    I --> V
    J --> V
    L --> V
    M --> V
    N --> V
    P --> V
    R --> V

    V --> W
    V --> X
    V --> Y

    Z[Validation Script<br/>06_Validation.sql]

    Z -. validates .-> C
    Z -. validates .-> E
    Z -. validates .-> F
    Z -. validates .-> G
    Z -. validates .-> U
    Z -. validates .-> H
    Z -. validates .-> I
    Z -. validates .-> J
    Z -. validates .-> L
    Z -. validates .-> M
    Z -. validates .-> N
    Z -. validates .-> P
    Z -. validates .-> R
    Z -. validates .-> T
```

## Architecture Summary

1. The **Healthcare_Readmissions** database is created in SQL Server.
2. The source CSV is imported into `dbo.raw_diabetes_readmissions`.
3. `dbo.stg_readmissions` preserves the raw table while converting numeric fields and creating the 30-day readmission flag.
4. The staging view feeds two parallel SQL layers:
   - a dimensional model containing `dim_patient`, `dim_diagnosis`, and `fact_readmissions`;
   - business-focused analytics views used for readmission analysis.
5. `dbo.vw_top10_specialty_readmission` is generated from `dbo.vw_readmission_by_specialty`; the other analytics views are generated directly from `dbo.stg_readmissions`.
6. `dbo.usp_ReadmissionSummary` reads from the staging view and returns reusable executive KPIs.
7. Power BI imports the required analytics views and the staging view, adds DAX measures, and presents the results across three report pages.
8. `06_Validation.sql` verifies row counts, dimensional tables, stored-procedure output, and the principal analytics views.

## SQL Script Execution Order

1. `01_Create_Database.sql`
2. Import the source CSV as `dbo.raw_diabetes_readmissions`
3. `02_Create_Staging_View.sql`
4. `03_Create_Dimensions_and_Fact.sql`
5. `04_Create_Analytics_Views.sql`
6. `05_Create_Stored_Procedure.sql`
7. `06_Validation.sql`
