--[[pod_format="raw",created="2025-02-02 19:06:08",modified="2026-08-30 01:20:00",revision=1250]]
--contra concept 
--by turbochop
--graphics work
--by reecegames

include "effects.lua"
include "map.lua"
include "leveldata.lua"
include "enemies.lua"
include "powerups.lua"
include "collision.lua"
include "ply_mod.lua"
include "ply_common.lua"
include "ply_scode.lua"
include "ply_tdcode.lua"
include "game.lua"
include "3d_code.lua"
include "wipe.lua"
include "weapons.lua"
include "cards.lua"
include "camera.lua"

function _init()
--stop btnp repeating
 poke(0x5f5c, 255)
 vid(3)
 full_reset()
 
end


slow=0
function _update()
global_timer+=1
if global_timer>=30 then global_timer=0
end
--slow+=1
--if slow>1 then
--slow=0
--end
--if key("2") then
-- slow=1	
--end

 
if fullreset then full_reset()
end
if (scene=="title")             update_title()
if (scene=="game" and slow==0)  update_game() 
if (scene=="wipe")              update_wipe()
if (scene=="card")              update_card()
if (scene=="gameover")          update_gameover()
if (scene=="continue")          update_continue()
if (scene=="end")               update_end()

end

function _draw()

palt(30,true)
local lifetext=(player_state[0].lives~=1) and " lives" or " life" 
if (scene=="title")   draw_title() palt()
if (scene=="game")    draw_game() -- palt()
if (scene=="wipe")    draw_wipe()  palt()
if (scene=="card")     draw_card() palt()
if (scene=="gameover")  draw_gameover()  palt()
if (scene=="continue")  draw_continue() palt()
if (scene=="end")       draw_end()  palt()

--print(continue,cam_x,50,7)
--print("weapon is "..player_state[0].weapon,cam_x,60,7)
--print("rapid is "..tostring(player_state[0].rapid),cam_x,70,7)
--print("copied is "..tostring(player_state[0].copied),cam_x,80,7)
--print("respawn is "..player_state[0].respawn,cam_x,90,7)
end



function full_reset()
  
   mgun,rapid,spread,laser,fire,homing=27,28,29,30,31,37  
 
   players={}
  lifepool=3
   
   player_state = {
    [0] = {
        copied=false,
        respawn=0,
        lives = lifepool,
        weapon = "base",
        rapid=false,
        gameover=false
    },
    [1] = {
        copied=false,
        respawn=0,
        lives = lifepool,
        weapon = "base",
        rapid=false,
        gameover=false
    }
}
 

     --game variables
    
     
     --Cheat code
     code={2,2,3,3,0,1,0,1,4,4,5}
     code_used=false
     input=0
     timeout=2
    sequence=1
     correct=false
     prompt=1
     
     effect={}
      pup={}
      bullet={}
     ebullet={}
     enemy={}
   
      bfight=false

 
     enemies=0
        grav=.07
        fric=.23
       reset_camera_state()
  spawn_layer = {}
spawn_scan_x = -1
   map_start=0

   
    
    -- gameplay setup
       scene="title"
       multiplayer=false
       level=1
       level_type="side scrolling"
       scrolling="horizontal"
       scroll_dir = "left"
       
      
       -- 3d mode level phases
       
       phase_complete=false
       phase=1
       screen=1
       enemycount=0
       wallexptimer=0
       wallexplosions=10
       bothready=false
       delay_timer=0
       delay_timer_max=60
       
       
       song= {3,0,14,28,26}  

scroll_front = 119
map_end_x = 0
map_end_y = 0
       
    pallette=7
       timer=0
      timer1=0
     timer_d=.12
      timer2=0
      timer3=0
      spawn=0
    mx,my=0,0
complete,clear=false,0
     fanfare=false
       ready=false
       start=0
     start_d=0
       title=0
    gameover=false
    g_otimer=0
    continue=2
 global_timer=0
         sel=71
      toggle=false   
   fullreset=false
   
    ------test------
-- x1r=0  y1r=0  x2r=0  y2r=0
end

function level_reset()
   

        players={}
         effect={}
            pup={}
         bullet={}
        ebullet={}
          enemy={}
visual_layer_1 = {}
        enemies=0
         bfight=false  
  reset_camera_state()
   spawn_layer = {}
  spawn_scan_x = -1
      map_start=0
          timer=0
         timer1=0
     
       -- 3d mode level resets
       
       phase_complete=false
       phase=1
       screen=1
       enemycount=0
       wallexptimer=0
       wallexplosions=10
       bothready=false
       delay_timer=0
       delay_timer_max=60
       
      timer2=0
      timer3=0
      spawn=0
      blink=0
complete,clear=false,0
     fanfare=false
     toggle=false 
    

end
