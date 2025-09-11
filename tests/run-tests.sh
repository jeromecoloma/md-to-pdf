#!/usr/bin/env bash
#
# Convenience script for running Bats tests

set -euo pipefail

# Get the project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Check if Bats is available
if [ ! -f "$PROJECT_ROOT/tests/bats-core/bin/bats" ]; then
    echo "Error: Bats-core not found. Run scripts/setup-bats.sh first." >&2
    exit 1
fi

# Run all tests or specific test file
if [ $# -eq 0 ]; then
    echo "Running all tests..."
    "$PROJECT_ROOT/tests/bats-core/bin/bats" "$PROJECT_ROOT/tests"/*.bats
else
    echo "Running specific test: $1"
    "$PROJECT_ROOT/tests/bats-core/bin/bats" "$1"
fi
