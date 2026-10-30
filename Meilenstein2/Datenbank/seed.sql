-- Beispieldaten für schema.sql (Zeitstempel UTC).
-- Demo-Passwort für alle Konten: 'demo' (die Hashes sind Platzhalter).
PRAGMA foreign_keys = ON;
BEGIN TRANSACTION;

-- Benutzer (je Rolle einer)
INSERT INTO users (id, username, display_name, password_hash, role, locale, active) VALUES
 (1, 'admin',          'Administration',     '$PLACEHOLDER$admin-hash',     'ADMIN',     'de', 1),
 (2, 'hausmeister',    'Hausmeister Becker', '$PLACEHOLDER$caretaker-hash', 'CARETAKER', 'de', 1),
 (3, 'it.support',     'IT Support Schmidt', '$PLACEHOLDER$it-hash',        'IT',        'en', 1),
 (4, 'lehrer.mueller', 'Frau Müller',        '$PLACEHOLDER$teacher-hash',   'TEACHER',   'de', 1);

-- Gebäude, Geschosse, Räume
INSERT INTO buildings (id, name) VALUES (1, 'Beatusstraße');
INSERT INTO floors (id, building_id, level, name) VALUES
 (1, 1, 0, 'Erdgeschoss'),
 (2, 1, 1, '1. Obergeschoss'),
 (3, 1, 2, '2. Obergeschoss');
INSERT INTO rooms (id, floor_id, number, name, type, capacity, out_of_order, active) VALUES
 (1, 1, 'E.01', 'Sekretariat',        'OFFICE',      3, 0, 1),
 (2, 1, 'E.02', 'Klassenraum E.02',   'CLASSROOM',  28, 0, 1),
 (3, 1, 'E.03', '3D-Druck-Werkstatt', 'WORKSHOP',   16, 0, 1),
 (4, 1, 'E.04', 'Serverraum',         'SERVER_ROOM', 0, 0, 1),
 (5, 2, '1.01', 'Klassenraum 1.01',   'CLASSROOM',  28, 0, 1),
 (6, 2, '1.02', 'Klassenraum 1.02',   'CLASSROOM',  30, 0, 1),
 (7, 3, '2.01', 'Klassenraum 2.01',   'CLASSROOM',  28, 0, 1),
 (8, 3, '2.02', 'Klassenraum 2.02',   'CLASSROOM',  28, 1, 1);

-- Gerätetypen und Geräte
INSERT INTO device_types (id, code, name) VALUES
 (1, 'DISPLAY',     'Digitales Display'),
 (2, 'PRINTER_3D',  '3D-Drucker'),
 (3, 'NETWORK',     'Netzwerktechnik'),
 (4, 'VENTILATION', 'Raumlüftung'),
 (5, 'SMART_PLUG',  'Smarte Steckdose'),
 (6, 'SENSOR',      'Umweltsensor');
INSERT INTO devices (id, room_id, device_type_id, name, serial_number, status, installed_at, active) VALUES
 (1, 2, 1, 'Display E.02',           'DSP-2024-001',  'FAULTY',      '2024-08-15T08:00:00Z', 1),
 (2, 3, 2, '3D-Drucker Prusa A',     'P3D-MK4-0A17',  'ONLINE',      '2025-02-10T09:00:00Z', 1),
 (3, 3, 2, '3D-Drucker Prusa B',     'P3D-MK4-0B22',  'MAINTENANCE', '2025-02-10T09:00:00Z', 1),
 (4, 4, 3, 'Core-Switch Serverraum', 'NET-SW-48-001', 'ONLINE',      '2023-09-01T07:00:00Z', 1),
 (5, 6, 4, 'Lüftung 1.02',           'VNT-1102',      'ONLINE',      '2024-03-05T07:00:00Z', 1),
 (6, 3, 5, 'Steckdose Druckerinsel', 'SPL-0003',      'ONLINE',      '2025-02-10T09:30:00Z', 1),
 (7, 2, 6, 'Klimasensor E.02',       'SNS-E02',       'ONLINE',      '2025-05-12T10:00:00Z', 1),
 (8, 6, 6, 'Klimasensor 1.02',       'SNS-102',       'ONLINE',      '2025-05-12T10:00:00Z', 1);

-- Sensortypen, Sensoren (mit Grenzwerten) und Messwerte
INSERT INTO sensor_types (id, code, name, unit) VALUES
 (1, 'TEMPERATURE', 'Temperatur',        '°C'),
 (2, 'CO2',         'CO2-Konzentration', 'ppm'),
 (3, 'HUMIDITY',    'Luftfeuchtigkeit',  '%'),
 (4, 'POWER',       'Leistungsaufnahme', 'W');
INSERT INTO sensors (id, device_id, sensor_type_id, min_threshold, max_threshold, active) VALUES
 (1, 7, 1, 16,   26,   1),
 (2, 7, 2, NULL, 1500, 1),
 (3, 8, 1, 16,   26,   1),
 (4, 8, 2, NULL, 1500, 1),
 (5, 6, 4, NULL, 2500, 1);
INSERT INTO sensor_readings (id, sensor_id, value, measured_at) VALUES
 (1,  1, 20.3, '2026-10-29T10:00:00Z'),
 (2,  1, 20.5, '2026-10-29T11:00:00Z'),
 (3,  1, 20.5, '2026-10-29T12:00:00Z'),
 (4,  2, 780,  '2026-10-29T10:00:00Z'),
 (5,  2, 820,  '2026-10-29T11:00:00Z'),
 (6,  2, 860,  '2026-10-29T12:00:00Z'),
 (7,  3, 21.6, '2026-10-29T10:00:00Z'),
 (8,  3, 21.6, '2026-10-29T11:00:00Z'),
 (9,  3, 21.5, '2026-10-29T12:00:00Z'),
 (10, 4, 1330, '2026-10-29T10:00:00Z'),
 (11, 4, 1490, '2026-10-29T11:00:00Z'),
 (12, 4, 1620, '2026-10-29T12:00:00Z'),
 (13, 5, 0,    '2026-10-29T10:00:00Z'),
 (14, 5, 1650, '2026-10-29T11:00:00Z'),
 (15, 5, 0,    '2026-10-29T12:00:00Z');

-- Alarm: CO2 in Raum 1.02 liegt mit 1620 ppm mehr als 5 % über dem Grenzwert 1500 -> Stufe ALARM
INSERT INTO alarms (id, sensor_id, reading_id, room_id, level, raised_at, acknowledged_by, acknowledged_at, cleared_at) VALUES
 (1, 4, 12, 6, 'ALARM', '2026-10-29T12:00:00Z', NULL, NULL, NULL);

-- Störmeldungen (alle vier Status)
INSERT INTO tickets (id, room_id, device_id, reporter_id, assignee_id, title, description, status, priority, created_at, updated_at, closed_at) VALUES
 (1, 2, 1,    4, 3,    'Display flackert',            'Das Display zeigt nach 10 Minuten Streifen.',       'IN_PROGRESS', 'HIGH',   '2026-10-20T07:50:00Z', '2026-10-21T09:15:00Z', NULL),
 (2, 2, 1,    4, 3,    'Display schwarz',             'Bild bleibt schwarz, Ton funktioniert.',            'DONE',        'NORMAL', '2026-09-22T08:05:00Z', '2026-09-22T12:30:00Z', '2026-09-22T12:30:00Z'),
 (3, 6, 5,    4, 2,    'Lüftung ohne Funktion',       'Luft im Raum schlecht, Lüftung bleibt aus.',        'NEW',         'URGENT', '2026-10-29T10:40:00Z', '2026-10-29T10:40:00Z', NULL),
 (4, 3, 3,    2, 3,    '3D-Drucker B: Düse verstopft','Druck bricht nach dem ersten Layer ab.',            'IN_PROGRESS', 'NORMAL', '2026-10-15T13:00:00Z', '2026-10-16T08:00:00Z', NULL),
 (5, 8, NULL, 4, 2,    'Wasserschaden an der Decke',  'Wasserfleck an der Decke, Raum gesperrt.',          'IN_PROGRESS', 'URGENT', '2026-10-26T07:30:00Z', '2026-10-26T09:00:00Z', NULL),
 (6, 5, NULL, 4, 2,    'Heizung zu warm',             'Raum fühlt sich überheizt an.',                     'REJECTED',    'NORMAL', '2026-10-19T09:00:00Z', '2026-10-19T13:00:00Z', '2026-10-19T13:00:00Z');

INSERT INTO ticket_comments (id, ticket_id, author_id, text, created_at) VALUES
 (1, 1, 3, 'Verdacht auf defektes Netzteil, Ersatz bestellt.',        '2026-10-21T09:15:00Z'),
 (2, 3, 4, 'CO2-Ampel zeigt rot, Raum wurde per Fenster gelüftet.',   '2026-10-29T11:30:00Z'),
 (3, 6, 2, 'Thermostat geprüft, Werte normal. Meldung abgelehnt.',    '2026-10-19T12:55:00Z');

-- Außenwetter
INSERT INTO weather_snapshots (id, fetched_at, temperature, humidity, wind_speed, condition) VALUES
 (1, '2026-10-29T10:00:00Z', 10.2, 76, 18, 'RAIN'),
 (2, '2026-10-29T12:00:00Z', 11.0, 71, 22, 'CLOUDY');

COMMIT;
