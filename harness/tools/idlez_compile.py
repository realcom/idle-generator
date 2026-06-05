#!/usr/bin/env python3
"""
idlez_compile.py — 하네스 툴체인 v0.2

content/<game>/ 소스를 idlez 엔진 proto-JSON으로 컴파일 + 검증.
지원 타입: unit / item / skill / buff / map / string / achievement / audio
tutorial manifest → Achievements / behavior → Triggers.

직렬화 규칙: engine-contract/json-serialization.md
액션 어휘:   engine-contract/action-vocabulary.md
사용: python3 tools/idlez_compile.py [game] [real_PatchResources_dir]
"""
import copy
import glob
import json
import math
import os
import re
import sys

import yaml

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TICKS_PER_SECOND = 30
DEFAULT_SKILL_COOLDOWN_SECONDS = 1.0


def i64(v):
    return str(int(v))  # int64 → 문자열 (json-serialization.md)


# ============================================================
# 타입 스펙 (enum 기본값=0값 이름 / int64 / 스탯배열 / 드롭 / 중첩)
# enum 값이 기본값과 같으면 직렬화 시 생략(proto3 default omission)
# ============================================================
SPECS = {
    "unit": dict(
        src="units/*.unit.yaml",
        out="Units.json",
        wrap="units",
        global_key="unitGlobal",
        enum={"type": "Normal", "armorType": "NormalArmor", "targetMode": "None"},
        int64=["requiredExps"],
        string_map=["animations"],
        stat=["addStats"],
        drop=["dropAddItemGroups"],
    ),
    "item": dict(
        src="items/*.item.yaml",
        out="Items.json",
        wrap="items",
        global_key="itemGlobal",
        enum={"category": "System", "type": "Unspecified", "weaponCategory": "Normal"},
        int64=["requiredExps"],
        string_map=["spriteGroups", "popupArgs"],
        stat=["addStats", "equipAddStats"],
        drop=[
            "addItemGroups",
            "equipAddItemGroups",
            "sellAddItemGroups",
            "decomposeAddItemGroups",
            "DailyRewardAddItemGroups",
        ],
        alias={"dailyRewardAddItemGroups": "DailyRewardAddItemGroups"},
    ),
    "skill": dict(
        src="skills/*.skill.yaml",
        out="Skills.json",
        wrap="skills",
        global_key="skillGlobal",
        enum={
            "projectileType": "None",
            "targetRefreshType": "NoRefresh",
            "damageType": "NormalDamage",
        },
        int64=[],
        string_map=[],
        stat=[],
        drop=["selfAddItemGroups"],
    ),
    "buff": dict(
        src="buffs/*.buff.yaml",
        out="Buffs.json",
        wrap="buffs",
        global_key="buffGlobal",
        enum={
            "type": "Unspecified",
            "prefabAttachmentTarget": "SkinRoot",
            "damageType": "NormalDamage",
        },
        int64=[],
        string_map=["spriteGroups"],
        stat=["addStats"],
        drop=[],
    ),
    "map": dict(
        src="maps/*.map.yaml",
        out="Maps.json",
        wrap="maps",
        global_key="mapGlobal",
        enum={"type": "Unspecified"},
        int64=[],
        string_map=["spriteGroups", "popupArgs"],
        stat=[],
        drop=["rewardAddItemGroups", "scoutAddItemGroups", "SpawnAddItemGroups"],
        alias={
            "clearAddItemGroups": "rewardAddItemGroups",
            "spawnAddItemGroups": "SpawnAddItemGroups",
        },
    ),
    # 단순 데이터 타입 (passthrough 중심)
    "string": dict(
        src="strings/*.string.yaml",
        out="Strings.json",
        wrap="strings",
        global_key="stringGlobal",
        enum={},
        int64=[],
        string_map=[],
        stat=[],
        drop=[],
    ),
    "achievement": dict(
        src="achievements/*.achievement.yaml",
        out="Achievements.json",
        wrap="achievements",
        global_key="achievementGlobal",
        enum={},
        int64=[],
        string_map=["popupArgs"],
        stat=[],
        drop=["rewardAddItemGroups"],
    ),
    "audio": dict(
        src="audios/*.audio.yaml",
        out="Audios.json",
        wrap="audios",
        global_key="audioGlobal",
        enum={},
        int64=[],
        string_map=[],
        stat=[],
        drop=[],
    ),
}

GLOBAL_DEFAULTS = {
    "globalData": {"minNameLength": 2, "maxNameLength": 10},
    **{spec["global_key"]: {} for spec in SPECS.values()},
}


def load_yaml(path):
    with open(path, encoding="utf-8") as f:
        return yaml.safe_load(f)


def deep_merge(dst, src):
    if src is None:
        return dst
    for key, value in src.items():
        if isinstance(value, dict) and isinstance(dst.get(key), dict):
            deep_merge(dst[key], value)
        else:
            dst[key] = copy.deepcopy(value)
    return dst


def content_base_dir(game, spec):
    return os.path.join(ROOT, "content", game, spec["src"].split("/", 1)[0])


def list_entry_paths(game, tname, spec, errors):
    base_dir = content_base_dir(game, spec)
    index_path = os.path.join(base_dir, "_index.yaml")
    if os.path.exists(index_path):
        index_doc = load_yaml(index_path) or {}
        paths = []
        seen = set()
        rows = index_doc.get(spec["wrap"])
        if rows is None:
            rows = index_doc.get("items", [])
        if not isinstance(rows, list):
            errors.append(f"{index_path}: '{spec['wrap']}' 목록이 없음")
            rows = []
        for row in rows:
            rel = row.get("file")
            if not rel:
                errors.append(f"{index_path}: file 없는 인덱스 행")
                continue
            full = os.path.join(base_dir, rel)
            if not os.path.exists(full):
                errors.append(f"{index_path}: '{rel}' 파일이 존재하지 않음")
                continue
            if full not in seen:
                paths.append(full)
                seen.add(full)
        return paths
    return sorted(glob.glob(os.path.join(ROOT, "content", game, spec["src"])))


def load_resource_globals(game):
    globals_out = copy.deepcopy(GLOBAL_DEFAULTS)
    path = os.path.join(ROOT, "content", game, "resource_globals.yaml")
    if os.path.exists(path):
        deep_merge(globals_out, load_yaml(path) or {})
    return globals_out


# ============================================================
# 성장식 (growth-pipeline.md)
# ============================================================
SAFE = {k: getattr(math, k) for k in "pow exp log log2 floor ceil sqrt".split()}
SAFE.update(min=min, max=max, round=round, abs=abs)


def load_growth(path):
    with open(path, encoding="utf-8") as f:
        txt = f.read()
    fm = re.search(r"^---\n(.*?)\n---\n", txt, re.S)
    meta = yaml.safe_load(fm.group(1))
    body = txt[fm.end() :]
    lo, hi = map(int, meta["levels"].split(".."))

    def section(name):
        m = re.search(rf"^##\s+{re.escape(name)}\b.*?$(.*?)(?=^##\s|\Z)", body, re.S | re.M)
        return m.group(1) if m else ""

    def parse(sec):
        c = re.search(r"`([^`]*=[^`]*)`", sec)
        expr = c.group(1).split("=", 1)[1].strip() if c else None
        params = dict(
            (n, float(v))
            for n, v in re.findall(r"^\|\s*([A-Za-z_]\w*)\s*\|\s*([0-9.]+)\s*\|", sec, re.M)
        )
        return expr, params

    arrays, out = {}, meta.get("output", "float")
    cl = meta.get("clamp", {})
    for target in meta.get("targets", []):
        expr, params = parse(section(target["formula"]))
        if not expr:
            continue
        arr = []
        for level in range(lo, hi + 1):
            value = eval(expr, {"__builtins__": {}}, {"level": level, **params, **SAFE})
            if "min" in cl:
                value = max(value, cl["min"])
            arr.append(i64(round(value)) if out in ("int64", "int32") else round(float(value), 4))
        arrays[target["field"]] = arr
    return meta, arrays


def growth_for(game):
    out = []
    for path in glob.glob(f"{ROOT}/content/{game}/**/*.growth.md", recursive=True):
        out.append(load_growth(path))
    return out


def bind_matches(bind, entry):
    match = bind.get("match", {})
    if "id" in match:
        return entry.get("id") == match["id"]
    if "tag" in match:
        return match["tag"] in (entry.get("tags") or [])
    if "category" in match:
        return entry.get("category") == match["category"]
    return False


# ============================================================
# 보상/드롭 → AddItemGroup (int64 count → 문자열)
# ============================================================
def compile_groups(groups, game):
    out = []
    for group in groups:
        if isinstance(group, dict) and "$ref" in group:
            out += compile_groups(load_anchor(game, group["$ref"]), game)
            continue
        compiled = {}
        if group.get("shouldAddAll"):
            compiled["shouldAddAll"] = True
        for key in ("rank", "level", "levelReferenceItemDataId", "minutes", "maxMinutes"):
            if key in group:
                compiled[key] = int(group[key])
        if "probPercent" in group:
            compiled["probPercent"] = float(group["probPercent"])
        items = []
        for add in group.get("addItems", group.get("adds", [])):
            item = {"itemDataId": add["itemDataId"]}
            for key in ("count", "minCount", "maxCount", "exp", "minExp", "maxExp"):
                if key in add:
                    item[key] = i64(add[key])
            for key in (
                "level",
                "minLevel",
                "maxLevel",
                "days",
                "hours",
                "minutes",
                "group",
                "pityGroup",
                "dropPrefabId",
            ):
                if key in add:
                    item[key] = int(add[key])
            for key in ("weight", "dropTimeToExpiration", "dropDestroyDelay"):
                if key in add:
                    item[key] = float(add[key])
            for key in ("isCore", "hideInRewardPreview", "isDropAutoGetExpired"):
                if add.get(key):
                    item[key] = True
            items.append(item)
        compiled["addItems"] = items
        out.append(compiled)
    return out


def expand_level_up_gold_cost(raw):
    spec = raw.pop("levelUpGoldCost", None)
    if not spec:
        return

    levels = str(spec.get("levels", "1..1"))
    lo, hi = map(int, levels.split(".."))
    base = int(spec.get("base", 0))
    step = int(spec.get("step", 0))
    item_data_id = int(spec.get("itemDataId", 5))

    groups = raw.setdefault("levelUpMaterialItemGroups", [])
    for level in range(lo, hi + 1):
        groups.append(
            {
                "level": level,
                "shouldAllValid": True,
                "materialItems": [
                    {
                        "id": item_data_id,
                        "count": base + step * (level - lo),
                    }
                ],
            }
        )


def expand_summon_cost_scaling(raw):
    spec = raw.pop("summonCostScaling", None)
    if not spec:
        return

    every_purchases = int(spec.get("everyPurchases", 0))
    add_material_count = int(spec.get("addMaterialCount", 0))
    if every_purchases <= 0 or add_material_count <= 0:
        return

    # Engine storage uses existing ResourceItem fields; source YAML keeps the
    # summon-specific meaning explicit.
    raw["regenPeriod"] = every_purchases
    raw["regenCount"] = add_material_count


def load_anchor(game, ref):
    fp, anchor = ref.split("#")
    doc = load_yaml(f"{ROOT}/content/{game}/{fp}")
    return doc[anchor]


def normalize_unit_scalars(entry, path, errors):
    for field in ("collideSize", "hitSize"):
        value = entry.get(field)
        if not isinstance(value, dict):
            continue
        if "x" not in value or "y" not in value:
            errors.append(f"{path}: {field} 객체는 x/y 키가 필요")
            continue
        x = float(value["x"])
        y = float(value["y"])
        if abs(x - y) > 1e-6:
            errors.append(f"{path}: {field} x/y가 달라 scalar float로 변환할 수 없음")
            continue
        entry[field] = x


# ============================================================
# 제네릭 엔트리 컴파일 (모든 정의 타입 공통)
# ============================================================
def compile_statarray(stats, gmap):
    out = []
    for stat in stats:
        stype = stat["type"]
        value = gmap.get(stype, [float(v) for v in stat["value"]])
        compiled = {}
        if stype != "Hp":
            compiled["type"] = stype  # Hp(enum 0) 생략
        compiled["value"] = [float(v) for v in value]
        out.append(compiled)
    return out


def stringify_map_values(mapping):
    out = {}
    for key, value in (mapping or {}).items():
        if value is None:
            continue
        if isinstance(value, bool):
            out[key] = "true" if value else "false"
        else:
            out[key] = str(value)
    return out


def normalize_combat_effect_aliases(value):
    if isinstance(value, list):
        return [normalize_combat_effect_aliases(v) for v in value]

    if not isinstance(value, dict):
        return value

    out = {key: normalize_combat_effect_aliases(v) for key, v in value.items()}
    add_damage = out.get("addDamage")
    if isinstance(add_damage, dict) and "damagePercent" in add_damage and "attackPercentDamages" not in add_damage:
        raw = add_damage.pop("damagePercent")
        values = raw if isinstance(raw, list) else [raw]
        add_damage["attackPercentDamages"] = [float(v) / 100.0 for v in values]
    return out


def compile_entry(src, tname, spec, game, growth, errors, source_path):
    raw = copy.deepcopy(src)
    if tname == "unit":
        normalize_unit_scalars(raw, source_path, errors)
    if tname == "skill" and raw.get("cooldown") is None:
        raw["cooldown"] = DEFAULT_SKILL_COOLDOWN_SECONDS
    if tname == "item":
        expand_level_up_gold_cost(raw)
        expand_summon_cost_scaling(raw)

    gmap = {}
    for meta, arrays in growth:
        bind = meta.get("bind", {})
        if bind.get("type") == tname and bind_matches(bind, raw):
            for field, arr in arrays.items():
                match = re.match(r"(\w+)\[(\w+)\]\.value", field)
                if match:
                    gmap.setdefault(match.group(1), {})[match.group(2)] = arr

    out = {}
    aliases = spec.get("alias", {})
    for key, value in raw.items():
        if key.startswith("_") or value is None:
            continue
        out_key = aliases.get(key, key)
        if out_key in spec["enum"]:
            if value != spec["enum"][out_key]:
                out[out_key] = value
        elif out_key in spec["int64"]:
            out[out_key] = [i64(x) for x in value] if isinstance(value, list) else i64(value)
        elif out_key in spec.get("string_map", []):
            out[out_key] = stringify_map_values(value)
        elif out_key in spec["stat"]:
            out[out_key] = compile_statarray(value, gmap.get(out_key, {}))
        elif out_key in spec["drop"]:
            out.setdefault(out_key, []).extend(compile_groups(value, game))
        else:
            out[out_key] = value
    return normalize_combat_effect_aliases(out)


def compile_tutorial_manifest(game, errors):
    tutorial_global = {}
    achievements = []
    for path in sorted(glob.glob(f"{ROOT}/content/{game}/tutorials/*.tutorial.yaml")):
        doc = load_yaml(path) or {}
        deep_merge(tutorial_global, doc.get("achievementGlobal", {}))
        defaults = doc.get("defaults", {}).get("achievement", {})

        def compile_tutorial_achievement(raw):
            merged = copy.deepcopy(defaults)
            deep_merge(merged, raw)
            return {k: v for k, v in merged.items() if v is not None}

        for _, raw in (doc.get("achievements") or {}).items():
            if "id" not in raw:
                errors.append(f"{path}: tutorial achievement id 누락")
                continue
            achievements.append(compile_tutorial_achievement(raw))

        for step in doc.get("steps", []):
            if "id" not in step:
                errors.append(f"{path}: tutorial step id 누락")
                continue
            ach = compile_tutorial_achievement(step.get("achievement", {}))
            ach["id"] = step["id"]
            achievements.append(ach)
    return tutorial_global, achievements


def sort_entries(entries):
    def key(entry):
        return (
            entry.get("id", 0),
            entry.get("key", ""),
            entry.get("name", ""),
        )

    return sorted(entries, key=key)


# ============================================================
# behavior → Triggers.json (action-vocabulary.md)
# ============================================================
EVENT = {
    "start": "OnStart",
    "update": "OnUpdate",
    "attack": "OnAttack",
    "attacked": "OnAttacked",
    "attacked_post": "OnAttackedPost",
    "heal": "OnHeal",
    "healed": "OnHealed",
    "buff_apply": "OnBuffApply",
    "kill": "OnKill",
    "owner_kill": "OnOwnerKill",
    "dead": "OnDead",
    "destroy": "OnDestroy",
}
ACTIONS = {
    "increaseGold": ("unitMethod", "IncreaseGold", {"amount": "Count"}),
    "increaseExp": ("unitMethod", "IncreaseExp", {"amount": "Count"}),
    "addBuff": (
        "unitMethod",
        "AddBuff",
        {"buffDataId": "BuffDataId", "level": "Level", "duration": "Duration"},
    ),
    "useSkill": ("unitMethod", "UseSkill", {"skillDataId": "SkillDataId"}),
    "useSkillToTarget": ("unitMethod", "UseSkillToTarget", {"skillDataId": "SkillDataId"}),
    "spawnUnit": ("boardMethod", "AddUnit", {"unitDataId": "UnitDataId", "count": "Count"}),
    "moveTo": ("unitMethod", "SetMoveDestination", {"x": "PositionX", "y": "PositionY"}),
    "SetMoveDestination": (
        "unitMethod",
        "SetMoveDestination",
        {"x": "PositionX", "y": "PositionY"},
    ),
    "moveRandom": (
        "unitMethod",
        "SetMoveRandomDestination",
        {"x": "PositionX", "y": "PositionY", "xRange": "PositionXrange", "yRange": "PositionYrange"},
    ),
    "stop": ("unitMethod", "Stop", {}),
    "SendWaveStartedEvent": ("boardMethod", "SendWaveStartedEvent", {}),
    "GetBoardState": ("boardMethod", "GetBoardState", {}),
    "GetUnitCountByTeam": ("boardMethod", "GetUnitCountByTeam", {"team": "Team"}),
}
METHOD_CALL_ARG_TYPES = {
    ("boardMethod", "GetUnitCount"): ["UnitDataId"],
    ("boardMethod", "GetUnitByDataId"): ["UnitDataId"],
    ("boardMethod", "GetUnitCountByOffset"): ["Offset"],
    ("boardMethod", "GetUnitCountByTeam"): ["Team"],
    ("boardMethod", "GetMainPlayerUnitVariable"): ["Value"],
    ("boardMethod", "RandomBetween"): ["Min", "Max"],
    ("boardMethod", "RandomIntBetween"): ["Min", "Max"],
    ("unitMethod", "GetSkillCooldown"): ["SkillDataId"],
    ("unitMethod", "IsUsingSkillBySkillDataId"): ["SkillDataId"],
    ("unitMethod", "GetBuffByDataId"): ["BuffDataId"],
    ("unitMethod", "IsBuffApplied"): ["BuffDataId"],
    ("unitMethod", "GetInventoryItemCountByTag"): ["Etag"],
    ("skillMethod", "GetSkillCooldown"): [],
    ("skillMethod", "ReduceSkillCooldownByPercent"): ["SkillDataId", "Value"],
    ("skillMethod", "ReduceSkillCooldownBySeconds"): ["SkillDataId", "Value"],
}

TEAM_ALIASES = {
    "neutral": 0,
    "player": 1,
    "playerred": 2,
    "playerblue": 3,
    "enemy": 4,
    "normal": 4,
    "enemyelite": 5,
    "elite": 5,
    "enemyboss": 6,
    "boss": 6,
}
RESULT_ALIASES = {
    "win": 1,
    "player": 1,
    "lose": 4,
    "enemy": 4,
}
BOARD_STATE_ALIASES = {
    "idle": 0,
    "willinitialize": 1000,
    "initializing": 1001,
    "initialized": 1002,
    "willplay": 2000,
    "playing": 2001,
    "willended": 1000000,
    "ended": 1000001,
}
BOARD_VARIABLES = {
    "wave": 601,
    "wavetransitionpending": 603,
    "wave_transition_pending": 603,
    "wavespawned": 604,
    "wave_spawned": 604,
    "enemylevel": 605,
    "enemy_level": 605,
    "bosslevel": 606,
    "boss_level": 606,
}
UNIT_VARIABLES = {
    "dataid": "DataId",
    "positionx": "PositionX",
    "positiony": "PositionY",
    "directionx": "DirectionX",
    "directiony": "DirectionY",
    "velocityx": "VelocityX",
    "velocityy": "VelocityY",
    "hasmovedirection": "HasMoveDirection",
    "movedirectionx": "MoveDirectionX",
    "movedirectiony": "MoveDirectionY",
    "hasmovedestination": "HasMoveDestination",
    "movedestinationx": "MoveDestinationX",
    "movedestinationy": "MoveDestinationY",
    "level": "Level",
    "state": "State",
    "iscollidingwall": "IsCollidingWall",
    "iscollidingunit": "IsCollidingUnit",
    "hp": "Hp",
    "maxhp": "MaxHp",
    "hpratio": "HpRatio",
    "mp": "Mp",
    "maxmp": "MaxMp",
    "mpratio": "MpRatio",
    "shield": "Shield",
    "guard": "Guard",
    "luck": "Luck",
    "hastarget": "HasTarget",
    "targetpositionx": "TargetPositionX",
    "targetpositiony": "TargetPositionY",
    "targetdistance": "TargetDistance",
    "targetangle": "TargetAngle",
    "isboss": "IsBoss",
}


def parse_dur(v):
    if isinstance(v, (int, float)):
        return max(1, int(v))

    text = str(v).strip().lower()
    match = re.match(r"^(\d+(?:\.\d+)?)(?:\s*(ms|msec|millisecond|milliseconds|s|sec|second|seconds|t|tick|ticks))?$", text)
    if not match:
        return 0

    value = float(match.group(1))
    unit = match.group(2)
    if unit in {"s", "sec", "second", "seconds"}:
        return max(1, int(round(value * TICKS_PER_SECOND)))
    if unit in {"ms", "msec", "millisecond", "milliseconds"}:
        return max(1, int(round(value * TICKS_PER_SECOND / 1000)))
    return max(1, int(value))


def _const_operand(v):
    return {"operand": {"constant": {"value": v}}}


def _resolve_behavior_var(raw, vars_, errors, ctx):
    if not (isinstance(raw, str) and raw.startswith("$")):
        return raw

    name = raw[1:]
    if name not in vars_:
        errors.append(f"{ctx}: $변수 '{name}' 미정의")
        return 0

    value = vars_[name]
    if isinstance(value, dict):
        if "default" not in value:
            errors.append(f"{ctx}: $변수 '{name}' 기본값 누락")
            return 0
        return value["default"]
    return value


OPS = {
    "or": ("Or", 1),
    "||": ("Or", 1),
    "and": ("And", 2),
    "&&": ("And", 2),
    "==": ("Equal", 3),
    "!=": ("NotEqual", 3),
    ">": ("GreaterThan", 4),
    ">=": ("GreaterThanOrEqual", 4),
    "<": ("LessThan", 4),
    "<=": ("LessThanOrEqual", 4),
    "+": ("Add", 5),
    "-": ("Subtract", 5),
    "*": ("Multiply", 6),
    "/": ("Divide", 6),
    "%": ("Modulo", 6),
}
PREDEF = {
    "level": "Level",
    "random": "Random",
    "damage": "Damage",
    "validdamage": "ValidDamage",
    "iscritical": "IsCritical",
    "return": "Return",
    "tick": "Tick",
    "timer": "Timer",
}
TOKEN = re.compile(
    r"\s*(>=|<=|==|!=|&&|\|\||[><+\-*/%(),]|\$\w+|[A-Za-z_]\w*(?:\.[A-Za-z_]\w*)*|\d+\.?\d*)"
)
RECEIVER = {
    "board": "boardMethod",
    "unit": "unitMethod",
    "skill": "skillMethod",
    "buff": "buffMethod",
}


def _operand(tok, vars_, errors, ctx):
    if re.match(r"^\d", tok):
        return _const_operand(float(tok))
    if tok.startswith("$"):
        return _const_operand(_resolve_behavior_var(tok, vars_, errors, ctx))
    low = tok.lower()
    norm = low.replace("_", "").replace("-", "")
    if low in BOARD_VARIABLES:
        return {"operand": {"variable": {"boardKey": BOARD_VARIABLES[low]}}}
    if low in PREDEF:
        return {"operand": {"variable": {"predefinedVariable": {"type": PREDEF[low]}}}}
    if norm in UNIT_VARIABLES:
        return {
            "operand": {
                "variable": {
                    "caller": True,
                    "unitVariable": {"type": UNIT_VARIABLES[norm]},
                }
            }
        }
    errors.append(f"{ctx}: 표현식 식별자 '{tok}' 미지원(사전정의 변수/$var/숫자/도메인.메서드 만)")
    return _const_operand(0)


def _is_method_path(tok):
    if "." not in tok:
        return False
    left = tok.split(".", 1)[0].lower()
    return left in RECEIVER


def _method_call_operand(receiver_method, arg_exprs, vars_, errors, ctx):
    receiver, method = receiver_method.split(".", 1)
    domain = RECEIVER[receiver.lower()]
    assignments = []
    parameter_types = METHOD_CALL_ARG_TYPES.get((domain, method))
    if parameter_types is None:
        parameter_types = ["Value"] * len(arg_exprs)
    if len(arg_exprs) > len(parameter_types):
        errors.append(
            f"{ctx}: '{receiver_method}' 인자 {len(arg_exprs)}개 — 지원 파라미터 {len(parameter_types)}개 초과"
        )
    for arg_expr, parameter_type in zip(arg_exprs, parameter_types):
        assignments.append(
            {
                "expression": {"postfix": arg_expr},
                "variable": {"parameter": {"type": parameter_type}},
            }
        )
    return {"operand": {"call": {"method": {domain: {"type": method}}, "assignments": assignments}}}


def expr_postfix(s, vars_, errors, ctx):
    toks = [m.group(1) for m in TOKEN.finditer(s)]
    out, stk = [], []
    i = 0
    while i < len(toks):
        tok = toks[i]
        low = tok.lower()
        if low in OPS:
            name, prec = OPS[low]
            while stk and stk[-1][0] != "(" and stk[-1][1] >= prec:
                out.append({"operator": {"type": stk.pop()[0]}})
            stk.append((name, prec))
        elif tok == "(":
            stk.append(("(", 0))
        elif tok == ")":
            while stk and stk[-1][0] != "(":
                out.append({"operator": {"type": stk.pop()[0]}})
            if stk:
                stk.pop()
        elif tok == ",":
            pass
        elif _is_method_path(tok):
            if i + 1 < len(toks) and toks[i + 1] == "(":
                depth = 1
                j = i + 2
                args, cur = [], []
                while j < len(toks) and depth > 0:
                    tt = toks[j]
                    if tt == "(":
                        depth += 1
                        cur.append(tt)
                    elif tt == ")":
                        depth -= 1
                        if depth == 0:
                            if cur:
                                args.append(cur)
                                cur = []
                            break
                        cur.append(tt)
                    elif tt == "," and depth == 1:
                        if cur:
                            args.append(cur)
                            cur = []
                    else:
                        cur.append(tt)
                    j += 1
                arg_exprs = []
                for arg_toks in args:
                    arg_exprs.append(expr_postfix(" ".join(arg_toks), vars_, errors, ctx)["postfix"])
                out.append(_method_call_operand(tok, arg_exprs, vars_, errors, ctx))
                i = j
            else:
                errors.append(f"{ctx}: 메서드 경로 '{tok}' 가 호출 형태가 아님")
                out.append(_const_operand(0))
        else:
            out.append(_operand(tok, vars_, errors, ctx))
        i += 1
    while stk:
        out.append({"operator": {"type": stk.pop()[0]}})
    return {"postfix": out}


def normalize_team(raw):
    if raw is None:
        return None
    if isinstance(raw, str):
        mapped = TEAM_ALIASES.get(raw.replace("_", "").replace("-", "").lower())
        if mapped is not None:
            return mapped
    return raw


def normalize_result(raw):
    if raw is None:
        return None
    if isinstance(raw, str):
        mapped = RESULT_ALIASES.get(raw.replace("_", "").replace("-", "").lower())
        if mapped is not None:
            return mapped
    return raw


def normalize_board_state(raw):
    if raw is None:
        return None
    if isinstance(raw, str):
        mapped = BOARD_STATE_ALIASES.get(raw.replace("_", "").replace("-", "").lower())
        if mapped is not None:
            return mapped
    return raw


def _walk_trigger_calls(statements):
    for statement in statements or []:
        if "call" in statement:
            yield statement["call"]
        condition = statement.get("condition")
        if condition:
            yield from _walk_trigger_calls(condition.get("statements", []))
            yield from _walk_trigger_calls(condition.get("elseStatements", []))
        loop = statement.get("loop")
        if loop:
            yield from _walk_trigger_calls(loop.get("statements", []))


def _constant_assignment_value(call, parameter_type):
    for assignment in call.get("assignments", []):
        variable = assignment.get("variable", {})
        if variable.get("parameter", {}).get("type") != parameter_type:
            continue
        postfix = assignment.get("expression", {}).get("postfix", [])
        if len(postfix) != 1:
            return None
        operand = postfix[0].get("operand", {})
        constant = operand.get("constant")
        if constant is None:
            return None
        return constant.get("value")
    return None


def _has_assignment(call, parameter_type):
    return any(
        assignment.get("variable", {}).get("parameter", {}).get("type") == parameter_type
        for assignment in call.get("assignments", [])
    )


def _is_board_method(call, method_type):
    return call.get("method", {}).get("boardMethod", {}).get("type") == method_type


def _validate_map_locations(game_map, errors):
    for location in game_map.get("locations", []):
        location_id = location.get("id")
        geometries = location.get("geometries") or []
        if not geometries:
            errors.append(
                f"map {game_map.get('id')}: location {location_id} geometries 누락 "
                "(AddUnit locationId 스폰 시 런타임 예외 가능)"
            )


def _validate_add_unit_call(call, trigger_name, unit_ids, map_contexts, all_map_location_ids, warns, errors):
    if not _has_assignment(call, "UnitDataId"):
        errors.append(f"trigger {trigger_name}: AddUnit UnitDataId 파라미터 누락")
    unit_data_id = _constant_assignment_value(call, "UnitDataId")
    if unit_data_id is not None:
        try:
            unit_data_id = int(unit_data_id)
        except (TypeError, ValueError):
            errors.append(f"trigger {trigger_name}: AddUnit UnitDataId={unit_data_id!r} 정수 아님")
        else:
            if unit_data_id not in unit_ids:
                errors.append(f"trigger {trigger_name}: AddUnit UnitDataId {unit_data_id} 유닛 리소스 누락")

    count = _constant_assignment_value(call, "Count")
    if count is not None:
        try:
            count = int(count)
        except (TypeError, ValueError):
            errors.append(f"trigger {trigger_name}: AddUnit Count={count!r} 정수 아님")
        else:
            if count <= 0:
                errors.append(f"trigger {trigger_name}: AddUnit Count는 1 이상이어야 함")

    location_id = _constant_assignment_value(call, "LocationId")
    if location_id is None:
        return
    try:
        location_id = int(location_id)
    except (TypeError, ValueError):
        errors.append(f"trigger {trigger_name}: AddUnit LocationId={location_id!r} 정수 아님")
        return
    if location_id == 0:
        return

    if map_contexts:
        for game_map in map_contexts:
            locations = {
                location.get("id"): location
                for location in game_map.get("locations", [])
            }
            location = locations.get(location_id)
            if location is None:
                errors.append(
                    f"map {game_map.get('id')}: trigger {trigger_name} AddUnit LocationId {location_id} 없음"
                )
            elif not (location.get("geometries") or []):
                errors.append(
                    f"map {game_map.get('id')}: trigger {trigger_name} AddUnit LocationId {location_id} geometry 없음"
                )
    elif location_id not in all_map_location_ids:
        warns.append(
            f"trigger {trigger_name}: AddUnit LocationId {location_id}를 가진 맵 location을 찾지 못함"
        )


def make_assignment(value, parameter_type, vars_, errors, ctx):
    operand = {"operand": {"constant": {"value": _resolve_behavior_var(value, vars_, errors, ctx)}}}
    return {
        "expression": {"postfix": [operand]},
        "variable": {"parameter": {"type": parameter_type}},
    }


def make_parameter_assignment(value, parameter_type, vars_, errors, ctx, *, allow_expression=False):
    expression = (
        expr_postfix(value, vars_, errors, ctx)
        if allow_expression and isinstance(value, str)
        else {"postfix": [{"operand": {"constant": {"value": _resolve_behavior_var(value, vars_, errors, ctx)}}}]}
    )
    return {
        "expression": expression,
        "variable": {"parameter": {"type": parameter_type}},
    }


def default_call_caller(owner_domain, method_domain):
    if owner_domain == "unit":
        return method_domain == "unitMethod"
    if owner_domain == "skill":
        return method_domain in {"unitMethod", "skillMethod"}
    if owner_domain == "buff":
        return method_domain in {"unitMethod", "buffMethod"}
    return False


def build_generic_call(domain, method, raw_args, arg_map, vars_, errors, ctx, caller=False):
    assignments = []
    for raw_key, parameter_type in arg_map.items():
        if raw_key not in raw_args:
            continue
        assignments.append(make_assignment(raw_args[raw_key], parameter_type, vars_, errors, ctx))
    call = {"method": {domain: {"type": method}}, "assignments": assignments}
    if caller:
        call["caller"] = True
    return {"call": call}


def validate_action_args(akey, args, allowed_keys, errors, ctx):
    unknown = sorted(set(args) - set(allowed_keys))
    if unknown:
        errors.append(f"{ctx}: 액션 '{akey}' 미지원 인자 {unknown}")


def board_assignment_expression(value, vars_, errors, ctx):
    if isinstance(value, str):
        return expr_postfix(value, vars_, errors, ctx)
    return {
        "postfix": [
            {
                "operand": {
                    "constant": {
                        "value": _resolve_behavior_var(value, vars_, errors, ctx)
                    }
                }
            }
        ]
    }


def build_board_variable_assignment(key, value, vars_, errors, ctx):
    return {
        "assignment": {
            "variable": {"boardKey": _resolve_behavior_var(key, vars_, errors, ctx)},
            "expression": board_assignment_expression(value, vars_, errors, ctx),
        }
    }


def build_behavior_calls(akey, args, vars_, errors, ctx, owner_domain=None):
    if args is None:
        args = {}
    if not isinstance(args, dict):
        errors.append(f"{ctx}: 액션 '{akey}' 인자는 객체여야 함")
        return []

    if akey == "AddUnit":
        validate_action_args(
            akey,
            args,
            {"unitDataId", "count", "locationId", "positionX", "positionY", "angle", "offset", "team", "rank", "level"},
            errors,
            ctx,
        )
        normalized = {}
        for raw_key, parameter_type in (
            ("unitDataId", "UnitDataId"),
            ("count", "Count"),
            ("locationId", "LocationId"),
            ("positionX", "PositionX"),
            ("positionY", "PositionY"),
            ("angle", "Angle"),
            ("offset", "Offset"),
            ("level", "Level"),
        ):
            if raw_key in args:
                normalized[raw_key] = (args[raw_key], parameter_type)

        team = args.get("team")
        if team is None and "rank" in args:
            team = normalize_team(args["rank"])
        else:
            team = normalize_team(team)
        if team is not None:
            normalized["team"] = (team, "Team")

        return [
            {
                "call": {
                    "method": {"boardMethod": {"type": "AddUnit"}},
                    "assignments": [
                        make_parameter_assignment(
                            value,
                            parameter_type,
                            vars_,
                            errors,
                            ctx,
                            allow_expression=parameter_type == "Level",
                        )
                        for value, parameter_type in normalized.values()
                    ],
                }
            }
        ]

    if akey == "SetBoardState":
        validate_action_args(akey, args, {"value"}, errors, ctx)
        value = normalize_board_state(args.get("value"))
        return [
            build_generic_call(
                "boardMethod",
                "SetBoardState",
                {"boardState": value},
                {"boardState": "BoardState"},
                vars_,
                errors,
                ctx,
            )
        ]

    if akey == "SetWave":
        validate_action_args(akey, args, {"value"}, errors, ctx)
        return [build_board_variable_assignment(BOARD_VARIABLES["wave"], args.get("value"), vars_, errors, ctx)]

    if akey == "SetBoardVariable":
        validate_action_args(akey, args, {"key", "value"}, errors, ctx)
        return [build_board_variable_assignment(args.get("key"), args.get("value"), vars_, errors, ctx)]

    if akey == "EndGame":
        validate_action_args(akey, args, {"result"}, errors, ctx)
        result = normalize_result(args.get("result"))
        return [
            build_generic_call(
                "boardMethod",
                "EndGame",
                {"team": result},
                {"team": "Team"},
                vars_,
                errors,
                ctx,
            )
        ]

    if akey == "SendWaveQueuedEvent":
        validate_action_args(akey, args, {"name"}, errors, ctx)
        calls = [build_generic_call("boardMethod", "SendWaveQueuedEvent", {}, {}, vars_, errors, ctx)]
        if "name" in args:
            calls.append(
                {
                    "call": {
                        "method": {"runTrigger": {"name": args["name"]}},
                        "assignments": [],
                    }
                }
            )
        return calls

    if akey not in ACTIONS:
        errors.append(f"{ctx}: 액션 '{akey}' 어휘에 없음")
        return []

    domain, method, arg_map = ACTIONS[akey]
    validate_action_args(akey, args, set(arg_map), errors, ctx)
    return [
        build_generic_call(
            domain,
            method,
            args,
            arg_map,
            vars_,
            errors,
            ctx,
            caller=default_call_caller(owner_domain, domain),
        )
    ]


def compile_behavior(path, errors):
    with open(path, encoding="utf-8") as f:
        docs = [doc for doc in yaml.safe_load_all(f) if doc]
    triggers = []
    for doc in docs:
        triggers += compile_behavior_doc(doc, path, errors)
    return triggers


def compile_behavior_doc(doc, path, errors):
    dom, name, vars_ = doc["domain"], doc["name"], doc.get("vars", {})
    on_list = doc.get("on")
    if on_list is None:
        on_list = doc.get(True, [])
    triggers = []
    for ev in on_list:
        etok = ev["event"]
        if etok not in EVENT:
            errors.append(f"{path}: 이벤트 '{etok}' 미지원")
            continue
        statements = []
        for action in ev.get("do", []):
            cond = action.get("when")
            inner = []
            for akey, args in action.items():
                if akey == "when":
                    continue
                inner.extend(build_behavior_calls(akey, args, vars_, errors, path, dom))
            if cond:
                statements.append(
                    {
                        "condition": {
                            "expression": expr_postfix(cond, vars_, errors, path),
                            "statements": inner,
                            "elseStatements": [],
                        }
                    }
                )
            else:
                statements.extend(inner)
        trigger = {"name": f"{dom}_ON{etok}_{name}".upper(), "statements": statements}
        if EVENT[etok] != "OnStart":
            trigger["type"] = EVENT[etok]
        if etok == "update" and ev.get("every"):
            trigger["period"] = parse_dur(ev["every"])
        triggers.append(trigger)
    return triggers


def walk_item_refs(node):
    if isinstance(node, dict):
        for key, value in node.items():
            if key == "itemDataId":
                yield value
            else:
                yield from walk_item_refs(value)
    elif isinstance(node, list):
        for item in node:
            yield from walk_item_refs(item)


def required_item_bindings(profile):
    reserved = profile.get("reserved_ids", {})
    currencies = profile.get("currencies", {})
    bindings = []
    if "playerLevel" in reserved:
        bindings.append(("playerLevel", reserved["playerLevel"]))
    if "credit" in currencies:
        bindings.append(("credit", currencies["credit"]["id"]))
    if "premium" in currencies:
        bindings.append(("ruby", currencies["premium"]["id"]))
    if "premium_free" in currencies:
        bindings.append(("freeRuby", currencies["premium_free"]["id"]))
    if "soft" in currencies:
        bindings.append(("gold", currencies["soft"]["id"]))
    if "exp" in currencies:
        bindings.append(("exp", currencies["exp"]["id"]))
    if "rankPoint" in reserved:
        bindings.append(("rankPoint", reserved["rankPoint"]))
    if "energy" in reserved:
        bindings.append(("energy", reserved["energy"]))
    if "defaultCharacter" in reserved:
        bindings.append(("defaultCharacter", reserved["defaultCharacter"]))
    return bindings


def _iter_entry_stats(tname, entry):
    for stat_field in SPECS[tname]["stat"]:
        for stat in entry.get(stat_field, []):
            yield stat_field, stat.get("type", "Hp"), stat.get("value", [])


def _as_float(value, ctx, errors):
    try:
        return float(value)
    except (TypeError, ValueError):
        errors.append(f"{ctx}: 숫자 값이 아님 ({value!r})")
        return None


def validate_stat_guardrails(profile, tname, entry, errors):
    guardrails = profile.get("stats", {}).get("guardrails", {}) or {}
    if not guardrails:
        return

    for stat_field, stat_type, values in _iter_entry_stats(tname, entry):
        rule = guardrails.get(stat_type)
        if not rule:
            continue
        min_value = rule.get("min")
        max_value = rule.get("max")
        for idx, raw_value in enumerate(values):
            ctx = f"{tname} {entry.get('id')}.{stat_field}.{stat_type}[{idx}]"
            value = _as_float(raw_value, ctx, errors)
            if value is None:
                continue
            if min_value is not None and value < float(min_value):
                errors.append(f"{ctx}: {value} < min {min_value}")
            if max_value is not None and value > float(max_value):
                errors.append(f"{ctx}: {value} > max {max_value}")


def _unit_stat_values(unit, stat_type):
    for stat in unit.get("addStats", []):
        if stat.get("type", "Hp") == stat_type:
            return stat.get("value", [])
    return None


def validate_unit_visual_scale(profile, bundles, errors):
    config = profile.get("unit_visual_scale", {}) or {}
    rules = config.get("classes", {}) or {}
    if not rules:
        return

    stat_type = config.get("stat", "ScalePercent")
    for unit in bundles.get("unit", []):
        unit_type = unit.get("type", "Normal")
        rule = rules.get(unit_type)
        if not rule:
            continue

        values = _unit_stat_values(unit, stat_type)
        if not values:
            errors.append(
                f"unit {unit.get('id')}: {stat_type} 누락 "
                f"(unit_visual_scale.{unit_type}.target={rule.get('target')})"
            )
            continue

        min_value = rule.get("min")
        max_value = rule.get("max")
        for idx, raw_value in enumerate(values):
            ctx = f"unit {unit.get('id')}.{stat_type}[{idx}]"
            value = _as_float(raw_value, ctx, errors)
            if value is None:
                continue
            if min_value is not None and value < float(min_value):
                errors.append(
                    f"{ctx}: {value} < unit_visual_scale.{unit_type}.min {min_value}"
                )
            if max_value is not None and value > float(max_value):
                errors.append(
                    f"{ctx}: {value} > unit_visual_scale.{unit_type}.max {max_value}"
                )


def _int_or_none(value, ctx, errors):
    try:
        return int(value)
    except (TypeError, ValueError):
        errors.append(f"{ctx}: 정수 값이 아님 ({value!r})")
        return None


def _popup_int(entry, key, ctx, errors, *, required=True):
    popup_args = entry.get("popupArgs") or {}
    if key not in popup_args:
        if required:
            errors.append(f"{ctx}: popupArgs.{key} 누락")
        return None
    return _int_or_none(popup_args[key], f"{ctx}.popupArgs.{key}", errors)


def _parse_csv_ints(raw, ctx, errors):
    if raw is None or raw == "":
        return []
    if isinstance(raw, list):
        values = raw
    else:
        values = [part.strip() for part in str(raw).split(",") if part.strip()]
    out = []
    for value in values:
        parsed = _int_or_none(value, ctx, errors)
        if parsed is not None:
            out.append(parsed)
    return out


def _add_item_total(groups, item_id):
    total = 0
    for group in groups or []:
        for item in group.get("addItems", []):
            if int(item.get("itemDataId", 0)) != item_id:
                continue
            total += int(item.get("count", 1))
    return total


def _material_item_total(groups, item_id):
    total = 0
    for group in groups or []:
        for item in group.get("materialItems", []):
            if int(item.get("id", 0)) != item_id:
                continue
            total += int(item.get("count", 1))
    return total


def _require_ids_exist(owner_ctx, label, ids, known_ids, errors):
    for data_id in ids:
        if data_id not in known_ids:
            errors.append(f"{owner_ctx}: {label} {data_id} 리소스 누락")


def _popup_int_value(entry, key, default=0):
    try:
        return int((entry.get("popupArgs") or {}).get(key, default))
    except (TypeError, ValueError):
        return default


def _skill_tree_item_max_level(item):
    stat_max = 1
    for stat in item.get("addStats", []) or []:
        value = stat.get("value")
        if isinstance(value, list):
            stat_max = max(stat_max, len(value))

    material_max = 1
    for group in item.get("levelUpMaterialItemGroups", []) or []:
        try:
            material_max = max(material_max, int(group.get("level", 0)) + 1)
        except (TypeError, ValueError):
            continue

    return max(stat_max, material_max)


def _level_point_cost_only(materials, level_point_item_id):
    total = 0
    for material in materials or []:
        try:
            item_id = int(material.get("id", material.get("itemDataId", 0)))
            count = int(material.get("count", 1))
        except (TypeError, ValueError):
            return None
        if item_id != level_point_item_id and count > 0:
            return None
        total += max(0, count)
    return total


def _skill_tree_level_up_cost(item, level, level_point_item_id):
    for group in item.get("levelUpMaterialItemGroups", []) or []:
        try:
            group_level = int(group.get("level", -1))
        except (TypeError, ValueError):
            continue
        if group_level != level:
            continue
        return _level_point_cost_only(group.get("materialItems", []), level_point_item_id)
    return None


def _skill_tree_required_item_ids(item):
    raw = (item.get("popupArgs") or {}).get("RequiredSkillItemDataIds")
    if raw is None or raw == "":
        return []
    if isinstance(raw, list):
        values = raw
    else:
        values = [part.strip() for part in str(raw).split(",") if part.strip()]

    out = []
    for value in values:
        try:
            out.append(int(value))
        except (TypeError, ValueError):
            continue
    return out


def _skill_tree_requirements_met(item, player_level, owned_levels):
    if player_level < _popup_int_value(item, "RequiredPlayerLevel", 1):
        return False

    required_skill_level = _popup_int_value(item, "RequiredSkillLevel", 0)
    for required_item_id in _skill_tree_required_item_ids(item):
        required_level = required_skill_level if required_skill_level > 0 else 1
        if owned_levels.get(required_item_id, 0) < required_level:
            return False
    return True


def _skill_tree_available_spends(skill_tree_items, player_level, owned_levels, points, level_point_item_id):
    actions = []
    for item in skill_tree_items:
        item_id = item["id"]
        owned_level = owned_levels.get(item_id, 0)
        if owned_level > 0:
            if owned_level >= _skill_tree_item_max_level(item):
                continue
            cost = _skill_tree_level_up_cost(item, owned_level, level_point_item_id)
            if cost is not None and cost <= points:
                actions.append(("level_up", item_id, cost))
            continue

        if not _skill_tree_requirements_met(item, player_level, owned_levels):
            continue
        cost = max(0, _popup_int_value(item, "UnlockCostLevelPoint", 0))
        if cost <= points:
            actions.append(("unlock", item_id, cost))

    return sorted(actions, key=lambda action: (action[2], action[0] != "unlock", action[1]))


def _validate_skill_tree_early_spend(
    tree_id,
    skill_tree_items,
    level_point_item_id,
    grant_per_level,
    early_until_level,
    errors,
):
    if early_until_level < 2:
        return

    item_by_id = {item["id"]: item for item in skill_tree_items}
    initial_levels = {}
    for item in skill_tree_items:
        if not item.get("initialCreate"):
            continue
        try:
            count = int(item.get("initialCreateCount", 1))
            level = int(item.get("initialCreateLevel", 1))
        except (TypeError, ValueError):
            continue
        if count > 0:
            initial_levels[item["id"]] = max(1, level)

    if not initial_levels:
        errors.append(f"skill_tree {tree_id}: 초반 스킬트리 시작 스킬(initialCreate)이 없음")
        return

    memo = {}

    def search(player_level, points, owned_levels):
        if player_level > early_until_level:
            return True

        next_points = points + grant_per_level
        key = (player_level, next_points, tuple(sorted(owned_levels.items())))
        if key in memo:
            return memo[key]

        actions = _skill_tree_available_spends(
            skill_tree_items,
            player_level,
            owned_levels,
            next_points,
            level_point_item_id,
        )
        for action, item_id, cost in actions:
            next_levels = dict(owned_levels)
            if action == "unlock":
                next_levels[item_id] = max(1, int(item_by_id[item_id].get("initialCreateLevel", 1)))
            else:
                next_levels[item_id] = next_levels[item_id] + 1
            if search(player_level + 1, next_points - cost, next_levels):
                memo[key] = True
                return True

        memo[key] = False
        return False

    if search(2, 0, initial_levels):
        return

    points = 0
    owned_levels = dict(initial_levels)
    for player_level in range(2, early_until_level + 1):
        points += grant_per_level
        actions = _skill_tree_available_spends(
            skill_tree_items,
            player_level,
            owned_levels,
            points,
            level_point_item_id,
        )
        if not actions:
            errors.append(
                f"skill_tree {tree_id}: Lv.{player_level} 초반 스킬 선택지가 없음 "
                f"(보유 레벨 포인트 {points})"
            )
            return
        action, item_id, cost = actions[0]
        points -= cost
        if action == "unlock":
            owned_levels[item_id] = max(1, int(item_by_id[item_id].get("initialCreateLevel", 1)))
        else:
            owned_levels[item_id] += 1


def validate_skill_tree(profile, bundles, errors):
    config = (profile.get("progression", {}) or {}).get("skill_tree")
    if not config:
        return

    items = bundles.get("item", [])
    achievements = bundles.get("achievement", [])
    skills = bundles.get("skill", [])
    item_by_id = {entry.get("id"): entry for entry in items}
    achievement_by_id = {entry.get("id"): entry for entry in achievements}
    skill_ids = {entry.get("id") for entry in skills}

    tree_id = str(
        config.get("tree_id")
        or profile.get("game", {}).get("name")
        or profile.get("game", {}).get("id")
        or ""
    )
    level_point_item_id = _int_or_none(
        config.get("level_point_item_id"),
        "progression.skill_tree.level_point_item_id",
        errors,
    )
    grant_config = config.get("level_point_grant", {}) or {}
    player_level_item_id = _int_or_none(
        config.get("player_level_item_id")
        or grant_config.get("player_level_item_id")
        or profile.get("reserved_ids", {}).get("playerLevel"),
        "progression.skill_tree.player_level_item_id",
        errors,
    )
    if level_point_item_id is None or player_level_item_id is None:
        return
    if level_point_item_id not in item_by_id:
        errors.append(f"skill_tree: level_point_item_id {level_point_item_id} 아이템 누락")
    if player_level_item_id not in item_by_id:
        errors.append(f"skill_tree: player_level_item_id {player_level_item_id} 아이템 누락")

    grant_per_level = _int_or_none(
        grant_config.get("grant_per_player_level_up", 1),
        "progression.skill_tree.level_point_grant.grant_per_player_level_up",
        errors,
    )
    if grant_per_level is None:
        return

    if grant_config.get("via") == "achievement":
        achievement_id = _int_or_none(
            grant_config.get("achievement_id"),
            "progression.skill_tree.level_point_grant.achievement_id",
            errors,
        )
        achievement = achievement_by_id.get(achievement_id)
        ctx = f"skill_tree grant achievement {achievement_id}"
        if achievement is None:
            errors.append(f"{ctx}: 업적 리소스 누락")
        else:
            if achievement.get("condition") != grant_config.get("condition", "LevelUpItem"):
                errors.append(f"{ctx}: condition은 LevelUpItem이어야 함")
            if achievement.get("conditionValue1") != player_level_item_id:
                errors.append(f"{ctx}: conditionValue1은 player_level_item_id여야 함")
            if achievement.get("targetProgress") != 1:
                errors.append(f"{ctx}: targetProgress는 1이어야 함")
            if not achievement.get("repeatable"):
                errors.append(f"{ctx}: repeatable=true 필요")
            if not achievement.get("autoReward"):
                errors.append(f"{ctx}: autoReward=true 필요")
            reward_count = _add_item_total(
                achievement.get("rewardAddItemGroups", []),
                level_point_item_id,
            )
            if reward_count < grant_per_level:
                errors.append(
                    f"{ctx}: 레벨 포인트 {level_point_item_id} 보상이 "
                    f"{grant_per_level}개 이상이어야 함"
                )

    gate_by_level = {}
    for gate in config.get("level_gate_achievements", []) or []:
        player_level = _int_or_none(gate.get("player_level"), "skill_tree.level_gate.player_level", errors)
        achievement_id = _int_or_none(gate.get("achievement_id"), "skill_tree.level_gate.achievement_id", errors)
        if player_level is None or achievement_id is None:
            continue
        gate_by_level[player_level] = achievement_id
        achievement = achievement_by_id.get(achievement_id)
        ctx = f"skill_tree level gate {achievement_id}"
        if achievement is None:
            errors.append(f"{ctx}: 업적 리소스 누락")
            continue
        if achievement.get("condition") != "HasItemLevel":
            errors.append(f"{ctx}: condition은 HasItemLevel이어야 함")
        if achievement.get("conditionValue1") != player_level_item_id:
            errors.append(f"{ctx}: conditionValue1은 player_level_item_id여야 함")
        if achievement.get("conditionValue2") != player_level:
            errors.append(f"{ctx}: conditionValue2는 요구 플레이어 레벨이어야 함")
        if achievement.get("targetProgress") != 1:
            errors.append(f"{ctx}: targetProgress는 1이어야 함")
        if not achievement.get("initialOpen"):
            errors.append(f"{ctx}: initialOpen=true 필요")
        if not achievement.get("autoReward"):
            errors.append(f"{ctx}: autoReward=true 필요")
        if "HideDisplay" not in (achievement.get("tags") or []):
            errors.append(f"{ctx}: tags에 HideDisplay 필요")

    skill_tree_items = [
        item for item in items
        if item.get("category") == "Skill"
        and (item.get("popupArgs") or {}).get("SkillTree") == tree_id
    ]
    if not skill_tree_items:
        errors.append(f"skill_tree {tree_id}: SkillTree popupArgs를 가진 Skill 아이템이 없음")
        return

    skill_tree_item_ids = {item["id"] for item in skill_tree_items}
    for item in skill_tree_items:
        item_id = item["id"]
        ctx = f"skill_tree item {item_id}"
        skill_data_id = item.get("skillDataId")
        if skill_data_id not in skill_ids:
            errors.append(f"{ctx}: skillDataId {skill_data_id} 스킬 리소스 누락")
        if _popup_int(item, "LevelPointItemDataId", ctx, errors) != level_point_item_id:
            errors.append(f"{ctx}: LevelPointItemDataId가 프로필과 다름")
        required_player_level = _popup_int(item, "RequiredPlayerLevel", ctx, errors)
        if required_player_level is not None and required_player_level < 1:
            errors.append(f"{ctx}: RequiredPlayerLevel은 1 이상이어야 함")
        max_skill_level = _popup_int(item, "MaxSkillLevel", ctx, errors)
        if max_skill_level is not None and max_skill_level < 1:
            errors.append(f"{ctx}: MaxSkillLevel은 1 이상이어야 함")

        required_skill_ids = _parse_csv_ints(
            (item.get("popupArgs") or {}).get("RequiredSkillItemDataIds"),
            f"{ctx}.RequiredSkillItemDataIds",
            errors,
        )
        child_skill_ids = _parse_csv_ints(
            (item.get("popupArgs") or {}).get("ChildrenSkillItemDataIds"),
            f"{ctx}.ChildrenSkillItemDataIds",
            errors,
        )
        _require_ids_exist(ctx, "RequiredSkillItemDataIds", required_skill_ids, skill_tree_item_ids, errors)
        _require_ids_exist(ctx, "ChildrenSkillItemDataIds", child_skill_ids, skill_tree_item_ids, errors)
        missing_required_items = sorted(set(required_skill_ids) - set(item.get("requiredItemDataIds", [])))
        if missing_required_items:
            errors.append(
                f"{ctx}: requiredItemDataIds에 선행 스킬 {missing_required_items} 누락"
            )

        if _material_item_total(item.get("levelUpMaterialItemGroups", []), level_point_item_id) <= 0:
            errors.append(f"{ctx}: 스킬 강화 비용에 레벨 포인트 {level_point_item_id}가 없음")

        gate_id = None
        if required_player_level and required_player_level > 1:
            gate_id = gate_by_level.get(required_player_level)
            if gate_id is None:
                errors.append(f"{ctx}: RequiredPlayerLevel {required_player_level} 게이트 업적 누락")
            elif gate_id not in item.get("requiredAchievementDataIds", []):
                errors.append(f"{ctx}: requiredAchievementDataIds에 레벨 게이트 {gate_id} 누락")

        recipe_id = _popup_int(item, "UnlockRecipeItemDataId", ctx, errors, required=False)
        if not recipe_id:
            continue
        recipe = item_by_id.get(recipe_id)
        recipe_ctx = f"skill_tree recipe {recipe_id}"
        if recipe is None:
            errors.append(f"{ctx}: UnlockRecipeItemDataId {recipe_id} 리소스 누락")
            continue
        if recipe.get("category") != "Recipe":
            errors.append(f"{recipe_ctx}: category는 Recipe여야 함")
        unlock_skill_id = _popup_int(recipe, "UnlockSkillItemDataId", recipe_ctx, errors)
        if unlock_skill_id != item_id:
            errors.append(f"{recipe_ctx}: UnlockSkillItemDataId가 스킬 아이템 {item_id}와 다름")
        recipe_required_level = _popup_int(recipe, "RequiredPlayerLevel", recipe_ctx, errors)
        if required_player_level != recipe_required_level:
            errors.append(f"{recipe_ctx}: RequiredPlayerLevel이 스킬 아이템과 다름")
        if _popup_int(recipe, "LevelPointItemDataId", recipe_ctx, errors) != level_point_item_id:
            errors.append(f"{recipe_ctx}: LevelPointItemDataId가 프로필과 다름")
        if gate_id and gate_id not in recipe.get("requiredAchievementDataIds", []):
            errors.append(f"{recipe_ctx}: requiredAchievementDataIds에 레벨 게이트 {gate_id} 누락")
        if item_id not in recipe.get("targetItemDataIds", []):
            errors.append(f"{recipe_ctx}: targetItemDataIds에 {item_id} 누락")
        if _add_item_total(recipe.get("addItemGroups", []), item_id) <= 0:
            errors.append(f"{recipe_ctx}: addItemGroups가 스킬 아이템 {item_id}를 지급하지 않음")
        if _material_item_total(recipe.get("materialItemGroups", []), level_point_item_id) <= 0:
            errors.append(f"{recipe_ctx}: 해금 비용에 레벨 포인트 {level_point_item_id}가 없음")

    early_until_level = config.get("early_spend_each_level_until")
    if early_until_level is not None:
        early_until_level = _int_or_none(
            early_until_level,
            "progression.skill_tree.early_spend_each_level_until",
            errors,
        )
        if early_until_level is not None:
            _validate_skill_tree_early_spend(
                tree_id,
                skill_tree_items,
                level_point_item_id,
                grant_per_level,
                early_until_level,
                errors,
            )


# ============================================================
# 검증
# ============================================================
def _collect_reserved_ids(node, acc):
    """reserved_ids 트리에서 모든 정수 id를 재귀 수집 (대역 검사 화이트리스트)."""
    if isinstance(node, dict):
        for value in node.values():
            _collect_reserved_ids(value, acc)
    elif isinstance(node, list):
        for value in node:
            _collect_reserved_ids(value, acc)
    elif isinstance(node, int) and not isinstance(node, bool):
        acc.add(node)


def validate_id_ranges(profile, bundles, warns, errors):
    """validate.md §6: 타입별 id가 profile.id_ranges 대역 안인가 + 타입 내 중복 없는가.

    reserved_ids / currencies id 는 의도적 예외(예: defaultCharacter 가 unit 대역의
    item)이므로 대역 검사에서 제외한다. 중복 검사는 예약 여부와 무관하게 적용.
    """
    id_ranges = profile.get("id_ranges", {}) or {}
    reserved = set()
    _collect_reserved_ids(profile.get("reserved_ids", {}), reserved)
    for currency in (profile.get("currencies", {}) or {}).values():
        if isinstance(currency, dict) and isinstance(currency.get("id"), int):
            reserved.add(currency["id"])

    for tname, entries in bundles.items():
        rng = id_ranges.get(tname)
        seen = {}
        for entry in entries:
            entry_id = entry.get("id")
            if not isinstance(entry_id, int) or isinstance(entry_id, bool):
                continue
            name = entry.get("name", "?")
            if entry_id in seen:
                errors.append(
                    f"{tname} id {entry_id} 중복 ({seen[entry_id]!r} ↔ {name!r})"
                )
            else:
                seen[entry_id] = name
            if entry_id in reserved or entry_id < 0:
                continue
            if rng:
                start, end = rng.get("start"), rng.get("end")
                if start is not None and end is not None and not (start <= entry_id <= end):
                    warns.append(
                        f"{tname} id {entry_id} ({name!r}) 가 "
                        f"id_ranges.{tname} [{start}~{end}] 밖"
                    )


def validate_reward_groups(bundles, warns, errors):
    """validate.md §7: AddItemGroup 의 probPercent 범위 + weight 무결성.

    가중 추첨(weight) 합이 꼭 100일 필요는 없으므로 합>0 만 강제(=0 이면 추첨 불가).
    weight 가 일부 항목에만 있으면 의도가 모호하므로 경고. shouldAddAll 그룹은 전부
    지급이라 weight 무의미 → 검사 제외.
    """
    for tname, entries in bundles.items():
        drop_fields = SPECS[tname].get("drop", [])
        for entry in entries:
            for drop_field in drop_fields:
                groups = entry.get(drop_field)
                if not isinstance(groups, list):
                    continue
                for gi, group in enumerate(groups):
                    if not isinstance(group, dict):
                        continue
                    ctx = f"{tname} {entry.get('id')}.{drop_field}[{gi}]"
                    prob = group.get("probPercent")
                    if prob is not None and not (0.0 <= float(prob) <= 100.0):
                        errors.append(f"{ctx}: probPercent {prob} 가 0~100 밖")
                    if group.get("shouldAddAll"):
                        continue
                    add_items = group.get("addItems") or []
                    weighted = [a for a in add_items if "weight" in a]
                    if not weighted:
                        continue
                    if len(weighted) != len(add_items):
                        warns.append(
                            f"{ctx}: addItems weight 혼재 "
                            f"(weight 있음 {len(weighted)}/{len(add_items)})"
                        )
                    total = sum(float(a["weight"]) for a in weighted)
                    if total <= 0:
                        errors.append(f"{ctx}: weight 합 {total} (>0 이어야 함)")


def validate(game, bundles, triggers, globals_out, warns, errors):
    profile = load_yaml(f"{ROOT}/game-profiles/{game}.profile.yaml")
    used_stats = set(profile.get("stats", {}).get("use", []))
    trigger_names = {t["name"] for t in triggers}
    trigger_by_name = {t["name"]: t for t in triggers}
    item_ids = {entry["id"] for entry in bundles.get("item", [])}
    unit_ids = {entry["id"] for entry in bundles.get("unit", [])}
    map_by_id = {entry["id"]: entry for entry in bundles.get("map", [])}
    item_by_id = {entry["id"]: entry for entry in bundles.get("item", [])}
    map_contexts_by_trigger = {}
    all_map_location_ids = set()
    for game_map in bundles.get("map", []):
        for location in game_map.get("locations", []):
            location_id = location.get("id")
            if location_id is not None:
                all_map_location_ids.add(location_id)
        for trigger_name in game_map.get("triggers", []):
            map_contexts_by_trigger.setdefault(trigger_name, []).append(game_map)

    for tname, entries in bundles.items():
        for entry in entries:
            validate_stat_guardrails(profile, tname, entry, errors)
            for stat_field in SPECS[tname]["stat"]:
                for stat in entry.get(stat_field, []):
                    stype = stat.get("type", "Hp")
                    if used_stats and stype not in used_stats:
                        warns.append(f"{tname} {entry.get('id')}: 스탯 '{stype}' profile.stats.use 밖")
            for trigger_name in entry.get("triggers", []):
                if trigger_name not in trigger_names:
                    warns.append(f"{tname} {entry.get('id')}: 트리거 '{trigger_name}' 미정의")
            for item_id in walk_item_refs(entry):
                if item_id not in item_ids:
                    warns.append(f"{tname} {entry.get('id')}: itemDataId {item_id} 미정의")

    validate_unit_visual_scale(profile, bundles, errors)
    validate_skill_tree(profile, bundles, errors)
    validate_id_ranges(profile, bundles, warns, errors)
    validate_reward_groups(bundles, warns, errors)

    item_global = globals_out["itemGlobal"]
    map_global = globals_out["mapGlobal"]
    item_data_id = item_global.get("dataId", {})
    avatar_constants = item_global.get("avatarConstants", {})
    map_data_id = map_global.get("dataId", {})
    map_board_constants = map_global.get("boardConstants", {})

    for field_name, expected_id in required_item_bindings(profile):
        actual_id = item_data_id.get(field_name)
        if actual_id != expected_id:
            errors.append(
                f"itemGlobal.dataId.{field_name}={actual_id!r} (expected {expected_id})"
            )
        if expected_id not in item_ids:
            errors.append(f"필수 item {field_name}({expected_id}) 리소스 누락")

    if avatar_constants.get("maxUnitCount", 0) <= 0:
        errors.append("itemGlobal.avatarConstants.maxUnitCount 가 1 이상이어야 함")

    default_character_id = item_data_id.get("defaultCharacter")
    default_character = item_by_id.get(default_character_id)
    if default_character is None:
        errors.append("defaultCharacter 아이템이 존재하지 않음")
    else:
        if default_character.get("category") != "Character":
            errors.append("defaultCharacter 아이템 category 가 Character 여야 함")
        unit_data_id = default_character.get("unitDataId")
        if unit_data_id not in unit_ids:
            errors.append(f"defaultCharacter.unitDataId {unit_data_id} 유닛 리소스 누락")

    shapes = map_board_constants.get("defaultPlayerInventoryShapes") or []
    inventory_shape_required = any(
        "ContainPlayerInventory" in (game_map.get("tags") or [])
        and not game_map.get("playerInventoryShape")
        for game_map in bundles.get("map", [])
    )
    if inventory_shape_required and not shapes:
        errors.append("mapGlobal.boardConstants.defaultPlayerInventoryShapes 누락")

    tutorial_map_id = map_data_id.get("tutorialMap")
    if not tutorial_map_id:
        errors.append("mapGlobal.dataId.tutorialMap 누락")
    elif tutorial_map_id not in map_by_id:
        errors.append(f"tutorialMap {tutorial_map_id} 리소스 누락")
    else:
        tutorial_map = map_by_id[tutorial_map_id]
        if not tutorial_map.get("scene"):
            errors.append(f"tutorialMap {tutorial_map_id}: scene 누락")
        if not any(loc.get("id") == -1 for loc in tutorial_map.get("locations", [])):
            errors.append(f"tutorialMap {tutorial_map_id}: Player location(id=-1) 누락")
        terrain_types = {terrain.get("type", "Unit") for terrain in tutorial_map.get("terrains", [])}
        if "Unit" not in terrain_types:
            errors.append(f"tutorialMap {tutorial_map_id}: Unit terrain 누락")
        if "Skill" not in terrain_types:
            errors.append(f"tutorialMap {tutorial_map_id}: Skill terrain 누락")

    for game_map in bundles.get("map", []):
        _validate_map_locations(game_map, errors)

        seen_types = {}
        for trigger_name in game_map.get("triggers", []):
            trigger = trigger_by_name.get(trigger_name)
            if trigger is None:
                continue
            trig_type = trigger.get("type", "OnStart")
            if trig_type in seen_types:
                errors.append(
                    f"map {game_map.get('id')}: trigger type '{trig_type}' 중복 "
                    f"({seen_types[trig_type]}, {trigger_name})"
                )
            else:
                seen_types[trig_type] = trigger_name

    for trigger in triggers:
        trigger_name = trigger.get("name")
        for call in _walk_trigger_calls(trigger.get("statements", [])):
            if _is_board_method(call, "AddUnit"):
                _validate_add_unit_call(
                    call,
                    trigger_name,
                    unit_ids,
                    map_contexts_by_trigger.get(trigger_name, []),
                    all_map_location_ids,
                    warns,
                    errors,
                )
                continue
            run_trigger_name = call.get("method", {}).get("runTrigger", {}).get("name")
            if run_trigger_name and run_trigger_name not in trigger_names:
                errors.append(f"trigger {trigger_name}: runTrigger '{run_trigger_name}' 미정의")


def compile_game(game):
    errors, warns = [], []
    growth = growth_for(game)
    globals_out = load_resource_globals(game)

    triggers = []
    for path in sorted(glob.glob(f"{ROOT}/content/{game}/**/*.behavior.yaml", recursive=True)):
        triggers += compile_behavior(path, errors)

    bundles = {}
    for tname, spec in SPECS.items():
        entries = []
        for path in list_entry_paths(game, tname, spec, errors):
            entries.append(
                compile_entry(load_yaml(path), tname, spec, game, growth, errors, path)
            )
        bundles[tname] = entries

    tutorial_global, tutorial_achievements = compile_tutorial_manifest(game, errors)
    deep_merge(globals_out["achievementGlobal"], tutorial_global)
    bundles["achievement"].extend(tutorial_achievements)

    for tname in bundles:
        bundles[tname] = sort_entries(bundles[tname])

    validate(game, bundles, triggers, globals_out, warns, errors)
    return bundles, triggers, globals_out, warns, errors


def _t(x):
    if isinstance(x, bool):
        return "bool"
    if isinstance(x, (int, float)):
        return "num"
    return type(x).__name__


def shape(d):
    return {
        k: (f"list<{_t(v[0]) if v else 'e'}>" if isinstance(v, list) else _t(v))
        for k, v in d.items()
    }


# ============================================================
# 오케스트레이터
# ============================================================
def main():
    game = sys.argv[1] if len(sys.argv) > 1 else "idlez"
    realdir = sys.argv[2] if len(sys.argv) > 2 else None

    bundles, triggers, globals_out, warns, errors = compile_game(game)

    outdir = f"{ROOT}/build/{game}"
    os.makedirs(outdir, exist_ok=True)

    for tname, spec in SPECS.items():
        with open(f"{outdir}/{spec['out']}", "w", encoding="utf-8") as f:
            json.dump(
                {
                    spec["global_key"]: globals_out.get(spec["global_key"], {}),
                    spec["wrap"]: bundles[tname],
                },
                f,
                ensure_ascii=False,
                indent=1,
            )

    with open(f"{outdir}/Triggers.json", "w", encoding="utf-8") as f:
        json.dump({"triggers": triggers}, f, ensure_ascii=False, indent=1)
    with open(f"{outdir}/ResourceGlobals.json", "w", encoding="utf-8") as f:
        json.dump({"globalData": globals_out.get("globalData", {})}, f, ensure_ascii=False, indent=2)

    print(f"=== 컴파일 (build/{game}/) ===")
    for tname, spec in SPECS.items():
        print(f"  {spec['out']:14}: {len(bundles[tname])} {tname}(s)")
    print(f"  {'Triggers.json':14}: {len(triggers)} triggers")

    checks = []
    if realdir and os.path.isdir(realdir):
        for tname, spec in SPECS.items():
            if not bundles[tname]:
                continue
            real_path = os.path.join(realdir, spec["out"])
            if not os.path.exists(real_path):
                continue
            with open(real_path, encoding="utf-8") as f:
                real_doc = json.load(f)
            real_entries = real_doc[spec["wrap"]]
            if not real_entries:
                continue
            ref = max(real_entries, key=lambda x: len(set(x) & set(bundles[tname][0])))
            rs, gs = shape(ref), shape(bundles[tname][0])
            mism = [k for k in gs if k in rs and gs[k] != rs[k]]
            checks.append((f"{spec['out']} 구조 일치", not mism, mism))

        real_path = os.path.join(realdir, "Triggers.json")
        if os.path.exists(real_path) and triggers:
            with open(real_path, encoding="utf-8") as f:
                real_triggers = json.load(f)["triggers"]
            real_call = any('"call"' in json.dumps(t) for t in real_triggers)
            out_call = any('"call"' in json.dumps(t) for t in triggers)
            checks.append(("Triggers call 구조", real_call and out_call, []))

    print("\n=== 검증 ===")
    for warn in warns:
        print(f"  [WARN] {warn}")
    for error in errors:
        print(f"  [ERROR] {error}")
    for name, ok, extra in checks:
        print(f"  [{'PASS' if ok else 'FAIL'}] {name}" + (f"  불일치:{extra}" if extra else ""))

    all_ok = not errors and all(ok for _, ok, _ in checks)
    print("\n" + ("✅ 툴체인 통과" if all_ok else "❌ 실패"))
    sys.exit(0 if all_ok else 1)


if __name__ == "__main__":
    main()
