-- Migration: 002_create_biomarkers.sql
-- Description: Create biomarker_readings table for health data
-- Stores readings: heart_rate, spo2, steps, calories, sleep, etc.

CREATE TABLE IF NOT EXISTS biomarker_readings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    device_id UUID,
    reading_type VARCHAR(50) NOT NULL 
        CHECK (reading_type IN ('heart_rate', 'spo2', 'steps', 'calories', 'sleep', 'environmental_noise')),
    value NUMERIC NOT NULL,
    unit VARCHAR(20) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) 
        CHECK (status IN ('ok', 'faulty'))
        DEFAULT 'ok',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance (critical for time-series queries)
CREATE INDEX IF NOT EXISTS idx_biomarker_user_id ON biomarker_readings(user_id);
CREATE INDEX IF NOT EXISTS idx_biomarker_timestamp ON biomarker_readings(timestamp);
CREATE INDEX IF NOT EXISTS idx_biomarker_type ON biomarker_readings(reading_type);
CREATE INDEX IF NOT EXISTS idx_biomarker_user_timestamp ON biomarker_readings(user_id, timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_biomarker_user_type_timestamp ON biomarker_readings(user_id, reading_type, timestamp DESC);
