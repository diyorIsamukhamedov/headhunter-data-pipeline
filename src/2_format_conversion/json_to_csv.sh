#!/bin/sh
# Shebang: tells the operating system to execute this script using /bin/sh

# Path to the input JSON file generated in the previous task 
json_file_path="../1_data_collection/hh.json"

# jq filter file that defines how JSON is converted to CSV
csv_filter="filter.jq"

# Output CSV file name
csv_file="hh.csv"

# Check if the input JSON file exists 
# '-f' tests whether the path points to a regular file
# '!' negates the test result (true if the file does not exists)
if [ ! -f "$json_file_path" ]; then
    echo "Error: File '$json_file_path' not found"
    exit 1
fi

# Use jq to transform JSON into CSV
# '-r' enables row output (requires for CSV format)
# '-f' specifies the jq filter file
# Finally, redirect the result into the output CSV file
jq -r -f "$csv_filter" "$json_file_path" > "$csv_file"