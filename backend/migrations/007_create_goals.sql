-- Migration: 007_create_goals.sql
-- Description: Create goals table for user health goals
-- Tracks goals like daily steps, calorie burn, heart rate targets, etc.

CREATE TABLE IF NOT EXISTS goals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    goal_type VARCHAR(100) NOT NULL 
        CHECK (goal_type IN ('steps', 'calories', 'heart_rate', 'sleep', 'water_intake', 'custom')),
    target_value NUMERIC NOT NULL,
    current_value NUMERIC DEFAULT 0,
    unit VARCHAR(20),
    period VARCHAR(20) 
        CHECK (period IN ('daily', 'weekly', 'monthly', 'yearly'))
        DEFAULT 'daily',
    status VARCHAR(20) 
        CHECK (status IN ('active', 'completed', 'abandoned', 'paused'))
        DEFAULT 'active',
    start_date DATE DEFAULT CURRENT_DATE,
    end_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_goal_user_id ON goals(user_id);
CREATE INDEX IF NOT EXISTS idx_goal_status ON goals(status);
CREATE INDEX IF NOT EXISTS idx_goal_goal_type ON goals(goal_type);
CREATE INDEX IF NOT EXISTS idx_goal_user_status ON goals(user_id, status);
