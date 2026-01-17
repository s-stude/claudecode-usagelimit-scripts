#!/bin/bash

# Read and parse claude-usage.json to get seven_day.utilization value
echo "Week usage $(jq -r '.seven_day.utilization' claude-usage.json)%"
