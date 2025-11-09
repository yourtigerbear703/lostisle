#!/bin/bash

START_DATE="2025-04-01"
END_DATE="2025-09-30"
DAYS=90
FILE="README.md"

# Calculate start and end dates in seconds since epoch
START_SECONDS=$(date -d "$START_DATE" "+%s")
END_SECONDS=$(date -d "$END_DATE" "+%s")

# Calculate the number of days in the range
RANGE_DAYS=$(( (END_SECONDS - START_SECONDS) / 86400 ))

# Debugging: Print the date range
echo "Start date: $(date -d "@$START_SECONDS" "+%Y-%m-%d")"
echo "End date: $(date -d "@$END_SECONDS" "+%Y-%m-%d")"
echo "Range in days: $RANGE_DAYS"

# Generate random commit dates
declare -a COMMIT_DATES
for ((i=0; i<$DAYS; i++)); do
  # Generate a random day offset within the range
  RANDOM_DAY=$((RANDOM % (RANGE_DAYS + 1)))
  # Calculate the random date in seconds
  RANDOM_SECONDS=$((START_SECONDS + RANDOM_DAY * 86400))
  # Add random hours, minutes, seconds for realism
  RANDOM_HOURS=$((RANDOM % 24))
  RANDOM_MINUTES=$((RANDOM % 60))
  RANDOM_SECONDS=$((RANDOM % 60))
  COMMIT_DATE=$(date -d "@$RANDOM_SECONDS" "+%Y-%m-%dT${RANDOM_HOURS}:${RANDOM_MINUTES}:${RANDOM_SECONDS}")
  COMMIT_DATES+=("$COMMIT_DATE")
done

# Sort dates to make commit history chronological
IFS=$'\n' sorted_dates=($(sort <<<"${COMMIT_DATES[*]}"))
unset IFS

# Create commits
for ((i=0; i<$DAYS; i++)); do
  COMMIT_DATE="${sorted_dates[$i]}"
  COMMIT_DISPLAY=$(date -d "$COMMIT_DATE" "+%Y-%m-%d %H:%M:%S")
  echo "Commit on $COMMIT_DISPLAY" >> $FILE
  git add $FILE
  GIT_AUTHOR_DATE="$COMMIT_DATE" GIT_COMMITTER_DATE="$COMMIT_DATE" git commit -m "Auto commit on $COMMIT_DISPLAY"
done

echo "✅ Done generating commits."
