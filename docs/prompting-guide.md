# Shell Starter - PRD Generation Guide

This guide helps you create comprehensive Product Requirements Documents (PRD) for your Shell Starter projects using AI assistance.

## 📋 Quick Start: PRD Generation Prompt

Use this prompt template with any AI assistant to generate a complete requirements.md:

```
Create a comprehensive Product Requirements Document (PRD) for a [PROJECT_TYPE] CLI tool called "[PROJECT_NAME]".

## Project Context:
- **Purpose**: [What problem does this solve?]
- **Target Users**: [Who will use this tool?]
- **Core Functionality**: [Main feature in 1-2 sentences]

## Requirements:
Generate a PRD following this exact structure with NO checkboxes or REQ-X codes:

### Product Overview
- Clear problem statement and solution approach
- Target user identification

### Primary Command/Tool Definition
**CRITICAL:** Define the main command and its primary function - this drives implementation
- Primary function description (what does this tool DO?)
- Main command pattern with arguments
- Required dependencies (external tools needed)
- Input/output specification with examples

### User Stories  
- 3-5 user stories in "As a [user], I want [goal] so that [benefit]" format

### Core Functionality (Implementation Requirements)
**CRITICAL:** These define what must be implemented - be specific about the actual work
- Primary feature with exact implementation steps
- Input validation specifications
- Error handling requirements
- Verification criteria (how to test it works)

### Advanced Features
- 4-6 additional features with clear acceptance criteria
- Focus on user-facing functionality beyond core implementation

### CLI Interface Requirements
- Interactive mode specifications
- Direct command-line usage patterns
- Help and version requirements

### Shell Starter Compliance
- Integration with Shell Starter library functions
- Logging, error handling, and UI standards
- Argument parsing conventions

### Technical Requirements
- Dependency management
- Input/output validation
- Cross-platform compatibility
- File handling requirements

### Error Handling Scenarios
- Specific error cases and expected responses
- User guidance for common issues

### Quality & Performance Requirements
- Code quality standards (shellcheck, shfmt)
- Testing requirements
- Performance expectations

### Success Criteria & Verification
**CRITICAL:** How to verify the tool actually works
- Functional test: tool successfully completes its primary purpose with real test data
- Quality standards: passes shellcheck and shfmt with no errors
- User experience: all user stories can be completed successfully
- Integration requirements: works with Shell Starter installer system
- Manual test cases: specific scenarios to verify functionality

Format as clean markdown with bullet points only. No task codes or checkboxes.
```

## ⚠️ Critical Requirements for Functional Implementation

**IMPORTANT:** Recent improvements to Shell Starter's AI workflow prevent a common issue where autonomous development would create perfectly compliant scripts that didn't actually perform their primary function.

### Essential Sections for Working Tools

**Always Include These Sections:**
- **Primary Command/Tool Definition**: Forces specification of what the tool actually does
- **Core Functionality (Implementation Requirements)**: Requires specific implementation steps, not generic descriptions
- **Success Criteria & Verification**: Emphasizes functional testing over code quality metrics

**Example of Specific vs Generic Requirements:**

❌ **Generic (leads to wrapper scripts):**
```
- Core feature: Process files efficiently
- Implementation: Add core processing logic
- Verification: Test the functionality
```

✅ **Specific (leads to working tools):**
```
- Primary feature: Convert markdown to PDF using pandoc
- Implementation: Call pandoc with proper arguments: pandoc "$input_file" -o "$output_file" --pdf-engine=xelatex
- Verification: Generate PDF from sample markdown file and verify it opens correctly
```

## 🎯 Example Usage

### Example 1: File Converter Tool
```
Create a comprehensive Product Requirements Document (PRD) for a file format conversion CLI tool called "universal-convert".

## Project Context:
- **Purpose**: Convert between common file formats (images, documents, media) with a single CLI tool
- **Target Users**: Developers, content creators, system administrators
- **Core Functionality**: Multi-format file conversion with automatic format detection and batch processing

[Continue with the template above...]
```

### Example 2: Development Utility
```
Create a comprehensive Product Requirements Document (PRD) for a development workflow CLI tool called "env-manager".

## Project Context:
- **Purpose**: Manage multiple development environments and their configurations across projects
- **Target Users**: Software developers, DevOps engineers, team leads
- **Core Functionality**: Switch between development environments, manage environment variables, and sync configurations

[Continue with the template above...]
```

## 🔧 Customization Guidelines

### Adapting the Template

**For Simple Tools** (single-purpose utilities):
- Reduce Core Features to 2-3 items
- Simplify CLI Interface Requirements
- Focus on one primary user type

**For Complex Tools** (multi-command systems):
- Expand Core Features to 6-8 items
- Add subcommand specifications to CLI Interface
- Include multiple user personas

**For Integration Tools** (work with external systems):
- Emphasize dependency checking in Technical Requirements
- Expand Error Handling Scenarios
- Add API/external service requirements

### Domain-Specific Additions

**For File Processing Tools**:
- Add file format specifications
- Include performance requirements for large files
- Specify backup and safety features

**For Network Tools**:
- Add connectivity requirements
- Include timeout and retry specifications
- Specify authentication methods

**For Development Tools**:
- Add IDE/editor integration requirements
- Include configuration file specifications
- Specify Git integration needs

## 📖 PRD Quality Checklist

Use this checklist to ensure your generated PRD is comprehensive:

### Content Completeness
- [ ] Clear problem statement and target users identified
- [ ] **Primary Command/Tool Definition section included** (critical for implementation)
- [ ] **Core Functionality section with specific implementation steps** (prevents wrapper scripts)
- [ ] 3+ user stories that cover main use cases
- [ ] Advanced features have measurable acceptance criteria
- [ ] CLI interface patterns are specifically defined
- [ ] Error scenarios include user guidance
- [ ] **Success criteria emphasize functional testing** (tool must actually work)

### Shell Starter Alignment
- [ ] References Shell Starter conventions
- [ ] Specifies lib/main.sh usage
- [ ] Includes logging and UI requirements
- [ ] Mentions shellcheck/shfmt compliance
- [ ] Covers bats testing expectations

### Technical Clarity
- [ ] Dependencies are explicitly listed
- [ ] Input/output validation is specified
- [ ] File handling requirements are clear
- [ ] Cross-platform needs are addressed
- [ ] Performance expectations are realistic

### AI Implementation Readiness
- [ ] **Primary function is explicitly defined** (what the tool actually does)
- [ ] **Implementation steps are specific, not generic** (actual commands/code to execute)
- [ ] **Functional verification is mandatory** (must test with real data)
- [ ] Requirements are specific enough for AI to implement without guessing
- [ ] Acceptance criteria are unambiguous and testable
- [ ] Technical details provide sufficient guidance for actual implementation
- [ ] Error handling covers edge cases with specific responses
- [ ] Integration points are well-defined

## 🚀 Advanced Prompting Techniques

### Iterative Refinement
After generating an initial PRD, use these follow-up prompts:

```
Review the generated PRD and enhance the [SECTION] section with:
- More specific acceptance criteria
- Additional edge cases for error handling
- Clearer technical specifications
- Better user experience details
```

### Domain Expert Perspective
```
Review this PRD from the perspective of a [DOMAIN] expert and suggest:
- Industry-specific requirements that are missing
- Best practices that should be included
- Common pitfalls to avoid
- Standards compliance requirements
```

### User Experience Focus
```
Enhance this PRD's user experience requirements by adding:
- Specific help text and usage examples
- Interactive prompt specifications
- Progress feedback requirements
- Error message formatting standards
```

## 📝 Template Variations

### Minimal PRD Template (for simple tools)
```markdown
# [project-name] - Product Requirements Document

## Product Overview
[Brief description and target users]

## Core Features
- [Main functionality]
- [Secondary features]

## CLI Interface
- [Usage patterns]
- [Help/version requirements]

## Technical Requirements
- [Dependencies and validation]
- [Shell Starter compliance]

## Success Criteria
- [Completion indicators]
```

### Comprehensive PRD Template (for complex tools)
```markdown
# [project-name] - Product Requirements Document

## Product Overview
[Detailed problem/solution and user analysis]

## User Stories
[5-8 comprehensive user stories]

## Core Features
[6-10 detailed features with acceptance criteria]

## CLI Interface Requirements
[Detailed command patterns and subcommands]

## Shell Starter Compliance
[Full integration specifications]

## Technical Requirements
[Comprehensive technical specifications]

## Error Handling Scenarios
[Extensive error case coverage]

## Quality & Performance Requirements
[Detailed quality and performance specs]

## Success Criteria
[Comprehensive completion criteria]

## Integration Requirements
[External system integration needs]
```

## 🎨 Best Practices

### Writing Effective Requirements
1. **Be Specific**: "Validate email format" vs "Check input"
2. **Include Examples**: Show expected command usage patterns
3. **Define Acceptance**: What does "success" look like?
4. **Consider Edge Cases**: What could go wrong?
5. **Think User-First**: How will users actually use this?

### Shell Starter Integration
1. **Reference Examples**: Point to existing `bin/` scripts
2. **Use Conventions**: Follow established patterns
3. **Leverage Libraries**: Specify lib/main.sh functions
4. **Plan Testing**: Include bats test requirements
5. **Consider Distribution**: Plan for installer integration

### AI Implementation Success
1. **Define Primary Function First**: Always specify what the tool actually does before adding features
2. **Be Implementation-Specific**: Write "Call pandoc with..." not "Process files efficiently"
3. **Require Functional Testing**: Tool must work with real data, not just pass code quality checks
4. **Provide Context**: Explain the "why" behind requirements
5. **Be Measurable**: Include testable criteria that verify actual functionality
6. **Show Relationships**: How features connect together
7. **Include Priorities**: Core implementation is essential, advanced features are nice-to-have
8. **Plan Phases**: Always include "Core Implementation" phase between foundation and polish

---

**Pro Tip**: Start with the minimal template for simple tools, then expand to comprehensive format for complex projects. The AI will follow your PRD structure when implementing, so invest time in getting requirements right upfront.