# Taskstonebar Runtime MVP

Static HTML/CSS/JS runtime preview for the `taskstonebar` content slice.

Run from the repository root:

```bash
python3 -m http.server 8765
```

Open:

```text
http://127.0.0.1:8765/harness/runtime/taskstonebar/
```

This is a visual and interaction MVP, not the final Phaser/content-loader integration. It uses the imported Task Stone image assets under `harness/assets/taskstonebar/source/taskstone/` and mirrors the first content slice in `harness/content/taskstonebar/`.
