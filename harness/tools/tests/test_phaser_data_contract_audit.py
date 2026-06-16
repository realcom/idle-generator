import importlib.util
import sys
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
MODULE_PATH = ROOT / "harness" / "tools" / "phaser_data_contract_audit.py"

spec = importlib.util.spec_from_file_location("phaser_data_contract_audit", MODULE_PATH)
phaser_data_contract_audit = importlib.util.module_from_spec(spec)
assert spec.loader is not None
sys.modules[spec.name] = phaser_data_contract_audit
spec.loader.exec_module(phaser_data_contract_audit)


class PhaserDataContractAuditTests(unittest.TestCase):
    def test_requires_spec_data_contract(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            root = Path(tmpdir)
            runtime = root / "harness" / "runtime" / "demo.html"
            spec_path = root / "harness" / "runtime" / "specs" / "ui" / "demo.yaml"
            runtime.parent.mkdir(parents=True)
            spec_path.parent.mkdir(parents=True)
            runtime.write_text("<html></html>", encoding="utf-8")
            spec_path.write_text(
                "\n".join([
                    'game: demo',
                    'target_runtime:',
                    '  page: harness/runtime/demo.html',
                ]),
                encoding="utf-8",
            )

            result = phaser_data_contract_audit.audit_spec(spec_path, root=root)

            self.assertFalse(result.ok)
            self.assertIn("missing_data_contract", {issue.code for issue in result.issues})

    def test_flags_content_tables_data_ids_and_runtime_text(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            root = Path(tmpdir)
            runtime = root / "harness" / "runtime" / "src" / "demo.js"
            spec_path = root / "harness" / "runtime" / "specs" / "ui" / "demo.yaml"
            runtime.parent.mkdir(parents=True)
            spec_path.parent.mkdir(parents=True)
            runtime.write_text(
                "\n".join([
                    "const SKILL_CHOICES = Object.freeze([300101, 300102]);",
                    "const TITLE = '성장 선택';",
                ]),
                encoding="utf-8",
            )
            spec_path.write_text(
                "\n".join([
                    'game: demo',
                    'target_runtime:',
                    '  entrypoint: harness/runtime/src/demo.js',
                    'data_contract:',
                    '  sources:',
                    '    skills: harness/build/demo/Skills.json',
                    '  bindings:',
                    '    choice.title: skills[].name',
                ]),
                encoding="utf-8",
            )

            result = phaser_data_contract_audit.audit_spec(spec_path, root=root)
            codes = {issue.code for issue in result.issues}

            self.assertTrue(result.ok)
            self.assertIn("runtime_content_table", codes)
            self.assertIn("runtime_data_id_literal", codes)
            self.assertIn("runtime_text_literal", codes)

    def test_asset_plan_allows_declared_runtime_asset_paths(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            root = Path(tmpdir)
            runtime = root / "harness" / "runtime" / "src" / "demo.js"
            spec_path = root / "harness" / "runtime" / "specs" / "ui" / "demo.yaml"
            asset_plan = root / "harness" / "design" / "demo" / "asset-plan.yaml"
            runtime.parent.mkdir(parents=True)
            spec_path.parent.mkdir(parents=True)
            asset_plan.parent.mkdir(parents=True)
            runtime.write_text(
                "\n".join([
                    "const ok = 'assets/demo/ui/known.png';",
                    "const bad = 'assets/demo/ui/missing.png';",
                ]),
                encoding="utf-8",
            )
            spec_path.write_text(
                "\n".join([
                    'game: demo',
                    'target_runtime:',
                    '  entrypoint: harness/runtime/src/demo.js',
                    'data_contract:',
                    '  sources:',
                    '    fixture: harness/runtime/scenarios/demo/ui.json',
                ]),
                encoding="utf-8",
            )
            asset_plan.write_text(
                "\n".join([
                    'version: "1.0"',
                    'game: demo',
                    'assets:',
                    '  - key: demo.ui.known',
                    '    runtime_path: harness/runtime/assets/demo/ui/known.png',
                ]),
                encoding="utf-8",
            )

            result = phaser_data_contract_audit.audit_spec(spec_path, root=root)

            unplanned = [issue.symbol for issue in result.issues if issue.code == "runtime_asset_unplanned"]
            self.assertEqual(["assets/demo/ui/missing.png"], unplanned)

    def test_allowlist_suppresses_known_legacy_line(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            root = Path(tmpdir)
            runtime = root / "harness" / "runtime" / "src" / "demo.js"
            spec_path = root / "harness" / "runtime" / "specs" / "ui" / "demo.yaml"
            runtime.parent.mkdir(parents=True)
            spec_path.parent.mkdir(parents=True)
            runtime.write_text("const MAP_IDS = [500101];\n", encoding="utf-8")
            spec_path.write_text(
                "\n".join([
                    'game: demo',
                    'target_runtime:',
                    '  entrypoint: harness/runtime/src/demo.js',
                    'data_contract:',
                    '  sources:',
                    '    maps: harness/build/demo/Maps.json',
                    '  hardcoding_allowlist:',
                    '    - harness/runtime/src/demo.js:1:runtime_content_table:MAP_IDS',
                    '    - harness/runtime/src/demo.js:1:runtime_data_id_literal:500101',
                ]),
                encoding="utf-8",
            )

            result = phaser_data_contract_audit.audit_spec(spec_path, root=root)

            self.assertEqual([], result.issues)


if __name__ == "__main__":
    unittest.main()
