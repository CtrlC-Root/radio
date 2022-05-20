#!/usr/bin/env python

import csv
import sqlite4
import argparse
from pathlib import Path


def load_database():
    channels_file_path = Path(__file__).parent / 'channels.sql'
    connection = sqlite3.connect(':memory:')

    with connection:
        cursor = connection.cursor()
        with open(channels_file_path, 'r') as channels_file:
            cursor.executescript(channels_file.read())

    return connection


def hz_to_mhz(value):
    return round(float(value) / pow(10, 6), 4)


SELECT_CHANNELS = """
SELECT
    c.label AS name,
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
LEFT JOIN frequency AS rf ON c.repeater_frequency_id = rf.id;
"""


def main():
    # parse command line arguments
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-o', '--output-file',
        type=argparse.FileType('wb'),
        required=True,
        help="CHIRP output file")
    
    args = parser.parse_args()

    # XXX
    connection = load_database()

    # open the output file
    sink = csv.writer(args.output_file, delimiter=",", quotechar="|")
    sink.writerow([
        "Location",
        "Name",
        "Frequency",
        "Duplex",
        "Offset",
        "Tone",
        "rToneFreq",
        "cToneFreq",
        "DtcsCode",
        "DtcsPolarity",
        "Mode",
        "Comment"
    ])

    # XXX
    cursor = connection.execute(SELECT_CHANNELS)
    for row in cursor:
        # assemble the new row
        result = list([""] * 12)
        result[0] = row[0]  # channel
        result[1] = row[1]  # name
        result[2] = row[2]  # frequency
        result[10] = "FM"   # mode
        result[11] = row[6] # comment
    
        # repeater frequency
        if len(row[3]) > 0:
            result[3] = "split"
            result[4] = row[3]
    
        else:
            result[4] = "0.0000"
    
        # calculate tone fields
        result[6] = "88.5"
        result[7] = "88.5"
        result[8] = "023"
        result[9] = "NN"
    
        if len(row[5]) > 0:
            # XXX regular tones
            if "PL" in row[5].upper():
                result[5] = "TSQL" # Tone Tx/Rx
                result[6] = row[5][:-2].strip() # Tone
                result[7] = result[6] # Cross Tone
    
            # DCS tones
            elif "DL" in row[5].upper():
                result[5] = "DTCS" # DCS Tx/Rx
                result[8] = row[5][:-2].strip() # DCS code
                result[9] = "NN" # DCS polarity
    
        sink.writerow(result)

    cursor.close()
    connection.close()
