# Contra Multiscroll Progress Report

## Project snapshot

The latest authoritative source is:

```text
C:/Users/turbo/AppData/Roaming/Picotron/drive/desktop/contra.zip
```

This archive contains the latest `contra.p64.png` cartridge. Its contents have now been reconciled into the `multiscroll` working tree, including the Lua source, maps, graphics, metadata, and cartridge image.

Git currently has:

- `main` at commit `71dfdf2` — `Import latest Contra cartridge build`
- Development branch: `multiscroll`
- Uncommitted experimental changes on `multiscroll`

The reconciled working tree is now the development source of truth. Existing extracted directories in the checkout may still be stale.

## Map architecture

The project intentionally uses two maps:

- `map/1.map` is the immutable source map.
- `map/0.map` is the mutable gameplay map.
- Chunks are selected from `map/1` and copied into `map/0`.
- Rendering and collision operate against `map/0`.

The relevant source-map layers are:

- Layer 1: visual overlay
- Layer 2: spawn and map metadata
- Layer 3: base/collision map copied into the play map

This separation is intentional and should be preserved.

## Map resource caching

Originally, every `map_helper()` call fetched both maps again:

```lua
fetch("map/1.map")
fetch("map/0.map")
```

That caused a noticeable hitch during chunk transitions.

The latest cart now fetches both maps once:

```lua
function init_map_resources()
    source_layers=fetch("map/1.map")
    play_layers=fetch("map/0.map")
end
```

`init_map_resources()` is called during `full_reset()`. Subsequent chunk loads reuse the existing userdata.

This made a major improvement. Horizontal-to-vertical-down transitions now work smoothly enough that incremental map copying has not yet been necessary.

The map copy and Lua-layer caching remain synchronous. If performance becomes a problem again, the proposed next optimization is:

- Horizontal chunks: copy the first 15 visible columns, then the next 16, followed by one column per update.
- Vertical chunks: copy the first 8 visible rows, then the next 9, followed by one row per update.
- Collision, visual, and spawn data must be streamed together.

That incremental loader is only a proposal and has not been implemented.

## Automatic map dimensions

Global `width` and `height` describe the active chunk in tiles.

Metadata sprites define the dimensions:

| Sprite | Purpose | Required position |
|---|---|---|
| `15` | Horizontal/X stop | Top row, on the rightmost included tile |
| `14` | Vertical/Y stop | First/leftmost column, on the bottommost included tile |
| `13` | Chunk transition trigger | Usually in the same boundary column as the X stop |

The stops are inclusive:

```lua
width=x_stop_x-chunk_start_x+1
height=y_stop_y-chunk_start_y+1
```

The dimension scanner:

- Searches the chunk's top row for sprite `15`.
- Searches its left column for sprite `14`.
- Breaks once each marker is found.
- Uses supplied dimensions as fallbacks rather than hard search caps.
- Includes temporary compatibility for older vertical maps whose sprite `14` is still near the right edge.

All loops consistently use:

```lua
for x=0,width-1 do
for y=0,height-1 do
```

The resulting boundaries are:

```lua
map_end_x=width*8
map_end_y=height*8
```

Sprites `14` and `15` are filtered from `spawn_layer`, so they cannot be interpreted as actors.

## Spawn streaming

Spawn metadata is cached into `spawn_layer`.

The map scans:

- Columns for horizontal scrolling
- Rows for vertical scrolling
- Both when `scrolling=="both"`

Sprite `13` is currently registered as a chunk-transition actor:

```lua
[13]=function(px,py)
    transfer_init()
end
```

The transition marker should normally share the X-stop boundary column. It cannot occupy the exact same metadata cell as sprite `15` unless separate metadata layers or a combined marker are introduced.

## Chunk-authoring rules

The visible screen is 240 by 128 pixels, or 30 by 16 tiles.

To prevent visible snapping, adjacent chunks should contain matching overlap geometry.

For horizontal movement:

```text
New chunk's first 30 columns
=
Old chunk's final 30 columns
```

For vertical-down movement:

```text
New chunk's first 16 rows
=
Old chunk's final 16 rows
```

For vertical-up movement:

```text
New chunk's final 16 rows
=
Old chunk's first 16 rows
```

For a transition supporting both axes, the entire 30-by-16 handoff viewport should match.

The overlapping visual and collision tiles should be identical. Enemy and spawner metadata generally should not be duplicated in the overlap, because that could respawn actors carried from the previous chunk.

## Current test transition

Level 0 currently has at least two chunks.

Chunk 1:

```lua
level_type="side scrolling"
scrolling="horizontal"
map_helper(0,0,width,height)
```

Chunk 2:

```lua
level_type="side scrolling"
scrolling="both"
scroll_dir="down"
map_helper(63,33,width,height)
```

This horizontal-to-vertical-down transition currently works cleanly.

## Camera transfer behavior

Camera deltas are no longer used to carry objects between chunks.

The transferred groups are:

```lua
{
    players,
    pup,
    bullet,
    ebullet,
    effect,
    enemy
}
```

The current transfer rebases every active object against the old camera:

```lua
local shift_x=-cam_x
local shift_y=-cam_y
```

Each object receives that positional shift:

```lua
obj.x+=shift_x
obj.y+=shift_y
```

Object velocities such as `dx` and `dy` are untouched. Bullets and actors therefore continue moving normally after the handoff.

The transfer then does:

```lua
spawn=0
chunk+=1
transfer=false
```

Using `spawn=0` was an important correction. Previously it used `spawn=-1`, which introduced one bad frame:

1. Objects and camera coordinates changed.
2. Physics ran against the old contents of `map/0`.
3. The player temporarily lost collision with the floor.
4. The old map was drawn from the reset camera position.
5. The new chunk loaded on the following update.

With `spawn=0`, `update_game()` immediately executes:

```lua
if spawn==0 then
    level_setup(level)
    spawn_players()
end
```

That installs the new chunk before physics and drawing occur. This fixed the visible map flick and momentary loss of footing.

## Why vertical-down currently works

The successful downward transition works because its destination camera begins at:

```lua
cam_y=0
```

The old camera offset is subtracted from the objects, and the new chunk uses zero-based play-map coordinates.

The new chunk is copied during the same update because `spawn` is set directly to zero. The new horizontal camera is also clamped back to zero when the new chunk does not permit horizontal camera movement.

## Vertical-up transfer implementation

Vertical-up requires a different initial camera position. Its camera should begin at the bottom of the new chunk:

```lua
new_cam_y=max(0,map_end_y-128)
```

The correct general transfer formula is:

```lua
shift_x=new_cam_x-old_cam_x
shift_y=new_cam_y-old_cam_y
```

For downward and horizontal chunks, the new camera is normally `(0,0)`, reducing the formula to:

```lua
shift_x=-old_cam_x
shift_y=-old_cam_y
```

For upward chunks, `new_cam_y` is nonzero, so merely subtracting the old camera is insufficient.

The earlier implementation had an ordering problem. This call inside `update_camera_transfer()` ran too early:

```lua
set_camera_for_map_start()
```

At that point, `level_setup()` has not selected the new chunk or discovered its dimensions. The call still sees the old chunk's scrolling mode and boundaries.

The useful `set_camera_for_map_start()` call is the one inside `map_helper()`, after the new `width`, `height`, and `map_end_y` are known.

## Implemented deferred transfer

The transfer now uses a pending transfer state.

At the beginning of a transfer:

```lua
transfer_state={
    old_cam_x=cam_x,
    old_cam_y=cam_y
}

chunk+=1
spawn=0
transfer=false
```

Objects are deliberately not shifted at this point.

During the same update, `level_setup()` calls `map_helper()`. `map_helper()` should:

1. Determine the new dimensions.
2. Cache and copy the new chunk into `map/0`.
3. Establish the new camera start.
4. Finish the pending transfer.

The destination map finishes the transfer with:

```lua
function finish_camera_transfer()
    if not transfer_state then
        return
    end

    local shift_x=cam_x-transfer_state.old_cam_x
    local shift_y=cam_y-transfer_state.old_cam_y
    local groups={players,pup,bullet,ebullet,effect,enemy}

    for group in all(groups) do
        for obj in all(group) do
            if obj.x~=nil then
                obj.x+=shift_x
            end

            if obj.y~=nil then
                obj.y+=shift_y
            end
        end
    end

    transfer_state=nil
end
```

This preserves the working horizontal-to-vertical-down behavior while supporting vertical-up and future chunks with nonzero camera origins. Runtime testing of the vertical-up handoff is the next step.

## Transition-boundary timing

Level 4 revealed a small horizontal map snap even after the deferred camera rebase. Its old chunk ends at column 60, with a final camera position of 248 pixels. The old and new collision screens match exactly at that stop, but the spawn streamer previously treated `cam_x+240` as visible and fired sprite `13` up to one tile early.

Sprite `13` is now converted into a pending transition instead of firing immediately when scanned. The departing chunk starts the transfer only when its camera reaches the appropriate boundary:

- Horizontal or both-direction chunks: `cam_x >= map_end_x-240`
- Vertical-down chunks: `cam_y >= map_end_y-128`
- Vertical-up chunks: `cam_y <= 0`

Visible spawn bounds now use the actual final screen pixels, `cam_x+239` and `cam_y+127`. This keeps actor streaming accurate while allowing transition metadata to be discovered before the boundary without transitioning early.

## Current priorities

1. Runtime-test the Level 4 horizontal-to-vertical-up transition and confirm that its X snap is gone.
2. Confirm that player footing, bullets, enemies, effects, and powerups preserve their screen positions.
3. Retest the existing horizontal-to-vertical-down transition for regressions.
4. Test horizontal, vertical-down, vertical-up, and both-direction transitions.
5. Commit the reconciled cart and transfer implementation once behavior is confirmed.
6. Only implement incremental map copying if synchronous copying still produces measurable hitches after resource caching.
