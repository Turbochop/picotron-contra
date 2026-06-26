--[[pod_format="raw",created="2026-02-06 05:15:57",modified="2026-06-26 08:25:55",revision=475]]
--explosions and effects
  function add_controller(_x,_y)

add(effect,{

      x=_x,
      y=_y,
    
 update=function(self)
  for p in all(players) do
self.x=p.x+16	
 end


 
 end,
 draw=function(self)
palt(0,false)
--rectfill(self.x,self.y,self.x+self.w,self.y+self.h,0)
  spr(--[[pod_type="gfx"]]unpod("b64:bHo0AJQAAACjAAAA8BFweHUAQyAgEAT-DxGhdiFXER6hdiFnAR7xBywHDw4HAQ8AMScMJwgA8hkHDQcsER4hN_FnAR4hBxAHMXYxVwEeAScQJ-EFHgEHUAcRdgE3ATcBDADhBlcGBwgPGBgGCwgLCAcnAHARBgcwBwYHEQBSBggLGAdGAAEpABQLKADwAyE3MXYHOAY4Bx7xBDcBNwH_EQ=="),self.x,self.y)
 if btn(0) then
 	rectfill(self.x+2,self.y+8,self.x+4,self.y+11,10)
 end

 if btn(1) then
 	rectfill(self.x+7,self.y+8,self.x+9,self.y+11,10)
 end
 if btn(2) then
 	rectfill(self.x+4,self.y+6,self.x+7,self.y+8,10)
 end
 if btn(3) then
 	rectfill(self.x+4,self.y+11,self.x+7,self.y+13,10)
 end
 if btn(4) then
 	rectfill(self.x+21,self.y+10,self.x+24,self.y+13,10)
 end
 if btn(5) then
 	rectfill(self.x+26,self.y+10,self.x+29,self.y+13,10)
 end
palt()
 end
  
})

end

function add_player_spawner(_x,_y,_type)

add(effect,{

     x=_x,
     y=_y,
     is_spawner=true,
     w=8,
     h=8,
     id=0,
     playeroffset=(_type=="player 2") and 20 or 0,
     screenx=(level_type=="side scrolling") and 0 or 100,
     screeny=(level_type=="side scrolling") and 0 or 110,
     timer=0,
     queued=true,
     init_spawn=true,
     poletimer=0,
     valid=(level_type=="top down") and true or false,
     offset=0,
     polex=32,
     poley=0,
     type=_type or "player 1",
 

 update=function(self)
 if level_type=="top down" then
 	self.x=(cam_x+self.screenx+self.playeroffset)
 self.y=(cam_y+self.screeny)
 self.valid=true
end
 
 
if level_type=="side scrolling" then
 local horizontal_spawn = scrolling=="horizontal" or scrolling=="both"
 self.screenx=horizontal_spawn and 0 or 50
 self.screeny=horizontal_spawn and 0 or 110
 local xoffset=(self.id==0) and 30 or 40
 self.id=(self.type=="player 1") and 0 or 1
self.x=(cam_x+self.screenx)+xoffset+self.offset
 self.y=(cam_y+self.screeny)+self.poley 
 
 self.poletimer+=1
 end
 
if level_type~= "top down" then
for i=1,2 do
 self.poley+=4

 if collide_map(self,"down",3) or collide_map(self,"down",0) or collide_map(self,"down",4) then
  if self.offset>=8 then self.offset-=8 end
  self.valid=true
  self.poley=0
  break
 end

 if self.poley>=128 then
  self.valid=false
  self.offset+=8
  self.poley=0
  break
 
end
end 
end
 self.id=(self.type=="player 1") and 0 or 1

 if self.valid then
 if self.queued then
 if self.init_spawn then
 	if level_type=="top down" then
 --	local offsetx= (self.id==0) and 0 or 20
 	 create_player(self.x,self.y,self.id)
 
elseif level_type=="side scrolling" then
  if scrolling=="horizontal" then
  create_player(self.x,cam_y-5,self.id)
 	elseif scrolling=="vertical" then
 	create_player(self.x,self.y-20,self.id)
 	
 	end
 	end
 	self.queued=false
 	end
 	self.init_spawn=false
 	end
 end
 
 


 

 end,
 
 draw=function(self)
 local col=self.id==0 and 12 or 8
--  rectfill(self.x,self.y,self.x+self.w,self.y+self.h,col)
--print(self.queued,self.x,self.y,7)

 
 end
  
})

end

function add_bridge_destroy(_x,_y,_stages)

add(effect,{

     x=_x,
     y=_y,
     active=false,
     h=16,
     w=24,
 timer=0,
 stage=1,
 stages=_stages or 5,
 

 update=function(self)
  	if	 self.x<cam_x-(self.w) then del (effect,self)
end
 for p in all(players)do
 	if p.x+p.w>=self.x and p.y<=self.y+self.h and not p.dead then
 		self.active=true
 	end
 end
 if self.active then
 	self.timer+=1
 end
 if (self.timer==15) add_new_exp_spawner(self.x,self.y+4,3,2)
	if (self.timer==15)add_new_exp_spawner(self.x+self.w,self.y+4,3,2)
	if (self.timer==25)add_new_exp_spawner(self.x+self.w,self.y+self.h-4,3,2)
	if (self.timer==25)add_new_exp_spawner(self.x+(self.w/2),self.y+(self.h/2),3,2)
	if (self.timer==30) add_new_exp_spawner(self.x,self.y+self.h-4,3,2)
 
if self.timer==30 then

if self.stage==1 then
	mset(self.x/8,self.y/8,110)
	mset(self.x/8,(self.y+8)/8,126)
	else
	mset(self.x/8,self.y/8,191)
	mset(self.x/8,(self.y+8)/8,191)
	end
	mset((self.x+8)/8,self.y/8,191)
	mset((self.x+8)/8,(self.y+8)/8,191)
	mset((self.x+16)/8,self.y/8,109)
	mset((self.x+16)/8,(self.y+8)/8,125)
	--mset(self.x/8,(self.y+8)/8,126)
		self.x+=16
		self.stage+=1
		self.timer=-8
		if self.stage>self.stages then del (effect,self)
		end

end

 
 end,
 
 draw=function(self)

-- spr(self.sp,self.x,self.y)
-- rect(self.x,self.y,self.x+self.w,self.y+self.h,7)
-- print(tostring(self.active),self.x,self.y,7)
 end
  
})

end
function add_new_exp_spawner(_x,_y,_type,_delta,_effect)

add(effect,{

     x=_x,
     y=_y,
  type=_type or 1,
 delta=(_delta or 1) * rnd(1.2),
 effect=_effect or nil,
     h=8,
     w=8,
     size=8,
     position=16,
 timer=0,
    sp=2,
    sw=1,
    sh=1,

 update=function(self)
  self.timer+=1
-- self.delta+= rnd(1.8)
if self.effect=="instant" then
if (self.timer==1)add_new_exp(_x+7,_y+8,self.type)
if (self.timer==4) add_new_exp(_x+7,_y+8,0,.3,.2,self.delta)add_new_exp(_x+7,_y+8,0,-.3,-.2,self.delta)

if (self.timer==5) add_new_exp(_x+7,_y+8,0,.3,-.2,self.delta) add_new_exp(_x+7,_y+8,0,-.3,.2,self.delta) del(effect,self)


else

if (self.timer==2) add_new_exp(_x+7,_y+8,self.type,3)

if (self.timer==4)add_new_exp(_x+7,_y+8,0,.3,.2,self.delta)
if (self.timer==6)add_new_exp(_x+7,_y+8,0,-.3,-.2,self.delta)
if (self.timer==8)add_new_exp(_x+7,_y+8,0,.3,-.2,self.delta)
if (self.timer==10)add_new_exp(_x+7,_y+8,0,-.3,.2,self.delta)



 if self.timer==20 then
 del(effect,self)
 end
 end
 
 
 end,
 
 draw=function(self)
--palt(30,true)
-- sspr(self.sp,self.x-self.offset,self.y-self.offset)
--  sspr(self.sp,self.position,16,self.size,self.size,self.x-self.offset-(self.sw*6/2),self.y-self.offset-(self.sh*6/2),self.size*(self.sw/2),self.size*(self.sh/2),self.flp1,self.inv1)
--print(self.size,self.x,self.y,7)
--palt()
 end
  
})

end

function add_new_exp(_x,_y,_type,_dx,_dy,_delta)

add(effect,{

     x=_x,
     y=_y,
     dx=_dx or 0,
     dy=_dy or 0,
     delta=_delta or 0,
     flp=rnd(1) <.5 and true or false,
     inv=rnd(1) <.5 and true or false,
  type=_type or 1,
  offset=0,
     h=8,
     w=8,
     size=8,
     position=16,
 timer=0,
    sp=2,
    sw=1,
    sh=1,

 update=function(self)
 self.x+=self.dx*self.delta
 self.y+=self.dy*self.delta
 
 self.timer+=.01
 if self.timer<=.01 then
 if self.type==1 then
 sfx(258,5,0,8)
 elseif self.type==2 then
 sfx(258,5,24,8)
 elseif self.type==3 then
 sfx(258,5,32,10)

 end
 
 end
 
 --animation timer
 self.sw+= self.timer
 self.sh+= self.timer
 if self.timer<.05 then 
 self.offset=4
-- self.sp,self.sw,self.sh=33,1,1 
 
 
 elseif self.timer<.09 then 
 self.offset=8
 self.size=16
-- self.sp=34
self.position=24
 
 elseif self.timer<.12 then
-- self.sp=36
 self.position=40
 
 end
 
 if self.timer>=.17 then
 
 del(effect,self)
 
 end
 
 end,
 
 draw=function(self)

-- sspr(self.sp,self.x-self.offset,self.y-self.offset)
  sspr(self.sp,self.position,16,self.size,self.size,self.x-self.offset-(self.sw*6/2),self.y-self.offset-(self.sh*6/2),self.size*(self.sw/2),self.size*(self.sh/2),self.flp,self.inv)

 end
  
})

end



function add_new_shrap(_x,_y)

add(effect,{

     x=_x-4,
     y=_y,
 timer=0,
    sp=63,
update=function(self)
 
 self.timer+=.2
 
 if self.timer>1 then 
 
 del (effect,self)
 
 end
 
 end,
 
 draw=function(self)
--palt(30,true)
 spr(self.sp,self.x,self.y)
-- palt()
 end
  
})

end

function add_new_spawner(_x,_y,_max_x,_dir)

add(effect,{

   dir=_dir,
chance=0,
max_x=_max_x,
 timer=0,
 debug=false,
toggle=false,

update=function(self)
self.timer+=.05
self.x=cam_x+_x
self.y=_y*8

if self.timer>1 then
self.chance=flr(rnd(10)) + 1
self.timer=0
self.toggle= not self.toggle

end

if self.chance>5  
and self.toggle==false 
and enemies<3 then
 self.toggle=true
enemies+=1
add_new_enmy_run(self.x,self.y,.7,self.dir) 

end

if self.x>self.max_x or (gameover and g_otimer>=1.8) then
del(effect,self)
end

end,

draw=function(self)
if  self.debug then
spr(63,self.x-20,self.y)
end
end
})
end


function level_clear()

timer2+=.2
if timer2>=1 then timer2=0

timer3+=1

end

if timer3==1 then


mset(212,10,149)
mset(212,11,167)
mset(212,12,183)

end

if timer3==2 then

add_new_exp_spawner(213*8+8,10*8+8,2,0)
add_new_exp(213*8+8,11*8+8)
add_new_exp(213*8+8,12*8+8)
mset(213,10,149)
mset(213,11,167)
mset(213,12,183)

end

if timer3==3 then


mset(214,10,149)
mset(214,11,167)
mset(214,12,183)

end

if timer3==4 then

add_new_exp(215*8+8,10*8+8)
add_new_exp(215*8+8,11*8+8)
add_new_exp(215*8+8,12*8+8)
mset(215,10,149)
mset(215,11,167)
mset(215,12,183)

end

if timer3==5 then


mset(216,10,149)
mset(216,11,167)
mset(216,12,183)

end

if timer3==6 then

add_new_exp(217*8+8,10*8+8)
add_new_exp(217*8+8,11*8+8)
add_new_exp(217*8+8,12*8+8)
mset(217,10,149)
mset(217,11,167)
mset(217,12,183)

end

end
