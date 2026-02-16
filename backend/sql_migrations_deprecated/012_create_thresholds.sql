-- Migration: 012_create_thresholds.sql
-- Description: User-specific biomarker thresholds
-- Providers/users can configure warning/critical ranges per biomarker.

CREATE TABLE IF NOT EXISTS biomarker_thresholds (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    biomarker_type VARCHAR(50) NOT NULL
        CHECK (biomarker_type IN ('heart_rate', 'spo2', 'steps', 'calories', 'sleep', 'environmental_noise')),
    warning_min NUMERIC,
    warning_max NUMERIC,
    critical_min NUMERIC,
    critical_max NUMERIC,
    unit VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, biomarker_type)
);

CREATE INDEX IF NOT EXISTS idx_thresholds_user_id ON biomarker_thresholds(user_id);
CREATE INDEX IF NOT EXISTS idx_thresholds_user_type ON biomarker_thresholds(user_id, biomarker_type);
