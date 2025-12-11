#!/usr/bin/env bash
# exporter.sh
# Purpose: Read .env and export all variables to environment
# Usage: `source ./exporter.sh`

ENV_FILE=".env"

if [[ ! -f "$ENV_FILE" ]]; then
    echo "❌ .env file not found at $ENV_FILE. Provide One"
    exit 1
fi

echo "🔹 Loading environment variables from $ENV_FILE..."

# Read each line
while IFS= read -r line || [[ -n "$line" ]]; do
    # Ignore comments and empty lines
    [[ "$line" =~ ^#.*$ ]] && continue
    [[ -z "$line" ]] && continue

    # Export key=value
    export "$line"
done < "$ENV_FILE"

echo "✅ All variables exported successfully."
