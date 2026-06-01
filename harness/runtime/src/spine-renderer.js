// spine-renderer.js — Spine WebGL character renderer
// Phaser와 공존: 별도 WebGL 캔버스에서 캐릭터 스켈레톤만 렌더링.
// 적 이동(approach) + 적 공격 애니메이션도 여기서 처리.

const SPINE_ASSETS = {
  Ninster:             { skel: 'assets/Ninster.skel.bytes',             atlas: 'assets/Ninster.atlas.txt',             png: 'assets/Ninster.png',             scale: 0.225 },
  melee_slime3_pirate: { skel: 'assets/melee_slime3_pirate.skel.bytes', atlas: 'assets/melee_slime3_pirate.atlas.txt', png: 'assets/melee_slime3_pirate.png', scale: 0.16 },
  Slimequeen:          { skel: 'assets/Slimequeen.skel.bytes',          atlas: 'assets/Slimequeen.atlas.txt',          png: 'assets/Slimequeen.png',          scale: 0.22 },
};

// 플레이어 위치 (Spine 좌표 — 좌하단 원점)
const PLAYER_POS = { xRatio: 0.18, yRatio: 0.15 };

function resolveSpineKey(unit) {
  if (unit.type === 'Boss') return 'Slimequeen';
  return 'melee_slime3_pirate';
}

export class SpineRenderer {
  constructor(canvasId) {
    this.canvas = document.getElementById(canvasId);
    if (!this.canvas) throw new Error(`Canvas #${canvasId} not found`);
    this.gl = this.canvas.getContext('webgl', { alpha: true, premultipliedAlpha: false });
    if (!this.gl) throw new Error('WebGL not supported');

    this.shader = spine.Shader.newTwoColoredTextured(this.gl);
    this.batcher = new spine.PolygonBatcher(this.gl);
    this.mvp = new spine.Matrix4();
    this.skeletonRenderer = new spine.SkeletonRenderer(this.gl);
    this.skeletonRenderer.premultipliedAlpha = false;

    this.cache = {};
    this.playerInst = null;
    this.enemies = new Map();     // unit → { inst, x, y, targetX, fadeStart }
    this.spawnSlot = 0;
    this.board = null;

    this._onResize = () => this._resizeCanvas();
    window.addEventListener('resize', this._onResize);
    this._resizeCanvas();
  }

  setBoard(board) {
    this.board = board;
    board.playerX = this.canvas.width * PLAYER_POS.xRatio;
  }

  getPlayerPos() {
    return {
      x: this.canvas.width * PLAYER_POS.xRatio,
      y: this.canvas.height * PLAYER_POS.yRatio,
    };
  }

  // ── 에셋 로드 ──
  async loadAssets() {
    const gl = this.gl;
    for (const [key, cfg] of Object.entries(SPINE_ASSETS)) {
      const atlasBuf = await fetch(cfg.atlas).then(r => r.arrayBuffer());
      const atlasText = new TextDecoder('utf-8').decode(atlasBuf);
      const img = await new Promise((res, rej) => {
        const i = new Image(); i.crossOrigin = 'anonymous';
        i.onload = () => res(i); i.onerror = rej; i.src = cfg.png;
      });
      const texture = new spine.GLTexture(gl, img);
      const atlas = new spine.TextureAtlas(atlasText);
      atlas.pages.forEach(p => { p.texture = texture; p.width = img.width; p.height = img.height; });
      atlas.regions.forEach(r => { r.texture = texture; r.page.texture = texture; });
      const skelBuf = await fetch(cfg.skel).then(r => r.arrayBuffer());
      const loader = new spine.AtlasAttachmentLoader(atlas);
      const bin = new spine.SkeletonBinary(loader); bin.scale = cfg.scale;
      this.cache[key] = bin.readSkeletonData(new Uint8Array(skelBuf));
      console.log(`[SpineRenderer] ${key}: ${this.cache[key].animations.length} anims`);
    }
    // 플레이어
    this.playerInst = this._makeInst(this.cache.Ninster);
    this.playerInst.skeleton.scaleX = -Math.abs(this.playerInst.skeleton.scaleX || 1);
    this._tryPlay(this.playerInst.state, ['idle', 'wait', 'stand'], true);
  }

  // ── 유닛 이벤트 ──
  addEnemy(unit) {
    const key = resolveSpineKey(unit);
    const data = this.cache[key]; if (!data) return;
    const inst = this._makeInst(data);
    const isBoss = unit.type === 'Boss';
    const cw = this.canvas.width, ch = this.canvas.height;

    // 목표 위치: 플레이어 attackRange 거리 (겹침 허용 — 약간의 랜덤 오프셋만)
    const playerX = cw * PLAYER_POS.xRatio;
    const range = unit.attackRange || 150;
    const jitter = (Math.random() - 0.5) * 40;  // ±20px 랜덤
    const targetX = isBoss
      ? playerX + range + 30
      : playerX + range + jitter;
    const y = ch * PLAYER_POS.yRatio;
    this.spawnSlot++;

    // 시작 위치: approach=true면 화면 우측 밖에서 시작
    const startX = unit.approach ? cw + 50 + Math.random() * 80 : targetX;

    inst.skeleton.x = startX;
    inst.skeleton.y = y;
    inst.skeleton.scaleX = Math.abs(inst.skeleton.scaleX || 1);
    if (isBoss) { inst.skeleton.scaleX *= 1.5; inst.skeleton.scaleY *= 1.5; }

    // approach → walk, 아니면 idle
    if (unit.approach && unit.state === 'approaching') {
      this._tryPlay(inst.state, ['walk', 'run', 'move', 'idle'], true);
    } else {
      this._tryPlay(inst.state, ['idle', 'wait', 'stand'], true);
    }

    this.enemies.set(unit, { inst, x: startX, y, targetX, fadeStart: null });
  }

  removeEnemy(unit) {
    const e = this.enemies.get(unit); if (!e) return;
    const anims = e.inst.state.data.skeletonData.animations.map(a => a.name);
    const dead = anims.find(a => /dead|die|death/i.test(a));
    if (dead) e.inst.state.setAnimation(0, dead, false);
    e.fadeStart = performance.now();
  }

  triggerPlayerAttack() {
    this._triggerAttack(this.playerInst);
  }

  // 적 공격 애니메이션 트리거
  triggerEnemyAttack(unit) {
    const e = this.enemies.get(unit);
    if (!e) return;
    this._triggerAttack(e.inst);
  }

  resetSpawnSlots() { this.spawnSlot = 0; }

  // ── 이동 업데이트 (매 프레임) ──
  updateMovement(dt) {
    for (const [unit, e] of this.enemies) {
      if (!unit.alive || e.fadeStart !== null) continue;
      if (unit.state !== 'approaching') continue;

      const speed = unit.moveSpeed || 80;
      const dx = e.targetX - e.x;
      if (Math.abs(dx) > 2) {
        const move = Math.sign(dx) * speed * dt;
        e.x += Math.abs(move) < Math.abs(dx) ? move : dx;
        e.inst.skeleton.x = e.x;
      }

      // 목표 도달 → combat 전환
      if (Math.abs(e.x - e.targetX) < 5) {
        e.x = e.targetX;
        e.inst.skeleton.x = e.x;
        if (this.board) this.board.unitEnteredCombat(unit);
        this._tryPlay(e.inst.state, ['idle', 'wait', 'stand'], true);
      }
    }
  }

  // ── 렌더 ──
  render(delta) {
    this.updateMovement(delta);

    const gl = this.gl, c = this.canvas;
    gl.clearColor(0, 0, 0, 0);
    gl.clear(gl.COLOR_BUFFER_BIT);
    this.mvp.ortho2d(0, 0, c.width - 1, c.height - 1);
    this.shader.bind();
    this.shader.setUniformi(spine.Shader.SAMPLER, 0);
    this.shader.setUniform4x4f(spine.Shader.MVP_MATRIX, this.mvp.values);
    this.batcher.begin(this.shader);

    // 플레이어
    if (this.playerInst) {
      const sk = this.playerInst.skeleton, st = this.playerInst.state;
      sk.x = c.width * PLAYER_POS.xRatio;
      sk.y = c.height * PLAYER_POS.yRatio;
      st.update(delta); st.apply(sk);
      sk.updateWorldTransform(spine.Physics.update);
      this.skeletonRenderer.draw(this.batcher, sk);
    }

    // 적
    const now = performance.now();
    for (const [unit, e] of this.enemies) {
      if (!e.inst) continue;
      if (e.fadeStart !== null) {
        const t = (now - e.fadeStart) / 600;
        if (t >= 1) { this.enemies.delete(unit); continue; }
        e.inst.skeleton.color.a = 1 - t;
      }
      e.inst.state.update(delta); e.inst.state.apply(e.inst.skeleton);
      e.inst.skeleton.updateWorldTransform(spine.Physics.update);
      this.skeletonRenderer.draw(this.batcher, e.inst.skeleton);
    }

    this.batcher.end();
    this.shader.unbind();
  }

  getEnemyPos(unit) {
    const e = this.enemies.get(unit);
    return e ? { x: e.x, y: e.y } : null;
  }

  // ── 내부 헬퍼 ──
  _makeInst(data) {
    const sk = new spine.Skeleton(data);
    if (data.defaultSkin) sk.setSkin(data.defaultSkin);
    else if (data.skins?.length) sk.setSkin(data.skins[0]);
    sk.setSlotsToSetupPose();
    const sd = new spine.AnimationStateData(data); sd.defaultMix = 0.15;
    return { skeleton: sk, state: new spine.AnimationState(sd) };
  }

  _tryPlay(state, candidates, loop = true) {
    const anims = state.data.skeletonData.animations.map(a => a.name);
    for (const c of candidates) {
      const f = anims.find(a => a.toLowerCase().includes(c.toLowerCase()));
      if (f) { state.setAnimation(0, f, loop); return f; }
    }
    if (anims.length) { state.setAnimation(0, anims[0], loop); return anims[0]; }
    return null;
  }

  _triggerAttack(inst) {
    if (!inst) return;
    const anims = inst.state.data.skeletonData.animations.map(a => a.name);
    const atk = anims.find(a => /attack|atk|hit/i.test(a));
    if (atk) {
      inst.state.setAnimation(0, atk, false);
      inst.state.addAnimation(0, anims.find(a => /idle|wait|stand/i.test(a)) || anims[0], true, 0);
    }
  }

  _resizeCanvas() {
    const wrap = document.getElementById('stageWrap');
    if (!wrap) return;
    const r = wrap.getBoundingClientRect();
    this.canvas.width = r.width; this.canvas.height = r.height;
    this.gl.viewport(0, 0, this.canvas.width, this.canvas.height);
  }

  destroy() { window.removeEventListener('resize', this._onResize); }
}
