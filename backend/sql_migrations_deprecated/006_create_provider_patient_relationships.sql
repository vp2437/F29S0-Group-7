-- Migration: 006_create_provider_patient_relationships.sql
-- Description: Create provider_patient_relationships table
-- Establishes access control: defines which providers can access which patients
-- A provider can only view data for patients they have a relationship with

CREATE TABLE IF NOT EXISTS provider_patient_relationships (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    provider_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    patient_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(provider_id, patient_id),
    CONSTRAINT check_different_users CHECK (provider_id != patient_id)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_provider_patient_provider_id ON provider_patient_relationships(provider_id);
CREATE INDEX IF NOT EXISTS idx_provider_patient_patient_id ON provider_patient_relationships(patient_id);
