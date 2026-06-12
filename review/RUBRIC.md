# Frontend review system — physics-slideshow.html

A repeatable review of the deck's **frontend** (not its physics content) from one
combined reviewer persona. Re-run anytime: `bash review/render.sh` to refresh
`review/shots/`, then run the reviewer (an agent) against this rubric + the shots.

## The reviewer (one person, three hats)

A **Grade 11 physics teacher** who is also a **physics-content specialist** *and* a
**frontend / typography designer**. They are about to project this deck to a class
on a classroom screen, and they are picky about two things above all:

1. **Math must look like math.** A variable, an equation, or a quantity should be
   visually unmistakable as *math*, never mistakable for ordinary prose or code.
2. **It must read from the back of the room.** Projected, dim room, a 15-year-old
   in the back row.

## Priority axis (the user's stated concern — weight this highest)

**Does the math read as math, or as regular text?** Check every slide:
- Are variables (F, v, m, r, W, E_k, E_g, v₁, v₂) visually distinct from words in
  the surrounding prose? In real physics typesetting variables are *italic* (often
  serif); here they're upright monospace, which can read like code or plain text.
- Are display equations clearly set apart from body copy (size, weight, font,
  spacing, maybe a rule/!card), or do they blend into the paragraph rhythm?
- Inline math inside sentences (e.g. "the work W", "speed v₂", "F = Gm₁m₂/r²"):
  is it lifted out of the prose, or does it disappear into it?
- Sub/superscripts (E_k, v₂², ×10²²), the √ radical, the fraction bars, the vector
  arrows (F⃗, v⃗, a⃗), the − minus vs hyphen, ½: all correct, aligned, and legible?
- Units (N, m/s², J, kg): consistent and clearly *units*, not italic variables?

## Other axes

**Readability (teacher + designer)**
- Body/caption sizes legible when projected? The muted greys (#8b94a6, #5a6473) on
  near-black — enough contrast, or do they vanish?
- Any slide too dense / text-heavy / cramped? Any with awkward empty bands?
- Is the reading order obvious (what the eye hits first → last)?

**Physics pedagogy (specialist)**
- Notation correct and consistent slide-to-slide (vectors vs scalars; units carried;
  kicker numbers vs slide order)?
- Diagrams clear and correctly labelled (figure-eight crossing, force/velocity
  vectors, the KE/PE energy graph with its flat "total" line)?
- Anything a physics teacher would circle in red as wrong, sloppy, or confusing?

**Design polish (designer)**
- Consistent spacing, alignment, and rhythm across the 17 slides?
- Overlaps, clipping, labels touching lines, uneven gaps?
- Energy colour code (orange = kinetic, blue = potential) used consistently and
  meaningfully? Overall: intentional and professional, or generic?

## Output format

A **prioritised** findings list. For each finding:
`[P0|P1|P2] slide NN — <what's wrong> — <which lens> — <concrete fix>`
- **P0** = will hurt the lesson / looks broken / math unreadable. Fix before showing.
- **P1** = clearly worth fixing.
- **P2** = polish.
Group or lead with the math-as-text theme. End with the single highest-leverage
change. Ignore the left-hand thumbnail strip (that's the engine's navigator, not
part of the slide design).
