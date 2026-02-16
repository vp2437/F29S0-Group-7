-- Migration: 003_create_appointments.sql
-- Description: Create appointments table for scheduling
-- Links patients with providers for consultations

CREATE TABLE IF NOT EXISTS appointments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    provider_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    status VARCHAR(20) 
        CHECK (status IN ('scheduled', 'completed', 'cancelled', 'no_show', 'rescheduled'))
        DEFAULT 'scheduled',
    notes TEXT,
    provider_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_end_after_start CHECK (end_time > start_time)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_appointment_patient_id ON appointments(patient_id);
CREATE INDEX IF NOT EXISTS idx_appointment_provider_id ON appointments(provider_id);
CREATE INDEX IF NOT EXISTS idx_appointment_start_time ON appointments(start_time);
CREATE INDEX IF NOT EXISTS idx_appointment_status ON appointments(status);
CREATE INDEX IF NOT EXISTS idx_appointment_provider_start ON appointments(provider_id, start_time DESC);
CREATE INDEX IF NOT EXISTS idx_appointment_patient_start ON appointments(patient_id, start_time DESC);
