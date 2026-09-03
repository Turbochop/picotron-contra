--[[pod_format="raw",created="2026-03-02 22:46:00",modified="2026-08-29 22:52:23",revision=2002]]
--[[pod_format="raw",created="2026-03-02 22:46:00",modified="2026-08-03 07:12:29",revision=1165]]
--Modular player object

function save_player_state(p)
    local state = player_state[p.player]
    -- if level_tpye~="3d" then
    state.lives = p.lives+1
   -- end
   
    state.weapon = p.weapon
    state.rapid = p.rapid
   -- state.gameover=p.gameover
    if not p.gameover then
    state.copied=true
    end
end

function load_player_state(p)
    local state = player_state[p.player]
    p.gameover=state.gameover
      p.dead=state.gameover
     
   if state.copied then state.respawn=15
    p.respawn=state.respawn
    state.copied=false
    
   
    end
    
--    p.lives = state.lives-1
    p.weapon = state.weapon
    p.rapid = state.rapid
 
   -- reset_player_power(p.player)
   
end

function reset_player_power(id)
    local state = player_state[id]
    state.weapon = "base"
    state.rapid = false
    state.respawn =  0
end

function create_player(_x,_y,_player,_z)
  add(players,{
  
  --body
   aim=0,
  acc0=.5,
  flp0=false,
  inv0=false,
 anim1=.11,
 timer=0,
 timer1=0,
  td_death=0,
  td_death_frame=1,  
  td_death_y=0,
 is_player=true,
  --legs
     sp1=0,
     spx=1,
       x=_x,
       y=_y,
       z=_z or 0,
   player=_player,
       w=5,
       h=8,
      dx=0,
      dy=(scrolling=="horizontal") and 0 or (level_type=="3d") and -2 or -1,
  max_dx=.55,
  max_dy=2.5,
  
  
  
    acc1= (level_type=="top down") and .7  or .5,
   copied=false,
    grav=.06,
    blink=0,
       fric=1,
    flp1=false,
    inv1=false,
   anim0=-.11,
   anim2=.15,
   anim3=(level_type=="top down") and .09  or.15,
can_fire=true,
  sound=0,
  wsound=nil,
  firing=false,
  aiming=false,
  jam=false,
  recoil=0,
  refire=0,
  max_refire=0,
  bullets=0,
  max_bullets=4,
  spread_up=true,
  lead=false,
  aim_dir= (level_type=="top down") and "up" or "rt",
 b_dbase=1.5,
  b_dx=0,
  b_dy=-1.5,
  b_os_x=_x+2,
  b_os_y=_y-10,
  landed=false,
  on_slope=false,
  slope_bottom=nil,
  scrollkill=false,
  
  --3d mode advancing variables
  
  advancing=false,
  advframe=1,
  advstep=0,
  advready=false,
  advsavex=0,
  advsavey=0,
  adv_world_x=0,
  adv_world_y=0,
  adv_z=0,
  
  
  
    jump=1.8,
-- jumping=(level_type=="side scrolling") and true or false ,
 jumping=(scrolling=="vertical" or scrolling== "both") and true or false ,
 dropdown=false,
jframet=0,
 jframe=1,
 jbuffer=0,
 running=false,
 start_run=false,
   prone=false,
can_prone=false,
can_jump=true,
 falling=true,
    dead=false,
    gameover=false,
    go_timer=0,
    pallette=7,
   rapid=false,
   water=false,
   watertimer=0,
  weapon=player_state[_player].weapon,
  health=1,
 respawn=player_state[_player].respawn,
death_timer=0,
 lives=player_state[_player].lives-1,
--   lives=lifepool,
  jump_t=0,
  update=function(self)

  
 if self.respawn==.2 then
 
--player_state[self.player].lives-=1
 	load_player_state(self)
 
 
 end
 
 
 
 if fanfare then
   save_player_state(self)
 	
 end

  if level_type=="top down" then
  self.jumping=false
  end
 
 if self.dead then
 
 	self.blink=0
 end
 for p in all(players)do
 	if  self.x>p.x or (flr(self.x)==flr(p.x) and self.player==0) then self.lead=true
elseif self.x<p.x then self.lead=false
 end
   end
   if not multiplayer then self.lead=true end
   if self.health==0 and not self.gameover then 
    ply_dead(self)
    ply_d_mvmt(self)
--    player_collide(self)
    elseif self.health==1 then 
   
   if level_type=="side scrolling" or level_type=="3d" then
   ply_mvmnt_side(self)
    ply_sound(self)
    if level_type=="side scrolling" then
    ply_aim_side(self)
    aiming_side(self)
    elseif level_type=="3d" then
    ply_aim_3d(self)
    aiming_3d(self)	
    end
      ply_fire(self)
    ply_anim_side(self)
    
   elseif level_type=="top down" then
    ply_mvmnt_top(self)
     
    ply_aim_top(self)
    aiming_top(self)
      ply_fire(self)
    ply_anim_top(self)
    
   end
   
    
    end
 

-- 
 if self.gameover then
 self.go_timer+=1
-- if multiplayer then self.advready=true
-- end
 reset_player_power(self.player)
-- self.timer+=.01
 self.timer1+=.01
 if self.timer1>=.1 then self.timer1=0
 end
 if self.timer1<=.05 then self.pallette=self.player==1 and 2 or 16
 end
 if self.timer1>=.05 then self.pallette=self.player==1 and 8 or 12
 end
 
 --Multiplayer life sharing 
 
 for p in all(players) do
 	if btnp(5,self.player) and self.go_timer>=130 and (p.lives~=0 and  p.respawn>=7) and not ((bfight or complete) or (p.dead or p.advancing)) then 
 	p.lives-=1 
 	--player_state[p.player].lives-=1
 	--self.lives-=1
   self.td_death=0
    self.td_death_frame=1
    self.falling=true
--    self.jumping=false
    self.flp0=false
    
     if (level_type=="3d" or level_type=="top down") then
     
     self.y=p.y
    self.x=(self.player==1) and (p.x+4)+6 or (p.x+4)-6
    
   end
   -- self.flp1=false
    if level_type=="side scrolling" then
    if not self.scrollkill then
    self.y=cam_y+10
    self.x=cam_x+20
    end
    if self.scrollkill then
   
   		if p.player~=self.player then
   			self.x=p.x-2 
   			self.y=p.y
   			self.scrollkill=false
   	
   	end
    else
    self.aim_dir="up"
    self.td_death=0
    self.td_death_frame=1
    
   
   end
    end
    if level_type~="3d" then
    self.dx=2.5
    self.dy=0
    end
    self.aim=0
    self.dead=false
    if level_type=="3d" then
     self.dy-=(self.jump+.5)
      self.jumping=true
      self.landed=false
    end
    self.health+=1
    self.respawn=1
    self.gameover=false
    self.go_timer=0
    self.prone=false
    self.weapon="base"
    self.timer=0
 
 end
 
 end
 end
   if self.jam then self.bullets=0
   end
   -- 3d mode advancing logic
    if self.advancing then
    if (global_timer%8==2 and (self.advframe==1 or self.advframe==3)) then
    	sfx(256,-1,0,2)
    	   self.advstep+=1
    end
 if not self.dead then

 self.adv_z+=.30
 
 -- Additional player-only convergence.
 self.adv_world_x+=
  (perspective_3d.cx-self.adv_world_x)*
  perspective_3d.player_pull

 local anchor_x,anchor_y=
  perspective_3d:project_point(
   self.adv_world_x,
   self.adv_world_y,
   self.adv_z
  )

 -- Convert the projected foot position
 -- back to the player's sprite position.
 self.x=anchor_x-4
 self.y=anchor_y-8

 self.dx=0
 self.can_jump=false

end
  	
  end
   
 -- 3d mode advancing
 if self.advancing then
 	self.advframe+=(global_timer%8==2) and 1 or 0
 end
  if self.advframe>4 then
 	self.advframe=1
 end
 
 --instant player animation response to input
 if self.running and self.landed  then
 	if not self.start_run then
 	if level_type~="top down" then
 		self.aim=1
 		end
 		self.sp1=2
 		self.start_run=true
 	end
 	else self.start_run=false
 end

  end,
  
draw=function(self)

 local yoffset=0


 if (flr(self.sp1)==3 or flr(self.sp1)==1)
 and (level_type=="top down" and self.running) or level_type=="side scrolling" then
  yoffset=1

 end

 local xoffset=
  self.aim==2
  and (self.flp0 and -1 or 1)
  or 0

 palt(11,true)
 palt(30,true)

 local lifeoffset=self.player==1 and 190 or 0

 if self.player==1 then
  palt(0,false)
  pal(15,31)
  pal(7,6)
  pal(6,7)
  pal(8,16)
  pal(20,21)
  pal(13,21)
  pal(25,5)
  pal(12,24)
  pal(9,22)
  pal(16,2)
  pal(10,5)
  pal(28,8)
 end

 local xframe={16,24,32,40,48,56,64,72}
 local player_sheet=1
--local yoffset=(level_type=="top down") and 0 or 1
 local offset=
  level_type=="top down"
  and 40
  or 16

 local legoffset=
  level_type=="top down"
  and 48
  or 16
 local dipy= (self.firing and self.recoil<5) and 7 or 8


if level_type=="3d" and not self.gameover then
	player_3d_draw(self)
end
if level_type~="3d"  then
 if self.blink==0 and self.respawn>0
 
 and not(self.lives==0 and self.gameover) then

  --player legs graphics
  
 if level_type=="side scrolling"

  then
  if self.dead and self.prone then
     sspr(
      player_sheet,
      48,24,
      16,8,
      self.x-6,self.y+1,
      16,8,
      self.flp0,self.inv0
     )
end

   if self.water then

    sspr(
     2,16,24,8,8,
     self.x,self.y+4,
     8,8
    )

   elseif self.prone
 

   then
if not self.dead then
    if self.on_slope then

     sspr(
      player_sheet,
      56,32,
      8,16,
      self.x,self.y-dipy,
      8,16,
      self.flp1,self.inv1
     )

    else
    

     sspr(
      player_sheet,
      40,32,
      16,8,
      self.x-6,self.y+9-dipy,
      16,8,
      self.flp1,self.inv1
     )
end
    end

  

--   elseif self.prone then

--    if self.on_slope then
  
--
--   else
--     sspr(
--      player_sheet,
--      56,32,
--      8,16,
--      self.x,self.y-8,
--      8,16,
--      self.flp0,self.inv0
--     )
--end
--    else
-- if self.dead then
--     sspr(
--      player_sheet,
--      48,24,
--      16,8,
--      self.x-6,self.y,
--      16,8,
--      self.flp0,self.inv0
--     )
----   else
----    sspr(
----      player_sheet,
----      40,32,
----      16,8,
----      self.x-6,self.y-1,
----      16,8,
----      self.flp0,self.inv0
----     )
--
--end
--    end


   elseif not self.jumping then

    sspr(
     player_sheet,
     xframe[flr(self.sp1)],
     self.dead and 24 or 32,
     8,8,
     self.x,self.y+1,
     8,8,
     self.flp1,self.inv1
    )

   end

  elseif level_type=="top down"
  and not self.dead then

   sspr(
    player_sheet,
    xframe[flr(self.sp1)],
    legoffset+(self.aim*8),
    8,8,
    self.x-xoffset,
    self.y+yoffset,
    8,8,
    self.flp0,self.inv1
   )

  end

  --player body graphics

  if self.prone or self.dead then

   if level_type=="top down" then
if self.dead then

    sspr(
     player_sheet,
     xframe[self.td_death_frame],
    (level_type=="top down") and 88 or 120,
   (level_type=="top down") and 8 or 16,16,
     self.x,self.y-3,
     (level_type=="top down") and 8 or 16,16,
    self.player==1 and true or false,self.inv0
    )
end
   end

  elseif self.water then

   if not self.firing then

    sspr(
     player_sheet,
     xframe[8],
     16,
     8,8,
     self.x,self.y-2,
     8,8,
     self.flp0,self.inv0
    )

   else

    sspr(
     player_sheet,
     xframe[flr(self.aim+1)],
     offset,
     8,8,
     self.x,self.y-3,
     8,8,
     self.flp0,self.inv0
    )

   end

  elseif self.jumping then

   sspr(
    player_sheet,
    xframe[flr(self.sp1)],
    24,
    8,8,
    self.x,self.y,
    8,8,
    self.flp1,self.inv1
   )

  else 


    sspr(
     player_sheet,
     xframe[flr(self.aim+1)],
     offset,
     8,8,
     self.x,
     self.y+yoffset-dipy,
     8,8,
     self.flp0,self.inv0
    )

 end
 end
 end
--print(self.dead,self.x+20,self.y,7)
--print(flr(self.x+4),self.x,self.y-16,7)
--print(flr((self.y+self.h)/8),self.x,self.y-8,7)
--print(player_state[self.player].lives,self.x,self.y-8,7)
 pal()
 palt(30,true)

 if self.gameover then

  print(
   "GAME",
   cam_x+11+lifeoffset,
   cam_y+6,
   1
  )

  print(
   "GAME",
   cam_x+10+lifeoffset,
   cam_y+5,
   self.pallette
  )

  print(
   "OVER",
   cam_x+11+lifeoffset,
   cam_y+14,
   1
  )

  print(
   "OVER",
   cam_x+10+lifeoffset,
   cam_y+13,
   self.pallette
  )

 end
---[[

 for l=1,self.lives do

  palt(30,true)

  spr(
   39,
   cam_x+lifeoffset+l*8,
   cam_y+8
  )

  if l==4 then
   break
  end

 end
--print(self.respawn,cam_x,50,7)
--]]
end
 })

end


