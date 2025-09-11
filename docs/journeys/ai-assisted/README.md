# AI-Assisted Development Journeys

These journeys show how to leverage AI coding assistants (Claude, ChatGPT, Gemini, etc.) to rapidly build professional CLI tools with Shell Starter.

## 🤖 Why AI-Assisted Development?

AI coding assistants excel at generating Shell Starter-compliant scripts because:

- **Rich context**: Shell Starter provides comprehensive documentation and examples
- **Established patterns**: Clear templates and conventions guide AI responses
- **Quality assurance**: Built-in linting and formatting catch common issues
- **Rapid iteration**: Quickly generate, test, and refine tools

## 📚 Available Journeys

### [Markdown to PDF Converter CLI](md-to-pdf.md)
Build a markdown to PDF conversion tool with pandoc integration and theme support

**What You'll Learn:**
- Crafting effective AI prompts for Shell Starter
- Dependency checking and validation patterns
- Interactive user input handling
- Progress indicators and error reporting
- File conversion workflows with theme systems

**Time:** ~40 minutes • **Level:** Beginner

---

## 🎯 AI-Assisted Development Tips

### Effective Prompting
- Reference Shell Starter conventions explicitly
- Specify the script template to use
- Include examples of desired behavior
- Ask for comprehensive help text

### Quality Assurance
- Always run `shellcheck` and `shfmt` on generated code
- Test edge cases and error conditions
- Validate all user inputs
- Use Shell Starter's logging functions consistently

### Iterative Improvement
- Start with basic functionality
- Add features incrementally
- Use AI to generate tests
- Enhance documentation and examples

## 🔧 Standard AI Prompt Template

```
Create a Shell Starter script named "SCRIPT_NAME" that does the following:
- [Describe primary functionality]
- [List specific requirements]
- [Mention integration needs]

Requirements:
- Follow Shell Starter conventions from docs/conventions.md
- Use the standard script template with proper header
- Include comprehensive help text with examples
- Use logging functions (log::info, log::error, etc.)
- Include proper argument parsing with --help and --version
- Add input validation for all parameters
- Handle errors gracefully with meaningful messages

The script should be saved as bin/SCRIPT_NAME (no .sh extension).
```

## 🚀 Coming Soon

- **File Converter Utility** - Multi-format file conversion with progress tracking
- **Git Workflow Helper** - Automated git operations with safety checks  
- **System Monitor Dashboard** - Real-time system metrics with alerts
- **API Integration Tool** - RESTful API client with authentication
- **Configuration Manager** - Interactive config file management

## 📖 Related Resources

- [Shell Starter AI Guide](../ai-guide.md)
- [Coding Conventions](../conventions.md)
- [Example Scripts](../examples.md)
- [Main Journeys](../README.md)