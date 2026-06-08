import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

try:
    from PIL import Image
except ImportError:  # pragma: no cover - optional local dependency guard
    Image = None


ROOT = Path(__file__).resolve().parents[3]
TOOL_PATH = ROOT / "harness" / "tools" / "design_visual_compare.py"


@unittest.skipIf(Image is None, "Pillow is required for visual compare tests")
class DesignVisualCompareTests(unittest.TestCase):
    def test_stack_compare_scales_and_crops_to_normalized_board(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            tmp = Path(tmpdir)
            concept = tmp / "concept.png"
            candidate = tmp / "candidate.png"
            out = tmp / "compare.png"
            Image.new("RGB", (200, 80), (200, 20, 20)).save(concept)
            Image.new("RGB", (300, 120), (20, 120, 40)).save(candidate)

            result = subprocess.run(
                [
                    sys.executable,
                    str(TOOL_PATH),
                    "--concept",
                    str(concept),
                    "--candidate",
                    str(candidate),
                    "--candidate-crop",
                    "50,10,100,40",
                    "--out",
                    str(out),
                    "--width",
                    "100",
                    "--label-height",
                    "10",
                    "--gap",
                    "3",
                ],
                check=True,
                capture_output=True,
                text=True,
            )

            self.assertIn(str(out), result.stdout)
            self.assertTrue(out.exists())
            with Image.open(out) as image:
                self.assertEqual((100, 103), image.size)

    def test_side_by_side_compare_uses_panel_width_for_each_image(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            tmp = Path(tmpdir)
            concept = tmp / "concept.png"
            candidate = tmp / "candidate.png"
            out = tmp / "compare-side.png"
            Image.new("RGB", (160, 80), (200, 20, 20)).save(concept)
            Image.new("RGB", (120, 60), (20, 120, 40)).save(candidate)

            subprocess.run(
                [
                    sys.executable,
                    str(TOOL_PATH),
                    "--concept",
                    str(concept),
                    "--candidate",
                    str(candidate),
                    "--out",
                    str(out),
                    "--mode",
                    "side-by-side",
                    "--width",
                    "80",
                    "--label-height",
                    "12",
                    "--gap",
                    "4",
                ],
                check=True,
                capture_output=True,
                text=True,
            )

            with Image.open(out) as image:
                self.assertEqual((164, 52), image.size)


if __name__ == "__main__":
    unittest.main()
