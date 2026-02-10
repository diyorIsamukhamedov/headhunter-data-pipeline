#!/bin/sh
# Shebang: tells the operating system to execute this script using /bin/sh

# Check if at least one argument was provided
# $# contains the number of arguments passed to the script
if [ $# -eq 0 ]; then
    echo "Not enough parametrs"
    exit 1
fi

# Take the first argument ($1)
# Replace spaces with '+' to make it URL-safe
vacancy_name=$(echo "$1" | sed "s/ /+/g")

# Base URL of the HeadHunter API
hh_url="https://api.hh.ru/vacancies"

# Number of vacancies to retrieve per page
vacancy_count=20

# Perform an HTTP GET request to the API
# -f makes curl fail on HTTP erros (4xx, 5xx) 
data_query=$(curl -f "$hh_url?text=$vacancy_name&per_page=$vacancy_count")

# Output file where the JSON response will be saved
output_file="hh.json"

# Check if the API response is empty
# -z is a string test operator:
# it returns true if the string length is zero (i.e. the variable is empty).
# This helps detect cases where curl failed or returned no data
if [ -z "$data_query" ]; then
    echo "Error while transfering data"
    exit 1
fi

# Pretty-print the JSON using jq and redirect the result into otput file
echo "$data_query" | jq "." > "$output_file"