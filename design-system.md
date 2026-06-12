# Apogee — Deep-Space Physics Deck (design system)

A design system for `physics-slideshow.html`, extracted from the existing
`Gravity Assist & Artemis II.html` deck so claude.ai/design can rebuild it
fresh and more polished. Maps 1:1 to the claude.ai/design **"Set up your
design system"** fields.

---

## 1 — Company name and blurb (name of design system)

**Apogee — a deep-space presentation system for Grade 11 physics (SPH3U).**

Dark mission-control aesthetic: big, bold sans headlines float over a deep-space
starfield; monospace labels and numbered section kickers carry the technical
voice; and a two-colour *energy code* — **orange = kinetic, blue = potential** —
runs through every diagram, equation, and accent. The tone is honest and
intuition-first ("steering, not boosting"), like a NASA flight-data briefing
that defines its terms before it uses them. 16:9 slides, one staggered entrance
animation per slide, generous negative space.

---

## 2 — Examples of your design system and products

**Link code from GitHub:** `https://github.com/eric-kharitonov/physics-isu`

Frontend-relevant files in that repo:
- `Gravity Assist & Artemis II.html` — the reference deck (the look to learn from).
- `deck-stage.js` — the slide engine: scales a fixed 1920×1080 stage to fit, arrow-key / digit navigation, speaker-notes support, print/export.
- `design-system.md` — this file.

---

## 3 — Fonts, logos and assets

- **Monospace (labels, kickers, equations, mission-tags):** Space Mono (Google Fonts).
- **Headline / body sans:** a clean neo-grotesque. Current deck uses Helvetica Neue; any neutral grotesque works (the personality comes from the starfield + energy-coding + mono labels, *not* the headline face). Avoid Inter/Roboto/Space Grotesk.
- **No logo.** Brand marks are the numbered kicker (`07 / THE MISSION`) and the footer mission-tag.
- **Iconography:** none — all visuals are hand-built SVG line diagrams (planets as radial-gradient spheres, energy-coded vectors and curves).

---

## 4 — Any other notes (the full design language)

### Colour tokens (exact)
```
--bg:      #05070d   /* deep-space base */
--bg-2:    #0a0f1a   /* panel / card background */
--panel:   #0e131f
--line:    #1d2737   /* hairlines, dividers, card borders */
--text:    #f3f5fa   /* near-white primary text */
--muted:   #8b94a6   /* secondary text */
--dim:     #5a6473   /* tertiary / captions / mission-tag */
--orange:  #ff7a45   /* KINETIC energy, highlights, kickers, accents */
--blue:    #5b9bff   /* POTENTIAL energy, Earth, cool/secondary accent */
--moon:    #c7ccd6   /* Moon grey */
```
**Energy colour-coding is semantic and must stay consistent:** orange always =
kinetic / speed / highlight; blue always = potential / cool. This is the single
most important rule of the system.

### Typography
- **Display font:** bold (700) neo-grotesque sans, tight tracking (`-0.015em`), line-height ~1.03, `text-wrap:balance`.
- **Mono font:** Space Mono. Used for kickers, equations, legends, axis labels, and footer mission-tags. Kickers/tags are UPPERCASE with wide tracking (`0.14`–`0.22em`).
- **Type scale (px on the 1920×1080 stage):** display 100 · title 62 · subtitle/lead 40 · body 32 · small 26 · mono 24.
- Body text uses `--muted`; key phrases are pulled out in `--orange` (or `--blue` for the cool/PE side).

### Layout & spacing
- **Fixed 16:9 stage, 1920×1080,** scaled to fit the viewport (never reflows).
- **Page padding:** 96 top / 84 bottom / 104 left-right.
- **Three-zone vertical rhythm per slide:** `head` (kicker + title/lead) at top → `content` (grows to fill) → `footer` at the bottom.
- Left-aligned, generous negative space — content often lives in the top ~60% with an airy lower band. Two-column splits for "diagram + explanation".
- Gaps: title block ~44, item ~26.

### Motion
- **One choreographed entrance per slide:** elements rise 16px into place on a `cubic-bezier(.22,.61,.36,1)` ease, staggered `0.05 / 0.10 / 0.15 / 0.20s` (classes `d1`–`d4`).
- **Transform-only** (no opacity fade) so slides stay fully legible in print/export and on a throttled tab.

### Background / atmosphere
- **Deep-space starfield:** scattered 1–1.5px radial-gradient star dots at varied opacity, plus two large soft nebula glows — a blue one top-right, an orange one bottom-left. Applied to most slides via a `.space` class.

### Slide templates (the component inventory)
1. **Cover** — oversized display title, lead subtitle, presenter byline + mission-date footer.
2. **Section kicker** — `NN / SECTION NAME` in orange mono, wide tracking; sits at the top of every content slide.
3. **Statement / hook** — large sans statement with exactly one accent-coloured phrase.
4. **Two-column diagram + prose** — SVG diagram on one side, explanatory copy on the other (left/right variants).
5. **Comparison cards** — two bordered panels, *cold* (blue tag) vs *warm* (orange tag), each with a muted note pinned to the bottom.
6. **Vocabulary grid** — 2-col: term (mono, bold) + definition (small, muted).
7. **Timeline** — rows of `WHEN` (orange mono, can wrap to 2 lines) | `what` (sans + a smaller muted aside), separated by hairline dividers.
8. **Law / concept cards** — 2×2 grid, orange left-border, mono label + small body.
9. **Equation card** — mono equation; fractions drawn with a `border-bottom` bar (numerator over denominator); **vector notation = a small arrow centred over the symbol** (F⃗, v⃗, a⃗) for *vectors only* — magnitudes and energy (E_k, E_g, speeds, the gravitation-law magnitude) stay plain. Use proper sub/superscripts, not Unicode glyphs.
10. **Energy graph / chart** — labelled axes, energy-coded curves (orange KE rising, blue PE mirroring), a dashed "total = constant" line; schematic but quantitatively honest (KE + PE must visibly sum to the flat line).
11. **GRASP problem** — 2-col *Given* / *Required · Analysis*, a full-width *Solution* line, and orange-outlined answer chips. Carry units through the working.
12. **Summary** — muted recap paragraph with inline equations, then one bold takeaway line.
13. **Sources** — numbered 2-col list with hairline tops.
14. **Footer rail** — presenter name with a small orange dot, plus an uppercase mono "mission-tag" on the right.

### Diagram conventions
- Thin-stroke SVG line art, energy colour-coded.
- **Refined arrowheads:** small, slightly swept, scaling with line weight (not chunky).
- Earth = blue radial-gradient sphere; Moon = grey radial-gradient sphere; both sit in the starfield.
- Vector quantities get the arrow-over-symbol; scalars don't.
- Labels never overlap the lines/objects they annotate.

### Voice / tone
Honest, intuition-first, mission-control. Picture before formalism. Defines
vocabulary before using it. Confident and precise, lightly playful ("the honest
headline", "steering, not boosting"). Never overclaims the physics.

---

## Content the deck covers (17 slides)
Gravity Assist & Artemis II — cover · the hook (free-speed myth) · definition ·
two flavours (speed-changing vs free-return) · honest headline · vocabulary ·
the mission timeline · the figure-eight trajectory · connection to SPH3U (4 laws)
· F = Gm₁m₂/r² · F⃗ = ma⃗ · energy & v₂ = √(v₁²+2W/m) · the energy graph ·
GRASP problem 1 (force) · GRASP problem 2 (speed) · 30-second summary · sources.
