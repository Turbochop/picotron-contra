--[[pod_format="raw",created="2026-04-07 11:38:53",modified="2026-07-18 05:42:31",revision=171]]
-- Common player control functions

function ply_run_left(_ply)
local ply=_ply
	 ply.timer+=.08
    ply.dx-=ply.acc1
    ply.running=true
    ply.can_prone=false
    ply.flp0=true 
   -- ply.flp1=ply.flp0
end

function ply_run_right(_ply)
local ply=_ply

	   ply.timer+=.08
    ply.dx+=ply.acc1
    ply.running=true
    ply.can_prone=false
    
      if ply.flp0==true then
         ply.flp0 =false
         ply.flp1=ply.flp0
 end
end

function ply_run_up(_ply)
local ply=_ply
	 ply.timer+=.08
    ply.dy-=ply.acc1-.2
    ply.running=true
  
end

function ply_run_down(_ply)
local ply=_ply
	 ply.timer+=.08
    ply.dy+=ply.acc1-.2
    ply.running=true
 
end

function ply_fire(_ply)
local ply=_ply


if ply.refire>ply.max_refire and (ply.weapon=="mgun" or ply.weapon=="homing") then ply.refire=0
end
if ply.refire>=ply.max_refire  then
ply.refire=ply.max_refire

end




if btn(4,ply.player) then ply.refire+=1
else ply.refire=0
end

-- fire weapon: allow held button to create a new charge
-- as soon as the bullet slot opens
if ply.weapon == "fire"
and btn(4, ply.player)
and ply.bullets < ply.max_bullets
and ply.refire > 1 then
    ply.refire = 1
end


if ply.refire==1 and ply.bullets<ply.max_bullets then
ply.can_fire=true
if (ply.prone and ply.water) or fanfare  then

ply.can_fire=false
else ply.can_fire=true 
end

else ply.can_fire=false


end
if ply.jam then
	ply.refire=ply.max_refire-7
end
if ply.firing and ply.recoil<20 then
ply.recoil+=1
end

if ply.recoil==20 then 
ply.recoil=0
ply.firing=false
end 


if not btn(4,ply.player) and ply.jam then
ply.refire=0
ply.firing=false
ply.can_fire=true

	ply.jam=false
end


if btn(4,ply.player) and ply.can_fire

 then 
 if ply.weapon~="fire" then
ply.firing=true
ply.recoil=0
end
ply_weapon(ply)

end
end

--death (side scrolling)

function ply_dead(_ply)

local ply=_ply

if ply.health<1 then 
if ply.dead==false then
 sfx(260,11)
ply.jframet=0
  	ply.jframe=1

ply.health=0
ply.dead=true
timer=0
ply.prone=false
ply.rapid=false
ply.respawn=0
ply.death_timer = 0
ply.td_death_y=flr(ply.y+30)
if ply.td_death_y+16>cam_y+120 then
	ply.td_death_y=cam_y+117
end
 
--ply.dx-=1
--ply.dy-=2
ply.y-=3
ply.water=false
ply.aim=62
ply.sp1=9
ply.dx=0
ply.dy=0
  
end
else ply.dead=false
end
end
 
function ply_d_mvmt(_ply)
local ply=_ply
 ply.sp1-=ply.anim0
 ply.x+=ply.dx
 ply.y+=ply.dy
 ply.dy+=grav
 ply.dx*=ply.fric
 ply.td_death+=(ply.td_death<35) and 1 or 0
 ply.dx=limit_speed(ply.dx,ply.max_dx)%.5
 ply.dy=limit_speed(ply.dy,ply.max_dy)
 ply.jump=(level_type=="top down") and 1.3 or 1.2
 ply.recoil=0
 ply.firing=false
 ply.jumping=false
 --death physics timer
 ply.on_slope=false

if collide_map(ply,"down",6) or collide_map(ply,"down",7) then
    ply.on_slope = true

end       
if ply.td_death>=15 then
	if ply.td_death%7==0 then
		ply.td_death_frame+=(ply.td_death_frame~=4) and 1 or 0
	end
end
 
if ply.death_timer < .1 then
    ply.death_timer += .0001
end

if ply.death_timer <= .0001 then
    ply.dy -= ply.jump
end

if level_type~="top down" then  
-- death throw direction

if not ply.flp0 then ply.dx-=ply.acc1+.4
else ply.dx+=ply.acc1

end
-- death throw animation

 flipping_anim(ply)
end
  --death movement collide
   if (level_type=="top down" and ply.y>ply.td_death_y) and ply.dy>0 then
     
      ply.dx=0
      ply.dy=0
--      ply.y = flr((ply.y + ply.h) / 8) * 8 - ply.h
    end
---[[
  if (collide_map(ply,"down",0) or ply.on_slope) and ply.dy>0 and level_type~="top down" then
     
      ply.dx=0
      ply.dy=0
      ply.y = flr((ply.y + ply.h) / 8) * 8 - ply.h
    end
    
 
    
    if (collide_map(ply,"down",3) or ply.on_slope) and ply.dy>0 then
      ply.dx=0
      ply.dy=0
      ply.y = flr((ply.y + ply.h) / 8) * 8 - ply.h
    end
    
     if collide_map(ply,"left",0) then
      ply.dx=0
    end
    
    if collide_map(ply,"right",0) then
      ply.dx=0
    end   
   --]] 
    --at rest
    
    if ply.dx==0 and ply.dy==0 then 
    ply.prone=true
    end 
    if (ply.prone and ply.dead) or ply.y>cam_y+128  then 
    ply.respawn+=1
    end
    if ply.respawn>=110 and ply.lives~=0 then
 local spawn_ok=false

 for s in all(effect) do
  if s.is_spawner and ply.player==s.id then
   s.queued=true

   if s.valid then
  local vertical_scroll = scrolling=="vertical" or scrolling=="both"
    ply.x=s.x
 if level_type=="top down" then
 ply.y=s.y
elseif vertical_scroll then
 ply.y=s.y-20
else
 ply.y=cam_y-5
end
--    ply.y=(level_type=="side scrolling") and cam_y-5 or s.y-20
    ply.respawn=0
    s.queued=false
    spawn_ok=true
   end
  end
 end

 if spawn_ok then
  ply.lives-=1
  ply.falling=true
  if level_type=="side scrolling" then
   ply.jumping=(scrolling==("vertical" or "both")) and true or false
   end
   ply.td_death=0
  ply.td_death_frame=1
  if level_type=="top down" then
  	ply.aim_dir="up"
  end
  ply.flp0=false
  ply.flp1=false
  ply.dx=2.5
  ply.dy=0
  ply.aim=0
  ply.dead=false
  ply.health=1
  ply.prone=false
  ply.weapon="base"
  timer=0
 end
elseif ply.respawn>=100 and ply.lives<=0 then
 ply.gameover=true
    ply.dx=0
    ply.dy=0
    ply.x=cam_x+20
    ply.y=cam_y+20
    ply.respawn=0
end
end
