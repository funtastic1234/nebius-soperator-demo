#!/bin/bash
# Quick script to push to GitHub
# Usage: ./PUSH_TO_GITHUB.sh YOUR_GITHUB_USERNAME REPO_NAME

set -e

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <github-username> <repo-name>"
    echo "Example: $0 myusername nebius-soperator-assignment"
    exit 1
fi

GITHUB_USER="$1"
REPO_NAME="$2"

echo "=========================================="
echo "Pushing to GitHub"
echo "=========================================="
echo "Repository: https://github.com/$GITHUB_USER/$REPO_NAME"
echo ""

# Check if remote already exists
if git remote get-url origin >/dev/null 2>&1; then
    echo "Remote 'origin' already exists:"
    git remote get-url origin
    read -p "Do you want to update it? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git remote set-url origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"
    else
        echo "Keeping existing remote"
    fi
else
    echo "Adding remote..."
    git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"
fi

# Set branch to main
git branch -M main

# Push
echo ""
echo "Pushing to GitHub..."
git push -u origin main

echo ""
echo "=========================================="
echo "✓ Successfully pushed to GitHub!"
echo "=========================================="
echo "View your repository at:"
echo "https://github.com/$GITHUB_USER/$REPO_NAME"
echo ""
