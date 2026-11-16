# Promod4 S&D + Proximity Revive — Source Overlay

This is an **editable GSC source overlay**, not a compiled mod and not a reconstruction of the proprietary/compiled SLeS mode.

## What this package changes

- Adds the missing `level.onPlayerKilled` callback to Promod4 S&D.
- Adds `revive.gsc` as a separate gametype module.
- Revive is automatic when a living teammate enters the fallen player's 50-unit trigger.
- No USE key and no revive progress timer.
- Revived player is sent through Promod4's normal `_globallogic::spawnPlayer()` pipeline, so the S&D spawn callback selects a normal team spawnpoint instead of placing the player at the corpse.
- Health is set to 100.
- Preserves the round-life counter around the spawn call.

## Files to apply

Use a separate copy of `A1/promod4-master-orignal`; do not edit either SLeS backup folder.

1. Replace `maps/mp/gametypes/sd.gsc` with this package's `maps/mp/gametypes/sd.gsc`.
2. Copy `maps/mp/gametypes/revive.gsc` into the same gametypes folder.
3. Add this line to the existing `mod.csv` in the gametype rawfile section:

```
rawfile,maps/mp/gametypes/revive.gsc
```

4. In the copied Promod4 `sd.gsc`, the setup calls `revive::setup()` only when enabled. This overlay defaults to enabled; set `scr_game_allowrevive 0` in the server config to disable it, or remove the setup call and callback assignment if you want no revive.
5. Add `scr_revivesound 1` to the server config to play the existing Revive sound, or set it to 0.

## Build

Use the Promod4 source project's existing `compile.bat` / `compile_fastfile.bat` with your installed COD4 Mod Tools. This package contains no `mod.ff`, `.iwd`, EXE, or other compiled output.

## Test notes / limitations

- This is a first integration prototype. It has not been compiled or run in a COD4 engine here.
- Test on a local/private server first. Confirm player spawn, weapon loadout, round counter, killcam, and objective flow.
- Revive is disabled after game end and only same-team living players can trigger it.
- The source calls Promod4's `_globallogic::spawnPlayer()`; this is deliberately different from the older Revive module's `_spawnPlayer()`, which does not exist in the Promod4 source.
- Original SLeS GSC source was not present in A1, so this does not claim to be an exact SLeS source rebuild.
- Keep the upstream Promod4 `LICENSE.md` and comply with it when redistributing or modifying the base project.
