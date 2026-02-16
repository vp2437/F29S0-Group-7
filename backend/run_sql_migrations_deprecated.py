"""run_migrations.py

Runs all SQL migration files in ./migrations against the configured PostgreSQL DB.

Usage:
  1) Copy .env.example -> .env and set DATABASE_URL
  2) Ensure the database exists (e.g., createdb healix_db)
  3) python run_migrations.py

Notes:
  - Migrations are executed in filename order (000_*, 001_*, ...).
  - The SQL files are intended for PostgreSQL.
"""

from __future__ import annotations

import os
from pathlib import Path

import psycopg2
from dotenv import load_dotenv


def main() -> int:
    # Load environment variables from .env if present
    load_dotenv()

    db_url = os.getenv("DATABASE_URL")
    if not db_url:
        print("ERROR: DATABASE_URL is not set. Copy .env.example -> .env and set it.")
        return 1

    migrations_dir = Path(__file__).parent / "migrations"
    if not migrations_dir.exists():
        print(f"ERROR: migrations directory not found at {migrations_dir}")
        return 1

    sql_files = sorted(p for p in migrations_dir.glob("*.sql") if p.is_file())
    if not sql_files:
        print(f"ERROR: no .sql files found in {migrations_dir}")
        return 1

    print(f"Connecting to: {db_url}")
    conn = psycopg2.connect(db_url)
    conn.autocommit = True
    try:
        with conn.cursor() as cur:
            for path in sql_files:
                sql_text = path.read_text(encoding="utf-8")
                if not sql_text.strip():
                    print(f"[SKIP] {path.name} (empty)")
                    continue

                print(f"[RUN ] {path.name}")
                try:
                    cur.execute(sql_text)
                except Exception as e:
                    print(f"[FAIL] {path.name}: {e}")
                    raise

        print("\nAll migrations completed successfully.")
        return 0
    finally:
        conn.close()


if __name__ == "__main__":
    raise SystemExit(main())
