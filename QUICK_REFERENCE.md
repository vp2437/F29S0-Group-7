# QUICK REFERENCE: Backend File Structure

## 🎯 At a Glance

```
backend/
├── app.py                           Main entry point
├── wsgi.py                          Production entry
├── requirements.txt                 Dependencies
├── .env.example                     Config template
│
├── src/                             Application code
│   ├── __init__.py                  Flask app factory
│   ├── config/                      Settings
│   ├── models/                      Database models
│   ├── controllers/                 Business logic
│   ├── routes/                      API endpoints
│   ├── middleware/                  Request processing
│   └── utils/                       Helpers
│
├── migrations/                      SQL files (CREATE NEXT!)
└── tests/                           Test files
```

## 📋 Task Assignment by Role

| Role | Files to Create | Location |
|------|-----------------|----------|
| **Kevin** | Database setup, migrations runner | `backend/` |
| **Neil** | SQL files 001-007, Appointment models | `migrations/`, `src/models/` |
| **Basheer** | Biomarker models, controllers, routes | `src/models/`, `src/controllers/` |
| **Arya** | Auth middleware, Admin controllers, Audit logs, SQL 008 | `src/middleware/`, `src/controllers/` |

## 🚀 Command Reference

```bash
# Setup virtual environment
python -m venv venv
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run development server
python app.py

# Run tests
pytest tests/

# Run specific test file
pytest tests/test_auth.py
```

## 📝 File Naming Pattern

| Type | Pattern | Example |
|------|---------|---------|
| Model files | `models/tablename.py` | `models/user.py` |
| Controller files | `controllers/feature_controller.py` | `controllers/auth_controller.py` |
| Route files | `routes/feature_routes.py` | `routes/auth_routes.py` |
| SQL migrations | `migrations/NNN_description.sql` | `migrations/001_create_users.sql` |
| Test files | `tests/test_feature.py` | `tests/test_auth.py` |

## 🔑 Key Files by Role

### KEVIN
- `app.py` - Start server here
- `requirements.txt` - Install packages
- `.env` - Configure database
- `wsgi.py` - Production deployment

### NEIL
- `migrations/001-007` - Create SQL schema
- `src/models/appointment.py`, `prescription.py`
- `src/controllers/appointment_controller.py`
- `src/routes/appointment_routes.py`

### BASHEER
- `src/models/biomarker.py`
- `src/controllers/biomarker_controller.py`
- `src/routes/biomarker_routes.py`
- `src/utils/biomarker_validator.py`

### ARYA
- `src/middleware/auth_middleware.py`
- `src/middleware/authorization.py`
- `src/controllers/admin_controller.py`
- `src/controllers/export_controller.py`
- `src/utils/audit_logger.py`
- `src/models/audit_log.py`
- `migrations/008_create_audit_logs.sql`

## 🔗 Dependencies (Blocking)

```
Kevin's Database Setup
    ↓ (Need database)
Neil's SQL Migrations
    ↓ (Need schema)
Python Models
    ↓ (Need structure)
Controllers & Routes
    ↓ (Need logic)
API Testing
```

## ✅ Checklist

- [x] Create directory structure
- [x] Create app.py, wsgi.py
- [x] Create requirements.txt
- [x] Create config files
- [ ] Create SQL migration files (NEXT)
- [ ] Create Python models
- [ ] Create controllers
- [ ] Create routes
- [ ] Create middleware
- [ ] Add tests

## 📖 Documentation Files Created

- `README.md` - Full project documentation
- `SETUP_GUIDE.md` - Getting started guide
- `STRUCTURE_GUIDE.txt` - Visual structure explanation
- `BACKEND_STRUCTURE_SUMMARY.txt` - Complete summary

---

**Ready to create SQL files?** Let me know! 🚀
