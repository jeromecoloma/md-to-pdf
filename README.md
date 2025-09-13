# md-to-pdf

A professional CLI tool for converting Markdown files to beautifully formatted PDFs with theme support, interactive prompts, and comprehensive error handling.

Built on the [Shell Starter](https://github.com/jeromecoloma/shell-starter) framework for robust bash scripting.

## 🚀 Quick Start

### Installation

Install md-to-pdf using the built-in installer:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/jeromecoloma/md-to-pdf/main/install.sh)
```

**Custom Installation Path**: The installer supports `--prefix /custom/path` (default: `~/.config/md-to-pdf/bin`)

**Uninstallation**: Built-in uninstaller with confirmation: `./uninstall.sh` or `./uninstall.sh -y`

### Prerequisites

- **pandoc** - Required for markdown to PDF conversion
  - macOS: `brew install pandoc`
  - Ubuntu/Debian: `sudo apt-get install pandoc`
  - Other systems: See [pandoc installation guide](https://pandoc.org/installing.html)

## 📋 Features

- **🎨 Professional PDF Output**: Clean, themed PDFs using pandoc with built-in styles
- **😀 Enhanced Emoji Support**: Full emoji rendering with system font integration
- **⏳ Interactive Mode**: Guided prompts for input/output paths and theme selection
- **🔧 Direct Mode**: Command-line arguments for automated workflows
- **📦 Multiple Themes**: GitHub, Academic, Clean, and Modern styles with authentic styling
- **🔍 Preview Mode**: Show conversion plan without executing
- **⚙️ WeasyPrint Optimization**: Themes optimized for reliable PDF rendering
- **🛡️ Error Handling**: Comprehensive validation and helpful error messages
- **📝 Progress Indicators**: Visual feedback during conversion operations
- **🤖 Shell Starter Framework**: Built on robust bash scripting foundation

## 🎯 Usage

### Interactive Mode

Run without arguments for guided setup:

```bash
md-to-pdf
```

This will prompt you for:
- Input markdown file path
- Output PDF file path
- Theme selection (GitHub, Academic, Clean, Modern)

### Direct Mode

Convert files directly with command-line arguments:

```bash
# Basic conversion with auto-generated output name
md-to-pdf document.md

# Specify custom output file
md-to-pdf document.md report.pdf

# Use specific theme
md-to-pdf --theme academic document.md

# Preview conversion plan
md-to-pdf --preview document.md
```

### Command Line Options

| Option | Description | Example |
|--------|-------------|---------|
| `--help`, `-h` | Show help message and usage examples | `md-to-pdf --help` |
| `--version`, `-v` | Show version information | `md-to-pdf --version` |
| `--theme <name>`, `-t <name>` | Use specific theme (github, academic, clean, modern) | `md-to-pdf --theme academic doc.md` |
| `--list-themes`, `-l` | List all available themes | `md-to-pdf --list-themes` |
| `--preview`, `-p` | Show conversion plan without creating PDF | `md-to-pdf --preview doc.md` |
| `--css <file>`, `-c <file>` | Use custom CSS file for styling | `md-to-pdf --css custom.css doc.md` |
| `--quiet`, `-q` | Suppress verbose output | `md-to-pdf --quiet doc.md` |
| `--force`, `-f` | Overwrite existing files without prompting | `md-to-pdf --force doc.md` |
| `--engine <name>`, `-e <name>` | Use specific PDF engine (weasyprint, xelatex) | `md-to-pdf --engine weasyprint doc.md` |
| `--list-engines` | List all available PDF engines | `md-to-pdf --list-engines` |

### Available Themes

md-to-pdf includes four professionally designed themes with enhanced emoji support:

- **GitHub** (default): Clean, familiar styling matching GitHub's markdown rendering with full emoji support and authentic GitHub code block styling
- **Academic**: Formal academic paper formatting with Times New Roman and structured layout
- **Clean**: Minimal, readable design with Helvetica Neue typography
- **Modern**: Contemporary styling optimized for WeasyPrint with clean gradients and modern typography

### Theme Examples

View example PDFs for each theme in `tests/output/`:
- `academic_final.pdf` - Academic theme example
- `clean_final.pdf` - Clean theme example
- `modern_final.pdf` - Modern theme example

Generate your own examples:
```bash
# Create theme comparison PDFs
echo "# Sample Document 🚀\n\nThis is a test with emojis! ✨\n\n\`\`\`bash\necho \"Hello World\"\n\`\`\`" > sample.md
md-to-pdf --theme academic sample.md academic_example.pdf
md-to-pdf --theme clean sample.md clean_example.pdf
md-to-pdf --theme modern sample.md modern_example.pdf
md-to-pdf --theme github sample.md github_example.pdf
```

### Theme Enhancements

**Recent improvements include:**

- **GitHub Theme**: Authentic GitHub markdown styling with proper code block rendering, enhanced emoji support, and clean typography matching GitHub's web interface
- **Modern Theme**: WeasyPrint-optimized styling that eliminates rendering artifacts while maintaining contemporary design elements
- **Enhanced Emoji Rendering**: All themes now include comprehensive emoji font support with proper fallbacks for cross-platform compatibility
- **Code Block Improvements**: Clean syntax highlighting without visual artifacts, proper spacing, and authentic styling for each theme

### PDF Engines

md-to-pdf supports multiple PDF generation engines with different capabilities:

- **WeasyPrint** (default): Enhanced CSS rendering with full emoji support, modern web standards, and optimized theme compatibility
- **XeLaTeX**: LaTeX-based generation optimized for complex mathematical content and academic documents

### Engine Selection

```bash
# Auto-select best engine (default: WeasyPrint)
md-to-pdf document.md

# Force WeasyPrint engine (recommended for most users)
md-to-pdf --engine weasyprint document.md

# Force XeLaTeX engine (for complex math/academic content)
md-to-pdf --engine xelatex document.md

# List available engines
md-to-pdf --list-engines
```

### Advanced Usage Examples

```bash
# List all available themes
md-to-pdf --list-themes

# Convert with academic theme and custom output
md-to-pdf --theme academic document.md thesis.pdf

# Preview conversion with modern theme
md-to-pdf --preview --theme modern document.md

# Use custom CSS with quiet mode
md-to-pdf --css styles.css --quiet document.md

# Force overwrite existing file
md-to-pdf --force --theme clean document.md

# Combine multiple options
md-to-pdf --theme academic --css custom.css --preview document.md report.pdf

# Use XeLaTeX engine for academic content
md-to-pdf --engine xelatex --theme academic thesis.md

# Force WeasyPrint with custom CSS
md-to-pdf --engine weasyprint --css styles.css document.md
```

## 📂 Project Structure

```
md-to-pdf/
├── bin/md-to-pdf         # Main CLI script
├── lib/                  # Shell Starter framework utilities
├── tests/                # Test suite (Bats framework)
│   ├── output/           # Test output files and theme examples
│   │   ├── academic_final.pdf    # Academic theme example
│   │   ├── clean_final.pdf       # Clean theme example
│   │   └── modern_final.pdf      # Modern theme example
│   └── *.bats            # Test files
├── docs/                 # Documentation and development guides
├── .github/workflows/    # CI/CD configuration
├── VERSION               # Version file
├── install.sh            # Installation script
└── uninstall.sh          # Uninstallation script
```

## 🔧 Development

This tool is built on the [Shell Starter](https://github.com/jeromecoloma/shell-starter) framework. For development information, see:

- [Shell Starter Documentation](https://github.com/jeromecoloma/shell-starter)
- [Development Journey](https://github.com/jeromecoloma/shell-starter/blob/main/docs/journeys/ai-assisted/md-to-pdf.md) - Complete build guide
- [Shell Scripting Conventions](https://github.com/jeromecoloma/shell-starter/blob/main/docs/conventions.md)

### Running Tests

```bash
# Run all tests
./tests/run-tests.sh

# Run specific test
./tests/run-tests.sh tests/md-to-pdf.bats

# View test outputs (theme examples)
ls tests/output/
```

**Note**: Test outputs are organized in `tests/output/` directory. Temporary test files are automatically cleaned up after each test run.

### Code Quality

```bash
# Lint scripts
shellcheck bin/md-to-pdf lib/*.sh

# Format code
shfmt -w bin/md-to-pdf lib/*.sh
```

## 🤖 AI-Assisted Development

This project was built using AI-assisted development workflows. See the [complete development journey](https://github.com/jeromecoloma/shell-starter/blob/main/docs/journeys/ai-assisted/md-to-pdf.md) for:

- Step-by-step AI development process
- Prompt engineering techniques
- Autonomous coding workflows
- Quality assurance automation

## 🔐 Security Notes

### curl | bash Warning

The quick install method executes remote code directly. For security:

- Only install from trusted repositories
- Review `install.sh` before execution:

```bash
curl -fsSL https://raw.githubusercontent.com/jeromecoloma/md-to-pdf/main/install.sh > install.sh
# Review the script
cat install.sh
# Run it
bash install.sh
```

## 📄 License

MIT License - see LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests: `./tests/bats-core/bin/bats tests/`
5. Submit a pull request

## 📚 Learn More

- **[Development Journey](https://github.com/jeromecoloma/shell-starter/blob/main/docs/journeys/ai-assisted/md-to-pdf.md)** - How this tool was built
- [Shell Starter Framework](https://github.com/jeromecoloma/shell-starter) - Base framework documentation
- [Pandoc Documentation](https://pandoc.org/) - PDF generation engine
- [Bats Testing Framework](https://github.com/bats-core/bats-core) - Test framework used