#!/usr/bin/env bats
#
# Tests for hello-world script

# Load test helpers
load test_helper
load bats-support/load
load bats-assert/load

@test "hello-world: default greeting" {
    run_script "hello-world"
    assert_success
    assert_output --regexp "Hello,.*World.*!"
    assert_output --partial "Greeting completed successfully"
}

@test "hello-world: custom name" {
    run_script "hello-world" "Alice"
    assert_success
    assert_output --regexp "Hello,.*Alice.*!"
    assert_output --partial "Greeting completed successfully"
}

@test "hello-world: quiet mode" {
    run_script "hello-world" --quiet
    assert_success
    assert_output --partial "Hello, World!"
    assert_output --partial "Greeting completed successfully"
    # In quiet mode, greeting should not contain color codes
    refute_output --regexp "Hello, .*\[.*World.*\].*!"
}

@test "hello-world: quiet mode with custom name" {
    run_script "hello-world" --quiet "Bob"
    assert_success
    assert_output --partial "Hello, Bob!"
    assert_output --partial "Greeting completed successfully"
    # In quiet mode, greeting should not contain color codes
    refute_output --regexp "Hello, .*\[.*Bob.*\].*!"
}

@test "hello-world: short quiet flag" {
    run_script "hello-world" -q "Charlie"
    assert_success
    assert_output --partial "Hello, Charlie!"
    assert_output --partial "Greeting completed successfully"
    # In quiet mode, greeting should not contain color codes
    refute_output --regexp "Hello, .*\[.*Charlie.*\].*!"
}

@test "hello-world: colorized output (default)" {
    run_script "hello-world"
    assert_success
    # Should contain ANSI color codes when not in quiet mode
    assert_output --partial $'\e['
}

@test "hello-world: help flag" {
    run_script "hello-world" --help
    assert_success
    assert_output --partial "Usage:"
    assert_output --partial "hello-world"
    assert_output --partial "OPTIONS:"
    assert_output --partial "EXAMPLES:"
}

@test "hello-world: short help flag" {
    run_script "hello-world" -h
    assert_success
    assert_output --partial "Usage:"
}

@test "hello-world: version flag" {
    expected_version=$(cat "${PROJECT_ROOT}/VERSION" | tr -d '\n')
    run_script "hello-world" --version
    assert_success
    assert_output --partial "hello-world"
    assert_output --partial "$expected_version"
}

@test "hello-world: short version flag" {
    expected_version=$(cat "${PROJECT_ROOT}/VERSION" | tr -d '\n')
    run_script "hello-world" -v
    assert_success
    assert_output --partial "hello-world"
    assert_output --partial "$expected_version"
}

@test "hello-world: unknown option error" {
    run_script "hello-world" --unknown
    assert_failure
    assert_output --partial "Unknown option: --unknown"
    assert_output --partial "Use --help for usage information."
}

@test "hello-world: unknown short option error" {
    run_script "hello-world" -x
    assert_failure
    assert_output --partial "Unknown option: -x"
    assert_output --partial "Use --help for usage information."
}

@test "hello-world: multiple arguments (last one wins)" {
    run_script "hello-world" "First" "Second"
    assert_success
    assert_output --regexp "Hello,.*Second.*!"
    assert_output --partial "Greeting completed successfully"
}

@test "hello-world: quiet flag before name" {
    run_script "hello-world" --quiet "Dave"
    assert_success
    assert_output --partial "Hello, Dave!"
    assert_output --partial "Greeting completed successfully"
}

@test "hello-world: name before quiet flag" {
    run_script "hello-world" "Eve" --quiet
    assert_success
    assert_output --partial "Hello, Eve!"
    assert_output --partial "Greeting completed successfully"
}

@test "hello-world: includes success log message" {
    run_script "hello-world"
    assert_success
    assert_output --partial "Greeting completed successfully"
}