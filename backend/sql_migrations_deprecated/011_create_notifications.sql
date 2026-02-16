-- Migration: 011_create_notifications.sql
-- Description: Create notifications table
-- Used for reminders, threshold alerts, system messages, etc.

CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    notif_type VARCHAR(50) NOT NULL
        CHECK (notif_type IN ('alert', 'reminder', 'tip', 'appointment', 'system')),
    title VARCHAR(255),
    message TEXT NOT NULL,
    related_resource_type VARCHAR(50),
    related_resource_id UUID,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP,
    status VARCHAR(20)
        CHECK (status IN ('unread', 'read', 'dismissed'))
        DEFAULT 'unread'
);

CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_notifications_user_status ON notifications(user_id, status);
