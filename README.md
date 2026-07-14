# Hospital Readmission Analytics

A SQL Server and Power BI project analyzing hospital readmissions, patient risk factors, and clinical patterns across **101,766 inpatient encounters**.

![Hospital Readmission Overview](Images/Hospital_Readmission_Overview.png)

---

## Project Overview

Hospital readmissions are an important quality and performance metric in healthcare. Understanding which patient populations and clinical characteristics are associated with higher readmission rates can help hospitals improve patient outcomes, optimize care planning, and reduce avoidable healthcare costs.

This project demonstrates an end-to-end healthcare analytics workflow using **SQL Server** and **Power BI**. Raw hospital encounter data was transformed into analytical SQL views, validated, and visualized through an interactive three-page dashboard designed to support executive and clinical decision-making.

The analysis focuses on identifying patterns in 30-day hospital readmissions across demographic, clinical, and treatment-related factors.

---

## Business Problem

Hospital administrators and clinical teams need reliable analytics to understand why patients are readmitted and which factors contribute most to higher readmission rates.

This project answers key business questions, including:

- What is the overall 30-day hospital readmission rate?
- Which patient groups experience the highest readmission rates?
- How does length of stay influence readmission risk?
- How do medication burden and medication changes affect readmissions?
- Which admission types and medical specialties have the highest readmission rates?
- Which patient risk factors should receive the greatest clinical attention?

The resulting dashboard provides a concise executive overview together with detailed clinical insights to support data-driven healthcare decisions.

---

## Dataset

- **Domain:** Healthcare
- **Dataset:** Hospital Readmission (Diabetes 130-US Hospitals)
- **Total Records:** **101,766** inpatient encounters
- **Database:** Microsoft SQL Server
- **Visualization:** Microsoft Power BI

The dataset contains demographic, clinical, medication, and hospitalization information used to analyze factors associated with 30-day hospital readmissions.

---

## Data Architecture

The project follows a SQL-first architecture that transforms raw hospital encounter data into reusable analytical datasets for Power BI reporting.

The data model consists of four logical layers:

1. **Raw Data**
   - `raw_diabetes_readmissions`
   - Original imported hospital encounter dataset.

2. **Staging Layer**
   - `stg_readmissions`
   - Standardizes data types, cleans values, creates calculated fields, and prepares data for analysis.

3. **Dimensional Model**
   - `dim_patient`
   - `dim_diagnosis`
   - `fact_readmissions`

   These tables form a simple star schema used to organize patient and encounter data for analytical reporting.

4. **Analytics Layer**
   Business-focused SQL views aggregate readmission metrics for reporting, including:

   - Readmission by Age Group
   - Readmission by Race
   - Readmission by Admission Type
   - Readmission by Length of Stay
   - Readmission by Medication Load
   - Readmission after Medication Change
   - Readmission by Patient Complexity
   - Top Medical Specialties by Readmission Rate

Power BI imports the staging view, analytical SQL views, and DAX measures to produce the final interactive dashboards.

---

## SQL Pipeline

The analytical workflow followed these stages:

1. Import raw hospital encounter data into SQL Server.
2. Clean and standardize data types.
3. Create reusable SQL views for each business question.
4. Aggregate patient counts and readmission metrics.
5. Connect Power BI directly to SQL views.
6. Build interactive dashboards using DAX measures and Power BI visualizations.

---

## Dashboard Pages

### Clinical Drivers of Readmission

![Clinical Drivers of Readmission](Images/Clinical_Drivers_of_Readmission.png)

Shows how admission type, medication changes, and medical specialties influence 30-day readmission rates.

---

### Patient Risk Factors

![Patient Risk Factors](Images/Patient_Risk_Factors.png)

Explores the relationship between readmissions and patient complexity, medication burden, and hospital length of stay.

---

## Key Insights

- Overall hospital readmission rate: **11.2%**
- Highest readmission rate observed among patients aged **20–29 years**
- Longer hospital stays generally correspond to higher readmission rates.
- Patients with higher medication burden experience increased readmission rates.
- Higher patient complexity is associated with greater readmission risk.
- Nephrology recorded the highest specialty readmission rate (**15.4%**).

---

## Technologies

- Microsoft SQL Server
- T-SQL
- Power BI
- DAX
- Power Query
- Git
- GitHub

---

## Skills Demonstrated

- SQL data transformation
- Healthcare data analysis
- Data modeling
- Dashboard development
- DAX calculations
- KPI design
- Data visualization
- Business intelligence reporting

---

## Repository Structure

```
Hospital-Readmission-Analytics/
│
├── Images/
│   ├── Clinical_Drivers_of_Readmission.png 
│   ├── Hospital_Readmission_Overview.png
│   └── Patient_Risk_Factors.png
│
├── 01_Create_Database.sql
├── 02_Create_Staging_View.sql
├── 03_Create_Dimensions_and_Fact.sql
├── 04_Create_Analytics_Views.sql
├── 05_Create_Stored_Procedure.sql
├── 06_Validation.sql
│
├── ARCHITECTURE_DIAGRAM.md
├── ER_DIAGRAM.md
├── LICENSE
├── README.md
└── healthcare_readmissions_analysis.pbix
```
