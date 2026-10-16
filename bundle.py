# bundle.py — run from your project root: python bundle.py
from pathlib import Path

root = Path(".")
out = ["# Word Roguelike — code bundle\n"]
for f in sorted(root.rglob("*.gd")):
    if ".godot" in f.parts:
        continue
    out.append(f"\n\n===== {f.as_posix()} =====\n")
    out.append(f.read_text(encoding="utf-8"))
Path("project_bundle.md").write_text("".join(out), encoding="utf-8")