-- Migration: 005_create_devices.sql
-- Description: Create devices table for wearable device tracking
-- Links users to their wearable devices (smartwatch, fitness tracker, etc)

CREATE TABLE IF NOT EXISTS devices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    device_type VARCHAR(100) NOT NULL,
    device_name VARCHAR(255),
    device_model VARCHAR(100),
    manufacturer VARCHAR(100),
    api_key VARCHAR(255),
    api_secret VARCHAR(255),
    last_sync TIMESTAMP,
    status VARCHAR(20) 
        CHECK (status IN ('connected', 'disconnected', 'error'))
        DEFAULT 'disconnected',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_device_user_id ON devices(user_id);
CREATE INDEX IF NOT EXISTS idx_device_status ON devices(status);
CREATE INDEX IF NOT EXISTS idx_device_last_sync ON devices(last_sync);
