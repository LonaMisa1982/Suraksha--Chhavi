#!/bin/bash

# Total number of fake commits
TOTAL_COMMITS=100

# Set start and end date range
START_DATE="2025-07-01"
END_DATE="2025-07-19"

# Files or folders to touch
TARGETS=("configs" "evaluation" "misc" "model" "preprocessing" "scripts" "utils" "README.md" "train.py" "test.py")

# Converts a date to epoch (seconds)
date_to_epoch() {
    date -d "$1" +%s
}

# Generate random date between START_DATE and END_DATE
random_date() {
    local start_epoch=$(date_to_epoch "$START_DATE")
    local end_epoch=$(date_to_epoch "$END_DATE")
    local random_epoch=$((RANDOM % (end_epoch - start_epoch + 1) + start_epoch))
    date -d "@$random_epoch" "+%Y-%m-%d"
}

# Generate commits
for ((i=1; i<=TOTAL_COMMITS; i++)); do
    TARGET=${TARGETS[$RANDOM % ${#TARGETS[@]}]}

    # Generate random date and random time
    COMMIT_DAY=$(random_date)
    RANDOM_HOUR=$((RANDOM % 24))
    RANDOM_MINUTE=$((RANDOM % 60))
    RANDOM_SECOND=$((RANDOM % 60))

    COMMIT_TIMESTAMP="${COMMIT_DAY}T$(printf "%02d:%02d:%02d" $RANDOM_HOUR $RANDOM_MINUTE $RANDOM_SECOND)"

    # Modify a file (create if doesn't exist)
    if [ -d "$TARGET" ]; then
        echo "# fake commit $i at $COMMIT_TIMESTAMP" >> "$TARGET/fake_$i.txt"
    else
        echo "# fake commit $i at $COMMIT_TIMESTAMP" >> "$TARGET"
    fi

    # Stage and commit with the fake date
    GIT_AUTHOR_DATE=$COMMIT_TIMESTAMP GIT_COMMITTER_DATE=$COMMIT_TIMESTAMP git add .
    GIT_AUTHOR_DATE=$COMMIT_TIMESTAMP GIT_COMMITTER_DATE=$COMMIT_TIMESTAMP git commit -m "Fake commit $i to $TARGET"

    echo "Committed $i to $TARGET at $COMMIT_TIMESTAMP"
done

# Final push to GitHub
git push origin main
