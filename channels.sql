-- Sqlite3: https://sqlite.org/index.html
-- APRS: http://www.aprs.org/

CREATE TABLE channel (
  label TEXT NULL,
  frequency_base_hz INT NOT NULL,  -- Hz
  frequency_repeater_hz INT NULL,  -- Hz
  bandwidth_hz INT NOT NULL,       -- Hz
  mode TEXT NOT NULL,              -- AM, USB, LSB, FM, NFM
  power_milliwatts INT NOT NULL,   -- mW
  squelch_mode TEXT NULL,          -- CTCSS, DCS
  squelch_ctcss_tone INT NULL,     -- 141.3 PL -> 1413
  notes TEXT NULL
);

CREATE TABLE tag (
  label TEXT NOT NULL,
  notes TEXT NULL
);

CREATE TABLE channel_tag (
  channel_id INT NOT NULL,
  tag_id INT NOT NULL
);

-- FRS
-- https://www.fcc.gov/wireless/bureau-divisions/mobility-division/family-radio-service-frs
-- https://www.radioreference.com/apps/db/?aid=7732
-- https://wiki.radioreference.com/index.php/FRS/GMRS_combined_channel_chart
-- https://en.wikipedia.org/wiki/Family_Radio_Service
INSERT INTO channel (
  label,
  frequency_base_hz,
  bandwidth_hz,
  mode,
  power_milliwatts
)
VALUES
  -- overlap with GMRS[1-7] with lower power and bandwidth
  ('FRS1',  trunc(462.5625 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  ('FRS2',  trunc(462.5875 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  ('FRS3',  trunc(462.6125 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  ('FRS4',  trunc(462.6375 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  ('FRS5',  trunc(462.6625 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  ('FRS6',  trunc(462.6875 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  ('FRS7',  trunc(462.7125 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),

  -- included in GMRS service as-is
  ('FRS8',  trunc(467.5625 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(0.5 * 1000)),
  ('FRS9',  trunc(467.5875 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(0.5 * 1000)),
  ('FRS10', trunc(467.6125 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(0.5 * 1000)),
  ('FRS11', trunc(467.6375 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(0.5 * 1000)),
  ('FRS12', trunc(467.6625 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(0.5 * 1000)),
  ('FRS13', trunc(467.6875 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(0.5 * 1000)),
  ('FRS14', trunc(467.7125 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(0.5 * 1000)),

  -- overlap with GMRS[15-22] with lower power and bandwidth
  ('FRS15', trunc(462.5500 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  ('FRS16', trunc(462.5750 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  ('FRS17', trunc(462.6000 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  ('FRS18', trunc(462.6250 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  ('FRS19', trunc(462.6500 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  ('FRS20', trunc(462.6750 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  ('FRS21', trunc(462.7000 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000)),
  ('FRS22', trunc(462.7250 * 1000 * 1000), trunc(12.5 * 1000), 'NFM', trunc(2 * 1000))
;

INSERT INTO tag (label, notes)
VALUES ('FRS', 'United States, Family Radio Service');

INSERT INTO channel_tag (channel_id, tag_id)
SELECT
  c.rowid AS channel_id,
  t.rowid AS tag_id
FROM channel AS c
JOIN tag AS t ON t.label = 'FRS'
WHERE c.label LIKE 'FRS%';

-- GMRS
-- https://www.fcc.gov/wireless/bureau-divisions/mobility-division/general-mobile-radio-service-gmrs
-- https://www.radioreference.com/apps/db/?inputs=1&aid=7730#cats
-- https://wiki.radioreference.com/index.php/FRS/GMRS_combined_channel_chart
-- https://en.wikipedia.org/wiki/General_Mobile_Radio_Service
INSERT INTO channel (
  label,
  frequency_base_hz,
  frequency_repeater_hz,
  bandwidth_hz,
  mode,
  power_milliwatts
)
VALUES
  -- overlap with FRS[1-7] with higher power and bandwidth
  ('GMRS1',  trunc(462.5625 * 1000 * 1000), NULL, trunc(20 * 1000), 'NFM', trunc(5 * 1000)),
  ('GMRS2',  trunc(462.5875 * 1000 * 1000), NULL, trunc(20 * 1000), 'NFM', trunc(5 * 1000)),
  ('GMRS3',  trunc(462.6125 * 1000 * 1000), NULL, trunc(20 * 1000), 'NFM', trunc(5 * 1000)),
  ('GMRS4',  trunc(462.6375 * 1000 * 1000), NULL, trunc(20 * 1000), 'NFM', trunc(5 * 1000)),
  ('GMRS5',  trunc(462.6625 * 1000 * 1000), NULL, trunc(20 * 1000), 'NFM', trunc(5 * 1000)),
  ('GMRS6',  trunc(462.6875 * 1000 * 1000), NULL, trunc(20 * 1000), 'NFM', trunc(5 * 1000)),
  ('GMRS7',  trunc(462.7125 * 1000 * 1000), NULL, trunc(20 * 1000), 'NFM', trunc(5 * 1000)),

  -- overlap with FRS[15-22] with repeater inputs, higher power, and higher bandwidth
  ('GMRS15', trunc(462.5500 * 1000 * 1000), trunc(467.5500 * 1000 * 1000), trunc(20 * 1000), 'NFM', trunc(50 * 1000)),
  ('GMRS16', trunc(462.5750 * 1000 * 1000), trunc(467.5750 * 1000 * 1000), trunc(20 * 1000), 'NFM', trunc(50 * 1000)),
  ('GMRS17', trunc(462.6000 * 1000 * 1000), trunc(467.6000 * 1000 * 1000), trunc(20 * 1000), 'NFM', trunc(50 * 1000)),
  ('GMRS18', trunc(462.6250 * 1000 * 1000), trunc(467.6250 * 1000 * 1000), trunc(20 * 1000), 'NFM', trunc(50 * 1000)),
  ('GMRS19', trunc(462.6500 * 1000 * 1000), trunc(467.6500 * 1000 * 1000), trunc(20 * 1000), 'NFM', trunc(50 * 1000)),
  ('GMRS20', trunc(462.6750 * 1000 * 1000), trunc(467.6750 * 1000 * 1000), trunc(20 * 1000), 'NFM', trunc(50 * 1000)),
  ('GMRS21', trunc(462.7000 * 1000 * 1000), trunc(467.7000 * 1000 * 1000), trunc(20 * 1000), 'NFM', trunc(50 * 1000)),
  ('GMRS22', trunc(462.7250 * 1000 * 1000), trunc(467.7250 * 1000 * 1000), trunc(20 * 1000), 'NFM', trunc(50 * 1000))
;

INSERT INTO tag (label, notes)
VALUES ('GMRS', 'United States, General Mobile Radio Service');

INSERT INTO channel_tag (channel_id, tag_id)
SELECT
  c.rowid AS channel_id,
  t.rowid AS tag_id
FROM channel AS c
JOIN tag AS t ON t.label = 'GMRS'
WHERE c.label LIKE 'FRS%';

INSERT INTO channel_tag (channel_id, tag_id)
SELECT
  c.rowid AS channel_id,
  t.rowid AS tag_id
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

-- MURS
-- https://www.fcc.gov/wireless/bureau-divisions/mobility-division/multi-use-radio-service-murs
-- https://www.radioreference.com/apps/db/?inputs=1&aid=7733#cats
-- https://en.wikipedia.org/wiki/Multi-Use_Radio_Service#Authorized_modes
-- TODO: Also allows AM w/ 8 kHz bandwidth on all channels.
INSERT INTO channel (
  label,
  frequency_base_hz,
  bandwidth_hz,
  mode,
  power_milliwatts
)
VALUES
  ('MURS1', trunc(151.8200 * 1000 * 1000), trunc(11.25 * 1000), 'NFM', trunc(2 * 1000)),
  ('MURS2', trunc(151.8800 * 1000 * 1000), trunc(11.25 * 1000), 'NFM', trunc(2 * 1000)),
  ('MURS3', trunc(151.9400 * 1000 * 1000), trunc(11.25 * 1000), 'NFM', trunc(2 * 1000)),
  ('MURS4', trunc(154.5700 * 1000 * 1000), trunc(20 * 1000),    'FM', trunc(2 * 1000)),
  ('MURS5', trunc(154.6000 * 1000 * 1000), trunc(20 * 1000),    'FM', trunc(2 * 1000))
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

-- National Calling Frequencies
INSERT INTO channel (
  label,
  frequency_base_hz,
  bandwidth_hz,
  mode,
  power_milliwatts,
  notes
)
VALUES
  -- ('HAC10M', trunc(29.6000 * 1000 * 1000), trunc(???), 'FM', trunc(???)),
  -- ('HAC6M1', trunc(50.1250 * 1000 * 1000), trunc(???), 'USB', trunc(???)),
  -- ('HAC6M2', trunc(52.5250 * 1000 * 1000), trunc(???), 'FM', trunc(???)), -- Primary
  -- ('HAC6M3', trunc(52.5400 * 1000 * 1000), trunc(???), 'FM', trunc(???)), -- Secondary
  ('HAC2M1',   trunc(144.2000 * 1000 * 1000), 3000,               'USB',  1500, NULL),
  ('HAAPRS',   trunc(144.3900 * 1000 * 1000), trunc(10 * 1000),   'APRS', 1500, 'APRS'), -- XXX: CTCSS 100
  ('HASOTA',   trunc(144.4100 * 1000 * 1000), trunc(12.5 * 1000), 'FM',   1500, 'US Summits On The Air'),
  ('HAC2M1',   trunc(146.5200 * 1000 * 1000), trunc(12.5 * 1000), 'FM',   1500, NULL),
  ('HACALT',   trunc(146.5800 * 1000 * 1000), trunc(12.5 * 1000), 'FM',   1500, 'North American Adventure'),
  ('HAC125M1', trunc(222.100 * 1000 * 1000),  150,                'CW',   1500, NULL),
  ('HAC125M2', trunc(222.100 * 1000 * 1000),  3000,               'USB',  1500, NULL),
  ('HAC125M3', trunc(223.500 * 1000 * 1000),  trunc(12.5 * 1000), 'FM',   1500, NULL),
  ('HAC70CM1', trunc(432.100 * 1000 * 1000),  3000,               'USB',  1500, NULL),
  ('HAC70CM2', trunc(446.000 * 1000 * 1000),  trunc(12.5 * 1000), 'FM',   1500, NULL)
  -- ('HAC33CM1', trunc(902.100 * 1000 * 1000), trunc(???), 'USB', trunc(???)), -- XXX: and CW
  -- ('HAC33CM2', trunc(927.500 * 1000 * 1000), trunc(???), 'FM', trunc(???)),
  -- ('HAC23CM1', trunc(1294.5 * 1000 * 1000), trunc(???), 'FM', trunc(???)),
  -- ('HAC23CM2', trunc(1296.1 * 1000 * 1000), trunc(???), 'USB', trunc(???)),
  -- ('HAC13CM1', trunc(2304.1 * 1000 * 1000), trunc(???), 'USB', trunc(???)),
  -- ('HAC13CM2', trunc(2305.2 * 1000 * 1000), trunc(???), 'FM', trunc(???))
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
