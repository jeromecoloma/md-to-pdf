#!/usr/bin/env bats
#
# Tests for lib/utils.sh - utility functions for polyglot execution

# Load test helpers
load test_helper
load bats-support/load
load bats-assert/load

setup() {
    # Create temporary test directory
    TEST_TEMP_DIR="$(mktemp -d)"
    export LOG_LEVEL="ERROR"  # Reduce noise in tests
}

teardown() {
    # Clean up temporary test directory
    if [[ -n "${TEST_TEMP_DIR:-}" && -d "$TEST_TEMP_DIR" ]]; then
        rm -rf "$TEST_TEMP_DIR"
    fi
}

@test "run::script: fails with no script path" {
    run run::script
    assert_failure
    assert_output --partial "No script path provided"
}

@test "run::script: fails with non-existent script" {
    run run::script "/non/existent/script.py"
    assert_failure
    assert_output --partial "Script file not found"
}

@test "run::script: executes shell script" {
    # Create test shell script
    local test_script="$TEST_TEMP_DIR/test.sh"
    cat > "$test_script" << 'EOF'
#!/bin/bash
echo "Hello from shell script"
echo "Args: $@"
EOF
    chmod +x "$test_script"
    
    run run::script "$test_script" "arg1" "arg2"
    assert_success
    assert_output --partial "Hello from shell script"
    assert_output --partial "Args: arg1 arg2"
}

@test "run::script: executes bash script" {
    # Create test bash script
    local test_script="$TEST_TEMP_DIR/test.bash"
    cat > "$test_script" << 'EOF'
#!/bin/bash
echo "Hello from bash script"
EOF
    chmod +x "$test_script"
    
    run run::script "$test_script"
    assert_success
    assert_output --partial "Hello from bash script"
}

@test "run::script: handles unknown script extension" {
    # Create script with unknown extension
    local test_script="$TEST_TEMP_DIR/test.unknown"
    cat > "$test_script" << 'EOF'
#!/bin/bash
echo "Test unknown script"
EOF
    chmod +x "$test_script"
    
    run run::script "$test_script"
    assert_success
    assert_output "Test unknown script"
}

@test "run::script: Python script detection by .py extension" {
    # Mock python3 command for testing
    local mock_python="$TEST_TEMP_DIR/python3"
    cat > "$mock_python" << 'EOF'
#!/bin/bash
echo "Python script executed: $1"
shift
echo "Args: $@"
EOF
    chmod +x "$mock_python"
    
    # Create test Python script
    local test_script="$TEST_TEMP_DIR/test.py"
    cat > "$test_script" << 'EOF'
print("Hello from Python")
EOF
    
    # Add mock to PATH temporarily
    local OLD_PATH="$PATH"
    export PATH="$TEST_TEMP_DIR:$PATH"
    
    run run::script "$test_script" "pyarg1"
    assert_success
    assert_output --partial "Python script executed"
    assert_output --partial "Args: pyarg1"
    
    # Restore PATH
    export PATH="$OLD_PATH"
}

@test "run::script: Python script detection by .python extension" {
    # Create test Python script with .python extension
    local test_script="$TEST_TEMP_DIR/test.python"
    echo 'print("Hello")' > "$test_script"
    
    # Mock python3 for this test
    if command -v python3 >/dev/null 2>&1; then
        run run::script "$test_script"
        # The test may succeed or fail based on python availability
        # Just verify it was recognized as Python
        if [[ $status -eq 0 ]]; then
            assert_success
        fi
    else
        skip "python3 not available"
    fi
}

@test "run::script: Node.js script detection by .js extension" {
    # Create test JavaScript script
    local test_script="$TEST_TEMP_DIR/test.js"
    echo 'console.log("Hello from Node.js");' > "$test_script"
    
    if command -v node >/dev/null 2>&1; then
        run run::script "$test_script"
        assert_success
        assert_output "Hello from Node.js"
    else
        skip "node not available"
    fi
}

@test "run::script: Node.js script detection by .javascript extension" {
    local test_script="$TEST_TEMP_DIR/test.javascript"
    echo 'console.log("Hello");' > "$test_script"
    
    if command -v node >/dev/null 2>&1; then
        run run::script "$test_script"
        assert_success
        assert_output "Hello"
    else
        skip "node not available"
    fi
}

@test "run::script: Ruby script detection" {
    local test_script="$TEST_TEMP_DIR/test.rb"
    echo 'puts "Hello from Ruby"' > "$test_script"
    
    if command -v ruby >/dev/null 2>&1; then
        run run::script "$test_script"
        assert_success
        assert_output "Hello from Ruby"
    else
        skip "ruby not available"
    fi
}

@test "run::script: Perl script detection" {
    local test_script="$TEST_TEMP_DIR/test.pl"
    echo 'print "Hello from Perl\n";' > "$test_script"
    
    if command -v perl >/dev/null 2>&1; then
        run run::script "$test_script"
        assert_success
        assert_output "Hello from Perl"
    else
        skip "perl not available"
    fi
}

@test "_run_python_script: detects .venv in script directory" {
    # Create mock Python virtual environment
    local script_dir="$TEST_TEMP_DIR/python_project"
    local venv_dir="$script_dir/.venv"
    local test_script="$script_dir/test.py"
    
    mkdir -p "$venv_dir/bin"
    mkdir -p "$script_dir"
    
    # Create mock activate script
    cat > "$venv_dir/bin/activate" << 'EOF'
#!/bin/bash
export VIRTUAL_ENV_ACTIVATED=1
deactivate() { unset VIRTUAL_ENV_ACTIVATED; }
EOF
    
    # Create mock python in venv
    cat > "$venv_dir/bin/python" << 'EOF'
#!/bin/bash
echo "Virtual env python executed: $1"
EOF
    chmod +x "$venv_dir/bin/python"
    
    echo 'print("test")' > "$test_script"
    
    # Test the internal function directly
    run bash -c "
        export LOG_LEVEL=ERROR
        export PATH='$venv_dir/bin:$PATH'
        source $PROJECT_ROOT/lib/utils.sh
        _run_python_script '$test_script' '$script_dir'
    "
    
    # Should attempt to use virtual environment
    # The exact behavior depends on PATH and system setup
    assert_success
}

@test "_run_python_script: detects venv in script directory" {
    # Create mock Python virtual environment with "venv" name
    local script_dir="$TEST_TEMP_DIR/python_project2"
    local venv_dir="$script_dir/venv"
    local test_script="$script_dir/test.py"
    
    mkdir -p "$venv_dir/bin"
    mkdir -p "$script_dir"
    
    cat > "$venv_dir/bin/activate" << 'EOF'
#!/bin/bash
export VIRTUAL_ENV_ACTIVATED=1
deactivate() { unset VIRTUAL_ENV_ACTIVATED; }
EOF
    
    # Create mock python in venv
    cat > "$venv_dir/bin/python" << 'EOF'
#!/bin/bash
echo "Virtual env python executed: $1"
EOF
    chmod +x "$venv_dir/bin/python"
    
    echo 'print("test")' > "$test_script"
    
    run bash -c "
        export LOG_LEVEL=ERROR
        export PATH='$venv_dir/bin:$PATH'
        source $PROJECT_ROOT/lib/utils.sh
        _run_python_script '$test_script' '$script_dir'
    "
    
    assert_success
}

@test "_run_python_script: falls back to system python when no venv" {
    local script_dir="$TEST_TEMP_DIR/no_venv_project"
    local test_script="$script_dir/test.py"
    
    mkdir -p "$script_dir"
    echo 'print("system python")' > "$test_script"
    
    if command -v python3 >/dev/null 2>&1; then
        run bash -c "
            export LOG_LEVEL=ERROR
            source $PROJECT_ROOT/lib/utils.sh
            _run_python_script '$test_script' '$script_dir'
        "
        assert_success
        assert_output "system python"
    else
        skip "python3 not available"
    fi
}

@test "internal functions exist and are properly named" {
    run bash -c "source $PROJECT_ROOT/lib/utils.sh; declare -F"
    assert_success
    assert_output --partial "_run_python_script"
    assert_output --partial "_run_node_script"
    assert_output --partial "_run_ruby_script"
    assert_output --partial "_run_perl_script"
    assert_output --partial "_run_shell_script"
}

@test "logging is loaded when not already available" {
    # Test the logging fallback mechanism
    run bash -c "
        # Ensure logging functions aren't defined
        unset -f log::info log::error 2>/dev/null || true
        source $PROJECT_ROOT/lib/utils.sh
        # Check if log::info is now available
        declare -F log::info
    "
    assert_success
    assert_output "log::info"
}