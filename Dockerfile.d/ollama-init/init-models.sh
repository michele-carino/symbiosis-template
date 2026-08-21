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

while read -r model || [ -n "$model" ]; do
    # Rimuovi eventuali ritorni a capo Windows (CRLF)
    model=$(echo "$model" | tr -d '\r')

    # Salta commenti e righe vuote
    case "$model" in
        \#*|'') continue ;;
    esac

    echo ""
    echo "👉 Checking/Pulling model: [ ${model} ]"

    curl -s -X POST "${HOST}/api/pull" \
         -H "Content-Type: application/json" \
         -d "{\"name\": \"${model}\"}"

    echo ""
    echo "✅ Finished processing: ${model}"
done < "$MODELS_FILE"

echo ""
echo "=========================================="
echo " All models processed successfully!"
echo "=========================================="