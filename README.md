# 🧭 hexa-mobility — n=6 mobility substrate (Stage-5 autonomous)

> **Stage-5 autonomous-driving substrate** organized around the **n=6 invariant lattice** —
> passenger car / truck / robotaxi as a single thematic bundle.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-0.1.0-informational.svg)](hexa.toml)
[![Bundle: 11 docs](https://img.shields.io/badge/bundle-11_docs-blue.svg)](#docs)
[![Status](https://img.shields.io/badge/status-bundle--first-orange.svg)](#status)

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

## Quick start

```bash
# CLI dispatcher (spec-first)
hexa run cli/hexa-mobility.hexa status        # 11-doc table
hexa run cli/hexa-mobility.hexa selftest      # 11-doc presence check
hexa run cli/hexa-mobility.hexa <verb>        # spec doc headline (head -30)

# Sibling CLIs (cross-link policy — DO NOT proxy through hexa-mobility):
hexa-energy battery        # EV cells / charging
hexa-grid   v2x            # 5G/6G + V2X
hexa-chip   vehicle        # vehicle SoC
hexa-codex  serve          # perception ML serving
```

---

## License

MIT — see [`LICENSE`](LICENSE).

## Provenance

Bundled from `canon/domains/{infra,energy}/` at canon SHA `aadcb101`
(2026-05-10). Drift checked by upstream `canon/tools/check_drift.hexa`.
