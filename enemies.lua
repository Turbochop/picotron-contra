--[[pod_format="raw",created="2026-02-06 05:16:53",modified="2026-04-07 09:20:57",revision=345]]


function add_new_ebullet(_x,_y,_dx,_dy)

add(ebullet,{
 
 x=_x,
 y=_y,
 offsetx=0,
 offsety=0,
 offsetw=0,
 offseth=0,
 plyoffset=0,
 w=8,
 h=8,
 life=250,
 dx=_dx,
 dy=_dy,
 
 update=function(self)
 self.life-=1
 self.x+=self.dx
 self.y+=self.dy
 for p in all(players) do
 if p.jumping then
 	self.plyoffset=2

else self.plyoffset= p.prone and 6 or 0
 end 
if (p.jumping==false) self.offsetx=3 self.offsety=-2 self.offsetw=-2 self.offseth=6
if (p.jumping==true) self.offsetx=2 self.offsety=0 self.offsetw=-2 self.offseth=0
if (p.prone==true) self.offsetx=-3 self.offsety=2 self.offsetw=4 self.offseth=-5
 

  

 
 if hit(p.x+5,p.y+self.plyoffset,self.x+self.offsetx,self.y+self.offsety,self.w+self.offsetw,self.h+self.offseth)
 and p.respawn>=15
 and not (p.prone and p.water)
 and p.health==1
 
 then

 p.flp0=p.x+3>self.x+3 and true or false
 p.health-=1
 del(ebullet,self)
 end
 end
  if self.x>=cam_x+245
  or self.life<=0 
 or self.x<=cam_x-20 
 or self.y>=cam_y+132 
 or self.y<=cam_y-20 then
 
 del(ebullet,self)
 add_new_shrap(self.x+2,self.y-2)
 
 end
 end,
 draw=function(self)
--  rect(self.x+self.offsetx,self.y+self.offsety,(self.x+self.offsetx)+(self.w+self.offsetw),(self.y+self.offsety)+(self.h+self.offseth),7)
--  rect(ply.x+3,ply.y+self.plyoffset,ply.x+3,ply.y+self.plyoffset,9)
  spr(140,self.x,self.y)
  

 end
  
})

end



function add_new_turret(_x,_y)

add(enemy,{
 x=_x*8,
 y=_y*8,
 is_turret=true,
 w=16,
 h=16,
 dx=.6,
 dy=0,
 x1=nil,
 x2=nil,
 y1=nil,
 y2=nil,
 orgnx=0,
 orgny=0,
 tflipx=false,
 tflipy=false,
 rotate=0,
 target=0,
 life=30,
 sp=72,
 timer=0,
 timer2=0,
 timer3=3,

 update=function(self)

self.timer3-=.1 
 self.timer+=.2
local p = pick_turret_target(self.orgnx, self.orgny)
if p then
  local px = p.x + p.w
  local py = p.y + p.h-8

  local dx = px - self.orgnx
  local dy = py - self.orgny

  -- deadzone to avoid jitter and accidental diagonals
  local dead = 2

  local horiz = 0
  if dx > dead then horiz = 1
  elseif dx < -dead then horiz = -1 end

  local vert = 0
  if dy > dead then vert = 1
  elseif dy < -dead then vert = -1 end

  -- map (horiz,vert) to your 0..7 scheme:
  -- 0 E, 1 SE, 2 S, 3 SW, 4 W, 5 NW, 6 N, 7 NE
  if vert == -1 then
    if horiz == -1 then self.target = 5
    elseif horiz == 1 then self.target = 7
    else self.target = 6 end
  elseif vert == 1 then
    if horiz == -1 then self.target = 3
    elseif horiz == 1 then self.target = 1
    else self.target = 2 end
  else
    if horiz == -1 then self.target = 4
    elseif horiz == 1 then self.target = 0
    -- else: keep current target
    end
  end
end
 
 self.orgnx=self.x+8  
 self.orgny=self.y+8

if self.timer2>2 then self.timer2=0
end

if self.timer3<=0 then self.timer3=0   
   end
if self.timer>2 then 
self.timer=0
end
if self.timer<.2 then
if self.timer3<=0 then
if self.rotate>6 and self.target==0 then self.rotate=0
elseif self.rotate<1 and self.target==7 then self.rotate=7
end
if self.rotate<self.target then self.rotate+=1 self.timer3=2
elseif self.rotate>self.target then self.rotate-=1 self.timer3=2

end
end
end

-- Turret orientation
if (self.rotate==0)  self.sp=72  self.tflipx,self.tflipy,self.dx,self.dy=false,false,.6,0
if (self.rotate==1)  self.sp=74  self.tflipx,self.tflipy,self.dx,self.dy=false,false,.6,.6 
if (self.rotate==2)  self.sp=76  self.tflipx,self.tflipy,self.dx,self.dy=false,false,0,.6
if (self.rotate==3)  self.sp=74  self.tflipx,self.tflipy,self.dx,self.dy=true,false,-.6,.6  
if (self.rotate==4)  self.sp=72  self.tflipx,self.tflipy,self.dx,self.dy=true,false,-.6,0 
if (self.rotate==5)  self.sp=74  self.tflipx,self.tflipy,self.dx,self.dy=true,true,-.6,-.6 
if (self.rotate==6)  self.sp=76  self.tflipx,self.tflipy,self.dx,self.dy=true,true, 0,-.6
if (self.rotate==7)  self.sp=74  self.tflipx,self.tflipy,self.dx,self.dy=false,true,.6,-.6







if self.rotate==self.target then self.timer2+=.02
end
if self.timer2>2 and p and self.life>=1 then
  add_new_ebullet(self.orgnx-4, self.y+4, self.dx, self.dy)
  self.timer2 = 0
end
if self.life<=.5 or complete then 
self.life=0
add_new_exp_spawner(self.x+8,self.y+8,2,2,"instant")
mset(self.x/8,self.y/8,171)
mset((self.x+8)/8,self.y/8,172)
mset(self.x/8,(self.y+8)/8,186)
mset((self.x+8)/8,(self.y+8)/8,187)
-- mset(sel.x,self.y,171)
 del(enemy,self)
end
if gameover then
	self.target=4
end
if (g_otimer>1.9 and gameover)  then del(enemy,self)
end
end,
 draw=function(self)

  spr(self.sp,self.x,self.y,self.tflipx,self.tflipy)
--  print(self.rotate,self.x,self.y,7)

 end
})

end

--Turret helper function

function pick_turret_target(tx, ty)
  local best_p = nil
  local best_d = 1e9
  for p in all(players) do
    if p.health==1 and not p.dead then
      local dx = (p.x+4) - tx
      local dy = (p.y+4) - ty
      local d  = dx*dx + dy*dy
      if d < best_d then
        best_d = d
        best_p = p
      end
    end
  end
  return best_p
end

function add_new_shutter_pup(_x,_y,_item,_owner)

add(enemy,{
 
 x=flr(_x*8),
 y=flr(_y*8),
 is_shutter=true,
 w=16,
 h=16,
 item=_item,
 owner=_owner or 0,
 life=1,
 timer=0,
 sp=100,
 open=true,
 
 
 update=function(self)
 
 --shutter delay
 
 if self.open then 
 self.timer+=.1
 elseif not self.open then 
 self.timer-=.1

 end
 
 if self.timer<4 then self.sp=100
 elseif self.timer<5 then self.sp=102
 elseif self.timer<6 then self.sp=104
 elseif self.timer<7 then self.sp=106
 
 end
 
 if self.timer>10 then self.open=false
 
 end
 
 if self.timer<0 then self.open=true
 
 end
 
 if self.x<=cam_x-16 or (gameover and g_otimer>=1.9) or complete then 
 
 del(enemy,self)
 
 end
 
 if self.life<1 then
  
add_new_exp_spawner(self.x+8,self.y+8,2,2,"instant")

 add_new_pup(self.x,self.y,self.item,self.owner)
mset(self.x/8,self.y/8,138)
mset((self.x+8)/8,self.y/8,139)
mset(self.x/8,(self.y+8)/8,154)
mset((self.x+8)/8,(self.y+8)/8,155)
 del(enemy,self)
 end
 
end,
draw=function(self)

  spr(self.sp,self.x,self.y)
  
 end
  
})

end

function add_new_enmy_run(_x,_y,_dx,_dir)

add(enemy,{
 x=_x,
 y=_y,
 is_runner=true,
 w=8,
 h=8,
 dx=_dx,
 dy=0,
 anim=true,
 s1=42,
 s2=58,
 eflip=false,
 life=1,
 jump=false,
 timer=42,
 timer1=58,
 timer2=0,
 timer3=0,
 timer4=0,
 timer5=0,
 chance=0,
 death=0,

 update=function(self)
 
 self.x+=self.dx
 self.y+=self.dy
 self.dy+=grav
 self.timer1+=.15
 self.timer2+=.2
 self.timer4+=.05
 
 
 if _dir=="right" then self.eflip=false
 elseif _dir=="left" then self.eflip=true
 
 end
 if self.timer>.2 then _dir=nil
 end
 if self.eflip==true then self.dx=-_dx  
 else self.dx=_dx
 
 end
 
 --animation timers
 
 if self.anim then self.timer+=.15
 else self.timer-=.15
 end
 
 if self.timer>44.8 then
 self.anim=false
 elseif self.timer<42.1 then
 self.anim=true
 end
 
 if self.timer1>60.9 then 
 self.timer1=58
 end
 if self.timer4>1 then self.timer4=1
 
 end
 
 --slopes
 self.on_slope=false
 if (collide_map(self,"down",6) or collide_map(self,"down",7)) then
 	self.on_slope=true
 end

 --ledge behavior logic
 
 if self.timer2>1 then
 
 self.chance=flr(rnd(60)) + 1
 self.timer2=0
 
 end
 if not self.on_slope then
 if collide_map(self,"right",0) and not self.eflip then
 	self.eflip= true
 end
 
 if collide_map(self,"left",0) and self.eflip then
 	self.eflip= false
 end 
 end
 if collide_map(self,"down",3) and self.dy>0
 or collide_map(self,"down",0) 
 
  then 
  self.jump=false
  self.dy=0
  self.y = flr((self.y + self.h) / 8) *8 - self.h
  elseif not self.on_slope then self.jump=true
   end
   if self.jump then
   self.timer3=0
   self.s1=42
   self.s2=60
   else
   self.s1=self.timer
   self.s2=self.timer1
   end
    if self.timer3>1 then self.timer3=1
    end
   ---[[ 
    if collide_map(self,"down",4) then
    self.dy=0
   self.y = flr((self.y + self.h) / 8) * 8 - self.h
    self.s2=24
    self.s1=62
    self.timer5+=.1
   end
   --]]
   --ledge behavior
   
   if collide_map(self,"down",1) 
   or collide_map(self,"down",2)
   then
    
   --jump up
    
    if self.chance<10 
    then
  self.dy-=1
  
   --jump up higher
  
  elseif self.chance>20 and self.chance<30 then 
  self.dy-=1.8
  
  --drop down
  
  elseif self.chance>10 and self.chance<20
   then 
  self.dy=0
  end
    
  --turn around (every night and ...)
    
    if self.chance>30 and self.timer4==1 then
    
     self.eflip= not self.eflip
     self.timer4=0 
  
    end 
   end
 
 if self.x>cam_x+240 
 or self.x<cam_x-10 
 or self.y>cam_y+128 
 or g_otimer>=1.9 and gameover 
 or self.timer5>.5 then
 enemies-=1
 del(enemy,self)
 
 end
 
 --die
 
 if self.life<=.5 then
  self.death+=1 
 if self.death<=11 then

 self.dy-=.2
 self.dx=-self.dx
 end
end
 if self.death>12 then
 add_new_exp_spawner(self.x+4,self.y-4,1,1.1,"instant")
 enemies-=1
 del(enemy,self)
 
 end
 
--kill player
for p in all(players) do
if not (p.prone and p.water) then
 if hit(p.x+4,p.y,self.x,self.y-6,self.w,self.h)
 and self.life==1
 and p.respawn>=15
 and p.health==1
 
 
 then
--  p.flp1=self.x<.x and true or false
 p.flp0=self.x<p.x and true or false
 p.health-=1
 end
 end
 end
 end,
  draw=function(self)
--palt(30,true)
local offset = self.on_slope and 2 or 0
--body

  spr(self.s1,self.x,self.y-8+offset,self.eflip)
 
 --legs
 
  spr(self.s2,self.x,self.y+offset,self.eflip)
--  print(self.on_slope,self.x,self.y,7)
-- palt()
 end
})

end

function add_boss(_x,_y)



add(enemy,{

     x=_x*8,
     y=_y*8,
     w=8,
     h=16,
     is_boss=true,
  life=100,
 timer=0,
timer1=0,
timer2=0,
timer3=0,
pallette=2,
 
 update=function(self)
 self.timer+=.05
 self.timer1+=.05
 if bfight and self.life<=1 then
 self.timer2+=.1
 self.timer3+=.2
 
 end
 
 if self.timer>1 then 
 self.timer=0
 end
 
 if self.timer1>1 then 
 self.timer1=1
 end
 
 if self.timer2>=20 then self.timer2=20
 end
 
 if self.timer3 >=1 then 
 add_new_exp(flr(rnd(10)) + self.x+8,flr(rnd(16)) + self.y+4)
 self.timer3=0
 
 end
 
 if self.timer <=.3 then self.pallette=2-- self.pallette1=9
 elseif self.timer <=.6 then self.pallette=4-- self.pallette1=14 
 elseif self.timer <=.9 then self.pallette=8 -- self.pallette1=1
 end
 
 if self.timer1<.11 then 
 sfx(261,8)
 sfx(262,9)
 end

--boss defeated, level complete
 
 if  self.timer2==20 then 
 add_new_exp_spawner(self.x,self.y+7,2,2,"instant") 
-- sfx(263,15)
 del(enemy,self)
 music(13)
 complete=true
 puptmr=-100
 end

 
 end,
 draw=function(self)
 pal(14,self.pallette)
  spr(164,self.x,self.y)
 
  pal()
--  palt()
-- print(self.life,cam_x,cam_y,7)
 end
 
})

end

function add_new_cannon(_x,_y)

add(enemy,{
 
 x=_x*8,
 y=_y*8,
 is_cannon=true,
 w=8,
 h=8,
 life=20,
 other=false,
 timer=0,
 sp=129,
 
 draw=function(self)

  spr(self.sp,self.x,self.y)
  
 end,
 update=function(self)

if self.timer>1 and self.other==false then
 add_new_cannon2(self.x+16,self.y)
 self.other=true
 end
 
 
 self.timer+=.1
 
 if self.timer>.2 then self.sp=129
 end
 if self.timer>=2 then
 self.sp=130
 self.timer=0
 add_new_bbullet(self.x,self.y,rnd(.5) + 1)
 end
 
 if self.life<=.5 or complete then 
 add_new_exp_spawner(self.x,self.y,2,2,"instant")

 del(enemy,self)
 end
 
 if (g_otimer>1.9 and gameover)  then del(enemy,self)
end

  end
  
})

end

function add_new_cannon2(_x,_y,_offset)

add(enemy,{
 
 x=_x,
 y=_y,
 is_cannon=true,
 w=8,
 h=8,
 life=20,
 timer=2,
 timer2=0,
 sp=129,

 update=function(self)

 self.timer2+=1
 self.timer-=.1
 
 
 if self.timer<1.8 then self.sp=129
 end
 if self.timer<=0 then
 self.sp=130
 self.timer=2
 add_new_bbullet(self.x,self.y,rnd(.5) + 1)
 end
 
 if self.life<=.5 or complete then 
  add_new_exp_spawner(self.x,self.y,2,2,"instant")


 del(enemy,self)
 
 end
 if (g_otimer>1.9 and gameover)  then del(enemy,self)
end

  end,
  
   
 draw=function(self)

  spr(self.sp,self.x,self.y)
 end
  
})

end

function add_new_bbullet(_x,_y,_dx)

add(ebullet,{
 
 x=_x,
 y=_y,
 offsetx=0,
 offsety=0,
 offsetw=0,
 offseth=0,
 plyoffset=0,
 w=8,
 h=8,
 dx=-_dx,
 dy=0,

 timer=0,
 
 
 update=function(self)
 self.timer+=.2
 self.x+=self.dx 
 self.y+=self.dy 
 self.dy+=grav
 
 for p in all(players) do
  if p.jumping then
 	self.plyoffset=2

else self.plyoffset= p.prone and 6 or 0
 end 
if (p.jumping==false) self.offsetx=0 self.offsety=-4 self.offsetw=-2 self.offseth=6
if (p.jumping==true) self.offsetx=1 self.offsety=1 self.offsetw=-2 self.offseth=0
if (p.prone==true) self.offsetx=-3 self.offsety=2 self.offsetw=4 self.offseth=-5



 ---[[
 if hit(p.x+5,p.y+self.plyoffset,self.x+self.offsetx,self.y+self.offsety,self.w+self.offsetw,self.h+self.offseth)
 and p.respawn>=15

 
 then
 
 p.health-=1
 add_new_exp_spawner(self.x,self.y,2,2,"instant")
 del(ebullet,self)
 end
 end
  if self.timer>3 then
-- if collide_map(self,"down",3)
 if collide_map(self,"down",0)
 
 then 
 add_new_shrap(self.x,self.y)
 del(ebullet,self)
end 
end
 --]]
 end,
 draw=function(self)

  spr(15,self.x,self.y)
 
  
 end,
  
})

end

