# Changelog

## 2026-09-02 — Latest cartridge import

- Imported the latest `contra.p64.png` cartridge from the supplied archive and decoded its project files into the repository.
- Added the new `3d_code.lua` prototype with trapezoid perspective projection, depth-aware player and projectile movement, phase progression, and 3D player drawing.
- Expanded map setup and streaming: cached visual and spawn layers, scanned horizontal and vertical spawn streams, copied play-map sections, and tracked map bounds for scrolling.
- Refined horizontal, vertical, and top-down camera behavior, including respawn easing, co-op lead/trailing-player focus, ratcheting, and wall-blocked camera pushes.
- Updated player, enemy, effect, weapon, power-up, stage, transition, graphics, map, and sound data used by the latest build.
