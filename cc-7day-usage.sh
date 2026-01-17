#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Read and parse claude-usage.json to get seven_day.utilization value
echo "Week usage $(jq -r '.seven_day.utilization' "$SCRIPT_DIR/claude-usage.json")%"
