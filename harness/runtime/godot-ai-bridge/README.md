# Godot AI Bridge

Small Godot 4 probe for testing how cleanly the harness JSON can feed an AI-assisted runtime.

It does two things:

- Loads `harness/build/idlez/*.json` directly from the monorepo.
- Sends a compact content summary to an OpenAI-compatible chat endpoint.

The default endpoint targets local Ollama:

```text
http://127.0.0.1:11434/v1/chat/completions
```

## Run

From the repository root:

```bash
godot4 --path harness/runtime/godot-ai-bridge
```

or:

```bash
godot --path harness/runtime/godot-ai-bridge
```

If you use Ollama:

```bash
ollama pull llama3.2
ollama serve
```

Then keep the default endpoint/model in the Godot UI and press `Ask AI`.

For LM Studio or another local OpenAI-compatible server, update the endpoint and model in the UI. For a hosted API, paste the API key into the optional key field.

## Data Path

The loader reads from:

```text
res://../../build/idlez
```

Because the Godot project lives in `harness/runtime/godot-ai-bridge`, this resolves to:

```text
harness/build/idlez
```

This is intentionally development-only. An exported Godot client should copy or package the compiled JSON into the project, or fetch it from a patch/resource server.

## Current Scope

This is not a game client yet. It is the first bridge:

1. Load content bundles.
2. Summarize units/items/maps/skills/achievements.
3. Ask an AI for recommendations grounded in existing IDs.
4. Keep combat, growth, drops, and economy deterministic outside the LLM.
