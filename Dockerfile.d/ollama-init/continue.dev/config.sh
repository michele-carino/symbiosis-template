#!/usr/bin/env sh
set -e

PORT="${OLLAMA_PORT:-11434}"
MODELS_FILE="/models.txt"

echo "=========================================="
echo " Generating Continue.dev Config..."
echo "=========================================="

if [ ! -f "$MODELS_FILE" ]; then
    echo "Error: Models file not found at $MODELS_FILE"
    exit 1
fi

MODELS_JSON=""
AUTO_MODEL=""
EMBEDDING_MODEL=""
RERANK_MODEL=""

has_chat=0
has_autocomplete=0

while IFS=, read -r model purpose || [ -n "$model" ]; do
    model=$(echo "$model" | tr -d '\r' | xargs)
    purpose=$(echo "$purpose" | tr -d '\r' | xargs)

    case "$model" in
        \#*|'') continue ;;
    esac

    if [ -z "$model" ] || [ -z "$purpose" ]; then
        echo "Error: Invalid entry in $models.txt (missing model or purpose for '$model')"
        exit 1
    fi

    case "$purpose" in
        reasoning|chat|general)
            has_chat=1
MODEL_BLOCK="    {
      \"title\": \"${model} (${purpose})\",
      \"provider\": \"ollama\",
      \"model\": \"${model}\",
      \"apiBase\": \"http://127.0.0.1:${PORT}\"
    }"
                    if [ -z "$MODELS_JSON" ]; then
                        MODELS_JSON="$MODEL_BLOCK"
                    else
                        # Metti la virgola e vai a capo fisicamente premendo invio
                        MODELS_JSON="${MODELS_JSON},
            ${MODEL_BLOCK}"
                    fi
            ;;
        autocomplete)
            has_autocomplete=1
            AUTO_MODEL="$model"
            ;;
        embedding)
            EMBEDDING_MODEL="$model"
            ;;
        rerank)
            RERANK_MODEL="$model"
            ;;
        *)
            echo "Error: Unknown purpose '$purpose' for model '$model' in $models.txt"
            exit 1
            ;;
    esac
done < "$MODELS_FILE"

# Integrity checks
if [ "$has_chat" -eq 0 ]; then
    echo "Error: No chat, reasoning, or general models found in $models.txt"
    exit 1
fi

if [ "$has_autocomplete" -eq 0 ]; then
    echo "Error: No autocomplete model defined in $models.txt"
    exit 1
fi

if [ -z "$EMBEDDING_MODEL" ]; then
    echo "Error: No embedding model defined in $models.txt"
    exit 1
fi

if [ -z "$RERANK_MODEL" ]; then
    echo "Error: No rerank model defined in $models.txt"
    exit 1
fi

# Copy template and replace placeholders
cp /continue.dev/config.json /tmp/config.json

sed -i "s|\${PORT}|${PORT}|g" /tmp/config.json
sed -i "s|\${AUTO_MODEL}|${AUTO_MODEL}|g" /tmp/config.json
sed -i "s|\${EMBEDDING_MODEL}|${EMBEDDING_MODEL}|g" /tmp/config.json
sed -i "s|\${RERANK_MODEL}|${RERANK_MODEL}|g" /tmp/config.json

mkdir -p /output/continue.dev

printf '%s\n' "$MODELS_JSON" > /tmp/models_block.txt
awk '
    NR==FNR { block = block $0 "\n"; next }
    /__MODELS_PLACEHOLDER__/ { printf "%s", block; next }
    { print }
' /tmp/models_block.txt /tmp/config.json > /tmp/config.json.tmp && mv /tmp/config.json.tmp /output/continue.dev/config.json

cat /output/continue.dev/config.json

echo ""
echo "=========================================="
echo " Continue.dev config file created successfully!"
echo "=========================================="