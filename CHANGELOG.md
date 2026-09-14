# Changelog

## 2026-09-14 — Base eye boss and weapon tuning

Compared with `38f0110` (`Import homing missile rapid-fire patch`):

- Imported the latest exported `contra.p64.png` and synchronized all 30 decoded project files, including the new `boss.lua` module, updated graphics, source map, and export metadata.
- Added a Base eye boss to the fifth phase of Level 3, plus a Level 0 test arena. Four destructible nodes protect the eye; destroying them starts a 40-update reveal delay, after which the eye moves horizontally, reacts to hits, and launches destructible bubbles aimed at the nearest living player.
- Added two boss turrets with opening and closing animations, three-shot downward volleys, and muzzle flashes. Nodes and turrets replace their map tiles with damaged scenery when destroyed. The eye awards eligible players 5,000 points after its death sequence.
- Moved the existing wall-core boss, paired cannons, and cannon projectiles into `boss.lua`, renamed the wall-core constructor, and updated its stage triggers.
- Extended projectile collisions to vulnerable boss emplacements and gated boss damage on targetability. Boss guns are excluded from the 3D phase-clear enemy count.
- Reduced rapid homing-missile acceleration from `0.04` to `0.03` per update and its speed threshold from `4` to `3`; normal missiles retain `0.02` acceleration and a threshold of `2`.
- Extended rifle, machine-gun, spread, untargeted homing, and laser projectile lifetimes during 3D boss fights. Released fire shots now lose `2.5` life per update in side-scrolling stages and boss fights, while ordinary 3D sections retain the previous decay of `4`.
- Reloaded map resources on level resets. Level 3 now loads its corridor map in phase 1 and a separate boss arena in phase 5; phases 2–4 retain the corridor map. Updated the Level 4 wipe's map location and supporting graphics and source-map data.

Validation: all 30 decoded files and the staged cartridge match the imported export byte for byte; Picotron Lua syntax checks passed. All 34 existing slope, marksman, and map-edge regressions passed with temporary fixture adaptations for `cam_y` and the relocated boss functions. Seven focused projectile tests and five boss lifecycle checks passed, covering weapon lifetimes, homing acceleration and target loss, node unlock timing, eye movement, turret volleys, bubbles, scoring, and phase enemy counting. Interactive Picotron gameplay was not tested.

## 2026-09-13 — Homing-missile rapid-fire patch

Compared with `c7e1277` (`Import latest Contra cart with scoring and enemy variants`):

- Homing missiles now copy their owner's rapid-fire flag when spawned, activating the rapid-specific speed behavior and fixing the issue recorded in the previous import.
- Tuned homing acceleration to `0.04` per update for rapid missiles and `0.02` for normal missiles, with speed thresholds of `4` and `2`, respectively.
- Imported the updated cartridge and synchronized its 29 decoded project files. Other changes are export metadata; graphics, maps, sounds, and other gameplay code are unchanged.

Validation: all 29 decoded files and the staged cartridge match the supplied export byte for byte; Picotron Lua syntax checks passed. Focused Lua checks passed 81 assertions covering 2D/3D missile spawning, rapid inheritance, acceleration, speed thresholds, steering, and target loss. The existing inclusive threshold check allows one increment beyond the threshold (`2.02` or `4.04`). Interactive Picotron gameplay was not tested.

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

Known issue in this import, resolved by the missile patch above: the new higher homing-missile speed limit checks `self.rapid`, but missiles do not inherit their owner's rapid flag, so that branch is not activated by the existing spawn path.

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
