#!/bin/bash

# Configuration
CONTENT_DIR="content"
EXIT_CODE=0

echo "Starting link validation..."

# Find all markdown files and verify links
while read -r FILE; do
    # Extract internal links starting with /docs/ or /cn/docs/
    # We look for [text](url) pattern where url starts with /docs/ or /cn/docs/
    # Using grep to find all matching links in the file
    while read -r MATCH; do
        if [ -z "$MATCH" ]; then continue; fi
        
        # Extract URL from ](url)
        LINK=${MATCH#*](}
        LINK=${LINK%)}
        
        # Remove anchor and query parameters
        CLEAN_LINK=$(echo "$LINK" | cut -d'#' -f1 | cut -d'?' -f1)
        CLEAN_LINK=${CLEAN_LINK%/}
        
        # Determine target file path based on language prefix
        if [[ "$CLEAN_LINK" == /docs/* ]]; then
            TARGET_PATH="content/en${CLEAN_LINK}"
        elif [[ "$CLEAN_LINK" == /cn/docs/* ]]; then
            TARGET_PATH="content${CLEAN_LINK}"
        else
            continue
        fi

        # Check for file existence variations
        FOUND=false
        
        # Check 1: As .md file
        if [[ -f "${TARGET_PATH}.md" ]]; then
            FOUND=true
        # Check 2: Exact file (if extension was included)
        elif [[ -f "$TARGET_PATH" ]]; then
            FOUND=true
        # Check 3: Directory index
        elif [[ -f "${TARGET_PATH}/_index.md" ]]; then
            FOUND=true
        # Check 4: Directory README (legacy)
        elif [[ -f "${TARGET_PATH}/README.md" ]]; then
            FOUND=true
        fi
        
        if [ "$FOUND" = false ]; then
            echo "Error: Broken link in $FILE"
            echo "  Link: $LINK"
            echo "  Target: $TARGET_PATH (and variants)"
            EXIT_CODE=1
        fi
    done < <(grep -oE '\]\((/docs/|/cn/docs/)[^)]+\)' "$FILE")
done < <(find "$CONTENT_DIR" -type f -name "*.md")

if [ $EXIT_CODE -eq 0 ]; then
    echo "Link validation passed!"
else
    echo "Link validation failed!"
fi

exit $EXIT_CODE
