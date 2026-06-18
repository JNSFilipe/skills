# 🛠️ Agent Skills for Claude Code & Codex

A curated collection of 5 powerful custom agent skills designed to enhance and direct AI coders (like **Claude Code** and **Codex / Gemini Code Assist**). These skills enable structured processes for system design, codebase refactoring, test-driven development, issue breakdown, and requirements definition.

Sources & Inspiration:
- [5 Agent Skills I Use Every Day (AI Hero)](https://www.aihero.dev/5-agent-skills-i-use-every-day)

---

## 📦 Included Skills

| Command / Trigger | Directory | Description |
| :--- | :--- | :--- |
| `/grilling` | [`skills/grill-me`](file:///Users/jfilipe/Documents/GitHub/skills/skills/grill-me) | Walks the user relentlessly down a design tree to stress-test plans, resolve dependencies, and find a shared understanding. |
| `/improve-codebase-architecture` | [`skills/improve-codebase-architecture`](file:///Users/jfilipe/Documents/GitHub/skills/skills/improve-codebase-architecture) | Scans a codebase for refactoring opportunities, outputs a visual HTML report, and recommends design improvements. |
| `/tdd` | [`skills/tdd`](file:///Users/jfilipe/Documents/GitHub/skills/skills/tdd) | Directs a vertical, tracer-bullet test-driven development flow (red-green-refactor) focused on public interfaces. |
| `/to-issues` | [`skills/to-issues`](file:///Users/jfilipe/Documents/GitHub/skills/skills/to-issues) | Breaks a plan or PRD into independently-trackable vertical tracer-bullet issues for issue trackers (e.g. GitHub/Jira). |
| `/to-prd` | [`skills/to-prd`](file:///Users/jfilipe/Documents/GitHub/skills/skills/to-prd) | Synthesizes current conversation context and codebase state into a Product Requirements Document (PRD). |

---

## 🚀 Easy Installation

You can install all 5 skills at once using the interactive helper script `install.sh`. 

### 1. Interactive Mode (Recommended)
Simply run the script with no arguments to select where and how to install:
```bash
./install.sh
```

### 2. Project-Local Installation
To install the skills to a specific project (so anyone working in the project has access to them):
```bash
# Install to the current repository
./install.sh --local

# Install to a specific target repository path
./install.sh --local /path/to/your-project
```
This creates:
- Claude Code skills in `<project-path>/.claude/skills/`
- Codex skills in `<project-path>/.agents/skills/`

### 3. Global Installation
To make these skills available across all projects on your machine:
```bash
./install.sh --global
```
This installs:
- Claude Code skills in `~/.claude/skills/`
- Codex skills in `~/.gemini/config/skills/`

### 4. Claude Code Plugin Marketplace (Alternative)
You can register this repository directly as a custom plugin marketplace in Claude Code:
1. Run the following command in Claude Code (or paste the repository URL `https://github.com/JNSFilipe/skills` in the "Add marketplace" UI):
   ```bash
   /plugin marketplace add JNSFilipe/skills
   ```
2. Install the `dev-skills` plugin from the newly added marketplace:
   ```bash
   /plugin install dev-skills@jnsfilipe-skills
   ```
This will register all 5 skills (`/grilling`, `/tdd`, `/to-prd`, `/to-issues`, `/improve-codebase-architecture`) natively.

---

## ⚙️ Installation Modes

You can specify how files are installed via the `--mode` flag:

*   **Copy Mode (Default)**: `--mode copy`  
    Copies all skill folders into the destination directory. This is completely self-contained; you can safely delete or move this repository after installing.
*   **Symlink Mode**: `--mode symlink`  
    Creates symbolic links pointing from the destination directory to this repository. This is recommended if you plan on modifying the skill files in this repository, as updates will apply immediately without needing to re-run the installer.

Examples:
```bash
# Installs globally using symlinks
./install.sh --global --mode symlink

# Installs locally using copy mode
./install.sh --local --mode copy
```

---

## 🛠️ Requirements & Structure
Each skill in the `skills/` directory contains:
- `SKILL.md`: The instruction document containing YAML frontmatter (`name` and `description`) followed by system instructions.
- Supporting resources (e.g., helper markdown files, guidelines, or templates) that are referenced relative to the `SKILL.md` file.

Both Claude Code and Codex will automatically parse these directories and register them as custom agents/slash commands.

---

## 🗑️ Uninstallation

If you ever need to uninstall the skills, you can use the `uninstall.sh` script.

### 1. Interactive Mode
Run the script with no arguments to select where to uninstall from:
```bash
./uninstall.sh
```

### 2. Project-Local Uninstallation
To remove the skills from a specific project:
```bash
./uninstall.sh --local

# Or specify a path
./uninstall.sh --local /path/to/your-project
```

### 3. Global Uninstallation
To remove the skills globally from your home directory:
```bash
./uninstall.sh --global
```
