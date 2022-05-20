#!/usr/bin/env python

import csv
import sqlite3
import argparse
from pathlib import Path


def load_database():
    channels_file_path = Path(__file__).parent / 'channels.sql'
    connection = sqlite3.connect(':memory:')
    connection.row_factory = sqlite3.Row

    with connection:
        cursor = connection.cursor()
        with open(channels_file_path, 'r') as channels_file:
            cursor.executescript(channels_file.read())

    return connection


def hz_to_mhz(value):
    return round(float(value) / pow(10, 6), 4)


SELECT_CHANNELS = """
SELECT
    c.label AS label,
    c.notes AS notes,

    bf.center_hz AS          base_frequency_hz,
    bf.bandwidth_hz AS       base_bandwidth_hz,
    bf.modulation AS         base_modulation,
    bf.power_milliwatts AS   base_power_milliwatts,
    bf.squelch_mode AS       base_squelch_mode,
    bf.squelch_ctcss_tone AS base_squelch_ctcss_tone,

    rf.center_hz AS          repeater_frequency_hz,
    rf.bandwidth_hz AS       repeater_bandwidth_hz,
    rf.modulation AS         repeater_modulation,
    rf.power_milliwatts AS   repeater_power_milliwatts,
    rf.squelch_mode AS       repeater_squelch_mode,
    rf.squelch_ctcss_tone AS repeater_squelch_ctcss_tone
FROM channel AS c
INNER JOIN frequency AS bf ON c.base_frequency_id = bf.id
LEFT JOIN frequency AS rf ON c.repeater_frequency_id = rf.id
WHERE
    base_frequency_hz >= (88 * 1000 * 1000) AND
    base_frequency_hz <= (480 * 1000 * 1000);
"""


CHIRP_FIELDS = [
    'Location',     # Channel Number (1-based)
    'Name',
    'Frequency',    # MHz
    'Duplex',       # "", "+", "-", "split"
    'Offset',       # MHz Repeater Offset or Frequency
    'Tone',         # "Tone", "TSQL", "DTCS", "Cross"
    'rToneFreq',    # 110.9 (?)
    'cToneFreq',    # 110.9 (?)
    'DtcsCode',     # 023
    'DtcsPolarity', # NN
    'Mode',         # FM
    'TStep',
    'Skip',
    'Comment',
    'URCALL',
    'RPT1CALL',
    'RPT2CALL',
    'DVCODE'
]


def main():
    # parse command line arguments
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-o', '--output-file',
        type=argparse.FileType('w'),
        required=True,
        help="output file")
    
    args = parser.parse_args()

    # XXX
    connection = load_database()

    # open the output file
    sink = csv.DictWriter(
        args.output_file,
        fieldnames=CHIRP_FIELDS,
        delimiter=",",
        quotechar="\"")

    sink.writeheader()

    # XXX
    cursor = connection.execute(SELECT_CHANNELS)
    for index, row in enumerate(cursor):
        record = {
            'Location': str(index + 1),
            'Name': row['label'],
            'Comment': row['notes'],
            'Frequency': hz_to_mhz(row['base_frequency_hz']),
            'Mode': row['base_modulation'],
            'Duplex': '',
            'Offset': '0.0',
            'rToneFreq': '88.5',
            'cToneFreq': '88.5',
            'DtcsCode': '023',
            'DtcsPolarity': 'NN',
            'TStep': '5.0'
        }

        if row['repeater_frequency_hz']:
            if row['base_modulation'] != row['repeater_modulation']:
                raise RuntimeError("Channel frequencies use different modulations")

            if row['base_bandwidth_hz'] != row['repeater_bandwidth_hz']:
                raise RuntimeError("Channel frequencies use different bandwidths")

            record.update({
                'Duplex': '+' if row['repeater_frequency_hz'] >= row['base_frequency_hz'] else '-',
                'Offset': hz_to_mhz(row['repeater_frequency_hz'] - row['base_frequency_hz'])
            })

        sink.writerow(record)

    cursor.close()
    connection.close()


if __name__ == '__main__':
    main()
