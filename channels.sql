-- Sqlite3: https://sqlite.org/index.html
-- APRS: http://www.aprs.org/

CREATE TABLE frequency (
  id INTEGER PRIMARY KEY,
  center_hz INT NOT NULL,      -- Hz
  bandwidth_hz INT NOT NULL,   -- Hz
  modulation TEXT NOT NULL,    -- AM, USB, LSB, FM, NFM, FM
  power_milliwatts INT NULL,   -- mW or NULL to disable transmitting
  squelch_mode TEXT NULL,      -- CTCSS, DCS
  squelch_ctcss_tone INT NULL, -- 141.3 PL -> 1413

  CHECK (modulation IN (
    'CW',
    'AM', 'LSB', 'USB',
    'FM', 'NFM', 'WFM',
    'DSTAR'
  )),
  CHECK (squelch_mode IN (NULL, 'CTCSS', 'DCS'))
);

CREATE TABLE channel (
  id INTEGER PRIMARY KEY,
  label TEXT NULL,
  base_frequency_id INT NOT NULL,
  repeater_frequency_id INT,
  notes TEXT NULL,

  FOREIGN KEY (base_frequency_id) REFERENCES frequency(id),
  FOREIGN KEY (repeater_frequency_id) REFERENCES frequency(id)
);

CREATE TABLE tag (
  id INTEGER PRIMARY KEY,
  label TEXT NOT NULL,
  notes TEXT NULL
);

CREATE TABLE channel_tag (
  id INTEGER PRIMARY KEY,
  channel_id INT NOT NULL,
  tag_id INT NOT NULL,

  FOREIGN KEY (channel_id) REFERENCES channel(id),
  FOREIGN KEY (tag_id) REFERENCES tag(id),
  UNIQUE (channel_id, tag_id)
);

-- FRS
-- https://www.fcc.gov/wireless/bureau-divisions/mobility-division/family-radio-service-frs
-- https://www.radioreference.com/apps/db/?aid=7732
-- https://wiki.radioreference.com/index.php/FRS/GMRS_combined_channel_chart
-- https://en.wikipedia.org/wiki/Family_Radio_Service
INSERT INTO frequency (
  id,
  center_hz,
  bandwidth_hz,
  modulation,
  power_milliwatts
)
VALUES
  -- overlap with GMRS[1-7] with lower power and bandwidth
  (1,  trunc(462.5625 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  (2,  trunc(462.5875 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  (3,  trunc(462.6125 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  (4,  trunc(462.6375 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  (5,  trunc(462.6625 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  (6,  trunc(462.6875 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  (7,  trunc(462.7125 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),

  -- included in GMRS service as-is
  (8,  trunc(467.5625 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(0.5 * 1000)),
  (9,  trunc(467.5875 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(0.5 * 1000)),
  (10, trunc(467.6125 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(0.5 * 1000)),
  (11, trunc(467.6375 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(0.5 * 1000)),
  (12, trunc(467.6625 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(0.5 * 1000)),
  (13, trunc(467.6875 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(0.5 * 1000)),
  (14, trunc(467.7125 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(0.5 * 1000)),

  -- overlap with GMRS[15-22] with lower power and bandwidth
  (15, trunc(462.5500 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  (16, trunc(462.5750 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  (17, trunc(462.6000 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  (18, trunc(462.6250 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  (19, trunc(462.6500 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  (20, trunc(462.6750 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  (21, trunc(462.7000 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  (22, trunc(462.7250 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000))
;

INSERT INTO channel (
  label,
  base_frequency_id
)
VALUES
  -- overlap with GMRS 1-7 with lower power and bandwidth
  ('FRS1',  1),
  ('FRS2',  2),
  ('FRS3',  3),
  ('FRS4',  4),
  ('FRS5',  5),
  ('FRS6',  6),
  ('FRS7',  7),

  -- included in GMRS service as-is
  ('FRS8',  8),
  ('FRS9',  9),
  ('FRS10', 10),
  ('FRS11', 11),
  ('FRS12', 12),
  ('FRS13', 13),
  ('FRS14', 14),

  -- overlap with GMRS 15-22 with lower power and bandwidth
  ('FRS15', 15),
  ('FRS16', 16),
  ('FRS17', 17),
  ('FRS18', 18),
  ('FRS19', 19),
  ('FRS20', 20),
  ('FRS21', 21),
  ('FRS22', 22)
;

INSERT INTO tag (label, notes)
VALUES ('FRS', 'United States, Family Radio Service');

INSERT INTO channel_tag (channel_id, tag_id)
SELECT
  c.id AS channel_id,
  t.id AS tag_id
FROM channel AS c
JOIN tag AS t ON t.label = 'FRS'
WHERE c.label LIKE 'FRS%';

-- GMRS
-- https://www.fcc.gov/wireless/bureau-divisions/mobility-division/general-mobile-radio-service-gmrs
-- https://www.radioreference.com/apps/db/?inputs=1&aid=7730#cats
-- https://wiki.radioreference.com/index.php/FRS/GMRS_combined_channel_chart
-- https://en.wikipedia.org/wiki/General_Mobile_Radio_Service
INSERT INTO frequency (
  id,
  center_hz,
  bandwidth_hz,
  modulation,
  power_milliwatts
)
VALUES
  -- overlap with FRS[1-7] with higher power and bandwidth
  (23,  trunc(462.5625 * 1000 * 1000), trunc(20 * 1000), 'FM', trunc(5 * 1000)),
  (24,  trunc(462.5875 * 1000 * 1000), trunc(20 * 1000), 'FM', trunc(5 * 1000)),
  (25,  trunc(462.6125 * 1000 * 1000), trunc(20 * 1000), 'FM', trunc(5 * 1000)),
  (26,  trunc(462.6375 * 1000 * 1000), trunc(20 * 1000), 'FM', trunc(5 * 1000)),
  (27,  trunc(462.6625 * 1000 * 1000), trunc(20 * 1000), 'FM', trunc(5 * 1000)),
  (28,  trunc(462.6875 * 1000 * 1000), trunc(20 * 1000), 'FM', trunc(5 * 1000)),
  (29,  trunc(462.7125 * 1000 * 1000), trunc(20 * 1000), 'FM', trunc(5 * 1000)),

  -- overlap with FRS 15-22 with repeater inputs, higher power, and higher bandwidth
  (30, trunc(462.5500 * 1000 * 1000), trunc(20 * 1000), 'FM', trunc(50 * 1000)),
  (31, trunc(462.5750 * 1000 * 1000), trunc(20 * 1000), 'FM', trunc(50 * 1000)),
  (32, trunc(462.6000 * 1000 * 1000), trunc(20 * 1000), 'FM', trunc(50 * 1000)),
  (33, trunc(462.6250 * 1000 * 1000), trunc(20 * 1000), 'FM', trunc(50 * 1000)),
  (34, trunc(462.6500 * 1000 * 1000), trunc(20 * 1000), 'FM', trunc(50 * 1000)),
  (35, trunc(462.6750 * 1000 * 1000), trunc(20 * 1000), 'FM', trunc(50 * 1000)),
  (36, trunc(462.7000 * 1000 * 1000), trunc(20 * 1000), 'FM', trunc(50 * 1000)),
  (37, trunc(462.7250 * 1000 * 1000), trunc(20 * 1000), 'FM', trunc(50 * 1000)),

  -- GMRS 15-22 repeater inputs
  (38, trunc(467.5500 * 1000 * 1000), trunc(20 * 1000), 'FM', trunc(50 * 1000)),
  (39, trunc(467.5750 * 1000 * 1000), trunc(20 * 1000), 'FM', trunc(50 * 1000)),
  (40, trunc(467.6000 * 1000 * 1000), trunc(20 * 1000), 'FM', trunc(50 * 1000)),
  (41, trunc(467.6250 * 1000 * 1000), trunc(20 * 1000), 'FM', trunc(50 * 1000)),
  (42, trunc(467.6500 * 1000 * 1000), trunc(20 * 1000), 'FM', trunc(50 * 1000)),
  (43, trunc(467.6750 * 1000 * 1000), trunc(20 * 1000), 'FM', trunc(50 * 1000)),
  (44, trunc(467.7000 * 1000 * 1000), trunc(20 * 1000), 'FM', trunc(50 * 1000)),
  (45, trunc(467.7250 * 1000 * 1000), trunc(20 * 1000), 'FM', trunc(50 * 1000))
;

INSERT INTO channel (
  label,
  base_frequency_id,
  repeater_frequency_id
)
VALUES
  -- overlap with FRS 1-7 with higher power and bandwidth
  ('GMRS1', 23, NULL),
  ('GMRS2', 24, NULL),
  ('GMRS3', 25, NULL),
  ('GMRS4', 26, NULL),
  ('GMRS5', 27, NULL),
  ('GMRS6', 28, NULL),
  ('GMRS7', 29, NULL),

  -- overlap with FRS 15-22 with higher power and higher bandwidth
  ('GMRS15', 30, NULL),
  ('GMRS16', 31, NULL),
  ('GMRS17', 32, NULL),
  ('GMRS18', 33, NULL),
  ('GMRS19', 34, NULL),
  ('GMRS20', 35, NULL),
  ('GMRS21', 36, NULL),
  ('GMRS22', 37, NULL),

  -- overlap with FRS 15-22 with repeater inputs, higher power, and higher bandwidth
  ('GMRS15R', 30, 38),
  ('GMRS16R', 31, 39),
  ('GMRS17R', 32, 40),
  ('GMRS18R', 33, 41),
  ('GMRS19R', 34, 42),
  ('GMRS20R', 35, 43),
  ('GMRS21R', 36, 44),
  ('GMRS22R', 37, 45)
;

INSERT INTO tag (label, notes)
VALUES ('GMRS', 'United States, General Mobile Radio Service');

INSERT INTO channel_tag (channel_id, tag_id)
SELECT
  c.id AS channel_id,
  t.id AS tag_id
FROM channel AS c
JOIN tag AS t ON t.label = 'GMRS'
WHERE c.label LIKE 'GMRS%';

INSERT INTO channel_tag (channel_id, tag_id)
SELECT
  c.id AS channel_id,
  t.id AS tag_id
FROM channel AS c
JOIN tag AS t ON t.label = 'GMRS'
WHERE c.label IN (
  'FRS8',
  'FRS9',
  'FRS10',
  'FRS11',
  'FRS12',
  'FRS13',
  'FRS14'
);

-- TODO: UPDATE BELOW

-- MURS
-- https://www.fcc.gov/wireless/bureau-divisions/mobility-division/multi-use-radio-service-murs
-- https://www.radioreference.com/apps/db/?inputs=1&aid=7733#cats
-- https://en.wikipedia.org/wiki/Multi-Use_Radio_Service#Authorized_modes
-- TODO: Also allows AM w/ 8 kHz bandwidth on all channels.
INSERT INTO frequency (
  id,
  center_hz,
  bandwidth_hz,
  modulation,
  power_milliwatts
)
VALUES
  (46, trunc(151.8200 * 1000 * 1000), trunc(11.25 * 1000), 'NFM', trunc(2 * 1000)),
  (47, trunc(151.8800 * 1000 * 1000), trunc(11.25 * 1000), 'NFM', trunc(2 * 1000)),
  (48, trunc(151.9400 * 1000 * 1000), trunc(11.25 * 1000), 'NFM', trunc(2 * 1000)),
  (49, trunc(154.5700 * 1000 * 1000), trunc(20 * 1000),    'FM',  trunc(2 * 1000)),
  (50, trunc(154.6000 * 1000 * 1000), trunc(20 * 1000),    'FM',  trunc(2 * 1000))
;

INSERT INTO channel (
  label,
  base_frequency_id
)
VALUES
  ('MURS1', 46),
  ('MURS2', 47),
  ('MURS3', 48),
  ('MURS4', 49),
  ('MURS5', 50)
;

INSERT INTO tag (label, notes)
VALUES ('MURS', 'United States, Multi-Use Radio Service (ZA)');

INSERT INTO channel_tag (channel_id, tag_id)
SELECT
  c.rowid AS channel_id,
  t.rowid AS tag_id
FROM channel AS c
JOIN tag AS t ON t.label = 'MURS'
WHERE c.label LIKE 'MURS%';

-- NOAA
-- https://www.weather.gov/nwr/
-- https://en.wikipedia.org/wiki/NOAA_Weather_Radio#Radio_frequencies_used

-- XXX: 12.5 to 16 kHz bandwidth for NOAA channels
-- Section 4.3.7 in https://www.ntia.doc.gov/files/ntia/publications/manual_sept_2009.pdf

-- TODO: SAME codes
-- https://www.weather.gov/NWR/counties
-- https://www.weather.gov/nwr/nwrsame

INSERT INTO frequency (
  id,
  center_hz,
  bandwidth_hz,
  modulation
)
VALUES
  (51, trunc(162.400 * 1000 * 1000), trunc(12.5 * 1000), 'NFM'),
  (52, trunc(162.425 * 1000 * 1000), trunc(12.5 * 1000), 'NFM'),
  (53, trunc(162.450 * 1000 * 1000), trunc(12.5 * 1000), 'NFM'),
  (54, trunc(162.475 * 1000 * 1000), trunc(12.5 * 1000), 'NFM'),
  (55, trunc(162.500 * 1000 * 1000), trunc(12.5 * 1000), 'NFM'),
  (56, trunc(162.525 * 1000 * 1000), trunc(12.5 * 1000), 'NFM'),
  (57, trunc(162.550 * 1000 * 1000), trunc(12.5 * 1000), 'NFM')
;

INSERT INTO channel (
  label,
  base_frequency_id
)
VALUES
  ('NOAAW1', 51),
  ('NOAAW2', 52),
  ('NOAAW3', 53),
  ('NOAAW4', 54),
  ('NOAAW5', 55),
  ('NOAAW6', 56),
  ('NOAAW7', 57)
;

INSERT INTO tag (label, notes)
VALUES ('NOAA', 'United States, NOAA Weather Broadcast');

INSERT INTO channel_tag (channel_id, tag_id)
SELECT
  c.rowid AS channel_id,
  t.rowid AS tag_id
FROM channel AS c
JOIN tag AS t ON t.label = 'NOAA'
WHERE c.label LIKE 'NOAA%';

-- TODO: Marine Band (plus AIS)
-- https://en.wikipedia.org/wiki/Marine_VHF_radio
-- https://en.wikipedia.org/wiki/Automatic_identification_system#Technical_specification
-- https://www.navcen.uscg.gov/?pageName=AISmain
-- https://www.itu.int/rec/R-REC-M.2092

-- National Calling Frequencies
INSERT INTO frequency (
  id,
  center_hz,
  bandwidth_hz,
  modulation,
  power_milliwatts
)
VALUES
  (58, trunc(29.6000 * 1000 * 1000),  trunc(12.5 * 1000), 'FM',  1500 * 1000), -- 200 Technician
  (59, trunc(50.1250 * 1000 * 1000),  3000,               'USB', 1500 * 1000),
  (60, trunc(52.5250 * 1000 * 1000),  trunc(12.5 * 1000), 'FM',  1500 * 1000),
  (61, trunc(52.5400 * 1000 * 1000),  trunc(12.5 * 1000), 'FM',  1500 * 1000),
  (62, trunc(144.2000 * 1000 * 1000), 3000,               'USB', 1500 * 1000),
  (63, trunc(144.4100 * 1000 * 1000), trunc(12.5 * 1000), 'FM',  1500 * 1000),
  (64, trunc(146.5200 * 1000 * 1000), trunc(12.5 * 1000), 'FM',  1500 * 1000),
  (65, trunc(146.5800 * 1000 * 1000), trunc(12.5 * 1000), 'FM',  1500 * 1000),
  (66, trunc(222.100 * 1000 * 1000),  150,                'CW',  1500 * 1000),
  (67, trunc(222.100 * 1000 * 1000),  3000,               'USB', 1500 * 1000),
  (68, trunc(223.500 * 1000 * 1000),  trunc(12.5 * 1000), 'FM',  1500 * 1000),
  (69, trunc(432.100 * 1000 * 1000),  3000,               'USB', 1500 * 1000),
  (70, trunc(446.000 * 1000 * 1000),  trunc(12.5 * 1000), 'FM',  1500 * 1000),
  (71, trunc(902.100 * 1000 * 1000),  3000,               'USB', 1500 * 1000), -- XXX: and CW
  (72, trunc(927.500 * 1000 * 1000),  trunc(12.5 * 1000), 'FM',  1500 * 1000),
  (73, trunc(1294.5 * 1000 * 1000),   trunc(12.5 * 1000), 'FM',  1500 * 1000),
  (74, trunc(1296.1 * 1000 * 1000),   3000,               'USB', 1500 * 1000),
  (75, trunc(2304.1 * 1000 * 1000),   3000,               'USB', 1500 * 1000),
  (76, trunc(2305.2 * 1000 * 1000),   trunc(12.5 * 1000), 'FM',  1500 * 1000)
;

INSERT INTO channel (
  label,
  base_frequency_id,
  notes
)
VALUES
  ('HAC10M',   58, NULL),
  ('HAC6M1',   59, NULL),
  ('HAC6M2',   60, 'Primary'),
  ('HAC6M3',   61, 'Secondary'),
  ('HAC2M1',   62, NULL),
  ('HASOTA',   63, 'US Summits On The Air'),
  ('HAC2M1',   64, NULL),
  ('HACALT',   65, 'North American Adventure'),
  ('HAC125M1', 66, NULL),
  ('HAC125M2', 67, NULL),
  ('HAC125M3', 68, NULL),
  ('HAC70CM1', 69, NULL),
  ('HAC70CM2', 70, NULL),
  ('HAC33CM1', 71, NULL), -- XXX: and CW
  ('HAC33CM2', 72, NULL),
  ('HAC23CM1', 73, NULL),
  ('HAC23CM2', 74, NULL),
  ('HAC13CM1', 75, NULL),
  ('HAC13CM2', 76, NULL)
;

INSERT INTO tag (label, notes)
VALUES ('NATCALL', 'US, National Channels, Amateur Radio Service (HA)');

INSERT INTO channel_tag (channel_id, tag_id)
SELECT
  c.rowid AS channel_id,
  t.rowid AS tag_id
FROM channel AS c
JOIN tag AS t ON t.label = 'NATCALL'
WHERE c.label LIKE 'HAC%';

-- Central Ohio Radio Club
-- http://www.corc.us/
-- http://www.corc.us/CORC%20Repeater%20Info%20by%20Location-11-21-2020.pdf
-- http://www.corc.us/CORC%20ALL%20Sites%207-2014.pdf
INSERT INTO frequency (
  id,
  center_hz,
  bandwidth_hz,
  modulation,
  power_milliwatts,
  squelch_mode,
  squelch_ctcss_tone -- 141.3 PL -> 1413
)
VALUES
  -- W8RRJ 6M
  (77, trunc(52.7000 * 1000 * 1000), trunc(11.25 * 1000), 'NFM', trunc(200 * 1000), NULL, NULL),
  (78, trunc(52.9400 * 1000 * 1000), trunc(11.25 * 1000), 'NFM', trunc(200 * 1000), NULL, NULL),
  (79, trunc(53.7000 * 1000 * 1000), trunc(11.25 * 1000), 'NFM', trunc(200 * 1000), NULL, NULL),
  (80, trunc(51.7000 * 1000 * 1000), trunc(11.25 * 1000), 'NFM', trunc(200 * 1000), NULL, NULL),

  -- W8CMH D-STAR
  (81, trunc(145.490 * 1000 * 1000), trunc(11.25 * 1000), 'DSTAR', trunc(1500 * 1000), NULL, NULL),
  (82, trunc(144.890 * 1000 * 1000), trunc(11.25 * 1000), 'DSTAR', trunc(1500 * 1000), NULL, NULL),

  -- W8AIC 2M (123.0 PL)
  (83, trunc(146.760 * 1000 * 1000), trunc(11.25 * 1000), 'NFM', trunc(1500 * 1000), 'CTCSS', 1230),
  (84, trunc(146.160 * 1000 * 1000), trunc(11.25 * 1000), 'NFM', trunc(1500 * 1000), 'CTCSS', 1230),

  -- W8RRJ 2M (123.0 PL)
  (85, trunc(146.970 * 1000 * 1000), trunc(11.25 * 1000), 'NFM', trunc(1500 * 1000), 'CTCSS', 1230),
  (86, trunc(146.370 * 1000 * 1000), trunc(11.25 * 1000), 'NFM', trunc(1500 * 1000), 'CTCSS', 1230),

  -- W8NBA 2M (123.0 PL)
  (87, trunc(147.330 * 1000 * 1000), trunc(11.25 * 1000), 'NFM', trunc(1500 * 1000), 'CTCSS', 1230),
  (88, trunc(147.930 * 1000 * 1000), trunc(11.25 * 1000), 'NFM', trunc(1500 * 1000), 'CTCSS', 1230),

  -- W8CMH D-STAR
  (89, trunc(444.000 * 1000 * 1000), trunc(11.25 * 1000), 'DSTAR', trunc(1500 * 1000), NULL, NULL),
  (90, trunc(449.000 * 1000 * 1000), trunc(11.25 * 1000), 'DSTAR', trunc(1500 * 1000), NULL, NULL),

  -- W8AIC 70CM (151.4 PL)
  (91, trunc(444.200 * 1000 * 1000), trunc(11.25 * 1000), 'NFM', trunc(1500 * 1000), 'CTCSS', 1514),
  (92, trunc(449.200 * 1000 * 1000), trunc(11.25 * 1000), 'NFM', trunc(1500 * 1000), 'CTCSS', 1514)
;

INSERT INTO channel (
  label,
  base_frequency_id,
  repeater_frequency_id
)
VALUES
  ('W8RRJ1', 77, 78),
  ('W8RRJ2', 77, 79),
  ('W8RRJ3', 77, 80),
  ('W8CMH1', 81, 82),
  ('W8AIC1', 83, 84),
  ('W8RRJ4', 85, 86),
  ('W8NBA',  87, 88),
  ('W8CMH2', 89, 90),
  ('W8AIC2', 91, 92)
;

INSERT INTO tag (label, notes)
VALUES ('CORC', 'United States, Ohio, Central Ohio Radio Club');

INSERT INTO channel_tag (channel_id, tag_id)
SELECT
  c.rowid AS channel_id,
  t.rowid AS tag_id
FROM channel AS c
JOIN tag AS t ON t.label = 'CORC'
WHERE c.label IN (
  'W8RRJ1',
  'W8RRJ2',
  'W8RRJ3',
  'W8CMH1',
  'W8AIC1',
  'W8RRJ4',
  'W8NBA',
  'W8CMH2',
  'W8AIC2'
);
