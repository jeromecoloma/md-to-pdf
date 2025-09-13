#!/bin/bash

set -euo pipefail

# md-to-pdf Installer
# This script installs CLI scripts from the bin/ directory to a specified location

# Configuration
DEFAULT_PREFIX="$HOME/.config/md-to-pdf/bin"
MANIFEST_DIR="$HOME/.config/md-to-pdf"
MANIFEST_FILE="$MANIFEST_DIR/install-manifest.txt"
REPO_URL="https://github.com/jeromecoloma/md-to-pdf"
TEMP_DIR=""

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

# Detect user's shell configuration file
detect_shell_config() {
	local shell_name
	shell_name=$(basename "$SHELL")

	case "$shell_name" in
	zsh)
		echo "$HOME/.zshrc"
		;;
	bash)
		# Check for .bashrc first, then .bash_profile
		if [[ -f "$HOME/.bashrc" ]]; then
			echo "$HOME/.bashrc"
		else
			echo "$HOME/.bash_profile"
		fi
		;;
	fish)
		echo "$HOME/.config/fish/config.fish"
		;;
	*)
		# Default to .bashrc for unknown shells
		echo "$HOME/.bashrc"
		;;
	esac
}

# Add directory to PATH in shell configuration
add_to_path() {
	local config_file="$1"
	local path_to_add="$2"

	# Check if PATH entry already exists
	if grep -q "export PATH.*$path_to_add" "$config_file" 2>/dev/null; then
		log_info "PATH entry already exists in $config_file"
		return 0
	fi

	log_info "Adding $path_to_add to PATH in $config_file"

	# Create config file if it doesn't exist
	if [[ ! -f "$config_file" ]]; then
		touch "$config_file"
		log_info "Created new config file: $config_file"
	fi

	# Add PATH export to the end of the file
	echo "" >>"$config_file"
	echo "# Added by md-to-pdf installer" >>"$config_file"
	echo "export PATH=\"$path_to_add:\$PATH\"" >>"$config_file"

	log_success "Added PATH entry to $config_file"
}

# Show usage information
show_help() {
	cat <<EOF
md-to-pdf Installer

Usage: $0 [OPTIONS]

DESCRIPTION:
    This installer copies CLI scripts from the bin/ directory to your system
    and automatically adds the installation directory to your PATH environment
    variable so you can run the scripts from anywhere.

OPTIONS:
    --prefix PATH    Install scripts to PATH (default: $DEFAULT_PREFIX)
    --help, -h       Show this help message

EXAMPLES:
    $0                           # Install to $DEFAULT_PREFIX and update PATH
    $0 --prefix /home/user/bin   # Install to custom location and update PATH
    bash <(curl -fsSL https://raw.githubusercontent.com/jeromecoloma/md-to-pdf/main/install.sh)

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

# Download project files if running remotely
download_project() {
	if [[ -d "bin" ]]; then
		log_info "Found local bin/ directory, using local files"
		return 0
	fi

	log_info "No local bin/ directory found, downloading project files..."

	# Create temporary directory
	TEMP_DIR=$(mktemp -d)
	cd "$TEMP_DIR"

	log_info "Downloading from $REPO_URL..."

	# Try git first, fallback to wget/curl
	if command -v git >/dev/null 2>&1; then
		if ! git clone --depth 1 "$REPO_URL" . 2>/dev/null; then
			log_error "Failed to clone repository with git"
			cleanup_temp
			exit 1
		fi
	elif command -v curl >/dev/null 2>&1; then
		if ! curl -fsSL "$REPO_URL/archive/main.tar.gz" | tar -xz --strip-components=1 2>/dev/null; then
			log_error "Failed to download and extract project files with curl"
			cleanup_temp
			exit 1
		fi
	elif command -v wget >/dev/null 2>&1; then
		if ! wget -qO- "$REPO_URL/archive/main.tar.gz" | tar -xz --strip-components=1 2>/dev/null; then
			log_error "Failed to download and extract project files with wget"
			cleanup_temp
			exit 1
		fi
	else
		log_error "No download tool available (git, curl, or wget required)"
		cleanup_temp
		exit 1
	fi

	if [[ ! -d "bin" ]]; then
		log_error "Downloaded project does not contain bin/ directory"
		cleanup_temp
		exit 1
	fi

	log_success "Project files downloaded successfully"
}

# Cleanup temporary directory
cleanup_temp() {
	if [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]]; then
		log_info "Cleaning up temporary files..."
		rm -rf "$TEMP_DIR"
	fi
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

# Install scripts and dependencies
install_scripts() {
	local script_count=0

	# Check if bin directory exists
	if [[ ! -d "bin" ]]; then
		log_error "No 'bin' directory found. Are you running this from the project root?"
		exit 1
	fi

	# Check if lib directory exists
	if [[ ! -d "lib" ]]; then
		log_error "No 'lib' directory found. Shell Starter framework requires lib/ directory."
		exit 1
	fi

	# Create parent directory for PREFIX (to install lib alongside bin)
	local install_root
	install_root=$(dirname "$PREFIX")
	if [[ ! -d "$install_root" ]]; then
		log_info "Creating install root directory: $install_root"
		mkdir -p "$install_root"
	fi

	# Check if PREFIX directory exists, create if needed
	if [[ ! -d "$PREFIX" ]]; then
		log_info "Creating install directory: $PREFIX"
		mkdir -p "$PREFIX"
	fi

	# Install lib directory to parent of bin
	local lib_dest="$install_root/lib"
	if [[ -d "$lib_dest" ]]; then
		log_info "Removing existing lib directory: $lib_dest"
		rm -rf "$lib_dest"
	fi
	log_info "Installing lib directory -> $lib_dest"
	cp -r "lib" "$lib_dest"
	echo "$lib_dest/" >>"$MANIFEST_FILE"

	# Install VERSION file to install root (needed for version detection)
	if [[ -f "VERSION" ]]; then
		local version_dest="$install_root/VERSION"
		log_info "Installing VERSION file -> $version_dest"
		cp "VERSION" "$version_dest"
		echo "$version_dest" >>"$MANIFEST_FILE"
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
	download_project
	create_manifest_dir
	init_manifest
	install_scripts

	# Setup PATH in shell configuration
	local shell_config
	shell_config=$(detect_shell_config)
	add_to_path "$shell_config" "$PREFIX"

	# Cleanup if we downloaded files
	cleanup_temp

	log_success "Installation complete!"
	log_info "Scripts installed to: $PREFIX"
	log_info "Install manifest saved to: $MANIFEST_FILE"
	log_info "PATH updated in: $shell_config"
	log_info "Please run 'source $shell_config' or restart your shell to use the installed scripts"
	log_info "Use 'md-to-pdf --uninstall' to remove installed scripts"
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]:-}" == "${0:-}" ]]; then
	main "$@"
fi
