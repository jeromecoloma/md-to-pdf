#!/usr/bin/env bats
#
# Integration tests for the complete library system

# Load test helpers
load test_helper
load bats-support/load
load bats-assert/load

@test "main library integration: all modules work together" {
    run bash -c "
        source $PROJECT_ROOT/lib/main.sh
        
        # Test version function
        version=\$(get_version)
        echo \"Version: \$version\"
        
        # Test colored logging
        log::info 'Integration test running'
        log::warn 'Warning message with colors'
        
        # Test that all expected functions are available
        if declare -F log::info >/dev/null && 
           declare -F spinner::start >/dev/null && 
           declare -F run::script >/dev/null; then
            echo 'All functions available'
        else
            echo 'Missing functions'
        fi
    "
    assert_success
    assert_output --partial "Version: 0.1.0"
    assert_output --partial "All functions available"
    assert_output --partial "INFO:"
    assert_output --partial "Integration test running"
    assert_output --partial "WARN:"
    assert_output --partial "Warning message with colors"
}

@test "library paths and sourcing work correctly" {
    run bash -c "
        source $PROJECT_ROOT/lib/main.sh
        
        echo \"LIB_DIR: \$SHELL_STARTER_LIB_DIR\"
        echo \"ROOT_DIR: \$SHELL_STARTER_ROOT_DIR\"
        
        # Verify all color constants are available
        if [[ -n \"\$COLOR_RED\" && -n \"\$COLOR_GREEN\" && -n \"\$COLOR_RESET\" ]]; then
            echo 'Colors loaded'
        else
            echo 'Colors missing'
        fi
        
        # Verify semantic colors work
        printf \"\${COLOR_SUCCESS}Success\${COLOR_RESET}\"
        echo
        printf \"\${COLOR_ERROR}Error\${COLOR_RESET}\"
        echo
    "
    assert_success
    assert_output --partial "LIB_DIR: $PROJECT_ROOT/lib"
    assert_output --partial "ROOT_DIR: $PROJECT_ROOT"
    assert_output --partial "Colors loaded"
    assert_output --partial "Success"
    assert_output --partial "Error"
}

@test "spinner integration with logging" {
    run bash -c "
        export LOG_LEVEL=INFO
        source $PROJECT_ROOT/lib/main.sh
        
        log::info 'Starting spinner test'
        spinner::start 'Processing...'
        sleep 0.1
        log::info 'Updating spinner'
        spinner::update 'Almost done...'
        sleep 0.1
        spinner::stop
        log::info 'Spinner test completed'
    "
    assert_success
    assert_output --partial "Starting spinner test"
    assert_output --partial "Updating spinner" 
    assert_output --partial "Spinner test completed"
}

@test "argument parsing integration" {
    # Test version parsing
    run bash -c "
        source $PROJECT_ROOT/lib/main.sh
        parse_common_args 'integration-test' --version
    "
    assert_success
    assert_output "integration-test 0.1.0"
    
    # Test help parsing
    run bash -c "
        source $PROJECT_ROOT/lib/main.sh
        parse_common_args 'integration-test' --help
    "
    assert_success
    assert_output --partial "Usage: integration-test [OPTIONS]"
    assert_output --partial "Shell Starter script"
}

@test "error handling across modules" {
    run bash -c "
        source $PROJECT_ROOT/lib/main.sh
        
        # Test error logging
        log::error 'Test error message'
        
        # Test utility error handling
        run::script '/non/existent/script.py' 2>&1 || echo 'Error caught'
        
        # Test spinner cleanup on error
        spinner::start 'test'
        spinner::stop
        echo 'Cleanup successful'
    "
    assert_success
    assert_output --partial "ERROR:"
    assert_output --partial "Test error message"
    assert_output --partial "Script file not found"
    assert_output --partial "Error caught"
    assert_output --partial "Cleanup successful"
}

@test "log level propagation across modules" {
    run bash -c "
        export LOG_LEVEL=WARN
        source $PROJECT_ROOT/lib/main.sh
        
        # Info should be suppressed
        log::info 'This should not appear'
        
        # Warn should appear
        log::warn 'This should appear'
        
        # Error should appear
        log::error 'This should also appear'
        
        echo 'Log test completed'
    "
    assert_success
    refute_output --partial "This should not appear"
    assert_output --partial "This should appear"
    assert_output --partial "This should also appear"
    assert_output --partial "Log test completed"
}

@test "polyglot utility integration" {
    run bash -c "
        source $PROJECT_ROOT/lib/main.sh
        
        # Create a simple shell script to test
        test_script=\"\$(mktemp --suffix=.sh)\"
        cat > \"\$test_script\" << 'EOF'
#!/bin/bash
echo \"Shell script executed with args: \$@\"
EOF
        chmod +x \"\$test_script\"
        
        # Test execution through utility
        log::info 'Testing polyglot execution'
        run::script \"\$test_script\" 'arg1' 'arg2'
        
        # Cleanup
        rm \"\$test_script\"
        log::info 'Test completed'
    "
    assert_success
    assert_output --partial "Testing polyglot execution"
    assert_output --partial "Shell script executed with args: arg1 arg2"
    assert_output --partial "Test completed"
}

@test "color and logging integration" {
    run bash -c "
        source $PROJECT_ROOT/lib/main.sh
        
        # Test that logging uses colors
        log::info 'Info with colors'
        log::warn 'Warning with colors'
        log::error 'Error with colors'
        log::debug 'Debug with colors'
    "
    assert_success
    # Should contain ANSI color codes
    assert_output --partial $'\e['
    assert_output --partial "Info with colors"
    assert_output --partial "Warning with colors"
    assert_output --partial "Error with colors"
    # Debug should not appear with default log level
    refute_output --partial "Debug with colors"
}

@test "full workflow simulation" {
    run bash -c "
        source $PROJECT_ROOT/lib/main.sh
        
        # Simulate a complete script workflow
        log::info 'Starting application'
        
        # Parse version argument
        version=\$(get_version)
        log::info \"Running version \$version\"
        
        # Start a task with spinner
        spinner::start 'Processing data...'
        sleep 0.1
        
        # Update spinner
        spinner::update 'Finalizing...'
        sleep 0.1
        
        # Stop spinner and log completion
        spinner::stop
        log::info 'Task completed successfully'
        
        # Demonstrate error handling
        log::warn 'Non-critical warning occurred'
        
        echo 'Workflow completed'
    "
    assert_success
    assert_output --partial "Starting application"
    assert_output --partial "Running version 0.1.0"
    assert_output --partial "Task completed successfully"
    assert_output --partial "Non-critical warning occurred"
    assert_output --partial "Workflow completed"
}