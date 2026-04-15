-- ============================================================
-- Seed data for Campaigns
-- Add these INSERT statements to the end of data.sql
-- ============================================================

-- Billboard advertising campaigns
INSERT INTO campaign (name, client, start_date, end_date, budget, status, location, created_at) VALUES
    ('Holiday Spectacular 2024', 'Macy''s', '2024-11-15', '2025-01-05', 125000.00, 'ACTIVE', 'Times Square, New York, NY', '2024-10-01 09:00:00'),
    ('Summer Blockbuster Promo', 'Universal Pictures', '2024-06-01', '2024-08-31', 250000.00, 'COMPLETED', 'Sunset Boulevard, Los Angeles, CA', '2024-04-15 14:30:00'),
    ('Spring Auto Launch', 'Tesla Motors', '2025-03-01', '2025-05-31', 180000.00, 'DRAFT', 'I-95 Corridor, Newark, NJ', '2024-11-10 11:00:00'),
    ('Back to School Tech', 'Best Buy', '2024-08-01', '2024-09-15', 75000.00, 'CANCELLED', 'Michigan Avenue, Chicago, IL', '2024-06-20 08:45:00'),
    ('New Year Fitness Push', 'Peloton', '2025-01-02', '2025-02-28', 95000.00, 'DRAFT', 'Downtown Connector, Atlanta, GA', '2024-11-05 16:15:00');
