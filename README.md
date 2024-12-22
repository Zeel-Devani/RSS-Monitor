# RSS Usage Monitoring Script

## Overview

**minimon.sh** is a shell script that helps monitor the RSS (Resident Set Size) memory usage of processes running under a specific user on a Linux-based system. The script calculates both the total RSS memory usage and the peak RSS usage for a given user. If either value exceeds a specified threshold, the script triggers an alert.

## Features

- Retrieves RSS memory usage for all processes of a specified user.
- Computes the total RSS memory usage for all processes of the user.
- Determines the peak (largest) RSS memory usage for the user's processes.
- Alerts if total or peak RSS exceeds the specified threshold.

## Prerequisites

- Linux-based system with basic command-line utilities such as `ps`, `awk`, and `grep`.
- Sufficient permissions to view processes of the specified user.

## Usage

1. **Clone the repository** (or download the script):

   ```bash
   git clone https://github.com/Zeel-Devani/RSS-Monitor.git
   cd RSS-Monitor
   ```

2. **Make the script executable**:

   ```bash
   chmod +x minimon.sh
   ```

3. **Run the script**:

   ```bash
   ./minimon.sh <username> <threshold>
   ```

   - `<username>`: The username of the user whose processes you want to monitor.
   - `<threshold>`: The memory usage threshold (in kilobytes). Alerts will be triggered if either the total or peak RSS exceeds this value.

### Example:

```bash
./minimon.sh john 100000
```

This example monitors the user `john` and triggers alerts if the total or peak RSS exceeds 100,000 KB (100 MB).

### Example Output:

```bash
john: 350000 120000
ALERT: john: exceeded RSS threshold (350000 total)
ALERT: john: exceeded RSS threshold (120000 peak)
```

- **Total RSS**: 350,000 KB
- **Peak RSS**: 120,000 KB
- Alerts are triggered because both values exceed the threshold.

## Functions

### `get_rss_usage(username)`
- **Input**: A username.
- **Output**: List of numeric RSS values for the user's processes.

### `combine_rss_usage(username)`
- **Input**: A username.
- **Output**: Total RSS memory usage for the user's processes.

### `find_largest_rss(username)`
- **Input**: A username.
- **Output**: The largest (peak) RSS memory usage from the user's processes.

### `main(username threshold)`
- **Input**: A username and a threshold (in kilobytes).
- **Output**: Total and peak RSS values, along with alerts if they exceed the provided threshold.

## Error Handling

- **Missing username**: The script will exit with an error if no username is provided.
- **Missing threshold**: The script will exit with an error if no threshold is provided.
- **No RSS values found**: If no processes are found for the given user, the script will display an error and exit.

## License

This script is licensed under the **MIT License**. 
