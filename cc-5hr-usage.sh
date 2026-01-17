#!/bin/bash

# Read and parse claude-usage.json to get five_hour.utilization value
echo "Day usage $(jq -r '.five_hour.utilization' claude-usage.json)%"
