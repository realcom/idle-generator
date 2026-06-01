#!/usr/bin/env python3
"""
Fill oracle hwpx template body sections with our markdown content.
Approach: replace text in the empty ◦/- paragraphs of each section.
"""

import re
import sys
from pathlib import Path
from copy import deepcopy
from lxml import etree

HP = 'http://www.hancom.co.kr/hwpml/2011/paragraph'
HC = 'http://www.hancom.co.kr/hwpml/2011/core'
NSMAP_INV = {f'{{{HP}}}': 'hp:', f'{{{HC}}}': 'hc:'}

SECTION_DIR = Path('/Users/yangjinhwan/Projects/idle-game-generator/docs/oracle-miracle/sections')
TEMPLATE_UNPACK = Path('/tmp/oracle-unpacked')
OUTPUT_UNPACK = Path('/tmp/oracle-filled')

# Section markdown → 본문 자리 매핑 (시작 헤더, 끝 마커)
SECTION_MAP = [
    # (md_file, sub_section_header, search_in_section_body, target_kw)
    ('01-problem.md', '1-1', '1-1.', '1-2.'),
    ('01-problem.md', '1-2', '1-2.', '2.'),
    ('02-solution.md', '2-1', '2-1.', '2-2.'),
    ('02-solution.md', '2-2', '2-2.', '3.'),
    ('03-scaleup.md', '3-1', '3-1.', '3-2.'),
    ('03-scaleup.md', '3-2', '3-2.', '3-3.'),
    ('03-scaleup.md', '3-3', '3-3.', '4.'),
    ('04-team.md', '4-1', '4-1.', '4-2.'),
    ('04-team.md', '4-2', '4-2.', '5.'),
    ('05-oracle.md', '5-1', '5-1.', '5-2.'),
    ('05-oracle.md', '5-2', '5-2.', '5-3.'),
    ('05-oracle.md', '5-3', '5-3.', None),
]

def walk_paragraphs(elem, result=None, in_tbl=False):
    if result is None:
        result = []
    for child in elem:
        if child.tag == f'{{{HP}}}p':
            result.append((in_tbl, child))
            walk_paragraphs(child, result, in_tbl)
        elif child.tag == f'{{{HP}}}tbl':
            walk_paragraphs(child, result, in_tbl=True)
        else:
            walk_paragraphs(child, result, in_tbl)
    return result

def get_text(p):
    parts = []
    for r in p.iter():
        if r.tag == f'{{{HP}}}t':
            if r.text:
                parts.append(r.text)
    return ''.join(parts)

def md_to_bullets(md_text, sub_section):
    """
    Extract bullet structure from markdown body of a sub-section.
    Returns list of ('o' or '-', text) tuples.
    - "  ○ XXX" or "○ XXX" → o-level
    - "  - XXX" or "- XXX" → dash-level
    - "### □ Header" → top-level (treated as o)
    """
    lines = md_text.split('\n')
    # Find sub-section start
    start_pattern = re.compile(rf'^##\s+{re.escape(sub_section)}\b')
    end_pattern = re.compile(r'^##\s+(?!' + re.escape(sub_section) + ')')

    bullets = []
    in_section = False
    in_table = False
    table_lines = []

    for line in lines:
        if not in_section:
            if start_pattern.match(line):
                in_section = True
            continue
        if end_pattern.match(line):
            break

        # Skip table blocks for now (will convert to text dump)
        if line.strip().startswith('|'):
            if not in_table:
                in_table = True
                table_lines = []
            table_lines.append(line.strip())
            continue
        else:
            if in_table:
                # Flush table as a single - bullet with summarized text
                # Skip the divider row, keep header + body
                rows = [l for l in table_lines if not re.match(r'^\|[\s\-:|]+\|$', l)]
                if rows:
                    bullets.append(('-', '[표] ' + ' / '.join(
                        ' · '.join(c.strip() for c in r.strip('|').split('|') if c.strip())
                        for r in rows[:6]  # cap rows to avoid bloat
                    )))
                in_table = False
                table_lines = []

        # Image marker (blockquote): summarize as one bullet
        if line.startswith('> '):
            bullets.append(('-', line[2:].strip()))
            continue

        # ### □ header → o-level
        m = re.match(r'^###\s+□?\s*(.+)$', line)
        if m:
            bullets.append(('o', m.group(1).strip()))
            continue

        # ○ bullet
        m = re.match(r'^\s*○\s+(.+)$', line)
        if m:
            bullets.append(('o', m.group(1).strip()))
            continue

        # - bullet (or "  - ")
        m = re.match(r'^\s*-\s+(.+)$', line)
        if m:
            text = m.group(1).strip()
            # strip leading **bold** markers for cleaner display
            text = re.sub(r'\*\*([^*]+)\*\*', r'\1', text)
            bullets.append(('-', text))
            continue

        # Plain paragraph (no marker) — treat as continuation of last bullet
        if line.strip() and not line.startswith('#'):
            text = re.sub(r'\*\*([^*]+)\*\*', r'\1', line.strip())
            bullets.append(('-', text))
            continue

    return bullets

def make_run(charPrIDRef, text):
    """Create a hp:run element with hp:t containing text."""
    run = etree.SubElement(etree.Element('dummy'), f'{{{HP}}}run')
    run.set('charPrIDRef', charPrIDRef)
    t = etree.SubElement(run, f'{{{HP}}}t')
    t.text = text
    return run

def clone_with_text(template_para, new_text):
    """Clone a paragraph and replace its t content."""
    new_p = deepcopy(template_para)
    # Clear all existing run/text content but keep first run as template
    runs = new_p.findall(f'{{{HP}}}run')
    if not runs:
        return new_p
    # Keep first run, remove others
    first_run = runs[0]
    for r in runs[1:]:
        new_p.remove(r)
    # Replace text in first run
    ts = first_run.findall(f'{{{HP}}}t')
    if ts:
        ts[0].text = new_text
        for t in ts[1:]:
            first_run.remove(t)
    else:
        t = etree.SubElement(first_run, f'{{{HP}}}t')
        t.text = new_text
    return new_p

def find_section_anchor(root, section_kw):
    """Find paragraph element that starts a sub-section (e.g., ' 1-1. 창업아이템 배경 및 필요성')."""
    # Search section-level paragraphs (depth 0, not in table)
    for p in root.iter(f'{{{HP}}}p'):
        t = get_text(p)
        if section_kw in t and len(t) < 60 and '창업아이템' in t or section_kw in t and ('. ' in t[:6]):
            # heuristic: contains kw and is short
            if section_kw in t and len(t) < 80:
                return p
    return None

def get_paragraph_parent_and_index(parent, target):
    """Find index of target in parent's children."""
    for i, ch in enumerate(parent):
        if ch is target:
            return i
    return -1

def fill_section(root, sub_section, bullets, anchors_para_map):
    """
    Replace the empty bullets in a section with our content.
    anchors_para_map: { '1-1': (header_p, empty_paragraphs_list) }
    """
    header_p, empty_paras = anchors_para_map[sub_section]
    if not empty_paras:
        print(f"  [warn] no empty paragraphs found for {sub_section}")
        return

    # Find parent of these paragraphs (they should all share the same parent)
    parent = empty_paras[0].getparent()

    # Find insertion point: after the last empty paragraph in this section
    last_empty = empty_paras[-1]
    insert_after_idx = get_paragraph_parent_and_index(parent, last_empty)

    # Strategy: replace text in existing empty paragraphs, then append more if needed
    # Use the empty paragraphs as templates for new ones

    # Find the ◦ template and - template
    o_template = None
    dash_template = None
    for p in empty_paras:
        t = get_text(p)
        first_run = p.find(f'{{{HP}}}run')
        cpr = first_run.get('charPrIDRef', '') if first_run is not None else ''
        if '◦' in t and o_template is None:
            o_template = p
        elif '-' in t and dash_template is None:
            dash_template = p
    if o_template is None and len(empty_paras) > 1:
        o_template = empty_paras[1]  # fallback
    if dash_template is None and len(empty_paras) > 3:
        dash_template = empty_paras[3]

    if o_template is None or dash_template is None:
        print(f"  [warn] {sub_section}: cannot find o/dash templates")
        return

    # Build new paragraphs from bullets
    new_paras = []
    # First, keep the empty separator at top (paraPr=53 charPr=39 empty)
    if empty_paras:
        first_separator = deepcopy(empty_paras[0])  # likely empty separator
        new_paras.append(first_separator)

    for level, text in bullets:
        if level == 'o':
            new_p = clone_with_text(o_template, ' ◦ ' + text)
        else:
            new_p = clone_with_text(dash_template, '   - ' + text)
        new_paras.append(new_p)

    # Remove old empty paragraphs from parent
    for p in empty_paras:
        parent.remove(p)

    # Insert new paragraphs at the same position
    # Find where the first empty paragraph used to be
    # Since we removed them, use header_p as anchor
    hdr_idx = get_paragraph_parent_and_index(parent, header_p)
    if hdr_idx < 0:
        print(f"  [warn] {sub_section}: header_p not in parent")
        return
    # Find the announcement paragraph(s) after header, skip them
    # Insert new paragraphs after the announcement table
    insert_idx = hdr_idx + 1
    # Skip the announcement paragraph and table (we keep them as-is)
    # Actually empty_paras came after announcement, so the announcement paragraphs are still in place
    # After removing empty_paras, the next index after them is where they used to start
    # We need to re-find that position
    # For simplicity: insert after header_p + look forward for the index where announcement ends
    # Skip paragraphs whose text starts with ※
    cursor = hdr_idx + 1
    while cursor < len(parent):
        nxt = parent[cursor]
        if nxt.tag == f'{{{HP}}}p':
            t = get_text(nxt)
            if t.strip().startswith('※'):
                cursor += 1
                continue
        elif nxt.tag == f'{{{HP}}}tbl':
            # announcement table — skip
            cursor += 1
            continue
        break

    # Insert all new paragraphs at cursor
    for i, np in enumerate(new_paras):
        parent.insert(cursor + i, np)
    print(f"  [{sub_section}] inserted {len(new_paras)} paragraphs, removed {len(empty_paras)} empty")

def main():
    # Parse template
    section_xml = TEMPLATE_UNPACK / 'Contents' / 'section0.xml'
    parser = etree.XMLParser(remove_blank_text=False)
    tree = etree.parse(str(section_xml), parser)
    root = tree.getroot()

    # Identify section anchors and their empty paragraph blocks
    paras = walk_paragraphs(root)
    section_kws = ['1-1.', '1-2.', '2-1.', '2-2.', '3-1.', '3-2.', '3-3.',
                   '4-1.', '4-2.', '5-1.', '5-2.', '5-3.']

    anchors_para_map = {}
    for idx, (in_tbl, p) in enumerate(paras):
        t = get_text(p)
        if in_tbl:
            continue
        for kw in section_kws:
            if t.strip().startswith(kw) and len(t) < 80:
                sub = kw.rstrip('.')
                if sub not in anchors_para_map:
                    # Collect empty paragraphs after this header, up to next section header
                    empty_paras = []
                    for j in range(idx + 1, len(paras)):
                        in_tbl_j, pj = paras[j]
                        tj = get_text(pj)
                        # Stop at next section header
                        if any(tj.strip().startswith(k) and len(tj) < 80 for k in section_kws):
                            break
                        # Also stop at "2.", "3.", "4.", "5." top-level headers
                        if re.match(r'^\s*[2345]\.\s+', tj) and len(tj) < 40:
                            break
                        if in_tbl_j:
                            continue
                        # Skip announcement paragraphs (start with ※) and section header itself
                        if tj.strip().startswith('※'):
                            continue
                        # Only collect non-table empty/marker paragraphs
                        empty_paras.append(pj)
                    anchors_para_map[sub] = (p, empty_paras)
                break

    print("=== anchors found ===")
    for sub, (hp_, eps) in anchors_para_map.items():
        print(f"  {sub}: {len(eps)} empty paragraphs")

    # Process each section
    for md_file, sub, _, _ in SECTION_MAP:
        if sub not in anchors_para_map:
            print(f"[skip] {sub}: not in anchors")
            continue
        md_path = SECTION_DIR / md_file
        if not md_path.exists():
            print(f"[skip] {sub}: md not found")
            continue
        md_text = md_path.read_text(encoding='utf-8')
        bullets = md_to_bullets(md_text, sub)
        print(f"\n[{sub}] {md_file}: {len(bullets)} bullets extracted")
        if bullets:
            fill_section(root, sub, bullets, anchors_para_map)

    # Write back
    out_path = TEMPLATE_UNPACK / 'Contents' / 'section0.xml'
    tree.write(str(out_path), xml_declaration=True, encoding='UTF-8', standalone=True)
    print(f"\n✓ Written: {out_path}")

if __name__ == '__main__':
    main()
