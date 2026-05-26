#!/usr/bin/env python3
"""
build_sfx_gallery.py — create a local HTML audition page for rendered SFX WAVs.

Usage:
  python3 harness/tools/build_sfx_gallery.py \
    harness/content/idlez/audios/recipes/sfx_pack_30.manifest.yaml \
    --audio-dir harness/build/sfx \
    --out harness/build/sfx/sfx_pack_30_gallery.html
"""

from __future__ import annotations

import argparse
import html
from pathlib import Path
import sys
import wave

try:
    import yaml
except ModuleNotFoundError:
    print("Missing dependency: PyYAML", file=sys.stderr)
    print("Install it with: python3 -m pip install -r harness/tools/requirements.txt", file=sys.stderr)
    sys.exit(2)


def wav_info(path: Path) -> str:
    if not path.exists():
        return "missing"
    with wave.open(str(path), "rb") as reader:
        duration = reader.getnframes() / reader.getframerate()
        channels = "mono" if reader.getnchannels() == 1 else f"{reader.getnchannels()} ch"
        size_kb = path.stat().st_size / 1024
        return f"{duration:.2f}s / {channels} / {size_kb:.0f} KB"


def main() -> int:
    parser = argparse.ArgumentParser(description="Build an HTML SFX audition gallery.")
    parser.add_argument("manifest", type=Path)
    parser.add_argument("--audio-dir", type=Path, required=True)
    parser.add_argument("--out", type=Path, required=True)
    args = parser.parse_args()

    manifest = yaml.safe_load(args.manifest.read_text(encoding="utf-8")) or {}
    sounds = manifest.get("sounds") or []
    rows = []
    for index, sound in enumerate(sounds):
        sound_id = sound["id"]
        wav_path = args.audio_dir / f"{sound_id}.wav"
        rel = wav_path.name
        disabled = "" if wav_path.exists() else " disabled"
        audio = (
            f'<audio preload="none" src="{html.escape(rel)}"></audio>'
            if wav_path.exists()
            else '<audio preload="none"></audio>'
        )
        rows.append(
            f"""
            <article data-index="{index}">
              <div>
                <h2>{html.escape(sound_id)}</h2>
                <p>{html.escape(sound.get("role", ""))} · {html.escape(sound.get("note", ""))}</p>
                <span>{html.escape(wav_info(wav_path))}</span>
              </div>
              <div class="row-actions">
                <button class="play-button" type="button" data-index="{index}"{disabled}>Play</button>
                {audio}
              </div>
            </article>
            """
        )

    page = f"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>SFX Pack 30 Gallery</title>
  <style>
    :root {{
      color-scheme: dark;
      --bg: #101316;
      --panel: #181e24;
      --line: #2a333d;
      --text: #f3f6f8;
      --muted: #9facbb;
      --accent: #67d8a4;
      --accent-soft: rgba(103, 216, 164, 0.16);
    }}
    * {{ box-sizing: border-box; }}
    body {{
      margin: 0;
      background: var(--bg);
      color: var(--text);
      font: 14px/1.45 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    }}
    main {{
      width: min(1080px, calc(100vw - 32px));
      margin: 0 auto;
      padding: 28px 0 40px;
    }}
    header {{
      display: grid;
      grid-template-columns: minmax(0, 1fr) auto;
      gap: 16px;
      align-items: end;
      border-bottom: 1px solid var(--line);
      padding-bottom: 16px;
      margin-bottom: 16px;
    }}
    h1 {{
      margin: 0 0 6px;
      font-size: 24px;
      letter-spacing: 0;
    }}
    header p, article p, span {{
      margin: 0;
      color: var(--muted);
    }}
    .grid {{
      display: grid;
      gap: 10px;
    }}
    .toolbar {{
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      justify-content: flex-end;
    }}
    article {{
      display: grid;
      grid-template-columns: minmax(0, 1fr) minmax(300px, 380px);
      align-items: center;
      gap: 14px;
      background: var(--panel);
      border: 1px solid var(--line);
      border-radius: 8px;
      padding: 12px;
    }}
    article.active {{
      border-color: var(--accent);
      background: var(--accent-soft);
    }}
    h2 {{
      margin: 0 0 4px;
      font-size: 15px;
      letter-spacing: 0;
    }}
    span {{
      display: inline-block;
      margin-top: 5px;
      font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
      font-size: 12px;
    }}
    .row-actions {{
      display: grid;
      grid-template-columns: 76px minmax(0, 1fr);
      align-items: center;
      gap: 10px;
    }}
    button {{
      appearance: none;
      border: 1px solid var(--line);
      background: #202832;
      color: var(--text);
      border-radius: 6px;
      min-height: 38px;
      padding: 0 12px;
      font: inherit;
      font-weight: 720;
      cursor: pointer;
    }}
    button:hover:not(:disabled) {{
      border-color: var(--accent);
    }}
    button.active {{
      background: var(--accent);
      border-color: var(--accent);
      color: #07110d;
    }}
    button:disabled {{
      opacity: 0.45;
      cursor: not-allowed;
    }}
    audio {{
      width: 100%;
    }}
    @media (max-width: 720px) {{
      header {{
        grid-template-columns: 1fr;
      }}
      .toolbar {{
        justify-content: flex-start;
      }}
      article {{
        grid-template-columns: 1fr;
      }}
      .row-actions {{
        grid-template-columns: 1fr;
      }}
    }}
  </style>
</head>
<body>
  <main>
    <header>
      <div>
        <h1>SFX Pack 30 Gallery</h1>
        <p>30 rendered WAVs</p>
      </div>
      <div class="toolbar">
        <button id="prevBtn" type="button">Prev</button>
        <button id="nextBtn" type="button">Next</button>
        <button id="stopBtn" type="button">Stop</button>
      </div>
    </header>
    <div class="grid">
      {"".join(rows)}
    </div>
  </main>
  <script>
    const rows = Array.from(document.querySelectorAll("article[data-index]"));
    const buttons = Array.from(document.querySelectorAll(".play-button"));
    let currentIndex = -1;

    function updateActive(index) {{
      rows.forEach((row, i) => row.classList.toggle("active", i === index));
      buttons.forEach((button, i) => {{
        const audio = rows[i].querySelector("audio");
        const isPlaying = i === index && audio && !audio.paused;
        button.textContent = isPlaying ? "Pause" : "Play";
        button.classList.toggle("active", isPlaying);
      }});
    }}

    function stopAll(reset) {{
      rows.forEach((row) => {{
        const audio = row.querySelector("audio");
        if (!audio) return;
        audio.pause();
        if (reset) audio.currentTime = 0;
      }});
      if (reset) currentIndex = -1;
      updateActive(currentIndex);
    }}

    async function playIndex(index) {{
      const row = rows[index];
      if (!row) return;
      const audio = row.querySelector("audio");
      if (!audio || !audio.getAttribute("src")) return;

      if (currentIndex === index && !audio.paused) {{
        audio.pause();
        updateActive(index);
        return;
      }}

      stopAll(false);
      currentIndex = index;
      audio.currentTime = 0;
      updateActive(index);
      row.scrollIntoView({{ block: "nearest" }});
      try {{
        await audio.play();
      }} catch (error) {{
        console.warn(error);
      }}
      updateActive(index);
    }}

    function playableIndex(offset) {{
      if (!rows.length) return -1;
      const start = currentIndex < 0 ? 0 : currentIndex;
      for (let step = 1; step <= rows.length; step += 1) {{
        const next = (start + offset * step + rows.length) % rows.length;
        const audio = rows[next].querySelector("audio");
        if (audio && audio.getAttribute("src")) return next;
      }}
      return -1;
    }}

    buttons.forEach((button) => {{
      button.addEventListener("click", () => playIndex(Number(button.dataset.index)));
    }});
    rows.forEach((row, index) => {{
      const audio = row.querySelector("audio");
      if (!audio) return;
      audio.addEventListener("play", () => {{
        rows.forEach((otherRow, otherIndex) => {{
          if (otherIndex !== index) otherRow.querySelector("audio")?.pause();
        }});
        currentIndex = index;
        updateActive(index);
      }});
      audio.addEventListener("ended", () => updateActive(index));
      audio.addEventListener("pause", () => updateActive(currentIndex));
    }});
    document.getElementById("prevBtn").addEventListener("click", () => {{
      const index = playableIndex(-1);
      if (index >= 0) playIndex(index);
    }});
    document.getElementById("nextBtn").addEventListener("click", () => {{
      const index = playableIndex(1);
      if (index >= 0) playIndex(index);
    }});
    document.getElementById("stopBtn").addEventListener("click", () => stopAll(true));
  </script>
</body>
</html>
"""
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(page, encoding="utf-8")
    print(args.out)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
