# QA Checklist — Journey Activation & Send Readiness

Run top to bottom before any activation or send. Every item exists because it has caught a real problem at least once.

## 1. Audience (before the journey/send touches anything)

- [ ] Nightly automation finished successfully — check Automation Studio run history, not just the schedule.
- [ ] Entry DE refreshed **after** the automation finished. (Refreshing before is the classic silent failure: the journey activates cleanly and pulls yesterday's audience.)
- [ ] Entry DE row count compared with yesterday's. A spike usually means an import landed, not organic signups — investigate before activating.
- [ ] Suppression DE row count is non-zero and its `Reason` values look sane. Zero suppressions is a red flag, not good news.
- [ ] Spot-check 5 known subscribers: one should be IN the audience, one suppressed (paused cadence), one lapsed-but-excluded (recent win-back entrant), two random.

## 2. Content

- [ ] Send preview against **real contact records** from the entry DE — never only test records with perfect data.
- [ ] All dynamic blocks render for every test record (see the fallback test matrix in `docs/FALLBACK_TESTS.md`).
- [ ] Subject line and hero agree (both come from the same AMPscript band variable — verify they still do after any edit).
- [ ] Every link clicked through in preview; offer code in the URL matches the offer code in the body.
- [ ] View-online, unsubscribe, and preference-center links all resolve. Preference link opens the page with the right subscriber's prefs pre-checked.
- [ ] Plain-text version read once, out loud if needed. Dynamic content that only exists in HTML is a deliverability and accessibility miss.

## 3. Journey settings

- [ ] Re-entry setting matches the design doc (welcome: no re-entry; win-back: 30 days, max 2).
- [ ] Goal and exit criteria set exactly as designed — goal = first click in 14 days (welcome) / any click or purchase in 21 days (win-back).
- [ ] Wait durations use the journey's timezone, not the browser's.
- [ ] Entry schedule starts **after** the nightly automation window, with at least 30 minutes of slack.

## 4. Send

- [ ] Seed list includes at least one address per major inbox provider the audience uses.
- [ ] Send classification and suppression list double-checked on the send itself, not inherited assumptions.
- [ ] First-hour monitoring planned: bounce rate, unsubscribe rate, and one real inbox check.

## Sign-off

| Check | By | Date |
|---|---|---|
| Audience | | |
| Content | | |
| Journey | | |
| Send | | |
