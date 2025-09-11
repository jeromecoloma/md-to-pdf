# Local CI Testing with Act

This document provides instructions for running GitHub Actions locally using `act`.

## Installation

`act` is already installed and configured on this system with an alias for Apple M-series compatibility:
```bash
act -P ubuntu-latest=shivammathur/node:latest
```

## Usage

### List available jobs
```bash
act --list
```

### Run all CI jobs (push event)
```bash
act push --container-architecture linux/amd64
```

### Run specific job
```bash
act -j shellcheck --container-architecture linux/amd64
act -j shfmt --container-architecture linux/amd64
act -j test --container-architecture linux/amd64
```

### Run for pull request event
```bash
act pull_request --container-architecture linux/amd64
```

## Notes

- Use `--container-architecture linux/amd64` for Apple M-series compatibility
- **Expected shellcheck output**:
  - Should pass cleanly (no errors/warnings) thanks to the `.shellcheckrc` configuration
  - The config file suppresses expected warnings for shell library projects
- **Expected shfmt output**:
  - Should pass cleanly (no formatting differences)
  - All files follow consistent formatting standards enforced by shfmt
- **Expected test output**:
  - Should show all 96+ tests passing with "ok" status
  - Test results displayed in TAP (Test Anything Protocol) format
  - Job fails if any tests fail - **Expected** (ensures code quality)
- The CI validates that linting, formatting, and testing tools are working correctly

## Shellcheck Configuration

The project includes a `.shellcheckrc` file that configures shellcheck for this project's needs:
- Ignores `SC2034` (unused variables) since libraries define variables for external use
- Ignores `SC1091` (sourcing files) which is normal when analyzing files individually
- Ignores various style/info warnings that don't affect functionality