#!/usr/bin/env bats
#
# Tests for lib/main.sh - main library entrypoint functions

# Load test helpers
load test_helper
load bats-support/load
load bats-assert/load

@test "get_version: returns VERSION file content" {
    # Test reading the VERSION file
    run get_version
    assert_success
    assert_output "0.1.0"
}

@test "get_version: returns 'unknown' when VERSION file missing" {
    # Temporarily move VERSION file
    mv "${PROJECT_ROOT}/VERSION" "${PROJECT_ROOT}/VERSION.backup"
    
    run get_version
    assert_success
    assert_output "unknown"
    
    # Restore VERSION file
    mv "${PROJECT_ROOT}/VERSION.backup" "${PROJECT_ROOT}/VERSION"
}

@test "parse_common_args: handles --version flag" {
    run parse_common_args "test-script" --version
    assert_success
    assert_output "test-script 0.1.0"
}

@test "parse_common_args: handles -v flag" {
    run parse_common_args "test-script" -v
    assert_success
    assert_output "test-script 0.1.0"
}

@test "parse_common_args: handles --help flag" {
    run parse_common_args "test-script" --help
    assert_success
    assert_output --partial "Usage: test-script [OPTIONS]"
    assert_output --partial "OPTIONS:"
    assert_output --partial "-h, --help"
    assert_output --partial "-v, --version"
}

@test "parse_common_args: handles -h flag" {
    run parse_common_args "test-script" -h
    assert_success
    assert_output --partial "Usage: test-script [OPTIONS]"
}

@test "parse_common_args: returns 1 for unknown options" {
    run parse_common_args "test-script" --unknown
    assert_failure
    assert_equal "$status" 1
}

@test "parse_common_args: returns 0 when no args provided" {
    run parse_common_args "test-script"
    assert_success
}

@test "show_help: displays default help message" {
    run show_help "test-script"
    assert_success
    assert_output --partial "Usage: test-script [OPTIONS]"
    assert_output --partial "OPTIONS:"
    assert_output --partial "-h, --help     Show this help message and exit"
    assert_output --partial "-v, --version  Show version information and exit"
    assert_output --partial "This is a Shell Starter script"
}

@test "show_help: uses basename when no script name provided" {
    run show_help
    assert_success
    # Should use basename of current script
    assert_output --partial "Usage:"
    assert_output --partial "OPTIONS:"
}

@test "library paths are set correctly" {
    # Test that the library directory paths are properly set
    assert [ -n "$SHELL_STARTER_LIB_DIR" ]
    assert [ -n "$SHELL_STARTER_ROOT_DIR" ]
    assert [ -d "$SHELL_STARTER_LIB_DIR" ]
    assert [ -d "$SHELL_STARTER_ROOT_DIR" ]
    
    # Verify the paths point to the correct directories
    assert [ "$SHELL_STARTER_ROOT_DIR" = "$PROJECT_ROOT" ]
    assert [ "$SHELL_STARTER_LIB_DIR" = "$PROJECT_ROOT/lib" ]
}

@test "all library modules are sourced" {
    # Verify that color variables are available (from colors.sh)
    assert [ -n "$COLOR_RED" ]
    assert [ -n "$COLOR_GREEN" ]
    assert [ -n "$COLOR_RESET" ]
    
    # Verify that logging functions are available (from logging.sh)
    assert [ "$(type -t log::info)" = "function" ]
    assert [ "$(type -t log::error)" = "function" ]
    
    # Verify that spinner functions are available (from spinner.sh)
    assert [ "$(type -t spinner::start)" = "function" ]
    assert [ "$(type -t spinner::stop)" = "function" ]
    
    # Verify that utility functions are available (from utils.sh)
    assert [ "$(type -t run::script)" = "function" ]
}