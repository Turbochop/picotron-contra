--[[pod_format="raw",created="2026-03-02 22:46:23",modified="2026-07-01 04:53:25",revision=715]]

--player top-down functions




--controls (movement)
 
function ply_mvmnt_top(_ply)
local ply=_ply

ply.landed=true
ply.falling=false
--ply.jmp=false
if clear>15 and clear<19 then 
ply.running=false
ply.dx=0
ply.dy=0
 ply.can_fire=false
--poke(0x005580,0)
end

if clear>200  then 
--
ply_run_up(ply)
end






--post hit invincibilty
ply.respawn+=.1


if ply.respawn<15 then ply.blink+=.5
else ply.blink=0
ply.respawn=15
 end
 
 if ply.blink>1 then ply.blink=0
 end

--ply.on_slope=false



--controls

-- Top down gameplay
ply.dx=0
ply.dy=0
if clear<15 then 
 if btn(1,ply.player)  then 

 ply_run_right(ply)

    
end
  
  if btn(0,ply.player) then
  ply_run_left(ply)

  end
  if btn(2,ply.player) then
  ply_run_up(ply)

  end
  if btn(3,ply.player) then
  ply_run_down(ply)

  end
   end
  if not fanfare then
   if ply.running
   and not btn(0,ply.player)
   and not btn(1,ply.player)
   and not btn(2,ply.player)
   and not btn(3,ply.player) then
   
   
   ply.running=false
  
   
   end
  if not ply.running then
  ply.dx=0
  ply.dy=0
  
  end

   end

     fric=.23
     player_collide_top(ply)
  
  end


function ply_aim_top(_ply)

local ply= _ply

if clear<15 then
 if btn(2,ply.player) and ply.running  and not fanfare then 
 ply.aim=1
 
 
 end
end 

end

--aiming logic 
--and bullet offsets

function aiming_top(ply)
    ply.b_dbase = ply.rapid and 2.5 or 1.5

    -- update intent only if pressing a direction
    if btn(2,ply.player) then ply.aim_dir="up" end
    if btn(3,ply.player) then ply.aim_dir="dn" end
    if btn(1,ply.player) then ply.aim_dir="rt" end
    if btn(0,ply.player) then ply.aim_dir="lt" end

    if btn(2,ply.player) and btn(0,ply.player) then ply.aim_dir="uplt" end
    if btn(2,ply.player) and btn(1,ply.player) then ply.aim_dir="uprt" end
    if btn(3,ply.player) and btn(0,ply.player) then ply.aim_dir="dnlt" end
    if btn(3,ply.player) and btn(1,ply.player) then ply.aim_dir="dnrt" end

    -- fallback
    if not ply.aim_dir then ply.aim_dir="up" end

    -- always apply bullet origin from current facing
    if ply.aim_dir=="up" then
        ply.aim=0 ply.flp0=false
        ply.b_dx=0
        ply.b_dy=-ply.b_dbase
        ply.b_os_x=ply.x+2
        ply.b_os_y=ply.y-10

    elseif ply.aim_dir=="dn" then
        ply.aim=4 ply.flp0=false
        ply.b_dx=0
        ply.b_dy=ply.b_dbase
        ply.b_os_x=ply.x-1
        ply.b_os_y=ply.y

    elseif ply.aim_dir=="rt" then
        ply.aim=2 ply.flp0=false
        ply.b_dx=ply.b_dbase
        ply.b_dy=0
        ply.b_os_x=ply.x+5
        ply.b_os_y=ply.y-4

    elseif ply.aim_dir=="lt" then
        ply.aim=2 ply.flp0=true
        ply.b_dx=-ply.b_dbase
        ply.b_dy=0
        ply.b_os_x=ply.x-5
        ply.b_os_y=ply.y-4

    elseif ply.aim_dir=="uprt" then
        ply.aim=1 ply.flp0=false
        ply.b_dx=ply.b_dbase
        ply.b_dy=-ply.b_dbase
        ply.b_os_x=ply.x+4
        ply.b_os_y=ply.y-10

    elseif ply.aim_dir=="uplt" then
        ply.aim=1 ply.flp0=true
        ply.b_dx=-ply.b_dbase
        ply.b_dy=-ply.b_dbase
        ply.b_os_x=ply.x-4
        ply.b_os_y=ply.y-10

    elseif ply.aim_dir=="dnrt" then
        ply.aim=3 ply.flp0=false
        ply.b_dx=ply.b_dbase
        ply.b_dy=ply.b_dbase
        ply.b_os_x=ply.x+5
        ply.b_os_y=ply.y-1

    elseif ply.aim_dir=="dnlt" then
        ply.aim=3 ply.flp0=true
        ply.b_dx=-ply.b_dbase
        ply.b_dy=ply.b_dbase
        ply.b_os_x=ply.x-5
        ply.b_os_y=ply.y-1
    end
end
 


function ply_anim_top(_ply)
local ply=_ply

if ply.running then
  ply.sp1+=(ply.anim3)   
else ply.sp1=1   
   end
  if ply.sp1>=5 then ply.sp1=1
   end    
end

 function player_collide_top(_ply)
 local ply=_ply
 ply.y += ply.dy

    if collide_map(ply,"up",0)  then

       
     ply.y = flr((ply.y + ply.h) / 8) * 8 - ply.h+1

   

    end  

    if collide_map(ply,"down",0)   then


      ply.y = flr((ply.y + ply.h) / 8) * 8 - ply.h

    end
ply.x += ply.dx
  if collide_map(ply,"left",0)  then
  
     ply.x = flr((ply.x + ply.w) / 8) * 8 
    

  end 

  if collide_map(ply,"right",0)  then

  ply.x = flr(((ply.x) + ply.w) / 8) * 8 -ply.w

    end




   
end

 




