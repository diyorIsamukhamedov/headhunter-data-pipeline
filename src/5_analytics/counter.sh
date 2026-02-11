#!/bin/sh
# Shebang: tells the operating system to execute this script using /bin/sh

# Path to the input CSV file from the previous exercise 03
# This file contains normalised position names (Junior, Middle, Senior, "-")
INPUT="../4_feature_extraction/hh_positions.csv"

# Path to the output CSV file that will store unique position counts
OUTPUT="hh_unique_positions.csv"

# Write the CSV header to the output file
# The '>' operator creates the file or overwrites it if it already exists
echo "\"name\", \"count\"" > "$OUTPUT"

# Skip the CSV header (first line) and pass only data rows to awk
# tail -n +2 outputs the file starting from the second line
tail -n +2 "$INPUT" | awk -F',' '
{
    # This block is the MAIN awk block.
    # It runs once for EACH input line coming from tail.

    # $3 refers to the third field of the current CSV row.
    # Because -F"," is used, fields are split by commas.
    name = $3

     # Remove all double quotes from the value of "name".
    # gsub means "global substitution" (replace all matches).
    # After this, values like "Junior" become Junior.
    gsub(/"/, "", name)

    # Skip placeholder values ("-") before counting.
    # If the position name is "-", the current record is ignored
    # using 'next', which stops processing this line and moves
    # to the next input record.
    # Only valid position names (e.g. Junior, Middle, Senior)
    # are counted in the associative array.
    if (name == "-") {
        next;
    } else if (!(name == "-")) {
        count[name]++
    }
}
END {
    # The END block runs ONCE, after ALL input lines have been processed.
    # At this point, the count[] array contains final counts for each position.

    # Iterate over all keys (position names) in the count array
    for (name in count)
        # Print each unique position and its count in CSV format
        # "\"" prints a literal double quote character
        # Output example: "Junior",10
        print "\"" name "\"," count[name]
}
' | sort -t',' -k2,2nr >> "$OUTPUT"
# The output from awk is piped to sort:
# -t','      -> use comma as the field delimiter
# -k2,2      -> sort by the second column (count)
# -n         -> numeric sort
# -r         -> reverse order (descending)
#
# The '>>' operator appends the sorted result to the output file
