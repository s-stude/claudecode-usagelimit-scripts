# Claude Code Usage Limits UI

A collection of shell scripts to parse and display Claude Code usage limits and reset timers from the `claude-usage.json` file.

## Source File: `claude-usage.json`

This JSON file contains usage limit information for Claude Code, tracking your utilization across different time windows:

```json
{
  "five_hour": {
    "utilization": 0.0,
    "resets_at": null
  },
  "seven_day": {
    "utilization": 100.0,
    "resets_at": "2026-01-17T13:59:59.602877+00:00"
  },
  "seven_day_oauth_apps": null,
  "seven_day_opus": null,
  "seven_day_sonnet": null,
  "iguana_necktie": null,
  "extra_usage": {
    "is_enabled": true,
    "monthly_limit": 2000,
    "used_credits": 963.0,
    "utilization": 48.15
  }
}
```

### Fields Explained

- **five_hour**: Daily (5-hour rolling window) usage limit
  - `utilization`: Percentage of the limit used (0-100)
  - `resets_at`: ISO 8601 timestamp when the limit resets (null if not set)

- **seven_day**: Weekly (7-day rolling window) usage limit
  - `utilization`: Percentage of the limit used (0-100)
  - `resets_at`: ISO 8601 timestamp when the limit resets (null if not set)

- **extra_usage**: Additional credit usage information
  - `is_enabled`: Whether extra usage is enabled
  - `monthly_limit`: Monthly credit limit
  - `used_credits`: Credits consumed this month
  - `utilization`: Percentage of monthly limit used

## Shell Scripts

### 1. `cc-5hr-usage.sh`

Displays the current utilization percentage for the 5-hour (daily) limit.

**Usage:**
```bash
./cc-5hr-usage.sh
```

**Output:**
```
0.0%
```

**Description:**
- Reads `claude-usage.json`
- Extracts `five_hour.utilization` value
- Appends a `%` sign to the output

---

### 2. `cc-7day-usage.sh`

Displays the current utilization percentage for the 7-day (weekly) limit.

**Usage:**
```bash
./cc-7day-usage.sh
```

**Output:**
```
100.0%
```

**Description:**
- Reads `claude-usage.json`
- Extracts `seven_day.utilization` value
- Appends a `%` sign to the output

---

### 3. `cc-5hr-reset-timestamp.sh`

Shows the time remaining until the 5-hour (daily) limit resets, or when it was reset.

**Usage:**
```bash
./cc-5hr-reset-timestamp.sh
```

**Possible Outputs:**
- `Day limit reset unknown` - When `resets_at` is null
- `Day limit reset 15m ago` - When the reset time has passed
- `Day limit reset in 2h 30m` - Time remaining until reset (future timestamp)
- `Day limit reset in 1d 5h 20m` - Time remaining with days (future timestamp)

**Description:**
- Reads `claude-usage.json`
- Extracts `five_hour.resets_at` timestamp
- Handles timezone conversion (supports UTC and other timezones)
- Calculates time difference from current time
- Formats output intelligently based on the time span

---

### 4. `cc-7day-reset-timestamp.sh`

Shows the time remaining until the 7-day (weekly) limit resets, or when it was reset.

**Usage:**
```bash
./cc-7day-reset-timestamp.sh
```

**Possible Outputs:**
- `Week limit reset unknown` - When `resets_at` is null
- `Week limit reset 4h 21m ago` - When the reset time has passed
- `Week limit reset in 3h 15m` - Time remaining until reset (future timestamp)
- `Week limit reset in 2d 10h 45m` - Time remaining with days (future timestamp)

**Description:**
- Reads `claude-usage.json`
- Extracts `seven_day.resets_at` timestamp
- Handles timezone conversion (supports UTC and other timezones)
- Calculates time difference from current time
- Formats output intelligently based on the time span

---

## Requirements

All scripts require:
- **jq** - Command-line JSON processor

### Installing jq

**macOS:**
```bash
brew install jq
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get install jq
```

**Linux (Fedora):**
```bash
sudo dnf install jq
```

## Cross-Platform Compatibility

The timestamp scripts (`cc-5hr-reset-timestamp.sh` and `cc-7day-reset-timestamp.sh`) are designed to work on both:
- **macOS** (BSD date)
- **Linux** (GNU date)

They automatically detect the platform and use the appropriate date command syntax.

## Setup

1. Ensure all scripts have execute permissions:
```bash
chmod +x cc-5hr-usage.sh cc-7day-usage.sh cc-5hr-reset-timestamp.sh cc-7day-reset-timestamp.sh
```

2. Make sure `claude-usage.json` exists in the same directory as the scripts

## Example Usage

Check your current usage:
```bash
$ ./cc-5hr-usage.sh
0.0%

$ ./cc-7day-usage.sh
100.0%
```

Check when limits reset:
```bash
$ ./cc-5hr-reset-timestamp.sh
Day limit reset unknown

$ ./cc-7day-reset-timestamp.sh
Week limit reset 4h 21m ago
```

## Use Cases

- **Status bar integrations**: Display usage in your system status bar
- **Monitoring dashboards**: Track Claude Code usage over time
- **Automation**: Create alerts when limits are approaching
- **CI/CD pipelines**: Check usage before running automated tasks

## License

MIT
