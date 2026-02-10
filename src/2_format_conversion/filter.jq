# Build an array that will contain the CSV header and all data rows
[
  # CSV header row
  ["id", "created_at", "name", "has_test", "alternate_url"],

  # Iterate over each vacancy in the "items" array and build one CSV row per vacancy
  (.items[] | [
      .id,            # Vacancy ID
      .created_at,    # Creation timestamp
      .name,          # Vacancy title
      .has_test,      # Indicates if a test assignment is required
      .alternate_url  # Public URL of the vacancy
  ])
]

# Unpack the array so each row is processed individually
| .[]

# Convert each row array into CSV format
| @csv