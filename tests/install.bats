#!/usr/bin/env bats
#
# Tests for install.sh script

# Load test helpers
load test_helper
load bats-support/load
load bats-assert/load

# Setup temporary directories for testing
setup() {
    TEST_TMP_DIR="$(mktemp -d)"
    TEST_MANIFEST_DIR="$TEST_TMP_DIR/.config/md-to-pdf"
    TEST_MANIFEST_FILE="$TEST_MANIFEST_DIR/install-manifest.txt"
    TEST_PREFIX="$TEST_TMP_DIR/test-prefix"

    # Create a mock bin directory with test scripts
    TEST_BIN_DIR="$TEST_TMP_DIR/bin"
    mkdir -p "$TEST_BIN_DIR"
    echo "#!/bin/bash\necho 'test script'" > "$TEST_BIN_DIR/test-script"
    chmod +x "$TEST_BIN_DIR/test-script"

    # Override HOME for testing
    export HOME="$TEST_TMP_DIR"
}

teardown() {
    rm -rf "$TEST_TMP_DIR"
}

# Helper function to run install.sh with test environment
run_install() {
    cd "$TEST_TMP_DIR"
    mkdir -p bin
    cp "$PROJECT_ROOT/bin/"* bin/ 2>/dev/null || true
    run "$PROJECT_ROOT/install.sh" "$@"
}

@test "install.sh: help option" {
    run_install --help
    assert_success
    assert_output --partial "md-to-pdf Installer"
    assert_output --partial "Usage:"
    assert_output --partial "OPTIONS:"
    assert_output --partial "--prefix PATH"
}

@test "install.sh: short help option" {
    run_install -h
    assert_success
    assert_output --partial "md-to-pdf Installer"
    assert_output --partial "Usage:"
}

@test "install.sh: unknown option error" {
    run_install --unknown
    assert_failure
    assert_output --partial "Unknown option: --unknown"
    assert_output --partial "md-to-pdf Installer"
}

@test "install.sh: error when bin directory missing" {
    cd "$TEST_TMP_DIR"
    rm -rf bin
    run "$PROJECT_ROOT/install.sh"
    assert_failure
    assert_output --partial "No 'bin' directory found"
    assert_output --partial "Are you running this from the project root?"
}

@test "install.sh: successful installation with custom prefix" {
    run_install --prefix "$TEST_PREFIX"
    assert_success
    assert_output --partial "Starting md-to-pdf installation"
    assert_output --partial "Installation complete"
    assert_output --partial "Scripts installed to: $TEST_PREFIX"

    # Check that scripts were installed
    assert [ -f "$TEST_PREFIX/md-to-pdf" ]
    assert [ -x "$TEST_PREFIX/md-to-pdf" ]

    # Check manifest was created
    assert [ -f "$TEST_MANIFEST_FILE" ]
    assert_output --partial "Install manifest saved to: $TEST_MANIFEST_FILE"
}

@test "install.sh: successful installation with default prefix" {
    run_install
    assert_success
    assert_output --partial "Starting md-to-pdf installation"
    assert_output --partial "Installation complete"

    # Check that scripts were installed to default location
    DEFAULT_PREFIX="$HOME/.config/md-to-pdf/bin"
    assert [ -f "$DEFAULT_PREFIX/md-to-pdf" ]
    assert [ -x "$DEFAULT_PREFIX/md-to-pdf" ]

    # Check manifest was created
    assert [ -f "$TEST_MANIFEST_FILE" ]
}

@test "install.sh: creates manifest directory if missing" {
    rm -rf "$TEST_MANIFEST_DIR"
    run_install --prefix "$TEST_PREFIX"
    assert_success
    assert [ -d "$TEST_MANIFEST_DIR" ]
    assert [ -f "$TEST_MANIFEST_FILE" ]
}

@test "install.sh: manifest contains installed files" {
    run_install --prefix "$TEST_PREFIX"
    assert_success

    # Check that manifest contains the installed scripts
    run grep "$TEST_PREFIX" "$TEST_MANIFEST_FILE"
    assert_success
    assert_output --partial "$TEST_PREFIX/"
}