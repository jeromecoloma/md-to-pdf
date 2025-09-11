#!/bin/bash

# Shell Starter - Utility Functions
# Provides utility functions for polyglot script execution

# Source logging if not already sourced
if ! declare -F log::info >/dev/null 2>&1; then
	SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	source "${SCRIPT_DIR}/logging.sh"
fi

# Function to execute scripts in other languages with environment setup
run::script() {
	local script_path="$1"
	local script_name
	local script_dir
	local script_ext

	# Validate input
	if [[ -z "$script_path" ]]; then
		log::error "run::script: No script path provided"
		return 1
	fi

	if [[ ! -f "$script_path" ]]; then
		log::error "run::script: Script file not found: $script_path"
		return 1
	fi

	# Extract script information
	script_name="$(basename "$script_path")"
	script_dir="$(cd "$(dirname "$script_path")" && pwd)"
	script_ext="${script_name##*.}"

	# Shift to get remaining arguments for the script
	shift

	log::debug "Running $script_ext script: $script_name"

	case "$script_ext" in
	py | python)
		_run_python_script "$script_path" "$script_dir" "$@"
		;;
	js | javascript)
		_run_node_script "$script_path" "$script_dir" "$@"
		;;
	rb | ruby)
		_run_ruby_script "$script_path" "$script_dir" "$@"
		;;
	pl | perl)
		_run_perl_script "$script_path" "$script_dir" "$@"
		;;
	sh | bash)
		_run_shell_script "$script_path" "$script_dir" "$@"
		;;
	*)
		log::warn "Unknown script type: $script_ext, attempting direct execution"
		"$script_path" "$@"
		;;
	esac
}

# Internal function to run Python scripts with virtual environment support
_run_python_script() {
	local script_path="$1"
	local script_dir="$2"
	shift 2

	local venv_path=""
	local python_cmd="python3"

	# Check for virtual environment in various locations
	if [[ -f "$script_dir/.venv/bin/activate" ]]; then
		venv_path="$script_dir/.venv"
	elif [[ -f "$script_dir/venv/bin/activate" ]]; then
		venv_path="$script_dir/venv"
	elif [[ -f "$script_dir/../.venv/bin/activate" ]]; then
		venv_path="$script_dir/../.venv"
	elif [[ -f "$script_dir/../venv/bin/activate" ]]; then
		venv_path="$script_dir/../venv"
	fi

	# Activate virtual environment if found
	if [[ -n "$venv_path" ]]; then
		log::debug "Activating Python virtual environment: $venv_path"
		# shellcheck source=/dev/null
		source "$venv_path/bin/activate"
		# Check if python command is available in the activated venv, fallback to python3
		if command -v python >/dev/null 2>&1; then
			python_cmd="python"
		elif command -v python3 >/dev/null 2>&1; then
			python_cmd="python3"
		else
			log::error "No Python interpreter found in virtual environment"
			return 1
		fi
	else
		log::debug "No Python virtual environment found, using system Python"
		# Use python3 as default, fallback to python if available
		if command -v python3 >/dev/null 2>&1; then
			python_cmd="python3"
		elif command -v python >/dev/null 2>&1; then
			python_cmd="python"
		else
			log::error "No Python interpreter found on system"
			return 1
		fi
	fi

	# Execute the Python script
	"$python_cmd" "$script_path" "$@"
	local exit_code=$?

	# Deactivate virtual environment if it was activated
	if [[ -n "$venv_path" ]] && declare -F deactivate >/dev/null 2>&1; then
		deactivate
	fi

	return $exit_code
}

# Internal function to run Node.js scripts
_run_node_script() {
	local script_path="$1"
	local script_dir="$2"
	shift 2

	log::debug "Running Node.js script with node"
	node "$script_path" "$@"
}

# Internal function to run Ruby scripts
_run_ruby_script() {
	local script_path="$1"
	local script_dir="$2"
	shift 2

	log::debug "Running Ruby script with ruby"
	ruby "$script_path" "$@"
}

# Internal function to run Perl scripts
_run_perl_script() {
	local script_path="$1"
	local script_dir="$2"
	shift 2

	log::debug "Running Perl script with perl"
	perl "$script_path" "$@"
}

# Internal function to run shell scripts
_run_shell_script() {
	local script_path="$1"
	local script_dir="$2"
	shift 2

	log::debug "Running shell script with bash"
	bash "$script_path" "$@"
}
