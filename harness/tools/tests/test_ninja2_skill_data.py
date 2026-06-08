import importlib.util
import math
import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
MODULE_PATH = ROOT / "harness" / "tools" / "idlez_compile.py"
SURVIVOR_APP_PATH = ROOT / "harness" / "runtime" / "src" / "survivor" / "survivor-app.js"
BOARD_KERNEL_PATH = ROOT / "harness" / "runtime" / "src" / "idlez-phaser" / "board-kernel.js"
SKILL_VFX_PATH = ROOT / "harness" / "runtime" / "src" / "survivor" / "skill-vfx.js"

spec = importlib.util.spec_from_file_location("idlez_compile", MODULE_PATH)
idlez_compile = importlib.util.module_from_spec(spec)
assert spec.loader is not None
spec.loader.exec_module(idlez_compile)


MAX_RUN_SKILL_LEVEL = 5
EXPECTED_SKILL_IDS = set(range(300101, 300117))
EXPECTED_BUFF_IDS = set(range(400101, 400107))
ALLOWED_TARGET_REFRESH_TYPES = {
    "Nearest",
    "Random",
    "HighestHp",
    "LowestHp",
    "Furthest",
    "NoRefresh",
}
ALLOWED_BUFF_STATS = {
    "AttackPercent",
    "AttackSpeedPercent",
    "BuffDurationEfficiencyPercent",
    "CooldownPercent",
    "CriticalDamagePercent",
    "CriticalPercent",
    "DamageTakenEfficiencyPercent",
    "DefensePercent",
    "Hp",
    "MoveSpeed",
}


class Ninja2SkillDataTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        bundles, _, _, warns, errors = idlez_compile.compile_game("ninja2")
        if errors:
            raise AssertionError(f"ninja2 compile errors: {errors}")
        cls.warns = warns
        cls.skills = {entry["id"]: entry for entry in bundles["skill"]}
        cls.buffs = {entry["id"]: entry for entry in bundles["buff"]}

    def test_survivor_skill_pool_has_expected_ids_and_basic_runtime_fields(self):
        self.assertEqual(EXPECTED_SKILL_IDS, set(self.skills))
        self.assertEqual(EXPECTED_BUFF_IDS, set(self.buffs))
        self.assertEqual(
            list(range(1, len(EXPECTED_SKILL_IDS) + 1)),
            sorted(skill["priority"] for skill in self.skills.values()),
        )

        for skill_id, skill in sorted(self.skills.items()):
            with self.subTest(skill_id=skill_id):
                self.assertGreater(skill.get("cooldown", 0), 0)
                self.assertLessEqual(skill["cooldown"], 9.0)
                if skill.get("targetRefreshType") is not None:
                    self.assertIn(skill.get("targetRefreshType"), ALLOWED_TARGET_REFRESH_TYPES)
                self.assertTrue(skill.get("prefab", "").startswith("FXPrefabs/"))
                self.assertRegex(skill.get("sprite", ""), r"^Skills/Ninja2/.+\.png$")

                timelines = skill.get("timelines") or []
                self.assertGreaterEqual(len(timelines), 2)
                times = [timeline.get("time", 0) for timeline in timelines]
                self.assertEqual(times, sorted(times))
                self.assertTrue(any("destroy" in timeline for timeline in timelines))

                has_hit = any("hit" in timeline for timeline in timelines)
                has_self_buff = bool(skill.get("selfAddBuffs"))
                self.assertTrue(has_hit or has_self_buff)

    def test_skill_damage_curves_and_buff_refs_are_level_five_ready(self):
        for skill_id, skill in sorted(self.skills.items()):
            with self.subTest(skill_id=skill_id):
                hit_count = 0
                for timeline in skill.get("timelines") or []:
                    hit = timeline.get("hit")
                    if not hit:
                        continue
                    hit_count += 1
                    self.assertGreaterEqual(hit.get("maxHit", 0), 1)
                    self.assertLessEqual(hit.get("maxHit", 0), 20)
                    self.assertTrue(hit.get("geometries"), "hit needs at least one geometry")

                    values = (hit.get("addDamage") or {}).get("attackPercentDamages")
                    self.assertIsNotNone(values, "hit needs attackPercentDamages")
                    self.assert_level_curve(values, f"skill {skill_id} damage")

                    for buff_ref in hit.get("addBuffs") or []:
                        self.assert_valid_buff_ref(buff_ref, f"skill {skill_id} hit buff")

                for buff_ref in skill.get("selfAddBuffs") or []:
                    self.assert_valid_buff_ref(buff_ref, f"skill {skill_id} self buff")

                if not skill.get("selfAddBuffs"):
                    self.assertGreater(hit_count, 0, "non-buff skills must hit something")

    def test_buff_curves_are_level_five_ready_and_use_supported_stats(self):
        for buff_id, buff in sorted(self.buffs.items()):
            with self.subTest(buff_id=buff_id):
                self.assertIn(buff.get("type"), {"UnitBuff", "UnitDebuff"})
                self.assertGreater(buff.get("duration", 0), 0)
                self.assertTrue(buff.get("addStats"))
                self.assertTrue(buff.get("prefab", "").startswith("FXPrefabs/"))

                for stat in buff.get("addStats") or []:
                    stat_type = stat.get("type")
                    self.assertIn(stat_type, ALLOWED_BUFF_STATS)
                    values = stat.get("value")
                    self.assert_level_curve(
                        values,
                        f"buff {buff_id} {stat_type}",
                        allow_negative=True,
                    )
                    self.assertTrue(any(abs(float(value)) > 0 for value in values))

    def test_phaser_skill_vfx_and_icon_contract_covers_entire_pool(self):
        source = SKILL_VFX_PATH.read_text(encoding="utf-8")

        self.assertEqual(EXPECTED_SKILL_IDS, extract_js_array_ids(source, "SKILL_VFX_DEMO_IDS"))
        self.assertEqual(EXPECTED_SKILL_IDS, extract_js_object_ids(source, "SKILL_ICON_PATHS"))
        self.assertEqual(EXPECTED_SKILL_IDS, extract_js_object_ids(source, "SKILL_VFX_PROFILES"))

        icon_body = extract_js_object_body(source, "SKILL_ICON_PATHS")
        for skill_id in EXPECTED_SKILL_IDS:
            with self.subTest(skill_id=skill_id):
                pattern = rf"{skill_id}\s*:\s*['\"]Skills/Ninja2/.+\.png['\"]"
                self.assertRegex(icon_body, pattern)

    def test_runtime_contract_uses_run_skill_levels_for_auto_casts_and_buffs(self):
        survivor_app = SURVIVOR_APP_PATH.read_text(encoding="utf-8")
        board_kernel = BOARD_KERNEL_PATH.read_text(encoding="utf-8")

        self.assertIn("this.runSkillLevels = new Map()", survivor_app)
        self.assertIn("this.runSkillReadyTicks = new Map()", survivor_app)
        self.assertIn("updateRunSkillAutos()", survivor_app)
        self.assertIn("skillLevel: this.runSkillLevels.get(Number(skillDataId)) || 1", survivor_app)

        self.assertIn("levelValue(ratios, skill.skillLevel", board_kernel)
        self.assertNotIn("ratios.reduce", board_kernel)
        self.assertIn("#applyBuffRefs", board_kernel)
        self.assertIn("getBuffStat(statType)", board_kernel)
        self.assertIn("skillHasSelfBuff", board_kernel)

    def assert_valid_buff_ref(self, buff_ref, label):
        buff_id = buff_ref.get("buffDataId")
        self.assertIn(buff_id, self.buffs, label)
        self.assertGreater(buff_ref.get("duration", 0), 0, label)
        self.assertGreaterEqual(buff_ref.get("level", 1), 1, label)
        self.assertLessEqual(buff_ref.get("level", 1), MAX_RUN_SKILL_LEVEL, label)

    def assert_level_curve(self, values, label, allow_negative=False):
        self.assertIsInstance(values, list, label)
        self.assertEqual(MAX_RUN_SKILL_LEVEL, len(values), label)
        previous = None
        for value in values:
            self.assertTrue(isinstance(value, (int, float)), label)
            self.assertTrue(math.isfinite(value), label)
            if not allow_negative:
                self.assertGreater(value, 0, label)
            if previous is not None:
                if previous >= 0 and value >= 0:
                    self.assertGreaterEqual(value, previous, label)
                if previous <= 0 and value <= 0:
                    self.assertLessEqual(value, previous, label)
            previous = value


def extract_js_array_ids(source, name):
    pattern = rf"export const {name} = Object\.freeze\(\[(.*?)\]\);"
    match = re.search(pattern, source, re.S)
    if not match:
        raise AssertionError(f"missing JS array: {name}")
    return {int(value) for value in re.findall(r"\b(\d{6})\b", match.group(1))}


def extract_js_object_ids(source, name):
    return {int(value) for value in re.findall(r"^\s*(\d{6})\s*:", extract_js_object_body(source, name), re.M)}


def extract_js_object_body(source, name):
    pattern = rf"export const {name} = Object\.freeze\(\{{(.*?)\n\}}\);"
    match = re.search(pattern, source, re.S)
    if not match:
        raise AssertionError(f"missing JS object: {name}")
    return match.group(1)


if __name__ == "__main__":
    unittest.main()
