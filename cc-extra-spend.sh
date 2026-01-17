#!/bin/bash

# Get extra usage data from JSON
used_credits=$(jq -r '.extra_usage.used_credits' claude-usage.json)
utilization=$(jq -r '.extra_usage.utilization' claude-usage.json)

# Check if values are null
if [ "$used_credits" = "null" ] || [ "$utilization" = "null" ]; then
    echo "Monthly extra spend: N/A"
    exit 0
fi

# Convert credits to dollars (divide by 100) and round to 2 decimal places
dollars=$(printf "%.2f" $(echo "$used_credits / 100" | bc -l))

# Format utilization to 1 decimal place
percent=$(printf "%.1f" "$utilization")

echo "Monthly extra spend: \$$dollars ($percent%)"
