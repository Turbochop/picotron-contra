--[[pod_format="raw",created="2026-02-06 05:18:16",modified="2026-09-03 22:46:08",revision=181]]

--capsules and powerups
function add_new_cap_spawner_hor(_x,_y,_item,_dir)

add(effect,{
    
      x=_x*8,
      y=_y*8,
      z=_z or 0,
      w=16,
      h=128,
      dir=_dir,   
   item=_item,

 update=function(self)


 for pl in all(players) do
 if self.x<pl.x+4 then 
 local direction=(self.dir=="left") and -1 or 1
 local spawn_side=(self.dir=="left") and cam_x+240 or cam_x-16
 add_new_cap_hor(spawn_side,self.y,direction,self.item,_dir)
 
 
 del(effect,self)


 

 
 
 end
 end
 end,
 draw=function(self)

--line(self.x,self.y-128,self.x,self.h,9)


--  spr(25,self.x,self.y)
--  spr(25,self.x+8,self.y,true)

 end
  
})

end

function add_new_cap_spawner_vert(_x,_y,_item,_dir)

add(effect,{
    
      x=_x,
      y=_y,
      z=_z or 0,
      w=16,
      h=128,
      dir=_dir,   
   item=_item,

 update=function(self)


 for pl in all(players) do
 if self.y>flr(pl.y) and not pl.gameover then 
-- local direction=(self.dir=="left") and -1 or 1
-- local spawn_side=(self.dir=="left") and cam_x+240 or cam_x
 add_new_cap_vert(self.x,cam_y+128,-1,self.item,_dir)
 
 
 del(effect,self)


 

 
 
 end
 end
 end,
 draw=function(self)

--line(cam_x,self.y,cam_x+240,self.y,9)


--  spr(25,self.x,self.y)
--  spr(25,self.x+8,self.y,true)

 end
  
})

end


function add_new_cap_hor(_x,_y,_dx,_item,_z,_dz)

add(enemy,{

      x=_x,
      y=_y,
      z=_z or 0,
      w=16,
      h=8,
      d=8,
     dx=_dx,
     
     dz=_dz or 0,
     is_cap=true,
     targetable=true,
     owner=_owner or 0,
     dy=-1,
   life=1,
   item=_item,
  timer=0,
 update=function(self)
 
self.x+=self.dx
self.y+=self.dy
self.timer+=.02
 
 
 --capsule bob

 if self.dy<-1 then self.dy=-1
 
 elseif self.dy>1 then self.dy=1
 
 end
 
 if self.timer>1 then 

 self.timer=0
 end
 
 if self.timer<.5 then self.dy+=.08
 elseif self.timer>.5 then self.dy-=.08


 

 end
 if self.life<=0 then 
 add_new_pup(self.x,self.y,self.item,self.owner)
 add_new_exp(self.x+8,self.y+4,2)
 
 del(enemy,self)


 --]]
 end
  ---[[
 if self.x>=cam_x+260
 or self.x<=cam_x-20 
 or self.y+self.h<cam_y
  then

 del(enemy,self)
 

 
 end
 end,
 draw=function(self)
palt(30,true)
 sspr(3,16,32,self.w,self.h,self.x,self.y,self.w,self.h)

--palt()

 end
  
})

end

function add_new_cap_vert(_x,_y,_dy,_item,_z,_dz)

add(enemy,{

      x=_x,
      y=_y,
      z=_z or 0,
      w=16,
      h=8,
      d=8,
     dx=-2,
     
     dz=_dz or 0,
     is_cap=true,
     targetable=true,
     owner=_owner or 0,
     dy=_dy,
   life=1,
   item=_item,
  timer=0,
 update=function(self)
 
self.x+=self.dx
self.y+=self.dy
self.timer+=.02
 
 
 --capsule bob

 if self.dx<-2 then self.dx=-2
 
 elseif self.dx>2 then self.dx=2
 
 end
 
 if self.timer>1 then 

 self.timer=0
 end
 
 if self.timer<.5 then self.dx+=.16
 elseif self.timer>.5 then self.dx-=.16


 

 end
 if self.life<=0  then 
 add_new_pup(self.x,self.y,self.item,self.owner)
 add_new_exp(self.x+8,self.y+4,2)
 
 del(enemy,self)


 --]]
 end
  ---[[
 if self.x>=cam_x+260
 or self.x<=cam_x-20 
 or self.y+self.h<cam_y
  then

 del(enemy,self)
 

 
 end
 end,
 draw=function(self)
palt(30,true)
  sspr(3,16,32,self.w,self.h,self.x,self.y,self.w,self.h)

palt(30,true)
 end
  
})

end

function add_new_pup(_x,_y,_item,_owner,_z,_dz)

add(pup,{ 
    x=_x,
    is_pup=true,
    y=_y,
    initial_y=_y+20,
    z=_z or 0,
    w=8,
    owner=_owner,
    h=8,
    d=8,
    timer=0,
    dz=_dz or 0,
   dx=_x<cam_x+110 and .4 or -.4,
   dy=-1.50,
   sp=_item,

 update=function(self)
 self.timer+=1
 self.x+=self.dx
 self.y+=self.dy
 self.dy+=grav/2
 
 if self.dy>2 then self.dy=2
 
 end
 if (level_type=="top down" and self.y+self.h>self.initial_y) and self.dy>0 then
 self.dx=0	
 self.dy=0	
 end
 if self.dy>0 then
 if collide_map(self,"left",0) and self.dx<0 then
 	self.dx=-self.dx
 end
 
  if collide_map(self,"right",0) and self.dx>0 then
 	self.dx=-self.dx
 end
 end
 if  collide_map(self,"up",0) and self.dy<=0 then
 	self.dy=0
 	self.y+=2
 end
-- resolve_slope(self)
 if level_type~= "top down" then
 if collide_map(self,"down",3) and self.dy>0 then
 
  self.dx=0
  self.y = flr((self.y + self.h) / 8) * 8 - self.h
  
   end
   
 if collide_map(self,"down",0) then
 
  self.dx=0
 self.y = flr((self.y + self.h) / 8) * 8 - self.h
   
   end
   end
   
  for p in all(players)do
  
  -- self.dx+=p.x<self.x and  -.01 or .01
 
 

 
  if hit(p.x+4,p.y+3,self.x+2,self.y-2,self.w-2,self.h+6)
 and not p.dead
--if player touches powerup
--grant item to player 
 
  then 
 -- p.rapid=false
  p.refire=0
  grant_item(self.sp,p)
  
  sfx(259,4)
  puptmr=0
  del(pup,self)

  end
end
 if self.x>=cam_x+240+8
 or self.x<=cam_x-20 
 or self.y>=cam_y+128 
 or self.y<=cam_y-60
 or gameover==true
 or self.timer>=420
 then

 del(pup,self)
 
 end
 
 end,
  draw=function(self)
 palt(30,true)
 if global_timer%14>=7 then
 pal(8,20)
 end
 if (self.timer<300 or (self.timer>=300 and global_timer%6>=3))  then 
 spr(self.sp,self.x,self.y)
 end
pal()
palt(30,true)
-- print(self.sp,self.x,self.y,9)
-- rect(self.x+2,self.y-2,(self.x+self.w)-2,(self.y+self.h)+6,9)
 end
  
  
})

end

--ooh, what'd you get?

function grant_item(item,_ply)
local ply=_ply
local prev_weapon=ply.weapon

if item==27 then ply.weapon="mgun"
elseif item==28 then ply.rapid=true
elseif item==29 then

if (ply.weapon=="spread" or ply.weapon=="spread 2") then 
ply.weapon="spread 2"
else
ply.weapon="spread"
end
elseif item==30 then ply.weapon="laser"
elseif item==31 then ply.weapon="fire"
elseif item==37 then ply.weapon="homing"

end
if ply.weapon~=prev_weapon and not (prev_weapon=="spread" and ply.weapon=="spread 2") then 
ply.rapid=false
end

end

