#!/bin/sh
# Shebang: tells the operating system to execute this script using /bin/sh

# Path to the input CSV file from the previous task
INPUT="../2_format_conversion/hh.csv"

# Path to the output sorted CSV file
OUTPUT="hh_sorted.csv"

# Copy the CSV header (first line) to the output file
head -n 1 "$INPUT" > "$OUTPUT"

# Sort the data rows (excluding the header)
# - tail -n +2 skips the first line (the CSV header)
# - sort -t ',' sets comma as the field delimiter
# - sort -k2,2 sorts primarily by the second column only
# - sort -k1,1 uses the first column as a secondary sort key
tail -n +2 "$INPUT" | sort -t ',' -k2,2 -k1,1 >> "$OUTPUT"