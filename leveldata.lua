--[[pod_format="raw",created="2026-06-25 20:07:31",modified="2026-07-24 09:27:21",revision=82]]
function spawn_players()
local spawnx= (level_type=="side scrolling") and cam_x or cam_x+50 
local spawny= (level_type=="side scrolling") and cam_y or cam_y+200
	 add_player_spawner(spawnx, spawny, "player 1")
  if multiplayer then
  add_player_spawner(spawnx, spawny, "player 2")
 end

end

function level_setup(_level)

local level=_level
--==Test Level

if level==0 then

 level_type="side scrolling"
  scrolling="horizontal"
spawn_players()
	map_helper(0,0,256)

 end
--==Test Level

--All levels begin from the top-left most tile. 
--Remember this when setting scroll stops

if level==1 then

 level_type="side scrolling"
  scrolling="horizontal"
spawn_players()
	map_helper(0,16,220)
-- map_helper(0, 80, 26, 220)
-- spawn_scan_x = -1
--create_player(cam_x+50,cam_y+20,0)

 add_bridge_destroy(46*8,7*8)
 add_bridge_destroy(67*8,7*8)
 add_new_cap_spawner(32,3,spread)
 add_new_cap_spawner(59,4,rapid)
 add_new_cap_spawner(100,9,rapid)
 add_new_cap_spawner(166,4,homing)
 add_new_cap_spawner(166,8,laser)
 end
 
 if level==2 then
  level_type="top down" 
 scrolling="vertical"
 scroll_dir = "up"
spawn_players()
--	map_helper(0,96,220)
 map_helper(0, 32, 32, 512)
-- spawn_scan_x = -1
--create_player(cam_x+50,cam_y+20,0)

-- add_bridge_destroy(46*8,7*8)
-- add_bridge_destroy(67*8,7*8)
-- add_new_cap_spawner(32,3,spread)
-- add_new_cap_spawner(59,4,rapid)
-- add_new_cap_spawner(100,9,rapid)
-- add_new_cap_spawner(166,4,mgun)
 	
 end
 
 if level==3 then
  level_type="side scrolling" 
 scrolling="vertical"
 scroll_dir = "up"
spawn_players()
--	map_helper(0,96,220)
 map_helper(30, 32, 32, 512)
-- spawn_scan_x = -1
--create_player(cam_x+50,cam_y+20,0)

-- add_bridge_destroy(46*8,7*8)
-- add_bridge_destroy(67*8,7*8)
-- add_new_cap_spawner(32,3,spread)
-- add_new_cap_spawner(59,4,rapid)
-- add_new_cap_spawner(100,9,rapid)
-- add_new_cap_spawner(166,4,mgun)
 	
 end
 
end