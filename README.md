# Contra

A Picotron run-and-gun action game by **turbochop**, with graphics work by **reecegames**.

Fight through enemy soldiers, turrets, cannons, and flying capsules in a fast-moving tribute to classic Contra. Run, jump, go prone, grab weapon upgrades, and bring in a second player when the shooting gets heavy.

![Contra cart](contra.p64.png)

## Play the Latest Build

Download `contra.p64.png`, open it in Picotron, and run the cartridge.

The game opens with a title screen and player-select flow before launching into the side-scrolling Jungle stage. Additional Base and Waterfall stage work is included and continues to evolve.

## Gameplay

- Fast side-scrolling movement, jumping, crouching, prone fire, aiming, recoil, deaths, respawns, and continues
- One-player and two-player modes, with support for player 2 joining during gameplay
- Enemy runners, turrets, cannons, bosses, bullets, destructible targets, flying capsules, and weapon pickups
- Horizontal, vertical, and top-down stage systems
- Stage cards, transitions, game-over and continue screens, and an end-state sequence

## Controls

- **Directional controls:** Move and aim
- **Down while grounded:** Go prone, or crouch on a slope
- **Jump button:** Jump
- **Fire button:** Shoot

Top-down stages use the directional controls for movement and aiming. The title screen lets you choose one or two players, and player 2 can join during gameplay when the current game state allows it.

## Weapons

- **Base rifle:** Reliable standard fire
- **Machine gun:** Faster sustained shooting
- **Rapid:** Improves firing speed
- **Spread:** Fires a wider multi-shot pattern; collecting it again upgrades it to a stronger five-shot version
- **Laser:** Fires linked laser segments with its own visual and collision behavior
- **Fire:** Launches explosive fire projectiles
- **Homing missiles:** Fires paired missiles that seek nearby targets

### New Homing Missiles

The latest build adds a complete homing-missile weapon:

- New homing weapon capsule and stage placement
- Paired missiles that launch with a slight spread before steering
- Automatic selection of the nearest valid target
- Live tracking of moving enemies and last-known-position behavior when a target disappears
- Variable steering and speed that give individual missiles slightly different flight paths
- Orbit detection and corrective movement to help missiles break out of circles
- New directional missile sprites for horizontal, vertical, and diagonal flight
- Player-specific missile colors and updated firing sounds
- A jittery lock indicator that makes the target feel actively tracked

Targeting support was added across runners, turrets, cannons, bosses, open shutters, and flying capsules. Closed shutters are ignored until they become vulnerable.

## Other Recent Changes

- Added new missile, pickup, map, and sound data to the packaged cartridge
- Added homing pickups to the Jungle stage and map spawn system
- Added a blinking palette effect to weapon capsules
- Reset player weapon power correctly during game-over handling
- Refined weapon sound channels and spread-shot audio
- Adjusted the upgraded fire-projectile explosion position
- Improved palette and transparency restoration after effects and capsule drawing
- Kept multiplayer disabled by default while preserving the title-screen selection and player-2 drop-in flow

## Current State

Contra is an active prototype. The Jungle stage is the most developed playable area. Top-down Base-style gameplay, the vertical Waterfall stage, bosses, level pacing, camera behavior, multiplayer edge cases, and collision tuning remain under active development.

Expect ongoing changes as stages and systems are tested in Picotron.

## For Developers

The repository is a Picotron cartridge/project export:

- `main.lua` — boot setup, global state, and scene routing
- `game.lua` — gameplay loop and level flow
- `ply_*.lua` — player objects, movement, aiming, and shared behavior
- `weapons.lua` — weapons and projectiles, including homing missiles
- `enemies.lua` — enemies, enemy bullets, and targeting eligibility
- `powerups.lua` — capsules, pickups, and weapon upgrades
- `effects.lua` — explosions, particles, spawners, and visual effects
- `camera.lua` — camera following and scrolling
- `map.lua` and `leveldata.lua` — map spawning and stage setup
- `cards.lua` and `wipe.lua` — title, stage, continue, ending, and transition screens
- `gfx/`, `map/`, and `sfx/` — Picotron graphics, map, and sound data

## Credits

- Code, game design, and creative direction: **turbochop**
- Graphics work: **reecegames**
