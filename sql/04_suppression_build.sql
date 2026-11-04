/* ============================================================
   SQL 04 — Suppression build  (RUN FIRST in the automation)
   Target DE:  SUPPRESSION_DoNotSend  (Action: Overwrite)
   Purpose:    One place that answers "who must NOT be mailed
               today, and why". Every segment query checks this
               DE. The Reason column is mandatory — when a
               stakeholder asks why someone was excluded, this
               table is the answer.
   Sources:    _Bounce (hard bounces), _Unsubscribe,
               Preference_Center_DE (Cadence = Paused),
               win-back journey entrants in the last 30 days.
   ============================================================ */

SELECT SubscriberKey, Reason, SuppressedDate FROM (

    SELECT b.SubscriberKey,
           'Hard bounce' AS Reason,
           GETUTCDATE()  AS SuppressedDate
    FROM _Bounce b
    WHERE b.BounceCategory = 'Hard bounce'

    UNION

    SELECT u.SubscriberKey,
           'Unsubscribed' AS Reason,
           GETUTCDATE()   AS SuppressedDate
    FROM _Unsubscribe u

    UNION

    SELECT p.SubscriberKey,
           'Cadence paused in preference center' AS Reason,
           GETUTCDATE() AS SuppressedDate
    FROM Preference_Center_DE p
    WHERE p.Cadence = 'Paused'

    UNION

    SELECT w.SubscriberKey,
           'In win-back journey within last 30 days' AS Reason,
           GETUTCDATE() AS SuppressedDate
    FROM Winback_Journey_Entrants w
    WHERE w.EntryDate >= DATEADD(day, -30, GETUTCDATE())

) x
