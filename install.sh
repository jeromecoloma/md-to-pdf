#!/bin/bash

set -euo pipefail

# md-to-pdf Installer
# This script installs CLI scripts from the bin/ directory to a specified location

# Configuration
DEFAULT_PREFIX="$HOME/.config/md-to-pdf/bin"
MANIFEST_DIR="$HOME/.config/md-to-pdf"
MANIFEST_FILE="$MANIFEST_DIR/install-manifest.txt"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
	echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
	echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
	echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
	echo -e "${RED}[ERROR]${NC} $1"
}

# Show usage information
show_help() {
	cat <<EOF
md-to-pdf Installer

Usage: $0 [OPTIONS]

OPTIONS:
    --prefix PATH    Install scripts to PATH (default: $DEFAULT_PREFIX)
    --help, -h       Show this help message

EXAMPLES:
    $0                           # Install to $DEFAULT_PREFIX
    $0 --prefix /home/user/bin   # Install to custom location
    curl -fsSL https://raw.githubusercontent.com/jeromecoloma/md-to-pdf/main/install.sh | bash

SECURITY NOTE:
    This installer can be run via 'curl | bash' for convenience, but be aware
    this poses security risks. Always review scripts before executing them.

EOF
}

# Parse command line arguments
parse_args() {
	PREFIX="$DEFAULT_PREFIX"

	while [[ $# -gt 0 ]]; do
		case $1 in
		--prefix)
			PREFIX="$2"
			shift 2
			;;
		--help | -h)
			show_help
			exit 0
			;;
		*)
			log_error "Unknown option: $1"
			show_help
			exit 1
			;;
		esac
	done
}

# Create manifest directory if it doesn't exist
create_manifest_dir() {
	if [[ ! -d "$MANIFEST_DIR" ]]; then
		log_info "Creating manifest directory: $MANIFEST_DIR"
		mkdir -p "$MANIFEST_DIR"
	fi
}

# Initialize manifest file
init_manifest() {
	log_info "Initializing install manifest: $MANIFEST_FILE"
	echo "# md-to-pdf Install Manifest" >"$MANIFEST_FILE"
	echo "# Generated on $(date)" >>"$MANIFEST_FILE"
	echo "# Install prefix: $PREFIX" >>"$MANIFEST_FILE"
	echo "" >>"$MANIFEST_FILE"
}

# Install scripts from bin/ directory
install_scripts() {
	local script_count=0

	# Check if bin directory exists
	if [[ ! -d "bin" ]]; then
		log_error "No 'bin' directory found. Are you running this from the project root?"
		exit 1
	fi

	# Check if PREFIX directory exists, create if needed
	if [[ ! -d "$PREFIX" ]]; then
		log_info "Creating install directory: $PREFIX"
		mkdir -p "$PREFIX"
	fi

	# Install each script in bin/
	for script in bin/*; do
		if [[ -f "$script" && -x "$script" ]]; then
			local script_name
			script_name=$(basename "$script")
			local dest_path="$PREFIX/$script_name"

			log_info "Installing $script_name -> $dest_path"

			# Copy script to destination
			cp "$script" "$dest_path"
			chmod +x "$dest_path"

			# Record in manifest
			echo "$dest_path" >>"$MANIFEST_FILE"

			((script_count++))
		fi
	done

	if [[ $script_count -eq 0 ]]; then
		log_warn "No executable scripts found in bin/ directory"
	else
		log_success "Installed $script_count script(s)"
	fi
}

# Main installation process
main() {
	log_info "Starting md-to-pdf installation..."

	parse_args "$@"
	create_manifest_dir
	init_manifest
	install_scripts

	log_success "Installation complete!"
	log_info "Scripts installed to: $PREFIX"
	log_info "Install manifest saved to: $MANIFEST_FILE"
	log_info "Use ./uninstall.sh to remove installed scripts"
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]:-}" == "${0:-}" ]]; then
	main "$@"
fi
