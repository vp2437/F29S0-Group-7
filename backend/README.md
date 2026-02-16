# HEALIX Backend (MongoDB)

This backend is configured to use **MongoDB**.

## Prerequisites
- Python 3.10+
- MongoDB (local) **or** MongoDB Atlas

## Configure environment
Copy the example file and edit it:

```bash
cp .env.example .env
```

Set:

- `MONGODB_URI` (e.g. `mongodb://localhost:27017` or your Atlas SRV string)
- `MONGODB_DB` (default: `healix_db`)

## Initialize the database (collections, indexes, seed data)

```bash
cd backend
python setup_mongo.py
```

## Smoke test (read-only)

```bash
cd backend
python mongo_smoke_test.py
```

## Run the API (optional)

```bash
cd backend
python app.py
```

> Note: `backend/sql_migrations_deprecated/` contains the older SQL migration files from an earlier draft. The MongoDB setup script is the source of truth now.
