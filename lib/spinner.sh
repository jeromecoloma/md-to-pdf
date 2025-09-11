#!/bin/bash

# Shell Starter - Spinner Functions
# Provides animated spinner functionality for long-running operations

# Global variables for spinner state
SPINNER_PID=""
SPINNER_CHARS="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
SPINNER_MESSAGE=""

# Function to run the spinner animation
_spinner_animate() {
	local message="$1"
	local i=0
	local chars="$SPINNER_CHARS"

	while true; do
		local char="${chars:$i:1}"
		printf "\r%s %s" "$char" "$message"
		i=$(((i + 1) % ${#chars}))
		sleep 0.1
	done
}

# Start the spinner with an optional message
spinner::start() {
	local message="${1:-Loading...}"

	# Stop any existing spinner
	spinner::stop

	# Skip spinner in CI environments or when disabled
	if [[ -n "${SHELL_STARTER_SPINNER_DISABLED:-}" ]] || [[ -n "${CI:-}" ]] || [[ -n "${GITHUB_ACTIONS:-}" ]]; then
		SPINNER_MESSAGE="$message"
		SPINNER_PID="disabled"
		return 0
	fi

	# Hide cursor and start spinner in background
	printf "\033[?25l" # Hide cursor
	SPINNER_MESSAGE="$message"
	_spinner_animate "$message" &
	SPINNER_PID=$!
}

# Stop the spinner and clean up
spinner::stop() {
	if [[ -n "$SPINNER_PID" ]]; then
		# Handle disabled spinner case
		if [[ "$SPINNER_PID" == "disabled" ]]; then
			SPINNER_PID=""
			return 0
		fi

		# Kill the background process and suppress job control messages
		{
			kill "$SPINNER_PID" 2>/dev/null

			# Give it a moment to die, then forcefully kill if needed
			sleep 0.1
			if kill -0 "$SPINNER_PID" 2>/dev/null; then
				kill -9 "$SPINNER_PID" 2>/dev/null
			fi
		} 2>/dev/null

		SPINNER_PID=""

		# Clear the spinner line and show cursor
		printf "\r\033[K"  # Clear line
		printf "\033[?25h" # Show cursor
	fi
}

# Update spinner message while running
spinner::update() {
	local new_message="${1:-Loading...}"
	if [[ -n "$SPINNER_PID" ]]; then
		SPINNER_MESSAGE="$new_message"
		# No need to do anything special for disabled spinner
	fi
}
