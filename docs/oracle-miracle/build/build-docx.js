// Build oracle-miracle business plan DOCX from markdown sections
// Usage: node build-docx.js

const path = require('path');
const fs = require('fs');

const MODULE_DIRS = [
  process.env.CODEX_NODE_MODULES,
  process.env.NODE_PATH,
  '/Users/yangjinhwan/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules',
].filter(Boolean).flatMap(p => p.split(path.delimiter).filter(Boolean));

function requireFromKnownDirs(name) {
  for (const dir of MODULE_DIRS) {
    const candidate = path.join(dir, name);
    if (fs.existsSync(candidate)) return require(candidate);
  }
  return require(name);
}

const docx = requireFromKnownDirs('docx');

const {
  Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell,
  AlignmentType, HeadingLevel, BorderStyle, WidthType, ShadingType,
  Header, Footer, PageNumber, LevelFormat, PageBreak, ImageRun,
} = docx;

const SECTIONS_DIR = '/Users/yangjinhwan/Projects/idle-game-generator/docs/oracle-miracle/sections';
const DIAGRAMS_DIR = '/Users/yangjinhwan/Projects/idle-game-generator/docs/oracle-miracle/assets/diagrams';
const OUTPUT = '/Users/yangjinhwan/Projects/idle-game-generator/docs/oracle-miracle/build/oracle-miracle.docx';

// Diagram number → PNG file (use v2 monochrome versions)
const DIAGRAM_MAP = {
  1: '01-ip-validation-v2.png',
  2: '02-two-market-timeline-v2.png',
  3: '03-competition-matrix-v2.png',
  4: '04-idle-forge-architecture-v2.png',
  5: '05-collab-machines-v2.png',
  6: '06-asset-workflow-v2.png',
  7: '07-oci-operations-v2.png',
  8: '08-three-stage-loop-v2.png',
  9: '09-dual-bm-tracks-v2.png',
  10: '10-gantt-v2.png',
  11: '11-budget-pie-v2.png',
};

// PNG IHDR chunk: read width/height from header
function getPngSize(buf) {
  return {
    width: buf.readUInt32BE(16),
    height: buf.readUInt32BE(20),
  };
}

const SECTION_FILES = [
  '00-cover.md',
  '01-problem.md',
  '02-solution.md',
  '03-scaleup.md',
  '04-team.md',
  '05-oracle.md',
];

const FONT = 'Malgun Gothic';
const BODY_SIZE = 18; // 9pt
const TABLE_SIZE = 16; // 8pt
const CAPTION_SIZE = 17; // 8.5pt
const ESSENTIAL_DIAGRAMS = new Set([3, 4, 8, 10, 11]);
const BORDER = { style: BorderStyle.SINGLE, size: 4, color: 'AAAAAA' };
const BORDERS = { top: BORDER, bottom: BORDER, left: BORDER, right: BORDER };

// --- Inline markdown → TextRun[] ---
function parseInline(line, baseProps = {}) {
  const runs = [];
  // Split by **bold** preserving boundaries
  const parts = line.split(/(\*\*[^*]+\*\*)/);
  for (const part of parts) {
    if (!part) continue;
    if (part.startsWith('**') && part.endsWith('**') && part.length > 4) {
      runs.push(new TextRun({ text: part.slice(2, -2), bold: true, font: FONT, ...baseProps }));
    } else {
      runs.push(new TextRun({ text: part, font: FONT, ...baseProps }));
    }
  }
  return runs.length ? runs : [new TextRun({ text: line, font: FONT, ...baseProps })];
}

// --- Table parser ---
function parseTable(tableLines) {
  // Filter divider rows like |---|---|
  const dataLines = tableLines.filter(l => !/^\|[\s\-:|]+\|$/.test(l.trim()));
  const rows = dataLines.map(l => {
    const trimmed = l.trim();
    const inner = trimmed.slice(1, -1); // strip leading and trailing |
    return inner.split('|').map(c => c.trim());
  });
  if (rows.length === 0) return null;

  const numCols = Math.max(...rows.map(r => r.length));
  // Normalize cell counts
  const normRows = rows.map(r => {
    while (r.length < numCols) r.push('');
    return r.slice(0, numCols);
  });

  const tableWidth = 9866; // A4 content width with compact 0.45" margins
  const colWidth = Math.floor(tableWidth / numCols);
  const colWidths = new Array(numCols).fill(colWidth);
  // Adjust last column to absorb rounding
  colWidths[numCols - 1] += tableWidth - colWidth * numCols;

  const tableRows = normRows.map((cells, rowIdx) => new TableRow({
    tableHeader: rowIdx === 0,
    children: cells.map((cellText, colIdx) => new TableCell({
      borders: BORDERS,
      width: { size: colWidths[colIdx], type: WidthType.DXA },
      margins: { top: 40, bottom: 40, left: 70, right: 70 },
      shading: rowIdx === 0 ? { fill: 'F2F2F2', type: ShadingType.CLEAR } : undefined,
      children: [new Paragraph({
        spacing: { before: 0, after: 0 },
        children: parseInline(cellText, { size: TABLE_SIZE }),
      })],
    })),
  }));

  return new Table({
    width: { size: tableWidth, type: WidthType.DXA },
    columnWidths: colWidths,
    rows: tableRows,
  });
}

// --- Blockquote (image marker) parser ---
// Detects `> **[도식 삽입 — 그림 N]** 제목` and embeds the actual PNG below the caption.
function parseBlockquote(quoteLines) {
  // Each line starts with "> "; strip prefix
  const stripped = quoteLines.map(l => l.replace(/^>\s?/, ''));
  const fullText = stripped.join('\n');

  // Detect diagram marker like "**[도식 삽입 — 그림 N]** 제목"
  const m = fullText.match(/\[도식\s*삽입\s*[—–-]\s*그림\s*(\d+)\]\s*\*?\*?\s*(.*?)(?:\n|$)/);
  const children = [];

  if (m) {
    const num = parseInt(m[1], 10);
    const title = m[2].trim();
    if (!ESSENTIAL_DIAGRAMS.has(num)) {
      return [];
    }
    const filename = DIAGRAM_MAP[num];
    const imgPath = filename ? path.join(DIAGRAMS_DIR, filename) : null;

    if (imgPath && fs.existsSync(imgPath)) {
      // Caption (centered, bold)
      children.push(new Paragraph({
        alignment: AlignmentType.CENTER,
        spacing: { before: 100, after: 40 },
        children: [
          new TextRun({ text: `[그림 ${num}] `, bold: true, font: FONT, size: CAPTION_SIZE }),
          new TextRun({ text: title.replace(/^\*+|\*+$/g, ''), bold: true, font: FONT, size: CAPTION_SIZE }),
        ],
      }));

      // Image
      const buf = fs.readFileSync(imgPath);
      const { width: pxW, height: pxH } = getPngSize(buf);
      const targetW = 430;
      const targetH = Math.round(pxH * (targetW / pxW));
      children.push(new Paragraph({
        alignment: AlignmentType.CENTER,
        spacing: { before: 0, after: 40 },
        children: [new ImageRun({
          type: 'png',
          data: buf,
          transformation: { width: targetW, height: targetH },
          altText: { title: `그림 ${num}`, description: title, name: `figure${num}` },
        })],
      }));

      // Description (small italic, below image)
      const descLine = stripped.slice(1).join(' ').trim();
      if (descLine) {
        children.push(new Paragraph({
          alignment: AlignmentType.CENTER,
          spacing: { before: 0, after: 80 },
          children: parseInline(descLine, { size: 15, italics: true, color: '555555' }),
        }));
      }

      return children;
    }
  }

  // Fallback: render as gray box (original behavior)
  const runs = [];
  stripped.forEach((line, idx) => {
    if (idx > 0) runs.push(new TextRun({ break: 1, font: FONT }));
    runs.push(...parseInline(line, { size: TABLE_SIZE }));
  });
  return [new Paragraph({
    shading: { fill: 'EEEEEE', type: ShadingType.CLEAR },
    border: {
      top: { style: BorderStyle.SINGLE, size: 4, color: 'CCCCCC' },
      bottom: { style: BorderStyle.SINGLE, size: 4, color: 'CCCCCC' },
      left: { style: BorderStyle.SINGLE, size: 4, color: 'CCCCCC' },
      right: { style: BorderStyle.SINGLE, size: 4, color: 'CCCCCC' },
    },
    spacing: { before: 60, after: 60 },
    children: runs,
  })];
}

// --- Markdown → docx children ---
function parseMarkdown(md) {
  const lines = md.split('\n');
  const children = [];
  let i = 0;

  while (i < lines.length) {
    const line = lines[i];
    const trimmed = line.trim();

    // Heading 1
    if (line.startsWith('# ')) {
      children.push(new Paragraph({
        heading: HeadingLevel.HEADING_1,
        children: parseInline(line.slice(2)),
      }));
      i++; continue;
    }
    // Heading 2
    if (line.startsWith('## ')) {
      children.push(new Paragraph({
        heading: HeadingLevel.HEADING_2,
        children: parseInline(line.slice(3)),
      }));
      i++; continue;
    }
    // Heading 3 (and beyond)
    if (line.startsWith('### ')) {
      children.push(new Paragraph({
        heading: HeadingLevel.HEADING_3,
        children: parseInline(line.slice(4)),
      }));
      i++; continue;
    }
    if (line.startsWith('#### ')) {
      children.push(new Paragraph({
        heading: HeadingLevel.HEADING_4,
        children: parseInline(line.slice(5)),
      }));
      i++; continue;
    }

    // Blockquote (image marker)
    if (line.startsWith('>')) {
      const quoteLines = [];
      while (i < lines.length && lines[i].startsWith('>')) {
        quoteLines.push(lines[i]);
        i++;
      }
      children.push(...parseBlockquote(quoteLines));
      continue;
    }

    // Table
    if (line.startsWith('|') && line.endsWith('|')) {
      const tableLines = [];
      while (i < lines.length && lines[i].trim().startsWith('|') && lines[i].trim().endsWith('|')) {
        tableLines.push(lines[i]);
        i++;
      }
      const table = parseTable(tableLines);
      if (table) children.push(table);
      // Spacing paragraph after table
      children.push(new Paragraph({ children: [], spacing: { before: 20, after: 20 } }));
      continue;
    }

    // Horizontal rule
    if (/^---+$/.test(trimmed)) {
      children.push(new Paragraph({
        border: { bottom: { style: BorderStyle.SINGLE, size: 6, color: '888888', space: 1 } },
        children: [],
      }));
      i++; continue;
    }

    // Empty line
    if (trimmed === '') {
      i++; continue;
    }

    // Normal paragraph (preserve markers like ○ - etc.)
    // Preserve leading whitespace as indentation hint
    const leadingSpaces = line.length - line.trimStart().length;
    const indent = leadingSpaces > 0 ? { left: leadingSpaces * 60 } : undefined;
    children.push(new Paragraph({
      indent,
      spacing: { before: 0, after: 20 },
      children: parseInline(trimmed, { size: BODY_SIZE }),
    }));
    i++;
  }

  return children;
}

// --- Build all sections ---
const allChildren = [];
SECTION_FILES.forEach((file, idx) => {
  const filePath = path.join(SECTIONS_DIR, file);
  const md = fs.readFileSync(filePath, 'utf-8');
  const sectionChildren = parseMarkdown(md);
  allChildren.push(...sectionChildren);
});

const doc = new Document({
  creator: 'UNIONJAM',
  title: 'Oracle Miracle 4기 사업계획서 - 유니온잼',
  styles: {
    default: {
      document: { run: { font: FONT, size: BODY_SIZE } },
    },
    paragraphStyles: [
      { id: 'Heading1', name: 'Heading 1', basedOn: 'Normal', next: 'Normal', quickFormat: true,
        run: { size: 28, bold: true, font: FONT, color: '000000' },
        paragraph: { spacing: { before: 220, after: 100 }, outlineLevel: 0 } },
      { id: 'Heading2', name: 'Heading 2', basedOn: 'Normal', next: 'Normal', quickFormat: true,
        run: { size: 24, bold: true, font: FONT, color: '000000' },
        paragraph: { spacing: { before: 160, after: 80 }, outlineLevel: 1 } },
      { id: 'Heading3', name: 'Heading 3', basedOn: 'Normal', next: 'Normal', quickFormat: true,
        run: { size: 21, bold: true, font: FONT, color: '000000' },
        paragraph: { spacing: { before: 100, after: 40 }, outlineLevel: 2 } },
      { id: 'Heading4', name: 'Heading 4', basedOn: 'Normal', next: 'Normal', quickFormat: true,
        run: { size: 19, bold: true, font: FONT, color: '000000' },
        paragraph: { spacing: { before: 80, after: 30 }, outlineLevel: 3 } },
    ],
  },
  sections: [{
    properties: {
      page: {
        size: { width: 11906, height: 16838 }, // A4
        margin: { top: 720, right: 650, bottom: 720, left: 650 },
      },
    },
    footers: {
      default: new Footer({
        children: [new Paragraph({
          alignment: AlignmentType.CENTER,
          children: [
            new TextRun({ text: '- ', font: FONT, size: 16 }),
            new TextRun({ children: [PageNumber.CURRENT], font: FONT, size: 16 }),
            new TextRun({ text: ' -', font: FONT, size: 16 }),
          ],
        })],
      }),
    },
    children: allChildren,
  }],
});

Packer.toBuffer(doc).then(buf => {
  fs.mkdirSync(path.dirname(OUTPUT), { recursive: true });
  fs.writeFileSync(OUTPUT, buf);
  const stat = fs.statSync(OUTPUT);
  console.log(`✓ Built: ${OUTPUT}`);
  console.log(`  Size: ${(stat.size / 1024).toFixed(1)} KB`);
}).catch(err => {
  console.error('Build failed:', err);
  process.exit(1);
});
