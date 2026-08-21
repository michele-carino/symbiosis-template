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

# Start the IDE AI facility (Ollama) using CPU (default)
ollama-up:
    @echo "Starting Ollama IDE facility (CPU mode)..."
    docker compose up --build -d

# Start the IDE AI facility (Ollama) using AMD Vulkan acceleration
ollama-up-vulkan:
    @echo "Starting Ollama IDE facility (Vulkan GPU mode)..."
    docker compose -f docker-compose.yml -f docker-compose.vulkan.override.yml up --build -d

# Stop the IDE AI facility
ollama-down:
    @echo "Stopping Ollama IDE facility..."
    docker compose down

# View logs of the IDE AI facility
ollama-logs:
    docker compose logs -f ollama

# Install Ollama models
ollama-models-install:
    docker compose --profile manual run --rm ollama-init

# List installed Ollama models
ollama-models-list:
    @docker compose exec -T ollama ollama list

# Ask a question to a specific Ollama model (usage: just ollama-ask <model> <prompt>)
ollama-models-prompt model prompt:
    @docker compose exec -it ollama ollama run {{model}} "{{prompt}}"