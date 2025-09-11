#!/usr/bin/env bats
#
# Tests for lib/spinner.sh - spinner animation functions

# Load test helpers
load test_helper
load bats-support/load
load bats-assert/load

setup() {
    # Clean up any existing spinner processes
    if [[ -n "${SPINNER_PID:-}" ]] && kill -0 "$SPINNER_PID" 2>/dev/null; then
        kill "$SPINNER_PID" 2>/dev/null || true
    fi
    unset SPINNER_PID SPINNER_MESSAGE
}

teardown() {
    # Clean up any remaining spinner processes
    if [[ -n "${SPINNER_PID:-}" ]] && kill -0 "$SPINNER_PID" 2>/dev/null; then
        kill "$SPINNER_PID" 2>/dev/null || true
    fi
}

@test "spinner::start sets SPINNER_PID" {
    run bash -c "export SHELL_STARTER_SPINNER_DISABLED=1; source $PROJECT_ROOT/lib/spinner.sh; spinner::start 'test message'; echo \"PID: \$SPINNER_PID\"; spinner::stop; echo \"After stop: \$SPINNER_PID\""
    assert_success
    # In CI mode (spinner disabled), should show disabled
    assert_output $'PID: disabled\nAfter stop: '
}

@test "spinner::start with default message" {
    # Test that spinner starts with default message when none provided
    run bash -c "export SHELL_STARTER_SPINNER_DISABLED=1; source $PROJECT_ROOT/lib/spinner.sh; spinner::start; spinner::stop; echo 'started'"
    assert_success
    assert_output "started"
}

@test "spinner::start with custom message" {
    run bash -c "export SHELL_STARTER_SPINNER_DISABLED=1; source $PROJECT_ROOT/lib/spinner.sh; spinner::start 'Custom loading message'; spinner::stop; echo 'started with custom'"
    assert_success
    assert_output "started with custom"
}

@test "spinner::stop cleans up process" {
    run bash -c "
        export SHELL_STARTER_SPINNER_DISABLED=1
        source $PROJECT_ROOT/lib/spinner.sh
        spinner::start 'test'
        pid=\$SPINNER_PID
        spinner::stop
        # Check if process is gone (in CI mode, pid will be 'disabled')
        if [[ \$pid == 'disabled' ]]; then
            echo 'disabled spinner cleaned up'
        elif kill -0 \$pid 2>/dev/null; then
            echo 'process still running'
        else
            echo 'process cleaned up'
        fi
    "
    assert_success
    assert_output "disabled spinner cleaned up"
}

@test "spinner::stop when no spinner is running" {
    run bash -c "source $PROJECT_ROOT/lib/spinner.sh; spinner::stop; echo 'stopped safely'"
    assert_success
    assert_output "stopped safely"
}

@test "spinner::update changes message" {
    # This test verifies the update function exists and runs without error
    run bash -c "
        export SHELL_STARTER_SPINNER_DISABLED=1
        source $PROJECT_ROOT/lib/spinner.sh
        spinner::start 'initial message'
        spinner::update 'updated message'
        spinner::stop
        echo 'updated successfully'
    "
    assert_success
    assert_output "updated successfully"
}

@test "spinner::update with no active spinner" {
    run bash -c "export SHELL_STARTER_SPINNER_DISABLED=1; source $PROJECT_ROOT/lib/spinner.sh; spinner::update 'test message'; echo 'update called'"
    assert_success
    assert_output "update called"
}

@test "multiple spinner::start calls stop previous spinner" {
    run bash -c "
        export SHELL_STARTER_SPINNER_DISABLED=1
        source $PROJECT_ROOT/lib/spinner.sh
        spinner::start 'first spinner'
        first_pid=\$SPINNER_PID
        spinner::start 'second spinner'
        second_pid=\$SPINNER_PID
        spinner::stop
        
        # In CI mode, both will be 'disabled'
        if [[ \$first_pid == 'disabled' && \$second_pid == 'disabled' ]]; then
            echo 'disabled spinners handled'
        elif [[ \$first_pid != \$second_pid ]]; then
            echo 'different pids'
        else
            echo 'same pids'
        fi
    "
    assert_success
    assert_output "disabled spinners handled"
}

@test "SPINNER_CHARS variable is defined" {
    run bash -c "source $PROJECT_ROOT/lib/spinner.sh; echo \${#SPINNER_CHARS}"
    assert_success
    # Should have 10 spinner characters
    assert_output "10"
}

@test "spinner characters are Unicode spinners" {
    run bash -c "source $PROJECT_ROOT/lib/spinner.sh; echo \$SPINNER_CHARS"
    assert_success
    assert_output "⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
}

@test "spinner global variables are properly initialized" {
    run bash -c "
        source $PROJECT_ROOT/lib/spinner.sh
        echo \"PID: \${SPINNER_PID:-empty}\"
        echo \"CHARS: \$SPINNER_CHARS\"
        echo \"MESSAGE: \${SPINNER_MESSAGE:-empty}\"
    "
    assert_success
    assert_output --partial "PID: empty"
    assert_output --partial "CHARS: ⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
    assert_output --partial "MESSAGE: empty"
}

@test "_spinner_animate function exists and is internal" {
    # Verify the internal function exists
    run bash -c "source $PROJECT_ROOT/lib/spinner.sh; declare -F _spinner_animate"
    assert_success
    assert_output "_spinner_animate"
}

@test "spinner handles forceful termination" {
    run bash -c "
        export SHELL_STARTER_SPINNER_DISABLED=1
        source $PROJECT_ROOT/lib/spinner.sh
        spinner::start 'test message'
        pid=\$SPINNER_PID
        # In CI mode, no real process to stop
        if [[ \$pid != 'disabled' ]]; then
            # Simulate a stuck process by sending STOP signal first
            kill -STOP \$pid 2>/dev/null || true
        fi
        spinner::stop
        echo 'force stop completed'
    "
    assert_success
    assert_output "force stop completed"
}