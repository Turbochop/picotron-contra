# Changelog

## 2026-09-03 — Multiscroll chunk progression

- Imported the latest supplied `contra.p64.png` cartridge and synchronized its decoded Lua source, maps, graphics, sounds, and metadata into the repository.
- Added marker-driven chunk dimensions: metadata sprites `15` and `14` now establish inclusive map width and height, with bounds-aware caching, drawing, collision-map copying, and spawn streaming.
- Cached the immutable source map and mutable play map once per full reset, removing repeated resource fetches from chunk loads.
- Added deferred, direction-independent chunk transfers. Transition marker `13` now queues a handoff at the departing chunk boundary, then rebases players, enemies, projectiles, powerups, and effects after the destination camera and map are ready.
- Expanded stage routing for horizontal, vertical-up, vertical-down, and combined-axis scrolling, including the four-chunk Level 5 test route and chunked Level 1 and Level 4 layouts.
- Added metadata-driven vertical camera scrollers using marker `12`, an `auto_cam_y` target, ratchet synchronization, and level-reset cleanup so autoscroll state cannot pin a later stage's camera.
- Refined completion behavior for Levels 4 and 5: clear triggers, boss sequencing, fanfare music, enemy/projectile cleanup, autorun boundaries, final-stage end routing, and destructible exit-wall effects.
- Updated player spawning and respawning across vertical and combined-axis chunks, preserved rapid-fire state, added completion-aware boundary collision, and added a keyboard-toggleable noclip/debug movement mode.
- Added powerup lifetime and expiration blinking, adjusted capsule activation, refreshed transition cards and wipes, and updated the supporting map, graphics, and sound data.

## 2026-09-02 — Latest cartridge import

- Imported the latest `contra.p64.png` cartridge from the supplied archive and decoded its project files into the repository.
- Added the new `3d_code.lua` prototype with trapezoid perspective projection, depth-aware player and projectile movement, phase progression, and 3D player drawing.
- Expanded map setup and streaming: cached visual and spawn layers, scanned horizontal and vertical spawn streams, copied play-map sections, and tracked map bounds for scrolling.
- Refined horizontal, vertical, and top-down camera behavior, including respawn easing, co-op lead/trailing-player focus, ratcheting, and wall-blocked camera pushes.
- Updated player, enemy, effect, weapon, power-up, stage, transition, graphics, map, and sound data used by the latest build.
