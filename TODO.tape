#!/usr/bin/env tape

@V := "tape" :: spec [active]
  version = "1.2"

@I id001 := "todo" :: identity-claim [d=2026-05-14 active]
  kind = "TODO — hexa-mobility"
  brief = "`v0.1.0` ships as a thin bundle of existing mobility-relevant canon docs"
  parent = "dancinlab/hexa-mobility"
  sibling-md = "TODO.md"

# ─── §Log (append @A / @D events here, chronological) ────────────────
# 
# Pre-existing log entries live in TODO.md.
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
