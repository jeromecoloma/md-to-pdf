# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.3] - 2025-09-14

### Added
- Built-in uninstall functionality with `--uninstall` option
- Hybrid uninstall system that downloads robust standalone uninstaller with built-in fallback

### Fixed
- Fixed installer script to work with `curl | bash` by downloading project files automatically
- Enhanced uninstaller to completely remove empty directories after cleanup
- Resolved installer failure when running remotely without local project files
- Added proper exit handling for interactive mode with support for typing "exit", "quit", or "q" at any prompt
- Fixed Ctrl+C handling by wrapping all read commands with proper signal detection
- Updated installation command to use process substitution to resolve pipe buffering issues
- Fixed argument parsing error when using --theme, --css, or --engine options without values
- Fixed shell script formatting to comply with shfmt standards

### Changed
- Improved installer with automatic project download using git/curl/wget fallbacks
- Enhanced uninstaller cleanup to remove empty bin and config directories
- Improved signal trap handling to pass signal type to cleanup function
- Added clear instructions in welcome message about exit options
- Ensured graceful cleanup and consistent exit messaging across all prompts
- Replaced 'curl | bash' with 'bash <(curl)' across all documentation

## [0.2.1] - 2025-09-13

### Fixed
- Fixed GitHub Actions CI failures by updating test version expectations
- Made test suite version-agnostic using dynamic VERSION file reading

### Changed
- Updated all test files to read version dynamically instead of hardcoded values
- Improved test maintainability for future version releases

## [0.2.0] - 2024-09-13

### Added
- Enhanced themes with emoji support and WeasyPrint optimizations
- Automated PATH management in install/uninstall scripts
- Install/uninstall test suite

### Fixed
- Issues with themes and install/uninstall routine

### Changed
- Improved install/uninstall automation

## [0.1.0] - Initial Release

### Added
- Initial md-to-pdf conversion functionality
- Basic theme support
- Core installation scripts

[0.2.3]: https://github.com/your-username/md-to-pdf/compare/v0.2.1...v0.2.3
[0.2.1]: https://github.com/your-username/md-to-pdf/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/your-username/md-to-pdf/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/your-username/md-to-pdf/releases/tag/v0.1.0