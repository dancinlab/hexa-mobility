<!-- @created: 2026-05-13 -->
<!-- @scope: canonical Stage-5 definition for hexa-mobility substrate -->
<!-- @authority: SAE J3016 (taxonomy) · ISO 26262 (functional safety) · LIMIT_BREAKTHROUGH.md (real limits) -->

# STAGE-5.md — Stage-5 자율주행 캐노니컬 정의

> **Stage-5 = SAE J3016 Level 5**: full driving automation across **all
> roadway / weather / time conditions a competent human driver can
> manage**, with **no human fallback expected**. This document is the
> canonical reference for what "Stage-5" means inside the
> `hexa-mobility` substrate — scope, requirements, honest limits.

---

## §1 Taxonomy (SAE J3016)

| Level | Name | DDT* | Fallback | ODD |
|------:|------|------|----------|-----|
| L0 | No automation | Human | Human | n/a |
| L1 | Driver assistance | Human + system (one axis) | Human | Limited |
| L2 | Partial automation | System (both axes), human monitors | Human | Limited |
| L3 | Conditional | System | Human (on request) | Limited |
| L4 | High | System | System | **Limited** (geofenced) |
| **L5** | **Full** | **System** | **System** | **Unlimited** |

*DDT = Dynamic Driving Task (steering + accel/brake + OEDR).
OEDR = Object & Event Detection and Response.

**The L4 → L5 jump is the ODD boundary**, not a capability tier. L5
removes the geofence; L4 does not.

---

## §2 Scope inside `hexa-mobility`

`hexa-mobility` is positioned as a **Stage-5 spec substrate**. This
means the substrate's verbs, docs, and verification anchors are
authored *as if* the target form-factor is L5, even though no
operator has independently-audited L5 deployment in 2024–2026
(see [`LIMIT_BREAKTHROUGH.md`](LIMIT_BREAKTHROUGH.md) §2.3).

### §2.1 Form-factor bundle (3 vehicle classes)

Per [`TODO.md`](TODO.md) v1.0.0 roadmap:

| Verb | Class | Operating mode |
|------|-------|----------------|
| `l5-passenger` | Stage-5 승용차 (passenger / personal) | Owner-operated, no driver |
| `l5-truck`     | Stage-5 트럭 (haul / freight / platooning) | Hub-to-hub or full door-to-door |
| `l5-robotaxi`  | Stage-5 로보택시 (ride-hail / fleet) | Fleet-dispatched, no safety driver |

### §2.2 Stack scope (10 supporting verbs)

Perception (4): `lidar-perception` · `camera-vision` · `radar-4d` ·
`sensor-fusion`. Planning/control (3): `behavior-planning` ·
`motion-trajectory` · `vehicle-control` (reuses
[`control-automation`](docs/control-automation.md)). Connectivity (2):
`hd-map-localization` · `v2x-comm`. Safety/ops (3): `mrm-fail-safe` ·
`fleet-ops` · `closed-loop-sim`.

### §2.3 Out of scope (call siblings)

| Concern | Sibling CLI |
|---------|-------------|
| EV battery cells / charging infra | `hexa-energy battery` |
| V2X 5G/6G radio layer | `hexa-grid v2x` |
| Vehicle SoC / automotive silicon | `hexa-chip vehicle` |
| Perception ML serving | `hexa-codex serve` |

---

## §3 What Stage-5 requires (engineering envelope)

A genuine L5 system must clear **all four** simultaneously:

1. **ODD = unrestricted** — every road type, weather, lighting, traffic
   condition a competent human handles. No geofence.
2. **Fallback = system, not human** — the vehicle must execute a
   safe MRM (Minimal Risk Maneuver) without human takeover.
3. **OEDR = complete** — perception covers the long-tail edge-case
   distribution sufficiently to meet the regulatory fatality ceiling
   (≤ 0.13 / 100M VMT per `LIMIT_BREAKTHROUGH.md` H9).
4. **Functional safety = ASIL-D** for any element whose failure causes
   uncontrollable hazard (ISO 26262-3 HARA). Lattice fit does **not**
   substitute for ASIL evidence.

---

## §4 HARD walls Stage-5 cannot break

Per [`LIMIT_BREAKTHROUGH.md`](LIMIT_BREAKTHROUGH.md) §2.1. 각 벽은
**정량 경계 + 출처 + Stage-5 함의**를 함께 명시한다. 소프트웨어·아키텍처
단독으로는 어느 한 벽도 깨지지 않는다.

| # | Wall | Quantitative bound | Origin | Stage-5 implication |
|---|------|-------------------|--------|---------------------|
| H4 | 타이어–노면 마찰 | μ ≤ ~1.0 (dry) · 0.3 (wet) · 0.1 (ice) | Coulomb 접촉역학 | L5도 블랙아이스에서 슬립 — 물리, 소프트웨어 아님 |
| H5 | Braess's paradox | 노드 추가 시 균형 throughput price-of-anarchy ≤ 4/3 (Roughgarden–Tardos 2002) | 네트워크 게임이론 (Braess 1968) | 100% L5 fleet도 도심 위상 정체를 제거하지 못함 |
| H6 | 정지거리 | d ≥ v·t_r + v²/(2μg);  v=30 m/s, μ=0.9, t_r=0.1 s → d ≥ 73 m | Newton + H4 | t_r → 0에서도 71 m 잔존; compute가 아닌 관성 |
| H7 | Perception decidability | PAC m ≥ Ω(d/ε²); robust m ≥ Ω(√d · d/ε²) (Schmidt 2018) | PAC-learning + adversarial | 일반 "is-pedestrian" oracle 없음 — ODD 제한만이 우회 |
| H8 | V2X 광추 | RTT ≥ 2L/c; L=300 m → 광추 RTT ≥ 2 μs, 실측 스택 1–10 ms | 특수상대성 + 스택 오버헤드 | 사이클 안에 cooperative consensus 불가한 거리 존재 |
| H9 | Fatality baseline | US 1.33 / 100M VMT (NHTSA FARS 2023); 규제 천장 ≤ 0.13 / 100M VMT | 통계 + 사회 협상 | 95% 신뢰 유의성에 ~275M VMT 필요 (Kalra–Paddock 2016) |

**보조 정량 노트**:

- **H6**: t_r = 100 ms reflex (A20)에서도 v·t_r = 3 m 잔존이며 v²/(2μg) 항이 dominant. 도심 8.3 m/s (30 km/h)에서도 d ≥ 4.7 m.
- **H7**: ImageNet-스케일 d ≈ 10⁶ 가정 시 robust m ≥ 10⁹ — 현 글로벌 라벨링 산업(~10⁸/yr) 1자릿수 부족.
- **H9**: Waymo 누적(2024) ~50M autonomous miles는 95% 유의성 도달의 1/5. 단일 operator가 *통계로* L5 안전을 증명하기까지 ~5–10년 누적 운영 필요.

**Stage-5 cannot violate H4–H9.** It can only *engineer around* them
via ODD design, redundant sensing, and MRM fail-operational behavior.

---

## §4.5 캐노니컬 추가 HARD walls (H10–H15)

§4의 H4–H9 외에 Stage-5 §3 4-게이트 통과를 깊이 막는 6개 **시스템·표준·시장·사이버 메타-벽**. §5의 기술 돌파가 *모두* 성공해도 행정·계리·운영 단계에서 봉쇄되는 지점.

| # | Wall | Quantitative bound | Origin | §3 게이트 |
|---|------|-------------------|--------|-----------|
| H10 | ASIL-D 잔존 고장률 | random HW ≤ 10⁻⁸ dangerous failures/h (ISO 26262-5 §9) | 표준 (HARD by certification) | §3-4 |
| H11 | Robust generalization gap | robust m / standard m ≥ Ω(√d) (Schmidt 2018) | 정보이론 | §3-3, H7 강화 |
| H12 | Reliability chain rule | P(sys fail) ≥ 1 − ∏(1−p_i); N=50 ASIL-D 요소 → 5·10⁻⁷/h 누적 | 확률 합성 | §3-2, §3-4 |
| H13 | Sim-to-real Wasserstein floor | W₂(P_sim, P_real) ≥ ε₀ > 0 (모든 유한 generator) | 측도론 (Arjovsky 2017) | §3-3, H7 강화 |
| H14 | Liability–reinsurance 천장 | 글로벌 reinsurance capacity ~$700B (Swiss Re sigma 2024) | 보험 자본시장 | §3-1, 규제 |
| H15 | Cyber attack-surface 비대칭 | OTA 패치 ≥ ISO 26262-2 freeze + 21434 TARA 재검증(주 단위) ≫ 공격자 weaponization (시간/일) | ISO/SAE 21434, Kerckhoffs | §3-2, §3-4 |

**왜 §4.5가 §4와 분리되는가**: H4–H9는 1차 물리·통계 벽이고,
H10–H15는 **시스템·표준·시장·사이버 메타-벽**. 후자는 §5의 기술
돌파가 모두 성공해도 *행정·계리·운영* 단계에서 봉쇄된다.

**해설**:

- **H10**: random HW ≤ 10⁻⁸/h. 평균 50 vh-h/day × 10⁶ fleet → 5·10⁷ vh-h/day → *random HW 단독으로* 0.5 dangerous failure/day 시스템 전체. systematic SW 결함은 별도 ISO 26262-6 process 증거 필요 — 격자 산술로 대체 불가.
- **H11**: Schmidt et al. (2018) — adversarial-robust generalization은 standard보다 sample-complexity √d배. d~10⁶ 시 robust m ≥ 10⁹. **VLA scaling (A1)** 단독으로 못 깬다.
- **H12**: §3-2 system fallback이 N개 ASIL-D 요소의 chain rule로 약화. **TMR (A5)** redundancy는 3× headroom만 제공 — 50개 요소면 여전히 한계 위.
- **H13**: §5의 **합성 corpus only (E79)** · **counterfactual sim (B30)**이 깨려는 벽. Arjovsky (Wasserstein-GAN, 2017) — *어떤* 유한 generator도 진짜 분포와 W₂ > 0. *희귀 long-tail*은 sim에서 학습 불가능한 영역이 항상 존재.
- **H14**: 제조사 100% 책임 시프트 (C61)의 자본시장 천장. 글로벌 reinsurance ~$700B capacity. Stage-5 fleet $1T+ 노출 시 자본 부족 → C61 단독으로 깰 수 없음.
- **H15**: OTA 패치 사이클이 공격자 weaponization 사이클보다 본질적으로 느림. ISO 26262 변경관리 freeze + 21434 TARA 재검증 = 주 단위. zero-day weaponization = 시간/일 단위. **비대칭은 supplier 측 손해**.

---

## §4.6 합성 정리: SOFT chain ≠ HARD break

**정리** (SOFT 합성의 한계). HARD wall W가 변수 x의 부등식
g(x) ≤ c (c는 물리/표준 상수)로 표현되면, SOFT 우회
{b₁, b₂, …, bₙ}는 *x를 더 효율적으로 사용*하는 곱 ∏ gᵢ을 제공할 뿐
c 자체는 변경하지 않는다. ∏ gᵢ < ∞ 인 한 c를 넘는 g(x)는 달성 불가.

**Corollary (Stage-5)**: §5의 어떤 SOFT 우회 조합도 H4(μ ≤ 1.0),
H6(v²/(2μg)), H8(c), H9(NHTSA 통계 유의성 ≥ 275M VMT), H10(ASIL-D
표준 10⁻⁸/h) 자체를 *제거*하지 못한다. **우회 = 벽 안에서 최적화**,
**돌파 ≠ 벽 제거**.

**구체 사례 — H4 우회 조합의 한계**:

- 예측 grip estimator (B39) × V2I 노면 사전 통보 (B34) × 가변-tread 스마트 타이어 × AV 전용 anti-ice 살포 = **μ-aware operation**.
- 4개 SOFT × 평균 1.2 효율 향상 ≈ 2.07× 운영 안전 마진 — 그러나 *μ_road = 0.1 (ice)일 때 μ_effective ≤ 0.1*. 정지거리 v²/(2·0.1·9.8) 자체는 불변.

**결론**: §5는 *기댓값* 안전을 끌어올리는 도구이지 *최악 시나리오*
봉쇄를 깨는 도구가 아니다. Stage-5 §3 4-게이트 통과는 §5 + **ODD 제한
(= 분포 자체를 자르는 경계 작업)**의 조합으로만 가능.

---

## §4.7 §5.6 통합 시너지의 잔존 봉쇄점

§5.6의 4가지 가장 plausible 조합 각각에 대해, §4 + §4.5 벽 중 어느
것이 *잔존*하는가를 명시. 봉쇄는 *조합 안의 가장 약한 게이트*에 의해
결정된다.

| §5.6 조합 | 1차 통과 | 잔존 봉쇄 (조합으로도 안 깨지는 벽) |
|----------|---------|------------------------------------|
| **1. Closed-ODD bootstrap** (C53+A20+B49) — 공항·광산 → 일반 ODD | §3-1 (ODD 제한), §3-4 (reflex 분리) | **H7** (일반 ODD 확장 시 long-tail 재등장), **H11** (robust m gap), **H14** (확장 시 책임 자본), **H9** (275M VMT 누적 시간) |
| **2. Infrastructure-absorbed H7** (C51+B34+HD-map prior) — 스마트로드 | H7 부분 흡수 | **H8** (V2X RTT 광추), **H10** (인프라 의존 ASIL-D — 인프라 다운 시 fail-degraded), **H14-class capex** (km당 인프라 비용 $10⁶ 클래스), **H15** (인프라 사이버 면적 폭증) |
| **3. Continuous-ODD score** (A6+A14+B30) — 연속 신뢰값 | §3-1 의미 재정의 | **H11** (PAC), **H10** (shield 자체 ASIL-D 인증), **H13** (B30의 sim-to-real floor), **§3-1의 규제 수용성** (이진→연속 게이트 인정 사례 없음) |
| **4. H9 정치경제 패키지** (C57+C61+C67) — 보험풀+책임시프트+NTSB | H9 사회 게이트 부분 완화 | **H4–H8** 무관 (기술 벽 못 깸), **H14** (재보험 자본 천장), **H15** (cyber liability), **H10** (ASIL-D는 협상 불가) |

**메타-관측**: 4개 조합 모두 **H10 또는 H14에서 봉쇄**된다. Stage-5
봉쇄의 *마지막 잠금*은 물리(H4–H8)도 perception(H7·H11)도 아닌
**표준·재보험(H10·H14) 메타-벽**이다. §5의 90개 벡터 중 H10·H14를
정면 다루는 것은 C58(AI driver's license), C61(책임 시프트),
B44(black-box mandate), C68(open safety case) 정도 — *합성 가능성이
가장 적게 탐색된 축*.

**미커버** (raw#10 C3 — 별도 audit 필요):

- **H10 · H14 합성** 양산 통합 사례 부재 — 학계·산업 모두 *기술 게이트* 위주 탐구.
- **H13 (sim-to-real)** 정량 측정 표준 부재 — operator마다 자체 metric (Waymo MPI, Mobileye REM 등은 모두 *behavioral* metric, *distributional* metric 아님).
- **H15 cyber vs ISO 26262 변경관리 freeze**의 시간 비대칭은 ISO/SAE 21434(2021)가 *정의*했을 뿐 *해결*하지 않은 상태.

---

## §5 돌파 벡터 (Breakthrough vectors)

§4의 HARD walls는 깰 수 없다. Stage-5 4-게이트(§3) 통과는 *벽을
우회하는 조합*이 만든다. 단일 후보로 통과하는 경로는 없다.

각 항목 뒤 `[ ]` 라벨은 §3 게이트(§3-1 ODD · §3-2 Fallback · §3-3 OEDR · §3-4 ASIL-D) 또는 §4 HARD wall(H4–H9) 표기.

### §5.1 A — 아키텍처 (스택 구조) · 23

1. **VLA foundation driver** — 단일 vision-language-action end-to-end (Waymo EMMA · Wayve LINGO). 장: long-tail 일반화. 단: 해석성·ASIL-D 인증 난제. [H7]
2. **Symbolic-neural hybrid** — neural perception + classical/SMT planner with formal safety set. [H7·§3-4]
3. **World-model rollout MPC** — 학습 dynamics 위 N초 imagine→optimize (Dreamer-V / JEPA). [H7]
4. **HJ-reachability shield** — 학습 policy 위 reachable-unsafe-set 형식 안전 wrapper. [§3-4]
5. **TMR 이종 컴퓨트** — camera-only / radar-only / LiDAR-only 3-voter (항공우주식). [§3-2·§3-4]
6. **Sparse MoE policy** — 시나리오 expert hot-swap (고속·도심·주차·악천후). [§3-1]
7. **Memory-augmented driver** — 차량 + 플릿 전체 prior drive RAG 호출. [H7]
8. **Diffusion scene-prediction** — 확률적 multi-modal 미래 샘플링 → worst-case planning. [H7]
9. **State-space attention (Mamba)** — 분 단위 long-horizon 시계열 perception. [H7]
10. **Implicit neural HD-map field** — tile 경계·sparsity 없는 연속 표상. [S8]
11. **Event-camera + neuromorphic spike compute** — μs 시간해상도, μJ 추론, motion-blur 0. [H6]
12. **Active sensing 헤드** — 가림 회피용 sensor pose 능동 제어 (사람의 peek). [H7]
13. **Conformal-prediction wrapper** — 모든 신경 출력에 bounded-risk 신뢰구간. [§3-4·H9]
14. **Selective prediction / IDK token** — "모름"을 1급 출력 → 즉시 MRM 트리거. [§3-2·H7]
15. **Game-theoretic interaction planner** — 타 에이전트 반응 함수까지 모델링. [H7]
16. **Test-time compute scaling** — 불확실 ↑ → 추론 budget ↑ (LLM 스타일). [H7]
17. **Factor-graph fusion** — uncertainty-aware multi-modal late fusion. [Sensor-fusion]
18. **Photonic on-chip LiDAR** — 10× 저가 + 100× 해상도 + ASIL-rated. [S3]
19. **FMCW imaging radar (4D + 속도)** — 안개·먼지·악천후서 LiDAR 대체. [§3-1]
20. **분리된 sub-100ms reflex 레이어** — 비상 제동만 FPGA/ASIL-D 분리, 메인 compute crash 무관. [§3-2·§3-4·H6]
21. **Differentiable physics planner** — 마찰·관성 미분가능 모델 MPC. [H4·H6]
22. **Causal-graph object permanence** — occlusion 사이 ID 유지. [H7]
23. **Cryptographic model attestation** — 규제기가 실제 차에 도는 가중치 검증. [규제]

### §5.2 B — 메커니즘 (운영·엔지니어링 트릭) · 27

24. **계층적 MRM 사다리** — slow → pull-over → curbside → full-stop, 단계별 독립 ASIL-D. [§3-2]
25. **확률적 ODD score** — binary in/out 대신 연속 신뢰값 → 자동 감속. [§3-1]
26. **Online 보정 drift 검출** — camera/LiDAR extrinsic 자동 재정렬. [H7]
27. **Continuous adversarial regression suite** — 매 빌드 worst-case 시나리오 1만 개 회귀. [H7]
28. **Inverse-RL on fleet human-takeover** — 인간 인계 모든 케이스 = 학습 신호. [H7]
29. **Sleep-cycle consolidation** — 야간 충전 중 그날 엣지케이스 재학습. [H7]
30. **Counterfactual fleet sim** — 모든 disengagement → 10k 변형 시뮬 회귀. [H7·H9]
31. **Active-learning labeling request** — 차량이 모호 케이스를 다음 정차 시 라벨 요청. [H7]
32. **Per-jurisdiction parameter pack** — 국가/주별 디폴트 hot-swap. [§3-1]
33. **Time-budget per maneuver** — 안전 윈도우 넘기 전 결정 강제. [H6·§3-4]
34. **Pre-emptive lane change via V2I** — 200 m 앞 통제구역 인프라 사전 통보. [H7·H8]
35. **V2V cooperative emergency braking** — 앞앞차 brake → 4대 동시 감속 (chain). [H6]
36. **Pedestrian gaze/gait 의도 분류기** — 보행 직전 1.5초 예측. [H7]
37. **Cyclist / animal / debris 전용 채널** — 다중-task 헤드 분리. [H7]
38. **Roadside RSU annotation pipeline** — 공사구역 실시간 메쉬 업데이트. [H7]
39. **Predictive grip estimator** — 타이어압 + 기온 + 노면 mmWave 반사. [H4]
40. **Drive-by-wire 이중 모터 + 기계 백업** — 1중 고장 시 기계 컬럼. [§3-2·§3-4]
41. **Sensor self-test 상시** — 열화 센서 즉시 모드 강등. [§3-2]
42. **Anomaly-flag-then-slow** — 분류 실패 → 추측 X, 감속 + MRM 예열. [H7]
43. **Risk-budget per mile** — km당 위험 quota 차량 자체 관리. [H9]
44. **Black-box mandate** — FAA 비행기록기 양식 모든 disengagement 감사. [규제·H9]
45. **Bi-directional 5G teleop fallback** — MRM 최종 단계 인간 원격조종. [§3-2]
46. **Drone-spotter 페어** — UAV 선행 정찰로 occlusion 사전 노출. [H7]
47. **3D 음향 분석** — 사이렌·브레이크 비명·아이 울음 SLA 인식. [H7]
48. **Formal scene grammar 파서** — pixel 분류 대신 agent-set + 상호작용 파싱. [H7]
49. **Shield from temporal logic spec** — STL / LTL → runtime monitor 자동 합성. [§3-4]
50. **Continual privacy-preserving 플릿 학습** — DP / FHE로 PII 없이 글로벌 학습. [규제]

### §5.3 C — 패러다임 (사회·규제·경제 리프레임) · 25

51. **Infrastructure-first L5** — 스마트로드(센서 매립 + RSU + V2X)가 ODD를 *도로*가 보장 → H7 인프라 흡수.
52. **AV-only ROW** — 전용 차로 / 지하 freight 터널. [H5·H7]
53. **Domain-specific L5 부트스트랩** — 공항셔틀 · 광산 · 항만 · 농업 (폐쇄 ODD = trivially L5) → 일반 ODD 점진 확장.
54. **Robotaxi 우선 → 사유차 일몰** — 혼합교통 제거로 행위 다양성 ↓.
55. **Per-route 인증 모델** — 노선별 L5 (LAX–Vegas L5, generic L4) 점진 확장.
56. **ODD-as-public-good** — 정부가 항공교통관제처럼 ODD 영역 인증·공개 (현재는 운영사 단일 책임).
57. **Insurance-pool 규제** — 운영사 풀 단위 사망률로 L5 게이팅 (개체별 X). [H9]
58. **AI driver's license** — 모델 SKU별 인증, 차량별 재인증 X.
59. **Continuous regulatory loop** — 모든 disengagement 실시간 규제기 대시보드.
60. **AV-specific 법정 (specialized AV courts)** — 책임 신속 판결 → 보험사 risk premium ↓.
61. **제조사 100% 책임 시프트** — 운전자 책임 제거 → 규제 게이트 ↓ (테슬라식).
62. **Congestion pricing as default** — Singapore++ 보편화. [H5]
63. **Tidal-flow lanes** — 실시간 방향전환 차로. [H5]
64. **수요 shaping (B2B 야간 배송)** — peak demand 분산. [H5]
65. **Sub-zone pedestrianization** — no-car zones + 가장자리 AV depot. [H5·H7]
66. **Right-of-way auction at 교차로** — V2X bid 우선권. [H5·H8]
67. **NTSB-식 항공식 사고조사** — 모든 AV 사망사고 공개 보고. [H9]
68. **Open safety case 의무화** — 기업비밀 대신 투명성으로 사회 동의.
69. **Red-team-as-regulator** — 규제기관이 adversarial scenario 제출.
70. **Compulsory V2X mandate** — 안전벨트식 의무화 → S7 SOFT 강제 격파.
71. **Government 911-for-AV teleop center** — 국가 운영 마지막 fallback. [§3-2]
72. **Modular chassis 인증** — compute swap = ODD 재인증 (vehicle별 X).
73. **Speed-by-context 자동 규제** — 도심 30 km/h, 고속 100 km/h 차량 강제. [H5·H6·H9]
74. **Stage-5 시민 옵트인 lane** — 시민이 "AV 통행 동의" 동네 선택 (Phoenix 모델 확장).
75. **Verifiable simulator 표준** — NCAP-식 sim-benchmark 공인.

### §5.4 D — HARD wall별 우회 매핑

| Wall | 우회 후보 (단독 X, 조합 O) |
|------|----------------------------|
| H4 마찰 (μ ≤ 1.0) | 예측 grip estimator · V2I 노면 통보 · 자동 체인 · 가변-tread 스마트 타이어 · AV 전용 차로 anti-ice 사전 살포 |
| H5 Braess | Congestion pricing 보편화 · tidal lanes · AV-only express · OD 쿼터 · 야간 freight · 분산 depot · sub-zone pedestrianization · 지하 freight 터널 |
| H6 정지거리 v²/(2μg) | V2V cooperative braking · V2I cycle 예측 · sub-200ms FPGA reflex · 확률적 pre-braking · 도심 30 km/h 강제 |
| H7 인지 long-tail | HD-map prior (S8 확장) · cooperative perception (RSU+V2V) · world-model imagination · VLA scaling · formal scene grammar · anomaly-then-slow · 능동 sensing · event-camera · drone-spotter · domain-restricted L5 |
| H8 V2X 광추 (c) | 안전-크리티컬은 V2X 비의존 (edge-only) · 5G NR sidelink 1 ms 직접 V2V · RSU 메쉬 · cellular V2X (DSRC 폐기) |
| H9 사망률 ≤ 0.13 / 100M VMT | 단계 ramp (1× → 0.1× 인간) · 작은 ODD부터 · insurance-pool 단위 · NTSB 투명성 · 보호 보행자/저속 도시부터 · 보험사 risk pricing |

### §5.5 E — 와일드카드 (speculative / 고위험-고보상) · 15

76. **Quantum gravimetric INS** — GPS 거부 환경 cm 정확도. [HD-map]
77. **Single-photon quantum LiDAR** — 1 km 안개 관통. [H7]
78. **광컴퓨팅 perception path** — fJ / 추론. [H7·전력]
79. **합성 corpus only training** — diffusion-world로 sim-to-real 격차 0. [H7]
80. **Embodied LLM 실시간 규제기 audit trail** — 의사결정 trace 자동. [규제·H9]
81. **HD-map as continuous neural field** — tile 경계 제거. [S8]
82. **Inductive charging lanes** — 무한 range → ODD 확장. [S1]
83. **Bose-Einstein gyroscope** — drift-free INS. [HD-map]
84. **Olfactory / photoacoustic 환경센서** — 누유 · 가스 · 연기. [H7]
85. **All-robot fleet pretraining** — drone + humanoid + car 공동 representation. [H7]
86. **Robotaxi as roving public-good 센서** — pothole · 날씨 · 교통. [경제]
87. **Homomorphic-encrypted V2X** — 프라이버시 보장 V2V. [규제]
88. **Programmable matter 차선 표시** — 동적 ROW 재구성. [H5]
89. **Multi-fidelity sim ladder** — 매 엣지케이스 cheap → expensive 자동 escalation. [H7]
90. **차량 = city 컴퓨트 노드** — 자율주행 + 분산 edge 클라우드 제공. [경제]

### §5.6 통합 시너지 (12–24개월 가장 plausible)

단일 후보로 4-게이트를 통과하는 경로는 없다. 다음 조합이 가장 현실적:

1. **Closed-ODD L5 부트스트랩** = C53(domain-specific) + A20(reflex 분리) + B49(shield) → 공항·광산 → sub-100ms ASIL-D shield → 일반 ODD 확장 로드맵
2. **Infrastructure-absorbed H7** = C51(스마트로드) + B34(V2I 사전통보) + D-H7(HD-map prior) → Phoenix 모델 100× 확장의 *인프라식* 우회
3. **Continuous-ODD score** = A6(MoE) + A14(selective prediction) + B30(counterfactual sim) → 이진 ODD 대신 *확률* ODD, 게이트 자체 재정의
4. **H9 정치경제 패키지** = C57(insurance pool) + C61(제조사 책임) + C67(NTSB 투명성) → 기술 게이트보다 *빠른* 규제 게이트 완화

**Under-explored** (학계엔 있는데 양산 통합 부재):
- **C56 (ODD-as-public-good)** — 항공관제식 ODD 공공인프라화. 현 산업은 운영사 단일 책임 부담.
- **A2 + A13 + B49** — neural-symbolic + conformal + formal shield 양산 통합.
- **C60 (AV courts)** — 법-제도 게이트 완화가 기술 게이트보다 빠를 수 있음.

**미커버 축** (별도 audit 대상): (a) 에너지·열관리, (b) 사이버보안 (CAN / V2X 공격), (c) 인간-AV 인터페이스 (탑승자 신뢰).

---

## §6 Honesty caveats (raw#10 C3 — UNVERIFIED at scale)

Mirroring [`README.md`](README.md) §Verify and
[`LIMIT_BREAKTHROUGH.md`](LIMIT_BREAKTHROUGH.md) §2.3.1:

- **L5 at scale is UNVERIFIED.** No operator has independently-audited
  L5 (unrestricted ODD) deployment in 2024–2026.
- **Waymo = L4 geofenced** (Phoenix / SF / LA / Austin). Operating
  commercially, but inside its ODD only.
- **Tesla FSD = L2 supervised.** Driver monitoring required. NOT L5.
- **Cruise (GM) = defunct as of 2024** after the Oct-2023 incident.
- **Mobileye / Baidu Apollo / Pony.ai / Aurora / NVIDIA DRIVE** each
  use their own intervention / MTBF / sim-hour metrics — no
  cross-operator lattice fit.
- **ASIL-D claims** require ISO 26262 process evidence (HARA → FSR →
  TSR → HSI → ISO 26262-2/-3/-4/-6/-9), not n=6 lattice arithmetic.
- **NCAP / IIHS** scores come from agency protocols, not from this
  substrate.
- All "L5 in N years" claims remain **UNVERIFIED until
  regulator-cleared**.

The substrate ships `v0.1.0` as a **BUNDLE_FIRST** thematic bundle of
canon docs. The L5 autonomy badge in README is intentionally
`UNVERIFIED`.

---

## §7 References

- **SAE J3016** — Taxonomy and Definitions for Terms Related to
  Driving Automation Systems (L0–L5)
- **ISO 26262** — Road vehicles — Functional safety (ASIL A–D)
- **UN-R157 ALKS** — Automated Lane-Keeping Systems (highway L3)
- **CA DMV** — Autonomous Vehicle Disengagement Reports 2023–2024
- **NHTSA FARS** — Fatality Analysis Reporting System 2023–2024
- **Waymo Safety Case Framework** (2023)
- **Braess (1968)** — *Über ein Paradoxon aus der Verkehrsplanung*
- **Valiant (1984)** — *A theory of the learnable* (PAC bound for H7)
- Local: [`LIMIT_BREAKTHROUGH.md`](LIMIT_BREAKTHROUGH.md) ·
  [`LATTICE_POLICY.md`](LATTICE_POLICY.md) · [`TODO.md`](TODO.md) ·
  [`README.md`](README.md)

---

> *"Stage-5 means the geofence is gone — not that physics is gone.
> Friction, Braess, and the perception long-tail remain."*

— hexa-mobility canonical Stage-5 reference (2026-05-13; §5 풀 breakthrough 90개 + §4 봉쇄 심화 H10–H15 + 합성 정리 + §5.6 잔존 벽 매핑)
