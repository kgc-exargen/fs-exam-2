#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Check if assessment already started
if git tag | grep -q "assessment-start"; then
    START_TIME=$(git log -1 --format=%ai "assessment-start")
    echo -e "${RED}Assessment has already been started!${NC}"
    echo "Start time: $START_TIME"
    exit 1
fi

echo "Initiating assessment..."
echo "Requesting decryption key..."

# Create a request file
echo "$(date +%s)" > .assessment-request
git add .assessment-request
git commit -m "Requesting assessment start"
git push

# Wait for GitHub Action to process
echo "Waiting for authorization..."
max_attempts=30
attempt=0

while [ $attempt -lt $max_attempts ]; do
    if [ -f ".task-key" ]; then
        TASK_KEY=$(cat .task-key)
        rm .task-key  # Remove key immediately
        
        # Decrypt and extract task files
        openssl enc -d -aes-256-cbc -in task.enc -out task.zip -pass pass:"${TASK_KEY}"
        unzip -q task.zip
        rm task.zip

        # Create the tag and push
        git tag -a "assessment-start" -m "Assessment started at $(date)"
        git push origin "assessment-start"

        # Add and commit the decrypted files
        git add docs/ starter/
        git commit -m "Assessment started at $(date)"
        git push

        END_TIME=$(date -d "+6 hours" '+%Y-%m-%d %H:%M:%S')

        echo -e "${GREEN}Assessment timer started!${NC}"
        echo "Start time: $(date)"
        echo "You have 6 hours to complete the assessment"
        echo "Expected end time: $END_TIME"
        echo -e "${GREEN}Task details are now available in the docs/ folder${NC}"
        
        # Clean up request file
        rm .assessment-request
        git add .assessment-request
        git commit -m "Cleanup assessment request"
        git push
        
        exit 0
    fi
    
    echo "Waiting for authorization... (attempt $((attempt + 1))/$max_attempts)"
    sleep 10
    git pull >/dev/null 2>&1
    attempt=$((attempt + 1))
done

echo -e "${RED}Failed to start assessment. Please contact support.${NC}"
exit 1