-- Migration: 020_seed_data.sql
-- Description: Seed the database with demo data (FAKE DATA ONLY)
-- Note: Password hashes below are bcrypt hashes for the plaintext "password123".

-- ---------------------------------------------------------------------------
-- Users (authentication)
-- ---------------------------------------------------------------------------
INSERT INTO users (id, email, password, role, status)
VALUES
    ('11111111-1111-1111-1111-111111111111', 'admin@healix.demo', '$2b$12$UKPADzDzgBP0PrgWMCsRK.3uKqtrURZYfbPUwnHy6U9ib/XIEBSbq', 'admin', 'active'),
    ('22222222-2222-2222-2222-222222222222', 'dr.singh@healix.demo', '$2b$12$UKPADzDzgBP0PrgWMCsRK.3uKqtrURZYfbPUwnHy6U9ib/XIEBSbq', 'provider', 'active'),
    ('33333333-3333-3333-3333-333333333333', 'dr.chen@healix.demo', '$2b$12$UKPADzDzgBP0PrgWMCsRK.3uKqtrURZYfbPUwnHy6U9ib/XIEBSbq', 'provider', 'active'),
    ('44444444-4444-4444-4444-444444444444', 'patient1@healix.demo', '$2b$12$UKPADzDzgBP0PrgWMCsRK.3uKqtrURZYfbPUwnHy6U9ib/XIEBSbq', 'patient', 'active'),
    ('55555555-5555-5555-5555-555555555555', 'patient2@healix.demo', '$2b$12$UKPADzDzgBP0PrgWMCsRK.3uKqtrURZYfbPUwnHy6U9ib/XIEBSbq', 'patient', 'active'),
    ('66666666-6666-6666-6666-666666666666', 'patient3@healix.demo', '$2b$12$UKPADzDzgBP0PrgWMCsRK.3uKqtrURZYfbPUwnHy6U9ib/XIEBSbq', 'patient', 'active')
ON CONFLICT (email) DO NOTHING;

-- Provider-only fields live on users for now (simple)
UPDATE users
SET provider_specialization = CASE id
        WHEN '22222222-2222-2222-2222-222222222222' THEN 'General Practice'
        WHEN '33333333-3333-3333-3333-333333333333' THEN 'Cardiology'
        ELSE provider_specialization
    END,
    provider_license_number = CASE id
        WHEN '22222222-2222-2222-2222-222222222222' THEN 'LIC-GP-1001'
        WHEN '33333333-3333-3333-3333-333333333333' THEN 'LIC-CARD-2002'
        ELSE provider_license_number
    END
WHERE id IN ('22222222-2222-2222-2222-222222222222', '33333333-3333-3333-3333-333333333333');

-- ---------------------------------------------------------------------------
-- Profiles (demographics, preferences, health conditions)
-- ---------------------------------------------------------------------------
INSERT INTO profiles (id, user_id, first_name, last_name, age, gender, health_conditions, preferences)
VALUES
    (gen_random_uuid(), '11111111-1111-1111-1111-111111111111', 'Admin', 'User', 30, 'other', NULL, '{"units":"metric","email_notifs":false}'::jsonb),
    (gen_random_uuid(), '22222222-2222-2222-2222-222222222222', 'Asha', 'Singh', 41, 'female', NULL, '{"units":"metric"}'::jsonb),
    (gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'Wei', 'Chen', 38, 'male', NULL, '{"units":"metric"}'::jsonb),
    (gen_random_uuid(), '44444444-4444-4444-4444-444444444444', 'Sam', 'Taylor', 24, 'male', 'mild asthma', '{"units":"metric","push_notifs":true}'::jsonb),
    (gen_random_uuid(), '55555555-5555-5555-5555-555555555555', 'Lina', 'Khan', 27, 'female', 'hypertension', '{"units":"metric","push_notifs":true}'::jsonb),
    (gen_random_uuid(), '66666666-6666-6666-6666-666666666666', 'Omar', 'Hassan', 33, 'male', NULL, '{"units":"metric","push_notifs":false}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;

-- ---------------------------------------------------------------------------
-- Provider <-> Patient relationships
-- ---------------------------------------------------------------------------
INSERT INTO provider_patient_relationships (id, provider_id, patient_id)
VALUES
    (gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '44444444-4444-4444-4444-444444444444'),
    (gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '55555555-5555-5555-5555-555555555555'),
    (gen_random_uuid(), '33333333-3333-3333-3333-333333333333', '66666666-6666-6666-6666-666666666666')
ON CONFLICT (provider_id, patient_id) DO NOTHING;

-- ---------------------------------------------------------------------------
-- Devices
-- ---------------------------------------------------------------------------
INSERT INTO devices (id, user_id, device_type, device_name, device_model, manufacturer, api_key, status, last_sync)
VALUES
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '44444444-4444-4444-4444-444444444444', 'smartwatch', 'Demo Watch', 'Watch X', 'Acme', 'demo-api-key-1', 'connected', NOW() - INTERVAL '1 hour'),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '55555555-5555-5555-5555-555555555555', 'fitness_tracker', 'Demo Tracker', 'Tracker Pro', 'Acme', 'demo-api-key-2', 'connected', NOW() - INTERVAL '2 hours')
ON CONFLICT (id) DO NOTHING;

-- ---------------------------------------------------------------------------
-- Biomarker thresholds (per user)
-- ---------------------------------------------------------------------------
INSERT INTO biomarker_thresholds (id, user_id, biomarker_type, warning_min, warning_max, critical_min, critical_max, unit)
VALUES
    (gen_random_uuid(), '44444444-4444-4444-4444-444444444444', 'heart_rate', 50, 120, 40, 160, 'bpm'),
    (gen_random_uuid(), '44444444-4444-4444-4444-444444444444', 'spo2', 92, NULL, 88, NULL, '%'),
    (gen_random_uuid(), '55555555-5555-5555-5555-555555555555', 'heart_rate', 50, 115, 40, 155, 'bpm'),
    (gen_random_uuid(), '55555555-5555-5555-5555-555555555555', 'spo2', 92, NULL, 88, NULL, '%')
ON CONFLICT (user_id, biomarker_type) DO NOTHING;

-- ---------------------------------------------------------------------------
-- Biomarker readings (time-series demo data)
-- ---------------------------------------------------------------------------
INSERT INTO biomarker_readings (id, user_id, device_id, reading_type, value, unit, timestamp, status, fault_reason, notes)
VALUES
    (gen_random_uuid(), '44444444-4444-4444-4444-444444444444', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'heart_rate', 72, 'bpm', NOW() - INTERVAL '6 days', 'ok', NULL, NULL),
    (gen_random_uuid(), '44444444-4444-4444-4444-444444444444', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'heart_rate', 85, 'bpm', NOW() - INTERVAL '5 days', 'ok', NULL, NULL),
    (gen_random_uuid(), '44444444-4444-4444-4444-444444444444', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'heart_rate', 130, 'bpm', NOW() - INTERVAL '1 day', 'ok', NULL, 'after workout'),
    (gen_random_uuid(), '44444444-4444-4444-4444-444444444444', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'spo2', 97, '%', NOW() - INTERVAL '1 day', 'ok', NULL, NULL),
    (gen_random_uuid(), '44444444-4444-4444-4444-444444444444', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'steps', 8342, 'steps', NOW() - INTERVAL '1 day', 'ok', NULL, NULL),
    (gen_random_uuid(), '55555555-5555-5555-5555-555555555555', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'heart_rate', 78, 'bpm', NOW() - INTERVAL '2 days', 'ok', NULL, NULL),
    (gen_random_uuid(), '55555555-5555-5555-5555-555555555555', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'spo2', 91, '%', NOW() - INTERVAL '2 days', 'ok', NULL, 'slightly low'),
    (gen_random_uuid(), '55555555-5555-5555-5555-555555555555', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'calories', 2130, 'kcal', NOW() - INTERVAL '2 days', 'ok', NULL, NULL),
    (gen_random_uuid(), '55555555-5555-5555-5555-555555555555', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'steps', 999999, 'steps', NOW() - INTERVAL '3 days', 'faulty', 'range_violation', 'simulated faulty device input')
;

-- ---------------------------------------------------------------------------
-- Goals
-- ---------------------------------------------------------------------------
INSERT INTO goals (id, user_id, goal_type, target_value, current_value, unit, period, status, start_date, notes)
VALUES
    (gen_random_uuid(), '44444444-4444-4444-4444-444444444444', 'steps', 9000, 8342, 'steps', 'daily', 'active', CURRENT_DATE, 'Daily walking goal'),
    (gen_random_uuid(), '55555555-5555-5555-5555-555555555555', 'calories', 2000, 2130, 'kcal', 'daily', 'active', CURRENT_DATE, 'Keep under 2000 kcal')
;

-- ---------------------------------------------------------------------------
-- Appointments
-- ---------------------------------------------------------------------------
INSERT INTO appointments (id, patient_id, provider_id, start_time, end_time, status, notes)
VALUES
    (gen_random_uuid(), '44444444-4444-4444-4444-444444444444', '22222222-2222-2222-2222-222222222222', NOW() + INTERVAL '3 days', NOW() + INTERVAL '3 days 30 minutes', 'scheduled', 'Routine follow-up'),
    (gen_random_uuid(), '55555555-5555-5555-5555-555555555555', '22222222-2222-2222-2222-222222222222', NOW() - INTERVAL '7 days', (NOW() - INTERVAL '7 days') + INTERVAL '30 minutes', 'completed', 'Blood pressure discussion')
;

-- ---------------------------------------------------------------------------
-- Prescriptions
-- ---------------------------------------------------------------------------
INSERT INTO prescriptions (id, patient_id, provider_id, medication_name, dosage, quantity, refills_left, instructions, issued_date, status)
VALUES
    (gen_random_uuid(), '55555555-5555-5555-5555-555555555555', '22222222-2222-2222-2222-222222222222', 'Lisinopril', '10mg', 30, 2, 'Take 1 tablet daily', NOW() - INTERVAL '7 days', 'active')
;

-- ---------------------------------------------------------------------------
-- Alerts + Notifications
-- ---------------------------------------------------------------------------
WITH inserted_alert AS (
    INSERT INTO alerts (id, user_id, biomarker_type, threshold_value, actual_value, alert_type, message, status, created_at)
    VALUES (gen_random_uuid(), '55555555-5555-5555-5555-555555555555', 'spo2', 92, 91, 'warning', 'SpO₂ is slightly below your warning threshold.', 'active', NOW() - INTERVAL '2 days')
    RETURNING id
)
INSERT INTO notifications (id, user_id, notif_type, title, message, related_resource_type, related_resource_id, created_at, status, read_at)
SELECT gen_random_uuid(), '55555555-5555-5555-5555-555555555555', 'alert', 'Oxygen level warning',
       'Your SpO₂ reading was 91%, which is below your configured threshold.', 'alert', inserted_alert.id,
       NOW() - INTERVAL '2 days', 'read', NOW() - INTERVAL '2 days'
FROM inserted_alert;

-- ---------------------------------------------------------------------------
-- Sessions
-- ---------------------------------------------------------------------------
INSERT INTO sessions (id, user_id, refresh_token_hash, ip_address, user_agent, created_at, expires_at)
VALUES
    (gen_random_uuid(), '44444444-4444-4444-4444-444444444444', 'sha256:demo_refresh_token_hash', '127.0.0.1', 'seed-script', NOW() - INTERVAL '1 hour', NOW() + INTERVAL '6 days')
;

-- ---------------------------------------------------------------------------
-- Password reset tokens (example)
-- ---------------------------------------------------------------------------
INSERT INTO password_reset_tokens (id, user_id, token_hash, created_at, expires_at)
VALUES
    (gen_random_uuid(), '44444444-4444-4444-4444-444444444444', 'sha256:demo_reset_token_hash', NOW() - INTERVAL '10 minutes', NOW() + INTERVAL '20 minutes')
;

-- ---------------------------------------------------------------------------
-- Audit logs
-- ---------------------------------------------------------------------------
INSERT INTO audit_logs (id, user_id, user_role, action, resource_type, resource_id, ip_address, user_agent, details, timestamp)
VALUES
    (gen_random_uuid(), '11111111-1111-1111-1111-111111111111', 'admin', 'ADMIN_VIEW_USERS', 'user', NULL, '127.0.0.1', 'seed-script', '{"note":"demo"}', NOW() - INTERVAL '1 day'),
    (gen_random_uuid(), '22222222-2222-2222-2222-222222222222', 'provider', 'PROVIDER_VIEW_PATIENT', 'user', '44444444-4444-4444-4444-444444444444', '127.0.0.1', 'seed-script', '{"reason":"routine"}', NOW() - INTERVAL '1 day')
;
