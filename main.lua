--[[pod_format="raw",created="2025-02-02 19:06:08",modified="2026-09-26 21:26:54",revision=1812]]
--contra concept 
--by turbochop
--graphics work
--by reecegames

include "effects.lua"
include "map.lua"
include "leveldata.lua"
include "enemies.lua"
include "boss.lua"
include "mark_lead.lua"
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
 
 --- Set video mode to 240 x 135
 vid(3)
 
 --- Initialize game variables
 full_reset()

end

--screen fading functions

function load_fade_lut()
    local sprite=get_spr(fade_lut_sprite)
    fade_lut={}

    for y=0,4 do
        fade_lut[y]={}
        for x=0,31 do
            fade_lut[y][x]=sprite:get(x,y)
        end
    end
end

function apply_fade()
    if fade_lut==nil then return end

    local row=mid(0,flr(fade),4)

    for c=0,31 do
        pal(c,fade_lut[row][c],1)
        pal(c+32,c,1) -- makes unfaded objects show normal colours
    end
end

-- these two functions can be applied to any object that should be excluded from fading
-- Begin should be placed before draw commands within a draw function
-- end should be placed after the commands you want excluded


function begin_unfaded()
if level~=5 then
    for c=1,31 do
        pal(c,c+32,0)
    end
    end
    palt(30,true)
end

function end_unfaded()
    pal(0)
    palt(30,true)
end


slow=0
function _update()
grav=debug and 0 or .7

global_timer+=1
if global_timer>=30 then global_timer=0
end
--if keyp("i") then fade+=1 end
--if keyp("o") then fade-=1 end
if fade>=4 then fade=4 end
if fade<=0 then fade=0 end
hiscore= max(max(player_state[0].score,player_state[1].score),hiscore)
if transfer then
  update_camera_transfer()
  end
if fullreset then full_reset()
end
if (scene=="title")             update_title()
if scene=="game" then

 

  update_game()

 
end
if (scene=="wipe")              update_wipe()
if (scene=="card")              update_card()
if (scene=="gameover")          update_gameover()
if (scene=="continue")          update_continue()
if (scene=="end")               update_end()
if keyp("k") then
debug=not debug
end
end

function _draw()

palt(30,true)
local lifetext=(player_state[0].lives~=1) and " lives" or " life" 
if (scene=="title")   draw_title()  palt()
if (scene=="game")    draw_game() -- palt()
if (scene=="wipe")    draw_wipe()  palt()
if (scene=="card")     draw_card() palt()
if (scene=="gameover")  draw_gameover()  palt()
if (scene=="continue")  draw_continue() palt()
if (scene=="end")       draw_end()  palt()
apply_fade()
--print(stat(466),cam_x,cam_y+50,8)
--print(fade,cam_x,cam_y+58,9)
--print(clear,cam_x,cam_y+66,9)
--print("weapon is "..player_state[0].weapon,cam_x,60,7)
--print("rapid is "..tostring(player_state[0].rapid),cam_x,70,7)
--print("copied is "..tostring(player_state[0].copied),cam_x,80,7)
--print("respawn is "..player_state[0].respawn,cam_x,90,7)
end

function transfer_init()
	transfer=true
end
function init_map_resources()
    source_layers=fetch("map/1.map")
    play_layers=fetch("map/0.map")
end



function full_reset()
debug=false


source_layers=nil
play_layers=nil
init_map_resources()

  
   mgun,rapid,spread,laser,fire,homing=27,28,29,30,31,37  

   players={}
  lifepool=3
   
   player_state = {
    [0] = {
        copied=false,
        respawn=0,
        score=0,
        lifescore=0,
        lifetier=1,
        lives = lifepool,
        weapon = "base",
        rapid=false,
        gameover=false
    },
    [1] = {
        copied=false,
        respawn=0,
        score=0,
        lifescore=0,
        lifetier=1,
        lives = lifepool,
        weapon = "base",
        rapid=false,
        gameover=false
    }
}
 

     --game variables
     
     hiscore=20000
     
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
       transfer=false
       transfer_state=nil
       chunk_transfer_pending=false
   spawn_layer = {}
spawn_scan_x = -1
   map_start=0

   
    
    -- gameplay setup
       scene="title"
       multiplayer=false
       level=1
       chunk=1
       width=30
       height=16
       fade=0
       fade_lut_sprite = 9
       fade_lut = {}
       level_type="side scrolling"
       scrolling="horizontal"
       scroll_dir = "left"
       scroll_front = 119
       cam_moving=false
       map_end_x = 0
       map_end_y = 0
       auto_cam_y=nil
       -- 3d mode level phases
       
       phase_complete=false
       bezel=1
       phase=1
       screen=1
       enemycount=0
       wallexptimer=0
       wallexplosions=10
       bothready=false
       delay_timer=0
       delay_timer_max=60
       threedee_fade_timer=0
       
       song= {3,0,14,28,36}  



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
    choose=false
    g_otimer=0
    continue=2
 global_timer=0
         sel=71
      toggle=false   
      load_fade_lut()
   fullreset=false
   
    ------test------
-- x1r=0  y1r=0  x2r=0  y2r=0
end


function level_reset()
   
init_map_resources()
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
  transfer=false
  transfer_state=nil
  chunk_transfer_pending=false
   spawn_layer = {}
  spawn_scan_x = -1
      map_start=0
          timer=0
         timer1=0
          chunk=1
          auto_cam_y=nil
          fade=0
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
       threedee_fade_timer=0
      
      
      timer2=0
      timer3=0
      spawn=0
      blink=0
complete,clear=false,0
     fanfare=false
     toggle=false 
    

end
