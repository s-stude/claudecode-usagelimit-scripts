#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the reset timestamp from JSON
reset_time=$(jq -r '.seven_day.resets_at' "$SCRIPT_DIR/claude-usage.json")

if [ "$reset_time" = "null" ]; then
    echo "Week limit reset unknown"
    exit 0
fi

# Convert ISO 8601 to Unix timestamp
# Handle both GNU date (Linux) and BSD date (macOS)
if date --version >/dev/null 2>&1; then
    # GNU date
    reset_epoch=$(date -d "$reset_time" +%s)
else
    # BSD date (macOS) - remove fractional seconds and reformat timezone
    cleaned_time=$(echo "$reset_time" | sed 's/\.[0-9]*+/+/' | sed 's/\([+-][0-9][0-9]\):\([0-9][0-9]\)$/\1\2/')
    reset_epoch=$(date -j -f "%Y-%m-%dT%H:%M:%S%z" "$cleaned_time" +%s)
fi

# Get current Unix timestamp
now_epoch=$(date +%s)

# Calculate difference in seconds
diff=$((reset_epoch - now_epoch))

# Handle expired case
if [ $diff -lt 0 ]; then
    # Convert negative difference to positive
    diff=$((diff * -1))
    days=$((diff / 86400))
    hours=$(((diff % 86400) / 3600))
    minutes=$(((diff % 3600) / 60))

    if [ $days -gt 0 ]; then
        echo "Week limit reset ${days}d ${hours}h ${minutes}m ago"
    elif [ $hours -gt 0 ]; then
        echo "Week limit reset ${hours}h ${minutes}m ago"
    else
        echo "Week limit reset ${minutes}m ago"
    fi
    exit 0
fi

# Convert to days, hours, minutes
days=$((diff / 86400))
hours=$(((diff % 86400) / 3600))
minutes=$(((diff % 3600) / 60))

# Format output
if [ $days -gt 0 ]; then
    echo "Week limit reset in ${days}d ${hours}h ${minutes}m"
elif [ $hours -gt 0 ]; then
    echo "Week limit reset in ${hours}h ${minutes}m"
else
    echo "Week limit reset in ${minutes}m"
fi
