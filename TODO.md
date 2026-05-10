# TODO — hexa-mobility

`v0.1.0` ships as a thin bundle of existing mobility-relevant canon docs
(11 docs, see [README.md](README.md#docs)). This TODO tracks the planned
**13-verb full-template author** for `v1.0.0`.

---

## v1.0.0 — Full 13-verb n=6 HEXA-template author (Stage-5 substrate)

Each new verb = a new canon spec doc following the gold-standard n=6
HEXA template (§WHY / §COMPARE / §REQUIRES / §STRUCT / §FLOW / §EVOLVE /
§VERIFY with stdlib Python verification code, ~450 lines/seed).

Reference: `canon/domains/infra/autonomous-driving/autonomous-driving.md`
(template exemplar).

### Vehicle classes (3)

- [ ] `l5-passenger`        — Stage-5 승용차 (passenger / personal)
- [ ] `l5-truck`            — Stage-5 트럭 (haul / freight / platooning)
- [ ] `l5-robotaxi`         — Stage-5 로보택시 (ride-hail / fleet)

### Perception stack (4)

- [ ] `lidar-perception`    — solid-state / FMCW LiDAR object detection
- [ ] `camera-vision`       — surround-view CV / depth / lane / sign
- [ ] `radar-4d`            — imaging 4D radar (range-doppler-azimuth-elevation)
- [ ] `sensor-fusion`       — multi-modal late/early fusion + tracking

### Planning / control (3)

- [ ] `behavior-planning`   — BP / decision / scenario tree
- [ ] `motion-trajectory`   — trajectory optimisation / MPC
- [ ] `vehicle-control`     — drive-by-wire (reuse `control-automation.md`)

### Connectivity / maps (2)

- [ ] `hd-map-localization` — vector HD map + lane-level localization
- [ ] `v2x-comm`            — V2V/V2I/V2N (delegate radio layer to hexa-grid)

### Safety / operation (3)

- [ ] `mrm-fail-safe`       — Minimal Risk Maneuver / fail-operational
- [ ] `fleet-ops`           — depot / dispatch / charging / cleaning
- [ ] `closed-loop-sim`     — scenario sim / edge-case generation / replay

---

## Cross-link policy (raw#10)

Do NOT re-implement these; call sibling CLI directly:

| concern                       | sibling CLI            |
| ----------------------------- | ---------------------- |
| EV battery cells / charging   | `hexa-energy battery`  |
| V2X 5G/6G radio               | `hexa-grid v2x`        |
| Vehicle SoC / chip            | `hexa-chip vehicle`    |
| Perception ML serving         | `hexa-codex serve`     |

---

## Authoring workflow (when v1.0.0 starts)

1. For each verb, create `canon/domains/mobility/<verb>/<verb>.md` using
   the gold-standard n=6 HEXA template (450 lines).
2. Append entry to `canon/tools/standalone_seeds.tsv` with
   `(hexa-mobility, 🧭, <oneliner>, <canonical>, docs/<verb>.md)`.
3. Copy canonical → `~/core/hexa-mobility/docs/<verb>.md`.
4. Run `hexa run canon/tools/build_registry.hexa` to refresh
   `standalone_registry.toml` md5s.
5. Run `hexa run canon/tools/check_drift.hexa` — expect 0 drift.
6. Bump `hexa.toml` version → `1.0.0`, `verdict` → `SPEC_FIRST`.
7. Commit + push both repos.
