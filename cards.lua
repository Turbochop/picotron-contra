--[[pod_format="raw",created="2026-02-06 05:21:36",modified="2026-04-24 01:23:01",revision=457]]
prompt=1
badgex=7
--title, card, end and gameover
local stop=220
function update_title()
for o in all(obj) do
   o:update()
   
  end
if code_used==false and not ready and timer1>=.5 and prompt==1 then
konami_code()
end
--title slide in and music

camera (cam_x-230)
 cam_x+=1
 timer1+=.01
 
      
     if cam_x>=stop then cam_x=stop
    
     elseif btnp()>0 and timer1>=.5 then 
     
     cam_x=stop  music(0)
    
     end   
     if cam_x==stop and title==0 then 
    -- add_controller(50,75)
     music(0) title=1
     end

--button prompt flash and timings

timer+=timer_d
start+=start_d
  if start>=5  then start=5
  end
   if timer>=1 then timer=0
   end
    if btnp(5)and timer1>=.5 then ready=true
    end
     if ready then 
    if timer<=.5 then pallette=8
elseif timer>=.5 then pallette=5
    end
    else if not ready then start=0 timer=0
    end
   end
     if ready  then start_d=prompt==1 and .1 or .05
     else start_d=0
     end
     
    if start>=5 and prompt==1  then
    ready=false
    timer=0
    start=0
    prompt+=1
    pallette=7
    
   end
   if prompt==2 and not ready then
   	if btnp(1) and badgex==7 then
   	sfx(264)
   	badgex=93
   end
   if btnp(0) and badgex==93 then
   sfx(264)
   	badgex=7
   end
   end
if start>=4.4 and prompt==2 and stat(466)~=-1 then
start=4.4
end
if start==5 then
if badgex==93 then multiplayer=true
end
obj={}
cam_x=0
ready=false
title=0
start=0
start_d=0
timer=0
badgex=7
scene="card"

   
  
   end
  end
  
  --Controller for visualization


function konami_code()
  -- timeout handling once we've begun entering the code
  if correct then
    input+=.1
    if input>=timeout then
      reset_konami()
      return
    end
  end

  -- strict mode: any press that isn't the expected one resets progress
  local expected = code[sequence]

  if btnp()>0 then
    if btnp(expected) then
      input=0
      correct=true
      sequence+=1

      if sequence==12 then
        sfx(259,8)
        lifepool=30
        reset_konami()
        code_used=true
      end
    else
      reset_konami()
    end
  end
end

function reset_konami()
  input=0
  sequence=1
  correct=false
end

function draw_title()
cls()

local rectcoordx=badgex==7 and -20 or 66
for o in all(obj) do
   o:draw()
   
  end
spr(254,20,10)
---[[
--print(cam_x,0,0,7)
--print(tostring(correct),0,16,7)
--print(input,0,24,7)
--print(ply.lives,0,8,7)
--]]
--print(badgex)
 if cam_x>=stop then
 if prompt==1 then
print ("PRESS — TO START!",25+cam_x-175,101,1)
print ("PRESS — TO START!",25+cam_x-175,100,pallette)
elseif prompt==2 then



print ("ONE PLAYER       TWO PLAYERS",-5+cam_x-165,101,1)
print ("ONE PLAYER       TWO PLAYERS",-5+cam_x-165,100,7)
if timer<.5 then
spr(26,badgex+cam_x-190,99)

end
end
if start>=4.5 and prompt==2 then rectfill(-100,0,255,255,0)
end
 end
end

--show level card

function update_card()

gameover=false
start+=.01
  if start>=2.5 then 
  copy_map_section(0, 16, 220)
  scene="wipe"
  fetch("sfx/1.sfx"):poke(0x80000)
  music(0,0,0xf,0x80000)
  start=0

  end
end

function draw_card()
cls(0)
camera(0,0)
print ("STAGE 1",cam_x+100,cam_y+64,6)
print ("JUNGLE",cam_x+102,cam_y+72,6)
--print(cam_x,0,0,7)

end

--show game over screen

function update_gameover()
 effect={}
    pup={}
 bullet={}
ebullet={}
 enemy={}
players={}
fanfare=false
clear=0
--complete=0
timer +=.01
timer1+=.01
toggle=false
bfight=false
timer3=0
spawn=0

--does the player have a continue

if timer>=3.2 then
if continue~=0 then

timer =0
--if so, then go to continue 
scene= "continue"
else  
-- otherwise back to title
-- reset all relevant variables
--cam_x=0
fullreset=true
--cam_y=0
--
--pallette=7
--timer1=0
--continue=2
--scene= "title"

end
end


end

function draw_gameover()

cls(0)
camera(0,0)
print ("GAME OVER",cam_x+100,cam_y+64,6)
--print(cam_x,cam_x,0,7)

end

--show continue screen

function update_continue()

--setup selector

if btnp(3) and sel~=81 then sel=81
sfx(264)
end
if btnp(2) and sel~=71 then sel=71
sfx(264)
end
--select yes, go to card
if btnp(5) and sel==71 then
cam_x=0
continue-=1
lifepool=code_used and 30 or 3
scene="card"

timer=0
timer1=0
--select no, go to title 
elseif btnp(5) and sel==81 then
  fullreset=true


end

end

function draw_continue()
cls(0)
camera(0,0)
--print(tostring(code_used),cam_x,cam_y,7)
print ("Continue?",cam_x+100,cam_y+60,6)
print ("Yes",cam_x+115,cam_y+71,6)
print ("No" ,cam_x+115,cam_y+81,6)
spr   (26,cam_x+105,cam_y+sel)
--print(cam_x,0,0,7)
end

--show ending

function update_end()
timer-=.3

timer3+=.1

if timer<=-265 then 
timer=-265
music(-1,1500)
timer2+=.1

end
if timer2>=25 then
players={}
timer=0
timer2=0
continue=0
clear=0
bfight=false
complete=false
cam_x=0
music(2)
scene="gameover"


end
end

function draw_end()
cls(0)
camera(0,0)
print("Congratulations!",85,128+timer,6)
print("Long live Picotron!!",78,170+timer)
print("Stay tuned for updates!!!",64,200+timer)
--print(cam_x,0,0,7)
end

