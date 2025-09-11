#!/usr/bin/env bats
#
# Tests for generate-ai-workflow script

# Load test helpers
load test_helper
load bats-support/load
load bats-assert/load

setup() {
	# Call parent setup
	export SHELL_STARTER_TEST=1

	# Create temporary directory for test workflows
	TEST_WORKFLOW_DIR=$(mktemp -d)
	export TEST_WORKFLOW_DIR

	# Change to test directory for isolation
	cd "$TEST_WORKFLOW_DIR"
}

teardown() {
	# Clean up test directory
	if [[ -n "$TEST_WORKFLOW_DIR" && -d "$TEST_WORKFLOW_DIR" ]]; then
		rm -rf "$TEST_WORKFLOW_DIR"
	fi

	# Call parent teardown
	unset SHELL_STARTER_TEST
	unset TEST_WORKFLOW_DIR
}

# Help and version tests
@test "generate-ai-workflow: help flag" {
	run_script "generate-ai-workflow" --help
	assert_success
	assert_output --partial "generate-ai-workflow - Generate multi-agent AI development workflow"
	assert_output --partial "USAGE:"
	assert_output --partial "ARGUMENTS:"
	assert_output --partial "DESCRIPTION:"
	assert_output --partial "EXAMPLES:"
	assert_output --partial "FILES CREATED:"
}

@test "generate-ai-workflow: short help flag" {
	run_script "generate-ai-workflow" -h
	assert_success
	assert_output --partial "generate-ai-workflow - Generate multi-agent AI development workflow"
}

@test "generate-ai-workflow: version flag" {
	run_script "generate-ai-workflow" --version
	assert_success
	assert_output --regexp "generate-ai-workflow [0-9]+\.[0-9]+\.[0-9]+"
}

@test "generate-ai-workflow: short version flag" {
	run_script "generate-ai-workflow" -v
	assert_success
	assert_output --regexp "generate-ai-workflow [0-9]+\.[0-9]+\.[0-9]+"
}

# Input validation tests
@test "generate-ai-workflow: missing project name" {
	run_script "generate-ai-workflow"
	assert_failure
	assert_output --partial "Project name is required"
	assert_output --partial "Usage: generate-ai-workflow <project-name>"
}

@test "generate-ai-workflow: invalid project name with spaces" {
	run_script "generate-ai-workflow" "invalid name"
	assert_failure
	assert_output --partial "Project name must contain only letters, numbers, hyphens, and underscores"
}

@test "generate-ai-workflow: invalid project name with special characters" {
	run_script "generate-ai-workflow" "invalid@name!"
	assert_failure
	assert_output --partial "Project name must contain only letters, numbers, hyphens, and underscores"
}

@test "generate-ai-workflow: valid project names" {
	# Test various valid formats
	local valid_names=("test-project" "my_tool" "project123" "simple" "long-project-name" "under_score_name")

	for name in "${valid_names[@]}"; do
		run bash -c "echo 'y' | '${PROJECT_ROOT}/bin/generate-ai-workflow' '$name'"
		assert_success
		assert_output --partial "Generating AI workflow for project: $name"
		assert_output --partial "✓ AI workflow generated successfully!"

		# Clean up for next iteration
		rm -rf .ai-workflow
	done
}

@test "generate-ai-workflow: unknown option" {
	run_script "generate-ai-workflow" --invalid-option
	assert_failure
	assert_output --partial "Unknown option: --invalid-option"
	assert_output --partial "Use --help for usage information."
}

# Core functionality tests
@test "generate-ai-workflow: successful generation" {
	# Auto-answer 'y' to overwrite prompt
	run bash -c "echo 'y' | '${PROJECT_ROOT}/bin/generate-ai-workflow' 'test-project'"
	assert_success
	assert_output --partial "Generating AI workflow for project: test-project"
	assert_output --partial "Creating state management files for test-project..."
	assert_output --partial "✓ AI workflow generated successfully!"
	assert_output --partial "Next steps:"
	assert_output --partial "1. Edit .ai-workflow/state/requirements.md"
	assert_output --partial "2. Generate specific tasks: generate-ai-workflow --update-tasks test-project"
	assert_output --partial "3. Copy commands to your AI coding agent:"
	assert_output --partial "4. Start development with: /dev start"
}

# File structure tests
@test "generate-ai-workflow: creates correct directory structure" {
	run bash -c "echo 'y' | '${PROJECT_ROOT}/bin/generate-ai-workflow' 'test-project'"
	assert_success

	# Check main directories exist
	assert [ -d ".ai-workflow" ]
	assert [ -d ".ai-workflow/state" ]
	assert [ -d ".ai-workflow/commands" ]
	assert [ -d ".ai-workflow/commands/.claude" ]
	assert [ -d ".ai-workflow/commands/.claude/commands" ]
	assert [ -d ".ai-workflow/commands/.cursor" ]
	assert [ -d ".ai-workflow/commands/.cursor/commands" ]
	assert [ -d ".ai-workflow/commands/.gemini" ]
	assert [ -d ".ai-workflow/commands/.gemini/commands" ]
	assert [ -d ".ai-workflow/commands/.opencode" ]
	assert [ -d ".ai-workflow/commands/.opencode/command" ]
}

@test "generate-ai-workflow: creates state files" {
	run bash -c "echo 'y' | '${PROJECT_ROOT}/bin/generate-ai-workflow' 'test-project'"
	assert_success

	# Check state files exist
	assert [ -f ".ai-workflow/state/tasks.md" ]
	assert [ -f ".ai-workflow/state/requirements.md" ]
	assert [ -f ".ai-workflow/state/progress.log" ]

	# Check tasks.md content
	run cat .ai-workflow/state/tasks.md
	assert_output --partial "# test-project - Development Tasks"
	assert_output --partial "TEST-PROJECT-1:"
	assert_output --partial "Phase 1: Foundation Setup"
	assert_output --partial "Phase 2: Core Functionality"
	assert_output --partial "Phase 3: Advanced Features & Polish"
	assert_output --partial "Phase 4: Testing & Documentation"

	# Check requirements.md content
	run cat .ai-workflow/state/requirements.md
	assert_output --partial "# test-project - Product Requirements Document"
	assert_output --partial "## Product Overview"
	assert_output --partial "## Primary Command/Tool Definition"
	assert_output --partial "## Core Functionality (Implementation Requirements)"
	assert_output --partial "## Shell Starter Compliance"
	assert_output --partial "## Success Criteria & Verification"

	# Check progress.log content
	run cat .ai-workflow/state/progress.log
	assert_output --partial "# test-project - Development Progress Log"
	assert_output --partial "## $(date '+%Y-%m-%d')" # Check today's date is present
	assert_output --partial "Workflow Generated"
	assert_output --partial "Ready to start development with /dev start"
}

@test "generate-ai-workflow: creates Claude commands" {
	run bash -c "echo 'y' | '${PROJECT_ROOT}/bin/generate-ai-workflow' 'test-project'"
	assert_success

	# Check Claude command files exist
	assert [ -f ".ai-workflow/commands/.claude/commands/dev.md" ]
	assert [ -f ".ai-workflow/commands/.claude/commands/qa.md" ]
	assert [ -f ".ai-workflow/commands/.claude/commands/status.md" ]

	# Check dev.md content
	run cat .ai-workflow/commands/.claude/commands/dev.md
	assert_output --partial "You are managing autonomous development"
	assert_output --partial "AUTONOMOUS DEVELOPMENT PROTOCOL"
	assert_output --partial "READ STATE"
	assert_output --partial "ANALYZE"
	assert_output --partial "ACT"
	assert_output --partial "VERIFY"
	assert_output --partial "UPDATE STATE"

	# Check qa.md content
	run cat .ai-workflow/commands/.claude/commands/qa.md
	assert_output --partial "Quality Assurance engineer"
	assert_output --partial "QA REPORT"
	assert_output --partial "Files Checked:"
	assert_output --partial "Issues Found:"

	# Check status.md content
	run cat .ai-workflow/commands/.claude/commands/status.md
	assert_output --partial "project manager"
	assert_output --partial "PROJECT STATUS"
	assert_output --partial "Next Task:"
	assert_output --partial "Progress:"
}

@test "generate-ai-workflow: creates multi-agent commands" {
	run bash -c "echo 'y' | '${PROJECT_ROOT}/bin/generate-ai-workflow' 'test-project'"
	assert_success

	# Check Cursor commands (should be copies of Claude commands)
	assert [ -f ".ai-workflow/commands/.cursor/commands/dev.md" ]
	assert [ -f ".ai-workflow/commands/.cursor/commands/qa.md" ]
	assert [ -f ".ai-workflow/commands/.cursor/commands/status.md" ]

	# Check OpenCode commands (should be copies of Claude commands)
	assert [ -f ".ai-workflow/commands/.opencode/command/dev.md" ]
	assert [ -f ".ai-workflow/commands/.opencode/command/qa.md" ]
	assert [ -f ".ai-workflow/commands/.opencode/command/status.md" ]

	# Check Gemini commands (TOML format)
	assert [ -f ".ai-workflow/commands/.gemini/commands/dev.toml" ]
	assert [ -f ".ai-workflow/commands/.gemini/commands/qa.toml" ]
	assert [ -f ".ai-workflow/commands/.gemini/commands/status.toml" ]

	# Check Gemini TOML content
	run cat .ai-workflow/commands/.gemini/commands/dev.toml
	assert_output --partial 'description = "Autonomous development cycle'
	assert_output --partial 'prompt = """'
	assert_output --partial "You are managing autonomous development"
}

@test "generate-ai-workflow: handles existing workflow directory" {
	# Create initial workflow
	run bash -c "echo 'y' | '${PROJECT_ROOT}/bin/generate-ai-workflow' 'test-project'"
	assert_success

	# Try to create again (should prompt for overwrite)
	run bash -c "echo 'n' | '${PROJECT_ROOT}/bin/generate-ai-workflow' 'test-project'"
	assert_success
	assert_output --partial "Existing .ai-workflow directory found"
	assert_output --partial "This will overwrite existing workflow files"
	assert_output --partial "Cancelled"

	# Try to create again with 'y' (should overwrite)
	run bash -c "echo 'y' | '${PROJECT_ROOT}/bin/generate-ai-workflow' 'test-project'"
	assert_success
	assert_output --partial "Existing .ai-workflow directory found"
	assert_output --partial "This will overwrite existing workflow files"
	assert_output --partial "✓ AI workflow generated successfully!"
}

@test "generate-ai-workflow: project name case handling" {
	run bash -c "echo 'y' | '${PROJECT_ROOT}/bin/generate-ai-workflow' 'image-resizer'"
	assert_success

	# Check that task codes are uppercase
	run cat .ai-workflow/state/tasks.md
	assert_output --partial "IMAGE-RESIZER-1:"
	assert_output --partial "IMAGE-RESIZER-2:"
	assert_output --partial "IMAGE-RESIZER-3:"
}

@test "generate-ai-workflow: task numbering is sequential" {
	run bash -c "echo 'y' | '${PROJECT_ROOT}/bin/generate-ai-workflow' 'my-project'"
	assert_success

	# Check sequential numbering in tasks
	run cat .ai-workflow/state/tasks.md
	assert_output --partial "MY-PROJECT-1:"
	assert_output --partial "MY-PROJECT-2:"
	assert_output --partial "MY-PROJECT-3:"
	assert_output --partial "MY-PROJECT-4:"
	assert_output --partial "MY-PROJECT-5:"
	assert_output --partial "MY-PROJECT-6:"
	assert_output --partial "MY-PROJECT-7:"
	assert_output --partial "MY-PROJECT-8:"
	assert_output --partial "MY-PROJECT-9:"
	assert_output --partial "MY-PROJECT-10:"
	assert_output --partial "MY-PROJECT-11:"
	assert_output --partial "MY-PROJECT-12:"
}

@test "generate-ai-workflow: verification commands include project name" {
	run bash -c "echo 'y' | '${PROJECT_ROOT}/bin/generate-ai-workflow' 'my-tool'"
	assert_success

	# Check that verification steps reference the project name
	run cat .ai-workflow/state/tasks.md
	assert_output --partial "shellcheck bin/my-tool"
	assert_output --partial "shfmt -d bin/my-tool"
}

@test "generate-ai-workflow: command file content integrity" {
	run bash -c "echo 'y' | '${PROJECT_ROOT}/bin/generate-ai-workflow' 'test-project'"
	assert_success

	# Check that Cursor commands are identical to Claude commands
	run diff .ai-workflow/commands/.claude/commands/dev.md .ai-workflow/commands/.cursor/commands/dev.md
	assert_success # diff should return 0 (no differences)

	# Check that OpenCode commands have proper frontmatter format
	run grep -q "^---$" .ai-workflow/commands/.opencode/command/qa.md
	assert_success
	run grep -q "description:" .ai-workflow/commands/.opencode/command/qa.md
	assert_success
}

@test "generate-ai-workflow: handles edge cases in project names" {
	# Test minimum length (single character)
	run bash -c "echo 'y' | '${PROJECT_ROOT}/bin/generate-ai-workflow' 'a'"
	assert_success
	rm -rf .ai-workflow

	# Test maximum reasonable length
	run bash -c "echo 'y' | '${PROJECT_ROOT}/bin/generate-ai-workflow' 'very-long-project-name-with-many-hyphens'"
	assert_success
	rm -rf .ai-workflow

	# Test numbers only
	run bash -c "echo 'y' | '${PROJECT_ROOT}/bin/generate-ai-workflow' '12345'"
	assert_success
	rm -rf .ai-workflow

	# Test mixed case (should be converted to uppercase in task codes)
	run bash -c "echo 'y' | '${PROJECT_ROOT}/bin/generate-ai-workflow' 'MyProject'"
	assert_success
	run cat .ai-workflow/state/tasks.md
	assert_output --partial "MYPROJECT-1:"
}

@test "generate-ai-workflow: progress log includes timestamp" {
	run bash -c "echo 'y' | '${PROJECT_ROOT}/bin/generate-ai-workflow' 'test-project'"
	assert_success

	# Check that progress log has proper timestamp format
	run cat .ai-workflow/state/progress.log
	assert_output --regexp "[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}"
}

@test "generate-ai-workflow: all command files are non-empty" {
	run bash -c "echo 'y' | '${PROJECT_ROOT}/bin/generate-ai-workflow' 'test-project'"
	assert_success

	# Check that all generated command files have content
	local files=(
		".ai-workflow/commands/.claude/commands/dev.md"
		".ai-workflow/commands/.claude/commands/qa.md"
		".ai-workflow/commands/.claude/commands/status.md"
		".ai-workflow/commands/.cursor/commands/dev.md"
		".ai-workflow/commands/.gemini/commands/dev.toml"
		".ai-workflow/commands/.opencode/command/dev.md"
	)

	for file in "${files[@]}"; do
		assert [ -s "$file" ] # -s checks that file exists and is not empty
	done
}
