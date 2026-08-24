# Justfile - Local Task Runner for Symbiosis

# Default recipe: list all available operations
default:
    @just --list

# Generate a new specification file from template inside specs/YYYY/MM/
spec TITLE="new-task":
    #!/usr/bin/env bash
    set -euo pipefail
    
    YEAR=$(date +%Y)
    MONTH=$(date +%m)
    DATE=$(date +%Y-%m-%d)
    
    # Clean title (replace spaces with hyphens, lowercase)
    SLUG=$(echo "{{TITLE}}" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
    
    DIR="specs/${YEAR}/${MONTH}"
    FILE="${DIR}/${DATE}-${SLUG}.md"
    
    mkdir -p "${DIR}"
    
    if [ -f "${FILE}" ]; then
        echo "Error: Specification file '${FILE}' already exists."
        exit 1
    fi
    
    cp specs/_template.md "${FILE}"
    echo "Created new spec file: ${FILE}"

# Build local artifacts
build:
    @echo "Building local artifacts..."

# Run local test suite
test:
    @echo "Running local tests..."

# Run local development environment
dev:
    @echo "Starting local dev environment..."

# --- IDE Facilities: Ollama (AI Engine) ---

# Build and setup Ollama AI facility using the specified mode (defaults to cpu)
ollama-build mode="cpu":
    @echo "Starting Ollama facility ({{mode}} mode)..."
    @just ollama-up "{{mode}}"

    @echo "📥 Installing models and setting up Continue.dev..."
    @just ollama-models-install
    @echo "Ollama facility is fully ready for use!"

# Start the IDE AI facility (Ollama) with a specific mode: cpu (default), vulkan, or nvidia
ollama-up mode="cpu":
    @echo "Starting Ollama IDE facility ({{mode}} mode)..."
    @if [ "{{mode}}" = "vulkan" ]; then \
        docker compose -f docker-compose.yml -f docker-compose.vulkan.override.yml up --build --wait -d; \
    elif [ "{{mode}}" = "nvidia" ]; then \
        docker compose -f docker-compose.yml -f docker-compose.nvidia.override.yml up --build --wait -d; \
    elif [ "{{mode}}" = "cpu" ]; then \
        docker compose up --build --wait -d; \
    else \
        echo "Error: Unknown mode '{{mode}}'. Use 'cpu', 'vulkan', or 'nvidia'."; \
        exit 1; \
    fi

# Stop the IDE AI facility
ollama-down:
    @echo "Stopping Ollama IDE facility..."
    docker compose down

# View logs of the IDE AI facility
ollama-logs:
    docker compose logs -f ollama

# Install Ollama models and generate Continue config
ollama-models-install:
    docker compose --profile manual run --rm ollama-init
    # Configure continue.dev plugin
    mkdir -p ./.continue
    cp ./Dockerfile.d/ollama-init/output/continue.dev/config.json ./.continue/config.json
    echo "Continue.dev config file saved at ~/.continue/config.json"

# List installed Ollama models
ollama-models-list:
    @docker compose exec -T ollama ollama list

# Ask a question to a specific Ollama model (usage: just ollama-ask <model> <prompt>)
ollama-models-prompt model prompt:
    @docker compose exec -it ollama ollama run {{model}} "{{prompt}}"