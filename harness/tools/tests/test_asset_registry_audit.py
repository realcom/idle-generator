import importlib.util
import sys
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
MODULE_PATH = ROOT / "harness" / "tools" / "asset_registry_audit.py"

spec = importlib.util.spec_from_file_location("asset_registry_audit", MODULE_PATH)
asset_registry_audit = importlib.util.module_from_spec(spec)
assert spec.loader is not None
sys.modules[spec.name] = asset_registry_audit
spec.loader.exec_module(asset_registry_audit)


class AssetRegistryAuditTests(unittest.TestCase):
    def test_collection_covers_runtime_reference(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            runtime = root / "runtime"
            registry = root / "assets" / "game" / "asset-registry.yaml"
            (runtime / "assets" / "ui").mkdir(parents=True)
            (runtime / "assets" / "ui" / "icon.png").write_bytes(b"png")
            (runtime / "index.html").write_text("'assets/ui/icon.png'", encoding="utf-8")
            registry.parent.mkdir(parents=True)
            registry.write_text(
                "\n".join([
                    "version: 1",
                    "game: game",
                    "collections:",
                    "  - name: ui",
                    "    prefix: assets/ui/",
                    "    type: ui",
                    "    status: approved",
                    "assets: {}",
                ]),
                encoding="utf-8",
            )

            result = asset_registry_audit.audit("game", registry, runtime, root / "build", release=True)

            self.assertTrue(result.ok, result)
            self.assertEqual([], result.missing_registry)

    def test_release_blocks_ai_draft_reference(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            runtime = root / "runtime"
            registry = root / "assets" / "game" / "asset-registry.yaml"
            (runtime / "assets" / "ui").mkdir(parents=True)
            (runtime / "assets" / "ui" / "icon.png").write_bytes(b"png")
            (runtime / "index.html").write_text("'assets/ui/icon.png'", encoding="utf-8")
            registry.parent.mkdir(parents=True)
            registry.write_text(
                "\n".join([
                    "version: 1",
                    "game: game",
                    "assets:",
                    "  assets/ui/icon.png:",
                    "    type: ui",
                    "    status: ai-draft",
                    "    used_by: [item:1]",
                ]),
                encoding="utf-8",
            )

            result = asset_registry_audit.audit("game", registry, runtime, root / "build", release=True)

            self.assertFalse(result.ok)
            self.assertEqual(["assets/ui/icon.png"], [ref.path for ref in result.release_blocked])


if __name__ == "__main__":
    unittest.main()
