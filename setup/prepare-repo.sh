#!/bin/bash

# This script prepares a new candidate repository

# Check if repository name is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <candidate-repo-name>"
    exit 1
fi

REPO_NAME=$1

# Generate unique key for this assessment
TASK_KEY=$(openssl rand -base64 32)

# Create zip of task files
cd tasks
zip -r ../task.zip docs/ starter/
cd ..

# Encrypt the zip file
openssl enc -aes-256-cbc -salt -in task.zip -out task.enc -pass pass:"${TASK_KEY}"

# Cleanup
rm task.zip
rm -rf docs/ starter/

# Save key to GitHub Secrets
gh secret set TASK_KEY -b"${TASK_KEY}" -R "$REPO_NAME"

# Commit encrypted file
git add task.enc
git commit -m "Add encrypted task files"
git push

echo "Repository prepared successfully!"
echo "TASK_KEY has been saved to GitHub Secrets"