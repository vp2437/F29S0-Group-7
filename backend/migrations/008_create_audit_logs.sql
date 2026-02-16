-- Migration: 008_create_audit_logs.sql
-- Description: Create audit_logs table for compliance and security tracking
-- ARYA'S PRIMARY TABLE: Logs all sensitive actions for GDPR/PDPL compliance
-- Tracks: admin actions, provider access, authorization failures, data exports, etc.

CREATE TABLE IF NOT EXISTS audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID,
    user_role VARCHAR(20),
    action VARCHAR(100) NOT NULL,
    resource_type VARCHAR(50),
    resource_id UUID,
    ip_address VARCHAR(45),
    user_agent TEXT,
    details JSONB,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Indexes for performance and querying
CREATE INDEX IF NOT EXISTS idx_audit_user_id ON audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_timestamp ON audit_logs(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_audit_action ON audit_logs(action);
CREATE INDEX IF NOT EXISTS idx_audit_resource_type ON audit_logs(resource_type);
CREATE INDEX IF NOT EXISTS idx_audit_user_timestamp ON audit_logs(user_id, timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_audit_action_timestamp ON audit_logs(action, timestamp DESC);

-- Sample actions tracked:
-- ADMIN_VIEW_USERS
-- ADMIN_DELETE_USER
-- ADMIN_CREATE_PROVIDER
-- ADMIN_GRANT_PROVIDER
-- ADMIN_REVOKE_PROVIDER
-- PROVIDER_VIEW_PATIENT
-- PROVIDER_ACCESS_DATA
-- PROVIDER_WRITE_PRESCRIPTION
-- PROVIDER_EXPORT_DATA
-- PATIENT_EXPORT_REPORT
-- PATIENT_VIEW_OWN_DATA
-- ACCESS_DENIED
-- UNAUTHORIZED_ACCESS_ATTEMPT
-- PASSWORD_RESET
-- ACCOUNT_DELETION
-- DATA_ANONYMIZATION
