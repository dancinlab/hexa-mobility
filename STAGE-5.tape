#!/usr/bin/env tape

@V := "tape" :: spec [active]
  version = "1.2"

@I id001 := "stage_5" :: identity-claim [d=2026-05-14 active]
  kind = "STAGE-5.md — Stage-5 자율주행 캐노니컬 정의"
  brief = "*DDT = Dynamic Driving Task (steering + accel/brake + OEDR)."
  parent = "dancinlab/hexa-mobility"
  sibling-md = "STAGE-5.md"

# ─── §Log (append @A / @D events here, chronological) ────────────────
# 
# Pre-existing log entries live in STAGE-5.md.
# New per-domain history entries land here as typed events:
#
#   @A commit_<hash> :: <domain> [d=<YYYY-MM-DD> ok]
#     <- <prev-id>
#     => "<one-line description>"
#
#   @D <id> := "<decision-name>" :: <domain> [<grades>]
#     <- <evidence-id>
#     |> <verifier>
#
# See ~/core/tape/spec/tape.md for full grammar.
