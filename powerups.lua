--[[pod_format="raw",created="2026-02-06 05:18:16",modified="2026-06-26 09:03:22",revision=92]]

--capsules and powerups
function add_new_cap_spawner(_x,_y,_item)

add(effect,{

      x=_x*8,
      y=_y*8,
      w=16,
      h=128,
    
   item=_item,

 update=function(self)
 

 for pl in all(players) do
 if self.x<pl.x then 
 add_new_cap(cam_x-10,self.y,1,self.item)
 
 
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


function add_new_cap(_x,_y,_dx,_item)

add(enemy,{

      x=_x,
      y=_y,
      w=16,
      h=8,
     dx=_dx,
     is_cap=true,
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
 if self.x>=cam_x+240
 or self.x<=cam_x-20 
 
  then

 del(enemy,self)
 

 
 end
 end,
 draw=function(self)
--palt(30,true)
  spr(25,self.x,self.y)
--  spr(25,self.x+8,self.y,true)
--palt()
 end
  
})

end

function add_new_pup(_x,_y,_item,_owner)

add(pup,{ 
    x=_x,
    is_pup=true,
    y=_y,
    initial_y=_y+20,
    w=8,
    owner=_owner,
    h=8,
   dx=_x<cam_x+110 and .4 or -.4,
   dy=-1.50,
   sp=_item,

 update=function(self)
 
 self.x+=self.dx
 self.y+=self.dy
 self.dy+=grav/2
 
 if self.dy>2 then self.dy=2
 
 end
 if (level_type=="top down" and self.y+self.h>self.initial_y) and self.dy>0 then
 self.dx=0	
 self.dy=0	
 end

-- resolve_slope(self)
 
 if collide_map(self,"down",3) and self.dy>0 then
 
  self.dx=0
  self.y = flr((self.y + self.h) / 8) * 8 - self.h
  
   end
   
 if collide_map(self,"down",0) then
 
  self.dx=0
 self.y = flr((self.y + self.h) / 8) * 8 - self.h
   
   end
   
   
  for p in all(players)do
  
  -- self.dx+=p.x<self.x and  -.01 or .01
 
 

 
  if hit(p.x+4,p.y+3,self.x+2,self.y-2,self.w-2,self.h+6)
 and not p.dead
--if player touches powerup
--grant item to player 
 
  then 
  p.rapid=false
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
 
 then

 del(pup,self)
 
 end
 
 end,
  draw=function(self)
-- palt(30,true)
 spr(self.sp,self.x,self.y)
-- palt()
-- print(self.owner,self.x,self.y,9)
-- rect(self.x+2,self.y-2,(self.x+self.w)-2,(self.y+self.h)+6,9)
 end
  
  
})

end

--ooh, what'd you get?

function grant_item(item,_ply)
local ply=_ply

if item==27 then ply.weapon="mgun"
elseif item==28 then ply.rapid=true
elseif item==29 then ply.weapon="spread"
elseif item==31 then ply.weapon="fire"

end

end

