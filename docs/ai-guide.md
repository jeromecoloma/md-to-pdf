# Shell Starter - AI Development Guide

This guide provides AI coding assistants with the information needed to generate compliant Shell Starter scripts. It includes prompt templates, examples, and best practices for AI-assisted development.

## 🔄 Autonomous AI Development

**New!** Shell Starter includes `generate-ai-workflow` - a tool that creates autonomous AI development workflows:

### Quick Setup for Any Project

```bash
# Generate autonomous development workflow
./bin/generate-ai-workflow my-cli-tool

# Install commands for your AI coding agent
mkdir -p .claude && cp -r .ai-workflow/commands/.claude/commands .claude/     # Claude Code
mkdir -p .cursor && cp -r .ai-workflow/commands/.cursor/commands .cursor/     # Cursor
mkdir -p .gemini && cp -r .ai-workflow/commands/.gemini/commands .gemini/     # Gemini CLI

# Customize project requirements
vim .ai-workflow/state/requirements.md

# Start autonomous development
/dev start
```

### Autonomous AI Commands

- **`/dev start`**: Begin self-managing development cycle
- **`/qa`**: Run comprehensive quality assurance  
- **`/status`**: Show current project status

The AI will automatically:
- Break down tasks and track progress
- **Implement core functionality first** (preventing wrapper scripts that don't work)
- Follow Shell Starter conventions for professional CLI experience
- Run quality checks (shellcheck, shfmt, testing)
- Resume development across context resets
- Provide detailed progress reports

See [Markdown to PDF Converter Journey](journeys/ai-assisted/md-to-pdf.md) for a complete example.

### PRD Generation

For creating comprehensive Product Requirements Documents, use the [PRD Generation Guide](prompting-guide.md) which provides:
- Copy-paste ready prompt templates
- Domain-specific customization guidelines  
- Quality checklists for AI-ready requirements
- Examples for different project types

## 🤖 AI Assistant Guidelines

### Core Principles
- **Implement functional core logic first** - ensure the tool actually works before polishing
- Always follow the conventions in `docs/conventions.md`
- Use the library functions from `lib/main.sh`
- Include proper error handling and input validation
- Provide comprehensive help text and examples
- Follow the standard script structure template

### Development Workflow
1. **Define and implement core functionality first** - what does this tool actually do?
2. Read existing scripts in `bin/` for patterns
3. Use the standard script template
4. Include all required argument parsing
5. Add appropriate logging and error handling
6. Test with various inputs and edge cases

## 📝 Prompt Templates

### 1. Basic Script Generation Prompt

```
Create a Shell Starter script named "SCRIPT_NAME" that does the following:
- [Describe functionality]
- [List specific requirements]
- [Mention any special features]

Requirements:
- Follow Shell Starter conventions from docs/conventions.md
- Use the standard script template with proper header
- Include comprehensive help text with examples
- Use logging functions (log::info, log::error, etc.) instead of echo
- Include proper argument parsing with --help and --version
- Add input validation where appropriate
- Handle errors gracefully with meaningful messages

The script should be saved as bin/SCRIPT_NAME (no .sh extension).
```

### 2. Library Function Enhancement Prompt

```
Add a new function to Shell Starter's library system:

Function: FUNCTION_NAME
Purpose: [Describe what the function does]
Parameters: [List parameters and their types]
Return: [Describe return value or behavior]

Requirements:
- Add to appropriate lib/*.sh file or create new file if needed
- Follow naming convention (use :: namespace separator)
- Include parameter validation
- Use existing color/logging functions for output
- Add comprehensive error handling
- Source the new file in lib/main.sh if it's a new file
- Follow the coding style from existing library functions
```

### 3. Test Generation Prompt

```
Create comprehensive Bats tests for the Shell Starter script "SCRIPT_NAME".

The tests should cover:
- Help and version output
- Default behavior
- All command-line options
- Error conditions and edge cases
- Input validation

Requirements:
- Save as tests/SCRIPT_NAME.bats
- Use proper Bats test structure
- Include setup() and teardown() functions
- Test both success and failure scenarios
- Verify exit codes and output content
- Follow the testing patterns from existing test files
```

## 🎯 Golden Examples

### Complete Script Template

Use this as the foundation for any new Shell Starter script:

```bash
#!/bin/bash

# SCRIPT_NAME - Brief description of what the script does
# Optional: Longer description with usage examples

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHELL_STARTER_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

source "${SHELL_STARTER_ROOT}/lib/main.sh"

show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] [ARGUMENTS]

Brief description of what the script does.

ARGUMENTS:
    ARG1              Description of first argument
    ARG2              Description of second argument (optional)

OPTIONS:
    -h, --help        Show this help message and exit
    -v, --version     Show version information and exit
    -q, --quiet       Suppress verbose output
    -f, --force       Force operation without confirmation
    --option VALUE    Description of custom option

EXAMPLES:
    $(basename "$0") --help
    $(basename "$0") --version
    $(basename "$0") arg1 arg2
    $(basename "$0") --quiet --force arg1
EOF
}

validate_input() {
    local input="$1"
    local input_type="$2"
    
    case "$input_type" in
        "file")
            if [[ ! -r "$input" ]]; then
                log::error "Cannot read file: $input"
                return 1
            fi
            ;;
        "directory")
            if [[ ! -d "$input" ]]; then
                log::error "Directory does not exist: $input"
                return 1
            fi
            ;;
        "non_empty")
            if [[ -z "$input" ]]; then
                log::error "Input cannot be empty"
                return 1
            fi
            ;;
    esac
    
    return 0
}

main() {
    # Default values
    local quiet=false
    local force=false
    local custom_option=""
    local arg1=""
    local arg2=""
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--version)
                echo "$(basename "$0") $(get_version)"
                exit 0
                ;;
            -q|--quiet)
                quiet=true
                shift
                ;;
            -f|--force)
                force=true
                shift
                ;;
            --option)
                custom_option="$2"
                shift 2
                ;;
            -*)
                log::error "Unknown option: $1"
                show_help
                exit 1
                ;;
            *)
                # Positional arguments
                if [[ -z "$arg1" ]]; then
                    arg1="$1"
                elif [[ -z "$arg2" ]]; then
                    arg2="$1"
                else
                    log::error "Too many arguments"
                    show_help
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # Validate required arguments
    if [[ -z "$arg1" ]]; then
        log::error "ARG1 is required"
        show_help
        exit 1
    fi
    
    # Validate inputs
    if ! validate_input "$arg1" "non_empty"; then
        exit 1
    fi
    
    # Main script logic
    if [[ "$quiet" != true ]]; then
        log::info "Starting $(basename "$0")..."
    fi
    
    # Example of using spinner for long operations
    if [[ "$quiet" != true ]]; then
        spinner::start "Processing $arg1"
    fi
    
    # Simulate work
    sleep 1
    
    if [[ "$quiet" != true ]]; then
        spinner::stop
        log::success "Processing completed successfully"
    fi
    
    # Example conditional logic
    if [[ "$force" == true ]]; then
        log::warn "Force mode enabled - skipping confirmations"
    fi
    
    if [[ -n "$custom_option" ]]; then
        log::info "Using custom option: $custom_option"
    fi
    
    # Output results
    echo "Result: processed $arg1"
    if [[ -n "$arg2" ]]; then
        echo "Additional: $arg2"
    fi
}

# Only run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
```

### Library Function Template

Use this pattern for adding new library functions:

```bash
# lib/new-feature.sh - Description of the new feature

# Check if already sourced to prevent double-sourcing
[[ -n "${SHELL_STARTER_NEW_FEATURE_LOADED:-}" ]] && return 0
readonly SHELL_STARTER_NEW_FEATURE_LOADED=1

# Source dependencies
source "${SHELL_STARTER_ROOT}/lib/colors.sh"
source "${SHELL_STARTER_ROOT}/lib/logging.sh"

# Function to do something useful
new_feature::do_something() {
    local param1="$1"
    local param2="${2:-default_value}"
    
    # Validate parameters
    if [[ -z "$param1" ]]; then
        log::error "Parameter 1 is required"
        return 1
    fi
    
    # Function logic here
    log::info "Doing something with $param1"
    
    # Return success
    return 0
}

# Function to validate something
new_feature::validate() {
    local input="$1"
    
    # Validation logic
    if [[ ! "$input" =~ ^[a-zA-Z0-9]+$ ]]; then
        log::error "Invalid input format: $input"
        return 1
    fi
    
    return 0
}

# Helper function (private, not part of public API)
_new_feature_helper() {
    local internal_param="$1"
    # Internal helper logic
    echo "processed_$internal_param"
}
```

### Test Template

Use this structure for comprehensive testing:

```bash
#!/usr/bin/env bats

# tests/SCRIPT_NAME.bats - Tests for SCRIPT_NAME script

load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

setup() {
    # Add bin directory to PATH
    export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
    
    # Create temporary directory
    export BATS_TMPDIR="$(mktemp -d)"
    
    # Create test files if needed
    echo "test content" > "$BATS_TMPDIR/test_file.txt"
}

teardown() {
    # Clean up
    [[ -n "$BATS_TMPDIR" ]] && rm -rf "$BATS_TMPDIR"
}

@test "SCRIPT_NAME shows help when --help flag is used" {
    run SCRIPT_NAME --help
    assert_success
    assert_output --partial "Usage:"
    assert_output --partial "SCRIPT_NAME"
}

@test "SCRIPT_NAME shows version when --version flag is used" {
    run SCRIPT_NAME --version
    assert_success
    assert_output --regexp "SCRIPT_NAME [0-9]+\.[0-9]+\.[0-9]+"
}

@test "SCRIPT_NAME fails when required argument is missing" {
    run SCRIPT_NAME
    assert_failure
    assert_output --partial "required"
}

@test "SCRIPT_NAME processes valid input correctly" {
    run SCRIPT_NAME "test_input"
    assert_success
    assert_output --partial "test_input"
}

@test "SCRIPT_NAME handles file input" {
    run SCRIPT_NAME "$BATS_TMPDIR/test_file.txt"
    assert_success
}

@test "SCRIPT_NAME fails with invalid file" {
    run SCRIPT_NAME "/nonexistent/file.txt"
    assert_failure
    assert_output --partial "Cannot read file"
}

@test "SCRIPT_NAME quiet mode suppresses verbose output" {
    run SCRIPT_NAME --quiet "test_input"
    assert_success
    refute_output --partial "Starting"
}

@test "SCRIPT_NAME handles unknown options gracefully" {
    run SCRIPT_NAME --unknown-option
    assert_failure
    assert_output --partial "Unknown option"
}
```

## 🔧 Specific AI Instructions

### When Creating Scripts

1. **Define primary function first** - what does this script actually do?
2. **Implement core functionality** - make it work before making it pretty
3. **Always start with the standard template**
4. **Replace placeholder content** with specific functionality
5. **Add comprehensive input validation** for all parameters
6. **Use semantic logging** (info, warn, error, success) instead of echo
7. **Include examples in help text** that show real usage scenarios
8. **Handle edge cases** and provide meaningful error messages

### When Adding Library Functions

1. **Choose the appropriate lib file** or create a new one
2. **Use namespace prefixes** (e.g., `spinner::`, `log::`, `utils::`)
3. **Include parameter validation** at the start of each function
4. **Follow existing patterns** for error handling and logging
5. **Update lib/main.sh** to source new library files

### When Writing Tests

1. **Test all public interfaces** (command-line options, arguments)
2. **Test error conditions** as thoroughly as success conditions
3. **Use descriptive test names** that explain what is being tested
4. **Include setup/teardown** for file system operations
5. **Test with various input combinations**

## 🎨 AI-Specific Best Practices

### Code Generation Guidelines

- **Implement core functionality first** - ensure the script actually does what its name suggests
- **Read existing code first** to understand patterns and style
- **Use library functions consistently** throughout the script
- **Validate all user inputs** before processing
- **Provide helpful error messages** that guide the user to success
- **Include usage examples** in help text
- **Follow the established naming conventions** exactly

### Error Handling Pattern

```bash
# Always validate inputs first
if [[ -z "$required_param" ]]; then
    log::error "Required parameter missing"
    show_help
    exit 1
fi

# Check file/directory existence
if [[ ! -r "$file_path" ]]; then
    log::error "Cannot read file: $file_path"
    exit 1
fi

# Validate formats with helpful messages
if [[ ! "$email" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
    log::error "Invalid email format: $email"
    log::info "Email should be in format: user@domain.com"
    exit 1
fi
```

### Integration Patterns

When calling external tools or APIs:

```bash
# Check dependencies first
if ! command -v jq >/dev/null 2>&1; then
    log::error "jq is required but not installed"
    log::info "Install with: brew install jq"
    exit 1
fi

# Use spinners for long operations
spinner::start "Calling external API"
response=$(curl -s "$api_url" || true)
spinner::stop

# Validate responses
if [[ -z "$response" ]]; then
    log::error "No response from API"
    exit 1
fi
```

## 📚 Reference Materials

When generating Shell Starter code, always reference:

1. **`docs/conventions.md`** - For coding standards and style
2. **`bin/` directory** - For existing script patterns
3. **`lib/` directory** - For available library functions
4. **`tests/` directory** - For testing patterns
5. **`README.md`** - For project overview and features

## 🔍 Common Patterns

### Configuration Management
```bash
# Load configuration with fallbacks
CONFIG_FILE="${CONFIG_FILE:-$HOME/.config/shell-starter/config}"
SETTING="${SETTING:-default_value}"

if [[ -r "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
fi
```

### Dependency Checking
```bash
check_dependencies() {
    local deps=("curl" "jq" "git")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            missing+=("$dep")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log::error "Missing dependencies: ${missing[*]}"
        return 1
    fi
}
```

### File Processing
```bash
process_file() {
    local file="$1"
    
    if [[ ! -r "$file" ]]; then
        log::error "Cannot read file: $file"
        return 1
    fi
    
    local line_count
    line_count=$(wc -l < "$file")
    log::info "Processing $line_count lines from $file"
    
    while IFS= read -r line; do
        # Process each line
        echo "Processed: $line"
    done < "$file"
}
```

This guide ensures that AI assistants can generate high-quality, consistent Shell Starter scripts that follow project conventions and best practices.