#!/usr/bin/env bats
#
# Tests for lib/colors.sh - color variables and constants

# Load test helpers
load test_helper
load bats-support/load
load bats-assert/load

@test "basic text colors are defined" {
    assert [ -n "$COLOR_BLACK" ]
    assert [ -n "$COLOR_RED" ]
    assert [ -n "$COLOR_GREEN" ]
    assert [ -n "$COLOR_YELLOW" ]
    assert [ -n "$COLOR_BLUE" ]
    assert [ -n "$COLOR_MAGENTA" ]
    assert [ -n "$COLOR_CYAN" ]
    assert [ -n "$COLOR_WHITE" ]
}

@test "bright text colors are defined" {
    assert [ -n "$COLOR_BRIGHT_BLACK" ]
    assert [ -n "$COLOR_BRIGHT_RED" ]
    assert [ -n "$COLOR_BRIGHT_GREEN" ]
    assert [ -n "$COLOR_BRIGHT_YELLOW" ]
    assert [ -n "$COLOR_BRIGHT_BLUE" ]
    assert [ -n "$COLOR_BRIGHT_MAGENTA" ]
    assert [ -n "$COLOR_BRIGHT_CYAN" ]
    assert [ -n "$COLOR_BRIGHT_WHITE" ]
}

@test "text formatting codes are defined" {
    assert [ -n "$COLOR_BOLD" ]
    assert [ -n "$COLOR_DIM" ]
    assert [ -n "$COLOR_UNDERLINE" ]
    assert [ -n "$COLOR_BLINK" ]
    assert [ -n "$COLOR_REVERSE" ]
}

@test "reset code is defined" {
    assert [ -n "$COLOR_RESET" ]
}

@test "semantic colors are defined" {
    assert [ -n "$COLOR_INFO" ]
    assert [ -n "$COLOR_SUCCESS" ]
    assert [ -n "$COLOR_WARNING" ]
    assert [ -n "$COLOR_ERROR" ]
    assert [ -n "$COLOR_DEBUG" ]
}

@test "color codes have correct ANSI sequences" {
    # Test basic colors
    assert_equal "$COLOR_RED" '\033[0;31m'
    assert_equal "$COLOR_GREEN" '\033[0;32m'
    assert_equal "$COLOR_BLUE" '\033[0;34m'
    
    # Test bright colors
    assert_equal "$COLOR_BRIGHT_RED" '\033[1;31m'
    assert_equal "$COLOR_BRIGHT_GREEN" '\033[1;32m'
    
    # Test formatting
    assert_equal "$COLOR_BOLD" '\033[1m'
    assert_equal "$COLOR_RESET" '\033[0m'
}

@test "semantic colors map to correct base colors" {
    assert_equal "$COLOR_INFO" "$COLOR_BLUE"
    assert_equal "$COLOR_SUCCESS" "$COLOR_GREEN"
    assert_equal "$COLOR_WARNING" "$COLOR_YELLOW"
    assert_equal "$COLOR_ERROR" "$COLOR_RED"
    assert_equal "$COLOR_DEBUG" "$COLOR_MAGENTA"
}

@test "color variables are readonly" {
    # Test that color variables cannot be modified
    run bash -c "source $PROJECT_ROOT/lib/colors.sh; COLOR_RED='modified'; echo \$COLOR_RED"
    assert_failure
}

@test "colors work in terminal output" {
    # Test that colors produce expected output format  
    run bash -c "source $PROJECT_ROOT/lib/colors.sh; printf \"\${COLOR_RED}red text\${COLOR_RESET}\""
    assert_success
    assert_output --partial "red text"
    # Should contain ANSI escape sequences
    assert_output --partial $'['
}