#!/bin/sh
# Shebang: tells the operating system to execute this script using /bin/sh

# =====================================================================
# Path to the input CSV file from the previous exercise (ex02).
# This file is already sorted and contains the original vacancy names.
INPUT="../3_data_sorting/hh_sorted.csv"

# Path to the output CSV file that will store cleaned position names.
# The file will be created or overwritten.
OUTPUT="hh_positions.csv"
# =====================================================================

# Write the CSV header (first line) to the output file.
# This preserves column names in the resulting dataset.
head -n 1 "$INPUT" > "$OUTPUT"

# =====================================================================
# Process data rows only by skipping the header line.
# tail -n +2 outputs the file starting from the second line.
# Each line is then processed independently by awk.
tail -n +2 "$INPUT" | awk '
{
    # Store the entire CSV row as a single string.
    # We DO NOT split the line by commas to avoid breaking
    # fields that contain commas inside double quotes.
    line = $0

    # -----------------------------------------------------------------
    # Step 1: Locate the "name" field using double quotes.
    #
    # CSV structure:
    #   1st field -> quotes 1 and 2
    #   2nd field -> quotes 3 and 4
    #   3rd field -> quotes 5 and 6   <-- this is the "name" field
    #
    # We scan the line character by character and count quotes.
    # -----------------------------------------------------------------
    quote_count = 0
    name_start = 0
    name_end = 0

    for (i = 1; i <= length(line); i++) {
        char = substr(line, i, 1)

        if (char == "\"") {
            quote_count++

            # The 5th quote marks the beginning of the "name" field
            if (quote_count == 5)
                name_start = i + 1

            # The 6th quote marks the end of the "name" field
            else if (quote_count == 6) {
                name_end = i - 1
                break
            }
        }
    }

    # -----------------------------------------------------------------
    # Step 2: Extract the original position name safely.
    # This substring may contain commas, slashes, or any text.
    # -----------------------------------------------------------------
    name = substr(line, name_start, name_end - name_start + 1)

    # -----------------------------------------------------------------
    # Step 3: Detect experience level keywords.
    # Multiple levels are allowed and preserved in order.
    # -----------------------------------------------------------------
    level = ""

    if (name ~ /Junior/) level = level "Junior/"
    if (name ~ /Middle/) level = level "Middle/"
    if (name ~ /Senior/) level = level "Senior/"

    # If no keywords were found, use "-"
    # Otherwise, remove the trailing slash
    if (level == "")
        level = "-"
    else
        sub(/\/$/, "", level)

    # -----------------------------------------------------------------
    # Step 4: Rebuild the CSV row.
    #
    # - "before" contains everything before the original name field
    # - "after"  contains everything after the original name field
    # - Only the name field is replaced
    # -----------------------------------------------------------------
    before = substr(line, 1, name_start - 2)
    after  = substr(line, name_end + 2)

    # Output the reconstructed CSV line with the cleaned name field.
    print before "\"" level "\"" after
}
' >> "$OUTPUT"