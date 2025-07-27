#!/bin/bash

# Starting point for the search
START_DIR="${1:-.}"

# List of directories to ignore, separated by spaces
IGNORE_DIRS=(storage)  # replace with actual directories to ignore

# Function to check if any part of the directory path contains an ignored directory
should_ignore() {
    local dir="$1"
    for ignore in "${IGNORE_DIRS[@]}"; do
        # Check if the directory part matches exactly
        if [[ "$dir" == *"/$ignore" || "$dir" == "$ignore"* || "$dir" == *"/$ignore/"* ]]; then
            return 0  # Yes, ignore this directory
        fi
    done
    return 1  # No, do not ignore this directory
}

# Find and execute each 'run.sh' script in directories not ignored
find "$START_DIR" -type f -name "run.sh" | while read -r script_path; do
    dir_path=$(dirname "$script_path")

    # Check if this directory (or any part of its path) should be ignored
    if should_ignore "$dir_path"; then
        echo "Skipping ignored directory: $dir_path"
        continue
    fi

    # Change to the directory and execute the script
    echo "Entering directory: $dir_path"
    (cd "$dir_path" && time ./run.sh)
done
