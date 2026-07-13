/* ============================================================
   PROJECT 2: CLINICAL OUTCOMES ANALYTICS
   Script: 05_Create_Stored_Procedure.sql
   Purpose: Create reusable executive KPI logic.

   BEFORE RUNNING:
   Run 02_Create_Staging_View.sql first.
============================================================ */

USE Healthcare_Readmissions;
GO

DROP PROCEDURE IF EXISTS dbo.usp_ReadmissionSummary;
GO

/* ------------------------------------------------------------
   Stored Procedure: usp_ReadmissionSummary

   Why:
   Demonstrates SQL Server stored procedure skills and returns
   reusable executive readmission KPIs.

   Parameter:
   @ReadmittedOnly = 0 returns all encounters
   @ReadmittedOnly = 1 returns only 30-day readmissions
------------------------------------------------------------ */

CREATE PROCEDURE dbo.usp_ReadmissionSummary
    @ReadmittedOnly BIT = 0
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        COUNT(*) AS TotalEncounters,
        SUM(readmitted_30d_flag) AS ReadmittedEncounters,
        ROUND(100.0 * SUM(readmitted_30d_flag) / COUNT(*), 2) AS ReadmissionRatePct,
        ROUND(AVG(CAST(time_in_hospital AS FLOAT)), 2) AS AverageLengthOfStay
    FROM dbo.stg_readmissions
    WHERE @ReadmittedOnly = 0
       OR readmitted_30d_flag = 1;
END;
GO
