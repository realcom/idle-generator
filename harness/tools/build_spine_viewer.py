#!/usr/bin/env python3
"""
build_spine_viewer.py — idlez Spine(4.2) 에셋을 self-contained HTML 뷰어로 묶는다.

핵심: spine-webgl 런타임을 인라인 임베드(CDN 불필요)하고, atlas를 *raw 문자열*로 전달한다.
(data URI 디코딩을 안 거치므로 한글 region 이름이 깨지지 않음 — 이전 "Region not found" 버그의 근본 해결)

사용: python3 harness/tools/build_spine_viewer.py
출력: harness/runtime/spine-viewer.html (런타임+에셋 전부 임베드, 인터넷/CDN 불필요)
"""
import argparse
import os, base64, json
from pathlib import Path

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
VENDOR = os.path.join(ROOT, "runtime", "vendor")
DEFAULT_SRC = os.path.join(ROOT, "examples", "patchresources", "Units")
DEFAULT_OUT = os.path.join(ROOT, "runtime", "spine-viewer.html")

UNITS = [
    ("용사 햄찌",   "hamsterAngel",            "Characters/Assets"),
    ("해적 슬라임", "melee_slime3_pirate",     "Monsters/Assets"),
    ("슬라임 보스", "large_melee_slime_boss",  "Monsters/Assets"),
    ("펫 래비",     "Rabbie",                  "Pets/Assets"),
]

def b64(path):
    return base64.b64encode(open(path, "rb").read()).decode()


def parse_args():
    parser = argparse.ArgumentParser(description="Build a self-contained Spine viewer for idlez PatchResources assets.")
    parser.add_argument(
        "--src",
        default=DEFAULT_SRC,
        help="Units directory containing Characters/Assets, Monsters/Assets, Pets/Assets.",
    )
    parser.add_argument(
        "--out",
        default=DEFAULT_OUT,
        help="Output HTML path.",
    )
    return parser.parse_args()


args = parse_args()
src = Path(args.src).resolve()
out_path = Path(args.out).resolve()

configs, cards = [], []
for kr, base, sub in UNITS:
    d = src / sub
    skel = os.path.join(d, base + ".skel.bytes")
    atlas_txt = open(os.path.join(d, base + ".atlas.txt"), encoding="utf-8").read()
    png_name = atlas_txt.splitlines()[0].strip()
    png = os.path.join(d, png_name)
    if not (os.path.exists(skel) and os.path.exists(png)):
        print("SKIP", base); continue
    cid = "sp-" + base
    configs.append({
        "id": cid,
        "atlas": atlas_txt,                                    # ★ raw 문자열 (디코딩 안 함)
        "skel": b64(skel),                                     # base64 → 런타임에서 Uint8Array
        "png": "data:image/png;base64," + b64(png),           # 이미지는 base64 데이터URI(인코딩 무관)
    })
    cards.append(
        f'<div class="card"><div class="cap">{kr} <span>{base}</span></div>'
        f'<canvas id="{cid}" class="cv"></canvas>'
        f'<select id="{cid}-anim" class="anim"><option>(로딩…)</option></select></div>'
    )
    print("embedded:", base)

SPINE_JS = open(os.path.join(VENDOR, "spine-webgl.min.js"), encoding="utf-8").read()
CFG = json.dumps(configs, ensure_ascii=False)

HTML = """<!DOCTYPE html>
<html lang="ko"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>idlez 하네스 — Spine 뷰어 (4.2, self-contained)</title>
<style>
:root{--bg:#f6f5f0;--tx:#2c2c2a;--tx2:#5f5e5a;--line:rgba(0,0,0,.12)}
body{margin:0;background:var(--bg);color:var(--tx);font-family:system-ui,-apple-system,"Apple SD Gothic Neo","Malgun Gothic",sans-serif}
.page{max-width:760px;margin:0 auto;padding:24px 16px 40px}
h1{font-size:18px;font-weight:500;margin:0 0 4px}
.sub{font-size:13px;color:var(--tx2);margin:0 0 18px;line-height:1.6}
.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:14px}
.card{background:#fff;border:0.5px solid var(--line);border-radius:12px;padding:12px}
.cap{font-size:13px;font-weight:500;margin-bottom:8px}.cap span{color:var(--tx2);font-weight:400;font-size:12px}
.cv{width:100%;height:280px;background:#eef0e6;border-radius:8px;display:block}
.anim{margin-top:8px;width:100%;font-size:13px;padding:5px;border-radius:6px;border:0.5px solid var(--line)}
.err{color:#a33;font-size:12px;padding:8px;text-align:center}
.foot{font-size:12px;color:var(--tx2);margin-top:18px;line-height:1.7}
code{background:#efeee8;padding:1px 5px;border-radius:5px;font-size:12px}
</style></head>
<body><div class="page">
<h1>idlez 하네스 · Spine 뷰어 (4.2)</h1>
<p class="sub">idlez <code>PatchResources</code>의 Spine 4.2 에셋을 spine-webgl로 직접 렌더(런타임·에셋 전부 임베드, CDN/인터넷 불필요). 드롭다운으로 애니메이션을 바꿔보세요.</p>
<div class="grid">__CARDS__</div>
<p class="foot">에셋 출처: idlez <code>Units/{Characters,Monsters,Pets}/Assets</code> (Spine 4.2.43). atlas는 raw 문자열로 전달해 한글 부위 이름 인코딩 문제를 회피했습니다.</p>
</div>
<script>__SPINEJS__</script>
<script>
var CONFIGS=__CFG__;
function b64bytes(b64){var bin=atob(b64),a=new Uint8Array(bin.length);for(var i=0;i<bin.length;i++)a[i]=bin.charCodeAt(i);return a;}
function setErr(id,msg){var e=document.getElementById(id);if(e){var p=e.parentNode;e.style.display='none';var s=document.getElementById(id+'-anim');if(s)s.style.display='none';var d=document.createElement('div');d.className='err';d.textContent='에러: '+msg;p.appendChild(d);}}
function initUnit(cfg){
  var canvas=document.getElementById(cfg.id);
  canvas.width=Math.max(240,canvas.clientWidth||260);canvas.height=280;
  var gl=canvas.getContext("webgl",{alpha:true,premultipliedAlpha:true})||canvas.getContext("experimental-webgl");
  if(!gl){setErr(cfg.id,"WebGL 미지원");return;}
  var renderer;
  try{renderer=new spine.SceneRenderer(canvas,gl);}catch(e){setErr(cfg.id,"renderer "+e.message);return;}
  var img=new Image();
  img.onerror=function(){setErr(cfg.id,"texture 로드 실패");};
  img.onload=function(){
    try{
      var tex=new spine.GLTexture(gl,img);
      var atlas=new spine.TextureAtlas(cfg.atlas);
      atlas.pages.forEach(function(p){p.setTexture(tex);});
      var bin=new spine.SkeletonBinary(new spine.AtlasAttachmentLoader(atlas));
      var data=bin.readSkeletonData(b64bytes(cfg.skel));
      var skeleton=new spine.Skeleton(data);
      var asd=new spine.AnimationStateData(data);asd.defaultMix=0.2;
      var state=new spine.AnimationState(asd);
      var sel=document.getElementById(cfg.id+'-anim');sel.innerHTML='';
      data.animations.forEach(function(a){var o=document.createElement('option');o.value=a.name;o.textContent=a.name;sel.appendChild(o);});
      var first=data.animations.length?data.animations[0].name:null;
      if(first){state.setAnimation(0,first,true);sel.value=first;}else{sel.innerHTML='<option>(애니메이션 없음)</option>';}
      sel.onchange=function(){state.setAnimation(0,sel.value,true);};
      var PH=(spine.Physics&&spine.Physics.update)!==undefined?spine.Physics.update:undefined;
      skeleton.setToSetupPose();skeleton.updateWorldTransform(PH);
      var off=new spine.Vector2(),size=new spine.Vector2();skeleton.getBounds(off,size,[]);
      var cx=off.x+size.x/2,cy=off.y+size.y/2;
      var last=performance.now();
      function frame(now){
        var dt=Math.min(0.05,(now-last)/1000);last=now;
        state.update(dt);state.apply(skeleton);skeleton.updateWorldTransform(PH);
        gl.clearColor(0,0,0,0);gl.clear(gl.COLOR_BUFFER_BIT);
        renderer.resize(spine.ResizeMode.Expand);
        var vw=renderer.camera.viewportWidth,vh=renderer.camera.viewportHeight;
        var zoom=Math.max(size.x/vw,size.y/vh)*1.5;if(!isFinite(zoom)||zoom<=0)zoom=1;
        renderer.camera.zoom=zoom;renderer.camera.position.x=cx;renderer.camera.position.y=cy;
        renderer.begin();renderer.drawSkeleton(skeleton,true);renderer.end();
        requestAnimationFrame(frame);
      }
      requestAnimationFrame(frame);
    }catch(e){setErr(cfg.id,e.message);}
  };
  img.src=cfg.png;
}
function start(){
  if(!window.spine||!spine.SceneRenderer){CONFIGS.forEach(function(c){setErr(c.id,"spine 런타임 로드 실패");});return;}
  CONFIGS.forEach(initUnit);
}
if(document.readyState!=='loading')start();else window.addEventListener('DOMContentLoaded',start);
</script>
</body></html>"""

out = (HTML.replace("__CARDS__", "\n".join(cards))
           .replace("__CFG__", CFG)
           .replace("__SPINEJS__", SPINE_JS.replace("</script", "<\\/script")))
out_path.parent.mkdir(parents=True, exist_ok=True)
out_path.write_text(out, encoding="utf-8")
try:
    display_path = out_path.relative_to(Path(ROOT).parent)
except ValueError:
    display_path = out_path
print("written:", display_path, round(out_path.stat().st_size / 1048576, 2), "MB")
