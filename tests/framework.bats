#!/usr/bin/env bats
#
# Framework test - verifies Bats testing setup is working

# Load test helpers
load test_helper
load bats-support/load
load bats-assert/load

@test "Bats framework is working" {
    run echo "Hello, Bats!"
    assert_success
    assert_output "Hello, Bats!"
}

@test "Project root is accessible" {
    [ -n "$PROJECT_ROOT" ]
    [ -d "$PROJECT_ROOT" ]
}

@test "Main library can be sourced" {
    [ -f "$PROJECT_ROOT/lib/main.sh" ]
    run bash -c "source '$PROJECT_ROOT/lib/main.sh' && echo 'Library loaded'"
    assert_success
    assert_output "Library loaded"
}

@test "Test helper functions work" {
    run command_exists "bash"
    assert_success
    
    run command_exists "nonexistent_command_12345"
    assert_failure
}