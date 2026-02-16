-- Migration: 009_create_alerts.sql
-- Description: Create alerts table for health threshold notifications
-- Alerts users when biomarker readings exceed safe thresholds

CREATE TABLE IF NOT EXISTS alerts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    biomarker_type VARCHAR(50) NOT NULL 
        CHECK (biomarker_type IN ('heart_rate', 'spo2', 'steps', 'calories', 'sleep', 'environmental_noise')),
    threshold_value NUMERIC NOT NULL,
    actual_value NUMERIC NOT NULL,
    alert_type VARCHAR(50) 
        CHECK (alert_type IN ('warning', 'critical', 'info'))
        DEFAULT 'warning',
    message TEXT,
    status VARCHAR(20) 
        CHECK (status IN ('active', 'read', 'dismissed', 'resolved'))
        DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP,
    CONSTRAINT check_threshold_actual CHECK (actual_value != threshold_value)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_alert_user_id ON alerts(user_id);
CREATE INDEX IF NOT EXISTS idx_alert_status ON alerts(status);
CREATE INDEX IF NOT EXISTS idx_alert_biomarker_type ON alerts(biomarker_type);
CREATE INDEX IF NOT EXISTS idx_alert_created_at ON alerts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_alert_user_status ON alerts(user_id, status);
CREATE INDEX IF NOT EXISTS idx_alert_user_created ON alerts(user_id, created_at DESC);
