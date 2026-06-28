import importlib.util
import sys
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
MODULE_PATH = ROOT / "harness" / "tools" / "growstone2_harness.py"

spec = importlib.util.spec_from_file_location("growstone2_harness", MODULE_PATH)
growstone2_harness = importlib.util.module_from_spec(spec)
assert spec.loader is not None
sys.modules[spec.name] = growstone2_harness
spec.loader.exec_module(growstone2_harness)


class Growstone2HarnessTests(unittest.TestCase):
    def test_content_indexes_have_review_or_bootstrap_statuses(self):
        for category in growstone2_harness.INDEX_CATEGORIES:
            with self.subTest(category=category):
                counts = growstone2_harness.status_counts(
                    growstone2_harness.CONTENT_DIR / category / "_index.yaml",
                    category,
                )
                self.assertNotIn("draft", counts)
                self.assertGreater(sum(counts.values()), 0)
                self.assertTrue(set(counts).issubset({"review", "bootstrap"}), counts)

    def test_canonical_paths_exist(self):
        self.assertTrue((growstone2_harness.ROOT / "assets" / "growstone2" / "asset-registry.yaml").exists())
        self.assertTrue(growstone2_harness.GODOT_PROJECT.exists())
        self.assertTrue(growstone2_harness.CONTENT_DIR.exists())


if __name__ == "__main__":
    unittest.main()
