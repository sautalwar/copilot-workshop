-- =============================================================================
-- SQL Server Database Initialization Script
-- =============================================================================
-- This script runs when the SQL Server container starts for the first time.
-- It creates the database and sets up the schema that Hibernate will populate.
--
-- Usage (standalone):
--   sqlcmd -S localhost -U sa -P "YourStrong@Passw0rd" -i init-db.sql
--
-- Usage (Docker Compose):
--   Automatically mounted and executed via docker-compose.yml
-- =============================================================================

-- Create the database if it doesn't exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'outfront_oms')
BEGIN
    CREATE DATABASE outfront_oms;
    PRINT 'Database outfront_oms created.';
END
ELSE
BEGIN
    PRINT 'Database outfront_oms already exists.';
END
GO

USE outfront_oms;
GO

-- =============================================================================
-- Note: Hibernate (ddl-auto=update) will create the tables automatically
-- from the JPA entity definitions. This script only ensures the database
-- exists. The seed data is loaded from data.sql by Spring Boot.
-- =============================================================================
