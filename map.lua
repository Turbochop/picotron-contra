--[[pod_format="raw",created="2026-02-24 20:03:51",modified="2026-09-03 16:29:41",revision=233]]
--[[pod_format="raw",created="2026-02-24 20:03:51",modified="2026-09-03 08:40:19",revision=228]]
visual_layer_1 = {}
spawn_layer = {}

function find_map_dimensions(bmp,x_start,y_start,fallback_width,fallback_height,legacy_height_scan)
 memmap(bmp,0x100000)

 local available_width=max(0,bmp:width()-x_start)
 local available_height=max(0,bmp:height()-y_start)
 local found_width=nil
 local found_height=nil

 -- sprite 15 marks the final tile in the map's top row
 for x=0,available_width-1 do
  if mget(x_start+x,y_start)==15 then
   found_width=x+1
   break
  end
 end

 -- sprite 14 marks the final tile in the map's left column
 for y=0,available_height-1 do
  if mget(x_start,y_start+y)==14 then
   found_height=y+1
   break
  end
 end

 -- temporary compatibility for vertical maps whose 14 is near the right edge
 if found_height==nil and legacy_height_scan then
  local legacy_width=min(fallback_width,available_width)

  for y=0,available_height-1 do
   for x=0,legacy_width-1 do
    if mget(x_start+x,y_start+y)==14 then
     found_height=y+1
     break
    end
   end

   if found_height~=nil then
    break
   end
  end
 end

 return found_width or fallback_width,found_height or fallback_height
end

function map_helper(_x,_y,_width,_height)
 local x=_x
 local y=_y


 local metadata_bmp=source_layers[2].bmp

 -- supplied dimensions are fallbacks, not marker-search ceilings
 local fallback_width=_width or 30
 local fallback_height=_height or 16

 -- sprites 15 and 14 define the map's tile boundaries
 width,height=find_map_dimensions(
  metadata_bmp,
  x,y,
  fallback_width,fallback_height,
  _height==nil
 )

 map_end_x=width*8
 map_end_y=height*8
 spawn_scan_x=-1
 spawn_scan_y=-1

 -- =========================
 -- source layer 2: cache spawn/meta layer
 -- =========================
 cache_map_layer(metadata_bmp,x,y,spawn_layer)

 if (scrolling == "vertical" or scrolling == "both") and is_vertical_scroll_up() then
  spawn_scan_y=height
 end

 -- =========================
 -- source layer 1: cache visual overlay
 -- =========================
 cache_map_layer(source_layers[1].bmp,x,y,visual_layer_1)

 -- =========================
 -- source layer 3 -> play layer 3
 -- =========================
 copy_map_section(source_layers[3].bmp,play_layers[3].bmp,x,y)

 -- Establish the destination camera only after the new dimensions and map
 -- are ready, then rebase carried actors into that camera's coordinate space.
 set_camera_for_map_start()
 finish_camera_transfer()

 return width,height
end


function copy_map_section(source_bmp,dest_bmp,x_start,y_start)
 for x=0,width-1 do
  local column = {}

  memmap(source_bmp, 0x100000)

  for y=0,height-1 do
   column[y] = mget(x_start + x, y_start + y)
  end

  memmap(dest_bmp, 0x100000)

  for y=0,height-1 do
   mset(x, y, column[y])
  end
 end

 memmap(dest_bmp, 0x100000)
end


function cache_map_layer(bmp,x_start,y_start,dest)
 memmap(bmp, 0x100000)

 for x=0,width-1 do
  dest[x] = dest[x] or {}
  for y=0,height-1 do
   local tile=mget(x_start+x,y_start+y)

   -- dimension markers are metadata, not spawn commands
   if dest==spawn_layer and (tile==14 or tile==15) then
    tile=0
   end

   dest[x][y]=tile
  end
 end
end


-- streamed actor spawns
function process_spawn_column(col, y_start, y_end)
 local column = spawn_layer[col]
 if not column then return end

 y_start = y_start or 0
 y_end = y_end or (height-1)
 y_start = max(0, y_start)
 y_end = min(height-1,y_end)

 for y=y_start,y_end do
  local sprite_id = column[y]
  if sprite_id and sprite_id ~= 0 then
   if sprite_id==13 then
    chunk_transfer_pending=true
   else
    spawn_enemy_from_cached_tile(col,y,sprite_id)
   end
   column[y] = 0
  end
 end
end


function process_spawn_row(row, x_start, x_end)
 x_start = x_start or 0
 x_end = x_end or (width-1)
 x_start = max(0, x_start)
 x_end = min(width-1,x_end)

 for x=x_start,x_end do
  local column = spawn_layer[x]
  if column then
   local sprite_id = column[row]
   if sprite_id and sprite_id ~= 0 then
     if sprite_id==13 then
      chunk_transfer_pending=true
     else
      spawn_enemy_from_cached_tile(x,row,sprite_id)
     end
     column[row] = 0
   end
  end
 end
end


function spawn_enemy_from_cached_tile(map_x, map_y, sprite_id)
 local px = map_x
 local py = map_y

 local spawnmap = {
  [12]=function(px,py) add_camera_scroller_vert(px,py) end,
  [27]=function(px,py) add_new_shutter_pup(px,py,mgun) end,
  [28]=function(px,py) add_new_shutter_pup(px,py,rapid) end,
  [29]=function(px,py) add_new_shutter_pup(px,py,spread) end,
  [30]=function(px,py) add_new_shutter_pup(px,py,laser) end,
  [31]=function(px,py) add_new_shutter_pup(px,py,fire) end,
  [32]=function(px,py) add_new_enmy_mark(px,py-1) end,
  [33]=function(px,py) add_new_enmy_mark(px,py-1,true) end,
  [37]=function(px,py) add_new_shutter_pup(px,py,homing) end,
  [72]=function(px,py) add_new_turret(px,py) end,
 }

 local f = spawnmap[sprite_id]
 if f then
  f(px,py)
 end
end


function update_chunk_transfer_trigger()
 if not chunk_transfer_pending or transfer then
  return
 end

 local at_exit=false

 if scrolling=="vertical" then
  local vertical_limit=max(0,map_end_y-128)
  at_exit=is_vertical_scroll_up() and cam_y<=0 or cam_y>=vertical_limit
 else
  local horizontal_limit=max(0,map_end_x-240)
  at_exit=cam_x>=horizontal_limit
 end

 if at_exit then
  chunk_transfer_pending=false
  transfer_init()
 end
end


function draw_cached_layer(layer_table)
 local start_tx=max(0,flr(cam_x/8))
 local end_tx=min(width-1,start_tx+30)

 local start_ty=max(0,flr(cam_y/8))
 local end_ty=min(height-1,start_ty+16)

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


function update_spawn_rows(visible_top_row, visible_bottom_row, visible_left_col, visible_right_col)
 local spawn_ahead_rows = is_vertical_scroll_up() and 4 or 0
visible_top_row -= spawn_ahead_rows
 visible_top_row = max(0, visible_top_row)
 visible_bottom_row = min(height-1,visible_bottom_row)

 if is_vertical_scroll_up() then
  while spawn_scan_y > visible_top_row do
   spawn_scan_y -= 1
   process_spawn_row(spawn_scan_y, visible_left_col, visible_right_col)
  end
 else
  while spawn_scan_y < visible_bottom_row do
   spawn_scan_y += 1
   process_spawn_row(spawn_scan_y, visible_left_col, visible_right_col)
  end
 end
end


function update_spawn_stream()
 local visible_left_col=mid(0,flr(cam_x/8),width-1)
 local visible_right_col=mid(0,flr((cam_x+239)/8),width-1)
 local visible_top_row=mid(0,flr(cam_y/8),height-1)
 local visible_bottom_row=mid(0,flr((cam_y+127)/8),height-1)

 if scrolling == "vertical" then
  update_spawn_rows(visible_top_row, visible_bottom_row, visible_left_col, visible_right_col)
 else
  while spawn_scan_x < visible_right_col do
   spawn_scan_x += 1
   process_spawn_column(spawn_scan_x, visible_top_row, visible_bottom_row)
  end

  if scrolling == "both" then
   update_spawn_rows(visible_top_row, visible_bottom_row, visible_left_col, visible_right_col)
  end
 end

 update_chunk_transfer_trigger()
end
