#!/bin/sh
# Shebang: tells the operating system to execute this script using /bin/sh

# Path to the input CSV file from the previous exercise 03
INPUT="../4_feature_extraction/hh_positions.csv"

# Automated folder creation
mkdir -p parts

# Use awk to partition the CSV file by date (created_at field)
awk -F',' '
{
    # NR is the current record (line) number in awk.
    # NR == 1 means the first line of the file (CSV header).
    if (NR == 1) {
        # Save the header line for later use.
        # We do NOT write it immediately, because each output file
        # must receive the header only once, when it is created.

        # Skip further processing of the header line.
        header = $0
        next;
    } else {
        # Extract the date (YYYY-MM-DD) from the "created_at" column.
        # $2 is the second CSV field: "2025-12-22T13:05:48+0300"
        # substr($2, 2, 10) removes the leading quote and keeps the date.
        date = substr($2, 2, 10)

        # Build the output filename dynamically based on the date.
        # Example: 2025-12-22.csv
        csv_filename = "parts/" date ".csv"

        # Check whether this date has already been processed.
        # "seen" is an associative array used as a memory structure.
        # The expression (date in seen) returns true if:
        #   - a file for this date was already initialised
        #   - the CSV header was already written to that file
        # The negation !(date in seen) means:
        #   "This is the FIRST time we encounter this date"
        if (!(date in seen)) {
            # Write the CSV header to the file.
            # This happens ONLY ONCE per date/file.
            print header > csv_filename

            # Mark this date as processed.
            # From now on, (date in seen) will be true.
            seen[date] = 1
        }
        
        #Write the current data row to the corresponding date file.
        # Since awk keeps the file open, subsequent rows with the same
        # date will be appended to the same file.
        print > csv_filename
    }
}
' "$INPUT"