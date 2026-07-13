/* ============================================================
   PROJECT 2: CLINICAL OUTCOMES ANALYTICS
   Script: 06_Validation.sql
   Purpose: Validate that all major objects return expected data.
============================================================ */

USE Healthcare_Readmissions;
GO

/* Expected raw row count: 101,766 */
SELECT COUNT(*) AS total_rows
FROM dbo.raw_diabetes_readmissions;
GO

/* Expected unique patients: 71,518 */
SELECT COUNT(*) AS total_unique_patients
FROM dbo.dim_patient;
GO

/* Expected encounters: 101,766 */
SELECT COUNT(*) AS total_encounters
FROM dbo.fact_readmissions;
GO

SELECT COUNT(*) AS total_primary_diagnoses
FROM dbo.dim_diagnosis;
GO

EXEC dbo.usp_ReadmissionSummary;
GO

EXEC dbo.usp_ReadmissionSummary @ReadmittedOnly = 1;
GO

SELECT * FROM dbo.vw_readmission_by_age ORDER BY readmission_rate_pct DESC;
GO

SELECT * FROM dbo.vw_readmission_by_race ORDER BY readmission_rate_pct DESC;
GO

SELECT * FROM dbo.vw_readmission_by_los ORDER BY time_in_hospital;
GO

SELECT * FROM dbo.vw_readmission_by_med_group ORDER BY sort_order;
GO

SELECT * FROM dbo.vw_readmission_by_complexity ORDER BY sort_order;
GO

SELECT * FROM dbo.vw_readmission_by_med_change ORDER BY readmission_rate_pct DESC;
GO

SELECT * FROM dbo.vw_readmission_by_admission_type ORDER BY readmission_rate_pct DESC;
GO

SELECT * FROM dbo.vw_top10_specialty_readmission ORDER BY readmission_rate_pct DESC;
GO

SELECT * FROM dbo.vw_readmission_by_a1c ORDER BY readmission_rate_pct DESC;
GO
