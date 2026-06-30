--[[pod_format="raw",created="2026-02-06 05:21:09",modified="2026-06-26 13:46:59",revision=132]]

-- wipe state
-- begins the level 
-- with some style
function starting_scene()

--These locations point to single screen images on the map for wipe visual

if level==1 then
level_type="side scrolling"
map_helper(481,0,30)
end	

if level==2 then
level_type="top down"
map_helper(481,17,30)
end
end

spawn_scan_x = -1
function update_wipe()
 timer += (level_type=="side scrolling") and  6 or 5

 if timer >= (level_type=="side scrolling" and 240 or 200) then
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
if level_type=="side scrolling" then
 rectfill(timer,0,250,200,0)
 elseif level_type=="top down" then
 rectfill(0,0,300,200-timer,0)
 end
 rectfill(0,128,240,136,0)
end





