<p align="center">
  <img src="docs/logo.svg" width="140" alt="hexa-mobility">
</p>

<h1 align="center">🚗 hexa-mobility</h1>

<p align="center"><strong>HEXA-Mobility family</strong> — transport · vehicles · Stage-5 autonomous-driving substrate</p>

<p align="center">
  <a href="LICENSE"><img alt="License" src="https://img.shields.io/badge/license-MIT-blue"></a>
  <a href=".github/workflows/lint.yml"><img alt="CI" src="https://github.com/dancinlab/hexa-mobility/actions/workflows/lint.yml/badge.svg"></a>
  <img alt="Spec" src="https://img.shields.io/badge/spec-v0.1-success">
  <img alt="Verbs" src="https://img.shields.io/badge/verbs-11-informational">
  <img alt="Verify" src="https://img.shields.io/badge/verify-4%2F4%20PASS-informational">
  <img alt="DOI" src="https://zenodo.org/badge/DOI/10.5281/zenodo.20115000.svg">
  <img alt="Sibling" src="https://img.shields.io/badge/sibling-hexa--grid%20·%20hexa--meta%20·%20hexa--millennium-blueviolet">
</p>

<p align="center">autonomous-driving · electric-vehicle · drive-by-wire · HD-map · robotics-transport · MRM-fail-safe · L5</p>

---

> **Stage-5 autonomous-driving substrate** organized around the **n=6 invariant lattice** —
> passenger car / truck / robotaxi as a single thematic bundle.

---

## Why

**hexa-mobility** is the mobility member of the HEXA family. It bundles
the existing mobility-relevant spec docs out of the upstream
[`canon`](https://github.com/dancinlab/canon) tree into a single
thematic substrate: **autonomous driving · EV powertrain · vehicle
control · HD-map / GIS · robotics-transport · MRM-safety · urban
governance**.

`v0.1.0` ships as an **honest bundle** of pre-existing canon docs.
The full 13-verb n=6 HEXA template author (`l5-passenger`, `l5-truck`,
`l5-robotaxi`, `lidar-perception`, `camera-vision`, `radar-4d`,
`sensor-fusion`, `behavior-planning`, `motion-trajectory`,
`hd-map-localization`, `v2x-comm`, `mrm-fail-safe`, `fleet-ops`,
`closed-loop-sim`) is tracked in [`TODO.md`](TODO.md) for `v1.0.0`.

**Out of scope** — call sibling CLI directly:

| concern                                  | call                          |
| ---------------------------------------- | ----------------------------- |
| EV battery cells / charging infra        | `hexa-energy battery`         |
| V2X 5G/6G / network protocols            | `hexa-grid v2x`               |
| Vehicle SoC / automotive silicon         | `hexa-chip vehicle`           |
| Perception ML serving                    | `hexa-codex serve`            |

---

## Docs (11)

| group                    | doc                                                                |
| ------------------------ | ------------------------------------------------------------------ |
| autonomous-driving       | [`autonomous-driving`](docs/autonomous-driving.md)                 |
| electric-vehicle         | [`electric-vehicle`](docs/electric-vehicle.md)                     |
| vehicle-control          | [`control-automation`](docs/control-automation.md)                 |
| consumer-car             | [`fun-car`](docs/fun-car.md)                                       |
| HD-map / GIS             | [`cartography-gis`](docs/cartography-gis.md)                       |
| robotics-shared          | [`robotics`](docs/robotics.md)                                     |
| haul / freight transport | [`robotics-transport`](docs/robotics-transport.md)                 |
| 2-wheel mobility         | [`motorcycle`](docs/motorcycle.md)                                 |
| MRM / fail-safe          | [`ultimate-safety`](docs/ultimate-safety.md)                       |
| EV battery (scale-6)     | [`battery-scale-6-ev`](docs/battery-scale-6-ev.md)                 |
| urban traffic governance | [`governance-safety-urban`](docs/governance-safety-urban.md)       |

---

## Status

`v0.1.0` — **BUNDLE_FIRST** (11/11 docs are existing canon copies, md5
drift-tracked via [`canon/standalone_registry.toml`](https://github.com/dancinlab/canon/blob/main/standalone_registry.toml)).

See [`TODO.md`](TODO.md) for the planned 13-verb full-template author at
`v1.0.0`.

---

## Install

```bash
# 1. Install hexa-lang (gives you `hexa` + `hx` package manager)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/dancinlab/hexa-lang/main/install.sh)"

# 2. Install hexa-mobility
hx install hexa-mobility
```

## Run

```bash
hexa-mobility autonomous_driving       # autonomous-driving spec doc
hexa-mobility electric_vehicle         # electric-vehicle spec doc
hexa-mobility control_automation       # control-automation (drive-by-wire) spec doc
hexa-mobility fun_car                  # fun-car (consumer) spec doc
hexa-mobility cartography_gis          # cartography-gis (HD-map) spec doc
hexa-mobility robotics                 # robotics (perception/planning shared) spec doc
hexa-mobility robotics_transport       # robotics-transport (haul/freight) spec doc
hexa-mobility motorcycle               # motorcycle (2-wheel) spec doc
hexa-mobility ultimate_safety          # ultimate-safety (MRM / fail-safe) spec doc
hexa-mobility battery_ev               # battery-scale-6-ev spec doc
hexa-mobility governance_safety_urban  # governance-safety-urban spec doc
hexa-mobility status                   # 11-doc table + cross-link + caveats
hexa-mobility selftest                 # 11-doc presence check
hexa-mobility version                  # print version
hexa-mobility help                     # full --help (subcommands + env vars + cross-link)
```

---

## Verify

Sister-substrate `verify/run_all.hexa` aggregator pattern, scaled to
Stage-5 mobility spec-first scope. From the repo root:

```bash
hexa run verify/run_all.hexa     # exit 0 = all 4 scripts PASS
```

| script                            | what it checks                                                                                  |
| --------------------------------- | ----------------------------------------------------------------------------------------------- |
| `verify/spec_presence.hexa`       | all 11 verb spec docs present at declared paths                                                 |
| `verify/lattice_arithmetic.hexa`  | n=6 self-consistency (σ·φ = n·τ = 24) — *aux only* per `LATTICE_POLICY.md` §1.3                 |
| `verify/real_limits_anchor.hexa`  | `LIMIT_BREAKTHROUGH.md` anchors (SAE J3016 L0–L5 · ISO 26262 ASIL A–D · NCAP · IIHS · NHTSA · Braess · Waymo MPI) |
| `verify/closure_consistency.hexa` | scoreboard cross-check (CLI · `hexa.toml` · README · `AGENTS.md`)                               |

Per `LATTICE_POLICY.md` §1.3, lattice-arithmetic identities are
permitted only as auxiliary self-consistency checks; the substrate's
real verification anchors live in `LIMIT_BREAKTHROUGH.md`.


- **L5 autonomy at scale is UNVERIFIED.** Waymo = L4 geofenced;
  Tesla FSD = L2 supervised, NOT L5. No commercial L5 in 2024–2026.
- **Cruise (GM) is defunct as of 2024.**
- **ASIL-D claims require ISO 26262 evidence**, not n=6 lattice fit.
- **NCAP / IIHS scores use agency protocols**, not lattice arithmetic.
- **Each operator uses their OWN MPI / disengagement / intervention
  metric** — Waymo MPI, Mobileye REM, Baidu Apollo MTBF, Pony.ai
  disclosures, NVIDIA DRIVE sim hours, Aurora pre-commercial trials —
  no lattice-fit applies across operators.
- **Safety claims remain UNVERIFIED** until peer-reviewed and/or
  regulator-cleared.

---

## Repo layout

```
hexa-mobility/
├── README.md
├── LICENSE                       MIT
├── AGENTS.tape                   identity + governance (.tape v1.2)
├── hexa.toml                     package manifest
├── install.hexa                  hx install hook
├── cli/                          hexa-mobility CLI (11-doc router)
├── docs/                         11 mobility spec docs (autonomous-driving · EV · …)
│   └── logo.svg                  repo logo
├── papers/                       reference papers
├── tests/                        selftest sweep
├── verify/                       4-script closure (run_all + 3 anchors)
├── state/                        runtime state (gitignored)
├── STAGE-5.md                    Stage-5 autonomy reference
├── TAPE-AUDIT.md                 .tape v1.x adoption ledger
├── TODO.md                       v1.0.0 13-verb full-template plan
├── LATTICE_POLICY.md             real-limits policy
├── LIMIT_BREAKTHROUGH.md         HARD/SOFT wall audit
└── IMPORTED_FROM_CANON.md        canon-bundle provenance
```

## License

[MIT](LICENSE) — see [`LICENSE`](LICENSE).

## Provenance

Bundled from `canon/domains/{infra,energy}/` at canon SHA `aadcb101`
(2026-05-10). Drift checked by upstream `canon/tools/check_drift.hexa`.
