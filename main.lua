--[[pod_format="raw",created="2025-02-02 19:06:08",modified="2026-06-26 14:04:06",revision=697]]
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
include "wipe.lua"
include "weapons.lua"
include "cards.lua"
include "camera.lua"

function _init()
--stop btnp repeating
 poke(0x5f5c, 255)



 vid(3)
   mgun,rapid,spread,fire=27,28,29,31  
 
   players={}
 multiplayer=false

     --game variables
    
     
     --Cheat code
     code={2,2,3,3,0,1,0,1,4,4,5}
     code_used=false
     input=0
     timeout=2
    sequence=1
     correct=false
     
     
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

    -- map_end=2048
       level_type="side scrolling"
       scrolling="horizontal"
       level=1
       song= {3,0,28,26}  
scroll_dir = "right"
scroll_front = 119
map_end_x = 0
map_end_y = 0
       scene="title"
    pallette=7
       timer=0
      timer1=0
     timer_d=.12
      timer2=0
      timer3=0
      spawn=0
    
complete,clear=false,0
     fanfare=false
       ready=false
       start=0
     start_d=0
       title=0
    gameover=false
    g_otimer=0
    continue=2
    lifepool=3
         sel=71
      toggle=false   
   fullreset=false
 
 ------test------
 x1r=0  y1r=0  x2r=0  y2r=0
end


slow=0
function _update()

--slow+=1
--if slow>1 then
--slow=0
--end
--if key("2") then
-- slow=1	
--end
 mx, my, mouse_b = mouse()
if fullreset then full_reset()
end
if (scene=="title")    update_title()
if scene=="game" and slow==0 then
     update_game()
end
if (scene=="wipe")     update_wipe()
if (scene=="card")     update_card()
if (scene=="gameover") update_gameover()
if (scene=="continue") update_continue()
if (scene=="end")      update_end()

end

function _draw()
palt(30,true)

if (scene=="title")   draw_title() palt()
if (scene=="game")    draw_game()  palt()
if (scene=="wipe")    draw_wipe()  palt()
if (scene=="card")     draw_card() palt()
if (scene=="gameover")  draw_gameover()  palt()
if (scene=="continue")  draw_continue() palt()
if (scene=="end")       draw_end()  palt()

end



function full_reset()
    mgun,rapid,spread,fire=27,28,29,31  

 players={}
 multiplayer=false
     --game variables
        b_dx=1.5
        b_dy=1.5
       
     b_dbase=1.5
     
     --Cheat code
     code={2,2,3,3,0,1,0,1,4,4,5}
     code_used=false
     input=0
     timeout=2
    sequence=1
     correct=false
     prompt=1
     badgex=7
  
    effect={}
      pup={}
      bullet={}
     ebullet={}
     enemy={}
visual_layer_1 = {}
     enemies=0
        grav=.07
        fric=.23
       reset_camera_state()
   spawn_layer = {}
spawn_scan_x = -1
   map_start=0
    level_type="side scrolling"
    scrolling = "horizontal"
    level=1
scroll_dir = "right"
scroll_front = 110
map_end_x = 0
map_end_y = 0
     map_end=1736
       sound=0
       scene="title"
   pallette=7
       timer=0
      timer1=0
     timer_d=.12
      timer2=0
      timer3=0
      spawn=0
      blink=0
complete,clear=false,0
     fanfare=false
       ready=false
       start=0
     start_d=0
       title=0
    gameover=false
    continue=2
    lifepool=3
         sel=71
      toggle=false   
 fullreset=false
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
     
      timer2=0
      timer3=0
      spawn=0
      blink=0
complete,clear=false,0
     fanfare=false
     toggle=false   

end
