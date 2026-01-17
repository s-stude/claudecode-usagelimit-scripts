#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Read and parse claude-usage.json to get five_hour.utilization value
echo "Day usage $(jq -r '.five_hour.utilization' "$SCRIPT_DIR/claude-usage.json")%"
