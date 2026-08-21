# Symbiosis

> A human-first framework of guardrails designed to keep developers in total cognitive control of their codebase while leveraging AI.

---

## Manifesto & Vision

Artificial Intelligence in software engineering must act as a cognitive amplifier, not a replacement for human thought. **Symbiosis** was created to prevent "blind coding" and stop developers from becoming alienated from their own codebases.

Through explicit guardrails and operational empathy, Symbiosis transforms AI from an autonomous code generator into a **transparent co-pilot**, ensuring the model continuously engages with and defers to the human driving it.

---

## 1. Core Principles

* **Primary Cognitive Control:** The human is the *Navigator*; the AI is the *Driver*. No substantial change occurs without human understanding and approval.
* **Operational Empathy:** The AI respects human cognitive load by delivering small, readable iterations and avoiding monolithic overhauls.
* **Continuous Alignment:** Every development step relies on an active feedback loop to ensure a shared mental model of the codebase.
* **Single-Task Local Execution:** No software or architecture may be introduced if it cannot be run, tested, and built locally using a single entrypoint task defined in the project runner (`Justfile`).
* **Traceable Evolution:** All changes are systematically tracked in `CHANGELOG.md` following strict, human-readable standards to maintain full auditability across human and AI contributions.

---

## 2. AI Directives & Guardrails

To ensure that AI assistants adhere to human-first collaboration, this repository enforces a deterministic execution algorithm.

* **Core Execution Rules:** All AI agents operating on this repository MUST follow the algorithm defined in [`GUARDRAILS.md`](./GUARDRAILS.md).
* **Entrypoint Directive:** Agents searching for `AGENTS.md` are automatically routed to [`GUARDRAILS.md`](./GUARDRAILS.md).
* **Chronological Specifications:** Every task must originate from an immutable Markdown spec file stored under `specs/` (e.g., `specs/2026/08/2026-08-05-task.md`).
* **Changelog Compliance:** Agents MUST maintain `CHANGELOG.md` adhering strictly to [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/) before concluding any implementation task.

For full details on mode switching (`[REFINE]`, `[ASK]`, `[EXECUTE]`), input constraints, skill discovery, and human checkpoint protocols, see [`GUARDRAILS.md`](./GUARDRAILS.md).

---

## 3. Versioning & Changelog

This project strictly adheres to [Semantic Versioning (SemVer 2.0.0)](https://semver.org/) and tracks all notable changes in `CHANGELOG.md` using the [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/) format.

Every modification—whether initiated by a human developer or an AI agent—is logged under `## [Unreleased]` using standardized subheadings (`Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`) and MUST link directly back to its originating specification file in `specs/`.

---

## 4. Local AI Facility (Ollama Integration)
To uphold the principle of local execution and privacy, Symbiosis includes a fully self-contained, offline AI facility powered by Ollama.
* **Containerized & Hardware-Agnostic:** The AI engine runs locally via Docker Compose, supporting both CPU-only execution and hardware acceleration (such as AMD Vulkan GPU mode) out-of-the-box.
* **Automated Model Bootstrap:** The environment features an on-demand initialization workflow (ollama-models-install) driven by a declarative models.txt file, ensuring that required models are automatically verified and pulled into local volumes.
* **Frictionless Orchestration:** Every operation—from starting the engine to bootstrapping models, listing installed versions, or querying a model—is exposed locally through standardized tasks in the Justfile.

[`More information here`](./LOCAL-AI.md).

## 5. Repository Structure

```text
/symbiosis/
├── GOVERNANCE.md        # Vision, manifesto, core principles, and repository layout
├── GUARDRAILS.md        # Deterministic algorithm, execution workflow, and system directives
├── AGENTS.md            # Universal entrypoint redirecting agents to GUARDRAILS.md
├── CONTRIBUTING.md      # Git hygiene, Justfile skill contract, and PR protocols
├── CHANGELOG.md         # Immutable version history following Keep a Changelog 1.1.0
├── Justfile             # Executable contract of project skills and local commands
├── LICENSE              # GNU General Public License v3.0 (GPLv3)
├── Dockerfile.d/        # Local infrastructure configurations (Ollama engine & bootstrap init)
└── specs/               # Chronological history of human specifications
    ├── _template.md     # Base specification template
    └── YYYY/MM/         # Chronologically ordered spec files (e.g., YYYY-MM-DD-task.md)
