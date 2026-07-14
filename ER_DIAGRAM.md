# ER Diagram

```mermaid
erDiagram

    dim_patient ||--o{ fact_readmissions : "patient_nbr"

    dim_patient {
        nvarchar patient_nbr PK
        nvarchar race
        nvarchar gender
        nvarchar age
    }

    fact_readmissions {
        int encounter_id PK
        nvarchar patient_nbr FK
        int time_in_hospital
        int num_lab_procedures
        int num_procedures
        int num_medications
        int number_diagnoses
        int readmitted_30d_flag
    }

    dim_diagnosis {
        int diagnosis_id PK
        nvarchar diag_1
    }
```

## Model Notes

- `dim_patient` contains one row per unique patient.
- `fact_readmissions` contains one row per hospital encounter.
- One patient can have multiple hospital encounters.
- `fact_readmissions.patient_nbr` is a foreign key referencing `dim_patient.patient_nbr`.
- `dim_diagnosis` contains unique primary diagnosis codes.
- `dim_diagnosis` is currently a standalone reference table because `fact_readmissions` does not contain a `diagnosis_id` foreign key.
