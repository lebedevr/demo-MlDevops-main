#!/usr/bin/env bash
set -euo pipefail

# push_to_github.sh
# A helper script to initialize a git repo (if needed) and push it to a GitHub repository.
# Usage:
#   ./scripts/push_to_github.sh [GITHUB_REPO_URL]
# or set env var:
#   GITHUB_REPO_URL="git@github.com:username/repo.git" ./scripts/push_to_github.sh
#
# Notes:
# - Requires git to be installed and your GitHub auth configured (SSH keys or HTTPS PAT).
# - If the repo is not initialized, this script will create an initial commit.
# - Default branch will be set to `main`.

cyan() { printf "\033[36m%s\033[0m\n" "$*"; }
red() { printf "\033[31m%s\033[0m\n" "$*"; }
green() { printf "\033[32m%s\033[0m\n" "$*"; }

git_check() {
  if ! command -v git >/dev/null 2>&1; then
    red "Error: git is not installed or not in PATH. Please install git first."
    exit 1
  fi
}

get_repo_root() {
  # Use current directory as root; user should run from project root
  REPO_ROOT=$(pwd)
}

ensure_git_repo() {
  if [ ! -d .git ]; then
    cyan "No .git directory found. Initializing new git repository..."
    git init
  else
    cyan ".git directory found. Using existing repository."
  fi
}

ensure_main_branch() {
  # Determine current branch if any
  current_branch=""
  if git rev-parse --abbrev-ref HEAD >/dev/null 2>&1; then
    current_branch=$(git rev-parse --abbrev-ref HEAD || echo "")
  fi

  # If HEAD is detached or no branch, try to create/switch to main
  if [ -z "$current_branch" ] || [ "$current_branch" = "HEAD" ]; then
    cyan "Creating 'main' branch..."
    git checkout -B main
    return
  fi

  if [ "$current_branch" != "main" ]; then
    cyan "Renaming current branch '$current_branch' to 'main'..."
    git branch -M main
  else
    cyan "On 'main' branch."
  fi
}

ensure_initial_commit() {
  if git rev-parse --verify HEAD >/dev/null 2>&1; then
    cyan "Repository already has commits."
  else
    cyan "Creating initial commit..."
    git add -A
    git commit -m "Initial commit"
  fi
}

configure_remote() {
  local url="${1:-}";
  if [ -z "$url" ]; then
    url="${GITHUB_REPO_URL:-}"
  fi
  if git remote get-url origin >/dev/null 2>&1; then
    cyan "Remote 'origin' already set to $(git remote get-url origin)."
    if [ -n "$url" ] && [ "$(git remote get-url origin)" != "$url" ]; then
      red "Provided URL differs from existing 'origin'. To change it, run: git remote set-url origin $url"
    fi
  else
    if [ -z "$url" ]; then
      red "No GitHub repo URL provided. Please provide it as an argument or GITHUB_REPO_URL env var."
      red "Examples:"
      red "  ./scripts/push_to_github.sh git@github.com:USERNAME/REPO.git"
      red "  GITHUB_REPO_URL=https://github.com/USERNAME/REPO.git ./scripts/push_to_github.sh"
      exit 1
    fi
    cyan "Adding remote 'origin' => $url"
    git remote add origin "$url"
  fi
}

push_main() {
  cyan "Pushing 'main' to 'origin' (setting upstream)..."
  git push -u origin main
  green "Push completed successfully."
}

main() {
  git_check
  get_repo_root
  ensure_git_repo
  ensure_initial_commit
  ensure_main_branch
  configure_remote "${1:-}"
  push_main
}

main "$@"
