#!/bin/sh
# Shebang: tells the operating system to execute this script using /bin/sh

# Path to one of the partitioned CSV files.
# This file is used only to extract the CSV header.
# All partition files share the same header structure.
INPUT="./parts/2026-01-12.csv"

# Path to the output CSV file that will contain the concatenated result.
# This file will be created or overwritten.
OUTPUT="./concat_positions.csv"

# Read the first line (header) from the input CSV file.
header=$(head -n 1 "$INPUT")

# Write the header to the output file.
# The '>' operator ensures the file is created or reset.
echo "$header" > "$OUTPUT"

# Iterate over all CSV files produced by the partitioner script.
# Each file contains data for a single date and includes its own header.
for csv_part_file in parts/*.csv; do
    # Append all data rows from the current file to the output file.
    # 'tail -n +2' skips the header line to avoid duplicate headers.
    tail -n +2 "$csv_part_file" >> "$OUTPUT"
done