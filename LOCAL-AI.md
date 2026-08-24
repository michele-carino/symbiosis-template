# Local AI Facility (Ollama Integration)

Symbiosis includes a fully containerized, offline AI facility powered by **Ollama**. This ensures privacy, cost-free execution, and full alignment with the *Single-Task Local Execution* principle—allowing you to run LLMs directly on your machine without relying on external cloud APIs.

---

## 1. Quick Start Guide

All interactions with the local AI engine are managed locally via the project runner (`Justfile`).

### Prerequisites

* [Docker & Docker Compose](https://www.google.com/search?q=https://www.docs.docker.com/engine/install/) installed and running.
* [Just](https://www.google.com/search?q=https://github.com/case/just) command runner.

### Available Commands

* **Start Ollama (CPU mode):**
  `just ollama-up`
* **Start Ollama (AMD Vulkan GPU acceleration):**
  `just ollama-up-vulkan`
* **Install/Bootstrap required models** (reads from `Dockerfile.d/ollama/models.txt`):
  `just ollama-models-install`
* **List installed models:**
  `just ollama-models-list`
* **Ask a quick question via CLI:**
  `just ollama-ask <model_name> "Your prompt here"`
* **View container logs:**
  `just ollama-logs`
* **Stop the AI facility:**
  `just ollama-down`

---

## 2. Integrating with IDEs

Once the container is running and your models are installed, you can connect your preferred IDE or AI coding assistant directly to the local Ollama instance.

By default, Ollama listens on port `11434` (configurable via `.env` using `OLLAMA_PORT`).

---

### Option A: JetBrains IDEs (IntelliJ, WebStorm, PyCharm, etc.)

If you are using JetBrains AI Assistant or third-party plugins (such as *Continue* or *CodeGPT*) that support local LLMs:

1. Ensure Ollama is running (`just ollama-up`).
2. Open your JetBrains IDE settings (`Settings / Preferences` -> `Tools` or `Plugins`).
3. Locate your AI assistant plugin settings.
4. Set the **Provider** to `Ollama` (or Custom OpenAI/Compatible API).
5. Configure the endpoint URL:
* **URL:** `http://localhost:11434` (or your custom `${OLLAMA_PORT}`)


6. Select the model you downloaded via `models.csv` (e.g., `llama3` or `deepseek-coder`).

---

### Option B: Visual Studio Code (VS Code)

The most popular way to use local models in VS Code is via the **Continue** extension or **CodeGPT**.

#### Using the *Continue* Extension:

1. Make sure Ollama is up and running (`just ollama-up`).
2. Install the **Continue** extension from the VS Code Marketplace.
3. Open the Continue configuration file (usually located at `~/.continue/config.json` or via the Continue gear icon).
4. Add Ollama as your model provider:
```json
{
  "models": [
    {
      "title": "Local Ollama",
      "provider": "ollama",
      "model": "llama3"
    }
  ],
  "tabAutocompleteModel": {
    "title": "Ollama Autocomplete",
    "provider": "ollama",
    "model": "deepseek-coder:1.3b"
  }
}

```


5. Save the file. Continue will automatically route your completions and chat requests through your local Docker container.

---

## 3. Adding New Models

To add or change the models that are automatically pulled during bootstrap:

1. Open `Dockerfile.d/ollama/models.txt`.
2. Add the desired model names (one per line, matching official [Ollama Library tags](https://ollama.com/library)).
3. Re-run the installer:
   `just ollama-models-install`