# Data Model — Data Extension Schemas

All DEs live in a `Portfolio_Northwind` folder in Data Designer. Sendable DEs are related to All Subscribers on `SubscriberKey`.

## 1. MASTER_Subscribers (sendable)

Source of truth for every subscriber in the program. One row per subscriber.

| Field | Type | Length | Key | Nullable | Notes |
|---|---|---|---|---|---|
| SubscriberKey | Text | 254 | PK | No | Email address in this demo build |
| EmailAddress | EmailAddress | 254 | | No | |
| FirstName | Text | 100 | | Yes | Falls back to "there" in personalization if empty |
| LastName | Text | 100 | | Yes | |
| SignupDate | Date | | | No | Drives the welcome journey entry window |
| SignupSource | Text | 50 | | Yes | `web_form`, `import`, `pos` |
| PreferredStore | Text | 100 | | Yes | Used for the dynamic store block |
| LoyaltyTier | Text | 20 | | Yes | `Base`, `Silver`, `Gold` |
| Status | Text | 20 | | No | `Active`, `Unsubscribed`, `Bounced` |

Retention: 730 days, row-based. Sendable: yes.

## 2. ENGAGEMENT_Scores (sendable)

Refreshed nightly by SQL 01. One row per subscriber who has ever engaged.

| Field | Type | Key | Notes |
|---|---|---|---|
| SubscriberKey | Text (254) | PK | |
| LastOpenDate | Date | | Most recent open from the `_Open` data view |
| LastClickDate | Date | | Most recent click from the `_Click` data view |
| Opens_90d | Number | | Count of opens in the trailing 90 days |
| Clicks_90d | Number | | Count of clicks in the trailing 90 days |
| DaysSinceLastEngagement | Number | | `DATEDIFF(day, last engagement, today)` |
| EngagementBand | Text (20) | | `Engaged` (<30d), `Cooling` (30–89d), `Lapsed` (90d+) |

## 3. Purchase_Activity (non-sendable)

| Field | Type | Key | Notes |
|---|---|---|---|
| SubscriberKey | Text (254) | PK (composite) | |
| OrderID | Text (50) | PK (composite) | |
| OrderDate | Date | | |
| OrderTotal | Decimal (10,2) | | |
| ProductCategory | Text (100) | | `Footwear`, `Outerwear`, `Camping`, `Climbing` |

## 4. Preference_Center_DE (sendable)

Written by the CloudPage, read by the dynamic email block and the win-back SQL.

| Field | Type | Key | Notes |
|---|---|---|---|
| SubscriberKey | Text (254) | PK | |
| Cadence | Text (20) | | `Weekly`, `Monthly`, `Paused` |
| Interest_Footwear | Boolean | | |
| Interest_Outerwear | Boolean | | |
| Interest_Camping | Boolean | | |
| Interest_Climbing | Boolean | | |
| UpdatedDate | Date | | Set by the CloudPage on every save |

## 5. SEG_Welcome (sendable)

Built by SQL 02. Subscribers who signed up in the last 24 hours, `Status = Active`, not in the suppression DE. Entry source for `Welcome_Journey_v1`. Columns mirror `MASTER_Subscribers` plus `JourneyEntryDate`.

## 6. SEG_Winback_90Day (sendable)

Built by SQL 03. `EngagementBand = Lapsed`, at least one purchase OR signup older than 120 days, cadence not `Paused`, not suppressed. Entry source for `Winback_Journey_v1`. Columns mirror `MASTER_Subscribers` plus `LastEngagementDate` and `OfferCode`.

## 7. SUPPRESSION_DoNotSend (non-sendable)

Built by SQL 04. Hard bounces, unsubscribes not yet reflected in `MASTER_Subscribers.Status`, `Cadence = Paused`, and anyone already in the win-back journey in the last 30 days (frequency protection).

| Field | Type | Key | Notes |
|---|---|---|---|
| SubscriberKey | Text (254) | PK | |
| Reason | Text (100) | | Why they are suppressed — always populate; future-you will ask |
| SuppressedDate | Date | | |
