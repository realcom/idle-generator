#!/usr/bin/env python3
"""Generate Taskstonebar's closed 100-map combat set.

The output is intentionally source YAML, not build artifacts. Re-run this when
the stage curve, wave shape, or monster family table changes.
"""

from __future__ import annotations

from dataclasses import dataclass
from math import pow
from pathlib import Path
import re


ROOT = Path(__file__).resolve().parents[2]
GAME_DIR = ROOT / "harness" / "content" / "taskstonebar"
MAP_DIR = GAME_DIR / "maps"
UNIT_DIR = GAME_DIR / "units"
MAP_DRAFTS = MAP_DIR / "_drafts"
UNIT_DRAFTS = UNIT_DIR / "_drafts"
GROWTH_DIR = GAME_DIR / "growth"

CREATED_AT = "2026-06-24T00:00:00+09:00"
SERIES = "taskstonebar-main-100"
MAX_LEVEL = 360
DIFFICULTY_GROWTH = 1.05

SPRITES = {
    "imp": "unit/02_몬스터/Monster_0034.png",
    "imp_elite": "unit/02_몬스터/Monster_0035.png",
    "imp_boss": "unit/02_몬스터/Monster_0036.png",
    "slime": "unit/02_몬스터/Monster_b10000.png",
    "spider": "unit/02_몬스터/08 잊힌 경계지 (2.5.0)/Monster_독거미_Pivot.png",
    "zombie": "unit/02_몬스터/08 잊힌 경계지 (2.5.0)/Monster_되살아난 시체.png",
    "ghost": "unit/02_몬스터/08 잊힌 경계지 (2.5.0)/Monster_망령.png",
    "skeleton": "unit/02_몬스터/08 잊힌 경계지 (2.5.0)/Monster_해골궁수.png",
}


@dataclass(frozen=True)
class Theme:
    no: int
    prefix: str
    map_root: str
    sprites: tuple[str, str, str, str, str, str]


THEMES = [
    Theme(1, "작업굴", "작업굴", ("imp", "imp_elite", "imp", "imp_elite", "imp_boss", "imp_boss")),
    Theme(2, "이끼굴", "이끼굴", ("slime", "imp", "slime", "imp_elite", "imp_boss", "imp_boss")),
    Theme(3, "수정로", "수정로", ("imp_elite", "slime", "skeleton", "spider", "imp_boss", "spider")),
    Theme(4, "녹슨굴", "녹슨굴", ("zombie", "imp", "skeleton", "zombie", "imp_boss", "zombie")),
    Theme(5, "망령길", "망령길", ("ghost", "slime", "ghost", "skeleton", "ghost", "ghost")),
    Theme(6, "용암고", "용암고", ("imp_boss", "imp", "skeleton", "spider", "imp_boss", "spider")),
    Theme(7, "빙결광", "빙결광", ("slime", "ghost", "skeleton", "zombie", "ghost", "zombie")),
    Theme(8, "경계지", "경계지", ("spider", "slime", "skeleton", "spider", "ghost", "spider")),
    Theme(9, "초석로", "초석로", ("zombie", "imp_elite", "skeleton", "zombie", "spider", "zombie")),
    Theme(10, "심연층", "심연층", ("ghost", "spider", "skeleton", "zombie", "ghost", "spider")),
]

MAP_LABELS = ["입구", "샛길", "작업구", "깊은길", "균열", "저장고", "협곡", "심층", "왕터", "심장"]

ROLE_TABLE = [
    {
        "key": "basic",
        "suffix": "일꾼",
        "type": "Normal",
        "tags": ["Monster", "Main", "Basic"],
        "trigger": "UNIT_ONUPDATE_TASKSTONEBARBASICSTRIKE",
        "hp": 100,
        "attack": 5,
        "defense": 1.5,
        "move": 2.8,
        "attack_speed": 1.0,
        "scale": -64,
        "ui": 0.92,
        "gold": (8, 14),
        "exp": 5,
    },
    {
        "key": "fast",
        "suffix": "질주꾼",
        "type": "Normal",
        "tags": ["Monster", "Main", "Fast"],
        "trigger": "UNIT_ONUPDATE_TASKSTONEBARFASTLUNGE",
        "hp": 85,
        "attack": 4.5,
        "defense": 1,
        "move": 4.15,
        "attack_speed": 1.22,
        "scale": -66,
        "ui": 0.86,
        "gold": (7, 12),
        "exp": 5,
    },
    {
        "key": "ranged",
        "suffix": "사수",
        "type": "Normal",
        "tags": ["Monster", "Main", "Ranged"],
        "trigger": "UNIT_ONUPDATE_TASKSTONEBARRANGEDSHOT",
        "hp": 110,
        "attack": 6,
        "defense": 1.5,
        "move": 2.25,
        "attack_speed": 0.82,
        "scale": -62,
        "ui": 0.95,
        "gold": (11, 18),
        "exp": 7,
    },
    {
        "key": "armored",
        "suffix": "방패병",
        "type": "Elite",
        "tags": ["Monster", "Main", "Armored"],
        "trigger": "UNIT_ONUPDATE_TASKSTONEBARSHIELDSLAM",
        "hp": 240,
        "attack": 7,
        "defense": 8,
        "move": 1.65,
        "attack_speed": 0.68,
        "scale": -56,
        "ui": 1.08,
        "gold": (22, 34),
        "exp": 13,
    },
    {
        "key": "miniboss",
        "suffix": "문지기",
        "type": "MidBoss",
        "tags": ["Monster", "Main", "MiniBoss"],
        "trigger": "UNIT_ONUPDATE_TASKSTONEBARKEEPERQUAKE",
        "hp": 900,
        "attack": 16,
        "defense": 14,
        "move": 1.45,
        "attack_speed": 0.62,
        "scale": -48,
        "ui": 1.28,
        "gold": (75, 115),
        "exp": 34,
    },
]

BOSS_ROLE = {
    "key": "giant_boss",
    "suffix": "군주",
    "type": "Boss",
    "tags": ["Monster", "Main", "GiantBoss"],
    "trigger": "UNIT_ONUPDATE_TASKSTONEBARGIANTCRUSH",
    "hp": 3400,
    "attack": 24,
    "defense": 24,
    "defense_growth": 1.034,
    "move": 1.15,
    "attack_speed": 0.55,
    "scale": -40,
    "ui": 1.85,
    "gold": (260, 420),
    "exp": 105,
}

EQUIPMENT_DROP_CHANCES = {
    "basic": 3.0,
    "fast": 3.0,
    "ranged": 3.0,
    "armored": 6.0,
    "miniboss": 35.0,
    "giant_boss": 100.0,
}

STONE_DROP_CHANCES = {
    "basic": 0.18,
    "fast": 0.18,
    "ranged": 0.18,
    "armored": 0.45,
    "miniboss": 3.5,
    "giant_boss": 12.0,
}
EARLY_STONE_DROP_CHANCE = 8.0
EARLY_STONE_DROP_SET_MAX = 1
EARLY_HP_MULTIPLIERS = {
    "basic": 4.4,
    "fast": 4.5,
    "ranged": 4.0,
    "armored": 2.0,
    "miniboss": 1.0,
    "giant_boss": 1.0,
}

EQUIPMENT_SLOT_BASE_IDS = {
    "Head": 200300,
    "Chest": 200310,
    "Gloves": 200320,
    "Boots": 200330,
    "Necklace": 200340,
    "Ring": 200350,
}


def slug(text: str) -> str:
    return re.sub(r"[^0-9A-Za-z가-힣_ᄀ-ᇿ]+", "", text)


def stat_curve(base: float, growth: float = DIFFICULTY_GROWTH) -> list[float]:
    return [round(base * pow(growth, level - 1), 4) for level in range(1, MAX_LEVEL + 1)]


def player_level_required_exps() -> list[int]:
    return [round(20 * pow(level, 1.28) + 8) for level in range(1, 100)]


def flow(items: list[float] | list[int]) -> str:
    return "[" + ", ".join(str(item) for item in items) + "]"


def unit_id(theme_no: int, role_index: int) -> int:
    return 111000 + theme_no * 10 + role_index


def boss_id(theme_no: int) -> int:
    return 111500 + theme_no


def map_id(stage_no: int) -> int:
    return 500100 + stage_no


def wave_count_for_stage(stage_no: int) -> int:
    return 6 if stage_no % 10 == 0 else 5


def difficulty_level_for_stage(stage_no: int) -> int:
    level = 1
    for previous_stage in range(1, stage_no):
        level += wave_count_for_stage(previous_stage) - 2
    return level


def representative_stage(theme_no: int) -> int:
    return 1 + (theme_no - 1) * 11


def direct_drop_cap(theme_no: int) -> int:
    return min(6, 1 + representative_stage(theme_no) // 20)


def direct_drop_weights(cap: int) -> list[tuple[int, float]]:
    lo = max(1, cap - 2)
    return [(grade, round(pow(0.45, cap - grade) * 100.0, 4)) for grade in range(lo, cap + 1)]


def direct_equipment_add_items(theme_no: int) -> str:
    rows = []
    for grade, weight in direct_drop_weights(direct_drop_cap(theme_no)):
        for slot_base in EQUIPMENT_SLOT_BASE_IDS.values():
            rows.append(f"      - {{ itemDataId: {slot_base + grade}, count: 1, weight: {weight}, group: {100 + theme_no} }}")
    return "\n".join(rows)


def direct_stone_add_items(theme_no: int) -> str:
    rows = []
    for stage, weight in direct_drop_weights(direct_drop_cap(theme_no)):
        rows.append(f"      - {{ itemDataId: {200201 + stage}, count: 1, weight: {weight}, group: {200 + theme_no} }}")
    return "\n".join(rows)


def stone_drop_chance(theme_no: int, role_key: str) -> float:
    if theme_no <= EARLY_STONE_DROP_SET_MAX:
        return EARLY_STONE_DROP_CHANCE
    return STONE_DROP_CHANCES[role_key]


def hp_base_for_role(theme_no: int, role: dict) -> float:
    multiplier = EARLY_HP_MULTIPLIERS.get(role["key"], 1.0) if theme_no <= EARLY_STONE_DROP_SET_MAX else 1.0
    return role["hp"] * multiplier


def unit_yaml(theme: Theme, role: dict, role_index: int, sprite_key: str) -> tuple[int, str, str]:
    data_id = boss_id(theme.no) if role["key"] == "giant_boss" else unit_id(theme.no, role_index)
    name = f"{theme.prefix}{role['suffix']}"
    filename = f"{data_id}_{slug(name)}_v1.unit.yaml"
    stat_set_factor = 1.0
    hp_base = hp_base_for_role(theme.no, role) * stat_set_factor
    reward_set_factor = 1.0 + (theme.no - 1) * 0.018
    drop_level = representative_stage(theme.no)
    gold_multiplier = pow(drop_level, 0.72)
    exp_multiplier = pow(drop_level, 0.65)
    gold_lo, gold_hi = role["gold"]
    gold_lo = round(gold_lo * reward_set_factor * gold_multiplier)
    gold_hi = round(gold_hi * reward_set_factor * gold_multiplier)
    exp_count = round(role["exp"] * reward_set_factor * exp_multiplier)
    material_id = 200101 if theme.no <= 4 else 200102 if theme.no <= 8 else 200103
    material_prob = 12 + min(28, theme.no * 2)
    type_line = "" if role["type"] == "Normal" else f'type: {role["type"]}\n'
    text = f"""id: {data_id}
name: "{name}"
{type_line}tags: {flow([*role["tags"], "Taskstonebar", f"Set{theme.no:02d}"])}
armorType: {"BossArmor" if role["type"] == "Boss" else "NormalArmor"}
warmupDelay: {round(0.55 + role_index * 0.08, 2)}
targetMode: Chaser
targetAwareDistance: {32.0 if "Ranged" in role["tags"] else 25.0}
targetResetDistance: {38.0 if "Ranged" in role["tags"] else 31.0}
deadDestroyDelaySeconds: {0.75 if role["type"] in ("Boss", "MidBoss") else 0.45}

addStats:
  - {{ type: Hp, value: {flow(stat_curve(hp_base))} }}
  - {{ type: Attack, value: {flow(stat_curve(role["attack"] * stat_set_factor))} }}
  - {{ type: Defense, value: {flow(stat_curve(role["defense"] * stat_set_factor))} }}
  - {{ type: AttackSpeed, value: [{role["attack_speed"]}] }}
  - {{ type: MoveSpeed, value: [{role["move"]}] }}
  - {{ type: ScalePercent, value: [{role["scale"]}] }}

triggers:
  - {role["trigger"]}

dropAddItemGroups:
  - shouldAddAll: true
    probPercent: 100
    addItems:
      - {{ itemDataId: 5, minCount: {gold_lo}, maxCount: {gold_hi}, isCore: true }}
      - {{ itemDataId: 1, exp: {exp_count} }}
  - shouldAddAll: false
    probPercent: {material_prob}
    addItems:
      - {{ itemDataId: {material_id}, count: 1, weight: 100, group: {theme.no} }}
  - shouldAddAll: false
    probPercent: {EQUIPMENT_DROP_CHANCES[role["key"]]}
    addItems:
{direct_equipment_add_items(theme.no)}
  - shouldAddAll: false
    probPercent: {stone_drop_chance(theme.no, role["key"])}
    addItems:
{direct_stone_add_items(theme.no)}

prefab: "Units/Taskstonebar/PFB_{role["key"].title().replace("_", "")}_{theme.no:02d}.prefab"
sprite: "{SPRITES[sprite_key]}"
uiScale: {role["ui"]}
animations:
  idle: "taskstonebar_enemy_idle"
  move: "taskstonebar_enemy_move"
  attack: "taskstonebar_enemy_attack"
  dead: "taskstonebar_enemy_dead"
"""
    return data_id, filename, text


def map_yaml(stage_no: int, theme: Theme, local_no: int) -> tuple[int, str, str]:
    data_id = map_id(stage_no)
    difficulty_level = difficulty_level_for_stage(stage_no)
    next_id = "self" if stage_no == 100 else str(map_id(stage_no + 1))
    name = f"{theme.map_root}{MAP_LABELS[local_no - 1]}"
    filename = f"{data_id}_{slug(name)}_v1.map.yaml"
    is_chapter_boss = local_no == 10
    trigger_prefix = f"TASKSTONEBARSET{theme.no:02d}{'LONG' if is_chapter_boss else ''}"
    gold_base = round(92 * pow(stage_no, 1.34))
    exp_base = round(26 * pow(stage_no, 1.18))
    tags = ["ContainPlayerInventory", "InfiniteWaves", "Taskstonebar"]
    if stage_no == 1:
        tags.insert(1, "Main")
    if is_chapter_boss:
        tags.extend(["Boss", "ChapterBoss"])
    material = 200101 if stage_no <= 40 else 200102 if stage_no <= 80 else 200103
    text = f"""id: {data_id}
group: {data_id}
name: "{name}"
type: Dungeon
tags: {flow(tags)}
scene: "PFB_MAP_Taskstonebar_{theme.no:02d}"
prefab: "Maps/Prefabs/PFB_MAP_Taskstonebar_{theme.no:02d}.prefab"
targetCameraPivot: {{ x: 0.5, y: 0.56 }}
fov: {9.1 if is_chapter_boss else 8.8}

popupArgs:
  ClientModeManager: ModeManagerTaskstonebar
  ClientHomeMapDataId: self
  ClientAutoAdvance: true
  ClientNextMapDataId: {next_id}
  ClientRetryMapDataId: self
  ClientFarmMapDataId: self
  ClientEnemySpawnLaneMinYRatio: 0.75
  ClientEnemySpawnLaneCenterYRatio: 0.875
  ClientEnemySpawnLaneMaxYRatio: 1.0
  ClientEnemySpawnLaneOffsetsY: "0,-10,10,-18,18,-5,5"

initVariables:
  - {{ callerKey: 605, value: {difficulty_level} }}
  - {{ callerKey: 606, value: {difficulty_level} }}

boardConstants:
  levelUpChoiceCount: 3

initLevel: {difficulty_level}
requiredExps: {flow(player_level_required_exps())}
initGold: {120 + stage_no * 24}
enableUnitExp: true
playerUnitCount: 0

triggers:
  - MAP_ONSTART_{trigger_prefix}WAVE1
  - MAP_ONUPDATE_{trigger_prefix}UPDATE

locations:
  - id: -1
    position: {{ x: -2.8, y: 0.0 }}
    geometries:
      - circle:
          center: {{ x: 0.0, y: 0.0 }}
          radius: 0.9
  - id: 101
    position: {{ x: 3.1, y: 0.0 }}
    geometries:
      - circle:
          center: {{ x: 0.0, y: 0.0 }}
          radius: {1.05 if is_chapter_boss else 0.75}

terrains:
  - vertices:
      - {{ position: {{ x: -8.0, y: -4.5 }}, height: 0.0 }}
      - {{ position: {{ x: 8.0, y: -4.5 }}, height: 0.0 }}
      - {{ position: {{ x: 8.0, y: 4.5 }}, height: 0.0 }}
      - {{ position: {{ x: -8.0, y: 4.5 }}, height: 0.0 }}
    triangles:
      - {{ v1: 0, v2: 1, v3: 2 }}
      - {{ v1: 0, v2: 2, v3: 3 }}
  - type: Skill
    vertices:
      - {{ position: {{ x: -8.0, y: -4.5 }}, height: 0.0 }}
      - {{ position: {{ x: 8.0, y: -4.5 }}, height: 0.0 }}
      - {{ position: {{ x: 8.0, y: 4.5 }}, height: 0.0 }}
      - {{ position: {{ x: -8.0, y: 4.5 }}, height: 0.0 }}
    triangles:
      - {{ v1: 0, v2: 1, v3: 2 }}
      - {{ v1: 0, v2: 2, v3: 3 }}

rewardAddItemGroups:
  - shouldAddAll: true
    probPercent: 100
    addItems:
      - {{ itemDataId: 5, minCount: {gold_base}, maxCount: {round(gold_base * (1.35 if is_chapter_boss else 1.22))}, isCore: true }}
  - shouldAddAll: false
    probPercent: {36 if is_chapter_boss else 18}
    addItems:
      - {{ itemDataId: {material}, count: {3 if is_chapter_boss else 1}, weight: 100, group: {theme.no} }}
"""
    return data_id, filename, text


def add_unit_call(unit_key: str, count: int, level: str, indent: str = "      ") -> str:
    return f"""{indent}- AddUnit:
{indent}    unitDataId: ${unit_key}
{indent}    count: {count}
{indent}    level: {level}
{indent}    team: $enemy_team
{indent}    locationId: $enemy_spawn
"""


def behavior_doc(name: str, vars_block: str, actions: str) -> str:
    return f"""name: {name}
domain: map

vars:
{vars_block}
  enemy_team: {{ type: int, default: 4 }}
  enemy_spawn: {{ type: int, default: 101 }}
  wave_spawned: {{ type: int, default: 604 }}

"on":
  - event: start
    do:
{actions.rstrip()}
"""


def start_actions(set_wave: int, units: list[tuple[str, int, str]], first: bool = False) -> str:
    actions = ""
    if first:
        actions += "      - SetBoardState: { value: Playing }\n"
        actions += "      - SetWave: { value: 1 }\n"
    actions += "      - SetBoardVariable: { key: $wave_spawned, value: 0 }\n"
    actions += "      - SendWaveStartedEvent: {}\n"
    for unit_key, count, level in units:
        actions += add_unit_call(unit_key, count, level)
    total = sum(count for _, count, _ in units)
    actions += f"      - SetBoardVariable: {{ key: $wave_spawned, value: {total} }}\n"
    return actions


def update_doc(name: str, wave_names: list[str]) -> str:
    lines = f"""name: {name}
domain: map

vars:
  enemy_team: {{ type: int, default: 4 }}
  wave_transition_pending: {{ type: int, default: 603 }}

"on":
  - event: update
    every: 1s
    do:
      - when: "waveTransitionPending == 1"
        SetBoardVariable: {{ key: $wave_transition_pending, value: 0 }}
"""
    for idx, wave_name in enumerate(wave_names[1:], start=1):
        next_wave = idx + 1
        lines += f"""
      - GetUnitCountByTeam: {{ team: $enemy_team }}
      - when: "waveTransitionPending == 0 and wave == {idx} and return == 0"
        SetBoardVariable: {{ key: $wave_transition_pending, value: 1 }}
        SetWave: {{ value: {next_wave} }}
        SendWaveQueuedEvent: {{ name: MAP_ONSTART_{wave_name.upper()} }}
"""
    final_wave = len(wave_names)
    lines += f"""
      - GetUnitCountByTeam: {{ team: $enemy_team }}
      - when: "waveTransitionPending == 0 and wave == {final_wave} and return == 0"
        EndGame: {{ result: win }}
"""
    return lines.rstrip() + "\n"


def behavior_yaml() -> str:
    docs: list[str] = []
    for theme in THEMES:
        normal_vars = f"""  basic_unit: {{ type: int, default: {unit_id(theme.no, 1)} }}
  fast_unit: {{ type: int, default: {unit_id(theme.no, 2)} }}
  ranged_unit: {{ type: int, default: {unit_id(theme.no, 3)} }}
  armored_unit: {{ type: int, default: {unit_id(theme.no, 4)} }}
  miniboss_unit: {{ type: int, default: {unit_id(theme.no, 5)} }}
"""
        normal_waves = [
            f"TaskstonebarSet{theme.no:02d}Wave1",
            f"TaskstonebarSet{theme.no:02d}Wave2",
            f"TaskstonebarSet{theme.no:02d}Wave3",
            f"TaskstonebarSet{theme.no:02d}Wave4",
            f"TaskstonebarSet{theme.no:02d}MiniBoss",
        ]
        normal_units = [
            [("basic_unit", 7, "enemyLevel")],
            [("basic_unit", 5, "enemyLevel + 1"), ("fast_unit", 4, "enemyLevel + 1")],
            [("ranged_unit", 5, "enemyLevel + 2"), ("armored_unit", 2, "enemyLevel + 2")],
            [("armored_unit", 3, "enemyLevel + 3"), ("fast_unit", 4, "enemyLevel + 3"), ("basic_unit", 5, "enemyLevel + 3")],
            [("miniboss_unit", 1, "bossLevel + 4"), ("ranged_unit", 3, "enemyLevel + 4"), ("basic_unit", 4, "enemyLevel + 4")],
        ]
        for idx, wave_name in enumerate(normal_waves):
            docs.append(behavior_doc(wave_name, normal_vars, start_actions(idx + 1, normal_units[idx], first=idx == 0)))
        docs.append(update_doc(f"TaskstonebarSet{theme.no:02d}Update", normal_waves))

        long_vars = normal_vars + f"  giant_boss_unit: {{ type: int, default: {boss_id(theme.no)} }}\n"
        long_waves = [
            f"TaskstonebarSet{theme.no:02d}LongWave1",
            f"TaskstonebarSet{theme.no:02d}LongWave2",
            f"TaskstonebarSet{theme.no:02d}LongWave3",
            f"TaskstonebarSet{theme.no:02d}LongWave4",
            f"TaskstonebarSet{theme.no:02d}LongWave5",
            f"TaskstonebarSet{theme.no:02d}GiantBoss",
        ]
        long_units = [
            [("basic_unit", 8, "enemyLevel")],
            [("fast_unit", 5, "enemyLevel + 1"), ("basic_unit", 6, "enemyLevel + 1")],
            [("ranged_unit", 6, "enemyLevel + 2"), ("armored_unit", 3, "enemyLevel + 2")],
            [("armored_unit", 5, "enemyLevel + 3"), ("ranged_unit", 5, "enemyLevel + 3"), ("fast_unit", 4, "enemyLevel + 3")],
            [("miniboss_unit", 2, "bossLevel + 4"), ("basic_unit", 6, "enemyLevel + 4"), ("ranged_unit", 4, "enemyLevel + 4")],
            [("giant_boss_unit", 1, "bossLevel + 5"), ("armored_unit", 3, "enemyLevel + 5"), ("ranged_unit", 4, "enemyLevel + 5")],
        ]
        for idx, wave_name in enumerate(long_waves):
            docs.append(behavior_doc(wave_name, long_vars, start_actions(idx + 1, long_units[idx], first=idx == 0)))
        docs.append(update_doc(f"TaskstonebarSet{theme.no:02d}LongUpdate", long_waves))
    return "---\n".join(docs)


def write_unit_index(unit_rows: list[tuple[int, str, str, dict]]) -> None:
    rows = [
        """  - id: 110111
    name: "작업돌지기"
    file: _drafts/110111_작업돌지기_v1.unit.yaml
    status: draft
    created_at: 2026-06-23T00:00:00+09:00
    created_by: new-content
    reviewer: null
    reviewed_at: null
    tags: [Player, Taskstonebar]"""
    ]
    for data_id, name, filename, role in unit_rows:
        tags = [*role["tags"], "Taskstonebar"]
        rows.append(
            f"""  - id: {data_id}
    name: "{name}"
    file: _drafts/{filename}
    status: draft
    created_at: {CREATED_AT}
    created_by: gen-units
    reviewer: null
    reviewed_at: null
    series: {SERIES}
    tags: {flow(tags)}"""
        )
    text = f"""version: "1.0"
updated_at: {CREATED_AT}

units:
""" + "\n".join(rows) + "\n"
    (UNIT_DIR / "_index.yaml").write_text(text, encoding="utf-8")


def write_map_index(map_rows: list[tuple[int, int, str, str, bool]]) -> None:
    rows = []
    for data_id, stage_no, name, filename, is_chapter_boss in map_rows:
        tags = ["InfiniteWaves", "Dungeon", "Taskstonebar"]
        if stage_no == 1:
            tags.insert(0, "Main")
        if is_chapter_boss:
            tags.insert(0, "Boss")
            tags.append("ChapterBoss")
        rows.append(
            f"""  - id: {data_id}
    name: "{name}"
    file: _drafts/{filename}
    status: draft
    created_at: {CREATED_AT}
    created_by: gen-maps
    reviewer: null
    reviewed_at: null
    series: {SERIES}
    chapter: {((stage_no - 1) // 10) + 1}
    stage_no: {stage_no}
    tags: {flow(tags)}"""
        )
    text = f"""version: "1.0"
updated_at: {CREATED_AT}

maps:
""" + "\n".join(rows) + "\n"
    (MAP_DIR / "_index.yaml").write_text(text, encoding="utf-8")


def write_balance_notes() -> None:
    text = f"""# Taskstonebar Main 100 Balance Notes

Generated by `harness/tools/taskstonebar_generate_main_set.py`.

## Set Shape

- 100 maps, ids `500101..500200`.
- 10 chapters of 10 maps.
- Maps 1-9 of each chapter use five waves and end with a mini boss.
- Map 10 of each chapter uses six waves and ends with a giant boss.
- Defeat retry edge: `ClientRetryMapDataId: self`.
- Clear edge: `ClientNextMapDataId` points to the next map, except map 100, which repeats itself.
- Farming mode edge is represented as `ClientFarmMapDataId: self`.

## Timing Target

Normal maps currently spawn 43 enemies: 4 waves plus mini boss wave.
Chapter boss maps currently spawn 62 enemies: 5 waves plus giant boss wave.
With the current Godot reference cooldown, this lands in the intended 2-3 minute
band for normal maps and a longer chapter-capstone band for each 10th map.

## Difficulty Curve

The closed set uses cumulative difficulty levels instead of raw map numbers:

- Map 1 starts at difficulty level 1.
- Each wave advances difficulty by one level, and each level is 5% harder.
- A normal 5-wave map runs `L..L+4`; the next map starts at `L+3`
  (the previous map's highest wave minus one).
- A chapter-boss 6-wave map runs `L..L+5`; the next map starts at `L+4`.
- Therefore map 10 starts at difficulty level 28 and map 100 starts at 307.

Each map binds:

- `enemyLevel = cumulativeDifficultyLevel`
- `bossLevel = cumulativeDifficultyLevel`
- `initLevel = cumulativeDifficultyLevel`

Enemy stat arrays use:

- Basic monster baseline after the first chapter: HP 100 / Attack 5 at difficulty level 1.
- First chapter onboarding HP is inflated so starter stones need 2-3 hits:
  basic x4.4, fast x4.5, ranged x4.0, armored x2.0, mini/chapter boss x1.0.
- HP, Attack, and Defense: `base * 1.05^(difficultyLevel-1)`.
- Role identity is expressed through base multipliers, speed/range/defense/skills,
  not hidden chapter stat bumps.

This keeps stage-to-stage pressure continuous and prevents map 10 from remaining
inside the initial one-shot band after all starting stones are active.

## Reward Curve

Map clear rewards:

- Gold min: `round(92 * stage^1.34)`
- Gold max: normal `1.22x`, chapter boss `1.35x`
- EXP: `round(26 * stage^1.18)`, chapter boss `1.45x`

Unit drops emit gold, EXP, existing material ids `200101..200103`, equipment,
and stones directly through `Unit.dropAddItemGroups`.

- Monster gold/EXP are baked into unit drop counts by representative chapter
  difficulty.
- Equipment drops are weighted add-items using real equipment ids
  `200301..200360`.
- Stone drops are weighted add-items using real stone ids `200202..200211`.

Direct loot caps at grade/stage 6 inside this 100-map closed set:

- Direct loot cap by chapter representative stage: `min(6, 1 + representativeStage / 20)`
- Roll window: cap, cap-1, cap-2 with weights `100, 45, 20.25`
- Equipment chance: normal 3%, elite 6%, mini boss 35%, chapter boss 100%
- Stone chance: set 1 early onboarding 8% for every monster role.
- Stone chance after set 1: normal 0.18%, elite 0.45%, mini boss 3.5%, chapter boss 12%

The first chapter deliberately over-samples stones so players see and equip
stone weapons early. A normal early map with 43 enemies expects about 3.4
direct stone drops per clear before merge/upgrades, enough to show the first
synthesis path without flooding the inventory.

At chapter 10 / map 100 (`500200`), this yields roughly 0.20 stage-6 stone per
clear, or one direct stage-6 stone every about five clears. Stage 7-10 stones
remain merge/future-extension territory for this closed set.
"""
    (GROWTH_DIR / "taskstonebar-main-100-balance.notes.md").write_text(text, encoding="utf-8")


def main() -> None:
    MAP_DRAFTS.mkdir(parents=True, exist_ok=True)
    UNIT_DRAFTS.mkdir(parents=True, exist_ok=True)
    GROWTH_DIR.mkdir(parents=True, exist_ok=True)

    unit_rows = []
    for theme in THEMES:
        for role_index, role in enumerate(ROLE_TABLE, start=1):
            data_id, filename, text = unit_yaml(theme, role, role_index, theme.sprites[role_index - 1])
            (UNIT_DRAFTS / filename).write_text(text, encoding="utf-8")
            unit_rows.append((data_id, f"{theme.prefix}{role['suffix']}", filename, role))
        data_id, filename, text = unit_yaml(theme, BOSS_ROLE, 6, theme.sprites[5])
        (UNIT_DRAFTS / filename).write_text(text, encoding="utf-8")
        unit_rows.append((data_id, f"{theme.prefix}{BOSS_ROLE['suffix']}", filename, BOSS_ROLE))
    write_unit_index(unit_rows)

    map_rows = []
    stage_no = 1
    for theme in THEMES:
        for local_no in range(1, 11):
            data_id, filename, text = map_yaml(stage_no, theme, local_no)
            (MAP_DRAFTS / filename).write_text(text, encoding="utf-8")
            map_rows.append((data_id, stage_no, f"{theme.map_root}{MAP_LABELS[local_no - 1]}", filename, local_no == 10))
            stage_no += 1
    write_map_index(map_rows)

    (MAP_DIR / "taskstonebar_main_100.behavior.yaml").write_text(behavior_yaml(), encoding="utf-8")
    write_balance_notes()

    print(f"generated {len(unit_rows)} enemy units and {len(map_rows)} maps for {SERIES}")


if __name__ == "__main__":
    main()
