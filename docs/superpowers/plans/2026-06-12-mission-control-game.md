# Mission Control Game — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add an interactive in-deck "Mission Control" sandbox slide to `physics-slideshow.html` where the class flies Orion's TLI burn and watches a real F=Gm₁m₂/r² gravity simulation produce the free-return figure-eight, with live KE/PE energy bars.

**Architecture:** One new `<section>` (slide 17) plus one self-contained vanilla-JS `<script>` (canvas 2-D, no libraries) appended at end of body. The Works Cited slide is renumbered 18. The game runs its `requestAnimationFrame` loop only while its slide carries `data-deck-active` (a MutationObserver gates it). All interaction is pointer (mouse/touch); zero keyboard handlers so deck-stage keeps global arrow/space nav.

**Tech stack:** Plain HTML + Canvas 2D + vanilla JS in the existing single file. Node (already present via the project's Python? — no: use `node` for the Task-2 tuning sweep; if unavailable, run the sweep in the browser console). Verification via gstack `browse` (`/c/Users/erick/.claude/skills/gstack/browse/dist/browse`).

**TDD adaptation:** This is browser/canvas work with no unit-test runner. The "test" for each task is a concrete **browser verification** (render the file via `browse`, run `js`/`eval` assertions against live state, screenshot) plus a commit — the same harness used throughout this repo. Task 2 is the exception: it ships a runnable parameter-sweep that empirically proves a free-return window exists.

---

## File Structure

- **Modify** `physics-slideshow.html`:
  - Insert one `<section id="mc-slide" …>` immediately after slide 16 (`<!-- 16 — SUMMARY -->` section ends at the `</section>` before `<!-- 17 — SOURCES -->` near line 706).
  - Renumber the Works Cited kicker `17` → `18` (around line 709).
  - Append one `<script id="mc-game">…</script>` at the very end of `<body>`, **after** the deck-stage `</script>` (which ends near line 728, before `</body>`).
- **Create (temporary, not committed)** `_sweep.mjs` — the Task-2 tuning harness. Deleted after constants are recorded.
- All game code is mouse-only and dependency-free; the file stays offline-safe (Google-Fonts webfont remains the only external load).

**The game `<script>` is one IIFE** with these named functions (defined once in Task 3; later tasks add the speaker-note text and verify): `fitCanvas`, `accel`, `energy`, `resetCraft`, `launch`, `stepSim`, `endFlight`, `draw`, `frame`, `setActive`, plus pointer handlers `onAimDown/Move/Up`, slider drag handler `makeSlider`, and button wiring.

---

## Task 1: Add the Mission Control slide markup + renumber Works Cited

**Files:**
- Modify: `physics-slideshow.html` (insert section after slide 16; renumber Works Cited kicker)

- [ ] **Step 1: Insert the new slide section after slide 16.** Find the end of the summary section — the lines:

```html
      <div class="mission-tag">STEERING, NOT BOOSTING</div>
    </div>
  </section>

  <!-- 17 — SOURCES -->
```

Replace that exact block with (keeps the summary close, inserts the game slide, leaves the sources comment):

```html
      <div class="mission-tag">STEERING, NOT BOOSTING</div>
    </div>
  </section>

  <!-- 17 — MISSION CONTROL (interactive sandbox) -->
  <section class="space" id="mc-slide" data-label="Mission Control" data-speaker-notes="PLACEHOLDER_NOTES">
    <div class="head anim">
      <div class="kicker"><span class="num">17</span> / MISSION CONTROL</div>
      <div style="font-size:54px;font-weight:700;line-height:1.04;letter-spacing:-.015em;">Fly It Yourself</div>
    </div>
    <div class="anim d1" style="flex:1;display:flex;gap:40px;min-height:0;margin-top:18px;">
      <div style="flex:1.55;min-width:0;display:flex;flex-direction:column;gap:14px;">
        <div style="position:relative;border:1px solid var(--line);border-radius:10px;overflow:hidden;background:#05070d;">
          <canvas id="mc-canvas" style="width:100%;display:block;aspect-ratio:1280/760;"></canvas>
          <div id="mc-banner" style="position:absolute;left:50%;top:18px;transform:translateX(-50%);font-family:var(--mono);font-size:24px;letter-spacing:.08em;text-shadow:0 1px 8px #000;opacity:0;transition:opacity .2s;"></div>
          <div id="mc-readout" style="position:absolute;left:14px;bottom:12px;font-family:var(--mono);font-size:18px;color:#8b94a6;text-shadow:0 1px 6px #000;"></div>
        </div>
        <div style="font-family:var(--mono);font-size:15px;color:var(--dim);">Drag from Earth to aim the burn · or use the sliders · then LAUNCH. Simplified: the Moon is held still — the real Moon's ~1 km/s motion is what enables a true free return.</div>
      </div>
      <div style="flex:1;min-width:240px;display:flex;flex-direction:column;gap:22px;">
        <div style="border:1px solid var(--line);border-radius:8px;background:var(--bg-2);padding:18px 20px;">
          <div style="font-family:var(--mono);font-size:var(--type-mono);letter-spacing:.14em;text-transform:uppercase;color:var(--muted);margin-bottom:14px;padding-bottom:8px;border-bottom:1px solid var(--line);">Energy (live)</div>
          <div style="display:flex;gap:22px;align-items:flex-end;height:200px;">
            <div style="display:flex;flex-direction:column;align-items:center;gap:8px;flex:1;height:100%;justify-content:flex-end;">
              <div style="width:38px;flex:1;display:flex;align-items:flex-end;background:#0e131f;border-radius:4px 4px 0 0;position:relative;">
                <div id="mc-ke" style="width:100%;height:0%;background:var(--orange);border-radius:4px 4px 0 0;"></div>
                <div id="mc-total" style="position:absolute;left:-6px;right:-6px;height:2px;background:#f3f5fa;bottom:0%;"></div>
              </div>
              <div style="font-family:var(--mono);font-size:18px;color:var(--orange);">KE</div>
            </div>
            <div style="display:flex;flex-direction:column;align-items:center;gap:8px;flex:1;height:100%;justify-content:flex-end;">
              <div style="width:38px;flex:1;display:flex;align-items:flex-end;background:#0e131f;border-radius:4px 4px 0 0;">
                <div id="mc-pe" style="width:100%;height:0%;background:var(--blue);border-radius:4px 4px 0 0;"></div>
              </div>
              <div style="font-family:var(--mono);font-size:18px;color:var(--blue);">PE</div>
            </div>
          </div>
          <div style="font-size:var(--type-small);color:var(--muted);margin-top:12px;line-height:1.3;">White line = total. It never moves while coasting — slide 13, live.</div>
        </div>
        <div style="display:flex;flex-direction:column;gap:16px;">
          <div>
            <div style="display:flex;justify-content:space-between;font-family:var(--mono);font-size:16px;color:var(--muted);margin-bottom:6px;"><span>BURN SPEED</span><span id="mc-spd-val" style="color:var(--orange);"></span></div>
            <div id="mc-spd" class="mc-slider" tabindex="-1" style="position:relative;height:10px;background:#0e131f;border:1px solid var(--line);border-radius:6px;cursor:pointer;"><div id="mc-spd-fill" style="position:absolute;left:0;top:0;bottom:0;background:var(--orange);opacity:.55;border-radius:6px 0 0 6px;"></div><div id="mc-spd-knob" style="position:absolute;top:50%;width:18px;height:18px;border-radius:50%;background:var(--orange);transform:translate(-50%,-50%);"></div></div>
          </div>
          <div>
            <div style="display:flex;justify-content:space-between;font-family:var(--mono);font-size:16px;color:var(--muted);margin-bottom:6px;"><span>BURN ANGLE</span><span id="mc-ang-val" style="color:var(--orange);"></span></div>
            <div id="mc-ang" class="mc-slider" tabindex="-1" style="position:relative;height:10px;background:#0e131f;border:1px solid var(--line);border-radius:6px;cursor:pointer;"><div id="mc-ang-fill" style="position:absolute;left:0;top:0;bottom:0;background:var(--orange);opacity:.55;border-radius:6px 0 0 6px;"></div><div id="mc-ang-knob" style="position:absolute;top:50%;width:18px;height:18px;border-radius:50%;background:var(--orange);transform:translate(-50%,-50%);"></div></div>
          </div>
          <div style="display:flex;gap:12px;margin-top:4px;">
            <button id="mc-launch" type="button" tabindex="-1" style="flex:1;font-family:var(--mono);font-size:18px;letter-spacing:.1em;text-transform:uppercase;color:#05070d;background:var(--orange);border:none;border-radius:6px;padding:12px 0;cursor:pointer;">Launch</button>
            <button id="mc-reset" type="button" tabindex="-1" style="font-family:var(--mono);font-size:16px;letter-spacing:.08em;text-transform:uppercase;color:var(--text);background:transparent;border:1px solid var(--line);border-radius:6px;padding:12px 16px;cursor:pointer;">Reset</button>
            <button id="mc-clear" type="button" tabindex="-1" style="font-family:var(--mono);font-size:16px;letter-spacing:.08em;text-transform:uppercase;color:var(--dim);background:transparent;border:1px solid var(--line);border-radius:6px;padding:12px 16px;cursor:pointer;">Trails</button>
          </div>
        </div>
      </div>
    </div>
    <div class="footer anim d2">
      <div class="presenter"><span class="dot"></span>Elvin &nbsp;·&nbsp; Leon &nbsp;·&nbsp; Eric</div>
      <div class="mission-tag">REAL PHYSICS · F = Gm₁m₂/r²</div>
    </div>
  </section>

  <!-- 18 — SOURCES -->
```

- [ ] **Step 2: Renumber the Works Cited kicker.** Find:

```html
      <div class="kicker"><span class="num">17</span> / WORKS CITED</div>
```

Replace with:

```html
      <div class="kicker"><span class="num">18</span> / WORKS CITED</div>
```

- [ ] **Step 3: Verify the deck still loads with 18 slides and no errors.**

Run:
```bash
cd "C:/work/School/U11Physics/ISU"
B="/c/Users/erick/.claude/skills/gstack/browse/dist/browse"
"$B" goto "file://./physics-slideshow.html" >/dev/null 2>&1; sleep 1.3
"$B" js "document.querySelectorAll('deck-stage > section').length"
"$B" console --errors 2>&1 | grep -ci "error:" || echo 0
```
Expected: `18` and `0`.

- [ ] **Step 4: Commit.**
```bash
git add physics-slideshow.html
git commit -m "feat(game): add Mission Control slide shell + renumber Works Cited to 18"
```

---

## Task 2: Tune the physics so a free-return window exists

**Files:**
- Create (temp): `_sweep.mjs`

- [ ] **Step 1: Write the sweep harness.** It uses the SAME physics the game will use, sweeps burn speed × angle, classifies each flight, and prints the contiguous "return-to-Earth" window.

Create `_sweep.mjs`:
```js
// Tuning sweep for Mission Control. Mirrors the game's physics exactly.
const EARTH={x:300,y:380,GM:7.5e6,draw:40,atmo:60};
const MOON ={x:1000,y:380,GM:0.95e6,draw:22,infl:140,coll:26};
const START={x:300,y:312};
const SUBSTEPS=12, DT=0.0022, MAXT=14, PAD=260, W=1280, H=760;
function accel(x,y){
  const dxe=EARTH.x-x,dye=EARTH.y-y,re2=dxe*dxe+dye*dye,re=Math.sqrt(re2);
  const dxm=MOON.x-x,dym=MOON.y-y,rm2=dxm*dxm+dym*dym,rm=Math.sqrt(rm2);
  const ae=EARTH.GM/(re2*re),am=MOON.GM/(rm2*rm);
  return [ae*dxe+am*dxm, ae*dye+am*dym, re, rm];
}
function sim(speed,angDeg){
  const a=angDeg*Math.PI/180;
  let x=START.x,y=START.y,vx=Math.cos(a)*speed,vy=Math.sin(a)*speed,t=0,enteredMoon=false;
  while(t<MAXT){
    for(let s=0;s<SUBSTEPS;s++){
      const [ax,ay,re,rm]=accel(x,y);
      vx+=ax*DT; vy+=ay*DT; x+=vx*DT; y+=vy*DT; t+=DT;
      if(rm<MOON.infl) enteredMoon=true;
      if(rm<MOON.coll) return 'impact';
      if(re<EARTH.atmo && t>0.2) return enteredMoon?'return':'fellback';
      if(x<-PAD||x>W+PAD||y<-PAD||y>H+PAD) return 'escape';
    }
  }
  return 'orbit';
}
const speeds=[], angles=[];
for(let s=300;s<=520;s+=4) speeds.push(s);
for(let a=-60;a<=-2;a+=2) angles.push(a);
let returns=[];
for(const s of speeds) for(const a of angles) if(sim(s,a)==='return') returns.push([s,a]);
console.log('return-window cells:', returns.length, 'of', speeds.length*angles.length);
if(returns.length){
  const ss=returns.map(r=>r[0]), as=returns.map(r=>r[1]);
  const cs=Math.round(ss.reduce((p,c)=>p+c,0)/ss.length);
  const ca=Math.round(as.reduce((p,c)=>p+c,0)/as.length);
  console.log('speed range', Math.min(...ss),'-',Math.max(...ss),' angle range', Math.min(...as),'-',Math.max(...as));
  console.log('SUGGESTED DEFAULTS  speed='+cs+'  angle='+ca);
}
```

- [ ] **Step 2: Run it.**
```bash
cd "C:/work/School/U11Physics/ISU" && node _sweep.mjs
```
Expected: a non-trivial window (aim for **≥ 25 return cells**, contiguous) and a `SUGGESTED DEFAULTS speed=… angle=…` line.

- [ ] **Step 3: If the window is empty or tiny (<15 cells), adjust and re-run** (edit `_sweep.mjs`, then re-run Step 2):
  - Window empty, everything `escape`: lower the speed sweep / raise `EARTH.GM` (e.g., 8.5e6).
  - Everything `fellback`/`orbit`: raise the speed sweep upper bound; lower `EARTH.GM` slightly.
  - Craft never bends back at the Moon: raise `MOON.GM` (e.g., 1.2e6) or widen `MOON.infl`.
  - Too many `impact`: shrink `MOON.coll` (e.g., 20) or widen the angle sweep.
  Iterate until ≥ 25 contiguous return cells. **Record the final `EARTH.GM`, `MOON.GM`, and the SUGGESTED DEFAULTS** — these are the source of truth for Task 3 (use the exact same constant values).

- [ ] **Step 4: Record results + delete the harness.**
```bash
cd "C:/work/School/U11Physics/ISU"
# Paste the final constants + defaults into a scratch note in the commit message below, then:
rm _sweep.mjs
```
There is nothing to commit here yet (harness is deleted). The recorded numbers flow into Task 3. (If `node` is unavailable, paste the body of `sim()`+the sweep loop into the browser console on any page and read the same output; record identically.)

---

## Task 3: Build the game — physics, canvas, render loop, visibility gating

**Files:**
- Modify: `physics-slideshow.html` (append `<script id="mc-game">` before `</body>`, after the deck-stage `</script>`)

> Replace the four constant values marked `/* from Task 2 */` with the **exact** values you recorded in Task 2 (`EARTH.GM`, `MOON.GM`, default `SPD0`, default `ANG0`). The values shown are the expected sweep result; if your sweep produced different numbers, use yours.

- [ ] **Step 1: Append the game script.** Find the end of file:

```html
  if (!customElements.get('deck-stage')) {
    customElements.define('deck-stage', DeckStage);
  }
})();

</script>


</body></html>
```

Replace with (same deck-stage close, then the new game script, then body close):

```html
  if (!customElements.get('deck-stage')) {
    customElements.define('deck-stage', DeckStage);
  }
})();

</script>

<script id="mc-game">
(function(){
  const sec = document.getElementById('mc-slide');
  if(!sec) return;
  const cv = document.getElementById('mc-canvas');
  const ctx = cv.getContext('2d');
  const W=1280, H=760;
  function fitCanvas(){ const r=Math.min(window.devicePixelRatio||1,2); cv.width=W*r; cv.height=H*r; ctx.setTransform(r,0,0,r,0,0); }
  fitCanvas();

  // ---- world constants (FROM TASK 2 SWEEP) ----
  const EARTH={x:300,y:380,GM:7.5e6,draw:40,atmo:60};      /* from Task 2 */
  const MOON ={x:1000,y:380,GM:0.95e6,draw:22,infl:140,coll:26}; /* from Task 2 */
  const START={x:300,y:312};
  const SUBSTEPS=12, DT=0.0022, MAXT=14, PAD=260;
  const SPD0=420 /* from Task 2 */, ANG0=-24 /* from Task 2 */;
  const SPD_MIN=300, SPD_MAX=520, ANG_MIN=-60, ANG_MAX=-2;
  const KMS=0.0095; // game-speed -> km/s label factor (display only)

  // ---- state ----
  let burnSpeed=SPD0, burnAngle=ANG0;
  let craft=null, ghosts=[], outcome=null;
  let aiming=false, dragNow=null;
  let raf=null, active=false, lastE=null;

  // ---- physics ----
  function accel(x,y){
    const dxe=EARTH.x-x,dye=EARTH.y-y,re2=dxe*dxe+dye*dye,re=Math.sqrt(re2);
    const dxm=MOON.x-x,dym=MOON.y-y,rm2=dxm*dxm+dym*dym,rm=Math.sqrt(rm2);
    const ae=EARTH.GM/(re2*re),am=MOON.GM/(rm2*rm);
    return [ae*dxe+am*dxm, ae*dye+am*dym, re, rm];
  }
  function energy(c){
    const v2=c.vx*c.vx+c.vy*c.vy;
    const re=Math.hypot(EARTH.x-c.x,EARTH.y-c.y), rm=Math.hypot(MOON.x-c.x,MOON.y-c.y);
    const KE=0.5*v2, PE=-(EARTH.GM/re)-(MOON.GM/rm);
    return {KE,PE,tot:KE+PE};
  }
  function launch(){
    const a=burnAngle*Math.PI/180;
    craft={x:START.x,y:START.y,vx:Math.cos(a)*burnSpeed,vy:Math.sin(a)*burnSpeed,t:0,trail:[START.x,START.y],enteredMoon:false};
    outcome=null; lastE=energy(craft);
  }
  function endFlight(type,label,color){
    outcome={type,label,color};
    if(craft&&craft.trail.length>4){ ghosts.push(craft.trail.slice()); if(ghosts.length>8) ghosts.shift(); }
    showBanner(label,color);
  }
  function stepSim(){
    if(!craft||outcome) return;
    for(let s=0;s<SUBSTEPS;s++){
      const [ax,ay,re,rm]=accel(craft.x,craft.y);
      craft.vx+=ax*DT; craft.vy+=ay*DT;
      craft.x+=craft.vx*DT; craft.y+=craft.vy*DT; craft.t+=DT;
      if(rm<MOON.infl) craft.enteredMoon=true;
      if(rm<MOON.coll){ endFlight('impact','IMPACT — too close','#ff5a5a'); break; }
      if(re<EARTH.atmo && craft.t>0.2){
        if(craft.enteredMoon) endFlight('return','FREE RETURN!','#ff7a45');
        else endFlight('fellback','FELL BACK — too slow','#5b9bff');
        break;
      }
      if(craft.x<-PAD||craft.x>W+PAD||craft.y<-PAD||craft.y>H+PAD){ endFlight('escape','ESCAPED — too fast','#8b94a6'); break; }
      if(craft.t>MAXT){ endFlight('orbit','STILL ORBITING — try again','#8b94a6'); break; }
    }
    craft.trail.push(craft.x,craft.y);
    lastE=energy(craft);
  }

  // ---- drawing ----
  function sphere(x,y,r,c0,c1){
    const g=ctx.createRadialGradient(x-r*0.35,y-r*0.35,r*0.1,x,y,r);
    g.addColorStop(0,c0); g.addColorStop(1,c1);
    ctx.fillStyle=g; ctx.beginPath(); ctx.arc(x,y,r,0,7); ctx.fill();
  }
  let stars=null;
  function drawStars(){
    if(!stars){ stars=[]; let seed=7; const rnd=()=>{seed=(seed*9301+49297)%233280; return seed/233280;};
      for(let i=0;i<140;i++) stars.push([rnd()*W,rnd()*H,rnd()*1.4+0.3,rnd()*0.5+0.2]); }
    for(const s of stars){ ctx.fillStyle='rgba(255,255,255,'+s[3]+')'; ctx.fillRect(s[0],s[1],s[2],s[2]); }
  }
  function polyline(t,color,width,alpha){
    if(t.length<4) return;
    ctx.strokeStyle=color; ctx.globalAlpha=alpha; ctx.lineWidth=width; ctx.lineJoin='round';
    ctx.beginPath(); ctx.moveTo(t[0],t[1]);
    for(let i=2;i<t.length;i+=2) ctx.lineTo(t[i],t[i+1]);
    ctx.stroke(); ctx.globalAlpha=1;
  }
  function draw(){
    ctx.fillStyle='#05070d'; ctx.fillRect(0,0,W,H);
    drawStars();
    // parking-orbit hint
    ctx.strokeStyle='#1d2737'; ctx.setLineDash([4,8]); ctx.lineWidth=2;
    ctx.beginPath(); ctx.arc(EARTH.x,EARTH.y,EARTH.y-START.y,0,7); ctx.stroke(); ctx.setLineDash([]);
    // ghosts
    for(const g of ghosts) polyline(g,'#ff7a45',2,0.18);
    // bodies
    sphere(EARTH.x,EARTH.y,EARTH.draw,'#8ec0ff','#173a78');
    sphere(MOON.x,MOON.y,MOON.draw,'#e9edf3','#6e7685');
    // current trail
    if(craft) polyline(craft.trail, outcome&&outcome.type==='return'?'#ff7a45':'#ffae8a', 3.5, outcome?0.95:0.95);
    // craft dot
    if(craft&&!outcome){ ctx.fillStyle='#fff'; ctx.beginPath(); ctx.arc(craft.x,craft.y,4,0,7); ctx.fill(); }
    // aim vector preview
    if(aiming&&dragNow){
      ctx.strokeStyle='#ff7a45'; ctx.lineWidth=3; ctx.beginPath();
      ctx.moveTo(START.x,START.y); ctx.lineTo(dragNow.x,dragNow.y); ctx.stroke();
      ctx.fillStyle='#ff7a45'; ctx.beginPath(); ctx.arc(dragNow.x,dragNow.y,5,0,7); ctx.fill();
    }
  }

  // ---- HUD ----
  const elKE=document.getElementById('mc-ke'), elPE=document.getElementById('mc-pe'), elTot=document.getElementById('mc-total');
  const elBanner=document.getElementById('mc-banner'), elRead=document.getElementById('mc-readout');
  const elSpdV=document.getElementById('mc-spd-val'), elAngV=document.getElementById('mc-ang-val');
  let bannerTimer=null;
  function showBanner(text,color){ elBanner.textContent=text; elBanner.style.color=color; elBanner.style.opacity='1';
    clearTimeout(bannerTimer); bannerTimer=setTimeout(()=>{ if(!craft||outcome) return; },10); }
  function updateHUD(){
    elSpdV.textContent=(burnSpeed*KMS).toFixed(2)+' km/s';
    elAngV.textContent=Math.round(burnAngle)+'°';
    elRead.textContent = craft&&!outcome ? 't = '+craft.t.toFixed(1)+' s'
      : 'speed '+(burnSpeed*KMS).toFixed(2)+' km/s · angle '+Math.round(burnAngle)+'°';
    // energy bars (Task 6 fills these; baseline here)
    if(lastE){
      const ref=Math.abs(EARTH.GM/EARTH.atmo)+0.5*SPD_MAX*SPD_MAX; // scale
      const keH=Math.max(0,Math.min(100, lastE.KE/ref*100*2));
      const peSpan=EARTH.GM/EARTH.atmo; const peH=Math.max(0,Math.min(100,(peSpan+lastE.PE)/peSpan*100));
      const totH=Math.max(0,Math.min(100,(peSpan+lastE.tot)/peSpan*100 + lastE.KE/ref*100*2));
      elKE.style.height=keH+'%'; elPE.style.height=peH+'%'; elTot.style.bottom=Math.min(100,totH)+'%';
    }
  }

  // ---- loop + visibility gating ----
  function frame(){ if(!active) return; stepSim(); draw(); updateHUD(); raf=requestAnimationFrame(frame); }
  function setActive(on){
    active=on;
    if(on){ fitCanvas(); if(!craft) launch(); cancelAnimationFrame(raf); raf=requestAnimationFrame(frame); }
    else { cancelAnimationFrame(raf); raf=null; }
  }
  const mo=new MutationObserver(()=>{ setActive(sec.hasAttribute('data-deck-active')); });
  mo.observe(sec,{attributes:true,attributeFilter:['data-deck-active']});
  // initial state (in case the deck deep-links to this slide)
  setActive(sec.hasAttribute('data-deck-active'));
  // expose for verification
  window.__mc={ get craft(){return craft;}, get outcome(){return outcome;}, get active(){return active;},
    set:(s,a)=>{burnSpeed=s;burnAngle=a;}, launch, energy:()=>lastE };

  // Interaction (Task 4) and energy polish (Task 6) are wired below.
})();
</script>


</body></html>
```

- [ ] **Step 2: Verify it animates only when the slide is active, and pauses otherwise.**

```bash
cd "C:/work/School/U11Physics/ISU"
B="/c/Users/erick/.claude/skills/gstack/browse/dist/browse"
"$B" goto "file://./physics-slideshow.html" >/dev/null 2>&1; sleep 1.2
echo -n "active on slide 1 (should be false): "; "$B" js "window.__mc.active"
# jump to the game slide (slide 17): press 0 ->10, then ArrowRight x7 -> 17
"$B" press "0" >/dev/null 2>&1; for i in 1 2 3 4 5 6 7; do "$B" press ArrowRight >/dev/null 2>&1; done; sleep 1.0
echo -n "active on game slide (should be true): "; "$B" js "window.__mc.active"
echo -n "craft advanced (t>0): "; "$B" js "window.__mc.craft ? window.__mc.craft.t>0 : false"
echo -n "console errors: "; "$B" console --errors 2>&1 | grep -ci "error:" || echo 0
"$B" screenshot /tmp/mc3.png >/dev/null 2>&1
```
Expected: `false`, then `true`, `true`, `0`. Then Read `/tmp/mc3.png` (via the Read tool) and confirm a default trajectory is drawn with Earth/Moon. If the default launch escapes/falls-back instead of free-returning, the Task-2 constants need another sweep iteration — fix and re-verify.

- [ ] **Step 3: Commit.**
```bash
git add physics-slideshow.html
git commit -m "feat(game): physics sim, canvas render, visibility-gated loop"
```

---

## Task 4: Interaction — drag-to-aim, custom sliders, buttons (mouse only)

**Files:**
- Modify: `physics-slideshow.html` (replace the comment line `// Interaction (Task 4)…` inside the game IIFE with the wiring below)

> All controls are pointer-driven. Buttons/sliders are `tabindex="-1"`; every handler `blur()`s the active element on pointerup so no control keeps keyboard focus — deck-stage keeps its global arrow/space nav and the game adds **zero** keyboard handlers.

- [ ] **Step 1: Replace the trailing comment** `  // Interaction (Task 4) and energy polish (Task 6) are wired below.` with:

```js
  // ---- canvas drag-to-aim ----
  function canvasPos(e){ const r=cv.getBoundingClientRect(); return {x:(e.clientX-r.left)/r.width*W, y:(e.clientY-r.top)/r.height*H}; }
  function onAimDown(e){ const p=canvasPos(e); if(Math.hypot(p.x-START.x,p.y-START.y)<240){ aiming=true; dragNow=p; e.stopPropagation(); e.preventDefault(); } }
  function onAimMove(e){ if(!aiming) return; dragNow=canvasPos(e); const dx=dragNow.x-START.x, dy=dragNow.y-START.y;
    burnAngle=Math.max(ANG_MIN,Math.min(ANG_MAX, Math.atan2(dy,dx)*180/Math.PI));
    burnSpeed=Math.max(SPD_MIN,Math.min(SPD_MAX, Math.hypot(dx,dy)*2.2));
    syncSliders(); e.stopPropagation(); }
  function onAimUp(e){ if(!aiming) return; aiming=false; dragNow=null; launch(); e.stopPropagation(); }
  cv.addEventListener('pointerdown',onAimDown);
  window.addEventListener('pointermove',onAimMove);
  window.addEventListener('pointerup',onAimUp);

  // ---- custom pointer sliders (no native range -> no keyboard surface) ----
  function makeSlider(id,min,max,get,setv){
    const track=document.getElementById(id), knob=document.getElementById(id+'-knob'), fill=document.getElementById(id+'-fill');
    function place(){ const f=(get()-min)/(max-min); knob.style.left=(f*100)+'%'; fill.style.width=(f*100)+'%'; }
    function fromEvent(e){ const r=track.getBoundingClientRect(); const f=Math.max(0,Math.min(1,(e.clientX-r.left)/r.width)); setv(min+f*(max-min)); place(); updateHUD(); }
    let drag=false;
    track.addEventListener('pointerdown',e=>{ drag=true; fromEvent(e); e.stopPropagation(); e.preventDefault(); });
    window.addEventListener('pointermove',e=>{ if(drag) fromEvent(e); });
    window.addEventListener('pointerup',()=>{ if(drag){ drag=false; track.blur(); } });
    return {place};
  }
  const spdS=makeSlider('mc-spd',SPD_MIN,SPD_MAX,()=>burnSpeed,v=>{burnSpeed=v;});
  const angS=makeSlider('mc-ang',ANG_MIN,ANG_MAX,()=>burnAngle,v=>{burnAngle=v;});
  function syncSliders(){ spdS.place(); angS.place(); updateHUD(); }
  syncSliders();

  // ---- buttons ----
  function btn(id,fn){ const b=document.getElementById(id); b.addEventListener('click',e=>{ fn(); b.blur(); e.stopPropagation(); }); }
  btn('mc-launch',()=>launch());
  btn('mc-reset',()=>{ craft=null; outcome=null; elBanner.style.opacity='0'; lastE=null; });
  btn('mc-clear',()=>{ ghosts=[]; });
```

- [ ] **Step 2: Verify mouse interaction works and the deck keeps keyboard nav.**

```bash
cd "C:/work/School/U11Physics/ISU"
B="/c/Users/erick/.claude/skills/gstack/browse/dist/browse"
"$B" goto "file://./physics-slideshow.html" >/dev/null 2>&1; sleep 1.0
"$B" press "0" >/dev/null 2>&1; for i in 1 2 3 4 5 6 7; do "$B" press ArrowRight >/dev/null 2>&1; done; sleep 0.6
# programmatically set a known free-return burn (from Task 2 defaults) and relaunch
"$B" js "window.__mc.set(420,-24); window.__mc.launch(); 'set'" >/dev/null 2>&1
sleep 2.0
echo -n "outcome after default burn (expect return): "; "$B" js "window.__mc.outcome ? window.__mc.outcome.type : 'flying'"
# confirm keyboard still advances the deck from the game slide (no hijack): ArrowRight -> slide 18
"$B" press ArrowRight >/dev/null 2>&1; sleep 0.4
echo -n "url after ArrowRight (expect #18): "; "$B" url 2>&1 | tail -1
echo -n "errors: "; "$B" console --errors 2>&1 | grep -ci "error:" || echo 0
```
Expected: outcome `return` (the Task-2 default is a free return), URL ends `#18` (deck nav not hijacked), `0` errors. If outcome is not `return`, the Task-2 constants/defaults are off — re-tune.

- [ ] **Step 3: Commit.**
```bash
git add physics-slideshow.html
git commit -m "feat(game): mouse drag-aim, pointer sliders, buttons (no keyboard surface)"
```

---

## Task 5: Outcome banners + ghost trails verification

**Files:**
- Verify-only (banners + ghosts already implemented in Tasks 3–4). This task confirms all four outcomes trigger and ghosts accumulate.

- [ ] **Step 1: Drive each outcome programmatically and assert the banner type.**

```bash
cd "C:/work/School/U11Physics/ISU"
B="/c/Users/erick/.claude/skills/gstack/browse/dist/browse"
"$B" goto "file://./physics-slideshow.html" >/dev/null 2>&1; sleep 1.0
"$B" press "0" >/dev/null 2>&1; for i in 1 2 3 4 5 6 7; do "$B" press ArrowRight >/dev/null 2>&1; done; sleep 0.5
# helper: set burn, launch, wait, report outcome
for case in "520 -2 escape" "300 -58 fellback_or_orbit" "420 -24 return"; do
  set -- $case
  "$B" js "window.__mc.set($1,$2); window.__mc.launch(); 'go'" >/dev/null 2>&1; sleep 2.5
  echo "$1/$2 -> $("$B" js "window.__mc.outcome?window.__mc.outcome.type:'flying'" 2>&1 | tail -1)"
done
echo -n "ghosts accumulated: "; "$B" js "(window.__mc.craft, document.querySelectorAll('#mc-banner').length)"  # banner exists
```
Expected: the high-speed shallow shot `escape`s, the slow steep shot `fellback`/`orbit`/`impact` (any non-return), the default `return`s. Adjust the impact/escape cases only if needed to demonstrate each (the point is each branch is reachable). Read a screenshot to confirm the orange "FREE RETURN!" banner shows on the return case:
```bash
"$B" js "window.__mc.set(420,-24); window.__mc.launch(); 'go'" >/dev/null 2>&1; sleep 2.5
"$B" screenshot /tmp/mc5.png >/dev/null 2>&1
```
Read `/tmp/mc5.png` — confirm: free-return trajectory drawn, "FREE RETURN!" banner visible, at least one faint ghost trail from a prior attempt.

- [ ] **Step 2: Commit** (no code change expected; if the verification surfaced a fix, include it):
```bash
git add -A
git commit -m "test(game): verify all four outcomes + ghost trails" --allow-empty
```

---

## Task 6: Energy panel — live KE/PE bars with a static total

**Files:**
- Modify: `physics-slideshow.html` (the `updateHUD` energy block — replace with a calibrated version)

> The Task-3 `updateHUD` has a rough energy mapping. Replace it with one calibrated so the bars read well across a flight and the TOTAL line is visibly static while coasting (energy is conserved in the fixed-body field, so it should be near-constant by construction — this step makes it *visually* obvious).

- [ ] **Step 1: Replace the energy block inside `updateHUD`.** Find:

```js
    // energy bars (Task 6 fills these; baseline here)
    if(lastE){
      const ref=Math.abs(EARTH.GM/EARTH.atmo)+0.5*SPD_MAX*SPD_MAX; // scale
      const keH=Math.max(0,Math.min(100, lastE.KE/ref*100*2));
      const peSpan=EARTH.GM/EARTH.atmo; const peH=Math.max(0,Math.min(100,(peSpan+lastE.PE)/peSpan*100));
      const totH=Math.max(0,Math.min(100,(peSpan+lastE.tot)/peSpan*100 + lastE.KE/ref*100*2));
      elKE.style.height=keH+'%'; elPE.style.height=peH+'%'; elTot.style.bottom=Math.min(100,totH)+'%';
    }
```

Replace with:

```js
    // energy bars: map KE and shifted-PE onto a shared 0..100 scale so KE+PE = TOTAL visually
    if(lastE){
      // PE is negative; shift by PE_REF so PE_plot>=0. KE shares the same unit scale.
      const PE_REF = EARTH.GM/EARTH.atmo + MOON.GM/MOON.coll;   // most-negative PE bound
      const SCALE  = PE_REF;                                    // one unit scale for both bars
      const peU = (PE_REF + lastE.PE);                          // >=0 "height above the deepest well"
      const keU = lastE.KE;
      const toPct = u => Math.max(0, Math.min(100, u/SCALE*100));
      elKE.style.height = toPct(keU)+'%';
      elPE.style.height = toPct(peU)+'%';
      // TOTAL marker sits at KE+PE on the SAME scale, drawn from the bottom of the KE column
      elTot.style.bottom = Math.min(100, toPct(keU+peU))+'%';
    }
```

- [ ] **Step 2: Verify the bars move and the total stays put while coasting.** Sample energy at two times during one free-return flight and confirm `tot` barely changes (conserved) while KE/PE swing.

```bash
cd "C:/work/School/U11Physics/ISU"
B="/c/Users/erick/.claude/skills/gstack/browse/dist/browse"
"$B" goto "file://./physics-slideshow.html" >/dev/null 2>&1; sleep 1.0
"$B" press "0" >/dev/null 2>&1; for i in 1 2 3 4 5 6 7; do "$B" press ArrowRight >/dev/null 2>&1; done; sleep 0.5
"$B" js "window.__mc.set(420,-24); window.__mc.launch(); 'go'" >/dev/null 2>&1
sleep 0.6; E1=$("$B" js "var e=window.__mc.energy(); e?e.tot.toFixed(0)+'|'+e.KE.toFixed(0):'?'" 2>&1 | tail -1)
sleep 1.2; E2=$("$B" js "var e=window.__mc.energy(); e?e.tot.toFixed(0)+'|'+e.KE.toFixed(0):'?'" 2>&1 | tail -1)
echo "early tot|KE = $E1 ; later tot|KE = $E2  (tot should match within ~1%, KE should differ)"
"$B" screenshot /tmp/mc6.png >/dev/null 2>&1
```
Expected: the two `tot` values agree within ~1% (conserved); the two `KE` values differ (energy trading). Read `/tmp/mc6.png` — confirm KE/PE bars are sensible (KE tall when near the Moon, PE accordingly) and the white TOTAL line is positioned consistently.

- [ ] **Step 3: Commit.**
```bash
git add physics-slideshow.html
git commit -m "feat(game): calibrated live KE/PE energy bars with static total"
```

---

## Task 7: Speaker notes + final whole-deck verification

**Files:**
- Modify: `physics-slideshow.html` (replace `PLACEHOLDER_NOTES` in the Mission Control section's `data-speaker-notes`)

- [ ] **Step 1: Replace `PLACEHOLDER_NOTES`** in the `<section id="mc-slide" … data-speaker-notes="PLACEHOLDER_NOTES">` with this exact string (one line; `RECORDED_SPEED`/`RECORDED_ANGLE` = the Task-2 default km/s and degrees shown on the slider readout for the winning burn):

```
(Closer — invite a volunteer.) We've shown you the physics; now you fly it. Drag from Earth to set the burn — direction is the angle, length is the speed — or use the sliders, then hit Launch. Too fast and Orion escapes; too slow and it falls straight back. Find the window and the Moon's gravity loops it home — a free return — and watch the energy bars: kinetic and potential trade the whole way, total never budges. Presenter cheat-note if nobody finds it: speed ~RECORDED_SPEED km/s, angle ~RECORDED_ANGLE° lands the free return. This is the exact equation from slide 10 running live, sixty times a second.
```

- [ ] **Step 2: Full whole-deck verification.**

```bash
cd "C:/work/School/U11Physics/ISU"
B="/c/Users/erick/.claude/skills/gstack/browse/dist/browse"
"$B" goto "file://./physics-slideshow.html" >/dev/null 2>&1; sleep 1.4
echo -n "slides (expect 18): "; "$B" js "document.querySelectorAll('deck-stage > section').length"
echo -n "katex (expect 43/43): "; "$B" js "document.querySelectorAll('.kx[data-done]').length+'/'+document.querySelectorAll('.kx').length"
echo -n "deck-stage defined: "; "$B" js "customElements.get('deck-stage')?'yes':'no'"
echo -n "errors: "; "$B" console --errors 2>&1 | grep -ci "error:" || echo 0
# nav sanity: End -> last slide is Works Cited (#18)
"$B" press "End" >/dev/null 2>&1; sleep 0.4; echo -n "last slide url: "; "$B" url 2>&1 | tail -1
# game pauses off-slide: go to slide 1, confirm not active
"$B" press "Home" >/dev/null 2>&1; sleep 0.4; echo -n "game active on slide 1 (expect false): "; "$B" js "window.__mc.active"
```
Expected: `18`, `43/43`, `yes`, `0`, url `#18`, `false`.

- [ ] **Step 3: Refresh the review shots and eyeball the game slide + neighbours.**
```bash
cd "C:/work/School/U11Physics/ISU" && bash review/render.sh >/dev/null 2>&1 && echo done
```
Read `review/shots/slide-17.png` (game) and `slide-18.png` (Works Cited) — confirm the game slide shows canvas + energy panel + controls, and Works Cited still reads correctly as slide 18.

- [ ] **Step 4: Commit.**
```bash
git add physics-slideshow.html
git commit -m "feat(game): speaker notes + final deck verification (18 slides)"
```

- [ ] **Step 5: Optional final review pass.** Dispatch the existing reviewer (review/RUBRIC.md) against the refreshed shots to confirm the new slide is presentation-ready and nothing regressed.

---

## Self-review notes (author)
- Spec coverage: placement/renumber (T1), drag+sliders+buttons mouse-only (T1 markup, T4), real integration (T2 sweep + T3 `accel`/`stepSim`), discoverable window + cheat-note (T2 → T7 notes), four outcomes (T3 `stepSim` + T5 verify), ghost trails ≤8 (T3 `endFlight` + draw), energy bars + static total (T6), run-only-when-visible (T3 MutationObserver), offline/single-file (no libs), Works Cited→18 (T1). All covered.
- No-keyboard requirement: satisfied via custom pointer sliders + `tabindex="-1"` + `blur()` on pointerup/click; **zero** keydown/keyup handlers added; verified in T4 Step 2 (ArrowRight still advances the deck to #18).
- Naming consistent across tasks: `__mc`, `craft`, `outcome`, `stepSim`, `endFlight`, `setActive`, `makeSlider`, `syncSliders`, `updateHUD`.
- Magic numbers (`EARTH.GM`, `MOON.GM`, `SPD0`, `ANG0`) are explicitly sourced from the Task-2 sweep, not asserted blind.
