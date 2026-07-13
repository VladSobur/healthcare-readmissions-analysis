/* ============================================================
   PROJECT 2: CLINICAL OUTCOMES ANALYTICS
   Script: 02_Create_Staging_View.sql
   Purpose: Create the cleaned staging layer.

   BEFORE RUNNING:
   The raw table dbo.raw_diabetes_readmissions must already exist.
============================================================ */

USE Healthcare_Readmissions;
GO

DROP VIEW IF EXISTS dbo.stg_readmissions;
GO

/* ------------------------------------------------------------
   Staging View: stg_readmissions

   Why:
   Keeps the raw imported table unchanged, converts numeric fields,
   and creates a reusable 30-day readmission flag.
------------------------------------------------------------ */

CREATE VIEW dbo.stg_readmissions AS
SELECT
    encounter_id,
    patient_nbr,
    race,
    gender,
    age,
    payer_code,
    medical_specialty,
    CAST(admission_type_id AS INT) AS admission_type_id,
    CAST(discharge_disposition_id AS INT) AS discharge_disposition_id,
    CAST(admission_source_id AS INT) AS admission_source_id,
    diag_1,
    diag_2,
    diag_3,
    A1Cresult,
    [change],
    diabetesMed,
    CAST(time_in_hospital AS INT) AS time_in_hospital,
    CAST(num_lab_procedures AS INT) AS num_lab_procedures,
    CAST(num_procedures AS INT) AS num_procedures,
    CAST(num_medications AS INT) AS num_medications,
    CAST(number_diagnoses AS INT) AS number_diagnoses,
    readmitted,
    CASE
        WHEN readmitted = '<30' THEN 1
        ELSE 0
    END AS readmitted_30d_flag
FROM dbo.raw_diabetes_readmissions;
GO
