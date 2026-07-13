/* ============================================================
   PROJECT 2: CLINICAL OUTCOMES ANALYTICS
   Script: 04_Create_Analytics_Views.sql
   Purpose: Create business-focused views for Power BI.

   BEFORE RUNNING:
   Run 02_Create_Staging_View.sql first.
============================================================ */

USE Healthcare_Readmissions;
GO

DROP VIEW IF EXISTS dbo.vw_readmission_by_a1c;
DROP VIEW IF EXISTS dbo.vw_top10_specialty_readmission;
DROP VIEW IF EXISTS dbo.vw_readmission_by_specialty;
DROP VIEW IF EXISTS dbo.vw_readmission_by_complexity;
DROP VIEW IF EXISTS dbo.vw_readmission_by_num_diagnoses;
DROP VIEW IF EXISTS dbo.vw_readmission_by_admission_type;
DROP VIEW IF EXISTS dbo.vw_readmission_by_med_change;
DROP VIEW IF EXISTS dbo.vw_readmission_by_med_group;
DROP VIEW IF EXISTS dbo.vw_readmission_by_medications;
DROP VIEW IF EXISTS dbo.vw_readmission_by_race;
DROP VIEW IF EXISTS dbo.vw_readmission_by_los;
DROP VIEW IF EXISTS dbo.vw_readmission_by_gender;
DROP VIEW IF EXISTS dbo.vw_readmission_by_age;
GO

/* ------------------------------------------------------------
   View: vw_readmission_by_age
   Why: Shows whether readmission risk differs across age groups.
------------------------------------------------------------ */

CREATE VIEW dbo.vw_readmission_by_age AS
SELECT
    age,
    COUNT(*) AS total_patients,
    SUM(readmitted_30d_flag) AS readmitted_patients,
    ROUND(100.0 * SUM(readmitted_30d_flag) / COUNT(*), 2) AS readmission_rate_pct
FROM dbo.stg_readmissions
GROUP BY age;
GO

/* ------------------------------------------------------------
   View: vw_readmission_by_gender
   Why: Checks whether gender is associated with readmission differences.
------------------------------------------------------------ */

CREATE VIEW dbo.vw_readmission_by_gender AS
SELECT
    gender,
    COUNT(*) AS total_patients,
    SUM(readmitted_30d_flag) AS readmitted_patients,
    ROUND(100.0 * SUM(readmitted_30d_flag) / COUNT(*), 2) AS readmission_rate_pct
FROM dbo.stg_readmissions
WHERE gender IS NOT NULL
  AND gender <> '?'
GROUP BY gender;
GO

/* ------------------------------------------------------------
   View: vw_readmission_by_race
   Why: Supports demographic comparison while excluding unknown values.
------------------------------------------------------------ */

CREATE VIEW dbo.vw_readmission_by_race AS
SELECT
    race,
    COUNT(*) AS total_patients,
    SUM(readmitted_30d_flag) AS readmitted_patients,
    ROUND(100.0 * SUM(readmitted_30d_flag) / COUNT(*), 2) AS readmission_rate_pct
FROM dbo.stg_readmissions
WHERE race IS NOT NULL
  AND race <> '?'
GROUP BY race;
GO

/* ------------------------------------------------------------
   View: vw_readmission_by_los
   Why: Tests whether longer hospital stays are associated with readmission.
------------------------------------------------------------ */

CREATE VIEW dbo.vw_readmission_by_los AS
SELECT
    time_in_hospital,
    COUNT(*) AS total_patients,
    SUM(readmitted_30d_flag) AS readmitted_patients,
    ROUND(100.0 * SUM(readmitted_30d_flag) / COUNT(*), 2) AS readmission_rate_pct
FROM dbo.stg_readmissions
GROUP BY time_in_hospital;
GO

/* ------------------------------------------------------------
   View: vw_readmission_by_medications
   Why: Explores medication burden at a detailed count level.
   Note: Removes very small groups to avoid misleading spikes.
------------------------------------------------------------ */

CREATE VIEW dbo.vw_readmission_by_medications AS
SELECT
    num_medications,
    COUNT(*) AS total_patients,
    SUM(readmitted_30d_flag) AS readmitted_patients,
    ROUND(100.0 * SUM(readmitted_30d_flag) / COUNT(*), 2) AS readmission_rate_pct
FROM dbo.stg_readmissions
GROUP BY num_medications
HAVING COUNT(*) >= 30;
GO

/* ------------------------------------------------------------
   View: vw_readmission_by_med_group
   Why: Creates clean dashboard groups for medication burden.
------------------------------------------------------------ */

CREATE VIEW dbo.vw_readmission_by_med_group AS
SELECT
    CASE
        WHEN num_medications BETWEEN 1 AND 10 THEN 'Low'
        WHEN num_medications BETWEEN 11 AND 20 THEN 'Moderate'
        WHEN num_medications BETWEEN 21 AND 30 THEN 'High'
        ELSE 'Extreme'
    END AS medication_group,
    CASE
        WHEN num_medications BETWEEN 1 AND 10 THEN 1
        WHEN num_medications BETWEEN 11 AND 20 THEN 2
        WHEN num_medications BETWEEN 21 AND 30 THEN 3
        ELSE 4
    END AS sort_order,
    COUNT(*) AS total_patients,
    SUM(readmitted_30d_flag) AS readmitted_patients,
    ROUND(100.0 * SUM(readmitted_30d_flag) / COUNT(*), 2) AS readmission_rate_pct
FROM dbo.stg_readmissions
GROUP BY
    CASE
        WHEN num_medications BETWEEN 1 AND 10 THEN 'Low'
        WHEN num_medications BETWEEN 11 AND 20 THEN 'Moderate'
        WHEN num_medications BETWEEN 21 AND 30 THEN 'High'
        ELSE 'Extreme'
    END,
    CASE
        WHEN num_medications BETWEEN 1 AND 10 THEN 1
        WHEN num_medications BETWEEN 11 AND 20 THEN 2
        WHEN num_medications BETWEEN 21 AND 30 THEN 3
        ELSE 4
    END;
GO

/* ------------------------------------------------------------
   View: vw_readmission_by_med_change
   Why: Tests whether medication changes correlate with readmission.
   Note: Association only, not causation.
------------------------------------------------------------ */

CREATE VIEW dbo.vw_readmission_by_med_change AS
SELECT
    CASE
        WHEN [change] = 'Ch' THEN 'Changed'
        WHEN [change] = 'No' THEN 'No Change'
        ELSE [change]
    END AS medication_change,
    COUNT(*) AS total_patients,
    SUM(readmitted_30d_flag) AS readmitted_patients,
    ROUND(100.0 * SUM(readmitted_30d_flag) / COUNT(*), 2) AS readmission_rate_pct
FROM dbo.stg_readmissions
WHERE [change] IS NOT NULL
  AND [change] <> '?'
GROUP BY
    CASE
        WHEN [change] = 'Ch' THEN 'Changed'
        WHEN [change] = 'No' THEN 'No Change'
        ELSE [change]
    END;
GO

/* ------------------------------------------------------------
   View: vw_readmission_by_admission_type
   Why: Identifies admission categories with higher readmission risk.
   Note: Keeps only meaningful sample sizes for reporting.
------------------------------------------------------------ */

CREATE VIEW dbo.vw_readmission_by_admission_type AS
SELECT
    CASE
        WHEN admission_type_id = 1 THEN 'Emergency'
        WHEN admission_type_id = 2 THEN 'Urgent'
        WHEN admission_type_id = 3 THEN 'Elective'
        WHEN admission_type_id = 4 THEN 'Newborn'
        WHEN admission_type_id = 5 THEN 'Not Available'
        WHEN admission_type_id = 6 THEN 'Unknown'
        WHEN admission_type_id = 7 THEN 'Trauma Center'
        WHEN admission_type_id = 8 THEN 'Not Mapped'
        ELSE 'Other'
    END AS admission_type,
    COUNT(*) AS total_patients,
    SUM(readmitted_30d_flag) AS readmitted_patients,
    ROUND(100.0 * SUM(readmitted_30d_flag) / COUNT(*), 2) AS readmission_rate_pct
FROM dbo.stg_readmissions
GROUP BY
    CASE
        WHEN admission_type_id = 1 THEN 'Emergency'
        WHEN admission_type_id = 2 THEN 'Urgent'
        WHEN admission_type_id = 3 THEN 'Elective'
        WHEN admission_type_id = 4 THEN 'Newborn'
        WHEN admission_type_id = 5 THEN 'Not Available'
        WHEN admission_type_id = 6 THEN 'Unknown'
        WHEN admission_type_id = 7 THEN 'Trauma Center'
        WHEN admission_type_id = 8 THEN 'Not Mapped'
        ELSE 'Other'
    END
HAVING COUNT(*) >= 1000;
GO

/* ------------------------------------------------------------
   View: vw_readmission_by_specialty
   Why: Identifies specialties with higher observed readmission rates.
   Note: Removes low-volume specialties to reduce noise.
------------------------------------------------------------ */

CREATE VIEW dbo.vw_readmission_by_specialty AS
SELECT
    medical_specialty,
    COUNT(*) AS total_patients,
    SUM(readmitted_30d_flag) AS readmitted_patients,
    ROUND(100.0 * SUM(readmitted_30d_flag) / COUNT(*), 2) AS readmission_rate_pct
FROM dbo.stg_readmissions
WHERE medical_specialty IS NOT NULL
  AND medical_specialty <> '?'
GROUP BY medical_specialty
HAVING COUNT(*) >= 500;
GO

/* ------------------------------------------------------------
   View: vw_top10_specialty_readmission
   Why: Gives Power BI a clean Top 10 specialty object.
------------------------------------------------------------ */

CREATE VIEW dbo.vw_top10_specialty_readmission AS
SELECT TOP (10)
    medical_specialty,
    total_patients,
    readmitted_patients,
    readmission_rate_pct
FROM dbo.vw_readmission_by_specialty
ORDER BY readmission_rate_pct DESC;
GO

/* ------------------------------------------------------------
   View: vw_readmission_by_num_diagnoses
   Why: Tests whether more diagnoses are associated with readmission.
------------------------------------------------------------ */

CREATE VIEW dbo.vw_readmission_by_num_diagnoses AS
SELECT
    number_diagnoses,
    COUNT(*) AS total_patients,
    SUM(readmitted_30d_flag) AS readmitted_patients,
    ROUND(100.0 * SUM(readmitted_30d_flag) / COUNT(*), 2) AS readmission_rate_pct
FROM dbo.stg_readmissions
GROUP BY number_diagnoses
HAVING COUNT(*) >= 100;
GO

/* ------------------------------------------------------------
   View: vw_readmission_by_complexity
   Why: Converts diagnosis count into simple dashboard risk groups.
------------------------------------------------------------ */

CREATE VIEW dbo.vw_readmission_by_complexity AS
SELECT
    CASE
        WHEN number_diagnoses BETWEEN 1 AND 3 THEN 'Low'
        WHEN number_diagnoses BETWEEN 4 AND 6 THEN 'Moderate'
        WHEN number_diagnoses BETWEEN 7 AND 9 THEN 'High'
        ELSE 'Very High'
    END AS patient_complexity,
    CASE
        WHEN number_diagnoses BETWEEN 1 AND 3 THEN 1
        WHEN number_diagnoses BETWEEN 4 AND 6 THEN 2
        WHEN number_diagnoses BETWEEN 7 AND 9 THEN 3
        ELSE 4
    END AS sort_order,
    COUNT(*) AS total_patients,
    SUM(readmitted_30d_flag) AS readmitted_patients,
    ROUND(100.0 * SUM(readmitted_30d_flag) / COUNT(*), 2) AS readmission_rate_pct
FROM dbo.stg_readmissions
GROUP BY
    CASE
        WHEN number_diagnoses BETWEEN 1 AND 3 THEN 'Low'
        WHEN number_diagnoses BETWEEN 4 AND 6 THEN 'Moderate'
        WHEN number_diagnoses BETWEEN 7 AND 9 THEN 'High'
        ELSE 'Very High'
    END,
    CASE
        WHEN number_diagnoses BETWEEN 1 AND 3 THEN 1
        WHEN number_diagnoses BETWEEN 4 AND 6 THEN 2
        WHEN number_diagnoses BETWEEN 7 AND 9 THEN 3
        ELSE 4
    END;
GO

/* ------------------------------------------------------------
   View: vw_readmission_by_a1c
   Why: Kept as exploratory SQL.
   Note: Not recommended as a main dashboard chart because most
   records have A1Cresult = None.
------------------------------------------------------------ */

CREATE VIEW dbo.vw_readmission_by_a1c AS
SELECT
    A1Cresult,
    COUNT(*) AS total_patients,
    SUM(readmitted_30d_flag) AS readmitted_patients,
    ROUND(100.0 * SUM(readmitted_30d_flag) / COUNT(*), 2) AS readmission_rate_pct
FROM dbo.stg_readmissions
WHERE A1Cresult IS NOT NULL
  AND A1Cresult <> '?'
GROUP BY A1Cresult;
GO
