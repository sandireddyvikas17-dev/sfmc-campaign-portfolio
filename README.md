# SFMC Campaign Portfolio — End-to-End Build

**Builder:** Vikas Sandireddy, Salesforce Marketing Cloud Developer (7+ years overall, 5+ years hands-on SFMC)
**What this is:** A personal portfolio build. One complete, production-style Marketing Cloud campaign for a fictional demo brand, built and documented piece by piece so every part can be shown, screenshotted, and talked through in an interview.
**Demo brand:** *Northwind Outfitters* — an outdoor retail brand (fictional; any resemblance to a real company is incidental). No employer data, no employer systems, nothing from Citigroup, UnitedHealth Group, or American Express.

## The problem this solves

Northwind was running welcome and win-back mail with no clean way to explain who had been excluded or why, while lapsed contacts kept getting sent to and new subscribers got a generic first touch. Trail Rewards fixes that order: build the suppression list first, score engagement in one place, and only then send.

## The campaign

**"Trail Rewards" re-engagement + welcome program**

1. **Welcome journey** — new subscribers get a 3-touch welcome series over 7 days.
2. **Re-engagement journey** — subscribers with no opens/clicks in 90 days get a win-back offer; non-responders are moved to a reduced-cadence segment instead of being mailed at full volume.
3. **Preference center** — a CloudPage where subscribers control cadence (weekly / monthly / paused) and interests, writing straight back to a data extension.

## Architecture

```
Signup form / import
        │
        ▼
MASTER_Subscribers ──────► Preference_Center_DE (CloudPage writes)
        │                            │
        ▼                            ▼
AUTOMATION (daily, Automation Studio)
  SQL 01: engagement scoring  ──►  ENGAGEMENT_Scores
  SQL 02: welcome audience    ──►  SEG_Welcome
  SQL 03: win-back audience   ──►  SEG_Winback_90Day
  SQL 04: suppression build   ──►  SUPPRESSION_DoNotSend
        │
        ▼
JOURNEY BUILDER
  Welcome_Journey_v1        (entry: SEG_Welcome)
  Winback_Journey_v1        (entry: SEG_Winback_90Day)
        │
        ▼
EMAIL (Content Builder)
  Dynamic AMPscript template — hero, product block and CTA
  change by segment + preference data, with safe fallbacks
```

## Repo layout

| Folder | Contents |
|---|---|
| `data-model/` | Data extension schemas (fields, types, keys, retention) + seed data CSVs |
| `sql/` | Automation Studio SQL Query Activities, in run order |
| `ampscript/` | The dynamic email content block + a small function library |
| `cloudpages/` | Preference center page (HTML + AMPscript) |
| `ssjs/` | Server-side JavaScript: CloudPage form processing + a REST utility |
| `journey/` | Journey design documents (entry, splits, waits, goals, exit rules) |
| `docs/` | Build log (one entry per build session — feeds LinkedIn knowledge posts) |

## Conventions used throughout

- Sendable DEs relate to All Subscribers on `SubscriberKey` (= email in this demo build; in production, a stable customer ID).
- Every SQL query is **idempotent** — it overwrites its target DE, so re-running an automation never duplicates rows.
- Every dynamic block has a **fallback**: if a lookup returns nothing, the email still renders with default content. No blank heroes, no broken sends.
- Naming: `SEG_` audience segments, `SUPPRESSION_` exclusion DEs, `MASTER_` source-of-truth DEs.

## How success is read

Click rate is the headline number. Opens are directional only — Apple Mail Privacy inflates them — so they sit in a footnote, not the headline. The reporting query (`sql/05_journey_reporting.sql`) is built that way: sends, unique clicks and unsubscribes per journey email, with click rate calculated from sends, and the data-view caveats (about 6 months of history, a send means accepted by the MTA, not delivered to the inbox) written into its header so nobody over-reads it later.

## The 90-second version (interview talk track)

"Northwind couldn't explain its exclusions, lapsed contacts kept getting mailed, and new subscribers got a generic welcome. I built Trail Rewards to fix the order. First, a suppression build where every excluded contact carries a Reason you can look up. Second, one engagement-scoring table that every segment reads, judged on clicks, not inflated opens. Then the welcome and win-back segments, a dynamic AMPscript hero with fallbacks so bad data never breaks a send, and a CloudPages preference center that lets people pause instead of unsubscribing. Reporting closes the loop the same honest way: clicks as the headline, opens as a footnote."

## What I would build next

A Salesforce Data Cloud (Data 360) extension feeding this same suppression and engagement pattern — the same one-table scoring idea, sourced from Data Cloud instead of only the Marketing Cloud data views. That connects this portfolio to the Data Cloud work I have done since 2023, rather than adding a new tool for show.

## Status

See `docs/BUILD_LOG.md` — updated after every working session.
