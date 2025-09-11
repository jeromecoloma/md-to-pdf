#!/bin/bash

# Shell Starter - Logging Functions
# Provides standardized logging functions with color support

# Source colors if not already sourced
if [[ -z "${COLOR_RESET:-}" ]]; then
	SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	source "${SCRIPT_DIR}/colors.sh"
fi

# Log level configuration (can be overridden)
LOG_LEVEL="${LOG_LEVEL:-INFO}"

# Internal function to determine if log level should be shown
_should_log() {
	local level="$1"
	case "$LOG_LEVEL" in
	DEBUG) return 0 ;;
	INFO) [[ "$level" != "DEBUG" ]] && return 0 || return 1 ;;
	WARN) [[ "$level" == "WARN" || "$level" == "ERROR" || "$level" == "SUCCESS" ]] && return 0 || return 1 ;;
	ERROR) [[ "$level" == "ERROR" ]] && return 0 || return 1 ;;
	SUCCESS) [[ "$level" == "SUCCESS" ]] && return 0 || return 1 ;;
	*) return 0 ;;
	esac
}

# Internal function for formatted logging
_log() {
	local level="$1"
	local color="$2"
	local timestamp
	timestamp=$(date '+%Y-%m-%d %H:%M:%S')
	shift 2

	if _should_log "$level"; then
		printf "${color}[%s] %s:${COLOR_RESET} %s\n" "$timestamp" "$level" "$*" >&2
	fi
}

# Public logging functions
log::debug() {
	_log "DEBUG" "$COLOR_DEBUG" "$@"
}

log::info() {
	_log "INFO" "$COLOR_INFO" "$@"
}

log::warn() {
	_log "WARN" "$COLOR_WARNING" "$@"
}

log::error() {
	_log "ERROR" "$COLOR_ERROR" "$@"
}

log::success() {
	_log "SUCCESS" "$COLOR_SUCCESS" "$@"
}
