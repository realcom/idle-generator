import { mkdirSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const outDir = dirname(fileURLToPath(import.meta.url));

const person = {
  company: "UnionJam Inc.",
  brand: "UNIONJAM",
  name: "Yang Jin Hwan",
  title: "CTO",
  phone: "+82 10 2647 0377",
  email: "jin@unionjam.com",
};

const css = `
    .sans { font-family: Arial, Helvetica, sans-serif; }
    .mono { font-family: "Courier New", Courier, monospace; }
    .heavy { font-weight: 700; }
  `;

function svg(body, desc = "UnionJam Inc. business card concept") {
  return `<svg xmlns="http://www.w3.org/2000/svg" width="90mm" height="50mm" viewBox="0 0 900 500" role="img">
  <title>${desc}</title>
  <defs>
    <style>${css}</style>
  </defs>
${body}
</svg>
`;
}

function mark(x, y, size, color, gap = 8) {
  const cells = [
    [0, 0], [1, 0], [2, 0],
    [0, 1], [2, 1],
    [0, 2], [1, 2], [2, 2],
  ];
  return `<g fill="${color}">
${cells.map(([cx, cy]) => `    <rect x="${x + cx * (size + gap)}" y="${y + cy * (size + gap)}" width="${size}" height="${size}"/>`).join("\n")}
  </g>`;
}

function cornerPixels(color) {
  return `<g fill="${color}">
    <rect x="64" y="64" width="12" height="12"/>
    <rect x="88" y="64" width="12" height="12"/>
    <rect x="112" y="64" width="12" height="12"/>
    <rect x="64" y="88" width="12" height="12"/>
    <rect x="824" y="412" width="12" height="12"/>
    <rect x="800" y="412" width="12" height="12"/>
    <rect x="776" y="412" width="12" height="12"/>
    <rect x="824" y="388" width="12" height="12"/>
  </g>`;
}

function variant01Front() {
  return svg(`  <rect width="900" height="500" fill="#fff"/>
  <rect x="32" y="32" width="836" height="436" fill="none" stroke="#111" stroke-width="3"/>
  ${mark(64, 64, 34, "#111")}
  ${mark(772, 64, 16, "#111")}
  <text class="sans heavy" x="214" y="112" font-size="38" fill="#111">${person.company}</text>
  <text class="sans heavy" x="64" y="258" font-size="56" fill="#111">${person.name}</text>
  <text class="mono" x="67" y="300" font-size="18" letter-spacing="3" fill="#111">${person.title}</text>
  <line x1="64" y1="386" x2="836" y2="386" stroke="#111" stroke-width="3"/>
  <text class="mono" x="64" y="425" font-size="24" letter-spacing="1" fill="#111">${person.phone}</text>
  <text class="mono" x="64" y="457" font-size="20" letter-spacing="1" fill="#111">${person.email}</text>
  <text class="mono" x="836" y="457" text-anchor="end" font-size="14" letter-spacing="2" fill="#111">UNIONJAM INC.</text>`, "Concept 01 front");
}

function variant01Back() {
  return svg(`  <rect width="900" height="500" fill="#111"/>
  <rect x="32" y="32" width="836" height="436" fill="none" stroke="#fff" stroke-width="3"/>
  ${mark(350, 110, 52, "#fff", 12)}
  <text class="sans heavy" x="450" y="347" text-anchor="middle" font-size="62" letter-spacing="1" fill="#fff">${person.brand}</text>
  <text class="mono" x="450" y="390" text-anchor="middle" font-size="22" letter-spacing="6" fill="#fff">INC.</text>
  ${cornerPixels("#fff")}`, "Concept 01 back");
}

function variant02Front() {
  return svg(`  <rect width="900" height="500" fill="#fff"/>
  <rect x="0" y="0" width="230" height="500" fill="#111"/>
  ${mark(58, 74, 38, "#fff", 10)}
  <text class="sans heavy" x="64" y="404" font-size="30" fill="#fff">UNION</text>
  <text class="sans heavy" x="64" y="442" font-size="30" fill="#fff">JAM</text>
  <rect x="258" y="54" width="590" height="392" fill="none" stroke="#111" stroke-width="2"/>
  <text class="sans heavy" x="292" y="150" font-size="50" fill="#111">${person.name}</text>
  <text class="mono" x="296" y="195" font-size="22" letter-spacing="4" fill="#111">${person.title}</text>
  <line x1="292" y1="260" x2="808" y2="260" stroke="#111" stroke-width="2"/>
  <text class="mono" x="292" y="320" font-size="24" fill="#111">${person.phone}</text>
  <text class="mono" x="292" y="360" font-size="22" fill="#111">${person.email}</text>
  <text class="sans heavy" x="808" y="408" text-anchor="end" font-size="28" fill="#111">${person.company}</text>`, "Concept 02 front");
}

function variant02Back() {
  return svg(`  <rect width="900" height="500" fill="#fff"/>
  <rect x="0" y="0" width="230" height="500" fill="#111"/>
  ${mark(346, 128, 62, "#111", 14)}
  <text class="sans heavy" x="450" y="374" text-anchor="middle" font-size="58" fill="#111">${person.brand}</text>
  <text class="mono" x="450" y="415" text-anchor="middle" font-size="22" letter-spacing="5" fill="#111">INC.</text>`, "Concept 02 back");
}

function variant03Front() {
  return svg(`  <rect width="900" height="500" fill="#fff"/>
  <rect x="44" y="44" width="812" height="412" fill="none" stroke="#111" stroke-width="2"/>
  <rect x="44" y="44" width="812" height="44" fill="#111"/>
  <circle cx="72" cy="66" r="6" fill="#fff"/>
  <circle cx="96" cy="66" r="6" fill="#fff"/>
  <circle cx="120" cy="66" r="6" fill="#fff"/>
  <text class="mono" x="156" y="72" font-size="16" letter-spacing="2" fill="#fff">UNIONJAM.EXE</text>
  <text class="mono heavy" x="78" y="164" font-size="30" fill="#111">&gt; ${person.name}</text>
  <text class="mono" x="78" y="210" font-size="24" fill="#111">role: ${person.title}</text>
  <text class="mono" x="78" y="260" font-size="24" fill="#111">mail: ${person.email}</text>
  <text class="mono" x="78" y="308" font-size="24" fill="#111">tel : ${person.phone}</text>
  <rect x="78" y="358" width="280" height="24" fill="#111"/>
  <text class="mono" x="78" y="420" font-size="20" letter-spacing="4" fill="#111">${person.company}</text>
  ${mark(716, 340, 20, "#111", 8)}`, "Concept 03 front");
}

function variant03Back() {
  return svg(`  <rect width="900" height="500" fill="#111"/>
  <text class="mono" x="72" y="92" font-size="18" letter-spacing="2" fill="#fff">BOOTING BRAND SYSTEM</text>
  <line x1="72" y1="118" x2="828" y2="118" stroke="#fff" stroke-width="2"/>
  ${mark(360, 154, 46, "#fff", 12)}
  <text class="mono heavy" x="450" y="364" text-anchor="middle" font-size="52" letter-spacing="4" fill="#fff">${person.brand}</text>
  <text class="mono" x="450" y="408" text-anchor="middle" font-size="22" letter-spacing="6" fill="#fff">INC.</text>
  <rect x="72" y="442" width="112" height="8" fill="#fff"/>
  <rect x="716" y="442" width="112" height="8" fill="#fff"/>`, "Concept 03 back");
}

function variant04Front() {
  return svg(`  <rect width="900" height="500" fill="#fff"/>
  <g stroke="#111" stroke-width="2">
    <line x1="56" y1="80" x2="844" y2="80"/>
    <line x1="56" y1="420" x2="844" y2="420"/>
    <line x1="118" y1="56" x2="118" y2="444"/>
    <line x1="782" y1="56" x2="782" y2="444"/>
  </g>
  <text class="sans heavy" x="450" y="188" text-anchor="middle" font-size="54" fill="#111">${person.name}</text>
  <text class="mono" x="450" y="232" text-anchor="middle" font-size="19" letter-spacing="5" fill="#111">${person.title}</text>
  <text class="mono" x="450" y="314" text-anchor="middle" font-size="22" fill="#111">${person.email}</text>
  <text class="mono" x="450" y="352" text-anchor="middle" font-size="22" fill="#111">${person.phone}</text>
  <text class="sans heavy" x="450" y="124" text-anchor="middle" font-size="24" fill="#111">${person.company}</text>
  ${mark(70, 224, 14, "#111", 7)}
  ${mark(780, 224, 14, "#111", 7)}`, "Concept 04 front");
}

function variant04Back() {
  return svg(`  <rect width="900" height="500" fill="#fff"/>
  <g fill="#111">
    ${Array.from({ length: 15 }, (_, i) => `<rect x="${84 + i * 52}" y="76" width="20" height="20"/>`).join("\n    ")}
    ${Array.from({ length: 15 }, (_, i) => `<rect x="${84 + i * 52}" y="404" width="20" height="20"/>`).join("\n    ")}
  </g>
  ${mark(348, 130, 58, "#111", 14)}
  <text class="sans heavy" x="450" y="366" text-anchor="middle" font-size="58" fill="#111">${person.brand}</text>
  <text class="mono" x="450" y="406" text-anchor="middle" font-size="20" letter-spacing="6" fill="#111">INC.</text>`, "Concept 04 back");
}

function variant05Front() {
  return svg(`  <rect width="900" height="500" fill="#fff"/>
  <path d="M642 0H900V500H532Z" fill="#111"/>
  <path d="M618 0H648L538 500H508Z" fill="#fff"/>
  <text class="sans heavy" x="62" y="118" font-size="34" fill="#111">${person.company}</text>
  <text class="sans heavy" x="62" y="256" font-size="54" fill="#111">${person.name}</text>
  <text class="mono" x="65" y="300" font-size="20" letter-spacing="5" fill="#111">${person.title}</text>
  <text class="mono" x="62" y="386" font-size="22" fill="#111">${person.email}</text>
  <text class="mono" x="62" y="424" font-size="22" fill="#111">${person.phone}</text>
  ${mark(728, 64, 28, "#fff", 10)}`, "Concept 05 front");
}

function variant05Back() {
  return svg(`  <rect width="900" height="500" fill="#111"/>
  <path d="M690 0H900V500H794Z" fill="#fff"/>
  ${mark(358, 126, 58, "#fff", 14)}
  <text class="sans heavy" x="450" y="362" text-anchor="middle" font-size="58" fill="#fff">${person.brand}</text>
  <text class="mono" x="450" y="404" text-anchor="middle" font-size="21" letter-spacing="6" fill="#fff">INC.</text>`, "Concept 05 back");
}

function variant06Front() {
  return svg(`  <rect width="900" height="500" fill="#fff"/>
  <rect x="594" y="0" width="306" height="500" fill="#111"/>
  <rect x="56" y="56" width="462" height="388" fill="none" stroke="#111" stroke-width="2"/>
  <text class="sans heavy" x="82" y="150" font-size="58" fill="#111">Yang</text>
  <text class="sans heavy" x="82" y="218" font-size="58" fill="#111">Jin Hwan</text>
  <text class="mono" x="84" y="270" font-size="21" letter-spacing="4" fill="#111">${person.title}</text>
  <line x1="82" y1="318" x2="486" y2="318" stroke="#111" stroke-width="2"/>
  <text class="mono" x="82" y="364" font-size="20" fill="#111">${person.email}</text>
  <text class="mono" x="82" y="398" font-size="20" fill="#111">${person.phone}</text>
  ${mark(670, 128, 48, "#fff", 12)}
  <text class="sans heavy" x="747" y="344" text-anchor="middle" font-size="34" fill="#fff">${person.brand}</text>
  <text class="mono" x="747" y="380" text-anchor="middle" font-size="18" letter-spacing="4" fill="#fff">INC.</text>`, "Concept 06 front");
}

function variant06Back() {
  return svg(`  <rect width="900" height="500" fill="#fff"/>
  <rect x="0" y="0" width="900" height="500" fill="#111"/>
  <rect x="92" y="76" width="716" height="348" fill="none" stroke="#fff" stroke-width="2"/>
  <text class="sans heavy" x="120" y="172" font-size="72" fill="#fff">UNION</text>
  <text class="sans heavy" x="120" y="250" font-size="72" fill="#fff">JAM</text>
  ${mark(620, 146, 48, "#fff", 12)}
  <text class="mono" x="120" y="360" font-size="22" letter-spacing="6" fill="#fff">INC.</text>`, "Concept 06 back");
}

function variant07Front() {
  return svg(`  <rect width="900" height="500" fill="#fff"/>
  <g stroke="#111" stroke-width="1" opacity="0.45">
    ${Array.from({ length: 10 }, (_, i) => `<line x1="${72 + i * 72}" y1="56" x2="${72 + i * 72}" y2="444"/>`).join("\n    ")}
    ${Array.from({ length: 6 }, (_, i) => `<line x1="56" y1="${72 + i * 64}" x2="844" y2="${72 + i * 64}"/>`).join("\n    ")}
  </g>
  <rect x="56" y="56" width="788" height="388" fill="none" stroke="#111" stroke-width="3"/>
  <text class="mono" x="84" y="104" font-size="16" letter-spacing="3" fill="#111">${person.company}</text>
  <text class="sans heavy" x="84" y="220" font-size="52" fill="#111">${person.name}</text>
  <text class="mono" x="84" y="264" font-size="21" letter-spacing="4" fill="#111">${person.title}</text>
  <rect x="84" y="310" width="190" height="6" fill="#111"/>
  <text class="mono" x="84" y="362" font-size="21" fill="#111">${person.email}</text>
  <text class="mono" x="84" y="398" font-size="21" fill="#111">${person.phone}</text>
  ${mark(706, 302, 26, "#111", 10)}`, "Concept 07 front");
}

function variant07Back() {
  return svg(`  <rect width="900" height="500" fill="#fff"/>
  <g stroke="#111" stroke-width="1" opacity="0.4">
    ${Array.from({ length: 11 }, (_, i) => `<line x1="${64 + i * 76}" y1="64" x2="${64 + i * 76}" y2="436"/>`).join("\n    ")}
    ${Array.from({ length: 7 }, (_, i) => `<line x1="64" y1="${64 + i * 62}" x2="836" y2="${64 + i * 62}"/>`).join("\n    ")}
  </g>
  ${mark(348, 124, 58, "#111", 14)}
  <text class="mono heavy" x="450" y="366" text-anchor="middle" font-size="54" letter-spacing="4" fill="#111">${person.brand}</text>
  <text class="mono" x="450" y="408" text-anchor="middle" font-size="20" letter-spacing="7" fill="#111">INC.</text>`, "Concept 07 back");
}

function variant08Front() {
  return svg(`  <rect width="900" height="500" fill="#111"/>
  <rect x="36" y="36" width="828" height="428" fill="none" stroke="#fff" stroke-width="2"/>
  ${mark(64, 64, 28, "#fff", 10)}
  <text class="sans heavy" x="62" y="236" font-size="58" fill="#fff">${person.name}</text>
  <text class="mono" x="66" y="284" font-size="22" letter-spacing="5" fill="#fff">${person.title}</text>
  <text class="mono" x="62" y="374" font-size="22" fill="#fff">${person.email}</text>
  <text class="mono" x="62" y="410" font-size="22" fill="#fff">${person.phone}</text>
  <text class="sans heavy" x="838" y="92" text-anchor="end" font-size="32" fill="#fff">${person.company}</text>`, "Concept 08 front");
}

function variant08Back() {
  return svg(`  <rect width="900" height="500" fill="#fff"/>
  <rect x="36" y="36" width="828" height="428" fill="none" stroke="#111" stroke-width="2"/>
  ${mark(350, 108, 58, "#111", 14)}
  <text class="sans heavy" x="450" y="356" text-anchor="middle" font-size="62" fill="#111">${person.brand}</text>
  <text class="mono" x="450" y="400" text-anchor="middle" font-size="22" letter-spacing="7" fill="#111">INC.</text>`, "Concept 08 back");
}

function variant09Front() {
  return svg(`  <rect width="900" height="500" fill="#fff"/>
  <g fill="#111" opacity="0.08">
    ${Array.from({ length: 9 }, (_, y) => Array.from({ length: 15 }, (_, x) => `<rect x="${32 + x * 58}" y="${28 + y * 52}" width="32" height="32"/>`).join("\n    ")).join("\n    ")}
  </g>
  <rect x="60" y="60" width="780" height="380" fill="#fff" stroke="#111" stroke-width="2"/>
  <text class="sans heavy" x="96" y="164" font-size="50" fill="#111">${person.name}</text>
  <text class="mono" x="100" y="206" font-size="20" letter-spacing="4" fill="#111">${person.title}</text>
  <text class="mono" x="100" y="330" font-size="22" fill="#111">${person.email}</text>
  <text class="mono" x="100" y="368" font-size="22" fill="#111">${person.phone}</text>
  <text class="sans heavy" x="802" y="128" text-anchor="end" font-size="32" fill="#111">${person.company}</text>
  ${mark(682, 250, 30, "#111", 10)}`, "Concept 09 front");
}

function variant09Back() {
  return svg(`  <rect width="900" height="500" fill="#111"/>
  <g fill="#fff" opacity="0.14">
    ${Array.from({ length: 8 }, (_, y) => Array.from({ length: 14 }, (_, x) => `<rect x="${58 + x * 58}" y="${50 + y * 52}" width="30" height="30"/>`).join("\n    ")).join("\n    ")}
  </g>
  <rect x="252" y="94" width="396" height="312" fill="#111" stroke="#fff" stroke-width="2"/>
  ${mark(360, 130, 46, "#fff", 12)}
  <text class="sans heavy" x="450" y="334" text-anchor="middle" font-size="52" fill="#fff">${person.brand}</text>
  <text class="mono" x="450" y="374" text-anchor="middle" font-size="20" letter-spacing="6" fill="#fff">INC.</text>`, "Concept 09 back");
}

function variant10Front() {
  return svg(`  <rect width="900" height="500" fill="#fff"/>
  <line x1="64" y1="74" x2="836" y2="74" stroke="#111" stroke-width="2"/>
  <line x1="64" y1="426" x2="836" y2="426" stroke="#111" stroke-width="2"/>
  <text class="mono" x="64" y="116" font-size="18" letter-spacing="4" fill="#111">${person.company}</text>
  <text class="sans heavy" x="64" y="252" font-size="64" fill="#111">${person.name}</text>
  <text class="mono" x="70" y="302" font-size="22" letter-spacing="6" fill="#111">${person.title}</text>
  <text class="mono" x="64" y="374" font-size="22" fill="#111">${person.email}</text>
  <text class="mono" x="618" y="374" font-size="22" fill="#111">${person.phone}</text>
  ${mark(736, 108, 22, "#111", 8)}`, "Concept 10 front");
}

function variant10Back() {
  return svg(`  <rect width="900" height="500" fill="#fff"/>
  <line x1="64" y1="74" x2="836" y2="74" stroke="#111" stroke-width="2"/>
  <line x1="64" y1="426" x2="836" y2="426" stroke="#111" stroke-width="2"/>
  <text class="sans heavy" x="450" y="250" text-anchor="middle" font-size="72" fill="#111">${person.brand}</text>
  <text class="mono" x="450" y="304" text-anchor="middle" font-size="22" letter-spacing="8" fill="#111">INC.</text>
  ${mark(80, 108, 22, "#111", 8)}
  ${mark(736, 326, 22, "#111", 8)}`, "Concept 10 back");
}

const variants = [
  ["01", "Border Pixel", variant01Front, variant01Back],
  ["02", "Split Panel", variant02Front, variant02Back],
  ["03", "Terminal", variant03Front, variant03Back],
  ["04", "Arcade Grid", variant04Front, variant04Back],
  ["05", "Diagonal Slash", variant05Front, variant05Back],
  ["06", "Offset Block", variant06Front, variant06Back],
  ["07", "System Grid", variant07Front, variant07Back],
  ["08", "Reverse Black", variant08Front, variant08Back],
  ["09", "Pattern Field", variant09Front, variant09Back],
  ["10", "Thin Editorial", variant10Front, variant10Back],
];

mkdirSync(outDir, { recursive: true });

for (const [id, , front, back] of variants) {
  writeFileSync(join(outDir, `unionjam-card-concept-${id}-front.svg`), front());
  writeFileSync(join(outDir, `unionjam-card-concept-${id}-back.svg`), back());
}

const gallery = `<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>UnionJam Business Card Concepts</title>
  <style>
    :root {
      background: #f2f2f2;
      color: #111;
      font-family: Arial, Helvetica, sans-serif;
    }

    body {
      margin: 0;
      padding: 32px;
    }

    .gallery {
      display: grid;
      gap: 32px;
      max-width: 1200px;
      margin: 0 auto;
    }

    .concept {
      display: grid;
      gap: 12px;
    }

    .label {
      font-size: 13px;
      font-weight: 700;
      letter-spacing: 0.08em;
      text-transform: uppercase;
    }

    .cards {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 16px;
    }

    img {
      display: block;
      width: 100%;
      height: auto;
      background: #fff;
      box-shadow: 0 8px 24px rgb(0 0 0 / 0.12);
    }

    @media (max-width: 760px) {
      body { padding: 18px; }
      .cards { grid-template-columns: 1fr; }
    }
  </style>
</head>
<body>
  <div class="gallery">
${variants.map(([id, name]) => `    <div class="concept">
      <div class="label">Concept ${id} - ${name}</div>
      <div class="cards">
        <img src="unionjam-card-concept-${id}-front.svg" alt="Concept ${id} front">
        <img src="unionjam-card-concept-${id}-back.svg" alt="Concept ${id} back">
      </div>
    </div>`).join("\n")}
  </div>
</body>
</html>
`;

writeFileSync(join(outDir, "gallery.html"), gallery);

const readme = `# UnionJam Business Card Concepts

Ten black and white flat business card directions.

Personal information used in every concept:

- Name: ${person.name}
- Role: ${person.title}
- Company: ${person.company}
- Phone: ${person.phone}
- Email: ${person.email}

Open \`gallery.html\` to review all concepts.
`;

writeFileSync(join(outDir, "README.md"), readme);

console.log(`Generated ${variants.length} concepts in ${outDir}`);
