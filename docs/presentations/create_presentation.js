const pptxgen = require("pptxgenjs");

const pres = new pptxgen();
pres.layout = "LAYOUT_16x9";
pres.title = "왜 Harness/Skill인가";

// ── 색상 상수 ──
const C = {
  dark:    "1A1A2E",  // 표지 배경
  darkMid: "16213E",
  accent:  "0F3460",  // 진한 파랑
  red:     "E74C3C",  // AI 단독
  green:   "27AE60",  // Harness
  blue:    "2980B9",  // 프로세스
  orange:  "E67E22",  // 경고
  white:   "FFFFFF",
  offWhite:"F8F9FA",
  gray:    "6C757D",
  lightGray:"E9ECEF",
  codeBg:  "1E1E1E",  // 코드 블록 배경
  codeText:"D4D4D4",  // 코드 텍스트
  border:  "DEE2E6",
  textMain:"212529",
  textSub: "495057",
};

// ── 슬라이드 헬퍼 ──
function slideNum(slide, num) {
  slide.addText(String(num), {
    x: 9.5, y: 5.3, w: 0.4, h: 0.25,
    fontSize: 10, color: C.gray, align: "right"
  });
}

function slideTitle(slide, title, color) {
  slide.addText(title, {
    x: 0.5, y: 0.2, w: 9, h: 0.7,
    fontSize: 28, bold: true, color: color || C.textMain,
    fontFace: "Calibri", margin: 0
  });
}

function accentBar(slide, color) {
  slide.addShape(pres.shapes.RECTANGLE, {
    x: 0, y: 0, w: 10, h: 0.08,
    fill: { color: color || C.blue }, line: { color: color || C.blue }
  });
}

function codeBox(slide, code, x, y, w, h, fontSize) {
  slide.addShape(pres.shapes.RECTANGLE, {
    x, y, w, h,
    fill: { color: C.codeBg },
    line: { color: "333333", width: 1 }
  });
  slide.addText(code, {
    x: x + 0.1, y: y + 0.08, w: w - 0.2, h: h - 0.16,
    fontSize: fontSize || 9.5,
    fontFace: "Consolas",
    color: C.codeText,
    valign: "top",
    margin: 0
  });
}

function commandBox(slide, cmd, x, y, w) {
  slide.addShape(pres.shapes.RECTANGLE, {
    x, y, w, h: 0.42,
    fill: { color: "0D1117" },
    line: { color: "30363D", width: 1 }
  });
  slide.addText([
    { text: "$ ", options: { color: "58A6FF", bold: true } },
    { text: cmd, options: { color: "C9D1D9" } }
  ], {
    x: x + 0.15, y: y + 0.02, w: w - 0.3, h: 0.38,
    fontSize: 11, fontFace: "Consolas", valign: "middle", margin: 0
  });
}

function labelBadge(slide, text, x, y, color) {
  const bgColor = color || C.blue;
  slide.addShape(pres.shapes.RECTANGLE, {
    x, y, w: 1.6, h: 0.3,
    fill: { color: bgColor }, line: { color: bgColor }
  });
  slide.addText(text, {
    x, y, w: 1.6, h: 0.3,
    fontSize: 10, bold: true, color: C.white,
    align: "center", valign: "middle", margin: 0
  });
}


// ═══════════════════════════════════════
// 슬라이드 1 — 표지
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.dark };

  // 장식 사각형들
  s.addShape(pres.shapes.RECTANGLE, {
    x: 0, y: 0, w: 0.35, h: 5.625,
    fill: { color: C.red }, line: { color: C.red }
  });
  s.addShape(pres.shapes.RECTANGLE, {
    x: 0.35, y: 0, w: 0.12, h: 5.625,
    fill: { color: C.green }, line: { color: C.green }
  });

  s.addText("왜 Harness/Skill인가", {
    x: 0.8, y: 1.0, w: 8.8, h: 1.1,
    fontSize: 44, bold: true, color: C.white,
    fontFace: "Calibri"
  });
  s.addText("AI 단독 개발 vs Harness/Skill 이용 개발", {
    x: 0.8, y: 2.2, w: 8.8, h: 0.55,
    fontSize: 20, color: "AAAACC",
    fontFace: "Calibri"
  });

  // 구분선
  s.addShape(pres.shapes.RECTANGLE, {
    x: 0.8, y: 2.9, w: 8, h: 0.04,
    fill: { color: "444466" }, line: { color: "444466" }
  });

  s.addText("idle-game-generator 콘텐츠 제작 체계", {
    x: 0.8, y: 3.1, w: 8.8, h: 0.4,
    fontSize: 14, color: "8888AA",
    fontFace: "Calibri"
  });

  // AI vs Harness 라벨
  s.addShape(pres.shapes.RECTANGLE, {
    x: 0.8, y: 4.2, w: 2.2, h: 0.5,
    fill: { color: C.red, transparency: 20 }, line: { color: C.red }
  });
  s.addText("AI 단독", {
    x: 0.8, y: 4.2, w: 2.2, h: 0.5,
    fontSize: 14, bold: true, color: C.white,
    align: "center", valign: "middle", margin: 0
  });

  s.addText("vs", {
    x: 3.2, y: 4.2, w: 0.6, h: 0.5,
    fontSize: 16, bold: true, color: "888899",
    align: "center", valign: "middle", margin: 0
  });

  s.addShape(pres.shapes.RECTANGLE, {
    x: 4.0, y: 4.2, w: 2.6, h: 0.5,
    fill: { color: C.green, transparency: 20 }, line: { color: C.green }
  });
  s.addText("Harness / Skill", {
    x: 4.0, y: 4.2, w: 2.6, h: 0.5,
    fontSize: 14, bold: true, color: C.white,
    align: "center", valign: "middle", margin: 0
  });
  slideNum(s, 1);
}


// ═══════════════════════════════════════
// 슬라이드 2 — 모두가 AI를 쓴다, 그런데 왜 힘든가?
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.white };
  accentBar(s, C.red);
  slideTitle(s, "모두가 AI를 쓴다 — 그런데 왜 여전히 힘든가?");

  // 왼쪽: AI 도구들
  s.addShape(pres.shapes.RECTANGLE, {
    x: 0.4, y: 1.1, w: 4.3, h: 1.2,
    fill: { color: "FFF5F5" }, line: { color: "FFCCCC" }
  });
  s.addText("ChatGPT · Claude · Copilot · Gemini...", {
    x: 0.5, y: 1.15, w: 4.1, h: 0.4,
    fontSize: 13, bold: true, color: C.red, align: "center", margin: 0
  });
  s.addText("AI 도구는 넘쳐난다", {
    x: 0.5, y: 1.6, w: 4.1, h: 0.6,
    fontSize: 12, color: C.textSub, align: "center", margin: 0
  });

  // 하지만...
  s.addText("하지만 게임 콘텐츠 제작은 여전히 병목", {
    x: 0.4, y: 2.45, w: 9.2, h: 0.45,
    fontSize: 16, bold: true, color: C.textMain, margin: 0
  });

  // "AI한테 물어봤더니..." 실패 사례들
  const fails = [
    { icon: "①", text: "유닛 만들어 달라고 했더니  →  엔진에서 필드 오류" },
    { icon: "②", text: "성장식 짜달라고 했더니     →  밸런스를 완전히 망침" },
    { icon: "③", text: "행동 로직 작성했더니       →  참조 오류로 빌드 실패" },
  ];

  fails.forEach((f, i) => {
    const y = 3.0 + i * 0.65;
    s.addShape(pres.shapes.RECTANGLE, {
      x: 0.4, y, w: 9.2, h: 0.55,
      fill: { color: i % 2 === 0 ? "FFF8F8" : C.white },
      line: { color: "FFE0E0", width: 1 }
    });
    s.addText(f.icon, {
      x: 0.55, y: y + 0.04, w: 0.4, h: 0.45,
      fontSize: 13, bold: true, color: C.red, valign: "middle", margin: 0
    });
    s.addText(f.text, {
      x: 1.05, y: y + 0.04, w: 8.3, h: 0.45,
      fontSize: 13, color: C.textMain, valign: "middle", fontFace: "Consolas", margin: 0
    });
  });

  s.addText("AI는 강하다. 하지만 체계가 없다.", {
    x: 0.4, y: 4.95, w: 9.2, h: 0.5,
    fontSize: 18, bold: true, color: C.red,
    align: "center", valign: "middle", margin: 0
  });
  slideNum(s, 2);
}


// ═══════════════════════════════════════
// 슬라이드 3 — 핵심 비교 표
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.white };
  accentBar(s);
  slideTitle(s, "AI 단독 vs Harness/Skill — 무엇이 다른가");

  // 헤더
  s.addShape(pres.shapes.RECTANGLE, {
    x: 0.3, y: 0.9, w: 2.8, h: 0.42,
    fill: { color: C.textMain }, line: { color: C.textMain }
  });
  s.addText("항목", {
    x: 0.3, y: 0.9, w: 2.8, h: 0.42,
    fontSize: 13, bold: true, color: C.white, align: "center", valign: "middle", margin: 0
  });

  s.addShape(pres.shapes.RECTANGLE, {
    x: 3.2, y: 0.9, w: 2.9, h: 0.42,
    fill: { color: C.red }, line: { color: C.red }
  });
  s.addText("AI 단독", {
    x: 3.2, y: 0.9, w: 2.9, h: 0.42,
    fontSize: 13, bold: true, color: C.white, align: "center", valign: "middle", margin: 0
  });

  s.addShape(pres.shapes.RECTANGLE, {
    x: 6.2, y: 0.9, w: 3.5, h: 0.42,
    fill: { color: C.green }, line: { color: C.green }
  });
  s.addText("Harness / Skill", {
    x: 6.2, y: 0.9, w: 3.5, h: 0.42,
    fontSize: 13, bold: true, color: C.white, align: "center", valign: "middle", margin: 0
  });

  const rows = [
    ["구조",     "자유형 텍스트/JSON",          "스키마 준수 YAML"],
    ["검증",     "없음 (엔진 실행 후 발견)",     "5개 자동 게이트"],
    ["성장식",   "숫자 배열 직접 작성",          "수식 기반 자동 계산"],
    ["행동 로직","임의 로직 (엔진 불보장)",       "action-vocabulary 기반 보장"],
    ["재사용",   "매번 새로 요청",               "engine-contract 공유"],
    ["협업",     "1개 AI가 전부 담당",            "5개 전문 에이전트 분업"],
  ];

  rows.forEach(([label, bad, good], i) => {
    const y = 1.38 + i * 0.65;
    const bg = i % 2 === 0 ? C.white : C.offWhite;

    s.addShape(pres.shapes.RECTANGLE, {
      x: 0.3, y, w: 2.8, h: 0.58,
      fill: { color: bg }, line: { color: C.border }
    });
    s.addText(label, {
      x: 0.4, y: y + 0.04, w: 2.6, h: 0.5,
      fontSize: 12, bold: true, color: C.textMain, valign: "middle", margin: 0
    });

    s.addShape(pres.shapes.RECTANGLE, {
      x: 3.2, y, w: 2.9, h: 0.58,
      fill: { color: "FFF5F5" }, line: { color: "FFD0D0" }
    });
    s.addText("✗  " + bad, {
      x: 3.3, y: y + 0.04, w: 2.7, h: 0.5,
      fontSize: 10.5, color: C.red, valign: "middle", margin: 0
    });

    s.addShape(pres.shapes.RECTANGLE, {
      x: 6.2, y, w: 3.5, h: 0.58,
      fill: { color: "F0FFF4" }, line: { color: "A8E6C0" }
    });
    s.addText("✓  " + good, {
      x: 6.3, y: y + 0.04, w: 3.3, h: 0.5,
      fontSize: 10.5, color: "1B6B3A", valign: "middle", margin: 0
    });
  });
  slideNum(s, 3);
}


// ═══════════════════════════════════════
// 슬라이드 4 — 3계층 아키텍처
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.offWhite };
  accentBar(s, C.green);
  slideTitle(s, "3계층 구조가 차이를 만든다");

  s.addText("AI 단독은 이 구분이 없다. 그래서 매번 결과물이 제각각이다.", {
    x: 0.5, y: 0.92, w: 9, h: 0.35,
    fontSize: 12, color: C.gray, italic: true, margin: 0
  });

  const layers = [
    { color: "27AE60", label: "engine-contract  (불변)", sub: "스키마 · 스탯 · 참조그래프 · 행동어휘", desc: "모든 게임 공통 규칙\n엔진이 이해하는 언어", tag: "모든 게임이 따름" },
    { color: "2980B9", label: "game-profiles  (게임별 설정)", sub: "스탯 · 통화 · 밸런스 가드레일 · ID 범위", desc: "idlez의 설정\n다른 게임은 다른 프로필", tag: "규칙 위에서 설정" },
    { color: "E67E22", label: "content / idlez  (발산)", sub: "유닛 · 맵 · 스킬 · 보상 · 성장식", desc: "AI가 생성, 사람이 승인\n매 업데이트마다 변함", tag: "자유롭게 발산" },
  ];

  layers.forEach((l, i) => {
    const y = 1.4 + i * 1.35;
    s.addShape(pres.shapes.RECTANGLE, {
      x: 1.0, y, w: 6.5, h: 1.15,
      fill: { color: l.color, transparency: 88 },
      line: { color: l.color, width: 2 }
    });
    s.addShape(pres.shapes.RECTANGLE, {
      x: 1.0, y, w: 0.22, h: 1.15,
      fill: { color: l.color }, line: { color: l.color }
    });
    s.addText(l.label, {
      x: 1.32, y: y + 0.08, w: 4.5, h: 0.38,
      fontSize: 14, bold: true, color: l.color, margin: 0
    });
    s.addText(l.sub, {
      x: 1.32, y: y + 0.5, w: 4.5, h: 0.55,
      fontSize: 10, color: C.textSub, margin: 0
    });

    // 오른쪽 설명
    s.addShape(pres.shapes.RECTANGLE, {
      x: 7.7, y: y + 0.1, w: 2.0, h: 0.95,
      fill: { color: l.color, transparency: 92 },
      line: { color: l.color, transparency: 60 }
    });
    s.addText(l.desc, {
      x: 7.75, y: y + 0.15, w: 1.9, h: 0.85,
      fontSize: 9.5, color: C.textSub, valign: "middle", margin: 0
    });

    // 화살표 (마지막 아닐 때)
    if (i < 2) {
      s.addShape(pres.shapes.RECTANGLE, {
        x: 4.0, y: y + 1.15, w: 0.7, h: 0.2,
        fill: { color: C.gray, transparency: 50 }, line: { color: C.gray, transparency: 50 }
      });
      s.addText("▼", {
        x: 3.85, y: y + 1.12, w: 1.0, h: 0.22,
        fontSize: 13, color: C.gray, align: "center", margin: 0
      });
    }
  });
  slideNum(s, 4);
}


// ═══════════════════════════════════════
// 슬라이드 5 — 전체 하네스 컴포넌트 구조
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.offWhite };
  accentBar(s, C.green);
  slideTitle(s, "전체 하네스 컴포넌트 구조");

  // ── 좌측 컬럼: 데이터 계층 흐름 (x: 0.4 ~ 5.6) ──
  const LX = 0.4, LW = 5.1;

  // 규칙 계층 라벨
  s.addText("① 규칙 계층  (불변 — 모든 게임 공유)", {
    x: LX, y: 0.95, w: LW, h: 0.24,
    fontSize: 8.5, bold: true, color: C.gray, margin: 0
  });

  // engine-contract
  s.addShape(pres.shapes.RECTANGLE, {
    x: LX, y: 1.2, w: LW, h: 0.58,
    fill: { color: "27AE60", transparency: 88 }, line: { color: "27AE60", width: 2 }
  });
  s.addShape(pres.shapes.RECTANGLE, {
    x: LX, y: 1.2, w: 0.16, h: 0.58,
    fill: { color: "27AE60" }, line: { color: "27AE60" }
  });
  s.addText("engine-contract", {
    x: LX + 0.25, y: 1.22, w: LW - 0.3, h: 0.28,
    fontSize: 10.5, bold: true, color: "27AE60", margin: 0
  });
  s.addText("스키마 · 스탯 · action-vocabulary · behavior-format · json-serialization", {
    x: LX + 0.25, y: 1.5, w: LW - 0.3, h: 0.24,
    fontSize: 8, color: C.textSub, margin: 0
  });

  // game-profiles
  s.addShape(pres.shapes.RECTANGLE, {
    x: LX, y: 1.88, w: LW, h: 0.58,
    fill: { color: "2980B9", transparency: 88 }, line: { color: "2980B9", width: 2 }
  });
  s.addShape(pres.shapes.RECTANGLE, {
    x: LX, y: 1.88, w: 0.16, h: 0.58,
    fill: { color: "2980B9" }, line: { color: "2980B9" }
  });
  s.addText("game-profiles  (게임별)", {
    x: LX + 0.25, y: 1.9, w: LW - 0.3, h: 0.28,
    fontSize: 10.5, bold: true, color: "2980B9", margin: 0
  });
  s.addText("idlez.profile.yaml — 스탯범위 · 통화 · ID대역 · 밸런스 가드레일", {
    x: LX + 0.25, y: 2.18, w: LW - 0.3, h: 0.24,
    fontSize: 8, color: C.textSub, margin: 0
  });

  // 화살표
  s.addText("↓", { x: LX + LW/2 - 0.3, y: 2.47, w: 0.6, h: 0.28,
    fontSize: 16, color: C.gray, align: "center", margin: 0 });
  s.addText("② 소스 계층  (발산)", {
    x: LX, y: 2.72, w: LW, h: 0.22,
    fontSize: 8.5, bold: true, color: C.gray, margin: 0
  });

  // content/idlez/
  s.addShape(pres.shapes.RECTANGLE, {
    x: LX, y: 2.95, w: LW, h: 0.6,
    fill: { color: "E67E22", transparency: 88 }, line: { color: "E67E22", width: 2 }
  });
  s.addShape(pres.shapes.RECTANGLE, {
    x: LX, y: 2.95, w: 0.16, h: 0.6,
    fill: { color: "E67E22" }, line: { color: "E67E22" }
  });
  s.addText("content / idlez/", {
    x: LX + 0.25, y: 2.97, w: LW - 0.3, h: 0.28,
    fontSize: 10.5, bold: true, color: "E67E22", margin: 0
  });
  s.addText("unit.yaml · skill.yaml · map.yaml · behavior.yaml · growth.md · reward.yaml", {
    x: LX + 0.25, y: 3.25, w: LW - 0.3, h: 0.26,
    fontSize: 8, color: C.textSub, margin: 0
  });

  // 화살표
  s.addText("↓", { x: LX + LW/2 - 0.3, y: 3.57, w: 0.6, h: 0.28,
    fontSize: 16, color: C.gray, align: "center", margin: 0 });
  s.addText("③ 컴파일 / 검증", {
    x: LX, y: 3.82, w: LW, h: 0.22,
    fontSize: 8.5, bold: true, color: C.gray, margin: 0
  });

  // compile + validate (나란히)
  s.addShape(pres.shapes.RECTANGLE, {
    x: LX, y: 4.05, w: 2.45, h: 0.55,
    fill: { color: "34495E", transparency: 88 }, line: { color: "34495E" }
  });
  s.addText("idlez_compile.py", {
    x: LX + 0.08, y: 4.05, w: 2.3, h: 0.55,
    fontSize: 9.5, bold: true, color: "34495E", valign: "middle", margin: 0
  });
  s.addShape(pres.shapes.RECTANGLE, {
    x: LX + 2.65, y: 4.05, w: 2.45, h: 0.55,
    fill: { color: "C0392B", transparency: 88 }, line: { color: "C0392B" }
  });
  s.addText("tools/validate  (5-gate)", {
    x: LX + 2.73, y: 4.05, w: 2.3, h: 0.55,
    fontSize: 9.5, bold: true, color: "C0392B", valign: "middle", margin: 0
  });

  // 화살표
  s.addText("↓", { x: LX + LW/2 - 0.3, y: 4.62, w: 0.6, h: 0.28,
    fontSize: 16, color: C.gray, align: "center", margin: 0 });
  s.addText("④ 빌드 산출", {
    x: LX, y: 4.87, w: LW, h: 0.22,
    fontSize: 8.5, bold: true, color: C.gray, margin: 0
  });

  // build output
  s.addShape(pres.shapes.RECTANGLE, {
    x: LX, y: 5.1, w: LW, h: 0.42,
    fill: { color: "1A1A2E", transparency: 85 }, line: { color: "1A1A2E" }
  });
  s.addText("build/idlez/  →  Units.json · Items.json · Skills.json · Maps.json · Triggers.json", {
    x: LX + 0.15, y: 5.1, w: LW - 0.2, h: 0.42,
    fontSize: 9, bold: true, color: C.dark, valign: "middle", margin: 0
  });

  // ── 우측 컬럼: AI 작성 계층 (x: 5.8 ~ 9.9) ──
  const RX = 5.8, RW = 4.1;

  s.addShape(pres.shapes.RECTANGLE, {
    x: RX, y: 0.95, w: RW, h: 4.6,
    fill: { color: "9B59B6", transparency: 93 }, line: { color: "9B59B6", width: 1.5 }
  });
  s.addText(".claude/  AI 작성 계층", {
    x: RX + 0.15, y: 1.0, w: RW - 0.2, h: 0.3,
    fontSize: 10, bold: true, color: "9B59B6", margin: 0
  });

  // 에이전트 라벨
  s.addText("Agents  (전문 역할 분담)", {
    x: RX + 0.15, y: 1.32, w: RW - 0.2, h: 0.22,
    fontSize: 8.5, bold: true, color: C.textSub, margin: 0
  });
  const agents = [
    { name: "content-designer", sub: "유닛/스킬/맵 정의" },
    { name: "economy-balancer", sub: "성장식 + 경제" },
    { name: "behavior-author", sub: "행동 로직 YAML" },
    { name: "asset-producer", sub: "에셋 키 바인딩" },
    { name: "content-reviewer", sub: "5-gate 검증" },
  ];
  agents.forEach((ag, i) => {
    const ax = RX + 0.1 + (i % 2) * 2.0;
    const ay = 1.57 + Math.floor(i / 2) * 0.72;
    s.addShape(pres.shapes.RECTANGLE, {
      x: ax, y: ay, w: 1.85, h: 0.6,
      fill: { color: "9B59B6", transparency: 82 }, line: { color: "9B59B6" }
    });
    s.addText(ag.name, {
      x: ax + 0.06, y: ay + 0.04, w: 1.73, h: 0.3,
      fontSize: 8, bold: true, color: "7B2FBE", margin: 0
    });
    s.addText(ag.sub, {
      x: ax + 0.06, y: ay + 0.32, w: 1.73, h: 0.24,
      fontSize: 7.5, color: C.textSub, margin: 0
    });
  });

  // 스킬 라벨
  s.addText("Skills  (사용자 진입점 6개)", {
    x: RX + 0.15, y: 3.05, w: RW - 0.2, h: 0.22,
    fontSize: 8.5, bold: true, color: C.textSub, margin: 0
  });
  const skills = ["/gen-unit", "/gen-map", "/gen-skill", "/gen-trigger", "/balance-review", "/new-content"];
  skills.forEach((sk, i) => {
    const sx = RX + 0.1 + (i % 2) * 2.0;
    const sy = 3.3 + Math.floor(i / 2) * 0.48;
    s.addShape(pres.shapes.RECTANGLE, {
      x: sx, y: sy, w: 1.85, h: 0.38,
      fill: { color: "2980B9", transparency: 85 }, line: { color: "2980B9" }
    });
    s.addText(sk, {
      x: sx, y: sy, w: 1.85, h: 0.38,
      fontSize: 8.5, bold: true, color: "2980B9", align: "center", valign: "middle", margin: 0
    });
  });

  // 화살표: AI → content
  s.addText("←  생성", {
    x: RX - 0.45, y: 3.1, w: 0.5, h: 0.3,
    fontSize: 8, color: "9B59B6", bold: true, align: "center", margin: 0
  });

  slideNum(s, 5);
}


// ═══════════════════════════════════════
// 슬라이드 6 — idlez-server + idlez-client 아키텍처
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.dark };
  accentBar(s, "0F3460");
  slideTitle(s, "idlez-server + idlez-client 아키텍처", C.white);

  // 부제
  s.addText("Harness가 만든 JSON이 서버-클라이언트로 흐르는 전체 경로", {
    x: 0.5, y: 0.92, w: 9, h: 0.28,
    fontSize: 11, color: "A0A8B8", italic: true, margin: 0
  });

  // ── Box 1: idle-game-generator (Harness) ──
  s.addShape(pres.shapes.RECTANGLE, {
    x: 0.25, y: 1.35, w: 2.8, h: 3.7,
    fill: { color: "27AE60", transparency: 88 }, line: { color: "27AE60", width: 2 }
  });
  s.addText("idle-game-\ngenerator", {
    x: 0.3, y: 1.42, w: 2.7, h: 0.6,
    fontSize: 13, bold: true, color: "27AE60", align: "center", margin: 0
  });
  s.addText("(Harness)", {
    x: 0.3, y: 1.98, w: 2.7, h: 0.28,
    fontSize: 9.5, color: "27AE60", align: "center", margin: 0
  });

  const harnessItems = [
    "engine-contract",
    "game-profiles",
    "content/idlez/",
    "idlez_compile.py",
    "build/idlez/*.json",
  ];
  harnessItems.forEach((item, i) => {
    s.addShape(pres.shapes.RECTANGLE, {
      x: 0.42, y: 2.35 + i * 0.44, w: 2.46, h: 0.36,
      fill: { color: "27AE60", transparency: 80 }, line: { color: "27AE60", transparency: 60 }
    });
    s.addText(item, {
      x: 0.46, y: 2.35 + i * 0.44, w: 2.38, h: 0.36,
      fontSize: 8.5, color: "D5F5E3", valign: "middle", margin: 0
    });
  });

  // ── 화살표 1: Harness → Server ──
  s.addShape(pres.shapes.RECTANGLE, {
    x: 3.05, y: 2.93, w: 0.7, h: 0.08,
    fill: { color: "A0A8B8" }, line: { color: "A0A8B8" }
  });
  s.addText("►", {
    x: 3.62, y: 2.77, w: 0.3, h: 0.4,
    fontSize: 16, color: "A0A8B8", align: "center", margin: 0
  });
  s.addText("JSON\n콘텐츠 전달", {
    x: 2.98, y: 3.05, w: 0.9, h: 0.45,
    fontSize: 7.5, color: "A0A8B8", align: "center", italic: true, margin: 0
  });

  // ── Box 2: idlez-server (.NET) ──
  s.addShape(pres.shapes.RECTANGLE, {
    x: 3.75, y: 1.35, w: 2.7, h: 3.7,
    fill: { color: "2980B9", transparency: 88 }, line: { color: "2980B9", width: 2 }
  });
  s.addText("idlez-server", {
    x: 3.8, y: 1.42, w: 2.6, h: 0.42,
    fontSize: 13, bold: true, color: "2980B9", align: "center", margin: 0
  });
  s.addText("(.NET)", {
    x: 3.8, y: 1.82, w: 2.6, h: 0.28,
    fontSize: 9.5, color: "2980B9", align: "center", margin: 0
  });

  const serverItems = [
    "콘텐츠 JSON 로드",
    "게임 로직 처리",
    "경제 시스템 관리",
    "REST / WebSocket API",
    "랭킹 · 저장 · 동기화",
  ];
  serverItems.forEach((item, i) => {
    s.addShape(pres.shapes.RECTANGLE, {
      x: 3.87, y: 2.2 + i * 0.44, w: 2.46, h: 0.36,
      fill: { color: "2980B9", transparency: 80 }, line: { color: "2980B9", transparency: 60 }
    });
    s.addText(item, {
      x: 3.91, y: 2.2 + i * 0.44, w: 2.38, h: 0.36,
      fontSize: 8.5, color: "D6EAF8", valign: "middle", margin: 0
    });
  });

  // ── 화살표 2: Server ↔ Client ──
  s.addShape(pres.shapes.RECTANGLE, {
    x: 6.45, y: 2.93, w: 0.7, h: 0.08,
    fill: { color: "A0A8B8" }, line: { color: "A0A8B8" }
  });
  s.addText("►", {
    x: 7.0, y: 2.77, w: 0.3, h: 0.4,
    fontSize: 16, color: "A0A8B8", align: "center", margin: 0
  });
  s.addText("API\nREST/WS", {
    x: 6.38, y: 3.05, w: 0.9, h: 0.45,
    fontSize: 7.5, color: "A0A8B8", align: "center", italic: true, margin: 0
  });

  // ── Box 3: idlez-client (Unity) ──
  s.addShape(pres.shapes.RECTANGLE, {
    x: 7.25, y: 1.35, w: 2.5, h: 3.7,
    fill: { color: "E67E22", transparency: 88 }, line: { color: "E67E22", width: 2 }
  });
  s.addText("idlez-client", {
    x: 7.3, y: 1.42, w: 2.4, h: 0.42,
    fontSize: 13, bold: true, color: "E67E22", align: "center", margin: 0
  });
  s.addText("(Unity)", {
    x: 7.3, y: 1.82, w: 2.4, h: 0.28,
    fontSize: 9.5, color: "E67E22", align: "center", margin: 0
  });

  const clientItems = [
    "씬(Scene) 렌더링",
    "프리팹(Prefab) 표시",
    "유저 인터페이스",
    "Spine 애니메이션",
    "Unity AI ★ (미래)",
  ];
  clientItems.forEach((item, i) => {
    const isAI = item.includes("★");
    s.addShape(pres.shapes.RECTANGLE, {
      x: 7.37, y: 2.2 + i * 0.44, w: 2.26, h: 0.36,
      fill: { color: isAI ? "7B2FBE" : "E67E22", transparency: isAI ? 70 : 80 },
      line: { color: isAI ? "7B2FBE" : "E67E22", transparency: isAI ? 0 : 60 }
    });
    s.addText(item, {
      x: 7.41, y: 2.2 + i * 0.44, w: 2.18, h: 0.36,
      fontSize: 8.5, color: isAI ? "D8B4FE" : "FDEBD0", bold: isAI, valign: "middle", margin: 0
    });
  });

  // ── Unity AI 설명 박스 ──
  s.addShape(pres.shapes.RECTANGLE, {
    x: 0.25, y: 5.13, w: 9.5, h: 0.45,
    fill: { color: "7B2FBE", transparency: 80 }, line: { color: "7B2FBE" }
  });
  s.addText("★  Unity AI  (unity.com/features/ai)  →  scene 자동 생성 · prefab 자동 수정  →  Harness asset-pipeline 연동 (3개월 로드맵)", {
    x: 0.4, y: 5.13, w: 9.2, h: 0.45,
    fontSize: 9.5, color: "D8B4FE", bold: true, valign: "middle", margin: 0
  });

  slideNum(s, 6);
}


// ═══════════════════════════════════════
// 슬라이드 7 — JSON 시스템 소개
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.offWhite };
  accentBar(s, C.blue);
  slideTitle(s, "키우기 게임 JSON 시스템");

  s.addText("엔진이 읽는 proto3 기반 커스텀 직렬화 — 소스 YAML을 이 형식으로 컴파일해야 실제 엔진이 로드한다.", {
    x: 0.5, y: 0.93, w: 9, h: 0.28,
    fontSize: 11, color: C.gray, italic: true, margin: 0
  });

  // ── 좌측: 최상위 구조 + 직렬화 규칙 ──
  s.addText("최상위 구조", {
    x: 0.4, y: 1.28, w: 4.6, h: 0.26,
    fontSize: 11, bold: true, color: C.textMain, margin: 0
  });
  codeBox(s,
    `{ "unitGlobal": { ... },\n  "units": [ { 엔트리 }, ... ] }\n\n{ "itemGlobal": { ... },\n  "items": [ { 엔트리 }, ... ] }`,
    0.4, 1.55, 4.6, 0.95, 9.5
  );

  s.addText("직렬화 5대 규칙", {
    x: 0.4, y: 2.58, w: 4.6, h: 0.26,
    fontSize: 11, bold: true, color: C.textMain, margin: 0
  });

  const rules = [
    { icon: "①", title: "int64 → 문자열", desc: 'count: "1000"  /  requiredExps: ["30","100"]' },
    { icon: "②", title: "enum 기본값(0) → 필드 생략", desc: 'type=Hp(0) → {"value":[120.0]}  (type 키 없음)' },
    { icon: "③", title: "enum 표기 혼합 ★주의", desc: "문자열: UnitStatType, ResourceUnit.Type\n정수: DamageCoefficient.armorType" },
    { icon: "④", title: "float .0 유지", desc: "120 → 120.0  (정수처럼 보여도 float)" },
    { icon: "⑤", title: "기본값(0/false/'') 전반 생략", desc: "proto 기본값은 JSON 출력에서 제거됨" },
  ];

  rules.forEach((r, i) => {
    const y = 2.88 + i * 0.5;
    s.addShape(pres.shapes.RECTANGLE, {
      x: 0.4, y, w: 4.6, h: 0.44,
      fill: { color: i % 2 === 0 ? "EBF5FB" : C.white },
      line: { color: "BDC3C7" }
    });
    s.addText(r.icon, {
      x: 0.45, y, w: 0.38, h: 0.44,
      fontSize: 11, bold: true, color: C.blue, align: "center", valign: "middle", margin: 0
    });
    s.addText(r.title, {
      x: 0.85, y: y + 0.04, w: 4.1, h: 0.18,
      fontSize: 8.5, bold: true, color: C.textMain, margin: 0
    });
    s.addText(r.desc, {
      x: 0.85, y: y + 0.22, w: 4.1, h: 0.18,
      fontSize: 7.5, color: C.textSub, margin: 0
    });
  });

  // ── 우측: 실제 컴파일 결과 비교 ──
  s.addText("실제 컴파일 결과  (slime_green)", {
    x: 5.2, y: 1.28, w: 4.6, h: 0.26,
    fontSize: 11, bold: true, color: C.textMain, margin: 0
  });

  // 소스 YAML
  s.addText("소스 (unit.yaml)", {
    x: 5.2, y: 1.56, w: 4.6, h: 0.22,
    fontSize: 9, bold: true, color: "27AE60", margin: 0
  });
  codeBox(s,
    `id: 110201\nname: "초록 슬라임"\ntype: Elite\ntags: [Monster]\naddStats:\n  - { type: Hp, value: [120.0] }\n  - { type: Attack, value: [12.0] }`,
    5.2, 1.78, 4.6, 1.3, 8.5
  );

  // 화살표
  s.addText("↓  idlez_compile.py", {
    x: 5.2, y: 3.1, w: 4.6, h: 0.28,
    fontSize: 9.5, bold: true, color: C.blue, align: "center", margin: 0
  });

  // 컴파일 결과 JSON
  s.addText("컴파일 결과 (Units.json)", {
    x: 5.2, y: 3.4, w: 4.6, h: 0.22,
    fontSize: 9, bold: true, color: C.red, margin: 0
  });
  codeBox(s,
    `{\n  "id": 110201,\n  "name": "초록 슬라임",\n  "type": "Elite",\n  "tags": ["Monster"],\n  "addStats": [\n    { "value": [120.0, 134.4, 150.5,\n               168.6, ...200레벨까지] },\n    { "type": "Attack",\n      "value": [12.0, 13.3, 14.8, ...] }\n  ]\n}`,
    5.2, 3.63, 4.6, 1.65, 8
  );

  s.addText("※ type=Hp(enum 0)는 직렬화 시 키 생략 | value[]는 성장식이 레벨 200까지 자동 생성", {
    x: 0.4, y: 5.38, w: 9.2, h: 0.28,
    fontSize: 8.5, color: C.gray, italic: true, align: "center", margin: 0
  });

  slideNum(s, 7);
}


// ═══════════════════════════════════════
// 슬라이드 8 — 스탯 시스템 소개
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.offWhite };
  accentBar(s, C.green);
  slideTitle(s, "스탯 시스템  —  76종 UnitStatType");

  s.addText("출처: idlez-client  Commons/Types/Units/UnitStatType.proto (enum 0~75, Count=76)", {
    x: 0.5, y: 0.93, w: 9, h: 0.26,
    fontSize: 10.5, color: C.gray, italic: true, margin: 0
  });

  // ── 상단: 3채널 설명 ──
  const channels = [
    { label: "Flat  (정수/실수 가산)", ex: "Hp, Attack, Defense, MoveSpeed", color: "27AE60",
      desc: "직접 더함. 기반 수치 제공." },
    { label: "XxxPercent  (% 가산)", ex: "HpPercent, AttackPercent, CriticalPercent", color: "2980B9",
      desc: "flat 합산 후 × (1 + Σ%/100)" },
    { label: "GameplayXxx  (보드 한정)", ex: "GameplayAttackPercent, GameplayCriticalPercent", color: "9B59B6",
      desc: "전투 보드 안에서만 적용되는 별도 채널" },
  ];

  channels.forEach((ch, i) => {
    const x = 0.35 + i * 3.15;
    s.addShape(pres.shapes.RECTANGLE, {
      x, y: 1.25, w: 3.0, h: 1.0,
      fill: { color: ch.color, transparency: 88 }, line: { color: ch.color, width: 2 }
    });
    s.addShape(pres.shapes.RECTANGLE, {
      x, y: 1.25, w: 3.0, h: 0.28,
      fill: { color: ch.color, transparency: 20 }, line: { color: ch.color }
    });
    s.addText(ch.label, {
      x: x + 0.1, y: 1.25, w: 2.8, h: 0.28,
      fontSize: 9, bold: true, color: C.white, valign: "middle", margin: 0
    });
    s.addText(ch.ex, {
      x: x + 0.1, y: 1.57, w: 2.8, h: 0.3,
      fontSize: 8, color: ch.color, margin: 0
    });
    s.addText(ch.desc, {
      x: x + 0.1, y: 1.87, w: 2.8, h: 0.32,
      fontSize: 8, color: C.textSub, italic: true, margin: 0
    });
  });

  // 합산 모델
  s.addShape(pres.shapes.RECTANGLE, {
    x: 0.35, y: 2.38, w: 9.3, h: 0.36,
    fill: { color: "FFF3CD" }, line: { color: "F39C12" }
  });
  s.addText("합산 모델:  최종값  =  (Flat 합)  ×  (1 + Percent 합 / 100)  →  전투 보드에서 Gameplay* 추가 적용", {
    x: 0.5, y: 2.38, w: 9.1, h: 0.36,
    fontSize: 10.5, bold: true, color: "856404", valign: "middle", align: "center", margin: 0
  });

  // ── AddUnitStat proto ──
  s.addText("AddUnitStat 구조  —  value[]가 레벨 배열", {
    x: 0.35, y: 2.84, w: 4.5, h: 0.26,
    fontSize: 10.5, bold: true, color: C.textMain, margin: 0
  });
  codeBox(s,
    `// proto 정의\nmessage AddUnitStat {\n  UnitStatType type  = 1;\n  repeated float value = 2;\n  // value[level-1] 로 레벨별 값 조회\n  // 길이 1이면 상수 (모든 레벨 동일)\n}`,
    0.35, 3.1, 4.5, 1.35, 9
  );

  // ── idlez profile 사용 스탯 ──
  s.addText("idlez 프로필 — 18개 활성 스탯", {
    x: 5.1, y: 2.84, w: 4.6, h: 0.26,
    fontSize: 10.5, bold: true, color: C.textMain, margin: 0
  });

  const statGroups = [
    { group: "자원/생존", stats: ["Hp", "HpPercent"], color: "E74C3C" },
    { group: "공격/방어", stats: ["Attack", "AttackPercent", "GameplayAttackPercent", "Defense", "DefensePercent"], color: "E67E22" },
    { group: "치명타", stats: ["CriticalPercent", "CriticalDamagePercent"], color: "F39C12" },
    { group: "속도/쿨다운", stats: ["AttackSpeed", "AttackSpeedPercent", "MoveSpeed", "CooldownPercent"], color: "27AE60" },
    { group: "경제/유틸", stats: ["ExpPercent", "ItemDropPercent", "Luck", "MonsterDamageEfficiencyPercent", "BossDamageEfficiencyPercent"], color: "2980B9" },
  ];

  let sy = 3.1;
  statGroups.forEach((g) => {
    const rowH = 0.26;
    s.addShape(pres.shapes.RECTANGLE, {
      x: 5.1, y: sy, w: 4.6, h: rowH,
      fill: { color: g.color, transparency: 88 }, line: { color: g.color }
    });
    s.addText(g.group, {
      x: 5.15, y: sy, w: 1.1, h: rowH,
      fontSize: 8, bold: true, color: g.color, valign: "middle", margin: 0
    });
    s.addText(g.stats.join("  ·  "), {
      x: 6.3, y: sy, w: 3.35, h: rowH,
      fontSize: 7.5, color: C.textSub, valign: "middle", margin: 0
    });
    sy += rowH + 0.06;
  });

  s.addText("※ 76종 중 게임 프로필에 선언한 것만 사용 — 검증기가 미선언 스탯 사용 시 오류", {
    x: 5.1, y: sy + 0.05, w: 4.6, h: 0.28,
    fontSize: 8, color: C.gray, italic: true, margin: 0
  });

  // 보조 채널
  s.addText("보조 스탯 채널 (상성)", {
    x: 0.35, y: 4.5, w: 4.5, h: 0.24,
    fontSize: 10, bold: true, color: C.textMain, margin: 0
  });
  const auxStats = [
    "ArmorType / ArmorTypeStat  —  방어 타입 상성",
    "DamageType / DamageTypeStat  —  피해 타입 상성",
    "ItemGroupStat · SlotStat · BuffGroupStat · SkillGroupStat",
  ];
  auxStats.forEach((a, i) => {
    s.addText("•  " + a, {
      x: 0.5, y: 4.76 + i * 0.24, w: 4.3, h: 0.22,
      fontSize: 8.5, color: C.textSub, margin: 0
    });
  });

  slideNum(s, 8);
}


// ═══════════════════════════════════════
// 슬라이드 9 — 7단계 파이프라인
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.offWhite };
  accentBar(s, C.blue);
  slideTitle(s, "AI 단독에는 없는 것 — 파이프라인");

  const steps = ["① 기획", "② 생성", "③ 바인딩", "④ 검증", "⑤ 컴파일", "⑥ 배포", "⑦ 리뷰"];
  const colors = ["6C757D","3498DB","9B59B6","E74C3C","27AE60","2980B9","F39C12"];

  steps.forEach((st, i) => {
    const x = 0.25 + i * 1.36;
    s.addShape(pres.shapes.RECTANGLE, {
      x, y: 1.3, w: 1.15, h: 0.85,
      fill: { color: colors[i] },
      line: { color: colors[i] }
    });
    s.addText(st, {
      x, y: 1.3, w: 1.15, h: 0.85,
      fontSize: 10, bold: true, color: C.white,
      align: "center", valign: "middle", margin: 0
    });

    if (i < steps.length - 1) {
      s.addText("→", {
        x: x + 1.15, y: 1.42, w: 0.21, h: 0.6,
        fontSize: 16, color: C.gray, align: "center", valign: "middle", margin: 0
      });
    }
  });

  // 피드백 루프 표시
  s.addShape(pres.shapes.RECTANGLE, {
    x: 3.0, y: 2.35, w: 1.5, h: 0.03,
    fill: { color: C.red }, line: { color: C.red }
  });
  s.addText("오류 시 재작업", {
    x: 2.8, y: 2.42, w: 1.9, h: 0.3,
    fontSize: 9, color: C.red, italic: true, align: "center", margin: 0
  });

  // AI 단독 vs Harness
  const comparison = [
    { label: "AI 단독", color: C.red, text: "생성 후 끝. 검증·컴파일·배포 = 전부 수작업" },
    { label: "Harness", color: C.green, text: "각 단계 자동화 + 게이트로 품질 보증. 오류 즉시 피드백" },
  ];
  comparison.forEach((c, i) => {
    const y = 2.9 + i * 0.9;
    s.addShape(pres.shapes.RECTANGLE, {
      x: 0.5, y, w: 9, h: 0.75,
      fill: { color: i === 0 ? "FFF5F5" : "F0FFF4" },
      line: { color: i === 0 ? "FFD0D0" : "A8E6C0" }
    });
    s.addShape(pres.shapes.RECTANGLE, {
      x: 0.5, y, w: 1.2, h: 0.75,
      fill: { color: c.color }, line: { color: c.color }
    });
    s.addText(c.label, {
      x: 0.5, y, w: 1.2, h: 0.75,
      fontSize: 11, bold: true, color: C.white,
      align: "center", valign: "middle", margin: 0
    });
    s.addText(c.text, {
      x: 1.85, y: y + 0.08, w: 7.5, h: 0.6,
      fontSize: 12, color: C.textMain, valign: "middle", margin: 0
    });
  });
  slideNum(s, 9);
}


// ═══════════════════════════════════════
// 슬라이드 6 — /gen-unit 산출 파일 트리
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.white };
  accentBar(s, C.green);
  slideTitle(s, "/gen-unit — 유닛 1개가 이렇게 완성된다");

  commandBox(s, 'gen-unit idlez "초록 슬라임, 체력 120, 공격력 12, 메도우 맵 등장"', 0.4, 0.98, 9.2);

  // 산출 파일 트리
  const tree = `content/idlez/
├── units/
│   ├── slime_green.unit.yaml        ← 유닛 정의 (스탯·타입·태그·참조)
│   └── slime_green.behavior.yaml   ← 행동 로직 (이벤트→액션)
├── growth/
│   └── slime-stat-growth.growth.md  ← 성장식 (레벨 1~200 자동 계산)
└── rewards/
    └── meadow_slime_drops.reward.yaml ← 드롭 테이블 (골드·재료·천장)`;

  codeBox(s, tree, 0.4, 1.55, 5.9, 2.5, 10);

  // 오른쪽 설명 카드들
  const cards = [
    { title: "✅ 스키마 준수", body: "engine-contract 기반\n자동 검증 통과" },
    { title: "✅ 참조 연결", body: "behavior↔unit\nreward↔unit 자동 바인딩" },
    { title: "✅ 성장식 200레벨", body: "수식으로 배열 자동 생성\n밸런스 조정 = 파라미터만" },
  ];
  cards.forEach((c, i) => {
    const y = 1.55 + i * 0.9;
    s.addShape(pres.shapes.RECTANGLE, {
      x: 6.5, y, w: 3.1, h: 0.78,
      fill: { color: "F0FFF4" }, line: { color: "A8E6C0", width: 1 }
    });
    s.addText(c.title, {
      x: 6.65, y: y + 0.06, w: 2.8, h: 0.3,
      fontSize: 11, bold: true, color: C.green, margin: 0
    });
    s.addText(c.body, {
      x: 6.65, y: y + 0.38, w: 2.8, h: 0.35,
      fontSize: 10, color: C.textSub, margin: 0
    });
  });

  // AI 단독 대비
  s.addShape(pres.shapes.RECTANGLE, {
    x: 0.4, y: 4.22, w: 9.2, h: 0.55,
    fill: { color: "FFF5F5" }, line: { color: "FFD0D0" }
  });
  s.addText("AI 단독이라면:  파일 없음. JSON 덩어리 1개. 검증 없음. 성장식은 숫자 200개 직접 입력.", {
    x: 0.55, y: 4.3, w: 9.0, h: 0.38,
    fontSize: 11, color: C.red, valign: "middle", margin: 0
  });
  s.addShape(pres.shapes.RECTANGLE, {
    x: 0.4, y: 4.82, w: 9.2, h: 0.55,
    fill: { color: "F0FFF4" }, line: { color: "A8E6C0" }
  });
  s.addText("Harness:  명령 1줄 → 파일 4개 자동 생성 → 5개 검증 게이트 통과 → 컴파일 준비 완료", {
    x: 0.55, y: 4.9, w: 9.0, h: 0.38,
    fontSize: 11, color: "1B6B3A", valign: "middle", margin: 0
  });
  slideNum(s, 10);
}


// ═══════════════════════════════════════
// 슬라이드 7 — 산출 코드: unit.yaml
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.white };
  accentBar(s, C.green);
  slideTitle(s, "산출 ① 유닛 정의 — slime_green.unit.yaml");

  const code = `id: 110201
name: "초록 슬라임"
type: Elite
tags: [Monster]
armorType: NormalArmor

addStats:
  - { type: Hp,        value: [120.0] }
  - { type: Attack,    value: [12.0] }
  - { type: Defense,   value: [4.0] }
  - { type: MoveSpeed, value: [3.0] }

triggers:
  - UNIT_ONSTART_SLIMEBOUNCE

dropAddItemGroups:
  - $ref: rewards/meadow_slime_drops.reward.yaml#green_slime

prefab: "Units/Slime/slime_green.prefab"
sprite: "Units/Slime/slime_green.png"`;

  codeBox(s, code, 0.4, 1.0, 5.8, 4.4);

  // 오른쪽 주석 카드
  const notes = [
    { title: "id: 110201", body: "profile.id_ranges 에서 자동 할당\n범위 초과 시 검증 오류" },
    { title: "type: Elite", body: "닫힌 enum 값만 허용\n(engine-contract 기준)" },
    { title: "triggers", body: "behavior.yaml 이름을 대문자 SNAKE로\n자동 변환·연결" },
    { title: "$ref 참조", body: "reward.yaml 앵커 참조\n참조 무결성 자동 검증" },
  ];

  notes.forEach((n, i) => {
    const y = 1.0 + i * 1.1;
    s.addShape(pres.shapes.RECTANGLE, {
      x: 6.45, y, w: 3.2, h: 0.95,
      fill: { color: C.offWhite }, line: { color: C.border }
    });
    s.addShape(pres.shapes.RECTANGLE, {
      x: 6.45, y, w: 0.18, h: 0.95,
      fill: { color: C.green }, line: { color: C.green }
    });
    s.addText(n.title, {
      x: 6.75, y: y + 0.06, w: 2.8, h: 0.3,
      fontSize: 10.5, bold: true, color: C.green, fontFace: "Consolas", margin: 0
    });
    s.addText(n.body, {
      x: 6.75, y: y + 0.4, w: 2.8, h: 0.5,
      fontSize: 9.5, color: C.textSub, margin: 0
    });
  });
  slideNum(s, 11);
}


// ═══════════════════════════════════════
// 슬라이드 8 — 산출 코드: behavior.yaml
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.white };
  accentBar(s, C.green);
  slideTitle(s, "산출 ② 행동 로직 — slime_green.behavior.yaml");

  const code = `name: SlimeBounce
domain: unit
on:
  - event: start
    do:
      - moveRandom: {}
        # unitMethod: SetMoveRandomDestination`;

  codeBox(s, code, 0.4, 1.0, 5.8, 2.2);

  // 컴파일 결과
  s.addText("▼  컴파일 결과 (Triggers.json)", {
    x: 0.4, y: 3.35, w: 5.8, h: 0.35,
    fontSize: 11, color: C.gray, italic: true, margin: 0
  });

  const compiled = `{
  "name": "UNIT_ONSTART_SLIMEBOUNCE",
  "event": "start",
  "domain": "unit",
  "actions": [{ "type": "SetMoveRandomDestination" }]
}`;

  codeBox(s, compiled, 0.4, 3.75, 5.8, 1.6);

  // 오른쪽 핵심 포인트
  s.addShape(pres.shapes.RECTANGLE, {
    x: 6.45, y: 1.0, w: 3.2, h: 4.3,
    fill: { color: C.offWhite }, line: { color: C.border }
  });

  const points = [
    { color: C.green, title: "action-vocabulary 기반", body: "action-vocabulary.md에 정의된\n액션만 사용 가능\n→ 엔진 실행 100% 보장" },
    { color: C.red, title: "AI 단독이라면?", body: "임의 메서드명 작성\n→ 엔진이 인식 못 할 수 있음\n→ 런타임 오류" },
    { color: C.blue, title: "컴파일 자동화", body: "YAML → JSON AST 변환\n이름 규칙 자동 적용\n(DOMAIN_ONEVENT_NAME)" },
  ];

  points.forEach((p, i) => {
    const y = 1.1 + i * 1.38;
    s.addShape(pres.shapes.RECTANGLE, {
      x: 6.55, y, w: 3.0, h: 1.2,
      fill: { color: i === 1 ? "FFF5F5" : "F0FFF4" },
      line: { color: i === 1 ? "FFD0D0" : "A8E6C0" }
    });
    s.addText(p.title, {
      x: 6.65, y: y + 0.08, w: 2.8, h: 0.3,
      fontSize: 10.5, bold: true, color: p.color, margin: 0
    });
    s.addText(p.body, {
      x: 6.65, y: y + 0.42, w: 2.8, h: 0.7,
      fontSize: 9.5, color: C.textSub, margin: 0
    });
  });
  slideNum(s, 12);
}


// ═══════════════════════════════════════
// 슬라이드 9 — 산출 코드: growth.md
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.white };
  accentBar(s, C.green);
  slideTitle(s, "산출 ③ 성장식 — slime-stat-growth.growth.md");

  const code = `---
id: slime-stat-growth
bind:
  type: unit
  match: { tag: Monster }  # Monster 태그 전체 적용
levels: 1..200
---

## hp(level) — 체력
value = base * pow(growth, level - 1)

| param  | value |
|--------|-------|
| base   | 120   |
| growth | 1.12  |

## atk(level) — 공격력
value = base * pow(growth, level - 1)

| param  | value |
|--------|-------|
| base   | 12    |
| growth | 1.11  |`;

  codeBox(s, code, 0.4, 1.0, 5.5, 4.4);

  // 오른쪽 설명
  const points = [
    {
      title: "수식 기반",
      body: "200개 숫자 직접 입력 X\n수식 1줄로 전 레벨 자동 계산",
      color: C.green
    },
    {
      title: "밸런스 조정",
      body: "파라미터(base, growth)만\n수정하면 전체 레벨 반영",
      color: C.blue
    },
    {
      title: "AI 단독이라면?",
      body: "[120.0, 134.4, 150.5, 168.6,\n189.0, 211.7, ...] × 200개\n→ 직접 계산 + 오류 위험",
      color: C.red
    },
    {
      title: "컴파일 결과",
      body: "addStats[Hp].value =\n[120.0, 134.4, 150.5,...]\n(len=200, float)",
      color: C.gray
    },
  ];

  points.forEach((p, i) => {
    const y = 1.0 + i * 1.1;
    s.addShape(pres.shapes.RECTANGLE, {
      x: 6.1, y, w: 3.5, h: 0.95,
      fill: { color: p.color === C.red ? "FFF5F5" : "F8FFFE" },
      line: { color: p.color === C.red ? "FFD0D0" : C.border }
    });
    s.addShape(pres.shapes.RECTANGLE, {
      x: 6.1, y, w: 0.15, h: 0.95,
      fill: { color: p.color }, line: { color: p.color }
    });
    s.addText(p.title, {
      x: 6.35, y: y + 0.06, w: 3.1, h: 0.28,
      fontSize: 11, bold: true, color: p.color, margin: 0
    });
    s.addText(p.body, {
      x: 6.35, y: y + 0.38, w: 3.1, h: 0.5,
      fontSize: 9.5, color: C.textSub, fontFace: "Consolas", margin: 0
    });
  });
  slideNum(s, 13);
}


// ═══════════════════════════════════════
// 슬라이드 10 — 산출 코드: reward.yaml
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.white };
  accentBar(s, C.green);
  slideTitle(s, "산출 ④ 드롭 테이블 — meadow_slime_drops.reward.yaml");

  const code = `green_slime:
  # 항상 주는 골드 (100%)
  - shouldAddAll: true
    probPercent: 100
    addItems:
      - { itemDataId: 5, minCount: 8,
          maxCount: 15, isCore: true }  # 골드
      - { itemDataId: 6, count: 5 }    # 경험치

  # 확률 드롭 (35%)
  - shouldAddAll: false
    probPercent: 35
    addItems:
      - { itemDataId: 200101, count: 1,
          weight: 70, group: 1 }       # 일반 재료
      - { itemDataId: 200102, count: 1,
          weight: 25, group: 1 }       # 고급 재료
      - { itemDataId: 200103, count: 1,
          weight: 5, pityGroup: 10 }   # 희귀(천장10)`;

  codeBox(s, code, 0.4, 1.0, 5.5, 4.4);

  // 오른쪽: 검증기 자동 계산
  s.addShape(pres.shapes.RECTANGLE, {
    x: 6.1, y: 1.0, w: 3.5, h: 4.35,
    fill: { color: C.offWhite }, line: { color: C.border }
  });
  s.addText("검증기 자동 계산", {
    x: 6.2, y: 1.1, w: 3.3, h: 0.38,
    fontSize: 12, bold: true, color: C.blue, margin: 0
  });

  const calcs = [
    "기대 골드/처치\n= (8+15)/2 = 11.5",
    "희귀 기대 확률\n= 0.35 × 5% = 1.75%",
    "천장 보장\npityGroup=10\n약 57처치마다 희귀 보장",
    "itemDataId 무결성\n200101, 200102, 200103\n실재 Item.id 자동 검증",
  ];

  calcs.forEach((c, i) => {
    s.addShape(pres.shapes.RECTANGLE, {
      x: 6.2, y: 1.55 + i * 0.92, w: 3.2, h: 0.8,
      fill: { color: C.white }, line: { color: "C8E6FF" }
    });
    s.addText(c, {
      x: 6.3, y: 1.62 + i * 0.92, w: 3.0, h: 0.66,
      fontSize: 10, color: C.textMain, valign: "middle", margin: 0
    });
  });
  slideNum(s, 14);
}


// ═══════════════════════════════════════
// 슬라이드 11 — /gen-map 산출
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.white };
  accentBar(s, C.blue);
  slideTitle(s, "/gen-map — 맵/던전이 이렇게 완성된다");

  commandBox(s, 'gen-map idlez "메도우 초원 1스테이지, 3웨이브, 슬라임 군단, 보스 등장"', 0.4, 0.98, 9.2);

  const code = `id: 500101
name: "초원 1"
type: Dungeon
tags: [ContainPlayerInventory]

boardConstants:
  levelUpChoiceCount: 3

triggers:
  - MAP_ONSTART_MEADOW1WAVE1   # 웨이브1: 일반 슬라임
  - MAP_ONSTART_MEADOW1WAVE2   # 웨이브2: 슬라임 밀집
  - MAP_ONSTART_MEADOW1WAVE3   # 웨이브3: 슬라임 보스

clearAddItemGroups:
  - shouldAddAll: true
    probPercent: 100
    addItems:
      - { itemDataId: 5, minCount: 100, maxCount: 200 }  # 골드
  - shouldAddAll: false
    probPercent: 25
    addItems:
      - { itemDataId: 200103, count: 1, pityGroup: 8 }  # 희귀(천장8)

prefab: "Maps/Meadow/meadow_1.prefab"`;

  codeBox(s, code, 0.4, 1.55, 5.9, 3.7);

  // 오른쪽 메타 정보
  const metas = [
    { label: "산출 파일", val: "meadow_1.map.yaml\nmeadow_1.behavior.yaml" },
    { label: "웨이브 로직", val: "behavior.yaml 에 분리\n(웨이브별 spawnUnit 액션)" },
    { label: "검증 항목", val: "Unit.id 110201, 110501\n실재 여부 자동 확인" },
  ];
  metas.forEach((m, i) => {
    const y = 1.55 + i * 1.25;
    s.addShape(pres.shapes.RECTANGLE, {
      x: 6.5, y, w: 3.1, h: 1.05,
      fill: { color: C.offWhite }, line: { color: C.border }
    });
    s.addText(m.label, {
      x: 6.65, y: y + 0.08, w: 2.8, h: 0.3,
      fontSize: 11, bold: true, color: C.blue, margin: 0
    });
    s.addText(m.val, {
      x: 6.65, y: y + 0.42, w: 2.8, h: 0.55,
      fontSize: 10, color: C.textSub, margin: 0
    });
  });
  slideNum(s, 15);
}


// ═══════════════════════════════════════
// 슬라이드 12 — /gen-skill 산출
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.white };
  accentBar(s, C.blue);
  slideTitle(s, "/gen-skill — 스킬이 이렇게 완성된다");

  commandBox(s, 'gen-skill idlez "베기 스킬, Pierce 타입, 쿨다운 1.5초, 120% 데미지"', 0.4, 0.98, 9.2);

  const code = `id: 300101
name: "베기"
damageType: Pierce       # DamageType enum
cooldown: 1.5
priority: 1

timelines:
  - { time: 0.0,
      playFx: { prefab: "FXPrefabs/VFX_Slash.prefab" } }
  - time: 0.1
    hit:
      maxHit: 1
      addDamage: { damagePercent: [120.0] }
  - { time: 0.4, destroy: {} }`;

  codeBox(s, code, 0.4, 1.55, 5.6, 3.2);

  // 타임라인 시각화
  s.addText("타임라인 (시각화):", {
    x: 0.4, y: 4.88, w: 5.6, h: 0.3,
    fontSize: 11, color: C.gray, italic: true, margin: 0
  });

  const timeline = [
    { t: "0.0s", label: "FX 재생", color: "9B59B6" },
    { t: "0.1s", label: "타격 판정 120%", color: C.red },
    { t: "0.4s", label: "destroy", color: C.gray },
  ];
  timeline.forEach((t, i) => {
    const x = 0.6 + i * 1.8;
    s.addShape(pres.shapes.RECTANGLE, {
      x, y: 5.0, w: 1.5, h: 0.45,
      fill: { color: t.color }, line: { color: t.color }
    });
    s.addText(t.t + "\n" + t.label, {
      x, y: 5.0, w: 1.5, h: 0.45,
      fontSize: 9, color: C.white, align: "center", valign: "middle", margin: 0
    });
    if (i < 2) {
      s.addText("→", {
        x: x + 1.5, y: 5.08, w: 0.3, h: 0.3,
        fontSize: 12, color: C.gray, align: "center", margin: 0
      });
    }
  });

  // 오른쪽 설명
  const pts = [
    { title: "산출 파일", body: "slash.skill.yaml (1개)", color: C.blue },
    { title: "timelines", body: "시점별 액션 배열\nplayFx/hit/destroy 등\nengine-contract 기반", color: C.blue },
    { title: "damagePercent", body: "[120.0] = 레벨별 배열\n강화 시 economy-balancer가\n식으로 조정", color: C.green },
  ];
  pts.forEach((p, i) => {
    const y = 1.55 + i * 1.25;
    s.addShape(pres.shapes.RECTANGLE, {
      x: 6.2, y, w: 3.4, h: 1.05,
      fill: { color: C.offWhite }, line: { color: C.border }
    });
    s.addShape(pres.shapes.RECTANGLE, {
      x: 6.2, y, w: 0.15, h: 1.05,
      fill: { color: p.color }, line: { color: p.color }
    });
    s.addText(p.title, {
      x: 6.45, y: y + 0.08, w: 3.0, h: 0.3,
      fontSize: 11, bold: true, color: p.color, margin: 0
    });
    s.addText(p.body, {
      x: 6.45, y: y + 0.42, w: 3.0, h: 0.55,
      fontSize: 9.5, color: C.textSub, margin: 0
    });
  });
  slideNum(s, 16);
}


// ═══════════════════════════════════════
// 슬라이드 13 — /gen-trigger 산출
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.white };
  accentBar(s, C.orange);
  slideTitle(s, "/gen-trigger — 유닛 AI 행동이 이렇게 완성된다");

  commandBox(s, 'gen-trigger idlez "슬라임 보스, HP 20% 이하일 때 슬라임 2마리 소환"', 0.4, 0.98, 9.2);

  const code = `name: SlimeBossSplit
domain: unit
on:
  - event: hpBelow
    params: { ratio: 0.2 }    # HP 20% 이하
    once: true                 # 한 번만 발동
    do:
      - spawnUnit:
          id: 110201            # 초록 슬라임
          count: 2
          position: near
      - playFx:
          prefab: "FXPrefabs/VFX_Split.prefab"`;

  codeBox(s, code, 0.4, 1.55, 5.6, 3.2);

  // 컴파일 이름
  s.addShape(pres.shapes.RECTANGLE, {
    x: 0.4, y: 4.88, w: 5.6, h: 0.5,
    fill: { color: "1A1A2E" }, line: { color: "333355" }
  });
  s.addText([
    { text: "컴파일 이름: ", options: { color: C.gray } },
    { text: "UNIT_ONHPBELOW_SLIMEBOSSSPLIT", options: { color: "58A6FF", bold: true } }
  ], {
    x: 0.55, y: 4.95, w: 5.3, h: 0.35,
    fontSize: 11, fontFace: "Consolas", valign: "middle", margin: 0
  });

  // 오른쪽 핵심
  const pts = [
    {
      title: "action-vocabulary 필수",
      body: "hpBelow, spawnUnit, playFx...\n어휘집에 없는 액션 사용 시\n→ 검증 오류 즉시 반환",
      color: C.orange,
      bg: "FFFBF0"
    },
    {
      title: "AI 단독이라면?",
      body: "임의 조건·메서드명\n→ 엔진 미지원 가능성\n→ 런타임 크래시",
      color: C.red,
      bg: "FFF5F5"
    },
    {
      title: "once: true",
      body: "이벤트 1회 발동 보장\n중복 발동 방지 로직\n자동 처리",
      color: C.green,
      bg: "F0FFF4"
    },
  ];
  pts.forEach((p, i) => {
    const y = 1.55 + i * 1.15;
    s.addShape(pres.shapes.RECTANGLE, {
      x: 6.2, y, w: 3.4, h: 1.0,
      fill: { color: p.bg }, line: { color: p.color, transparency: 40 }
    });
    s.addText(p.title, {
      x: 6.35, y: y + 0.08, w: 3.1, h: 0.3,
      fontSize: 11, bold: true, color: p.color, margin: 0
    });
    s.addText(p.body, {
      x: 6.35, y: y + 0.42, w: 3.1, h: 0.52,
      fontSize: 9.5, color: C.textSub, margin: 0
    });
  });
  slideNum(s, 17);
}


// ═══════════════════════════════════════
// 슬라이드 14 — /balance-review 산출
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.white };
  accentBar(s, C.blue);
  slideTitle(s, "/balance-review — 밸런스 리포트가 이렇게 나온다");

  commandBox(s, 'balance-review idlez slime_green', 0.4, 0.98, 9.2);

  const report = `=== 밸런스 리뷰: slime_green (idlez) ===

[성장곡선]
Lv1  : HP=120,    ATK=12,    DEF=4
Lv10 : HP=331,    ATK=32,    DEF=17
Lv50 : HP=2,893,  ATK=264,   DEF=76
Lv100: HP=83,522, ATK=6,959, DEF=149

[스테이지 적합도]
Lv1~5  : ✓ 적합  (전투력 P/R = 1.0~1.2)
Lv10   : ⚠ 경계  (P/R = 0.85) ← "벽" 발생 구간
권고   : growth.atk base 12→15 상향 조정

[드롭 경제]
골드 기대치: 11.5/처치
희귀 아이템: 1.75%/처치
천장(pityGroup=10): 약 57처치마다 보장`;

  codeBox(s, report, 0.4, 1.55, 5.8, 3.75);

  // 오른쪽: AI 단독 대비
  s.addShape(pres.shapes.RECTANGLE, {
    x: 6.4, y: 1.55, w: 3.2, h: 3.75,
    fill: { color: C.offWhite }, line: { color: C.border }
  });
  s.addText("AI 단독이라면...", {
    x: 6.55, y: 1.65, w: 2.9, h: 0.35,
    fontSize: 12, bold: true, color: C.red, margin: 0
  });
  const items = [
    "성장식 수렴 여부 모름",
    "밸런스 '벽' 위치 알 수 없음",
    "드롭 기대치 직접 계산 필요",
    "천장 시스템 별도 검증 필요",
  ];
  items.forEach((item, i) => {
    s.addText("✗  " + item, {
      x: 6.55, y: 2.1 + i * 0.5, w: 2.9, h: 0.4,
      fontSize: 10.5, color: C.red, margin: 0
    });
  });

  s.addShape(pres.shapes.RECTANGLE, {
    x: 6.55, y: 4.18, w: 2.9, h: 0.05,
    fill: { color: C.border }, line: { color: C.border }
  });
  s.addText("Harness: 모두 자동 계산·보고", {
    x: 6.55, y: 4.3, w: 2.9, h: 0.35,
    fontSize: 11, bold: true, color: C.green, margin: 0
  });
  slideNum(s, 18);
}


// ═══════════════════════════════════════
// 슬라이드 15 — YAML → 엔진 JSON 컴파일
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.offWhite };
  accentBar(s, C.green);
  slideTitle(s, "소스 → 컴파일 → 엔진 JSON");

  s.addText("AI 단독: 엔진 JSON 직접 편집 → 버전 추적 불가, AI 재생성 불가", {
    x: 0.5, y: 0.92, w: 9, h: 0.3,
    fontSize: 11, italic: true, color: C.red, margin: 0
  });

  // 왼쪽: 소스
  s.addText("소스 (사람·AI가 작성)", {
    x: 0.4, y: 1.3, w: 3.8, h: 0.35,
    fontSize: 12, bold: true, color: C.green, margin: 0
  });
  const yamlSrc = `addStats:
  - { type: Hp,
      value: [120.0] }

성장식:
  formula:
    base * pow(growth, level-1)
  base: 120
  growth: 1.12`;
  codeBox(s, yamlSrc, 0.4, 1.7, 3.8, 2.5);

  // 가운데 화살표
  s.addShape(pres.shapes.RECTANGLE, {
    x: 4.35, y: 2.7, w: 1.3, h: 0.08,
    fill: { color: C.blue }, line: { color: C.blue }
  });
  s.addText("▶", {
    x: 4.5, y: 2.5, w: 1.0, h: 0.4,
    fontSize: 20, color: C.blue, align: "center", margin: 0
  });
  s.addShape(pres.shapes.RECTANGLE, {
    x: 4.45, y: 3.0, w: 1.1, h: 0.7,
    fill: { color: "E8F4FD" }, line: { color: "B8D4E8" }
  });
  s.addText("idlez_\ncompile.py", {
    x: 4.45, y: 3.05, w: 1.1, h: 0.6,
    fontSize: 9, color: C.blue, align: "center", valign: "middle", margin: 0
  });

  // 오른쪽: JSON 결과
  s.addText("엔진 JSON (컴파일 결과)", {
    x: 5.8, y: 1.3, w: 3.9, h: 0.35,
    fontSize: 12, bold: true, color: C.blue, margin: 0
  });
  const jsonOut = `{
  "addStats": [
    {
      "value": [
        "120.0",
        "134.4",
        "150.5",
        "168.6",
        ...
      ]
    }
  ]
}`;
  codeBox(s, jsonOut, 5.8, 1.7, 3.8, 2.5);

  // 하단: 변환 포인트들
  const convPoints = [
    { label: "성장식 → 배열", desc: "수식으로 레벨200 배열 자동 생성" },
    { label: "behavior → AST", desc: "YAML 트리거 → Triggers.json" },
    { label: "enum0 생략", desc: "type: Hp (enum0) → JSON에서 생략" },
  ];
  convPoints.forEach((c, i) => {
    const x = 0.4 + i * 3.15;
    s.addShape(pres.shapes.RECTANGLE, {
      x, y: 4.35, w: 2.9, h: 0.75,
      fill: { color: "EBF5FB" }, line: { color: "AED6F1" }
    });
    s.addText(c.label, {
      x: x + 0.1, y: 4.42, w: 2.7, h: 0.28,
      fontSize: 11, bold: true, color: C.blue, margin: 0
    });
    s.addText(c.desc, {
      x: x + 0.1, y: 4.72, w: 2.7, h: 0.3,
      fontSize: 9.5, color: C.textSub, margin: 0
    });
  });
  slideNum(s, 19);
}


// ═══════════════════════════════════════
// 슬라이드 16 — 5개 검증 게이트
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.offWhite };
  accentBar(s, C.red);
  slideTitle(s, "AI 단독에는 없는 것 — 5개 자동 검증 게이트");

  // 입력 화살표
  s.addShape(pres.shapes.RECTANGLE, {
    x: 0.3, y: 2.5, w: 1.2, h: 0.08,
    fill: { color: C.gray }, line: { color: C.gray }
  });
  s.addText("생성된\nYAML", {
    x: 0.2, y: 1.85, w: 1.4, h: 0.55,
    fontSize: 11, color: C.textMain, align: "center", bold: true, margin: 0
  });

  const gates = [
    { num: "①", label: "스키마 검증", desc: "필드·타입·enum 준수" },
    { num: "②", label: "참조 무결성", desc: "댕글링 참조 0개" },
    { num: "③", label: "스탯 가드레일", desc: "profile 범위 내" },
    { num: "④", label: "밸런스 검증", desc: "성장식 수렴 확인" },
    { num: "⑤", label: "행동어휘 검증", desc: "action-vocabulary 준수" },
  ];

  gates.forEach((g, i) => {
    const y = 1.4 + i * 0.75;
    // 게이트 박스
    s.addShape(pres.shapes.RECTANGLE, {
      x: 1.6, y, w: 4.8, h: 0.62,
      fill: { color: C.white }, line: { color: C.green, width: 1.5 }
    });
    s.addShape(pres.shapes.RECTANGLE, {
      x: 1.6, y, w: 0.5, h: 0.62,
      fill: { color: C.green }, line: { color: C.green }
    });
    s.addText(g.num, {
      x: 1.6, y, w: 0.5, h: 0.62,
      fontSize: 14, bold: true, color: C.white,
      align: "center", valign: "middle", margin: 0
    });
    s.addText(g.label, {
      x: 2.2, y: y + 0.06, w: 2.5, h: 0.28,
      fontSize: 12, bold: true, color: C.textMain, margin: 0
    });
    s.addText(g.desc, {
      x: 2.2, y: y + 0.34, w: 2.5, h: 0.24,
      fontSize: 10, color: C.gray, margin: 0
    });
    // PASS 배지
    s.addShape(pres.shapes.RECTANGLE, {
      x: 4.8, y: y + 0.12, w: 1.4, h: 0.38,
      fill: { color: C.green }, line: { color: C.green }
    });
    s.addText("✅ PASS", {
      x: 4.8, y: y + 0.12, w: 1.4, h: 0.38,
      fontSize: 11, bold: true, color: C.white,
      align: "center", valign: "middle", margin: 0
    });
    // 또는 FAIL 경로
    if (i === 0) {
      s.addShape(pres.shapes.RECTANGLE, {
        x: 6.3, y: y + 0.12, w: 1.4, h: 0.38,
        fill: { color: C.red }, line: { color: C.red }
      });
      s.addText("❌ FAIL", {
        x: 6.3, y: y + 0.12, w: 1.4, h: 0.38,
        fontSize: 11, bold: true, color: C.white,
        align: "center", valign: "middle", margin: 0
      });
      s.addText("→ 담당 에이전트로\n   자동 반려", {
        x: 7.8, y: y + 0.06, w: 1.8, h: 0.5,
        fontSize: 9.5, color: C.red, margin: 0
      });
    }
  });

  // 하단 결론
  s.addShape(pres.shapes.RECTANGLE, {
    x: 1.6, y: 5.1, w: 4.8, h: 0.38,
    fill: { color: "0D3B26" }, line: { color: "0D3B26" }
  });
  s.addText("→ 컴파일 준비 완료", {
    x: 1.6, y: 5.1, w: 4.8, h: 0.38,
    fontSize: 13, bold: true, color: C.white,
    align: "center", valign: "middle", margin: 0
  });

  s.addText("AI 단독: 이 과정 전부 수작업 → 엔진 실행 후 발견 → 디버깅 반복", {
    x: 6.4, y: 3.5, w: 3.3, h: 1.5,
    fontSize: 11, color: C.red, margin: 0
  });
  slideNum(s, 20);
}


// ═══════════════════════════════════════
// 슬라이드 17 — 5개 에이전트 협업
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.offWhite };
  accentBar(s, C.blue);
  slideTitle(s, "AI 단독 1개 vs 전문 에이전트 5개");

  // 왼쪽: AI 단독
  s.addShape(pres.shapes.RECTANGLE, {
    x: 0.3, y: 1.05, w: 4.3, h: 4.2,
    fill: { color: "FFF5F5" }, line: { color: "FFD0D0", width: 2 }
  });
  s.addText("AI 단독", {
    x: 0.3, y: 1.05, w: 4.3, h: 0.45,
    fontSize: 14, bold: true, color: C.red,
    align: "center", valign: "middle", margin: 0
  });
  s.addShape(pres.shapes.RECTANGLE, {
    x: 1.3, y: 1.65, w: 2.3, h: 0.75,
    fill: { color: C.red }, line: { color: C.red }
  });
  s.addText("1개 AI", {
    x: 1.3, y: 1.65, w: 2.3, h: 0.75,
    fontSize: 14, bold: true, color: C.white,
    align: "center", valign: "middle", margin: 0
  });

  const aiTasks = ["유닛 정의", "성장식", "행동 로직", "에셋", "검증"];
  aiTasks.forEach((t, i) => {
    s.addText("→  " + t, {
      x: 0.6, y: 2.55 + i * 0.48, w: 3.8, h: 0.4,
      fontSize: 11, color: C.red, margin: 0
    });
  });
  s.addText("(일관성 없음, 역할 경계 없음)", {
    x: 0.5, y: 4.85, w: 4.0, h: 0.3,
    fontSize: 10, italic: true, color: C.gray, align: "center", margin: 0
  });

  // 오른쪽: Harness
  s.addShape(pres.shapes.RECTANGLE, {
    x: 5.1, y: 1.05, w: 4.55, h: 4.2,
    fill: { color: "F0FFF4" }, line: { color: "A8E6C0", width: 2 }
  });
  s.addText("Harness", {
    x: 5.1, y: 1.05, w: 4.55, h: 0.45,
    fontSize: 14, bold: true, color: C.green,
    align: "center", valign: "middle", margin: 0
  });

  const agents = [
    { name: "content-designer",  task: "유닛·맵·스킬 정의 YAML",   color: "3498DB" },
    { name: "economy-balancer",  task: "성장식 + 경제 밸런싱",      color: "27AE60" },
    { name: "behavior-author",   task: "행동 로직 YAML",            color: "9B59B6" },
    { name: "asset-producer",    task: "에셋 키 + 레지스트리",      color: "E67E22" },
    { name: "content-reviewer",  task: "5개 게이트 검증 + 최종 승인", color: "E74C3C" },
  ];
  agents.forEach((a, i) => {
    const y = 1.6 + i * 0.72;
    s.addShape(pres.shapes.RECTANGLE, {
      x: 5.25, y, w: 4.2, h: 0.6,
      fill: { color: C.white }, line: { color: a.color }
    });
    s.addShape(pres.shapes.RECTANGLE, {
      x: 5.25, y, w: 0.15, h: 0.6,
      fill: { color: a.color }, line: { color: a.color }
    });
    s.addText(a.name, {
      x: 5.5, y: y + 0.02, w: 2.0, h: 0.28,
      fontSize: 9.5, bold: true, color: a.color, fontFace: "Consolas", margin: 0
    });
    s.addText(a.task, {
      x: 5.5, y: y + 0.32, w: 3.8, h: 0.24,
      fontSize: 9.5, color: C.textSub, margin: 0
    });
  });
  s.addText("오류 시 담당 에이전트로 자동 반려", {
    x: 5.2, y: 4.92, w: 4.3, h: 0.25,
    fontSize: 9.5, italic: true, color: C.red, align: "center", margin: 0
  });

  // 가운데 vs
  s.addText("vs", {
    x: 4.35, y: 2.7, w: 0.7, h: 0.6,
    fontSize: 22, bold: true, color: C.gray,
    align: "center", valign: "middle", margin: 0
  });
  slideNum(s, 21);
}


// ═══════════════════════════════════════
// 슬라이드 18 — 스킬 6개 전체 지도
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.offWhite };
  accentBar(s, C.green);
  slideTitle(s, "Harness/Skill — 6개 진입점 전체 지도");

  // 중앙: new-content
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, {
    x: 3.5, y: 0.95, w: 3.0, h: 0.72,
    fill: { color: C.dark }, line: { color: C.dark }, rectRadius: 0.1
  });
  s.addText("/new-content  (오케스트레이터)", {
    x: 3.5, y: 0.95, w: 3.0, h: 0.72,
    fontSize: 10.5, bold: true, color: C.white,
    align: "center", valign: "middle", margin: 0
  });

  const skills = [
    { name: "/gen-unit",      desc: "유닛 정의 + 성장식\n+ 행동 + 드롭\n(파일 4개)",  x: 0.3,  y: 2.0,  color: "27AE60" },
    { name: "/gen-map",       desc: "맵 정의\n+ 웨이브 로직\n(파일 2개)",              x: 7.4,  y: 2.0,  color: "2980B9" },
    { name: "/gen-skill",     desc: "스킬 정의\n타임라인·데미지\n(파일 1개)",          x: 0.3,  y: 3.6,  color: "9B59B6" },
    { name: "/gen-trigger",   desc: "행동 로직 YAML\n이벤트→액션\n(파일 1개)",        x: 7.4,  y: 3.6,  color: "E67E22" },
    { name: "/balance-review",desc: "밸런스 리포트\n성장곡선·드롭경제\n'벽' 위치",   x: 3.7,  y: 4.6,  color: "E74C3C" },
  ];

  skills.forEach(sk => {
    s.addShape(pres.shapes.RECTANGLE, {
      x: sk.x, y: sk.y, w: 2.4, h: 1.1,
      fill: { color: sk.color, transparency: 15 },
      line: { color: sk.color, width: 2 }
    });
    s.addText(sk.name, {
      x: sk.x + 0.05, y: sk.y + 0.06, w: 2.3, h: 0.3,
      fontSize: 11, bold: true, color: sk.color, fontFace: "Consolas", margin: 0
    });
    s.addText(sk.desc, {
      x: sk.x + 0.08, y: sk.y + 0.38, w: 2.2, h: 0.65,
      fontSize: 9.5, color: C.white, margin: 0
    });
  });

  // 연결선 (개략)
  const arrows = [
    { x1: 4.5, y1: 1.67, x2: 1.5, y2: 2.0 },
    { x1: 5.5, y1: 1.67, x2: 8.6, y2: 2.0 },
    { x1: 4.5, y1: 1.67, x2: 1.5, y2: 3.6 },
    { x1: 5.5, y1: 1.67, x2: 8.6, y2: 3.6 },
    { x1: 5.0, y1: 1.67, x2: 4.9, y2: 4.6 },
  ];
  arrows.forEach(a => {
    const w = a.x2 - a.x1;
    const h = a.y2 - a.y1;
    s.addShape(pres.shapes.LINE, {
      x: Math.min(a.x1, a.x2), y: Math.min(a.y1, a.y2),
      w: Math.abs(w), h: Math.abs(h),
      line: { color: "CCCCCC", width: 1, dashType: "dash" }
    });
  });
  slideNum(s, 22);
}


// ═══════════════════════════════════════
// 슬라이드 19 — 개발 속도 비교 차트
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.white };
  accentBar(s);
  slideTitle(s, "수치로 보는 차이 — 개발 속도");

  s.addChart(pres.charts.BAR, [
    {
      name: "AI 단독",
      labels: ["유닛 1개", "맵 1개", "스킬 1개", "성장식 조정"],
      values: [120, 90, 60, 180]
    },
    {
      name: "Harness/Skill",
      labels: ["유닛 1개", "맵 1개", "스킬 1개", "성장식 조정"],
      values: [5, 5, 3, 10]
    }
  ], {
    x: 0.4, y: 0.95, w: 5.8, h: 3.8,
    barDir: "bar",
    barGrouping: "clustered",
    chartColors: [C.red, C.green],
    chartArea: { fill: { color: C.white } },
    catAxisLabelColor: C.textSub,
    valAxisLabelColor: C.textSub,
    valGridLine: { color: C.lightGray, size: 0.5 },
    catGridLine: { style: "none" },
    showValue: true,
    dataLabelColor: C.textMain,
    showLegend: true,
    legendPos: "b",
    valAxisTitle: "소요 시간 (분)",
    showValAxisTitle: true,
  });

  // 오른쪽: 월 기준
  s.addShape(pres.shapes.RECTANGLE, {
    x: 6.4, y: 0.95, w: 3.3, h: 1.8,
    fill: { color: "FFF5F5" }, line: { color: "FFD0D0" }
  });
  s.addText("월 콘텐츠 기준 (유닛 10개+)", {
    x: 6.55, y: 1.0, w: 3.0, h: 0.35,
    fontSize: 11, bold: true, color: C.red, margin: 0
  });
  s.addText("AI 단독: 350시간", {
    x: 6.65, y: 1.4, w: 2.8, h: 0.3,
    fontSize: 13, bold: true, color: C.red, margin: 0
  });
  s.addText("Harness: 25시간", {
    x: 6.65, y: 1.75, w: 2.8, h: 0.35,
    fontSize: 16, bold: true, color: C.green, margin: 0
  });

  s.addShape(pres.shapes.RECTANGLE, {
    x: 6.4, y: 2.9, w: 3.3, h: 1.8,
    fill: { color: "F0FFF4" }, line: { color: "A8E6C0" }
  });
  s.addText("95% 단축", {
    x: 6.55, y: 2.95, w: 3.0, h: 0.6,
    fontSize: 32, bold: true, color: C.green, align: "center", margin: 0
  });
  s.addText("같은 팀이 5배 더 많은\n게임을 만들 수 있다", {
    x: 6.55, y: 3.6, w: 3.0, h: 0.9,
    fontSize: 12, color: C.textMain, align: "center", margin: 0
  });

  s.addText("단위: 분 (minutes)", {
    x: 0.4, y: 4.9, w: 5.8, h: 0.3,
    fontSize: 10, color: C.gray, italic: true, margin: 0
  });
  slideNum(s, 23);
}


// ═══════════════════════════════════════
// 슬라이드 20 — 오류율 비교
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.white };
  accentBar(s, C.green);
  slideTitle(s, "신뢰도 비교 — 오류율");

  // AI 단독 파이
  s.addChart(pres.charts.PIE, [{
    name: "AI 단독",
    labels: ["오류 (~30%)", "정상 (~70%)"],
    values: [30, 70]
  }], {
    x: 0.5, y: 1.0, w: 4.0, h: 3.5,
    chartColors: [C.red, "E8E8E8"],
    showPercent: true,
    dataLabelColor: C.textMain,
    showLegend: true,
    legendPos: "b",
    title: "AI 단독",
    showTitle: true,
    titleColor: C.red,
  });

  // Harness 파이
  s.addChart(pres.charts.PIE, [{
    name: "Harness",
    labels: ["오류 (<1%)", "정상 (>99%)"],
    values: [1, 99]
  }], {
    x: 5.2, y: 1.0, w: 4.0, h: 3.5,
    chartColors: [C.red, C.green],
    showPercent: true,
    dataLabelColor: C.textMain,
    showLegend: true,
    legendPos: "b",
    title: "Harness / Skill",
    showTitle: true,
    titleColor: C.green,
  });

  s.addText(
    "게임팀이 버그 잡는 시간  →  새 콘텐츠 만드는 시간으로",
    {
      x: 0.5, y: 4.75, w: 9, h: 0.5,
      fontSize: 16, bold: true, color: C.blue,
      align: "center", margin: 0
    }
  );
  slideNum(s, 24);
}


// ═══════════════════════════════════════
// 슬라이드 21 — 재사용성
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.offWhite };
  accentBar(s, C.blue);
  slideTitle(s, "두 번째 게임을 만들 때");

  // AI 단독
  s.addShape(pres.shapes.RECTANGLE, {
    x: 0.3, y: 1.05, w: 4.3, h: 4.3,
    fill: { color: "FFF5F5" }, line: { color: "FFD0D0", width: 2 }
  });
  s.addText("AI 단독: 새 게임 = 처음부터 다시", {
    x: 0.4, y: 1.1, w: 4.1, h: 0.42,
    fontSize: 12, bold: true, color: C.red, margin: 0
  });
  const aiItems = [
    "새 프롬프트 설계",
    "새 스키마 협의",
    "새 검증 체계",
    "새 컴파일 방법",
    "새 밸런스 가이드",
  ];
  aiItems.forEach((item, i) => {
    s.addShape(pres.shapes.RECTANGLE, {
      x: 0.5, y: 1.65 + i * 0.65, w: 3.8, h: 0.52,
      fill: { color: C.white }, line: { color: "FFD0D0" }
    });
    s.addText("✗  " + item, {
      x: 0.65, y: 1.7 + i * 0.65, w: 3.5, h: 0.42,
      fontSize: 11, color: C.red, valign: "middle", margin: 0
    });
  });
  s.addShape(pres.shapes.RECTANGLE, {
    x: 0.5, y: 4.9, w: 3.8, h: 0.38,
    fill: { color: C.red }, line: { color: C.red }
  });
  s.addText("공수: 첫 번째와 동일", {
    x: 0.5, y: 4.9, w: 3.8, h: 0.38,
    fontSize: 12, bold: true, color: C.white,
    align: "center", valign: "middle", margin: 0
  });

  // Harness
  s.addShape(pres.shapes.RECTANGLE, {
    x: 5.1, y: 1.05, w: 4.55, h: 4.3,
    fill: { color: "F0FFF4" }, line: { color: "A8E6C0", width: 2 }
  });
  s.addText("Harness: 새 게임 = 프로필만 새로", {
    x: 5.2, y: 1.1, w: 4.3, h: 0.42,
    fontSize: 12, bold: true, color: C.green, margin: 0
  });
  const harnessItems = [
    { text: "my-game2.profile.yaml  (1시간)", reuse: false },
    { text: "engine-contract  재사용", reuse: true },
    { text: "7단계 파이프라인  재사용", reuse: true },
    { text: "스킬 6개  재사용", reuse: true },
    { text: "검증 게이트  재사용", reuse: true },
  ];
  harnessItems.forEach((item, i) => {
    s.addShape(pres.shapes.RECTANGLE, {
      x: 5.25, y: 1.65 + i * 0.65, w: 4.2, h: 0.52,
      fill: { color: C.white }, line: { color: "A8E6C0" }
    });
    s.addText((item.reuse ? "♻  " : "📄  ") + item.text, {
      x: 5.4, y: 1.7 + i * 0.65, w: 3.9, h: 0.42,
      fontSize: 11, color: item.reuse ? C.green : C.blue, valign: "middle", margin: 0
    });
  });
  s.addShape(pres.shapes.RECTANGLE, {
    x: 5.25, y: 4.9, w: 4.2, h: 0.38,
    fill: { color: C.green }, line: { color: C.green }
  });
  s.addText("공수: 첫 번째의 20%", {
    x: 5.25, y: 4.9, w: 4.2, h: 0.38,
    fontSize: 12, bold: true, color: C.white,
    align: "center", valign: "middle", margin: 0
  });

  s.addText("vs", {
    x: 4.35, y: 2.8, w: 0.7, h: 0.6,
    fontSize: 22, bold: true, color: C.gray,
    align: "center", valign: "middle", margin: 0
  });
  slideNum(s, 25);
}


// ═══════════════════════════════════════
// 슬라이드 22 — 누적 효과 그래프
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.white };
  accentBar(s, C.blue);
  slideTitle(s, "게임이 많아질수록 벌어지는 차이");

  s.addChart(pres.charts.LINE, [
    {
      name: "AI 단독 (선형 증가)",
      labels: ["게임 1", "게임 2", "게임 3", "게임 4", "게임 5"],
      values: [300, 600, 900, 1200, 1500]
    },
    {
      name: "Harness/Skill (누적 감소)",
      labels: ["게임 1", "게임 2", "게임 3", "게임 4", "게임 5"],
      values: [400, 580, 700, 780, 830]
    }
  ], {
    x: 0.4, y: 0.98, w: 6.5, h: 4.3,
    chartColors: [C.red, C.green],
    lineSize: 3,
    lineSmooth: true,
    chartArea: { fill: { color: C.white } },
    catAxisLabelColor: C.textSub,
    valAxisLabelColor: C.textSub,
    valGridLine: { color: C.lightGray, size: 0.5 },
    catGridLine: { style: "none" },
    showValue: false,
    showLegend: true,
    legendPos: "b",
    valAxisTitle: "누적 공수 (시간)",
    showValAxisTitle: true,
  });

  // 오른쪽 설명
  s.addShape(pres.shapes.RECTANGLE, {
    x: 7.1, y: 0.98, w: 2.6, h: 2.1,
    fill: { color: "FFF5F5" }, line: { color: "FFD0D0" }
  });
  s.addText("AI 단독", {
    x: 7.2, y: 1.05, w: 2.4, h: 0.35,
    fontSize: 12, bold: true, color: C.red, margin: 0
  });
  s.addText("게임 추가할수록\n비용 선형 증가\n게임 5개 = 1,500h", {
    x: 7.2, y: 1.45, w: 2.4, h: 0.95,
    fontSize: 10.5, color: C.textSub, margin: 0
  });

  s.addShape(pres.shapes.RECTANGLE, {
    x: 7.1, y: 3.25, w: 2.6, h: 2.1,
    fill: { color: "F0FFF4" }, line: { color: "A8E6C0" }
  });
  s.addText("Harness", {
    x: 7.2, y: 3.32, w: 2.4, h: 0.35,
    fontSize: 12, bold: true, color: C.green, margin: 0
  });
  s.addText("게임 추가할수록\n한계비용 감소\n게임 5개 = 830h", {
    x: 7.2, y: 3.72, w: 2.4, h: 0.95,
    fontSize: 10.5, color: C.textSub, margin: 0
  });

  s.addText("교차점: 2번째 게임부터 Harness가 유리", {
    x: 0.4, y: 5.25, w: 9, h: 0.3,
    fontSize: 11, bold: true, color: C.blue, align: "center", margin: 0
  });
  slideNum(s, 26);
}


// ═══════════════════════════════════════
// 슬라이드 23 — 현재 검증 현황
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.white };
  accentBar(s, C.green);
  slideTitle(s, "이미 동작한다 — 현재 검증 현황");

  const checks = [
    { icon: "✅", title: "슬라임 샘플 검증", detail: "정의/인스턴스 분리 · 계층 구조 · 소스→JSON · 참조 무결성  →  4/4 PASS" },
    { icon: "✅", title: "컴파일 완성도", detail: "unit · item · skill · buff · map · string · achievement · audio  →  9/9 PASS" },
    { icon: "✅", title: "behavior → Triggers.json", detail: "YAML → 실제 call/postfix AST 컴파일 정상 동작" },
    { icon: "✅", title: "참조 런타임", detail: "idle-runtime.html — engine-independent 플레이어블 확인" },
  ];

  checks.forEach((c, i) => {
    const y = 1.1 + i * 1.08;
    s.addShape(pres.shapes.RECTANGLE, {
      x: 0.4, y, w: 9.2, h: 0.9,
      fill: { color: "F0FFF4" }, line: { color: "A8E6C0", width: 1.5 }
    });
    s.addText(c.icon, {
      x: 0.5, y: y + 0.1, w: 0.6, h: 0.7,
      fontSize: 22, align: "center", valign: "middle", margin: 0
    });
    s.addText(c.title, {
      x: 1.2, y: y + 0.06, w: 7.8, h: 0.3,
      fontSize: 13, bold: true, color: C.green, margin: 0
    });
    s.addText(c.detail, {
      x: 1.2, y: y + 0.42, w: 7.8, h: 0.4,
      fontSize: 11, color: C.textSub, margin: 0
    });
  });
  slideNum(s, 27);
}


// ═══════════════════════════════════════
// 슬라이드 24 — Harness의 한계
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.white };
  accentBar(s, C.orange);
  slideTitle(s, "Harness의 한계 — 솔직하게");

  // 한계
  s.addText("현재 한계", {
    x: 0.4, y: 0.98, w: 4.3, h: 0.38,
    fontSize: 14, bold: true, color: C.red, margin: 0
  });
  const limits = [
    "action-vocabulary 밖의 행동 불가\n→ 엔진 팀 작업 필요",
    "환생 / 가챠 / 장비 시스템\n아직 미구현",
    "에셋 실파일(CDN) 통합 미완성",
  ];
  limits.forEach((l, i) => {
    s.addShape(pres.shapes.RECTANGLE, {
      x: 0.4, y: 1.45 + i * 1.05, w: 4.5, h: 0.88,
      fill: { color: "FFF5F5" }, line: { color: "FFD0D0" }
    });
    s.addText("⚠  " + l, {
      x: 0.55, y: 1.52 + i * 1.05, w: 4.2, h: 0.74,
      fontSize: 11, color: C.red, valign: "middle", margin: 0
    });
  });

  // AI 단독이 유리한 곳
  s.addText("AI 단독이 여전히 유리한 영역", {
    x: 5.2, y: 0.98, w: 4.4, h: 0.38,
    fontSize: 14, bold: true, color: C.blue, margin: 0
  });
  const aiGood = [
    "아이디어 발산, 스토리텔링",
    "기획 초안, 컨셉 스케치",
    "텍스트/대사 생성",
  ];
  aiGood.forEach((a, i) => {
    s.addShape(pres.shapes.RECTANGLE, {
      x: 5.2, y: 1.45 + i * 1.05, w: 4.4, h: 0.88,
      fill: { color: "EBF5FB" }, line: { color: "AED6F1" }
    });
    s.addText("💡  " + a, {
      x: 5.35, y: 1.52 + i * 1.05, w: 4.1, h: 0.74,
      fontSize: 12, color: C.blue, valign: "middle", margin: 0
    });
  });

  // 결론: 분업
  s.addShape(pres.shapes.RECTANGLE, {
    x: 0.4, y: 4.6, w: 9.2, h: 0.75,
    fill: { color: C.dark }, line: { color: C.dark }
  });
  s.addText([
    { text: "결론: 대립이 아니라 ", options: { color: C.white } },
    { text: "분업", options: { color: "FFD700", bold: true } },
    { text: "  —  AI 단독(기획·아이디어) + Harness(생성·검증·배포)", options: { color: "AAAACC" } }
  ], {
    x: 0.5, y: 4.65, w: 9.0, h: 0.65,
    fontSize: 14, align: "center", valign: "middle", margin: 0
  });
  slideNum(s, 28);
}


// ═══════════════════════════════════════
// 슬라이드 25 — 로드맵
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.offWhite };
  accentBar(s, C.blue);
  slideTitle(s, "앞으로의 계획 — 로드맵");

  const phases = [
    { phase: "현재", time: "완성", items: ["기본 6개 스킬 ✅", "검증 파이프라인 ✅", "컴파일러 ✅", "참조 런타임 ✅"], color: C.green },
    { phase: "1개월", time: "진행 중", items: ["환생/가챠/장비 시스템", "참조 런타임 확장", "드롭 경제 고도화"], color: C.blue },
    { phase: "3개월", time: "예정", items: ["idlez-server 도입", "idlez-client (Unity) 통합", "Unity AI scene/prefab 자동 생성"], color: C.orange },
    { phase: "12개월", time: "목표", items: ["Unity AI prefab 수정 파이프라인", "자동화율 80%", "월 게임 1개 추가 체계"], color: "7B2FBE" },
  ];

  phases.forEach((p, i) => {
    const x = 0.3 + i * 2.38;
    s.addShape(pres.shapes.RECTANGLE, {
      x, y: 1.1, w: 2.15, h: 0.5,
      fill: { color: p.color }, line: { color: p.color }
    });
    s.addText(p.phase, {
      x, y: 1.1, w: 2.15, h: 0.28,
      fontSize: 14, bold: true, color: C.white,
      align: "center", valign: "middle", margin: 0
    });
    s.addText(p.time, {
      x, y: 1.38, w: 2.15, h: 0.22,
      fontSize: 10, color: C.white, align: "center", margin: 0
    });

    s.addShape(pres.shapes.RECTANGLE, {
      x, y: 1.65, w: 2.15, h: 3.55,
      fill: { color: C.white }, line: { color: p.color, transparency: 40 }
    });
    p.items.forEach((item, j) => {
      s.addText((p.phase === "현재" ? "✅  " : "•  ") + item, {
        x: x + 0.12, y: 1.78 + j * 0.82, w: 1.9, h: 0.65,
        fontSize: 10.5, color: C.textMain, valign: "top", margin: 0
      });
    });

    // 화살표
    if (i < 3) {
      s.addText("→", {
        x: x + 2.15, y: 2.6, w: 0.23, h: 0.4,
        fontSize: 14, color: C.gray, align: "center", margin: 0
      });
    }
  });

  s.addText("최종 목표: idlez-client/server + Unity AI로 완전 자동화된 게임 개발 파이프라인", {
    x: 0.4, y: 5.3, w: 9.2, h: 0.3,
    fontSize: 12, bold: true, color: C.blue, align: "center", margin: 0
  });
  slideNum(s, 29);
}


// ═══════════════════════════════════════
// 슬라이드 26 — 핵심 3줄 요약
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.dark };

  const summaries = [
    { num: "01", a: "AI는 생성한다.", b: "Harness는 검증한다.", color: C.green },
    { num: "02", a: "AI는 1회성이다.", b: "Harness는 누적된다.", color: "3498DB" },
    { num: "03", a: "AI는 자유롭다.", b: "Harness는 구조적이다.", color: C.orange },
  ];

  s.addText("왜 Harness/Skill인가", {
    x: 0.5, y: 0.2, w: 9, h: 0.6,
    fontSize: 22, bold: true, color: "8888AA", margin: 0
  });

  summaries.forEach((sm, i) => {
    const y = 1.1 + i * 1.42;
    s.addShape(pres.shapes.RECTANGLE, {
      x: 0.4, y, w: 9.2, h: 1.22,
      fill: { color: "16213E" }, line: { color: sm.color, width: 2 }
    });
    s.addShape(pres.shapes.RECTANGLE, {
      x: 0.4, y, w: 0.8, h: 1.22,
      fill: { color: sm.color }, line: { color: sm.color }
    });
    s.addText(sm.num, {
      x: 0.4, y, w: 0.8, h: 1.22,
      fontSize: 18, bold: true, color: C.white,
      align: "center", valign: "middle", margin: 0
    });
    s.addText(sm.a, {
      x: 1.35, y: y + 0.12, w: 7.8, h: 0.42,
      fontSize: 17, color: "AAAACC", margin: 0
    });
    s.addText(sm.b, {
      x: 1.35, y: y + 0.58, w: 7.8, h: 0.52,
      fontSize: 22, bold: true, color: sm.color, margin: 0
    });
  });

  s.addText("세 가지가 합쳐질 때 — 빠르고 안전하고 저렴한 게임 제작", {
    x: 0.5, y: 5.22, w: 9, h: 0.35,
    fontSize: 13, italic: true, color: "666688",
    align: "center", margin: 0
  });
  slideNum(s, 30);
}


// ═══════════════════════════════════════
// 슬라이드 27 — 대립이 아니라 분업 (정리)
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.white };
  accentBar(s, C.blue);
  slideTitle(s, "AI 단독 vs Harness — 대립이 아니라 분업");

  // 왼쪽: AI 단독
  s.addShape(pres.shapes.RECTANGLE, {
    x: 0.3, y: 1.1, w: 4.0, h: 4.1,
    fill: { color: "EBF5FB" }, line: { color: "AED6F1", width: 2 }
  });
  s.addText("AI 단독", {
    x: 0.3, y: 1.1, w: 4.0, h: 0.48,
    fontSize: 16, bold: true, color: C.blue,
    align: "center", valign: "middle", margin: 0
  });
  const aiRole = [
    "아이디어 발산",
    "기획 초안 작성",
    "스토리·텍스트 생성",
    "컨셉 스케치",
    "빠른 프로토타이핑",
  ];
  aiRole.forEach((r, i) => {
    s.addText("💡  " + r, {
      x: 0.5, y: 1.7 + i * 0.7, w: 3.6, h: 0.55,
      fontSize: 13, color: C.textMain, margin: 0
    });
  });

  // 오른쪽: Harness/Skill
  s.addShape(pres.shapes.RECTANGLE, {
    x: 5.4, y: 1.1, w: 4.3, h: 4.1,
    fill: { color: "F0FFF4" }, line: { color: "A8E6C0", width: 2 }
  });
  s.addText("Harness / Skill", {
    x: 5.4, y: 1.1, w: 4.3, h: 0.48,
    fontSize: 16, bold: true, color: C.green,
    align: "center", valign: "middle", margin: 0
  });
  const harnessRole = [
    "실제 콘텐츠 생성 (YAML)",
    "5개 자동 검증 게이트",
    "성장식·밸런스 관리",
    "엔진 JSON 컴파일",
    "배포 + 리뷰",
  ];
  harnessRole.forEach((r, i) => {
    s.addText("⚙️  " + r, {
      x: 5.6, y: 1.7 + i * 0.7, w: 4.0, h: 0.55,
      fontSize: 13, color: C.textMain, margin: 0
    });
  });

  // 가운데 +
  s.addShape(pres.shapes.OVAL, {
    x: 4.3, y: 2.7, w: 1.0, h: 1.0,
    fill: { color: C.dark }, line: { color: C.dark }
  });
  s.addText("+", {
    x: 4.3, y: 2.7, w: 1.0, h: 1.0,
    fontSize: 28, bold: true, color: C.white,
    align: "center", valign: "middle", margin: 0
  });

  s.addText("= 빠르고 안전한 게임 제작 체계", {
    x: 0.5, y: 5.33, w: 9, h: 0.38,
    fontSize: 16, bold: true, color: C.dark,
    align: "center", margin: 0
  });
  slideNum(s, 31);
}


// ═══════════════════════════════════════
// 슬라이드 28 — 마무리
// ═══════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.dark };

  s.addShape(pres.shapes.RECTANGLE, {
    x: 0, y: 0, w: 0.35, h: 5.625,
    fill: { color: C.green }, line: { color: C.green }
  });
  s.addShape(pres.shapes.RECTANGLE, {
    x: 0.35, y: 0, w: 0.12, h: 5.625,
    fill: { color: C.blue }, line: { color: C.blue }
  });

  s.addText("함께 시작해 봅시다", {
    x: 0.8, y: 0.6, w: 8.8, h: 0.8,
    fontSize: 38, bold: true, color: C.white, fontFace: "Calibri"
  });

  s.addShape(pres.shapes.RECTANGLE, {
    x: 0.8, y: 1.55, w: 8.8, h: 0.04,
    fill: { color: "333366" }, line: { color: "333366" }
  });

  const steps = [
    { num: "01", text: "필요한 것: Claude Code + idle-game-generator 프로젝트" },
    { num: "02", text: '첫 번째 명령: /gen-unit [게임명] "유닛 설명"' },
    { num: "03", text: "4주 파일럿: 기존 게임 1개 마이그레이션" },
  ];
  steps.forEach((st, i) => {
    s.addShape(pres.shapes.RECTANGLE, {
      x: 0.8, y: 1.8 + i * 0.98, w: 0.55, h: 0.75,
      fill: { color: C.green }, line: { color: C.green }
    });
    s.addText(st.num, {
      x: 0.8, y: 1.8 + i * 0.98, w: 0.55, h: 0.75,
      fontSize: 13, bold: true, color: C.white,
      align: "center", valign: "middle", margin: 0
    });
    s.addText(st.text, {
      x: 1.5, y: 1.88 + i * 0.98, w: 8.0, h: 0.6,
      fontSize: 14, color: "CCCCEE", valign: "middle", margin: 0
    });
  });

  s.addShape(pres.shapes.RECTANGLE, {
    x: 0.8, y: 4.65, w: 8.8, h: 0.75,
    fill: { color: "0D3B26" }, line: { color: "0D3B26" }
  });
  s.addText('"AI는 도구입니다. Harness/Skill은 체계입니다."', {
    x: 0.9, y: 4.68, w: 8.6, h: 0.68,
    fontSize: 16, italic: true, color: C.green,
    align: "center", valign: "middle", margin: 0
  });
  slideNum(s, 32);
}


// ═══════════════════════════════════════
// 저장
// ═══════════════════════════════════════
const OUTPUT = "/Users/yangjinhwan/Documents/Claude/Projects/idle-game-generator/harness-skill-presentation.pptx";
pres.writeFile({ fileName: OUTPUT })
  .then(() => console.log("✅ 저장 완료:", OUTPUT))
  .catch(err => { console.error("❌ 오류:", err); process.exit(1); });
