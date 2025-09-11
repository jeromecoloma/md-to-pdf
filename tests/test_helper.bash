#!/usr/bin/env bash

# Bats test helper functions
# This file is sourced by all test files

# Get the project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Source the main library
source "${PROJECT_ROOT}/lib/main.sh"

# Test utilities
setup() {
    # Common setup for all tests
    export SHELL_STARTER_TEST=1
    
    # Detect CI environments and set optimizations
    if [[ -n "${CI:-}" ]] || [[ -n "${GITHUB_ACTIONS:-}" ]] || [[ -n "${SHELL_STARTER_CI_MODE:-}" ]]; then
        export SHELL_STARTER_CI=1
        export SHELL_STARTER_SPINNER_DISABLED=1  # Disable spinners in CI
        # Don't set BATS_TEST_TIMEOUT in CI environments that lack pkill/ps
        # This prevents the "Cannot execute timeout" errors in containers
        if command -v pkill >/dev/null 2>&1 && command -v ps >/dev/null 2>&1; then
            export BATS_TEST_TIMEOUT=30          # Only set timeout if tools are available
        fi
    fi
}

teardown() {
    # Common cleanup for all tests
    unset SHELL_STARTER_TEST
    unset SHELL_STARTER_CI 2>/dev/null || true
    unset SHELL_STARTER_SPINNER_DISABLED 2>/dev/null || true
    unset BATS_TEST_TIMEOUT 2>/dev/null || true
}

# Helper function to run scripts and capture output
run_script() {
    local script_name="$1"
    shift
    run "${PROJECT_ROOT}/bin/${script_name}" "$@"
}

# Helper function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}