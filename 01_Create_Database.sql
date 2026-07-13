/* ============================================================
   PROJECT 2: CLINICAL OUTCOMES ANALYTICS
   Script: 01_Create_Database.sql
   Purpose: Create and select the project database.

   Dataset: Diabetes 130-US Hospitals
   Goal: Analyze 30-day hospital readmissions
   Tools: SQL Server + Power BI

   BEFORE RUNNING:
   1. Import the CSV into SQL Server after creating the database.
   2. Raw table name must be: dbo.raw_diabetes_readmissions
============================================================ */

IF DB_ID('Healthcare_Readmissions') IS NULL
BEGIN
    CREATE DATABASE Healthcare_Readmissions;
END;
GO

USE Healthcare_Readmissions;
GO
