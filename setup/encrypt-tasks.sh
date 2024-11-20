#!/bin/bash

# This script encrypts the task files
if [ ! -d "tasks" ]; then
    echo "Error: tasks directory not found"
    exit 1
fi

# Generate encryption key
TASK_KEY=$(openssl rand -base64 32)

# Create zip of task files
cd tasks
zip -r ../task.zip docs/ starter/
cd ..

# Encrypt the zip file
openssl enc -aes-256-cbc -salt -in task.zip -out task.enc -pass pass:"${TASK_KEY}"

# Cleanup
rm task.zip

echo "Tasks encrypted successfully!"
echo "TASK_KEY: ${TASK_KEY}"
echo "Store this key securely in GitHub Secrets"