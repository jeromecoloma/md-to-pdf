#!/usr/bin/env bats
#
# Tests for md-to-pdf script

# Load test helpers
load test_helper
load bats-support/load
load bats-assert/load

setup() {
	# Create test files
	TEST_MD_FILE="${BATS_TEST_TMPDIR}/test.md"
	TEST_EMPTY_FILE="${BATS_TEST_TMPDIR}/empty.md"
	TEST_PLAIN_FILE="${BATS_TEST_TMPDIR}/plain.txt"
	TEST_OUTPUT_FILE="${BATS_TEST_TMPDIR}/output.pdf"
	TEST_EXISTING_PDF="${BATS_TEST_TMPDIR}/existing.pdf"

	# Create test markdown content
	cat >"$TEST_MD_FILE" <<'EOF'
# Test Document

This is a test markdown file for automated testing.

## Features

- Lists
- **Bold text**
- *Italic text*
- `Code`

## Code Block

```bash
echo "Hello World"
```
EOF

	# Create empty file
	touch "$TEST_EMPTY_FILE"

	# Create plain text file
	echo "This is plain text without markdown formatting." >"$TEST_PLAIN_FILE"

	# Create existing PDF file (dummy)
	echo "dummy pdf content" >"$TEST_EXISTING_PDF"
}

teardown() {
	# Clean up test files
	rm -f "$TEST_MD_FILE" "$TEST_EMPTY_FILE" "$TEST_PLAIN_FILE" "$TEST_OUTPUT_FILE" "$TEST_EXISTING_PDF"
	rm -f "${BATS_TEST_TMPDIR}"/*.pdf
}

@test "md-to-pdf: basic conversion succeeds" {
	run_script "md-to-pdf" "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "md-to-pdf tool initialized"
	assert_output --partial "Starting markdown to PDF conversion"
	assert_output --partial "Conversion completed successfully"
	assert_output --partial "Output saved to:"
	# Check that output file was created
	assert [ -f "$TEST_OUTPUT_FILE" ]
}

@test "md-to-pdf: default output filename" {
	run_script "md-to-pdf" "$TEST_MD_FILE"
	assert_success
	# Should create test.pdf in the same directory as input
	local expected_output="${TEST_MD_FILE%.*}.pdf"
	assert [ -f "$expected_output" ]
	# Clean up
	rm -f "$expected_output"
}

@test "md-to-pdf: help flag" {
	run_script "md-to-pdf" --help
	assert_success
	assert_output --partial "Usage:"
	assert_output --partial "md-to-pdf"
	assert_output --partial "OPTIONS:"
	assert_output --partial "EXAMPLES:"
	assert_output --partial "--force"
}

@test "md-to-pdf: short help flag" {
	run_script "md-to-pdf" -h
	assert_success
	assert_output --partial "Usage:"
}

@test "md-to-pdf: version flag" {
	run_script "md-to-pdf" --version
	assert_success
	assert_output --partial "md-to-pdf"
	assert_output --partial "0.1.0"
}

@test "md-to-pdf: short version flag" {
	run_script "md-to-pdf" -v
	assert_success
	assert_output --partial "md-to-pdf"
	assert_output --partial "0.1.0"
}

@test "md-to-pdf: quiet mode" {
	run_script "md-to-pdf" --quiet "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	# In quiet mode, should not have verbose output
	refute_output --partial "md-to-pdf tool initialized"
	refute_output --partial "Starting markdown to PDF conversion"
	# Check that output file was created
	assert [ -f "$TEST_OUTPUT_FILE" ]
}

@test "md-to-pdf: short quiet flag" {
	run_script "md-to-pdf" -q "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	refute_output --partial "md-to-pdf tool initialized"
	# Check that output file was created
	assert [ -f "$TEST_OUTPUT_FILE" ]
}

@test "md-to-pdf: force flag with existing file" {
	# Create existing output file
	echo "existing content" >"$TEST_OUTPUT_FILE"

	run_script "md-to-pdf" --force "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "Overwriting existing file"
	assert_output --partial "Conversion completed successfully"
}

@test "md-to-pdf: short force flag" {
	# Create existing output file
	echo "existing content" >"$TEST_OUTPUT_FILE"

	run_script "md-to-pdf" -f "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "Overwriting existing file"
}

@test "md-to-pdf: missing input file" {
	run_script "md-to-pdf" "nonexistent.md"
	assert_failure
	assert_output --partial "Cannot read input file: nonexistent.md"
	assert_output --partial "File does not exist"
}

@test "md-to-pdf: no arguments" {
	run_script "md-to-pdf"
	assert_failure
	assert_output --partial "Input file is required"
	assert_output --partial "Use --help for usage information"
}

@test "md-to-pdf: empty input file" {
	run_script "md-to-pdf" "$TEST_EMPTY_FILE"
	assert_failure
	assert_output --partial "Input file is empty"
	assert_output --partial "Please provide a markdown file with content"
}

@test "md-to-pdf: plain text file warning" {
	run_script "md-to-pdf" "$TEST_PLAIN_FILE"
	assert_success
	assert_output --partial "Input file does not have .md or .markdown extension"
	assert_output --partial "Input file does not appear to contain markdown formatting"
	assert_output --partial "Proceeding anyway"
	assert_output --partial "Conversion completed successfully"
}

@test "md-to-pdf: unknown option" {
	run_script "md-to-pdf" --unknown "$TEST_MD_FILE"
	assert_failure
	assert_output --partial "Unknown option: --unknown"
	assert_output --partial "Use --help for usage information"
}

@test "md-to-pdf: unknown short option" {
	run_script "md-to-pdf" -x "$TEST_MD_FILE"
	assert_failure
	assert_output --partial "Unknown option: -x"
	assert_output --partial "Use --help for usage information"
}

@test "md-to-pdf: too many arguments" {
	run_script "md-to-pdf" "$TEST_MD_FILE" "output.pdf" "extra_arg"
	assert_failure
	assert_output --partial "Too many arguments"
	assert_output --partial "Use --help for usage information"
}

@test "md-to-pdf: custom output with .pdf extension" {
	local custom_output="${BATS_TEST_TMPDIR}/custom.pdf"
	run_script "md-to-pdf" "$TEST_MD_FILE" "$custom_output"
	assert_success
	assert_output --partial "Output saved to: $custom_output"
	assert [ -f "$custom_output" ]
}

@test "md-to-pdf: quiet with force" {
	# Create existing output file
	echo "existing content" >"$TEST_OUTPUT_FILE"

	run_script "md-to-pdf" --quiet --force "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	# Should not have verbose output
	refute_output --partial "md-to-pdf tool initialized"
	# Check that output file was created/overwritten
	assert [ -f "$TEST_OUTPUT_FILE" ]
}

@test "md-to-pdf: includes success log message" {
	run_script "md-to-pdf" "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "md-to-pdf conversion completed successfully!"
}

@test "md-to-pdf: complex markdown content" {
	# Create complex markdown
	local complex_file="${BATS_TEST_TMPDIR}/complex.md"
	cat >"$complex_file" <<'EOF'
# Complex Test

## Math
$$E = mc^2$$

## Table
| A | B |
|---|---|
| 1 | 2 |

## Code
```python
print("Hello")
```
EOF

	run_script "md-to-pdf" "$complex_file"
	assert_success
	assert_output --partial "Conversion completed successfully"

	# Clean up
	rm -f "${complex_file%.*}.pdf"
}
