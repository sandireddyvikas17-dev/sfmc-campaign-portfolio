# LinkedIn Posting Plan — "Building in Public" Series

One small post per day from this project, each with a REAL screenshot of the actual file or screen (Vikas's rule: real pictures, no AI graphics). Short, human, one idea per post. Screenshots come from the project files themselves — code as it actually sits in the repo.

| Day | Post idea | Screenshot |
|---|---|---|
| 1 | Start with Northwind's problem, not the architecture: no clean way to explain who was excluded or why, lapsed contacts kept getting mailed, new subscribers got a generic first touch — Trail Rewards fixes that order (suppression first, one engagement table, then send) | README "The problem this solves" section |
| 2 | One engagement table to rule all segments — clicks over opens (Apple Mail Privacy) | `sql/01_engagement_scoring.sql` |
| 3 | Every suppressed contact gets a Reason | `sql/04_suppression_build.sql` |
| 4 | The entry-DE refresh mistake (yesterday's audience) — also today's scheduled knowledge post theme | `docs/QA_CHECKLIST.md` §1 |
| 5 | AMPscript fallbacks: the send must never break | `ampscript/dynamic_hero_block.ampscript` |
| 6 | Preference center: let people pause instead of unsubscribe | `cloudpages/preference_center.html` |
| 7 | Win-back design: it ends with LESS mail, not more | `journey/JOURNEY_DESIGNS.md` |
| 8 | Reporting honesty: click rate is the headline, opens are a footnote | `sql/05_journey_reporting.sql` |

Repo status (Nov 1, 2026): github.com/sandireddyvikas17-dev/sfmc-campaign-portfolio is created and public (empty). Publish in daily pieces alongside the posts — Day 1 = README + data model — once Contents: Read and write is enabled for the Muse app on that repo. After day 8, the series wraps with a "what I built" summary post linking the repo.
