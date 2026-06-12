# Mission Control — interactive sandbox slide (design)

**Date:** 2026-06-12 · **Status:** approved by Eric
**Target:** `physics-slideshow.html` (SPH3U "Gravity Assist & Artemis II" deck)

## What

A new interactive slide — **slide 17, kicker `17 / MISSION CONTROL`, title "Fly It
Yourself"** — inserted after the 30-second summary (slide 16). The existing Works
Cited slide becomes **slide 18** (kicker renumbered `18 / WORKS CITED`). Total
slides: 18.

The slide is an **open sandbox** (no score, no levels): the player aims Orion's
TLI burn from Earth and a **real numerical gravity simulation** shows what
happens. The free-return figure-eight is discoverable, not scripted. Played
live in class on the projector, driven entirely by mouse.

## Why

- Closes the talk with "you've heard the physics — now watch it run."
- The sim integrates the deck's own equation (F = Gm₁m₂/r²) live, reinforcing
  the deck's honesty theme: emergent trajectories, not a movie.
- The energy side-panel is slide 13's graph running in real time.

## Gameplay & controls (mouse only — hard requirement)

- **Drag-to-aim:** mousedown near Earth and drag — drag direction = burn angle,
  drag length = burn speed. A live arrow + numeric readout (speed in km/s,
  angle in degrees) previews the burn during the drag. Releasing sets the values.
- **Sliders:** two range inputs (Burn speed, Burn angle) below the canvas for
  fine adjustment; kept in two-way sync with the drag values.
- **Buttons:** `LAUNCH` starts the integration from Earth's parking-orbit point;
  `RESET` clears the current flight (ghost trails persist); `CLEAR TRAILS`
  wipes ghosts.
- **Ghost trails:** each completed attempt leaves its path at low opacity
  (max ~8 ghosts, oldest dropped) so successive attempts visibly converge on
  the figure-eight.
- **No keyboard listeners at all.** deck-stage owns ArrowKeys / Space / digits /
  R / Home / End globally. The game must not add any `keydown`/`keyup`
  handlers. All interaction is pointer-based (mouse + touch via pointer events).
- Pointer events on the canvas call `stopPropagation()` so deck-stage's
  click-to-advance (if any) never fires from inside the game area.

## Physics model

- 2-D restricted three-body, **both primaries fixed** (Earth at left anchor,
  Moon at right anchor). Spacecraft is a point mass under both inverse-square
  pulls: `a = -GM_e·r̂_e/r_e² - GM_m·r̂_m/r_m²`.
- **Integrator:** semi-implicit (symplectic) Euler with fixed substeps
  (e.g., 8 substeps per 60 fps frame, fixed dt) — stable, energy-drift small,
  fast. No external libraries.
- **Game units, tuned, not SI.** Masses/distances/G chosen so that:
  - the Earth–Moon gap spans ~70% of the canvas width;
  - the free-return-like loop (out around the Moon's far side and back to
    Earth) is reachable within a contiguous band of the speed×angle space
    large enough to find in ~3–6 attempts;
  - a launch ~15–20% faster than the window clearly escapes; ~15–20% slower
    clearly falls back.
  - Tuning is part of implementation: sweep the parameter space in a test
    harness and verify the window exists and has sensible width.
- Readouts display **scaled "display units"** (km/s, Mm) derived from game
  units by fixed factors — labelled as scaled, not claimed as mission-accurate.
- **Honesty footnote** on the slide (small, muted): "Simplified: the Moon is
  held still — the real Moon orbits at ~1 km/s, which is what makes a true
  free-return possible without a second burn."

## Outcome detection (live, each frame)

| Outcome | Condition | Feedback |
|---|---|---|
| **FREE RETURN!** | Craft passed within the Moon's influence radius, then re-entered Earth's atmosphere radius | Orange flash banner + trail turns solid orange |
| **Lunar impact** | Distance to Moon < Moon collision radius | "IMPACT — too close" banner, trail freezes |
| **Escaped** | Leaves a generous world bound (~1.5× canvas) | "ESCAPED EARTH–MOON SPACE — too fast" |
| **Fell back** | Re-enters Earth radius without ever entering the Moon's influence sphere | "FELL BACK — not enough speed" |

A flight also auto-ends after a max sim time (prevents infinite orbits);
banner "STILL ORBITING — try again."

## Energy side-panel (the teaching payoff)

- Vertical bars: **KE (orange)** `½mv²` and **PE (blue)** offset-shifted
  `-GM_em/r_e - GM_mm/r_m` (rescaled so the visible range is positive), plus a
  thin white **TOTAL** marker line that stays fixed while coasting.
- Updated every frame; uses the deck's energy colour code and mono labels
  (`E_k`, `E_g` in the italic-math style used on slide 13).
- Small caption: "Total never changes while coasting — slide 13, live."

## Visual & layout (Apogee system)

- Slide uses the standard head (kicker + title) / content / footer zones.
- Content: left ~72% = canvas (starfield background, blue-gradient Earth,
  grey-gradient Moon, dashed parking-orbit hint, orange trajectory, refined
  arrowheads on the aim vector); right ~28% = energy panel + outcome banner +
  controls block (sliders + buttons, mono labels, hairline-bordered card).
- Footer: presenter `Elvin · Leon · Eric` + mission-tag `REAL PHYSICS · F = Gm₁m₂/r²`.
- Canvas is fixed internal resolution (e.g., 1280×760 logical) scaled by CSS —
  deck-stage scales the whole 1920×1080 stage, so no resize handling needed
  beyond devicePixelRatio crispness at load.

## Integration & lifecycle

- All game code lives in one `<script>` block (vanilla JS) + one `<section>`
  of markup inside `physics-slideshow.html`. No external dependencies; file
  stays offline-safe.
- **Run-only-when-visible:** the game observes its section's
  `data-deck-active` attribute (MutationObserver). Activate → start
  `requestAnimationFrame` loop; deactivate → cancel loop and pause state.
  Never animates in the background.
- Speaker notes for slide 17: invite a volunteer; suggested script in notes.
- Works Cited kicker renumbered to 18; its `data-label` unchanged.

## Non-goals (YAGNI)

Scoring, leaderboards, levels, fuel budget, moving Moon (possible future
toggle), sound, phone/multi-device play, saving attempts.

## Acceptance criteria

1. Deck has 18 slides; 17 = Mission Control, 18 = Works Cited (renumbered).
2. Drag-aim, sliders, Launch/Reset/Clear-trails all work by mouse alone; no
   keyboard handlers added anywhere in game code.
3. Trajectories are produced by live integration of the two-body pulls
   (verifiable: parameter sweep shows emergent outcome bands, not canned paths).
4. A discoverable free-return window exists (documented speed/angle values
   from the tuning sweep recorded as a presenter cheat-note in speaker notes).
5. All four outcome banners trigger under the right conditions.
6. Energy bars track KE/PE each frame; TOTAL marker visibly static while
   coasting.
7. Sim pauses when the slide is not active (no rAF while on other slides).
8. The existing 17 slides' markup is unchanged except the Works Cited kicker
   renumber; KaTeX, deck-stage nav, and speaker notes all still work; no
   console errors.
9. File remains single-file/offline (Google-Fonts webfont remains the only
   external load).
