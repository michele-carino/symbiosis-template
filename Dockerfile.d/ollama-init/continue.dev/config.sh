#!/usr/bin/env sh
set -e

PORT="${OLLAMA_PORT}"
MODELS_FILE="/models.csv"

echo "=========================================="
echo " Generating Continue.dev YAML Config..."
echo "=========================================="

if [ ! -f "$MODELS_FILE" ]; then
    echo "Error: Models file not found at $MODELS_FILE"
    exit 1
fi

MODELS_YAML=""
has_chat=0
has_autocomplete=0
EMBEDDING_MODEL=""
RERANK_MODEL=""

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
        reasoning)
            has_chat=1
            MODEL_BLOCK="  - name: \"${model} (${purpose})\"
    provider: ollama
    model: \"${model}\"
    apiBase: \"http://127.0.0.1:${PORT}\"
    roles:
      - chat
      - edit"
            ;;
        chat|general)
            has_chat=1
            MODEL_BLOCK="  - name: \"${model} (${purpose})\"
    provider: ollama
    model: \"${model}\"
    apiBase: \"http://127.0.0.1:${PORT}\"
    roles:
      - chat
      - edit
      - apply"
            ;;
        autocomplete)
            has_autocomplete=1
            MODEL_BLOCK="  - name: \"Ollama Autocomplete (${model})\"
    provider: ollama
    model: \"${model}\"
    apiBase: \"http://127.0.0.1:${PORT}\"
    roles:
      - autocomplete"
            ;;
        embedding)
            EMBEDDING_MODEL="$model"
            MODEL_BLOCK="  - name: \"Nomic Embed\"
    provider: ollama
    model: \"${model}\"
    apiBase: \"http://127.0.0.1:${PORT}\"
    roles:
      - embed"
            ;;
        rerank)
            RERANK_MODEL="$model"
            MODEL_BLOCK="  - name: \"BGE Rerank\"
    provider: ollama
    model: \"${model}\"
    apiBase: \"http://127.0.0.1:${PORT}\"
    roles:
      - rerank"
            ;;
        *)
            echo "Error: Unknown purpose '$purpose' for model '$model' in $models.txt"
            exit 1
            ;;
    esac

    if [ -z "$MODELS_YAML" ]; then
        MODELS_YAML="$MODEL_BLOCK"
    else
        MODELS_YAML="${MODELS_YAML}
${MODEL_BLOCK}"
    fi

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

# Copia il template YAML e sostituisce i placeholder
cp /continue.dev/config.yaml /tmp/config.yaml

mkdir -p /output/continue.dev

printf '%s\n' "$MODELS_YAML" > /tmp/models_block.txt
awk '
    NR==FNR { block = block $0 "\n"; next }
    /__MODELS_PLACEHOLDER__/ { printf "%s", block; next }
    { print }
' /tmp/models_block.txt /tmp/config.yaml > /tmp/config.yaml.tmp && mv /tmp/config.yaml.tmp /output/continue.dev/config.yaml

cat /output/continue.dev/config.yaml

echo ""
echo "=========================================="
echo " Continue.dev config.yaml created successfully!"
echo "=========================================="