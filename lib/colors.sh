#!/bin/bash

# Shell Starter - Color Variables
# Provides standard ANSI color codes for terminal output

# Text colors
readonly COLOR_BLACK='\033[0;30m'
readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[0;33m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_MAGENTA='\033[0;35m'
readonly COLOR_CYAN='\033[0;36m'
readonly COLOR_WHITE='\033[0;37m'

# Bright text colors
readonly COLOR_BRIGHT_BLACK='\033[1;30m'
readonly COLOR_BRIGHT_RED='\033[1;31m'
readonly COLOR_BRIGHT_GREEN='\033[1;32m'
readonly COLOR_BRIGHT_YELLOW='\033[1;33m'
readonly COLOR_BRIGHT_BLUE='\033[1;34m'
readonly COLOR_BRIGHT_MAGENTA='\033[1;35m'
readonly COLOR_BRIGHT_CYAN='\033[1;36m'
readonly COLOR_BRIGHT_WHITE='\033[1;37m'

# Text formatting
readonly COLOR_BOLD='\033[1m'
readonly COLOR_DIM='\033[2m'
readonly COLOR_UNDERLINE='\033[4m'
readonly COLOR_BLINK='\033[5m'
readonly COLOR_REVERSE='\033[7m'

# Reset
readonly COLOR_RESET='\033[0m'

# Semantic colors (commonly used)
readonly COLOR_INFO="${COLOR_BLUE}"
readonly COLOR_SUCCESS="${COLOR_GREEN}"
readonly COLOR_WARNING="${COLOR_YELLOW}"
readonly COLOR_ERROR="${COLOR_RED}"
readonly COLOR_DEBUG="${COLOR_MAGENTA}"
