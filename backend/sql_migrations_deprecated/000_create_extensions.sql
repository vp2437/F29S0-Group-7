-- Migration: 000_create_extensions.sql
-- Description: Enable PostgreSQL extensions required by later migrations

-- gen_random_uuid() is provided by pgcrypto
CREATE EXTENSION IF NOT EXISTS pgcrypto;
