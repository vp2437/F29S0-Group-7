-- Migration: 004_create_prescriptions.sql
-- Description: Create prescriptions table for medical prescriptions
-- Providers write prescriptions for patients

CREATE TABLE IF NOT EXISTS prescriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    provider_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    medication_name VARCHAR(255) NOT NULL,
    dosage VARCHAR(100) NOT NULL,
    quantity INTEGER NOT NULL,
    refills_left INTEGER NOT NULL DEFAULT 0,
    instructions TEXT,
    issued_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) 
        CHECK (status IN ('active', 'completed', 'expired', 'cancelled'))
        DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_prescription_patient_id ON prescriptions(patient_id);
CREATE INDEX IF NOT EXISTS idx_prescription_provider_id ON prescriptions(provider_id);
CREATE INDEX IF NOT EXISTS idx_prescription_status ON prescriptions(status);
CREATE INDEX IF NOT EXISTS idx_prescription_issued_date ON prescriptions(issued_date DESC);
CREATE INDEX IF NOT EXISTS idx_prescription_patient_status ON prescriptions(patient_id, status);
