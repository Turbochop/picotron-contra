--[[pod_format="raw",created="2026-02-06 05:16:53",modified="2026-08-30 00:01:17",revision=1055]]
local enemysheet=3

function add_new_ebullet(_x,_y,_dx,_dy,_z,_dz)

add(ebullet,{
 
 x=_x,
 y=_y,
 z=_z or 0,
 offsetx=0,
 offsety=0,
 offsetw=0,
 offseth=0,
 plyoffset=0,
 plyoffsetx=0,
 w=8,
 h=8,
 d=8,
 dz=_dz or 0,
 life=250,
 dx=_dx,
 dy=_dy,
 
 update=function(self)
 self.life-=1
 self.x+=self.dx
 self.y+=self.dy
 for p in all(players) do
 if level_type=="top down" then
 	 self.plyoffsetx=(p.flp0) and 6 or 3
 	
 	 
 	 else self.plyoffsetx=3
-- 	  if p.aim==0 then
-- 	 	 self.plyoffsetx=3
-- 	 	 end
 end
 if p.jumping then
 	self.plyoffset=2
 	elseif p.water then self.plyoffset=4

else self.plyoffset= p.prone and 6 or 0
 end 
if (p.jumping==false) self.offsetx=1 self.offsety=-2 self.offsetw=-2 self.offseth=6
if (p.jumping==true) self.offsetx=2 self.offsety=0 self.offsetw=-2 self.offseth=0
if (p.prone==true) self.offsetx=-3 self.offsety=2 self.offsetw=4 self.offseth=-5
if (p.prone and p.on_slope) self.offsetx=1 self.offsety=-4 self.offsetw=-2 self.offseth=4

 

  

 
 if hit(p.x+self.plyoffsetx,p.y+self.plyoffset,self.x+self.offsetx,self.y+self.offsety,self.w+self.offsetw,self.h+self.offseth)
 and p.respawn>=15 and not (level_type=="3d" and p.prone)
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
 or self.x<=cam_x
 or self.y>=cam_y+132 
 or self.y<=cam_y-20 then
 
 del(ebullet,self)
 add_new_shrap(self.x+2,self.y-2)
 
 end
 end,
 draw=function(self)
--  rect(self.x+self.offsetx,self.y+self.offsety,(self.x+self.offsetx)+(self.w+self.offsetw),(self.y+self.offsety)+(self.h+self.offseth),7)
--  for ply in all (players) do
--  rect(ply.x+self.plyoffsetx,ply.y+self.plyoffset,ply.x+self.plyoffsetx,ply.y+self.plyoffset,9)
-- end
  sspr(enemysheet,48,32,8,8,self.x,self.y,8,8)
  

 end
  
})

end



function add_new_turret(_x,_y,_z)

add(enemy,{
 x=_x*8,
 y=_y*8,
 z=_z or 0,
 is_turret=true,
 targetable=false,
 deployed=false,
 opening=false,
 opened=false,
 openframe=1,
 opentimer=1,
 opentimermax=7,
 blink = {21,24,8},
 w=16,
 h=16,
 d=4,
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
 rotate=5,
 led_pal=1,
  direction= {80,64,48,32,16,32,48,64,80,64,48,32,16,32,48,64,80},
  turret_dirs={
 -- dx,   dy,   flipx, flipy
 { 0,   -.6, true,  true },
 {.3,   -.6, false, true },
 {.6,   -.6, false, true },
 {.6,   -.3, false, true },
 {.6,    0,  false, true },
 {.6,    .3, false, false},
 {.6,    .6, false, false},
 {.3,    .6, false, false},
 { 0,    .6, false, false},
 {-.3,   .6, true,  false},
 {-.6,   .6, true,  false},
 {-.6,   .3, true,  false},
 {-.6,    0, true,  false},
 {-.6,  -.3, true,  true },
 {-.6,  -.6, true,  true },
 {-.3,  -.6, true,  true }
},
 target=0,
 life=30,
 sp=72,
 timer=0,
 timer2=0,
 timer3=3,

 update=function(self)
 
 for p in all(players) do
 	if (abs((p.x+4)-(self.x+8))<110 and self.y-5>cam_y) and not gameover then
 	if not self.opened then
 	self.deployed=true
 	if not self.opening then
 	sfx(267,-1,0,12)
 	 self.opening=true
 	 end
 	end
 		
 	end
 end
 
 if self.opening then
 self.opentimer+=2
 end
 
if self.opentimer>=self.opentimermax and not gameover then
 	self.openframe+=1
 	self.opentimer=0
 end
 if self.openframe==5 then 
 	self.opened=true
 	self.opening=false
 	self.targetable=true
 	self.openframe=4
 end
if not self.deployed and global_timer%6==1 and self.opened==false then
 self.led_pal+=1
 if self.led_pal>3 then self.led_pal=1
 end
 end	

if self.deployed and self.opened then
self.opentimer=0
self.timer3-=.1 
 self.timer+=.2
-- 
local p = pick_best_target(self.orgnx, self.orgny)
if p then
local offset= (p.prone) and 6 or 8
  local px = p.x + p.w
  local py = p.y + p.h-offset

 local dx = px - self.orgnx
local dy = py - self.orgny

-- convert angle to 1-16 turret steps
local a = atan2(-dy, -dx)

self.target=((flr(a*16+1.5)-1)%16)+1
end
-- 
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

local diff=((self.target-self.rotate+8)%16)-8

if diff>0 then
 self.rotate+=1
elseif diff<0 then
 self.rotate-=1
end

-- keep rotation in 1-16
self.rotate=((self.rotate-1)%16)+1
end
self.timer3=1

end
--if self.rotate==self.target then
--	self.timer=1
--end
--
---- Turret orientation
local d=self.turret_dirs[self.rotate]

self.dx=d[1]
self.dy=d[2]
self.tflipx=d[3]
self.tflipy=d[4]


if self.rotate==self.target then  self.timer2+=.02
else self.timer2-=.003
if self.timer3<0 then self.timer3=0 end
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
end
if gameover then
if self.rotate~=self.target then self.timer2=0
end
	self.target=5
	if self.rotate==5 and self.opened and self.timer2>=.25 then  
	if self.deployed then
		sfx(267,-1,16,12)
	self.deployed=false
	end
   if self.opened then self.opentimer-=1
   end
	end
			
		 if self.opentimer<0 and self.openframe~=1 then
 	self.openframe-=1
 	self.opentimer=self.opentimermax
 		end
 	if self.openframe==1 then self.opened=false
 
 end
end
if (g_otimer>1.9 and gameover) 
or self.y>=cam_y+128
or self.x+self.w<cam_x
 then del(enemy,self)
end
end,
 draw=function(self)
 palt(0,false)


  if not (self.opened and self.deployed) then
  pal(8,self.blink[self.led_pal])
  sspr(3,16*self.openframe,64,16,16,self.x,self.y,self.w,self.h,self.tflipx,self.tflipy)
  
  else
  pal()
  sspr(enemysheet,self.direction[self.rotate],48,16,16,self.x,self.y,self.w,self.h,self.tflipx,self.tflipy)
 end
 
--  print(self.target.." vs "..self.rotate,self.x-8,self.y-16,7)
--  print(tostring(self.target==self.rotate),self.x-8,self.y+8,7)
--  print(self.timer,self.x-8,self.y-8,7)
pal()
palt(30,true)
 end
})

end

--Turret helper function

function pick_best_target(tx, ty)
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

function add_new_shutter_pup(_x,_y,_item,_owner,_z)

add(enemy,{
 
 x=flr(_x*8),
 y=flr(_y*8),
 z=_z or 0,
 is_shutter=true,
 w=16,
 h=16,
 d=4,
 item=_item,
 owner=_owner or 0,
 life=1,
 timer=0,
 sp=16,
 targetable=false,
 open=true,
 
 
 update=function(self)
 
 --shutter delay
 
 if self.open then 
 self.timer+=.1
 elseif not self.open then 
 self.timer-=.1

 end
 
 if self.timer<4 then self.sp=16
 elseif self.timer<5 then self.sp=32
 elseif self.timer<6 then self.sp=48
 elseif self.timer<7 then self.sp=64
 
 end
 
 if self.timer>10 then self.open=false
 
 end
 
 if self.timer<0 then self.open=true
 
 end
 
 if (self.x<=cam_x-16 or self.y>cam_y+128) or (gameover and g_otimer>=1.9) or complete then 
 
 del(enemy,self)
 
 end
 
 if self.life<1  then
  
add_new_exp_spawner(self.x+8,self.y+8,2,2,"instant")

 add_new_pup(self.x,self.y,self.item,self.owner)
 if  level_type~="3d" then
mset(self.x/8,self.y/8,138)
mset((self.x+8)/8,self.y/8,139)
mset(self.x/8,(self.y+8)/8,154)
mset((self.x+8)/8,(self.y+8)/8,155)
end
 del(enemy,self)
 end
 self.targetable=self.open
end,
draw=function(self)

  sspr(enemysheet,self.sp,80,16,16,self.x,self.y,self.w,self.h)
--  print(self.item,self.x,self.y-8,7)
 end
  
})

end

function add_new_enmy_run(_x,_y,_dx,_dir,_z)

add(enemy,{
 x=_x,
 y=_y,
 z=_z or 0,
 is_runner=true,
 targetable=true,
 exposed=true,
 w=8,
 h=8,
 d=5,
 dx=_dx,
 dy=0,
 anim=true,
 s1=1,
 frame={16,24,32,40,48},
 s2=1,
 eflip=false,
 life=1,
 jump=false,
 water=false,
 timer=1,
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
 self.timer+=(self.s1==2) and .20 or .15

 
 if _dir=="right" then self.eflip=false
 elseif _dir=="left" then self.eflip=true
 
 end
 if self.timer>.2 then _dir=nil
 end
 if self.eflip==true then self.dx=-_dx  
 else self.dx=_dx
 
 end
 
 --animation timers
 
 


 
 if self.timer>1.5 then
-- self.anim=not self.anim
self.s1+=(self.anim) and 1 or -1
self.timer=0
 end

if self.s1==1 then self.anim=true
end 

 if self.s1==3 then
 self.anim=false
end

 if self.timer1>1 then
 self.s2+=1 
 
 if self.s2>3 then
 self.s2=1
 end
 self.timer1=0
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
   self.s1=3
   self.s2=3
--   else
--   self.s1=self.timer
--   self.s2=self.timer1
   end
    if self.timer3>1 then self.timer3=1
    end
   ---[[ 
    if collide_map(self,"down",4) then
    self.dy=0
   self.y = flr((self.y + self.h) / 8) * 8 - self.h
    self.water=true
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
--local enemysheet=3
local offset = self.on_slope and 2 or 0
	if not self.water then
	--body
	sspr(enemysheet,self.frame[self.s1],16,8,8,self.x,self.y-8+offset,8,8,self.eflip)

 --legs
	 sspr(enemysheet,self.frame[self.s2],24,8,8,self.x,self.y+offset,8,8,self.eflip)

-- palt()
	 end
 
	 if self.water then
	 sspr(2,16,32,8,8,self.x,self.y+4,8,8)
--	 spr(24,self.x,self.y)
	 end
 
 end
})

end

--Marksman

function add_new_enmy_mark(_x,_y,_flip)
	add(enemy,{
 x=_x*8,
 y=_y*8,
-- z=_z or 0,
exposed=true, -- if false he cannot be shot. He can NOT!... 

 is_mark=true, -- Oh, hi Mark...
 targetable=false,
 w=8,
 h=16,
 dx=0,
 dy=0,
-- d=5,
frame={64,72,80,88,96,56},
 s1=1,
 s2=1,
 eflip=_flip or false,
 life=1,
 idle=false,
 recoil=5,
 rate=1,
 timer=50,
 timer2=179,
 death=0,


 update=function(self)
 self.x+=self.dx
 self.y+=self.dy
 
 if self.s1>2 then self.targetable=true end
 
 if self.recoil~=5 then
 	self.recoil+=1
 end
 
 	
 	
 	if (self.timer2>=60 and self.timer2<=140) and self.timer2%60==self.rate 
 	then 
 	
 	self.recoil=0
 	
 	
 end
 
--stand for a moment, then shoulder up the rifle
 
 if self.idle and self.y+self.h>cam_y+10 then
 	self.timer+=self.rate
 	if self.timer>= 110 and self.timer%10==2 then
 		self.s1+=1
 	end
 	if self.timer>=130 then
 	 self.timer=0
 		self.idle=false
 	end
 end
 
 -- Determine where to aim
 
 if not self.idle then self.timer2+=self.rate
 
local target=nil
local closest=250

for p in all(players) do

	-- only living players can be targeted
	if not p.dead
	and not p.gameover
	and p.respawn>=10
	and p.life~=0 then

		local dist=abs((self.x+4)-(p.x+4))

		if dist<closest then
			closest=dist
			target=p
		end
	end

	if target then
		if self.timer2==180 then
	
			self.eflip=(target.x+4<self.x+4)
		end

		if self.timer2<60 or self.recoil==0 then
			self.eflip=(target.x+4<self.x+4)

			if target.y+4<self.y then
				self.s1=5
			elseif target.y+4>self.y+self.h or (abs((target.x+4)-(self.x+4))<=18 and (target.y+4>self.y and target.prone)) then
				self.s1=4
			else
				self.s1=3
			end
		end
	end
end
 	
 
 -- once aiming is done, then calculate the bullet deltas	
 	
 if self.recoil==0 then
 local dx=self.eflip and -1 or 1
   local dy=0
 	if self.s1==5 then dy=-1
 	elseif self.s1==4 then dy=1
 	else dy=0
 	end
 	
 	--fire
 	
 	add_new_ebullet(self.x,self.y,dx,dy)
 end
 
 --done firing, return to idle
 
 if self.timer2==140+self.rate then self.s1=3
 end
 if self.timer2>= 160 and self.timer2%10==2 then
 		self.s1-=1
 	end
 	if self.timer2>=180 then
 	 self.timer2=0
 		self.idle=true
 	end
 end
 
  if self.x>cam_x+240 
 or self.x<cam_x-10 
 or self.y>cam_y+126 
 or g_otimer>=1.9 and gameover then
 
 del(enemy,self)
 
 end
 
--Kill player on touch
 
 for p in all(players) do
 
 if hit(p.x+4,p.y,self.x,self.y-6,self.w,self.h)
 and self.life==1
 and p.respawn>=15
 and p.health==1
 
 
 then

 p.flp0=self.x<p.x and true or false
 p.health-=1
 end
 end
 
--All players dead? Stand down  
  
  if gameover then
 self.s1=2
 self.timer=0
 self.timer2=0
 end

 
 --die
 
  if self.life<=.5 then
 self.timer=0
 self.timer2=0
 self.dx=self.eflip and -1 or 1 
 self.s1=5
 
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
 
 end,
 draw=function(self)
local recoil= self.recoil<5 and 1 or 0
--body
palt(30,true)
 sspr(enemysheet,self.frame[self.s1],16,8,8,self.x,self.y+recoil,8,8,self.eflip)
--legs 
 
 sspr(enemysheet,self.life==1 and 48 or 56,24,8,8,self.x,self.y+8,8,8,self.eflip)
 
--  print(self.s1,self.x,self.y-16,7)
 end
 
})

end

function add_boss(_x,_y,_z)



add(enemy,{

     x=_x*8,
     y=_y*8,
     z=_z or 0,
     w=8,
     h=16,
     d=10,
     is_boss=true,
     targetable=true,
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
   if bfight then 
 cam_x+=.5
 --map_end=217*8
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

function add_new_cannon(_x,_y,_z)

add(enemy,{
 
 x=_x*8,
 y=_y*8,
 z=_z or 0,
 is_cannon=true,
 targetable=true,
 w=8,
 h=8,
 d=4,
 life=20,
 other=false,
 timer=0,
 sp=129,
 

 update=function(self)

if self.timer>1 and self.other==false then
 add_new_cannon2(self.x+16,self.y)
 self.other=true
 end
 
 
 self.timer+=.1
 
 if self.timer>.2 then self.sp=32
 end
 if self.timer>=2 then
 self.sp=40
 self.timer=0
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

  sspr(enemysheet,self.sp,32,8,8,self.x,self.y,8,8)
  
 end
  
})

end

function add_new_cannon2(_x,_y,_offset,_z)

add(enemy,{
 
 x=_x,
 y=_y,
 z=_z or 0,
 is_cannon=true,
 targetable=true,
 w=8,
 h=8,
 d=4,
 life=20,
 timer=2,
 timer2=0,
 sp=129,

 update=function(self)

 self.timer2+=1
 self.timer-=.1
 
 
 if self.timer<1.8 then self.sp=32
 end
 if self.timer<=0 then
 self.sp=40
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

  sspr(enemysheet,self.sp,32,8,8,self.x,self.y,8,8)
 end
  
})

end

function add_new_bbullet(_x,_y,_dx,_z)

add(ebullet,{
 
 x=_x,
 y=_y,
 z=_z or 0,
 offsetx=0,
 offsety=0,
 offsetw=0,
 offseth=0,
 plyoffset=0,
 w=8,
 h=8,
 d=8,
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
 if p.health>=1 then
 p.health-=1
 end
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

  sspr(4,32,16,8,8,self.x,self.y,8,8)
 
  
 end,
  
})

end

