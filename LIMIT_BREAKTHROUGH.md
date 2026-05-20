<!-- @created: 2026-05-12 -->
<!-- @scope: real-limits audit — Stage-5 autonomous mobility (battery, range, urban congestion, autonomy safety) -->
<!-- @authority: per LATTICE_POLICY.md §1.2 -->
<!-- @wave: M (limit-breakthrough audit, application repos) -->

# LIMIT_BREAKTHROUGH.md — hexa-mobility real-limits audit

> **Honest scope**: hexa-mobility is a **Stage-5 autonomous mobility
> substrate** (passenger / truck / robotaxi bundle). The HARD walls
> here are **battery chemistry**, **vehicle aerodynamics**, and
> **Braess's paradox** for urban congestion. The SOFT envelopes are
> sensor cost, autonomy reliability, and regulatory-permission
> latency. The autonomy-safety threshold is HARD by social negotiation
> (10× human-driver fatality rate as a regulatory ceiling), not by
> physics.

---

## §1 Domain

`hexa-mobility` is a **mobility substrate** bundling autonomous driving,
EV powertrain, sensor stack (LiDAR / camera / radar / sensor-fusion),
HD-mapping, V2X, MRM fail-safe, and fleet ops. Target form-factors:
passenger car, freight truck, robotaxi.

The dominant operating envelopes are:
- **Vehicle range** — bounded by battery energy density × pack mass
  budget × aerodynamic drag
- **Urban speed** — bounded by congestion (Braess's paradox) and
  signal-timing geometry, not by powertrain
- **Autonomy safety** — bounded by perception reliability and
  long-tail edge cases
- **Cost per km** — bounded by capex amortization + electricity +
  insurance

---

## §2 Limits

### §2.1 HARD walls (physics / chemistry / network theory)

| # | Limit | Bound | Origin |
|---|-------|-------|--------|
| H1 | **Battery energy density** | ~300 Wh/kg cell (2026 NMC); ~3000 Wh/kg Li-air theoretical | Electrochemistry; HARD within current science |
| H2 | **Aerodynamic drag** | F_d = ½ρv²C_dA; v² scaling | Fluid dynamics; HARD |
| H3 | **Rolling resistance** | C_rr·mg; ~0.006–0.012 for car tires | Tire physics; HARD |
| H4 | **Tire–road friction** | μ ≤ ~1.0 dry, ~0.3 wet, ~0.1 ice | Contact mechanics; HARD safety floor |
| H5 | **Braess's paradox** | Adding road capacity can *reduce* network throughput | Network theory (Braess 1968); HARD topological |
| H6 | **Stopping distance** | v²/(2μg) + reaction-distance | Newton; HARD safety floor |
| H7 | **Perception decidability** | No general "is-pedestrian" oracle | PAC-learning + adversarial examples; HARD |
| H8 | **Communication light-cone** | V2X round-trip ≥ propagation delay | c = 3×10⁸ m/s; HARD |
| H9 | **Autonomy fatality rate baseline** | US driver: ~1.3 fatality / 100M VMT | Statistical; regulatory ceiling expected ≤ 10% of this for L5 acceptance |

### §2.2 SOFT envelopes (engineering / regulatory)

| # | Envelope | Current | Breakthrough margin |
|---|----------|---------|---------------------|
| S1 | **EV range** | 400–600 km (75–100 kWh pack) | SOFT, target 800–1000 km with solid-state |
| S2 | **Charge rate** | 250 kW peak (15-min 10→80%) | SOFT, target 350+ kW with 800V pack |
| S3 | **LiDAR cost** | $500–2000 unit (2025 ToF MEMS) | SOFT, declining ~30%/yr |
| S4 | **Autonomy disengagement rate** | Waymo ~0.04 / 1000 mi (CA 2024) | SOFT, long-tail bounded |
| S5 | **Urban average speed** | 25–35 km/h global mega-city | SOFT but bounded by H5 |
| S6 | **Robotaxi $/mi** | $1.50–3.00 effective (Waymo 2024) | SOFT, target <$0.50 at scale |
| S7 | **V2X penetration** | <5% vehicles 2025 | SOFT, regulatory + standards (5.9 GHz DSRC vs C-V2X) |
| S8 | **HD-map coverage** | <0.1% of global road-km 2025 | SOFT, scales with fleet |

### §2.3 Negotiated / standard (NOT physical)

- **Urban speed limit 30–50 km/h** — regulatory, not physical
- **0.08 BAC blood-alcohol** — regulatory
- **SAE J3016 L0–L5 autonomy taxonomy** — standard
  (L0 = no automation · L1 = driver-assist · L2 = partial · L3 = conditional ·
  L4 = high (geofenced) · L5 = full anywhere). **L5 at scale is UNVERIFIED**.
- **ISO 26262 ASIL ratings A/B/C/D** — automotive functional-safety
  standard (ASIL-D = highest integrity, e.g. brake/steer). Claims at
  ASIL-D require ISO 26262 evidence, not n=6 lattice fit.
- **NCAP / IIHS crash-test ratings** — independent safety scoring
  (Euro NCAP · US-NCAP · IIHS Top Safety Pick+). These use the
  agencies' own protocols; the lattice does not score crash tests.
- **AV disengagement / intervention / MPI** — each operator uses their
  OWN metric: Waymo MPI (miles per intervention), CA-DMV disengagement,
  Tesla FSD intervention, Mobileye REM stats, Baidu Apollo MTBF,
  Pony.ai PR-disclosed numbers, NVIDIA DRIVE simulation hours,
  Aurora pre-commercial trials. No lattice-fit applies.
- **UN-R157 ALKS regulation** — regulatory (highway L3 only)
- **California DMV autonomous-vehicle disengagement reporting** — regulatory


| Operator | Status (2024–2026) | Honest claim |
|----------|-------------------|--------------|
| Waymo | Operating commercial robotaxi (Phoenix, SF, LA, Austin) | Geofenced L4 within ODD; Waymo's own MPI; ~10× lower fatality *within ODD only*; not L5 |
| Cruise (GM) | **Defunct as of 2024** — wound down after Oct-2023 incident | Past disengagement data only; no current ops |
| Tesla FSD | Available as **L2 supervised** | NOT L5; driver-monitoring required; Tesla FSD intervention rate is Tesla's own metric |
| Mobileye | Tier-1 supplier · REM mapping | EyeQ ASIL-B/D depending on SKU; REM stats are Mobileye's own |
| Baidu Apollo | Commercial robotaxi (Wuhan, Beijing) | Operator-disclosed MTBF; not independently audited at L5 |
| Pony.ai | Robotaxi pilot (Guangzhou, Beijing, Fremont) | PR-disclosed numbers; no L5 claim at scale |
| NVIDIA DRIVE | Compute platform (Orin / Thor) | ASIL-D platform; not a self-driving system per se |
| Aurora | Pre-commercial trucking pilot | No L5 commercial; own intervention reports |

---

## §3 Assessment

The 3 most binding HARD walls:

1. **H1 (battery)** — at 300 Wh/kg, a 100 kWh pack masses ~333 kg
   cells (~500 kg pack). Doubling range requires *doubling pack mass*
   or *doubling density*, and pack mass cubes consumption via H2/H3.
   Solid-state at 400–500 Wh/kg is a near-term SOFT bypass; Li-air
   3000 Wh/kg is a *theoretical* HARD ceiling.
2. **H5 (Braess) + H4 (friction)** — urban throughput is bounded by
   network topology + signal timing + safety stopping distance. *No
   amount of autonomy fixes a congested 2-lane bridge.* This is the
   most under-acknowledged HARD wall in mobility marketing.
3. **H7 (perception) + H9 (fatality threshold)** — L5 autonomy is
   gated on a long-tail edge-case distribution that PAC-learning
   cannot eliminate via more data; only by *restricting the operational
   design domain (ODD)*. This is why robotaxi works in Phoenix /
   Chandler / SF subset but not "everywhere."

**Honest framing**: hexa-mobility's HARD walls are battery chemistry,
Braess's paradox, and perception long-tail — none broken by software
alone.

---

## §4 Top-3 breakthroughs (most plausible 12–24 month)

### B1 — Solid-state battery (sulfide / oxide electrolyte) → 400–500 Wh/kg cell (SOFT bypass on S1)

Toyota / Samsung-SDI / QuantumScape demonstrations at 400+ Wh/kg
cell-level have moved from lab to pilot lines in 2024–2025. The HARD
wall (Li-air 3000 Wh/kg) is not approached; 400–500 is the realistic
12–24 month target. This translates to ~33–66% range improvement at
fixed pack mass, or ~25–40% mass reduction at fixed range. Honest
caveat: cost is 3–5× current Li-ion at pilot scale; production-line
ramp 2027–2029 realistic.

### B2 — Restricted-ODD robotaxi + remote teleop → 10× safer than human in geofence (SOFT bypass on S4 + sidesteps H7)

By restricting the operational design domain (geofenced city sector,
weather <30 mm/h rain, no construction zones unannotated), Waymo has
demonstrated ~10× lower fatality rate than median human driver *within
the ODD*. The HARD wall (H7 — general perception oracle) is NOT
broken; it is *sidestepped* by domain restriction. Honest caveat: the
ODD covers <2% of US road-km in 2025; expansion is linear in HD-map
coverage (S8) and not "scaling to AGI."

### B3 — Congestion pricing + signal-coordinated arterial → 30% urban throughput vs Braess baseline (SOFT bypass on S5 within H5)

Stockholm / Singapore / London congestion-charge programs demonstrate
20–35% peak-hour throughput increase via demand pricing — within the
Braess-paradox HARD ceiling. The breakthrough is *economic* (Lindahl-style
internalization of congestion externality), not physical. Honest
caveat: this is regulatory + political, not engineering; rollout speed
depends on civic acceptance, not technology.

---

## §5 Caveats

1. **No Li-air production claim**: 3000 Wh/kg is *theoretical upper
   bound* on Li-air chemistry; production cells are not yet viable in
   this audit window. Solid-state at 400–500 Wh/kg is the realistic
   12–24 month target.
2. **L5 "anywhere" is not promised**: L5 autonomy requires geofenced
   ODD restriction; no honest claim of unrestricted-ODD L5 in 12–24
   month window.
3. **Urban speed is bounded by Braess**: even 100% autonomous fleet
   does NOT eliminate H5; can reduce friction loss (S5) but not
   defeat topology.
4. **Fatality threshold is regulatory**: H9 baseline 1.3 / 100M VMT
   is a US-NHTSA statistic; regulator acceptance of L5 expected at
   ≤ 0.13 / 100M VMT (10× safer than median driver).
5. **Robotaxi $/mi numbers** (S6) include subsidized operations; true
   break-even is uncertain.
6. **No n=6 magic**: per `LATTICE_POLICY.md §1.2`, 300 Wh/kg / urban
   speed / Braess paradox are not dictated by σ(6)=12.
7. **Public data only**: NHTSA, CA DMV disengagement reports, EPA
   range estimates — no proprietary telemetry; no GDPR concern.
8. **L5 autonomy is UNVERIFIED at scale**: per SAE J3016, no operator
   has independently-audited L5 (unrestricted ODD) deployment in the
   2024–2026 window. Tesla FSD = L2 supervised, not L5. Waymo = L4
   geofenced. All "L5 in N years" claims remain UNVERIFIED until
   regulator-cleared.
   C3, ASIL-D functional-safety claims must use the ISO 26262
   process (HARA → FSR → TSR → HSI → ISO 26262-2/-3/-4/-6/-9), not
   n=6 lattice. Lattice cannot substitute for ASIL evidence.
10. **NCAP/IIHS scores are agency-protocol**: crash-test ratings come
    from Euro NCAP / US-NCAP / IIHS protocols. The substrate does NOT
    re-derive these via lattice arithmetic.
11. **AV/100MmiPI is operator-specific**: Waymo MPI, Cruise (defunct)
    disengagement, Tesla FSD intervention, Mobileye REM, Baidu Apollo
    MTBF, Pony.ai disclosures, NVIDIA DRIVE sim hours, Aurora trial
    reports — each metric is the operator's OWN; no lattice-fit
    applies across operators.

---

## §6 References

- Braess, D. *Über ein Paradoxon aus der Verkehrsplanung* (1968) — H5
- Goodenough, J. B. et al., *Solid-state Li-ion electrolytes* (various 2020–2024) — B1 chemistry
- Janek, J. & Zeier, W. G. *A solid future for battery development* (Nature Energy 2016) — H1 bound
- NHTSA *Fatality Analysis Reporting System* 2023–2024 — H9 baseline
- CA DMV *Autonomous Vehicle Disengagement Reports* 2023–2024 — S4
- Vickrey, W. *Congestion theory and transport investment* (1969) — B3 economic basis
- SAE J3016 — L0–L5 taxonomy
- Waymo *Safety Case Framework* 2023 — S4 evidence
- Stockholm Congestion Tax evaluations 2007–2024 — B3 evidence
- BloombergNEF *EV Outlook 2024* — S1, S3 trends
- Valiant, L. *A theory of the learnable* (1984) — H7 PAC-learning bound

---

> *"Energy density is chemistry. Urban speed is topology.
> Autonomy is a geofenced restriction, not a unicorn."*

— hexa-mobility Wave M audit (2026-05-12)
