-- Smart School Service Hub - Datenbankschema (SQLite)
-- Konventionen: snake_case, Tabellen im Plural, PK "id", FK "<tabelle>_id".
-- Zeitstempel in UTC (ISO-8601). Der Raumstatus wird nicht gespeichert,
-- sondern in der View v_room_status berechnet.

PRAGMA foreign_keys = ON;

-- Benutzer (Soft-Delete über active)
CREATE TABLE users (
    id             INTEGER PRIMARY KEY AUTOINCREMENT,
    username       VARCHAR(50)  NOT NULL,
    display_name   VARCHAR(100) NOT NULL,
    password_hash  VARCHAR(255) NOT NULL,            -- z. B. bcrypt/PBKDF2, nie Klartext
    role           VARCHAR(20)  NOT NULL,
    locale         VARCHAR(5)   NOT NULL DEFAULT 'de',
    active         SMALLINT     NOT NULL DEFAULT 1,
    CONSTRAINT uq_users_username UNIQUE (username),
    CONSTRAINT ck_users_role   CHECK (role IN ('TEACHER','CARETAKER','IT','ADMIN')),
    CONSTRAINT ck_users_locale CHECK (locale IN ('de','en')),
    CONSTRAINT ck_users_active CHECK (active IN (0,1))
);

-- Gebäude -> Geschoss -> Raum
CREATE TABLE buildings (
    id    INTEGER PRIMARY KEY AUTOINCREMENT,
    name  VARCHAR(100) NOT NULL,
    CONSTRAINT uq_buildings_name UNIQUE (name)
);

CREATE TABLE floors (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    building_id  INTEGER      NOT NULL,
    level        INTEGER      NOT NULL,              -- 0 = EG, -1 = UG, 1 = 1. OG ...
    name         VARCHAR(50)  NOT NULL,
    CONSTRAINT fk_floors_building FOREIGN KEY (building_id) REFERENCES buildings (id),
    CONSTRAINT uq_floors_building_level UNIQUE (building_id, level)
);

CREATE TABLE rooms (
    id               INTEGER PRIMARY KEY AUTOINCREMENT,
    floor_id         INTEGER      NOT NULL,
    number           VARCHAR(20)  NOT NULL,          -- Raumnummer, z. B. 'E.04'
    name             VARCHAR(100) NOT NULL,
    type             VARCHAR(30)  NOT NULL DEFAULT 'CLASSROOM',
    capacity         INTEGER,
    out_of_order     SMALLINT     NOT NULL DEFAULT 0, -- manuell gesetzt (gesperrt) -> Status OUT_OF_ORDER
    active           SMALLINT     NOT NULL DEFAULT 1, -- Soft-Delete
    CONSTRAINT fk_rooms_floor FOREIGN KEY (floor_id) REFERENCES floors (id),
    CONSTRAINT uq_rooms_floor_number UNIQUE (floor_id, number),
    CONSTRAINT ck_rooms_type CHECK (type IN ('CLASSROOM','LAB','WORKSHOP','SERVER_ROOM','OFFICE','CORRIDOR','OTHER')),
    CONSTRAINT ck_rooms_capacity CHECK (capacity IS NULL OR capacity >= 0),
    CONSTRAINT ck_rooms_ooo CHECK (out_of_order IN (0,1)),
    CONSTRAINT ck_rooms_active CHECK (active IN (0,1))
);

-- Gerätetypen als Tabelle: neue Typen ohne Codeänderung
CREATE TABLE device_types (
    id    INTEGER PRIMARY KEY AUTOINCREMENT,
    code  VARCHAR(30)  NOT NULL,                     -- z. B. 'DISPLAY'
    name  VARCHAR(100) NOT NULL,
    CONSTRAINT uq_device_types_code UNIQUE (code)
);

CREATE TABLE devices (
    id               INTEGER PRIMARY KEY AUTOINCREMENT,
    room_id          INTEGER      NOT NULL,
    device_type_id   INTEGER      NOT NULL,
    name             VARCHAR(100) NOT NULL,
    serial_number    VARCHAR(100),
    status           VARCHAR(20)  NOT NULL DEFAULT 'ONLINE',
    installed_at     DATETIME,
    active           SMALLINT     NOT NULL DEFAULT 1,  -- Soft-Delete (Historie bleibt)
    CONSTRAINT fk_devices_room FOREIGN KEY (room_id) REFERENCES rooms (id),
    CONSTRAINT fk_devices_type FOREIGN KEY (device_type_id) REFERENCES device_types (id),
    CONSTRAINT uq_devices_serial UNIQUE (serial_number),   -- mehrere NULL erlaubt
    CONSTRAINT ck_devices_status CHECK (status IN ('ONLINE','OFFLINE','FAULTY','MAINTENANCE')),
    CONSTRAINT ck_devices_active CHECK (active IN (0,1))
);
CREATE INDEX ix_devices_room ON devices (room_id);
CREATE INDEX ix_devices_type ON devices (device_type_id);

-- Sensorik
CREATE TABLE sensor_types (
    id    INTEGER PRIMARY KEY AUTOINCREMENT,
    code  VARCHAR(30)  NOT NULL,                     -- TEMPERATURE, CO2, HUMIDITY, POWER
    name  VARCHAR(100) NOT NULL,
    unit  VARCHAR(10)  NOT NULL,                     -- °C, ppm, %, W
    CONSTRAINT uq_sensor_types_code UNIQUE (code)
);

CREATE TABLE sensors (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    device_id       INTEGER NOT NULL,                -- physisches Gerät, an dem der Sensor hängt
    sensor_type_id  INTEGER NOT NULL,
    min_threshold   DECIMAL(10,3),                   -- NULL = kein Grenzwert
    max_threshold   DECIMAL(10,3),
    active          SMALLINT NOT NULL DEFAULT 1,
    CONSTRAINT fk_sensors_device FOREIGN KEY (device_id) REFERENCES devices (id),
    CONSTRAINT fk_sensors_type   FOREIGN KEY (sensor_type_id) REFERENCES sensor_types (id),
    CONSTRAINT ck_sensors_thresholds CHECK (min_threshold IS NULL OR max_threshold IS NULL OR min_threshold <= max_threshold),
    CONSTRAINT ck_sensors_active CHECK (active IN (0,1))
);
CREATE INDEX ix_sensors_device ON sensors (device_id);

-- Messwerte (Massendaten)
CREATE TABLE sensor_readings (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    sensor_id    INTEGER       NOT NULL,
    value        DECIMAL(12,3) NOT NULL,
    measured_at  DATETIME      NOT NULL,             -- UTC
    CONSTRAINT fk_readings_sensor FOREIGN KEY (sensor_id) REFERENCES sensors (id),
    CONSTRAINT uq_readings_sensor_time UNIQUE (sensor_id, measured_at)  -- Idempotenz + Index
);
-- Absteigender Index für "letzter Messwert je Sensor".
CREATE INDEX ix_readings_sensor_time_desc ON sensor_readings (sensor_id, measured_at DESC);

-- Störmeldungen
CREATE TABLE tickets (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    room_id      INTEGER      NOT NULL,
    device_id    INTEGER,                            -- optional: Meldung nur zum Raum
    reporter_id  INTEGER      NOT NULL,
    assignee_id  INTEGER,
    title        VARCHAR(150) NOT NULL,
    description  VARCHAR(2000),
    status       VARCHAR(20)  NOT NULL DEFAULT 'NEW',
    priority     VARCHAR(20)  NOT NULL DEFAULT 'NORMAL',
    created_at   DATETIME     NOT NULL,
    updated_at   DATETIME     NOT NULL,
    closed_at    DATETIME,
    CONSTRAINT fk_tickets_room     FOREIGN KEY (room_id)     REFERENCES rooms (id),
    CONSTRAINT fk_tickets_device   FOREIGN KEY (device_id)   REFERENCES devices (id),
    CONSTRAINT fk_tickets_reporter FOREIGN KEY (reporter_id) REFERENCES users (id),
    CONSTRAINT fk_tickets_assignee FOREIGN KEY (assignee_id) REFERENCES users (id),
    CONSTRAINT ck_tickets_status   CHECK (status IN ('NEW','IN_PROGRESS','DONE','REJECTED')),
    CONSTRAINT ck_tickets_priority CHECK (priority IN ('LOW','NORMAL','HIGH','URGENT')),
    -- closed_at ist nur bei abgeschlossenen Meldungen (DONE/REJECTED) gesetzt.
    -- Die erlaubten Statusübergänge prüft der TicketService, nicht die DB.
    CONSTRAINT ck_tickets_closed CHECK (
        (status IN ('DONE','REJECTED') AND closed_at IS NOT NULL) OR
        (status IN ('NEW','IN_PROGRESS') AND closed_at IS NULL)),
    CONSTRAINT ck_tickets_dates CHECK (updated_at >= created_at),
    -- Längenlimits per CHECK, da SQLite VARCHAR(n) nicht erzwingt.
    CONSTRAINT ck_tickets_title_len CHECK (length(trim(title)) BETWEEN 1 AND 150),
    CONSTRAINT ck_tickets_desc_len  CHECK (description IS NULL OR length(description) <= 2000)
);
CREATE INDEX ix_tickets_room_created ON tickets (room_id, created_at);
CREATE INDEX ix_tickets_device       ON tickets (device_id);
CREATE INDEX ix_tickets_status       ON tickets (status);
CREATE INDEX ix_tickets_reporter     ON tickets (reporter_id);
CREATE INDEX ix_tickets_assignee     ON tickets (assignee_id);

CREATE TABLE ticket_comments (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    ticket_id   INTEGER      NOT NULL,
    author_id   INTEGER      NOT NULL,
    text        VARCHAR(2000) NOT NULL,
    created_at  DATETIME     NOT NULL,
    CONSTRAINT ck_comments_text_len CHECK (length(trim(text)) BETWEEN 1 AND 2000),
    CONSTRAINT fk_comments_ticket FOREIGN KEY (ticket_id) REFERENCES tickets (id) ON DELETE CASCADE,
    CONSTRAINT fk_comments_author FOREIGN KEY (author_id) REFERENCES users (id)
);
CREATE INDEX ix_comments_ticket ON ticket_comments (ticket_id, created_at);

-- Alarme (room_id bewusst redundant gespeichert: schneller Zugriff fürs Dashboard)
CREATE TABLE alarms (
    id               INTEGER PRIMARY KEY AUTOINCREMENT,
    sensor_id        INTEGER     NOT NULL,
    reading_id       INTEGER     NOT NULL,           -- auslösender Messwert
    room_id          INTEGER     NOT NULL,
    level            VARCHAR(10) NOT NULL,
    raised_at        DATETIME    NOT NULL,
    acknowledged_by  INTEGER,
    acknowledged_at  DATETIME,
    cleared_at       DATETIME,                       -- NULL = Alarm noch aktiv
    CONSTRAINT fk_alarms_sensor  FOREIGN KEY (sensor_id)  REFERENCES sensors (id),
    CONSTRAINT fk_alarms_reading FOREIGN KEY (reading_id) REFERENCES sensor_readings (id),
    CONSTRAINT fk_alarms_room    FOREIGN KEY (room_id)    REFERENCES rooms (id),
    CONSTRAINT fk_alarms_ack_by  FOREIGN KEY (acknowledged_by) REFERENCES users (id),
    CONSTRAINT ck_alarms_level CHECK (level IN ('WARNING','ALARM')),
    CONSTRAINT ck_alarms_ack CHECK ((acknowledged_by IS NULL) = (acknowledged_at IS NULL)),
    CONSTRAINT ck_alarms_cleared CHECK (cleared_at IS NULL OR cleared_at >= raised_at),
    CONSTRAINT uq_alarms_reading UNIQUE (reading_id)   -- ein Messwert löst höchstens einen Alarm(-Level) aus
);
-- Je Sensor höchstens ein aktiver Alarm (partieller Unique-Index).
CREATE UNIQUE INDEX ux_alarms_one_active_per_sensor ON alarms (sensor_id) WHERE cleared_at IS NULL;
CREATE INDEX ix_alarms_room_active ON alarms (room_id, cleared_at);
CREATE INDEX ix_alarms_sensor      ON alarms (sensor_id, raised_at);

-- Außenwetter fürs Dashboard (nur lesend)
CREATE TABLE weather_snapshots (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    fetched_at   DATETIME     NOT NULL,
    temperature  DECIMAL(5,2) NOT NULL,              -- °C
    humidity     DECIMAL(5,2),                       -- % relative Feuchte
    wind_speed   DECIMAL(5,2),                       -- km/h
    condition    VARCHAR(10)  NOT NULL,
    CONSTRAINT uq_weather_fetched UNIQUE (fetched_at),
    CONSTRAINT ck_weather_humidity CHECK (humidity IS NULL OR (humidity BETWEEN 0 AND 100)),
    CONSTRAINT ck_weather_condition CHECK (condition IN ('SUNNY','CLOUDY','RAIN','STORM','SNOW','FOG'))
);

-- View: abgeleiteter Raumstatus, Priorität von oben nach unten:
--   OUT_OF_ORDER = Raum manuell gesperrt, ALARM = aktiver Alarm der Stufe ALARM,
--   WARNING = aktiver Alarm WARNING oder offene Meldung HIGH/URGENT,
--   UNKNOWN = kein aktiver Sensor im Raum, sonst OK.
CREATE VIEW v_room_status AS
SELECT r.id AS room_id,
       CASE
         WHEN r.out_of_order = 1 THEN 'OUT_OF_ORDER'
         WHEN EXISTS (SELECT 1 FROM alarms a WHERE a.room_id = r.id AND a.cleared_at IS NULL AND a.level = 'ALARM')
              THEN 'ALARM'
         WHEN EXISTS (SELECT 1 FROM alarms a WHERE a.room_id = r.id AND a.cleared_at IS NULL AND a.level = 'WARNING')
           OR EXISTS (SELECT 1 FROM tickets t WHERE t.room_id = r.id AND t.status IN ('NEW','IN_PROGRESS') AND t.priority IN ('HIGH','URGENT'))
              THEN 'WARNING'
         WHEN NOT EXISTS (SELECT 1 FROM sensors s JOIN devices d ON d.id = s.device_id
                          WHERE d.room_id = r.id AND s.active = 1 AND d.active = 1)
              THEN 'UNKNOWN'
         ELSE 'OK'
       END AS status
FROM rooms r
WHERE r.active = 1;
