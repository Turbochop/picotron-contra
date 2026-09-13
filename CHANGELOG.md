# Changelog

## 2026-09-13 — Scoring, enemy variants, and movement refinements

Compared with `d2fd00d` (`Add multiscroll chunk progression`):

- Imported the latest `contra.p64.png` from the supplied `contra.zip` and synchronized all 29 decoded project files, including the new `mark_lead.lua` module, graphics, source map, sounds, and metadata.
- Added per-player scores, a session high score, and score-based extra lives at 10,000, 50,000, and 100,000 total points, then every additional 100,000 points. Enemy hits, kills, capsules, and pickups award points; boss completion grants eligible players 5,000 points.
- Added score and high-score displays to stage cards and the continue screen. Continuing resets each player's score and extra-life progress, with a short confirmation blackout before resuming or returning to the title.
- Added Hider enemies that emerge from cover, aim at a living player, fire twice, and retreat into protection, with dedicated map spawn markers.
- Expanded marksman firing angles and added a distinct predictive variant that leads moving targets. Marksmen wait for valid targets, cancel volleys when targets disappear, and use randomized pauses before lowering their rifles.
- Rebalanced turret health from 30 to 15 and boss health from 100 to 50. Runner spawners now pause at the active-enemy limit and suppress right-moving spawns when a player is nearby at the same height.
- Reworked player slope collision around continuous surface heights, improving ramp seams, tips, flat-ground transitions, and jump landings while preserving ordinary wall collision. Running animation offsets no longer nudge grounded players into slopes.
- Added a hidden map column beyond horizontal camera stops so edge collision and spawn/transition commands remain available without extending the visible camera bounds.
- Refined vertical and combined-axis respawns to retain the last safe grounded position while airborne. Scroll deaths now use camera movement to identify scroll kills, and co-op recovery can use the partner's safe spawn anchor when the partner is airborne.
- Increased homing-missile acceleration. Updated fireball animation, directional flipping, secondary flame effects, and weapon sound-channel timing.
- Refined exit-wall and bridge destruction tiles, prevented exit-wall clearing during game over, and stopped horizontal player movement during the final-stage fanfare. Updated supporting graphics, map placement, and sound data.

Known issue in the supplied build: the new higher homing-missile speed limit checks `self.rapid`, but missiles do not inherit their owner's rapid flag, so that branch is not activated by the existing spawn path.

Validation: all 29 decoded files match the supplied cartridge byte for byte; Picotron Lua syntax checks passed. All 34 existing slope, marksman, and map-edge regression tests passed against the imported source using a temporary runner that supplies the new `cam_y` test fixture. Interactive Picotron gameplay was not tested.

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
