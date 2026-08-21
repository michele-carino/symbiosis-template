ARG OLLAMA_BASE_IMAGE=ollama/ollama:latest
FROM ${OLLAMA_BASE_IMAGE}

# Define build argument and default port
ARG OLLAMA_PORT=11500
ENV OLLAMA_HOST="0.0.0.0:${OLLAMA_PORT}"

# The main container process directly runs Ollama server
ENTRYPOINT ["ollama", "serve"]