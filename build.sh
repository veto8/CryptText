#!/bin/bash

SOURCE_FILE="src/crypttext.c"
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )" # Get the directory of the script

# Function to execute your build and run commands
run_build_and_execute() {
  echo "File changed. Rebuilding and running..."
  rm -rf build
  cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local/nappgui
  cmake --build build
  build/Release/bin/crypttext & 
  echo "Build and execution complete."
}

# Check if inotifywait is installed
if ! command -v inotifywait &> /dev/null
then
    echo "inotifywait is not installed. Please install it (e.g., sudo apt-get install inotify-tools)."
    exit 1
fi

# Initial build and execution
run_build_and_execute

# Monitor the source file for changes
while inotifywait -e modify "$SOURCE_FILE"; do
    echo "...changed"
    pkill -f "build/Release/bin/crypttext"
    run_build_and_execute

done
