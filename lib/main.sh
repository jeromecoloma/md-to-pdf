#!/bin/bash

# Shell Starter - Main Library Entrypoint
# This file serves as the main library entrypoint for Shell Starter scripts.

# Get the directory where this script is located
SHELL_STARTER_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHELL_STARTER_ROOT_DIR="$(cd "${SHELL_STARTER_LIB_DIR}/.." && pwd)"

# Source color and logging libraries
source "${SHELL_STARTER_LIB_DIR}/colors.sh"
source "${SHELL_STARTER_LIB_DIR}/logging.sh"
source "${SHELL_STARTER_LIB_DIR}/spinner.sh"
source "${SHELL_STARTER_LIB_DIR}/utils.sh"

# Function to get the current version from VERSION file
get_version() {
	local version_file="${SHELL_STARTER_ROOT_DIR}/VERSION"
	if [[ -f "$version_file" ]]; then
		cat "$version_file"
	else
		echo "unknown"
	fi
}

# Function to parse common command line arguments
parse_common_args() {
	local script_name="${1:-$(basename "$0")}"
	shift

	while [[ $# -gt 0 ]]; do
		case $1 in
		--version | -v)
			echo "$script_name $(get_version)"
			exit 0
			;;
		--help | -h)
			show_help "$script_name"
			exit 0
			;;
		*)
			# Unknown option, return to caller for handling
			return 1
			;;
		esac
		shift
	done
	return 0
}

# Default help function (can be overridden by scripts)
show_help() {
	local script_name="${1:-$(basename "$0")}"
	cat <<EOF
Usage: $script_name [OPTIONS]

OPTIONS:
    -h, --help     Show this help message and exit
    -v, --version  Show version information and exit

This is a Shell Starter script. Override the show_help function
in your script to provide specific usage information.
EOF
}
