# TAPE-AUDIT — hexa-mobility

**Date:** 2026-05-14 · **Lens:** `.tape` (4th sibling: typed events + provenance + grade + 11 types / 7 edges / 6 grades).

## A. Audit-class ledgers

`state/markers/*.marker` — boot-hook touchstones (spec_presence / lattice_arithmetic / real_limits_anchor / closure_consistency / run_all). Filename = `<check>_<unix>.marker` ± `_FAILED`. **CARGO** (gitignored ephemera per dancinlab convention, mirrors wilson `state/markers/`); no per-event payload. `verify/` holds Python `*_audit.py` scripts (cross_doc, real_limits, vendor_spec) but their output is rc-only — no ledger. No `.jsonl`, no `.hook-audit.jsonl`.

## B. Identity surface

`hexa.toml` has no `[identity]` / agent_id. Substrate-level (no per-agent), driver/vehicle identity is the runtime concern not in-repo.

## C. Domain.md files

**Zero** top-level UPPERCASE.md (besides policy: `LATTICE_POLICY.md`, `LIMIT_BREAKTHROUGH.md`). `STAGE-5.md` (26 KB, 2026-05-13, SAE J3016 L5 canonical def + ISO 26262 anchor) is the only single-cap stack — borderline domain-style, not following the `<UPPERCASE>.md` convention. Per-verb dirs (`cli/`, `tests/`, `verify/`, `papers/`) — no per-verb domain.md.

## D. Per-run / per-event history

Verify scripts re-touch markers on each run (timestamp overwrite). **No per-run event stream** — the marker is a presence-touch, not a measurement record. Stage-5 ODD enumeration (in STAGE-5.md) is a static catalog, not a run-history.

## E. Promotion candidates

- **`.tape` future fit**: any future "real Stage-5 sim event log" (per-mile encounters: weather state · ODD breach · disengage cause) would be the natural `H` (history) tape consumer. None exists today.
- **hxc / n12**: none.

## Verdict

**LIGHT** — verb-stub substrate roll-up (cli/ + verify/ + papers/, ~7 verbs). State surface is the dancinlab-uniform marker-touch hook layer only; no per-event / per-trip ledger today. Future Stage-5 sim or fleet-telemetry pipeline would be a natural `.tape` site; pre-implementation today.
