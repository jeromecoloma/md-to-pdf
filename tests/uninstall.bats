#!/usr/bin/env bats
#
# Tests for uninstall.sh script

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

    # Override HOME for testing
    export HOME="$TEST_TMP_DIR"
}

teardown() {
    rm -rf "$TEST_TMP_DIR"
}

# Helper function to run uninstall.sh
run_uninstall() {
    run env HOME="$TEST_TMP_DIR" "$PROJECT_ROOT/uninstall.sh" "$@"
}

# Helper function to create mock installation
create_mock_installation() {
    mkdir -p "$TEST_MANIFEST_DIR"
    mkdir -p "$TEST_PREFIX"

    # Create manifest file
    cat > "$TEST_MANIFEST_FILE" << EOF
# md-to-pdf Install Manifest
# Generated on $(date)
# Install prefix: $TEST_PREFIX

$TEST_PREFIX/test-script1
$TEST_PREFIX/test-script2
EOF

    # Create mock installed scripts
    echo "#!/bin/bash\necho 'test script 1'" > "$TEST_PREFIX/test-script1"
    echo "#!/bin/bash\necho 'test script 2'" > "$TEST_PREFIX/test-script2"
    chmod +x "$TEST_PREFIX/test-script1" "$TEST_PREFIX/test-script2"
}

@test "uninstall.sh: help option" {
    run_uninstall --help
    assert_success
    assert_output --partial "md-to-pdf Uninstaller"
    assert_output --partial "Usage:"
    assert_output --partial "OPTIONS:"
    assert_output --partial "--force"
}

@test "uninstall.sh: short help option" {
    run_uninstall -h
    assert_success
    assert_output --partial "md-to-pdf Uninstaller"
    assert_output --partial "Usage:"
}

@test "uninstall.sh: unknown option error" {
    run_uninstall --unknown
    assert_failure
    assert_output --partial "Unknown option: --unknown"
    assert_output --partial "md-to-pdf Uninstaller"
}

@test "uninstall.sh: error when manifest missing" {
    run_uninstall
    assert_failure
    assert_output --partial "No installation manifest found"
    assert_output --partial "Either md-to-pdf was never installed"
}



@test "uninstall.sh: successful uninstallation with force" {
    create_mock_installation

    run_uninstall --force
    assert_success
    assert_output --partial "Starting md-to-pdf uninstallation"
    assert_output --partial "Uninstallation complete"
    assert_output --partial "All md-to-pdf files have been removed"

    # Check that scripts were removed
    assert [ ! -f "$TEST_PREFIX/test-script1" ]
    assert [ ! -f "$TEST_PREFIX/test-script2" ]

    # Check that manifest was removed
    assert [ ! -f "$TEST_MANIFEST_FILE" ]
}

@test "uninstall.sh: force flag variants" {
    create_mock_installation

    # Test -y flag
    run_uninstall -y
    assert_success
    assert_output --partial "Force removal enabled"
}

@test "uninstall.sh: shows files to be removed" {
    create_mock_installation

    run_uninstall --force
    assert_success
    assert_output --partial "The following files will be removed:"
    assert_output --partial "test-script1"
    assert_output --partial "test-script2"
}

@test "uninstall.sh: handles missing files gracefully" {
    create_mock_installation
    # Remove one of the files to simulate it being already deleted
    rm "$TEST_PREFIX/test-script1"

    run_uninstall --force
    assert_success
    assert_output --partial "File not found (already removed?)"
    assert_output --partial "were already missing"
}

@test "uninstall.sh: removes manifest directory when empty" {
    create_mock_installation

    run_uninstall --force
    assert_success

    # Manifest directory should be removed since it's empty
    assert [ ! -d "$TEST_MANIFEST_DIR" ]
}

@test "uninstall.sh: keeps manifest directory when not empty" {
    create_mock_installation
    # Add another file to the manifest directory
    echo "other file" > "$TEST_MANIFEST_DIR/other-file"

    run_uninstall --force
    assert_success

    # Manifest directory should still exist
    assert [ -d "$TEST_MANIFEST_DIR" ]
    assert [ -f "$TEST_MANIFEST_DIR/other-file" ]
}

@test "uninstall.sh: removes PATH entry from shell config" {
    create_mock_installation

    # Create mock shell config with PATH entry
    local shell_name
    shell_name=$(basename "$SHELL")
    local mock_config

    case "$shell_name" in
        zsh)
            mock_config="$TEST_TMP_DIR/.zshrc"
            ;;
        bash)
            mock_config="$TEST_TMP_DIR/.bashrc"
            ;;
        *)
            mock_config="$TEST_TMP_DIR/.bashrc"
            ;;
    esac

    # Add PATH entry to mock config
    echo "# Added by md-to-pdf installer" >"$mock_config"
    echo "export PATH=\"$TEST_PREFIX:\$PATH\"" >>"$mock_config"

    run_uninstall --force
    assert_success

    # Check that PATH entry was removed
    run grep "export PATH=\"$TEST_PREFIX:\$PATH\"" "$mock_config"
    assert_failure  # Should not find the PATH entry
}