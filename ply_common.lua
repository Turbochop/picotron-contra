--[[pod_format="raw",created="2026-04-07 11:38:53",modified="2026-04-11 13:47:44",revision=42]]
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
    ply.dy-=ply.acc1
    ply.running=true
  
end

function ply_run_down(_ply)
local ply=_ply
	 ply.timer+=.08
    ply.dy+=ply.acc1
    ply.running=true
 
end

function ply_fire(_ply)
local ply=_ply


if ply.refire>9 then ply.refire=9
end
if ply.refire==ply.max_refire  then
ply.refire=0

end


if btn(4,ply.player) then ply.refire+=1
else ply.refire=0
end




if ply.refire==1 and ply.bullets<ply.max_bullets then
ply.can_fire=true
if (ply.prone and ply.water) or fanfare  then

ply.can_fire=false
else ply.can_fire=true 
end

else ply.can_fire=false


end
if ply.firing and ply.recoil<20 then
ply.recoil+=1
end

if ply.recoil==20 then 
ply.recoil=0
ply.firing=false
end 





if btn(4,ply.player) and ply.can_fire 

 then 
ply.firing=true
ply.recoil=0
ply_weapon(ply)

end
end

--death

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
 ply.dx=limit_speed(ply.dx,ply.max_dx)%.5
 ply.dy=limit_speed(ply.dy,ply.max_dy)
 ply.jump=1.2
 ply.recoil=0
 ply.firing=false
 ply.jumping=false
 --death physics timer
 ply.on_slope=false

if collide_map(ply,"down",6) or collide_map(ply,"down",7) then
    ply.on_slope = true

end       

 
 if timer <.1 then timer+=.0001
 
 end  
if timer<=.0001 then ply.dy-=ply.jump
end

  
-- death throw direction

if not ply.flp0 then ply.dx-=ply.acc1+.4
else ply.dx+=ply.acc1

end
-- death throw animation

 flipping_anim(ply)

  --death movement collide
  
---[[
  if (collide_map(ply,"down",0) or ply.on_slope) and ply.dy>0 then
     
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
    ply.respawn+=.01
    end
    if ply.respawn>=1 and ply.lives~=0 then
 local spawn_ok=false

 for s in all(effect) do
  if s.is_spawner and ply.player==s.id then
   s.queued=true

   if s.valid then
    ply.x=s.x
    ply.y=-5
    ply.respawn=0
    s.queued=false
    spawn_ok=true
   end
  end
 end

 if spawn_ok then
  ply.lives-=1
  ply.falling=true
  ply.jumping=false
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
elseif ply.respawn>=1 and ply.lives<=0 then
 ply.gameover=true
    ply.dx=0
    ply.dy=0
    ply.x=cam_x+20
    ply.y=cam_y+20
    ply.respawn=0
end
end
--    if ply.respawn>=1 and ply.lives~=0 then 
--    for s in all(effect) do
--    	if ply.player==s.id then
--    s.queued=true
--    	if (s.valid and s.queued) then
--    	 ply.y=-5
--    ply.x=s.x
--    ply.respawn=0
--    s.queued=false
--   end 
--   end
--   end
--    ply.lives-=1
--    ply.falling=true
--    ply.jumping=false
--    ply.flp0=false
--    ply.flp1=false
--   
--    ply.dx=2.5
--    ply.dy=0
--    ply.aim=0
--    ply.dead=false
--    ply.health+=1
--    --ply.respawn=0
--    ply.prone=false
--    ply.weapon="base"
--    timer=0
----     end
--   --  end
--    elseif ply.respawn>=1 and ply.lives<=0 then
--    ply.gameover=true
--    ply.dx=0
--    ply.dy=0
--    ply.x=cam_x+20
--    ply.y=cam_y+20
--    ply.respawn=0
--    
--
-- 
--end
--end
