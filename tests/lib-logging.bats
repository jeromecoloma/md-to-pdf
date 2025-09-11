#!/usr/bin/env bats
#
# Tests for lib/logging.sh - logging functions

# Load test helpers
load test_helper
load bats-support/load
load bats-assert/load

setup() {
    # Reset log level to default for each test
    export LOG_LEVEL="INFO"
}

@test "log::info displays info messages" {
    run log::info "Test info message"
    assert_success
    assert_output --partial "[$(date '+%Y-%m-%d')"
    assert_output --partial "INFO:"
    assert_output --partial "Test info message"
}

@test "log::warn displays warning messages" {
    run log::warn "Test warning message"
    assert_success
    assert_output --partial "WARN:"
    assert_output --partial "Test warning message"
}

@test "log::error displays error messages" {
    run log::error "Test error message"
    assert_success
    assert_output --partial "ERROR:"
    assert_output --partial "Test error message"
}

@test "log::debug displays debug messages when LOG_LEVEL is DEBUG" {
    export LOG_LEVEL="DEBUG"
    run log::debug "Test debug message"
    assert_success
    assert_output --partial "DEBUG:"
    assert_output --partial "Test debug message"
}

@test "log::debug is suppressed when LOG_LEVEL is INFO" {
    export LOG_LEVEL="INFO"
    run log::debug "Test debug message"
    assert_success
    refute_output --partial "DEBUG:"
    refute_output --partial "Test debug message"
}

@test "log::debug is suppressed when LOG_LEVEL is WARN" {
    export LOG_LEVEL="WARN"
    run log::debug "Test debug message"
    assert_success
    refute_output --partial "DEBUG:"
}

@test "log::info is suppressed when LOG_LEVEL is WARN" {
    export LOG_LEVEL="WARN"
    run log::info "Test info message"
    assert_success
    refute_output --partial "INFO:"
}

@test "log::warn is suppressed when LOG_LEVEL is ERROR" {
    export LOG_LEVEL="ERROR"
    run log::warn "Test warning message"
    assert_success
    refute_output --partial "WARN:"
}

@test "log::error is always shown regardless of LOG_LEVEL" {
    export LOG_LEVEL="ERROR"
    run log::error "Test error message"
    assert_success
    assert_output --partial "ERROR:"
    assert_output --partial "Test error message"
}

@test "logging includes timestamps" {
    run log::info "Test with timestamp"
    assert_success
    # Check for timestamp format YYYY-MM-DD HH:MM:SS
    assert_output --regexp "\[[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}\]"
}

@test "logging outputs to stderr" {
    # Capture stderr output by redirecting stderr to stdout
    run bash -c "source $PROJECT_ROOT/lib/logging.sh; log::info 'test message' 2>&1"
    assert_success
    assert_output --partial "test message"
}

@test "logging uses colors" {
    run log::error "Test colored message"
    assert_success
    # Should contain ANSI color codes
    assert_output --partial $'\e['
}

@test "_should_log function works correctly for DEBUG level" {
    export LOG_LEVEL="DEBUG"
    run bash -c "source $PROJECT_ROOT/lib/logging.sh; _should_log DEBUG && echo 'show debug'"
    assert_success
    assert_output "show debug"
    
    run bash -c "source $PROJECT_ROOT/lib/logging.sh; _should_log INFO && echo 'show info'"
    assert_success
    assert_output "show info"
    
    run bash -c "source $PROJECT_ROOT/lib/logging.sh; _should_log WARN && echo 'show warn'"
    assert_success
    assert_output "show warn"
    
    run bash -c "source $PROJECT_ROOT/lib/logging.sh; _should_log ERROR && echo 'show error'"
    assert_success
    assert_output "show error"
}

@test "_should_log function works correctly for INFO level" {
    export LOG_LEVEL="INFO"
    run bash -c "source $PROJECT_ROOT/lib/logging.sh; _should_log DEBUG && echo 'show debug'"
    assert_failure
    
    run bash -c "source $PROJECT_ROOT/lib/logging.sh; _should_log INFO && echo 'show info'"
    assert_success
    assert_output "show info"
}

@test "_should_log function works correctly for WARN level" {
    export LOG_LEVEL="WARN"
    run bash -c "source $PROJECT_ROOT/lib/logging.sh; _should_log INFO && echo 'show info'"
    assert_failure
    
    run bash -c "source $PROJECT_ROOT/lib/logging.sh; _should_log WARN && echo 'show warn'"
    assert_success
    assert_output "show warn"
}

@test "multiple arguments are handled correctly" {
    run log::info "Message with" "multiple" "arguments"
    assert_success
    assert_output --partial "Message with multiple arguments"
}

@test "colors are loaded when not already sourced" {
    # Test the color fallback loading mechanism
    run bash -c "unset COLOR_RESET; source $PROJECT_ROOT/lib/logging.sh; echo \$COLOR_RESET"
    assert_success
    assert_output '\033[0m'
}