/* ============================================================
   PROJECT 2: CLINICAL OUTCOMES ANALYTICS
   Script: 03_Create_Dimensions_and_Fact.sql
   Purpose: Build the star schema tables.

   BEFORE RUNNING:
   Run 02_Create_Staging_View.sql first.
============================================================ */

USE Healthcare_Readmissions;
GO

IF OBJECT_ID('dbo.fact_readmissions', 'U') IS NOT NULL
BEGIN
    ALTER TABLE dbo.fact_readmissions DROP CONSTRAINT IF EXISTS FK_fact_patient;
END;
GO

DROP TABLE IF EXISTS dbo.fact_readmissions;
DROP TABLE IF EXISTS dbo.dim_diagnosis;
DROP TABLE IF EXISTS dbo.dim_patient;
GO

/* ------------------------------------------------------------
   Dimension Table: dim_patient

   Why:
   Stores one row per unique patient and separates patient
   demographics from encounter-level facts.
------------------------------------------------------------ */

CREATE TABLE dbo.dim_patient (
    patient_nbr NVARCHAR(255) NOT NULL PRIMARY KEY,
    race NVARCHAR(100),
    gender NVARCHAR(50),
    age NVARCHAR(50)
);
GO

INSERT INTO dbo.dim_patient (
    patient_nbr,
    race,
    gender,
    age
)
SELECT
    patient_nbr,
    MAX(race) AS race,
    MAX(gender) AS gender,
    MAX(age) AS age
FROM dbo.stg_readmissions
GROUP BY patient_nbr;
GO

/* ------------------------------------------------------------
   Dimension Table: dim_diagnosis

   Why:
   Stores unique primary diagnosis codes.
   This supports dimensional modeling and can be expanded later
   by mapping diagnosis codes into clinical categories.
------------------------------------------------------------ */

CREATE TABLE dbo.dim_diagnosis (
    diagnosis_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    diag_1 NVARCHAR(50) NOT NULL
);
GO

INSERT INTO dbo.dim_diagnosis (diag_1)
SELECT DISTINCT
    diag_1
FROM dbo.stg_readmissions
WHERE diag_1 IS NOT NULL
  AND diag_1 <> '?';
GO

/* ------------------------------------------------------------
   Fact Table: fact_readmissions

   Why:
   Stores one row per hospital encounter with measurable encounter
   facts used for readmission analysis.
------------------------------------------------------------ */

CREATE TABLE dbo.fact_readmissions (
    encounter_id INT NOT NULL PRIMARY KEY,
    patient_nbr NVARCHAR(255) NOT NULL,
    time_in_hospital INT,
    num_lab_procedures INT,
    num_procedures INT,
    num_medications INT,
    number_diagnoses INT,
    readmitted_30d_flag INT
);
GO

INSERT INTO dbo.fact_readmissions (
    encounter_id,
    patient_nbr,
    time_in_hospital,
    num_lab_procedures,
    num_procedures,
    num_medications,
    number_diagnoses,
    readmitted_30d_flag
)
SELECT
    encounter_id,
    patient_nbr,
    time_in_hospital,
    num_lab_procedures,
    num_procedures,
    num_medications,
    number_diagnoses,
    readmitted_30d_flag
FROM dbo.stg_readmissions;
GO

ALTER TABLE dbo.fact_readmissions
ADD CONSTRAINT FK_fact_patient
FOREIGN KEY (patient_nbr)
REFERENCES dbo.dim_patient(patient_nbr);
GO

/* ------------------------------------------------------------
   Indexes

   Why:
   Improve joins and common filtering patterns.
   Included to demonstrate basic SQL Server performance design.
------------------------------------------------------------ */

CREATE INDEX IX_fact_readmissions_patient_nbr
ON dbo.fact_readmissions(patient_nbr);
GO

CREATE INDEX IX_fact_readmissions_readmitted_30d_flag
ON dbo.fact_readmissions(readmitted_30d_flag);
GO

CREATE INDEX IX_fact_readmissions_number_diagnoses
ON dbo.fact_readmissions(number_diagnoses);
GO
