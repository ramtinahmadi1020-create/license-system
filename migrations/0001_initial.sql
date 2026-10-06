CREATE TABLE IF NOT EXISTS admins (id INTEGER PRIMARY KEY CHECK (id = 1), username TEXT NOT NULL UNIQUE, password_hash TEXT NOT NULL, password_salt TEXT NOT NULL, iterations INTEGER NOT NULL, created_at INTEGER NOT NULL);
CREATE TABLE IF NOT EXISTS licenses (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, key TEXT UNIQUE NOT NULL, type TEXT NOT NULL CHECK (type IN ('monthly','3m','6m','yearly','unlimited')), status TEXT NOT NULL DEFAULT 'unused' CHECK (status IN ('unused','active','expired','revoked')), device_id TEXT, created_at INTEGER NOT NULL, activated_at INTEGER, expires_at INTEGER);
CREATE TABLE IF NOT EXISTS login_attempts (ip TEXT PRIMARY KEY, failures INTEGER NOT NULL DEFAULT 0, blocked_until INTEGER NOT NULL DEFAULT 0, updated_at INTEGER NOT NULL);
CREATE TABLE IF NOT EXISTS api_rate_limits (ip TEXT PRIMARY KEY, window_start INTEGER NOT NULL, count INTEGER NOT NULL DEFAULT 0);
CREATE TABLE IF NOT EXISTS sessions (token_hash TEXT PRIMARY KEY, expires_at INTEGER NOT NULL, created_at INTEGER NOT NULL);
CREATE INDEX IF NOT EXISTS idx_licenses_created ON licenses(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_licenses_search ON licenses(name, key);
