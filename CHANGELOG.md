## Unreleased

* A failing database no longer breaks the calling app. A failure to open, read
  or write the local queue is logged and swallowed inside `push()` and
  `flush()` — the same treatment network failures already had, and what this
  SDK's own documentation claimed. Because `initialize()` flushes whatever the
  last session left behind, this is also what let a device with unreadable
  storage fail initialization outright and come up with no analytics at all.

* The `eventId` backfill is per row and best effort. A row that cannot be
  given an id is left as it is rather than failing the migration and taking
  the whole queue with it; it uploads with an empty id, which is where it
  would have been without the migration.

* Add a unique `eventId` (UUID v4) to every event. It is generated when the
  event is created, stored in the local queue alongside it, and sent as a
  top-level field on `/track`. An event that is re-sent — because the app was
  suspended before the `202` landed, so the row was never deleted — arrives
  with the id it was created with, letting the backend drop the duplicate.

  **Backend:** dedupe on `eventId`. Calling apps need no change; the id is
  minted inside `push()`.

  Drift schema goes to **v2**: `PendingEvents` gains an `eventId` column, and
  a `MigrationStrategy` adds it on upgrade. Rows already queued when a device
  upgrades are backfilled with fresh ids, so they carry an id but cannot be
  matched against a copy delivered before the upgrade — a one-time residual
  limited to whatever was in the queue at the moment of the upgrade.

* Add `Beacon.instance.identify(deviceId, email, uid)`: attaches a real email
  and uid to a device's anonymous event history. Apps send their device id in
  the `email` and `uid` fields while logged out; this call asks the backend
  (`POST /identify`) to rewrite that history onto the real identity once the
  user signs in. Flushes pending events first so none are stranded under the
  old identity. Failures are logged, not thrown.

  `uid` is required by the API on every tracked event, so apps must send the
  device id there too while logged out — an empty `uid` is rejected with
  `400 uid is required` and the event never reaches the panel.

* Add `Beacon.instance.refresh()`: uploads all pending events, then starts a
  new session. Events keep the token they were pushed under, so a failed
  upload does not strand them in the wrong session. Exposes
  `Beacon.instance.sessionToken`.

## 0.0.1

* Initial Beacon Flutter SDK with Drift-backed batching, `push` / `flush`, and configurable `apiKey`, `baseUrl`, and `batchSize`.
