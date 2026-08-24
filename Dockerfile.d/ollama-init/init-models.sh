#!/usr/bin/env sh
set -e

PORT="${OLLAMA_PORT:-11434}"
HOST="http://ollama:${PORT}"
MODELS_FILE="/models.txt"

echo "=========================================="
echo " Starting Ollama Models Auto-Loader..."
echo " Target: ${HOST}"
echo "=========================================="

if [ ! -f "$MODELS_FILE" ]; then
    echo "Error: Models file not found at $MODELS_FILE"
    exit 1
fi

while IFS=, read -r model purpose || [ -n "$model" ]; do
    # Remove spaces and Windows carriage returns (CRLF)
    model=$(echo "$model" | tr -d '\r' | xargs)
    purpose=$(echo "$purpose" | tr -d '\r' | xargs)

    # Skip comments
    case "$model" in
        \#*|'') continue ;;
    esac

    # Verify model has a name
    if [ -z "$model" ]; then
        continue
    fi

    echo ""
    echo "👉 Pulling model: [ ${model} ]"

    curl -s -X POST "${HOST}/api/pull" \
         -H "Content-Type: application/json" \
         -d "{\"name\": \"${model}\"}"

    echo ""
    echo "✅ Finished processing: ${model}"

done < "$MODELS_FILE"

echo ""
echo "=========================================="
echo " All models downloaded successfully!"
echo "=========================================="

echo ""
echo "=========================================="
echo " Creating IDE config files..."
echo "=========================================="

mkdir -p /output

# continue.dev
sh /continue.dev/config.sh