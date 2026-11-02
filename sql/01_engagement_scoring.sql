/* ============================================================
   SQL 01 — Engagement scoring
   Automation: NW_Nightly_Audience_Build (runs 02:00, before 02–04)
   Target DE:  ENGAGEMENT_Scores  (Action: Overwrite — idempotent)
   Purpose:    One row per subscriber with trailing-90-day opens/
               clicks from the system data views, an engagement
               band, and days since last engagement. Everything
               downstream (segments, suppression, AMPscript
               lookups) reads THIS table, never the raw views.
   Notes:      _Open/_Click hold ~6 months of data. OMM opens
               (Apple Mail Privacy) inflate Opens_90d — clicks
               are the more trustworthy signal, so the band is
               driven by last CLICK first, then last open.
   ============================================================ */

SELECT
    m.SubscriberKey,
    MAX(o.EventDate)  AS LastOpenDate,
    MAX(c.EventDate)  AS LastClickDate,
    SUM(CASE WHEN o.EventDate >= DATEADD(day, -90, GETUTCDATE()) THEN 1 ELSE 0 END) AS Opens_90d,
    SUM(CASE WHEN c.EventDate >= DATEADD(day, -90, GETUTCDATE()) THEN 1 ELSE 0 END) AS Clicks_90d,
    DATEDIFF(day,
        COALESCE(MAX(c.EventDate), MAX(o.EventDate)),
        GETUTCDATE()) AS DaysSinceLastEngagement,
    CASE
        WHEN DATEDIFF(day, COALESCE(MAX(c.EventDate), MAX(o.EventDate)), GETUTCDATE()) < 30  THEN 'Engaged'
        WHEN DATEDIFF(day, COALESCE(MAX(c.EventDate), MAX(o.EventDate)), GETUTCDATE()) < 90  THEN 'Cooling'
        ELSE 'Lapsed'
    END AS EngagementBand
FROM MASTER_Subscribers m
LEFT JOIN _Open  o ON o.SubscriberKey = m.SubscriberKey
LEFT JOIN _Click c ON c.SubscriberKey = m.SubscriberKey
WHERE m.Status = 'Active'
GROUP BY m.SubscriberKey
HAVING MAX(o.EventDate) IS NOT NULL OR MAX(c.EventDate) IS NOT NULL
