--[[pod_format="raw",created="2026-02-06 05:21:09",modified="2026-04-11 17:11:30",revision=60]]

-- wipe state
-- begins the level 
-- with some style
map_helper(0,80,220)
spawn_scan_x = -1
function update_wipe()
 timer += 6

 if timer >= 300 then
  scene = "game"
  cam_x = 0
 end
end

function draw_wipe()
 cls(0)

 map()
 draw_cached_layer(visual_layer_1)

 if multiplayer then
  for l=1,lifepool do 
   spr(39,(cam_x+190)+l*8,cam_y+8)
   if l==4 then break end
  end	
 end

 for l=1,lifepool do 
  spr(39,cam_x+l*8,cam_y+8)
  if l==4 then break end
 end

 rectfill(timer,0,300,200,0)
 rectfill(0,128,240,136,0)
end





