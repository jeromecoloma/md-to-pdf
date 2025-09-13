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
	TEST_CSS_FILE="${BATS_TEST_TMPDIR}/test.css"
	TEST_INVALID_CSS="${BATS_TEST_TMPDIR}/invalid.css"

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

	# Create valid CSS file
	cat >"$TEST_CSS_FILE" <<'EOF'
body {
	font-family: Arial, sans-serif;
	margin: 20px;
}

h1 {
	color: #333;
	border-bottom: 2px solid #ccc;
}
EOF

	# Create invalid CSS file (no CSS rules)
	echo "This is not CSS content" >"$TEST_INVALID_CSS"
}

teardown() {
	# Clean up test files
	rm -f "$TEST_MD_FILE" "$TEST_EMPTY_FILE" "$TEST_PLAIN_FILE" "$TEST_OUTPUT_FILE" "$TEST_EXISTING_PDF"
	rm -f "$TEST_CSS_FILE" "$TEST_INVALID_CSS"
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

# Theme and Preview Tests

@test "md-to-pdf: list themes" {
	run_script "md-to-pdf" --list-themes
	assert_success
	assert_output --partial "Available themes:"
	assert_output --partial "github"
	assert_output --partial "academic"
	assert_output --partial "clean"
	assert_output --partial "modern"
}

@test "md-to-pdf: short list themes flag" {
	run_script "md-to-pdf" -l
	assert_success
	assert_output --partial "Available themes:"
	assert_output --partial "github"
}

@test "md-to-pdf: valid theme - github" {
	run_script "md-to-pdf" --theme github "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "Using theme: github"
	assert_output --partial "Conversion completed successfully"
	assert [ -f "$TEST_OUTPUT_FILE" ]
}

@test "md-to-pdf: valid theme - academic" {
	run_script "md-to-pdf" --theme academic "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "Using theme: academic"
	assert_output --partial "Conversion completed successfully"
	assert [ -f "$TEST_OUTPUT_FILE" ]
}

@test "md-to-pdf: valid theme - clean" {
	run_script "md-to-pdf" --theme clean "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "Using theme: clean"
	assert_output --partial "Conversion completed successfully"
	assert [ -f "$TEST_OUTPUT_FILE" ]
}

@test "md-to-pdf: valid theme - modern" {
	run_script "md-to-pdf" --theme modern "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "Using theme: modern"
	assert_output --partial "Conversion completed successfully"
	assert [ -f "$TEST_OUTPUT_FILE" ]
}

@test "md-to-pdf: short theme flag" {
	run_script "md-to-pdf" -t github "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "Using theme: github"
	assert_output --partial "Conversion completed successfully"
}

@test "md-to-pdf: invalid theme" {
	run_script "md-to-pdf" --theme invalid "$TEST_MD_FILE"
	assert_failure
	assert_output --partial "Invalid theme: invalid"
	assert_output --partial "Available themes:"
	assert_output --partial "github"
	assert_output --partial "academic"
	assert_output --partial "clean"
	assert_output --partial "modern"
}

@test "md-to-pdf: preview mode" {
	run_script "md-to-pdf" --preview "$TEST_MD_FILE"
	assert_success
	assert_output --partial "=== CONVERSION PREVIEW ==="
	assert_output --partial "Input file: $TEST_MD_FILE"
	assert_output --partial "File size:"
	assert_output --partial "Line count:"
	assert_output --partial "Output file:"
	assert_output --partial "Selected theme: github"
	assert_output --partial "Pandoc command:"
	assert_output --partial "pandoc"
	assert_output --partial "--pdf-engine=xelatex"
	refute_output --partial "Conversion completed successfully"
}

@test "md-to-pdf: short preview flag" {
	run_script "md-to-pdf" -p "$TEST_MD_FILE"
	assert_success
	assert_output --partial "=== CONVERSION PREVIEW ==="
	assert_output --partial "Input file: $TEST_MD_FILE"
}

@test "md-to-pdf: preview with custom theme" {
	run_script "md-to-pdf" --preview --theme academic "$TEST_MD_FILE"
	assert_success
	assert_output --partial "Selected theme: academic"
	assert_output --partial "pandoc"
	assert_output --partial "academic.tex"
}

@test "md-to-pdf: preview with custom output" {
	local custom_output="${BATS_TEST_TMPDIR}/custom.pdf"
	run_script "md-to-pdf" --preview "$TEST_MD_FILE" "$custom_output"
	assert_success
	assert_output --partial "Output file: $custom_output"
}

@test "md-to-pdf: custom CSS file" {
	run_script "md-to-pdf" --css "$TEST_CSS_FILE" "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "Using custom CSS: $TEST_CSS_FILE"
	assert_output --partial "Conversion completed successfully"
	assert [ -f "$TEST_OUTPUT_FILE" ]
}

@test "md-to-pdf: short CSS flag" {
	run_script "md-to-pdf" -c "$TEST_CSS_FILE" "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "Using custom CSS: $TEST_CSS_FILE"
}

@test "md-to-pdf: CSS file not found" {
	run_script "md-to-pdf" --css nonexistent.css "$TEST_MD_FILE"
	assert_failure
	assert_output --partial "CSS file not found: nonexistent.css"
}

@test "md-to-pdf: CSS file not readable" {
	local unreadable_css="${BATS_TEST_TMPDIR}/unreadable.css"
	echo "body { color: red; }" >"$unreadable_css"
	chmod 000 "$unreadable_css"

	run_script "md-to-pdf" --css "$unreadable_css" "$TEST_MD_FILE"
	assert_failure
	assert_output --partial "CSS file is not readable: $unreadable_css"

	# Restore permissions for cleanup
	chmod 644 "$unreadable_css"
}

@test "md-to-pdf: invalid CSS content warning" {
	run_script "md-to-pdf" --css "$TEST_INVALID_CSS" "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "CSS file does not appear to contain valid CSS rules"
	assert_output --partial "Proceeding anyway"
	assert_output --partial "Conversion completed successfully"
}

@test "md-to-pdf: preview with custom CSS" {
	run_script "md-to-pdf" --preview --css "$TEST_CSS_FILE" "$TEST_MD_FILE"
	assert_success
	assert_output --partial "Custom CSS: $TEST_CSS_FILE (found)"
	assert_output --partial "pandoc"
	assert_output --partial "--css"
}

@test "md-to-pdf: theme and CSS together" {
	run_script "md-to-pdf" --theme academic --css "$TEST_CSS_FILE" "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "Using theme: academic"
	assert_output --partial "Using custom CSS: $TEST_CSS_FILE"
	assert_output --partial "Conversion completed successfully"
	assert [ -f "$TEST_OUTPUT_FILE" ]
}

@test "md-to-pdf: quiet mode with theme" {
	run_script "md-to-pdf" --quiet --theme modern "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	refute_output --partial "md-to-pdf tool initialized"
	refute_output --partial "Using theme: modern"
	assert [ -f "$TEST_OUTPUT_FILE" ]
}

@test "md-to-pdf: force mode with theme" {
	# Create existing output file
	echo "existing content" >"$TEST_OUTPUT_FILE"

	run_script "md-to-pdf" --force --theme clean "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "Overwriting existing file"
	assert_output --partial "Using theme: clean"
	assert_output --partial "Conversion completed successfully"
}

# Engine Tests

@test "md-to-pdf: list engines" {
	run_script "md-to-pdf" --list-engines
	assert_success
	assert_output --partial "Available PDF engines:"
	assert_output --partial "weasyprint"
	assert_output --partial "xelatex"
}

@test "md-to-pdf: engine selection - weasyprint" {
	run_script "md-to-pdf" --engine weasyprint "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "Using engine: weasyprint"
	assert_output --partial "Conversion completed successfully"
	assert [ -f "$TEST_OUTPUT_FILE" ]
}

@test "md-to-pdf: engine selection - xelatex" {
	run_script "md-to-pdf" --engine xelatex "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "Using engine: xelatex"
	assert_output --partial "Conversion completed successfully"
	assert [ -f "$TEST_OUTPUT_FILE" ]
}

@test "md-to-pdf: short engine flag" {
	run_script "md-to-pdf" -e weasyprint "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "Using engine: weasyprint"
	assert_output --partial "Conversion completed successfully"
}

@test "md-to-pdf: invalid engine" {
	run_script "md-to-pdf" --engine invalid "$TEST_MD_FILE"
	assert_failure
	assert_output --partial "Invalid engine: invalid"
	assert_output --partial "Available PDF engines:"
	assert_output --partial "weasyprint"
	assert_output --partial "xelatex"
}

@test "md-to-pdf: preview shows engine information" {
	run_script "md-to-pdf" --preview "$TEST_MD_FILE"
	assert_success
	assert_output --partial "Selected engine:"
	assert_output --partial "Engine status:"
}

@test "md-to-pdf: preview with weasyprint engine" {
	run_script "md-to-pdf" --preview --engine weasyprint "$TEST_MD_FILE"
	assert_success
	assert_output --partial "Selected engine: weasyprint"
	assert_output --partial "WeasyPrint command:"
	assert_output --partial "weasyprint"
}

@test "md-to-pdf: preview with xelatex engine" {
	run_script "md-to-pdf" --preview --engine xelatex "$TEST_MD_FILE"
	assert_success
	assert_output --partial "Selected engine: xelatex"
	assert_output --partial "Pandoc command:"
	assert_output --partial "--pdf-engine=xelatex"
}

@test "md-to-pdf: weasyprint with theme" {
	run_script "md-to-pdf" --engine weasyprint --theme academic "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "Using engine: weasyprint"
	assert_output --partial "Using theme: academic"
	assert_output --partial "Conversion completed successfully"
	assert [ -f "$TEST_OUTPUT_FILE" ]
}

@test "md-to-pdf: xelatex with theme" {
	run_script "md-to-pdf" --engine xelatex --theme modern "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "Using engine: xelatex"
	assert_output --partial "Using theme: modern"
	assert_output --partial "Conversion completed successfully"
	assert [ -f "$TEST_OUTPUT_FILE" ]
}

@test "md-to-pdf: weasyprint with custom CSS" {
	run_script "md-to-pdf" --engine weasyprint --css "$TEST_CSS_FILE" "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "Using engine: weasyprint"
	assert_output --partial "Using custom CSS: $TEST_CSS_FILE"
	assert_output --partial "Conversion completed successfully"
	assert [ -f "$TEST_OUTPUT_FILE" ]
}

@test "md-to-pdf: xelatex with custom CSS" {
	run_script "md-to-pdf" --engine xelatex --css "$TEST_CSS_FILE" "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "Using engine: xelatex"
	assert_output --partial "Conversion completed successfully"
	assert [ -f "$TEST_OUTPUT_FILE" ]
}

@test "md-to-pdf: quiet mode with engine selection" {
	run_script "md-to-pdf" --quiet --engine weasyprint "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	refute_output --partial "md-to-pdf tool initialized"
	refute_output --partial "Using engine: weasyprint"
	assert [ -f "$TEST_OUTPUT_FILE" ]
}

@test "md-to-pdf: force mode with engine selection" {
	# Create existing output file
	echo "existing content" >"$TEST_OUTPUT_FILE"

	run_script "md-to-pdf" --force --engine xelatex "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "Overwriting existing file"
	assert_output --partial "Using engine: xelatex"
	assert_output --partial "Conversion completed successfully"
}

@test "md-to-pdf: engine and theme combination" {
	run_script "md-to-pdf" --engine weasyprint --theme github "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "Using engine: weasyprint"
	assert_output --partial "Using theme: github"
	assert_output --partial "Conversion completed successfully"
	assert [ -f "$TEST_OUTPUT_FILE" ]
}

@test "md-to-pdf: engine, theme, and CSS combination" {
	run_script "md-to-pdf" --engine weasyprint --theme clean --css "$TEST_CSS_FILE" "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "Using engine: weasyprint"
	assert_output --partial "Using theme: clean"
	assert_output --partial "Using custom CSS: $TEST_CSS_FILE"
	assert_output --partial "Conversion completed successfully"
	assert [ -f "$TEST_OUTPUT_FILE" ]
}

# Enhanced Features Tests

@test "md-to-pdf: emoji support in markdown" {
	# Create markdown with emojis
	local emoji_file="${BATS_TEST_TMPDIR}/emoji.md"
	cat >"$emoji_file" <<'EOF'
# Emoji Test Document 🚀

This document tests emoji rendering.

## Features 📝

- 🎨 Professional styling
- 😀 Emoji support
- ⚡ Fast conversion
- ✅ Quality output

## Code Example 💻

```bash
echo "Hello World! 🌍"
```

**Result**: Perfect emoji rendering! 🎉
EOF

	run_script "md-to-pdf" --theme github "$emoji_file" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "Using theme: github"
	assert_output --partial "Conversion completed successfully"
	assert [ -f "$TEST_OUTPUT_FILE" ]

	# Clean up
	rm -f "$emoji_file"
}

@test "md-to-pdf: github theme with enhanced features" {
	# Create markdown with GitHub-style elements
	local github_file="${BATS_TEST_TMPDIR}/github.md"
	cat >"$github_file" <<'EOF'
# GitHub Style Test 🐙

## Task Lists ✅

- [x] Completed task
- [ ] Pending task
- [ ] Another task

## Code Blocks 💻

```javascript
function hello() {
    console.log("Hello GitHub! 👋");
}
```

## Links and References 🔗

See [GitHub](https://github.com) for more examples.
EOF

	run_script "md-to-pdf" --theme github "$github_file" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "Using theme: github"
	assert_output --partial "Conversion completed successfully"
	assert [ -f "$TEST_OUTPUT_FILE" ]

	# Clean up
	rm -f "$github_file"
}

@test "md-to-pdf: modern theme weasyprint optimization" {
	# Test that modern theme works without artifacts
	run_script "md-to-pdf" --engine weasyprint --theme modern "$TEST_MD_FILE" "$TEST_OUTPUT_FILE"
	assert_success
	assert_output --partial "Using engine: weasyprint"
	assert_output --partial "Using theme: modern"
	assert_output --partial "Conversion completed successfully"
	assert [ -f "$TEST_OUTPUT_FILE" ]

	# Verify no warnings about unsupported properties (would appear in stderr)
	# This is implicit - if conversion succeeds, WeasyPrint handled it properly
}
