#!/bin/bash

# Feynman Game - Git Deploy Script
# This script commits and pushes all changes to GitHub

set -e  # Exit on error

echo "🚀 Feynman Game Deploy Script"
echo "=============================="
echo ""

# Check if git is initialized
if [ ! -d .git ]; then
    echo "📦 Initializing Git repository..."
    git init
    echo "✓ Git initialized"
    echo ""
fi

# Check git status
echo "📊 Current Git Status:"
git status
echo ""

# Add all files
echo "📝 Adding all files..."
git add .
echo "✓ Files staged"
echo ""

# Prompt for commit message
read -p "📌 Enter commit message (or press Enter for default): " commit_msg
if [ -z "$commit_msg" ]; then
    commit_msg="Add physics challenges: Projectile Motion, Pendulum, and Circular Motion with Feynman Lectures links"
fi

# Commit
echo "💾 Committing changes..."
git commit -m "$commit_msg"
echo "✓ Changes committed"
echo ""

# Check if remote exists
if ! git remote get-url origin > /dev/null 2>&1; then
    echo "🔗 No remote found. Enter your GitHub repository URL:"
    read -p "GitHub URL: " github_url
    git remote add origin "$github_url"
    echo "✓ Remote added"
    echo ""
fi

# Push to GitHub
echo "🌐 Pushing to GitHub..."
git branch -M main
git push -u origin main
echo "✓ Successfully pushed to GitHub!"
echo ""

echo "✅ Deploy complete!"
