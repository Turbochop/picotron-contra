--[[pod_format="raw",created="2026-06-25 20:07:31",modified="2026-08-29 22:29:01",revision=206]]
function spawn_players()
local spawnx= (level_type=="side scrolling") and cam_x or cam_x+50 
local spawny= (level_type=="side scrolling") and cam_y or cam_y+200
	 if #players==0 then
	 add_player_spawner(spawnx, spawny, "player 1")
  if  multiplayer then
  add_player_spawner(spawnx, spawny, "player 2")
 end
end
end

function level_setup(_level)

if level_type=="3d" then
 phase_complete=false
 end
local level=_level
--==Test Level

if level==0 then

 level_type="side scrolling"
  scrolling="horizontal"
--spawn_players()
	map_helper(0,0,220)

 end
--==Test Level

--All levels begin from the top-left most tile. 
--Remember this when setting scroll stops

if level==1 then

 level_type="side scrolling"
  scrolling="horizontal"
--spawn_players()
	map_helper(0,16,220)
-- map_helper(0, 80, 26, 220)
-- spawn_scan_x = -1
--create_player(cam_x+50,cam_y+20,0)

 add_bridge_destroy(46*8,7*8)
 add_bridge_destroy(67*8,7*8)
 add_new_cap_spawner_hor(32,3,spread,"left")
 add_new_cap_spawner_hor(59,4,rapid)
 add_new_cap_spawner_hor(100,9,rapid)
 add_new_cap_spawner_hor(166,4,homing)
 add_new_cap_spawner_hor(166,8,laser)
 end
 
 
 
 if level==2 then
  level_type="top down" 
 scrolling="vertical"
 scroll_dir = "up"
--spawn_players()
--	map_helper(0,96,220)
 map_helper(0, 32, 32, 512)
-- spawn_scan_x = -1
--create_player(cam_x+50,cam_y+20,0)

-- add_bridge_destroy(46*8,7*8)
-- add_bridge_destroy(67*8,7*8)

 add_new_cap_spawner_vert(100,800,mgun)
-- add_new_cap_spawner(59,4,rapid)
-- add_new_cap_spawner(100,9,rapid)
-- add_new_cap_spawner(166,4,mgun)
 	
 end
 
  if level==3 then
  
  level_type="3d" 
 scrolling="vertical"
 scroll_dir = "up"
 if phase==1 then
   add_new_shutter_pup(17,cam_y+5,mgun)
 	add_new_turret(14,cam_y+5)
 end
 if phase==2 then
 	add_new_turret(12,cam_y+5)
 	add_new_turret(16,cam_y+5)
 end
 if phase==3 then
 	add_new_turret(11,cam_y+5)
 	add_new_turret(14,cam_y+5)
 	add_new_turret(17,cam_y+5)
-- 	add_new_turret(16,cam_y+4)
 end
 if phase==4 then
 	add_new_turret(11,cam_y+5)
 	add_new_turret(13,cam_y+5)
 	add_new_turret(15,cam_y+5)
 	add_new_turret(17,cam_y+5)
 end
 if phase==5 then
 	add_new_turret(7,cam_y+2)
 	add_new_turret(11,cam_y+2)
 	add_new_turret(17,cam_y+2)
 	add_new_turret(14,cam_y+5)
 	add_new_turret(21,cam_y+2)
 end
--spawn_players()
--	map_helper(0,96,220)
 map_helper(481, 34 , 30, 16)

 	
 end
 
 if level==4 then
  level_type="side scrolling" 
 scrolling="vertical"
 scroll_dir = "up"
--spawn_players()
--	map_helper(0,96,220)
 map_helper(30, 32, 32, 512)
-- spawn_scan_x = -1
--create_player(cam_x+50,cam_y+20,0)

-- add_bridge_destroy(46*8,7*8)
-- add_bridge_destroy(67*8,7*8)
add_new_cap_spawner_vert(150,700,mgun)
add_new_cap_spawner_vert(100,600,laser)
add_new_cap_spawner_vert(75,600,homing)
--add_new_cap_spawner_vert(100,830,spread)
--add_new_cap_spawner_vert(100,830,spread)
-- add_new_cap_spawner(32,3,spread)
-- add_new_cap_spawner(59,4,rapid)
-- add_new_cap_spawner(100,9,rapid)
-- add_new_cap_spawner(166,4,mgun)
 	
 end
 
end