#!/usr/bin/env python3
"""
compile_unit.py — 하네스 회귀 검사용 미니 컴파일러 (stabilization seed)

content/<game>/units/<unit>.yaml + 연결된 growth(.growth.md) 식을 읽어
idlez ResourceUnit proto-JSON 엔트리로 컴파일하고, 실제 Units.json 과 구조를 대조한다.

이건 "골조가 마크다운 더미가 아니라 실제로 도는 루프"임을 증명하는 최소 도구다.
정식 컴파일러/검증기로 확장될 씨앗. (engine-contract/json-serialization.md 규칙 반영)

사용:
  python3 tools/compile_unit.py [REAL_UNITS_JSON]
  # REAL_UNITS_JSON 생략 시 구조 대조는 건너뜀(컴파일만)
"""
import sys, os, re, json, math

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
GAME = "idlez"

# ---------- 성장 식 파서 ----------
def load_growth(md_path):
    """frontmatter(targets) + 각 formula 섹션의 식/파라미터를 파싱."""
    txt = open(md_path, encoding="utf-8").read()
    fm = re.search(r"^---\n(.*?)\n---\n", txt, re.S)
    import yaml
    meta = yaml.safe_load(fm.group(1)) if fm else {}
    body = txt[fm.end():] if fm else txt
    lo, hi = (meta.get("levels", "1..1")).split("..")
    lo, hi = int(lo), int(hi)

    def section(name):
        m = re.search(rf"^##\s+{re.escape(name)}\b.*?$(.*?)(?=^##\s|\Z)", body, re.S | re.M)
        return m.group(1) if m else ""

    def parse_formula(sec):
        code = re.search(r"`([^`]*=[^`]*)`", sec)
        expr = code.group(1).split("=", 1)[1].strip() if code else None
        params = {}
        for pname, pval in re.findall(r"^\|\s*([A-Za-z_]\w*)\s*\|\s*([0-9.]+)\s*\|", sec, re.M):
            params[pname] = float(pval)
        return expr, params

    arrays = {}
    SAFE = {k: getattr(math, k) for k in ("pow exp log log2 floor ceil sqrt").split()}
    SAFE.update(min=min, max=max, round=round)
    for t in meta.get("targets", []):
        expr, params = parse_formula(section(t["formula"]))
        if not expr:
            continue
        arr = []
        for level in range(lo, hi + 1):
            env = {"level": level, **params, **SAFE}
            arr.append(round(eval(expr, {"__builtins__": {}}, env), 4))
        arrays[t["field"]] = arr
    return meta, arrays

# ---------- 직렬화 쿽 (json-serialization.md) ----------
def comp_addstats(addstats, growth_by_stat):
    out = []
    for s in addstats:
        stat = s["type"]
        val = growth_by_stat.get(stat, [float(v) for v in s["value"]])  # 성장식이 있으면 대체
        entry = {}
        if stat != "Hp":                 # enum 기본값(0=Hp) 생략
            entry["type"] = stat
        entry["value"] = [float(v) for v in val]
        out.append(entry)
    return out

def compile_unit(unit, arrays):
    # addStats[Hp].value -> {"Hp":[...]}
    growth_by_stat = {}
    for field, arr in arrays.items():
        m = re.match(r"addStats\[(\w+)\]\.value", field)
        if m:
            growth_by_stat[m.group(1)] = arr
    e = {"id": unit["id"], "name": unit["name"]}
    if unit.get("type") and unit["type"] != "Normal":   # Normal(0) 생략
        e["type"] = unit["type"]
    e["addStats"] = comp_addstats(unit["addStats"], growth_by_stat)
    if unit.get("tags"):     e["tags"] = unit["tags"]
    if unit.get("prefab"):   e["prefab"] = unit["prefab"]
    if unit.get("triggers"): e["triggers"] = unit["triggers"]
    # armorType=Normal(0), requiredExps(유닛 미사용) 생략
    return e

# ---------- 구조 대조 ----------
def shape(d):
    out = {}
    for k, v in d.items():
        out[k] = f"list<{type(v[0]).__name__ if v else 'empty'}>" if isinstance(v, list) else type(v).__name__
    return out

def main():
    import yaml
    unit = yaml.safe_load(open(f"{ROOT}/content/{GAME}/units/slime_green.unit.yaml", encoding="utf-8"))
    meta, arrays = load_growth(f"{ROOT}/content/{GAME}/growth/slime-stat-growth.growth.md")
    entry = compile_unit(unit, arrays)

    print("=== 컴파일된 슬라임 (배열 일부 축약) ===")
    show = json.loads(json.dumps(entry))
    for st in show["addStats"]:
        if len(st["value"]) > 4:
            st["value"] = st["value"][:4] + [f"...len={len(st['value'])}"]
    print(json.dumps(show, ensure_ascii=False, indent=2))

    # 쿽 자체 검사
    checks = []
    hp = next((s for s in entry["addStats"] if "type" not in s), None)
    checks.append(("Hp type 생략", hp is not None))
    checks.append(("value float", all(isinstance(v, float) for s in entry["addStats"] for v in s["value"])))
    checks.append(("성장식 확장(len>1)", any(len(s["value"]) > 1 for s in entry["addStats"])))

    real_path = sys.argv[1] if len(sys.argv) > 1 else None
    if real_path and os.path.exists(real_path):
        units = json.load(open(real_path, encoding="utf-8"))["units"]
        ref = next((u for u in units if "addStats" in u and "triggers" in u), units[0])
        rs, gs = shape(ref), shape(entry)
        mism = [k for k in gs if k in rs and gs[k] != rs[k]]
        checks.append(("공유 필드 형태 일치", not mism))
        print("\n=== 실제 Units.json 대조 ===")
        for k in sorted(gs):
            tag = "OK" if gs[k] == rs.get(k) else ("실데이터에없음(선택필드)" if k not in rs else "형태≠")
            print(f"  {k:10} 우리:{gs[k]:12} 실제:{rs.get(k,'—'):12} [{tag}]")

    print("\n=== 검사 결과 ===")
    allok = True
    for name, ok in checks:
        allok &= ok
        print(f"  [{'PASS' if ok else 'FAIL'}] {name}")
    print("\n" + ("✅ 컴파일 루프 정상 (회귀 통과)" if allok else "❌ 회귀 실패"))
    sys.exit(0 if allok else 1)

if __name__ == "__main__":
    main()
