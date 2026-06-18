#!/bin/bash

# exit on error
set -e

# ANSI Color Codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Determine script directories
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SRC_DIR="$SCRIPT_DIR/skills"

show_help() {
  echo -e "${BOLD}Skill Installer for Claude Code & Codex${NC}"
  echo "Easily install repository skills locally or globally."
  echo
  echo -e "${BOLD}Usage:${NC}"
  echo "  ./install.sh [options]"
  echo
  echo -e "${BOLD}Options:${NC}"
  echo "  -l, --local [PATH]    Install locally in the specified project path (default: current directory)"
  echo "  -g, --global          Install globally in your home directory"
  echo "  -m, --mode MODE       Installation mode: 'copy' or 'symlink' (default: copy)"
  echo "  -h, --help            Show this help message"
  echo
  echo -e "${BOLD}Examples:${NC}"
  echo "  ./install.sh --local                   # Install locally in current project"
  echo "  ./install.sh --global --mode symlink   # Install globally via symlinks"
  echo "  ./install.sh --local ~/projects/my-app # Install locally in a specific project"
  echo
}

LOCAL=false
LOCAL_PATH=""
GLOBAL=false
MODE="copy"

# Parse CLI arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -l|--local)
      LOCAL=true
      if [[ -n "$2" && "$2" != -* ]]; then
        LOCAL_PATH="$2"
        shift
      else
        LOCAL_PATH="."
      fi
      ;;
    -g|--global)
      GLOBAL=true
      ;;
    -m|--mode)
      if [[ "$2" == "copy" || "$2" == "symlink" ]]; then
        MODE="$2"
        shift
      else
        echo -e "${RED}Error: Mode must be 'copy' or 'symlink'${NC}" >&2
        exit 1
      fi
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}" >&2
      show_help
      exit 1
      ;;
  esac
  shift
done

# If no target specified, run interactive mode
if [ "$LOCAL" = false ] && [ "$GLOBAL" = false ]; then
  echo -e "${BLUE}=== Skill Installer for Claude Code & Codex ===${NC}"
  echo "Where would you like to install the skills?"
  echo "1) Install locally in the current project (creates .claude/ and .agents/)"
  echo "2) Install globally (creates ~/.claude/ and ~/.gemini/config/)"
  echo "3) Install both locally and globally"
  echo "4) Cancel"
  read -p "Select an option (1-4): " choice
  case $choice in
    1)
      LOCAL=true
      LOCAL_PATH="."
      ;;
    2)
      GLOBAL=true
      ;;
    3)
      LOCAL=true
      LOCAL_PATH="."
      GLOBAL=true
      ;;
    *)
      echo "Installation cancelled."
      exit 0
      ;;
  esac

  echo
  echo "Choose installation mode:"
  echo "1) Copy (self-contained, works if you delete this repo)"
  echo "2) Symlink (updates automatically when you update this repo)"
  read -p "Select a mode (1-2) [default: 1]: " mode_choice
  case $mode_choice in
    2)
      MODE="symlink"
      ;;
    *)
      MODE="copy"
      ;;
  esac
  echo
fi

# Verify source directory
if [ ! -d "$SRC_DIR" ]; then
  echo -e "${RED}Error: Source skills directory not found at: $SRC_DIR${NC}" >&2
  exit 1
fi

# Find all skill folders
SKILLS=()
for dir in "$SRC_DIR"/*; do
  if [ -d "$dir" ]; then
    SKILLS+=("$(basename "$dir")")
  fi
done

if [ ${#SKILLS[@]} -eq 0 ]; then
  echo -e "${RED}Error: No skills found in $SRC_DIR${NC}" >&2
  exit 1
fi

# Function to install a skill to a target folder
install_skill() {
  local skill_name="$1"
  local target_parent_dir="$2"
  local install_mode="$3"

  local src_path="$SRC_DIR/$skill_name"
  local dest_path="$target_parent_dir/$skill_name"

  mkdir -p "$target_parent_dir"

  # Remove existing destination (file, folder, or symlink)
  if [ -e "$dest_path" ] || [ -L "$dest_path" ]; then
    rm -rf "$dest_path"
  fi

  if [ "$install_mode" = "symlink" ]; then
    ln -s "$src_path" "$dest_path"
    echo -e "  ${GREEN}✓${NC} Symlinked ${BOLD}$skill_name${NC} -> $dest_path"
  else
    cp -R "$src_path" "$dest_path"
    echo -e "  ${GREEN}✓${NC} Copied ${BOLD}$skill_name${NC} to $dest_path"
  fi
}

# Run local installation
if [ "$LOCAL" = true ]; then
  # Resolve local path to absolute path
  if [ ! -d "$LOCAL_PATH" ]; then
    mkdir -p "$LOCAL_PATH"
  fi
  ABS_LOCAL_PATH="$(cd "$LOCAL_PATH" && pwd)"
  
  echo -e "${BLUE}Installing skills locally in: ${BOLD}$ABS_LOCAL_PATH${NC} using ${BOLD}$MODE${NC} mode..."
  
  # Claude Code local path
  CLAUDE_LOCAL="$ABS_LOCAL_PATH/.claude/skills"
  echo -e "${YELLOW}Installing for Claude Code (.claude/skills/)...${NC}"
  for skill in "${SKILLS[@]}"; do
    install_skill "$skill" "$CLAUDE_LOCAL" "$MODE"
  done
  
  # Codex local path
  CODEX_LOCAL="$ABS_LOCAL_PATH/.agents/skills"
  echo -e "${YELLOW}Installing for Codex (.agents/skills/)...${NC}"
  for skill in "${SKILLS[@]}"; do
    install_skill "$skill" "$CODEX_LOCAL" "$MODE"
  done
  echo
fi

# Run global installation
if [ "$GLOBAL" = true ]; then
  echo -e "${BLUE}Installing skills globally using ${BOLD}$MODE${NC} mode..."
  
  # Claude Code global path
  CLAUDE_GLOBAL="$HOME/.claude/skills"
  echo -e "${YELLOW}Installing for Claude Code (~/.claude/skills/)...${NC}"
  for skill in "${SKILLS[@]}"; do
    install_skill "$skill" "$CLAUDE_GLOBAL" "$MODE"
  done
  
  # Codex global path
  CODEX_GLOBAL="$HOME/.gemini/config/skills"
  echo -e "${YELLOW}Installing for Codex (~/.gemini/config/skills/)...${NC}"
  for skill in "${SKILLS[@]}"; do
    install_skill "$skill" "$CODEX_GLOBAL" "$MODE"
  done
  echo
fi

echo -e "${GREEN}${BOLD}Successfully installed all skills!${NC}"
echo "Ready to use in Claude Code (as slash commands) and Codex (via agents)."
