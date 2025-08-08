# demo-MlDevops

Repository to showcase hello-world examples of ML in DevOps.

## Push this project to GitHub

You can push this project to your GitHub account using either the provided helper script or manual git commands.

### Prerequisites
- git installed (git --version)
- A GitHub account
- Authentication configured for GitHub:
  - SSH: set up SSH keys and add them to GitHub (recommended), or
  - HTTPS: use a Personal Access Token (PAT) with repo scope
- Optional: GitHub CLI (gh) if you prefer creating repos from the CLI

### Option A: Use the helper script (recommended)

1) Create a new empty repository on GitHub (via web UI) and copy its URL, e.g.:
   - SSH: git@github.com:USERNAME/REPO.git
   - HTTPS: https://github.com/USERNAME/REPO.git

2) From the project root, run one of:

   Using positional argument:
   ./scripts/push_to_github.sh git@github.com:USERNAME/REPO.git

   Using environment variable:
   GITHUB_REPO_URL=https://github.com/USERNAME/REPO.git ./scripts/push_to_github.sh

What the script does:
- Initializes a git repo if none exists
- Creates an initial commit if none exists
- Ensures the default branch is main
- Adds the remote origin if missing
- Pushes main to origin and sets upstream

Troubleshooting:
- If you see auth errors over HTTPS, ensure you use a PAT instead of a password
- If origin already exists and points elsewhere, change it with:
  git remote set-url origin git@github.com:USERNAME/REPO.git

### Option B: Manual commands

From the project root:

# Initialize repo if needed
[ -d .git ] || git init

# Ensure reasonable ignores
# (A Python-friendly .gitignore is already included.)

# Create initial commit if needed
if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
  git add -A
  git commit -m "Initial commit"
fi

# Ensure branch is 'main'
current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
if [ -z "$current_branch" ] || [ "$current_branch" = "HEAD" ]; then
  git checkout -B main
elif [ "$current_branch" != "main" ]; then
  git branch -M main
fi

# Add remote (replace with your repo URL)
# SSH example:
# git remote add origin git@github.com:USERNAME/REPO.git
# HTTPS example:
# git remote add origin https://github.com/USERNAME/REPO.git

# First push
# If your remote is empty, this sets upstream and pushes main
# (uncomment the appropriate command once remote is set)
# git push -u origin main

### Option C: Create the repo via GitHub CLI (gh) and push

# Create a new private repo under your account (requires 'gh auth login')
# gh repo create USERNAME/REPO --private --source=. --remote=origin --push

This will automatically create the repo, add origin, and push.

### Notes
- Default branch is main to align with modern GitHub defaults.
- Ensure you’re in the project root: /Users/rlebedev/Desktop/demo-MlDevops-main
- Script is located at scripts/push_to_github.sh