#!/usr/bin/env bash
#
# Setup script for Bats-core testing framework
# This script installs Bats-core as a git submodule for local testing

set -euo pipefail

# Get the project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "Setting up Bats-core testing framework..."

# Check if we're in a git repository
if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "Error: Not in a git repository. Bats setup requires git." >&2
    exit 1
fi

# Create tests directory if it doesn't exist
mkdir -p tests

# Add Bats-core as a git submodule
if [ ! -d "tests/bats-core" ]; then
    echo "Adding Bats-core as git submodule..."
    git submodule add https://github.com/bats-core/bats-core.git tests/bats-core
    git submodule update --init --recursive
else
    echo "Bats-core submodule already exists, updating..."
    git submodule update --recursive --remote tests/bats-core
fi

# Add supporting libraries
if [ ! -d "tests/bats-support" ]; then
    echo "Adding bats-support library..."
    git submodule add https://github.com/bats-core/bats-support.git tests/bats-support
fi

if [ ! -d "tests/bats-assert" ]; then
    echo "Adding bats-assert library..."
    git submodule add https://github.com/bats-core/bats-assert.git tests/bats-assert
fi

# Create a convenience script for running tests
cat > tests/run-tests.sh << 'EOF'
#!/usr/bin/env bash
#
# Convenience script for running Bats tests

set -euo pipefail

# Get the project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Check if Bats is available
if [ ! -f "$PROJECT_ROOT/tests/bats-core/bin/bats" ]; then
    echo "Error: Bats-core not found. Run scripts/setup-bats.sh first." >&2
    exit 1
fi

# Run all tests or specific test file
if [ $# -eq 0 ]; then
    echo "Running all tests..."
    "$PROJECT_ROOT/tests/bats-core/bin/bats" "$PROJECT_ROOT/tests"/*.bats
else
    echo "Running specific test: $1"
    "$PROJECT_ROOT/tests/bats-core/bin/bats" "$1"
fi
EOF

chmod +x tests/run-tests.sh

echo "✅ Bats-core testing framework setup complete!"
echo ""
echo "Usage:"
echo "  ./tests/run-tests.sh                 # Run all tests"
echo "  ./tests/run-tests.sh tests/foo.bats  # Run specific test"
echo ""
echo "To add the submodules to git:"
echo "  git add .gitmodules tests/"
echo "  git commit -m 'feat: add Bats-core testing framework'"