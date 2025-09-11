# Testing Framework

This directory contains the test suite for Shell Starter using [Bats-core](https://github.com/bats-core/bats-core).

## Setup

The testing framework is set up using git submodules. To initialize:

```bash
./scripts/setup-bats.sh
```

This installs:
- `bats-core/` - Main Bats testing framework
- `bats-support/` - Additional test helpers
- `bats-assert/` - Assertion helpers

## Running Tests

```bash
# Run all tests
./tests/run-tests.sh

# Run specific test file
./tests/run-tests.sh tests/framework.bats

# Run tests directly with Bats
./tests/bats-core/bin/bats tests/*.bats
```

## Test Structure

- `test_helper.bash` - Common setup and utility functions for all tests
- `framework.bats` - Tests that verify the testing framework itself is working
- `*.bats` - Individual test files for specific components

## Writing Tests

Tests use the standard Bats format:

```bash
#!/usr/bin/env bats

# Load helpers
load test_helper
load bats-support/load
load bats-assert/load

@test "test description" {
    run your_command
    assert_success
    assert_output "expected output"
}
```

See the [Bats documentation](https://bats-core.readthedocs.io/) for more details.