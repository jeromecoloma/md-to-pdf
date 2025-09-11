# Development Journey: AI-Assisted Markdown to PDF Converter CLI
**Task Code**: `JOURNEY-MD-PDF`

Build a professional markdown to PDF conversion tool using Shell Starter and an AI coding assistant.

## 📋 Overview

**What You'll Build:** A CLI tool that converts markdown files to professional PDFs using pandoc with theme support, interactive prompts, and comprehensive error handling.

**AI Coding Agents:** Claude Code, Cursor, Codex, Gemini CLI, etc.

**Final Result:** Production-ready `md-to-pdf` script with professional UX

## ⏱️ Time Estimate
**Total:** ~40 minutes
- Setup & Exploration: 5 minutes
- Requirements: 3 minutes  
- AI Development: 15 minutes
- Testing & Refinement: 10 minutes
- Enhancement: 7 minutes

## 📚 Prerequisites

- Basic command line knowledge
- Access to an AI coding agent
- Pandoc installed (`brew install pandoc` or `apt-get install pandoc`)
- Some sample markdown files for testing

---

## Phase 1: Discovery & Setup (5 minutes)

### Step 1: Get Shell Starter

```bash
# Clone Shell Starter as your project template
git clone https://github.com/jeromecoloma/shell-starter.git
cd shell-starter
```

### Step 2: Explore the Capabilities

```bash
# Try the example scripts directly to understand Shell Starter's features
./bin/hello-world --help
./bin/show-colors
./bin/long-task
./bin/greet-user --formal "Developer"
```

**Key Observations:**
- Consistent `--help` and `--version` flags
- Colored logging output (`log::info`, `log::error`, etc.)
- Progress spinners for long operations
- Professional argument parsing

### Step 3: Examine the Project Structure

```bash
# Look at the library functions available
ls lib/
# colors.sh  logging.sh  main.sh  spinner.sh  utils.sh

# Check existing script patterns
ls bin/
# hello-world  show-colors  long-task  greet-user  my-cli  ai-action  polyglot-example
```

---

## Phase 2: Requirements Definition (3 minutes)

### Step 4: Define Your Markdown to PDF Converter Requirements

Our tool should:

- ✅ **Single file conversion** from markdown to PDF
- ✅ **Interactive prompts** for input/output paths and theme selection  
- ✅ **Dependency checking** to ensure pandoc is available
- ✅ **Progress indicators** during conversion
- ✅ **Error handling** for invalid files, permissions, pandoc errors
- ✅ **Theme support** (GitHub, Academic, Clean, Modern styles)
- ✅ **Preview mode** to show what would be processed
- ✅ **Shell Starter compliance** (help, version, logging, etc.)

### Step 5: Plan the User Experience

```bash
# Desired usage patterns:
md-to-pdf --help                      # Show comprehensive help
md-to-pdf --version                   # Show version
md-to-pdf                            # Interactive mode with prompts
md-to-pdf document.md                 # Convert to document.pdf
md-to-pdf document.md report.pdf      # Convert with custom output name
md-to-pdf --theme academic doc.md     # Convert with specific theme
md-to-pdf --preview document.md       # Preview conversion plan
```

---

## Phase 3: AI-Assisted Development (15 minutes)

### Step 6: Setup Autonomous AI Development Workflow

Instead of crafting a single prompt, we'll set up a self-managing AI development system that can work across context windows and different AI coding agents.

#### 6A: Generate AI Workflow Structure

```bash
# Generate the autonomous development workflow for md-to-pdf project
./bin/generate-ai-workflow md-to-pdf
```

This creates:
- `.ai-workflow/state/` - Task tracking and progress files for your md-to-pdf project
- `.ai-workflow/commands/` - Project-specific AI commands (separate from Shell Starter's internal commands)

**Important:** This generates a **separate** AI development workflow for your md-to-pdf project. This is different from Shell Starter's internal development commands (like `/do SHS-1`) which are used to develop Shell Starter itself.

#### 6B: Customize Project Requirements

You have three options for creating your project requirements:

**Option 1: Use the provided md-to-pdf specification (Fastest)**  
Copy-paste this ready-to-use specification directly:

```bash
# Edit the product requirements document
open .ai-workflow/state/requirements.md
```

Replace the template content with this complete md-to-pdf specification:

```markdown
# md-to-pdf - Product Requirements Document

## Product Overview
Professional markdown to PDF conversion CLI tool with theme support and interactive prompts.

**Target Users:** Developers, writers, documentation teams, content creators
**Core Problem:** Need professional, consistently formatted PDF output from markdown files with minimal setup
**Solution Approach:** Command-line tool using pandoc with built-in themes, interactive prompts, and comprehensive error handling

## Primary Command/Tool Definition
**CRITICAL:** Define the main command and its primary function - this drives implementation

**Primary Function:** Convert markdown files to PDF format using pandoc
**Main Command:** `md-to-pdf input.md [output.pdf] [options]`
**Dependencies:** pandoc (required for markdown to PDF conversion)
**Input/Output:** Takes markdown files (.md, .markdown) as input and produces PDF files as output

**Example Usage:**

    md-to-pdf document.md                    # Basic usage
    md-to-pdf document.md report.pdf        # With output specification
    md-to-pdf --help                        # Show help

## User Stories
- **US-1:** As a developer, I want to convert README.md to PDF for offline reading so that I can review documentation without internet access
- **US-2:** As a writer, I want to generate styled PDFs from my markdown drafts so that I can share professional documents with clients
- **US-3:** As a documentation team, I want consistent PDF formatting across all docs so that our brand appears professional and unified

## Core Functionality (Implementation Requirements)
**CRITICAL:** These define what must be implemented - be specific about the actual work

- **Primary Feature:** Convert markdown to PDF using pandoc
  - Implementation: Call pandoc with proper arguments: pandoc "$input_file" -o "$output_file" --pdf-engine=xelatex
  - Verification: Generate PDF from sample markdown file and verify it opens correctly

- **Input Validation:** Accept markdown files and validate them
  - File types: .md, .markdown, .txt
  - Validation: Check file exists, readable, proper format

- **Error Handling:** Specific error conditions and responses
  - Missing dependencies: Check for pandoc and guide installation
  - Invalid files: Clear error messages for bad input

## Advanced Features
- Interactive mode: prompts user for input file, output file, and theme selection with validation
- Direct mode: accepts markdown input file and optional PDF output name via command-line arguments
- Built-in themes: GitHub, Academic, Clean, Modern styles with preview capability
- Preview mode: shows conversion plan, theme preview, and file details without executing conversion
- Smart defaults: auto-generate output filename (input.md → input.pdf) and detect optimal theme

## CLI Interface Requirements
- **Interactive mode:** Prompt for input file, output location, and options
- **Direct mode:** Accept file paths and options as command arguments: `md-to-pdf file.md [output.pdf] [--theme name] [--preview]`
- **Preview mode:** Show what would happen without executing (--preview flag)
- **Help and version:** Standard --help and --version flags
- **Progress feedback:** Show progress for long-running operations

## Shell Starter Compliance  
- Follow Shell Starter conventions from docs/conventions.md (kebab-case, standard header)
- Use lib/main.sh and provided library functions (logging, colors, spinner, utils)
- Include --help and --version flags with proper argument parsing
- Use log:: functions (info, warn, error, debug) instead of echo for all output
- Handle all error conditions gracefully with meaningful, actionable messages
- Include progress indicators for conversion operations using spinner:: functions

## Technical Implementation Details
**CRITICAL:** Specific technical requirements for implementation

- **Dependencies:** pandoc (required for markdown to PDF conversion)
- **File Handling:** Read markdown input, write PDF output, handle temp files
- **Command Execution:** Execute pandoc with proper error handling and progress feedback
- **Cross-platform:** Support macOS and Linux with proper path handling
- **Performance:** Handle files up to 50MB efficiently

## Error Handling Scenarios
**CRITICAL:** Specific error conditions that must be handled

- **Pandoc not installed:** Provide installation instructions for macOS/Linux
- **File not found:** Clear error message with file path and suggestions
- **Permission denied:** Specific guidance for read/write permission problems
- **Invalid format:** Handle malformed markdown with helpful error messages
- **Disk full:** Check available space before processing large files
- **Interrupted operation:** Clean up partial files and provide recovery options

## Success Criteria & Verification
**CRITICAL:** How to verify the tool actually works

- **Functional Test:** Tool successfully converts markdown to PDF with real test data
- **Quality:** Passes shellcheck and shfmt with no errors
- **Integration:** Works with Shell Starter installer system
- **User Experience:** All user stories can be completed successfully
- **Error Handling:** All error scenarios produce helpful, actionable messages
- **Documentation:** Comprehensive help text with examples

**Manual Test Cases:**
- [ ] Basic conversion works: markdown file → PDF file
- [ ] Error handling works: test with invalid input
- [ ] Help and version flags work correctly
- [ ] Progress indicators show during conversion operations
```

**Option 2: Generate with AI assistance (Educational)**  
Use this prompt with any AI assistant to generate a custom PRD:

```
Create a comprehensive Product Requirements Document (PRD) for a markdown to PDF conversion CLI tool called "md-to-pdf".

## Project Context:
- **Purpose**: Convert markdown files to professional PDF documents with built-in themes and interactive prompts
- **Target Users**: Developers, writers, documentation teams, content creators
- **Core Functionality**: Command-line tool using pandoc with theme support, interactive mode, and comprehensive error handling

## Requirements:
Generate a PRD following this exact structure with NO checkboxes or REQ-X codes:

### Product Overview
- Clear problem statement and solution approach
- Target user identification

### User Stories  
- 3-5 user stories in "As a [user], I want [goal] so that [benefit]" format

### Core Features
- Interactive mode with file and theme selection prompts
- Direct command-line mode accepting arguments
- Built-in themes (GitHub, Academic, Clean, Modern)
- Preview mode showing conversion plan
- Smart defaults for output filenames

### CLI Interface Requirements
- Interactive mode specifications
- Direct command-line usage: `md-to-pdf file.md [output.pdf] [--theme name] [--preview]`
- Help and version requirements

### Shell Starter Compliance
- Integration with Shell Starter library functions (lib/main.sh)
- Logging with log:: functions instead of echo
- Progress indicators using spinner:: functions
- Standard argument parsing conventions

### Technical Requirements
- Pandoc dependency checking with installation guidance
- Input validation for markdown files (.md, .markdown, .txt)
- Output validation and overwrite protection
- Theme system with CSS templates
- Cross-platform compatibility (macOS/Linux)
- Safe file handling for paths with spaces

### Error Handling Scenarios
- Pandoc not installed
- Invalid file paths and permissions
- Malformed markdown syntax
- Insufficient disk space
- Invalid theme selection
- File overwrite scenarios

### Quality & Performance Requirements
- Code quality standards (shellcheck, shfmt)
- Bats testing framework coverage
- Performance for files up to 50MB
- Memory usage optimization

### Success Criteria
- Script executable at bin/md-to-pdf
- All user stories completed successfully
- Comprehensive error handling
- Manual testing across scenarios
- Shell Starter installer integration

Format as clean markdown with bullet points only. No task codes or checkboxes.
```

**Option 3: Create custom PRD for other projects**  
Use the comprehensive prompting guide for different project types:

```bash
# See the full PRD generation guide with templates
open docs/prompting-guide.md
```

---

#### 6C: Generate Specific Tasks from PRD

After customizing your requirements.md, generate project-specific tasks:

```bash
# Generate specific implementation tasks based on your PRD
./bin/generate-ai-workflow --update-tasks md-to-pdf
```

This analyzes your requirements.md and creates specific tasks like:
- **MD-TO-PDF-1:** Create project structure and basic executable
- **MD-TO-PDF-2:** Implement dependency checking (because PRD mentions pandoc)
- **MD-TO-PDF-3:** Implement primary functionality - markdown to PDF converter
  - **MD-TO-PDF-3.1:** Call pandoc with proper arguments: pandoc "$input_file" -o "$output_file" --pdf-engine=xelatex
- **MD-TO-PDF-4:** Implement interactive mode (because PRD mentions interactive prompts)  
- **MD-TO-PDF-5:** Implement theme system (because PRD mentions GitHub, Academic, Clean, Modern themes)
- **MD-TO-PDF-6:** Implement preview mode (because PRD mentions --preview flag)

The workflow ensures comprehensive task coverage for complete implementation.

#### 6D: Install Commands for Your AI Agent

Copy the appropriate commands to your coding agent:

```bash
# For Claude Code users:
mkdir -p .claude && cp -r .ai-workflow/commands/.claude/commands .claude/

# For Cursor users:
mkdir -p .cursor && cp -r .ai-workflow/commands/.cursor/commands .cursor/

# For Gemini CLI users:
mkdir -p .gemini && cp -r .ai-workflow/commands/.gemini/commands .gemini/

# For OpenCode users:
mkdir -p .opencode && cp -r .ai-workflow/commands/.opencode/command .opencode/
```

**Important:** After copying the commands, restart your AI agent or refresh the command list to ensure the new `/dev` command is available.

### Step 7: Start Autonomous Development

Now launch the AI development cycle using the **generated** `/dev` command (not Shell Starter's internal development commands):

```
/dev start
```

**Note:** This `/dev` command comes from the generated `.ai-workflow/commands/` directory you just copied, not from Shell Starter's internal development workflow. It will read your project-specific requirements and tasks from `.ai-workflow/state/`.

Your AI coding agent will now:

1. **Read** the current state from `.ai-workflow/state/` files (requirements.md and tasks.md)
2. **Analyze** the next incomplete task with detailed Goal/Actions/Verification
3. **Act** by implementing that specific feature following the task instructions
4. **Verify** with quality checks (shellcheck, shfmt, manual testing)
5. **Update** progress in the state files and mark tasks complete [x]
6. **Continue** to the next task automatically

**Expected AI Output:**
```
🔄 AUTONOMOUS DEVELOPMENT CYCLE
Current Task: MD-PDF-1: Create project structure and basic executable
Action: Creating bin/md-to-pdf with Shell Starter template structure
Progress: Implementing help text and argument parsing following task specifications
Next: MD-PDF-2: Implement core argument parsing and validation
```

### Step 8: Monitor and Resume Development

If the AI reaches context limits, it will save state and prompt you:

```
Continue development with: /dev
```

Simply start a new conversation and run:

```
/dev
```

**Note:** This uses the **project-specific** `/dev` command from your generated `.ai-workflow/commands/` directory. Make sure you have copied the commands to your AI agent's directory (Step 6D) before trying to resume development. The AI will read the saved state from `.ai-workflow/state/` and continue exactly where it left off.

---

## Phase 4: Testing & Refinement (10 minutes)

### Step 9: Run Quality Assurance

The AI workflow includes built-in QA. Run comprehensive checks:

```
/qa
```

**Expected QA Output:**
```
🔍 QA REPORT
Files Checked: bin/md-to-pdf
Issues Found: 0
Critical: None
Warnings: None
Status: PASS - Ready for manual testing
```

If issues are found, the AI will provide specific fixes to implement.

### Step 10: Manual Testing

The autonomous development should have created a working script. Test it:

```bash
# Test help and version (should work automatically)
./bin/md-to-pdf --help
./bin/md-to-pdf --version

# Test dependency checking
./bin/md-to-pdf --preview /nonexistent/file.md

# The AI should have implemented proper error handling for all scenarios
```

### Step 11: Create Test Markdown Files and Directories

```bash
# Create test directory structure
mkdir -p test-docs/input test-docs/output

# Create sample markdown files for testing
echo "# Test Document
This is a test markdown file with **bold** and *italic* text.

## Code Example
\`\`\`bash
echo 'Hello World'
\`\`\`

## List Example
- Item 1
- Item 2
- Item 3
" > test-docs/input/sample.md

# Test the modes (AI should have implemented all these)
./bin/md-to-pdf                                     # Interactive mode
./bin/md-to-pdf test-docs/input/sample.md           # Direct mode (auto output)
./bin/md-to-pdf test-docs/input/sample.md test-docs/output/report.pdf  # Custom output
./bin/md-to-pdf --theme academic test-docs/input/sample.md             # Themed conversion
./bin/md-to-pdf --preview test-docs/input/sample.md                    # Preview mode
```

### Step 12: Handle Issues and Iterate

If issues are found, the autonomous workflow handles fixes:

```
/dev
```

The AI will:
1. Detect the issue from testing results
2. Fix the problem automatically
3. Re-run QA to verify the fix
4. Update progress logs

For complex issues, you can check development status:

```
/status
```

---

## Phase 5: Enhancement & Documentation (7 minutes)

### Step 13: Add Advanced Features

To add enhancements, update the requirements and let the AI continue:

```bash
# Edit requirements to add new features
open .ai-workflow/state/requirements.md
```

Add to the requirements:
```markdown
## Advanced Features
- [ ] Custom CSS: --css option to use custom stylesheets
- [ ] Table of contents: --toc flag to generate PDF bookmarks
- [ ] Page options: --margins, --paper-size (A4, Letter, etc.)
- [ ] Metadata: --title, --author flags for PDF properties
- [ ] Enhanced preview: Show markdown parsing results and theme preview
```

Then continue development:
```
/dev
```

The AI will automatically pick up the new requirements and implement them following the same autonomous cycle.

### Step 14: Generate Comprehensive Tests

```
Create comprehensive Bats tests for the md-to-pdf script.

The tests should cover:
- Help and version output validation
- Dependency checking (pandoc availability)
- Input validation (file paths, theme names)
- Error conditions (invalid files, permissions, malformed markdown)
- Interactive mode simulation
- Direct mode with various argument combinations
- Preview mode functionality
- Theme selection and application

Requirements:
- Save as tests/md-to-pdf.bats
- Use proper Bats test structure with setup() and teardown()
- Test both success and failure scenarios
- Verify exit codes and output content
- Follow the testing patterns from existing test files
```

### Step 15: Final Integration & Distribution Setup

```bash
# Run the new tests
./tests/bats-core/bin/bats tests/md-to-pdf.bats

# Add your script to the installer manifest
# This allows users to install your CLI tool with one command
# Edit install.sh to include bin/md-to-pdf in the SCRIPTS array

# Final quality check
shellcheck bin/md-to-pdf tests/md-to-pdf.bats
shfmt -d bin/md-to-pdf
```

### Step 16: Prepare for Distribution

Now that your tool is complete, you can distribute it like any professional CLI:

```bash
# 1. Update VERSION file for your first release
echo "1.0.0" > VERSION

# 2. Update README.md with your tool's description
# Replace Shell Starter content with your Markdown to PDF converter documentation

# 3. Push to your own GitHub repository
git remote set-url origin https://github.com/your-username/md-to-pdf-cli.git
git add .
git commit -m "feat: add md-to-pdf CLI tool with theme support"
git push -u origin main

# 4. Your users can now install with:
# curl -fsSL https://raw.githubusercontent.com/your-username/md-to-pdf-cli/main/install.sh | bash
```

---

## ✅ Journey Complete!

### What You Built

- **Professional CLI tool** with consistent UX
- **Markdown to PDF conversion** with pandoc integration
- **Interactive and direct modes** for different workflows
- **Built-in theme support** (GitHub, Academic, Clean, Modern)
- **Comprehensive error handling** and user feedback
- **Progress indicators** for conversion operations
- **Complete test suite** for reliability
- **Production-ready code** following Shell Starter conventions

### Verification Checklist

**Functional Requirements (Most Important):**
- [ ] **Actually converts markdown to PDF** - core functionality works with test data
- [ ] **Generates valid PDF files** that can be opened and viewed
- [ ] **Handles real markdown content** including headers, lists, code blocks, formatting

**Shell Starter Integration:**
- [ ] Script has `--help` and `--version` flags
- [ ] Uses Shell Starter logging functions consistently
- [ ] Handles missing dependencies gracefully (pandoc)
- [ ] Validates all user inputs with helpful error messages
- [ ] Shows progress during conversion operations

**Quality Assurance:**
- [ ] Passes shellcheck and shfmt quality checks
- [ ] Has comprehensive test coverage
- [ ] Works with various markdown files and theme selections

**Critical Test:** If the script doesn't actually convert a markdown file to a viewable PDF, the journey has failed regardless of code quality scores.

### Key Learning Outcomes

1. **AI Prompting**: How to craft effective prompts for Shell Starter compliance
2. **Library Integration**: Using Shell Starter's logging, spinner, and utility functions
3. **Error Handling**: Professional error messages and graceful failure modes
4. **Testing Strategy**: Comprehensive test coverage with Bats
5. **Code Quality**: Automated linting and formatting workflows

---

## 🎨 Enhancement Ideas

Ready to take it further? Try these enhancements:

### Advanced Features
- **Custom templates**: Create reusable pandoc templates for different document types
- **Batch processing**: Convert multiple markdown files in a directory
- **Live preview**: Watch mode that regenerates PDF when markdown changes
- **Plugin system**: Support for custom pandoc filters and processors

### Integration Improvements
- **Configuration files**: Support for saving/loading conversion presets
- **Git integration**: Auto-convert README.md files in repositories
- **Editor plugins**: VS Code/Vim plugins for one-click conversion
- **Web interface**: Simple web UI for drag-and-drop markdown conversion

### Professional Features
- **Document merging**: Combine multiple markdown files into single PDF
- **Citation support**: Bibliography and academic citation formatting
- **Collaboration**: Team templates and shared style configurations
- **Quality assurance**: Markdown linting and validation before conversion

---

## 📚 What's Next?

- Try the [File Converter Journey](../coming-soon.md) to build a multi-format conversion tool
- Explore [Manual Development approaches](../coming-soon.md) without AI assistance
- Check out [Team Development workflows](../coming-soon.md) for collaborative CLI projects

---

**Total Development Time:** ~40 minutes from Shell Starter template to distributed CLI tool

**Key Insight:** Shell Starter's standardized structure and comprehensive documentation makes AI-assisted development incredibly effective when the workflow focuses on building functional tools that solve real problems.
