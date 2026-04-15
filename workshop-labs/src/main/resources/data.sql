-- ============================================================
-- Seed data for the OutFront Workshop OMS
-- ============================================================

-- Sample orders
INSERT INTO orders (customer_name, product_name, quantity, status, order_date, notes) VALUES
    ('Clear Channel NYC', 'Digital Screen Unit 96x48', 4, 'CONFIRMED', '2024-11-01', 'Install at Times Square locations'),
    ('JCDecaux Transit', 'LED Panel 72x36', 10, 'PENDING', '2024-11-05', 'Awaiting site survey approval'),
    ('Lamar Advertising', 'Transit Display Module', 6, 'SHIPPED', '2024-10-20', 'Shipped via freight — ETA Nov 15'),
    ('Outfront Media HQ', 'Smart Kiosk Display', 2, 'PENDING', '2024-11-10', 'Internal demo units for trade show'),
    ('Adams Outdoor', 'Solar Billboard Controller', 8, 'CONFIRMED', '2024-11-08', 'Rural highway deployment — Phase 1');

-- Inventory items
INSERT INTO inventory_item (sku, name, description, quantity, location, last_updated) VALUES
    ('DSU-9648', 'Digital Screen Unit 96x48', 'High-brightness 96x48 inch digital billboard screen, weatherproof', 25, 'Warehouse A — Newark, NJ', '2024-11-01'),
    ('LED-7236', 'LED Panel 72x36', 'Full-color LED panel for urban signage, 72x36 inches', 50, 'Warehouse A — Newark, NJ', '2024-11-03'),
    ('TDM-2412', 'Transit Display Module', 'Compact transit shelter display, 24x12 inches, anti-glare', 30, 'Warehouse B — Los Angeles, CA', '2024-10-28'),
    ('SKD-3220', 'Smart Kiosk Display', 'Interactive touch kiosk with 32-inch screen, built-in sensors', 12, 'Warehouse A — Newark, NJ', '2024-11-05'),
    ('SBC-001', 'Solar Billboard Controller', 'Solar-powered controller unit for remote billboard sites', 40, 'Warehouse C — Dallas, TX', '2024-11-02'),
    ('MNT-UNI', 'Universal Mounting Bracket', 'Adjustable steel mounting bracket for panels up to 96 inches', 100, 'Warehouse A — Newark, NJ', '2024-10-15'),
    ('CAB-HDMI50', 'HDMI Cable 50ft', 'Industrial-grade 50-foot HDMI cable, weatherproof connectors', 200, 'Warehouse B — Los Angeles, CA', '2024-10-20'),
    ('PSU-500W', 'Power Supply Unit 500W', '500W weatherproof power supply for outdoor digital displays', 75, 'Warehouse C — Dallas, TX', '2024-11-01'),
    ('CTL-MEDIA', 'Media Player Controller', 'ARM-based media player for content scheduling and playback', 35, 'Warehouse A — Newark, NJ', '2024-11-07'),
    ('SEN-AMB', 'Ambient Light Sensor', 'Auto-brightness ambient light sensor for dynamic display adjustment', 60, 'Warehouse B — Los Angeles, CA', '2024-11-04');
