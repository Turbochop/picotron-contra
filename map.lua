--[[pod_format="raw",created="2026-02-24 20:03:51",modified="2026-05-28 12:50:18",revision=159]]
visual_layer_1 = {}
spawn_layer = {}

function map_helper(_x,_y,_width,_height)
 local x=_x
 local y=_y
 local width=_width
 local height=_height or 16

 spawn_stream_width = width
 spawn_stream_height = height
 spawn_scan_x = -1
 spawn_scan_y = -1

 if scrolling == "vertical" or scrolling == "both" then
  map_end_y = height * 8
 end

 local layers = fetch("map/0.map")

 -- =========================
 -- layer 2: cache spawn/meta layer
 -- =========================
 cache_map_layer(layers[2].bmp, x, y, width, spawn_layer, height)

 -- one-time immediate metadata scan
 process_spawn_metadata(width, height)

 -- =========================
 -- layer 1: cache visual overlay
 -- =========================
 cache_map_layer(layers[1].bmp, x, y, width, visual_layer_1, height)

 -- =========================
 -- layer 3: active gameplay/collision layer
 -- =========================
 memmap(layers[3].bmp, 0x100000)
 copy_map_section(x, y, width, height)
end


function copy_map_section(x_start, y_start, width, height)
 height = height or 16

 for x=0,width-1 do
  for y=0,height-1 do
   local tile = mget(x_start + x, y_start + y)
   mset(x, y, tile)
  end
 end
end


function cache_map_layer(bmp, x_start, y_start, width, dest, height)
 height = height or 16

 memmap(bmp, 0x100000)

 for x=0,width-1 do
  dest[x] = dest[x] or {}
  for y=0,height-1 do
   dest[x][y] = mget(x_start + x, y_start + y)
  end
 end
end


-- one-time pass for metadata that should exist immediately
function process_spawn_metadata(width, height)
 height = height or 16

 for x=0,width-1 do
  local col = spawn_layer[x]
  if col then
   for y=0,height-1 do
    local sprite_id = col[y]
    if sprite_id == 15 then
     map_end_x = x * 8
     col[y] = 0
    end
   end
  end
 end
end


-- streamed actor spawns
function process_spawn_column(col, y_start, y_end)
 local column = spawn_layer[col]
 if not column then return end

 y_start = y_start or 0
 y_end = y_end or ((spawn_stream_height or 16) - 1)
 y_start = max(0, y_start)
 y_end = min((spawn_stream_height or 16) - 1, y_end)

 for y=y_start,y_end do
  local sprite_id = column[y]
  if sprite_id and sprite_id ~= 0 then
   spawn_enemy_from_cached_tile(col, y, sprite_id)
   column[y] = 0
  end
 end
end


function process_spawn_row(row, x_start, x_end)
 x_start = x_start or 0
 x_end = x_end or ((spawn_stream_width or 220) - 1)
 x_start = max(0, x_start)
 x_end = min((spawn_stream_width or 220) - 1, x_end)

 for x=x_start,x_end do
  local column = spawn_layer[x]
  if column then
   local sprite_id = column[row]
   if sprite_id and sprite_id ~= 0 then
    spawn_enemy_from_cached_tile(x, row, sprite_id)
    column[row] = 0
   end
  end
 end
end


function spawn_enemy_from_cached_tile(map_x, map_y, sprite_id)
 local px = map_x
 local py = map_y

 local spawnmap = {
  [27]=function(px,py) add_new_shutter_pup(px,py,mgun) end,
  [28]=function(px,py) add_new_shutter_pup(px,py,rapid) end,
  [29]=function(px,py) add_new_shutter_pup(px,py,spread) end,
  [31]=function(px,py) add_new_shutter_pup(px,py,fire) end,
  [72]=function(px,py) add_new_turret(px,py) end,
 }

 local f = spawnmap[sprite_id]
 if f then
  f(px,py)
 end
end


function draw_cached_layer(layer_table)
 local start_tx = flr(cam_x / 8)
 local end_tx   = start_tx + 30

 local start_ty = flr(cam_y / 8)
 local end_ty   = start_ty + 16

 for tx=start_tx,end_tx do
  local col = layer_table[tx]
  if col then
   for ty=start_ty,end_ty do
    local tile = col[ty]
    if tile and tile ~= 0 then
     spr(tile, tx*8, ty*8)
    end
   end
  end
 end
end


function update_spawn_stream()
 local visible_left_col = flr(cam_x / 8)
 local visible_right_col = flr((cam_x + 240) / 8)
 local visible_top_row = flr(cam_y / 8)
 local visible_bottom_row = flr((cam_y + 128) / 8)

 if scrolling == "vertical" then
  while spawn_scan_y < visible_bottom_row do
   spawn_scan_y += 1
   process_spawn_row(spawn_scan_y, visible_left_col, visible_right_col)
  end
 else
  while spawn_scan_x < visible_right_col do
   spawn_scan_x += 1
   process_spawn_column(spawn_scan_x, visible_top_row, visible_bottom_row)
  end

  if scrolling == "both" then
   while spawn_scan_y < visible_bottom_row do
    spawn_scan_y += 1
    process_spawn_row(spawn_scan_y, visible_left_col, visible_right_col)
   end
  end
 end
end
