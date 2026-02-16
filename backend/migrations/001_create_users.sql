-- Migration: 001_create_users.sql
-- Description: Create users table for authentication and profiles
-- All user types: patients, providers, and admins

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    age INTEGER,
    gender VARCHAR(20),
    role VARCHAR(20) NOT NULL 
        CHECK (role IN ('patient', 'provider', 'admin'))
        DEFAULT 'patient',
    status VARCHAR(20) 
        CHECK (status IN ('active', 'inactive'))
        DEFAULT 'active',
    health_conditions TEXT,
    provider_specialization VARCHAR(100),
    provider_license_number VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_status ON users(status);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);
