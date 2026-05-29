--[[pod_format="raw",created="2026-04-07 10:50:13",modified="2026-04-12 15:14:48",revision=45]]

--Player side-scrolling functions


function flipping_anim(_ply)
local ply=_ply
ply.jframet+= ply.anim2
ply.anim2=ply.dead and .11 or .15
	 local rootanim=ply.dead and 3 or 1
	 
	 if (ply.jframe==1)   ply.sp1=rootanim ply.flp1=ply.flp0 ply.inv1=false
    if (ply.jframe==2)   ply.sp1=rootanim+1
    if (ply.jframe==3)   ply.sp1=rootanim ply.flp1=not ply.flp0 ply.inv1=true
    if (ply.jframe==4)   ply.sp1=rootanim+1
	 
	 if ply.jframet>=.90 then
 	ply.jframe+=1
 	ply.jframet=0
 	if ply.jframe>4 then
  	ply.jframe=1
  end
 end
end



 
 -- Side scrolling gameplay (Possibly 3d gameplay as well)

function ply_mvmnt_side(_ply)
local ply=_ply

ply.h=ply.jumping and 6 or 8
--end of level auto movement

if clear>15 and clear<19 then 
--ply.running=false
--ply.dx=0
 ply.can_fire=false
--poke(0x005580,0)
end

if clear>20 and ply.x<map_end+20 then 

ply_run_right(ply)
end



if clear>22 and ply.x<212*8
and (ply.dx<.6 and not ply.falling) 
and not ply.jumping then 
ply.dy-=1.5
ply.jumping=true
end

if clear>22 and (ply.x>191*8 and ply.x<192*8)
--and (ply.dx<.6 and not ply.falling) 
and not ply.jumping  then 
ply.dy-=1.8
ply.jumping=true
end


--post hit invincibilty
ply.respawn+=.1


if ply.respawn<15 then ply.blink+=.5
else ply.blink=0
 end
 
 if ply.blink>1 then ply.blink=0
 end
player_collide_side(ply)
--ply.on_slope=false
if ply.can_jump==false then
ply.jump_t+=.1 

end



--jump down through platforms

if ply.prone and btnp(5,ply.player) 
and collide_map(ply,"down",3) then 
   ply.jumping=true
   ply.jump_t=0
   ply.can_jump=false
  end 

if ply.jump_t>=2.3 then 
ply.jump_t=2.3
ply.can_jump=true
end

if ply.timer>0 
and ply.falling 
and ply.running

then ply.timer-=.05
else ply.timer=0
end
if ply.timer<0  then ply.timer=0
end
if ply.timer>1 then ply.timer=1

end



if ply.landed==false then ply.can_prone=false
else ply.can_prone=true
end


--controls
if clear<15 then 
 if btn(1,ply.player)  then 

 ply_run_right(ply)

    
end
  
  if btn(0,ply.player) then
  ply_run_left(ply)

  end
   end
  if not fanfare then
   if ply.running
   and not btn(0,ply.player)
   and not btn(1,ply.player)
   and not ply.falling then 
   
   ply.running=false
   ply.can_prone=true 
   
   end
  if not ply.running and ply.landed then
  ply.dx=0
  
  end
 
 if btn(3,ply.player) and ply.can_prone then
  ply.prone=true
  
  else ply.prone=false
  end
   end
--  or self.x-2<cam_x and 
 
 -- Begin a jump
 
 if ((btnp(5,ply.player) and clear<15 
 and ply.can_jump and ply.landed) 
 or 
 (ply.x<cam_x and collide_map(ply,"right",1) 
 and ply.landed)
 or
  
 (btn(5,ply.player) and ply.landed and (ply.jbuffer<16 and ply.sound>=1) 
 and ply.can_jump)) then
      ply.dy-=ply.jump
      ply.jumping=true
      ply.landed=false
      ply.can_prone=false
   if ply.prone and btn(5,ply.player) then 
      ply.can_jump=false
      end

  end
  -- Player jump buffer
if ply.falling and not ply.jumping then ply.jbuffer=16
end
    if ply.jumping and btn(5,ply.player) then
	ply.jbuffer+=1
if ply.jbuffer>=16 and btn(5,ply.player) then
 ply.jbuffer=16
end
elseif not btn(5,ply.player) or (ply.landed and not btn(5,ply.player)) then  ply.jbuffer=0
end     

 if collide_map(ply,"up",0) and (ply.jumping and ply.dy<0) and not ply.on_slope then
      

--      ply.dx=0
      ply.dy=0
--      ply.y = 0
      ply.y = flr(ply.y / 8) * 8 +1
 
    end

   
 --player mid air control
 
  
 if not  ply.landed 
    and not ply.jumping then 
    
   if ply.falling   
    and ply.timer<=.6 
    then 
     ply.fric=1
     ply.acc1=.45
      if ply.dx>=0 
       then ply.dx=.68
    
   elseif ply.dx<=0 and ply.can_jump then ply.dx=-.68
   
   ply.fric=1
--   acc1=.45
  
  else ply.fric=.23
      
     end
   end
  end
  end

function limit_speed(num,maximum)
  return mid(-maximum,num,maximum)


end
--controls (aiming)
--]]

---[[
function ply_aim_side(_ply)

local ply= _ply

if clear<15 then
 if btn(2,ply.player) and ply.running  and not ply.jumping and not fanfare then 
 ply.aim=4
 
 elseif (not ply.running) or fanfare then
  ply.aim=5
 end
 
  if ply.aim==6 and ply.running 
  then ply.aim=1
  end
   end
   if clear>=15 or not btn(2,ply.player) then 
   if ply.running and (not ply.firing) or fanfare
   then ply.aim+=ply.anim1
 
  -- player body animation system
  
   if ply.aim>3.85  then ply.anim1=ply.anim0
   end
  if ply.aim<1.11  then ply.anim1=ply.anim2
  end
if ply.water then ply.aim=0
end
  else ply.aim=0 
  end
 end
  if btn(3,ply.player) and ply.running and not fanfare and not ply.water then
   ply.aim=6
  end
  
  
end

--aiming logic 
--and bullet offsets

function aiming_side(_ply)

local ply=_ply
--rapid shot speed modifier
 
 ply.b_dbase=ply.rapid and 2.5 or 1.5
  
  aim="rt"
 ply.b_dx=ply.b_dbase
 ply.b_dy=0
  ply.b_os_x=ply.x+5
  ply.b_os_y=ply.y-5
  
  if ply.prone then 
  ply.b_os_x=ply.x+6
  ply.b_os_y=ply.y+4
  
  end

  
  if btn(2,ply.player) and not ply.prone 
  then  aim="up"
  ply.b_dy=-ply.b_dbase
  ply.b_dx=0
  ply.b_os_x=ply.x
  ply.b_os_y=ply.y-7
  end
  
  if btn(2,ply.player) and btn(1,ply.player) then
  aim="uprt"
  ply.b_dy=-ply.b_dbase
  ply.b_dx=ply.b_dbase
  ply.b_os_x=ply.x+5
  ply.b_os_y=ply.y-12
  end
  if not ply.water then
  if btn(3,ply.player) and btn(1,ply.player) then
  aim="dnrt"
  ply.b_dy=ply.b_dbase
  ply.b_dx=ply.b_dbase
  ply.b_os_x=ply.x+5
  ply.b_os_y=ply.y+1
  end
  end
  if btn(0,ply.player) or ply.flp0==true 
  and not btn(2,ply.player) then 
  aim="lt"
  ply.b_dx=-ply.b_dbase
  ply.b_dy=0
  ply.b_os_x=ply.x-5
  ply.b_os_y=ply.y-5
  
  end
  if btn(2,ply.player) and btn(0,ply.player) then
  aim="uplt"
  ply.b_dy=-ply.b_dbase
  ply.b_dx=-ply.b_dbase
  ply.b_os_x=ply.x-5
  ply.b_os_y=ply.y-12
  end
  if not ply.water then
  if btn(3,ply.player) and btn(0,ply.player) then
  aim="dnlt"
  ply.b_dy=ply.b_dbase
  ply.b_dx=-ply.b_dbase
  ply.b_os_x=ply.x-5
  ply.b_os_y=ply.y+1
  end
  end
  if btn(3,ply.player) and not ply.landed
  and not ply.running
    then
  aim="dn"
  ply.b_dy=ply.b_dbase
  ply.b_dx=0
  ply.b_os_x=ply.x
  ply.b_os_y=ply.y+5
  end
  
  if aim=="lt" and ply.prone then
   
  ply.b_os_x=ply.x-11
  ply.b_os_y=ply.y+4
  end
  
  if ply.jumping then
  
  ply.b_os_x=ply.x
  ply.b_os_y=ply.y
  
  end
  
  if ply.water and not ply.flp0
   then
  
  ply.b_os_x=ply.x+5
  ply.b_os_y=ply.y-1
  elseif ply.water and ply.flp0 then
  ply.b_os_x=ply.x-5
  ply.b_os_y=ply.y-1
  
  end
  
  if ply.water and aim=="up" then
  
  ply.b_os_x=ply.x
  ply.b_os_y=ply.y-8
  end
  
  if ply.water and aim=="uplt" then
  
  ply.b_os_x=ply.x-5
  ply.b_os_y=ply.y-5
  
  end
  
  if ply.water and aim=="uprt" then
  
  ply.b_os_x=ply.x+5
  ply.b_os_y=ply.y-6
  
  end
  
end
 



 
function ply_anim_side(_ply)
 local ply=_ply 
  
 --jumping (flippity flippity)
 if ply.jumping==false then
  	ply.jframet=0
  	ply.jframe=1
  	ply.inv1=false
   	ply.flp1=ply.flp0
      
  end
  if ply.jumping then
  -- ply.jframet+= ply.anim2
  flipping_anim(ply)
  
  

  ply.water=false 
      
    
 
  end
 
 -- water bobbing
 
  if ply.water and not ply.jumping then
  ply.running=false
  ply.jump= 1.3
  ply.watertimer+=.05
  if ply.watertimer>=2 then ply.watertimer=0
  
  end
  if ply.watertimer<=1 then ply.y+=1
  
  end
  
  
  if ply.sp1==1  and not ply.firing then ply.aim=7
   elseif not  ply.water then ply.aim=0
   end
 
end
  
  --running
  
    if ply.running 
    and not  ply.jumping
    and not ply.falling
    
    then 
      ply.sp1+=(ply.anim3)
      
    end
      
      if ply.sp1<=0 and not ply.jumping 
      then ply.sp1=3
     
      end
      
     if ply.sp1>=4 then 
        ply.sp1=1
     
     end
     
     --just standing there...
     
     if ply.running==false and not ply.jumping then
        ply.sp1 = 1
     
     end
      
      --running gait
      
      if ply.sp1>=3 and (ply.aim==4 or ply.aim==6 or ply.firing) and level_type=="side scrolling" then ply.y+=1
      end 
    
    -- running off a ledge
    -- without jumping
    
    if ply.falling and not ply.jumping then
    ply.aim=1
    ply.sp1=2
    
    -- falling down a hole
    
    end
   --[[
    if ply.y>=cam_y+120 then 
    if clear==0 then
    ply.health=0
    else ply.dy-=2
    end
    
    end
   --]]
end


-- landing sound

function ply_sound(_ply)

local ply=_ply


 if ply.sound>=.9 then ply.sound=.9
 end
 if ply.sound<=0 or ply.falling then
  ply.sound=0
 end
 if ply.landed then ply.sound+=1
 end
 
   if ply.falling==false and ply.landed and puptmr==50 then 
    if ply.sound<=1 and level_type=="side scrolling" then 
    if ply.water then sfx(256,10,3,7)
    else sfx(256,10,0,2)
     
   
   end
    end
     end 
  
end   



 
 

 
function player_collide_side(_ply)
 local ply=_ply
-- --physics
local was_on_slope = ply.on_slope
ply.on_slope = false
local snapped_to_semi = false
local snapped_to_slope = false
--
 ply.dy+=grav
--
 ply.dx*=ply.fric
--end
-- --map collision check up and down
   if  ply.dy>0 then
      ply.falling=true
      ply.landed=false
--      
     end
--      
     ply.dy=limit_speed(ply.dy,ply.max_dy)
    if collide_map(ply,"down",4)  then
      ply.water=true
      ply.can_jump=true
      ply.landed=true
      ply.jumping=false
      ply.falling=false
      ply.dy=0
     ply.y = flr((ply.y + ply.h) / 8) * 8 - ply.h
      else ply.water=false
    end  
--    
--   
    if collide_map(ply,"down",0) and not ply.on_slope and ply.dy>0 then
     ply.can_jump=true
--    
      ply.landed=true
      ply.jumping=false
      ply.falling=false
      ply.jump=1.7
      ply.dy=0
      ply.y = flr((ply.y + ply.h) / 8) * 8 - ply.h
    end
--    
  if collide_map(ply,"down",3) and ply.can_jump and ply.dy>0 then
--    
    if not ply.landed  then
     ply.can_jump=true
--     	ply.flp1=ply.dx<0 and true or false
--   
      ply.landed=true
-- 
      ply.jumping=false
      ply.falling=false
      ply.jump=1.7
      ply.dy=0
      ply.y = flr((ply.y + ply.h) / 8) * 8 - ply.h 
     end
   end
--
-- --map collision check left and right 
 if ply.dx<0 then
-- 
 ply.dx=limit_speed(ply.dx,ply.max_dx)
  if collide_map(ply,"left",0) and not ply.on_slope then
--    
     ply.dx=0
--    
--    
  end 
 end
-- 
 if ply.dx>0 then
  ply.dx=limit_speed(ply.dx,ply.max_dx) 
  if collide_map(ply,"right",0) and not ply.on_slope then

 ply.dx=0

    end

 end

ply.x += ply.dx
ply.y += ply.dy

local snapped_to_slope = false
----
if not snapped_to_semi then
    snapped_to_slope = resolve_slope(ply)
end

if not snapped_to_semi and not snapped_to_slope and was_on_slope and ply.dy >= 0 then
    local old_y2 = ply.y
   ply.y += 2
    snapped_to_slope = resolve_slope(ply)
   if not snapped_to_slope then
        ply.y = old_y2
   end
end

local snapped_to_slope = resolve_slope(ply)

-- tiny coyote-style slope glue:
-- if we were on a slope last frame and didn't quite catch this frame,
-- don't immediately declare the player airborne from a 1-pixel seam
if not snapped_to_slope and was_on_slope and ply.dy >= 0 then
   local old_y = ply.y
    ply.y += 2
    snapped_to_slope = resolve_slope(ply)
    if not snapped_to_slope then
       ply.y = old_y
    end
end  

end
