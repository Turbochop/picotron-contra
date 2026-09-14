--[[pod_format="raw",created="2026-09-13 23:53:00",modified="2026-09-14 07:27:23",revision=313]]
 local bosssheet=5
 local enemysheet=3

function add_boss_wallcore(_x,_y,_z)



add(enemy,{

     x=_x*8,
     y=_y*8,
     z=_z or 0,
     w=8,
     h=16,
     d=10,
     is_boss=true,
     targetable=true,
  life=50,
  points=5000,
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

for p in all(players) do
	if not p.gameover and not (p.dead and p.lives<=0) then
		add_score(p,self.points)
	end
end
 del(enemy,self)
 music(127)
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
 points=150,
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
 
 if self.life<=.5  then 
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
 points=150,
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
 
 if self.life<=.5 then 
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

function add_boss_base_eye(_x,_y)

    add(enemy,{
        x=_x*8,
        y=_y*8,
        z=_z or 0,
        w=16,
        h=16,
        d=10,
        dx=1,
        buffer=0,
        is_boss=true,
        is_eye=true,
        nodes=4,
        targetable=false,
        origin=(_x*8)+8,
        range=35,
        linecolor=1,
        life=30,
        frame={16,32},
        sprite=1,
        points=5000,
        alert=false,
        timer=0,
        timer1=5,
        timer2=0,
        timer3=0,
        timer4=0,

        add_boss_node(9,5),
        add_boss_turret(9,7),
        add_boss_node(14,8),
        add_boss_node(14,5),
        add_boss_node(19,5),
        add_boss_turret(19,7),

        update=function(self)
        if self.life~=0 then
        for t in all(enemy) do
        	if  t.is_gun then
        		 t.targetable= not t.closed
t.timer+=1
local track=t.closed and 1 or -1 
 if t.timer==60 then
 if ((t.sprite~=4 and t.closed) or (t.sprite~=1 and not t.closed)) then
 t.sprite+=track
 t.timer=55
 end
if t.sprite==4 then 
t.closed=false
t.timer=-15
elseif t.sprite==1 then
t.closed=true
t.timer=-80
end 

 end
 if not t.closed and t.timer==0 then
	add_new_ebullet(t.x+5,t.y+10,0,1)
	add_new_ebullet(t.x,t.y+10,-.5,1)
	add_new_ebullet(t.x+10,t.y+10,.5,1)
   add_new_muzzleflash(t.x+8,t.y+8)
	add_new_muzzleflash(t.x+3,t.y+8)
	add_new_muzzleflash(t.x+14,t.y+8)
end

        	end
        end
        end
            local speed_scale=self.life<=.5 and .3 or 1

            if self.nodes==0 then
                self.timer3+=1
            end

            if self.timer3==40 then
                self.targetable=true
            end

            if self.targetable then
                self.x+=self.dx*speed_scale
            end

            self.timer+=1
            self.timer1+=self.timer1~=5 and 1 or 0

            if self.timer>=35 then
                self.linecolor+=(self.timer%2==1) and 1 or 0
            end

            if self.timer==60 then
                self.timer=0
            end

            if self.linecolor>5 or self.timer<35 then
                self.linecolor=1
            end

            if self.timer1==1 or self.life==0 then
                self.alert=true
            end

            if self.alert then
                if self.timer1==1 and self.life~=0 then
                    if self.dx~=0 then
                        self.buffer=rnd(100)>=15
                            and self.dx or -self.dx
                        self.dx=0
                    end
                elseif self.dx==0 then
                    self.dx=self.buffer
                end

                self.timer2+=1
                self.sprite=(global_timer%30<=15) and 2 or 1
            else
                self.sprite=1
            end

            if self.timer2>90 then
                self.timer2=0
                self.alert=false
            end

            -- Keep the eye's center within its range.
            -- Check after alert handling restores its direction.
            local left=self.origin-8-self.range
            local right=self.origin-8+self.range

            if self.x<=left then
                self.x=left
                self.dx=abs(self.dx)
            elseif self.x>=right then
                self.x=right
                self.dx=-abs(self.dx)
            end

            if self.timer3%100==1
            and self.life~=0
            and self.targetable then
                add_boss_bubble(self.x,self.y+3)
            end

            if self.life<=.5 then
                self.life=0
            end

            if self.life==0 then
                self.timer4+=1
            end

            if self.timer4%4==2 then
                add_new_exp(
                    flr(rnd(10))+self.x+8,
                    flr(rnd(16))+self.y+4
                )
            end

            -- Boss defeated, level complete.
           

            if self.timer4==40 then
             add_new_exp_spawner(
                    self.x+8,self.y+8,
                    2,2,"instant"
                )
                for p in all(players) do
                    if not p.gameover
                    and not (p.dead and p.lives<=0) then
                        add_score(p,self.points)
                    end

                    del(enemy,self)
                end
            end
        end,

        draw=function(self)
            local orb=8
            local lines={1,16,17,3,19}

            if self.alert then
                orb=(self.timer%10<5) and 12 or 10
            else
                orb=(self.timer%10<5) and 8 or 31
            end

            pal(8,orb)
            pal(14,lines[self.linecolor])
            palt(30,true)

            if self.targetable then
                sspr(
                    bosssheet,
                    self.frame[self.sprite],32,16,16,
                    self.x,self.y,16,16
                )
            end

            pal()
        end,
    })
end



function add_boss_turret(_x,_y)

	add(enemy,{

    x=_x*8,
     y=_y*8,
     targetable=false,
     closed=true,
--     is_boss=true,
     is_gun=true,
     emplacement=true,
     z=_z or 0,
     w=16,
     h=16,
     d=10,
     life=30,
     points=300,
     sprite=1,
     frame={16,32,48,64},
     timer=-30,

 
 update=function(self)

if self.life<=.5  then 
self.life=0
add_new_exp_spawner(self.x+8,self.y+8,2,2,"instant")
mset(self.x/8,self.y/8,171)
mset((self.x+8)/8,self.y/8,172)
mset(self.x/8,(self.y+8)/8,186)
mset((self.x+8)/8,(self.y+8)/8,187)

 del(enemy,self)
end

 end,
 draw=function(self)


palt(30,true)

sspr(bosssheet,self.frame[self.sprite],16,16,16,self.x,self.y,16,16)
palt()
-- print(self.timer,self.x,self.y,7)
-- print(self.closed,self.x,self.y,7)
 end,
})
	
end

function add_boss_node(_x,_y)
	add(enemy,{

    x=_x*8,
     y=_y*8,
     targetable=true,
    emplacement=true,
     z=_z or 0,
     w=16,
     h=16,
     d=10,
     life=25,
     points=200,
     choose=1,
     blink={24,25,9},

 
 update=function(self)
if global_timer%6==1 then
	self.choose+=1
end
 
 if self.choose>3 then self.choose=1
 end
  if self.life<1  then
  
add_new_exp_spawner(self.x+8,self.y+8,2,2,"instant")

 
mset(self.x/8,self.y/8,138)
mset((self.x+8)/8,self.y/8,139)
mset(self.x/8,(self.y+8)/8,154)
mset((self.x+8)/8,(self.y+8)/8,155)
for bs in all(enemy) do
	if bs.is_eye then
		bs.nodes-=1
	end
end
 del(enemy,self)
 end
 
 end,
 draw=function(self)



 palt(30,false)
 pal(30,self.blink[self.choose])
sspr(bosssheet,80,16,16,16,self.x,self.y,16,16)
 pal()
 palt()
 
 end,
})
end