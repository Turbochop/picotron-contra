--[[pod_format="raw",created="2026-02-06 05:18:49",modified="2026-07-18 12:10:43",revision=923]]
--weapons


function ply_weapon(_ply)


local ply=_ply
  ply.recoil+=1
 local offset= ply.player==1 and 1 or 0
 local seffect=ply.player==0 and 257 or 265

 if ply.weapon=="base" then 
   ply.max_refire=10
 
    if puptmr>=45 then
   sfx(seffect,13-offset,0,2)
   end
   sfx(seffect,15-offset,3,5)
   ply.max_bullets=4
  
   add_new_bullet(ply) 
   
   
   elseif ply.weapon=="mgun" then 
  -- ply.bullets+=1
   ply.max_refire=5
   
   ply.max_bullets=6
   
    sfx(seffect,13-offset,8,4)
    
     if puptmr>=45 then
   sfx(seffect,15-offset,12,4)
   end
   add_new_mgun_bullet(ply)
   
   elseif ply.weapon=="fire" then 
   ply.max_refire=25
 
   
   ply.max_bullets=1
   if not ply.jam then
    
  add_new_fire_bullet(ply.b_os_x, ply.b_os_y, ply.b_dx, ply.b_dy, ply) 
  end
  
  elseif ply.weapon=="laser" then
  ply.max_refire = 6 
  ply.max_bullets = 6

   sfx(seffect,15-offset,56,8)
  if puptmr>=45 then sfx(seffect,13-offset,48,8) end
  add_new_laser(ply)
 
 elseif ply.weapon=="homing" then
  ply.max_refire=7
  ply.max_bullets=6
   if puptmr>=45 then 
   if ply.player==0 then
   sfx(266,13,0,12)
   else 
   sfx(266,13-offset,24,12)
   end
   if ply.player==0 then
  sfx(266,15,16,3)
  else
  sfx(266,15-offset,40,3)
  end
end
  -- Only fire if we have at least one slot
  if ply.bullets < ply.max_bullets then
  add_spread_shot(ply.b_os_x, ply.b_os_y, ply.b_dx, ply.b_dy, ply,60)
  end
 

elseif ply.weapon=="spread" then
  ply.max_refire=10
  ply.max_bullets=6
   if puptmr>=45 then sfx(seffect,13-offset,44,4) end
  sfx(seffect,15-offset,40,4)

  -- Only fire if we have at least one slot
  if ply.bullets < ply.max_bullets then
  add_spread_shot(ply.b_os_x, ply.b_os_y, ply.b_dx, ply.b_dy, ply,60)
  end

  
 elseif ply.weapon=="spread 2" then
 ply.max_refire=10
ply.max_bullets=10


  if puptmr>=45 then sfx(seffect,13-offset,40,4) end
  sfx(seffect,15-offset,44,4)

  -- Only fire if we have at least one slot
  if ply.bullets < ply.max_bullets then
  add_spread_shot(ply.b_os_x, ply.b_os_y, ply.b_dx, ply.b_dy, ply,60)
  end
end
end

function add_spread_shot(x, y, dx, dy,_ply,_life)
local ply = _ply

local life=_life
  -- how wide the cone is (bigger = wider)
  local k = 0.18

  -- perpendicular (sideways) vector
  local px = -dy
  local py =  dx

  -- how many pellets can we actually spawn?
--  local shot = ply.weapon=="spread 2" and 5 or 3
  local avail=ply.max_bullets-ply.bullets
local n=mid(1,avail,5)

if ply.weapon=="homing" then

  -- Homing always fires an alternating pair.
  n=min(2,avail)

elseif avail>=5 then

  n=(ply.weapon=="spread 2") and 5 or 3

elseif avail>=3 then

  n=3

elseif avail>=2
and ply.weapon=="spread" then

  n=2

elseif avail>=1 then

  n=1

end
  -- Offsets and speed multipliers chosen for symmetry + rounded "nose"
  -- s = sideways scalar, m = forward speed multiplier
  -- l = life scaler, so pellets expire in such a way that allows rapid fire
  local s_list, m_list, l_list

  if n == 1 then
    s_list = { 0 }
    m_list = { 1 }                 -- center leads
   l_list = { 60 }
  elseif n == 2 then
    s_list = { 0, ply.spread_up and k or -k } -- skewed pair, alternating upward/downward secondary
    m_list = { 1.00, 1.10 }           
    l_list = { 60, 50}
    ply.spread_up= not ply.spread_up
  elseif (n ==3 and (ply.weapon=="spread" or ply.weapon=="homing")) then
    s_list = { -k*2, 0,  k*2 }       -- wider 3 grouping for base spread and homing
    m_list = { 0.92, 1.0, 0.92 }     -- rounded nose
    l_list = { 60, 54, 60}
    elseif (n ==3 and ply.weapon=="spread 2") then
    s_list = { -k*1, 0,  k*1 }      -- narrower grouping for spread 2, since the 5 shot now has the wide pattern
    m_list = { 0.92, 1.0, 0.92 }     -- rounded nose
    l_list = { 60, 54, 60}
  
--    s_list = { -k*2, -k,  k,  k*2 }
--    m_list = { 0.92, 1.00, 1.00, 0.92 }

  else -- n == 5
    s_list = { -k*2, -k, 0,  k,  k*2 }
    m_list = { 0.85, .95, 1., .95, 0.85 }
    l_list = { 60, 54, 51, 54, 60 }
  end

  -- spawn pellets
  for i=1,#s_list do
    local s = s_list[i]
    local m = m_list[i]
    local l = l_list[i]
    if ply.weapon~="homing" then
    add_new_spread_bullet(
      x, y,
      dx*m + px*s,
      dy*m + py*s, ply, l
    )
    else
    add_new_homing_bullet(
      x, y,
      dx*m + px*s,
      dy*m + py*s, ply, l
    )
  end

 end
end

function kill_bullet(b)
local seffect=b.owner.player==0 and 257 or 265
local offset= b.owner.player==1 and 1 or 0
  if b.owner and not b.is_2nd_fire then
    b.owner.bullets = max(0, (b.owner.bullets or 0) - 1)
  end
   if b.is_fire then
 if puptmr>=45 then
 if b.super then
  sfx(seffect,15-offset,38,2)
  else
     sfx(seffect,15-offset,34,2)
    end
     end
     if b.super then
    sfx(seffect,14-offset,36,2)
      else
    sfx(seffect,14-offset,32,2)
end
 add_new_fire_bullet2nd(b.x,b.y,1,-1,b.owner, b.super)
 add_new_fire_bullet2nd(b.x,b.y,1,1,b.owner, b.super)
 add_new_fire_bullet2nd(b.x,b.y,-1,-1,b.owner, b.super)
 add_new_fire_bullet2nd(b.x,b.y,-1,1,b.owner, b.super)
 if b.super then
 add_new_exp_spawner(b.x+8,b.y+8,0)
 	add_new_fire_bullet2nd(b.x,b.y,0,-1.5,b.owner, b.super)
 add_new_fire_bullet2nd(b.x,b.y,1.5,0,b.owner, b.super)
 add_new_fire_bullet2nd(b.x,b.y,0,1.5,b.owner, b.super)
 add_new_fire_bullet2nd(b.x,b.y,-1.5,0,b.owner, b.super)
 end
  end
end

function add_new_bullet(_ply)
_ply.bullets += 1
local ply=_ply
add(bullet,{

 x=ply.b_os_x,
 y=ply.b_os_y,
 dx=ply.b_dx,
 dy=ply.b_dy,
 life=60,
 owner=_ply,
 update=function(self)
 self.x+=self.dx
 self.y+=self.dy
 self.life-=1
 

 end,
 draw=function(self)
-- palt(30,true)
  spr(13,self.x,self.y)
 --print(self.owner,self.x,self.y,7)
--  palt()
 end
  
})

end


function add_new_mgun_bullet(_ply)
_ply.bullets += 1
local ply=_ply
add(bullet,{

x=ply.b_os_x,
y=ply.b_os_y,
dx=ply.b_dx,
dy=ply.b_dy,
 life=60,
 owner=_ply,
 update=function(self)
 self.x+=self.dx
 self.y+=self.dy
 self.life-=1


 end,
 draw=function(self)

  spr(14,self.x,self.y)
 
 end
  
})

end

function add_new_spread_bullet(x, y, dx, dy,_ply,_life)
  _ply.bullets += 1

  add(bullet,{
    x=x, y=y,
    dx=dx, dy=dy,
    life=_life,
   owner=_ply,
    sp=13,

    update=function(self)
      self.x += self.dx
      self.y += self.dy
      self.life -= 1
     if self.life==48 then self.sp+=1
      end
      
      if self.life==30 then self.sp+=1
      end


    end,

    draw=function(self)
      spr(self.sp,self.x,self.y)
      
    end
  })
end

function can_home_target(e)

  return e
     and e.targetable==true
     and e.life
     and e.life>0
     and not e.dead

end

function find_homing_target(x,y)

  local best=nil
  local best_dist=32767

  for e in all(enemy) do

    if can_home_target(e) then

      local ew=e.w or 8
      local eh=e.h or 8

      local tx=e.x+ew/2
      local ty=e.y+eh/2

      local dx=tx-x
      local dy=ty-y

      local dist=dx*dx+dy*dy

      if dist<best_dist then
        best=e
        best_dist=dist
      end
    end
  end

  return best
end

function add_new_homing_bullet(x,y,dx,dy,_ply,_life)

  _ply.bullets+=1

  --------------------------------------------------
  -- INITIAL MOVEMENT
  --------------------------------------------------

  local speed=sqrt(dx*dx+dy*dy)

  if speed<=0 then
    speed=1
    dx=1
    dy=0
  end

  local dir_x=dx/speed
  local dir_y=dy/speed

  --------------------------------------------------
  -- INITIAL TARGET
  --------------------------------------------------

  local target=find_homing_target(x,y)

  local target_x=nil
  local target_y=nil

  if target then
    target_x=target.x+(target.w or 8)/2
    target_y=target.y+(target.h or 8)/2
  end

  --------------------------------------------------
  -- CREATE MISSILE
  --------------------------------------------------

  add(bullet,{

    x=x,
    y=y,

    dx=dx,
    dy=dy,
    flpx=false,
    flpy=false,
    speed=speed,
    timer=0+flr(rnd(10)),
    dir_x=dir_x,
    dir_y=dir_y,

    target=target,

    target_x=target_x,
    target_y=target_y,

    -- Preserve the initial spread direction briefly.
    steer_delay=(_ply.rapid) and 10+flr(rnd(5)) or 20+flr(rnd(10))+flr(rnd(5)),

    -- Each missile has slightly different behavior.
    base_turn=.05+rnd(.135),
    panic_turn=0,

    orbit_timer=0,

last_aim_angle=nil,
orbit_sweep=0,
orbit_sign=0,

last_dist=nil,

    orbit_dir=rnd(1)<.5 and -1 or 1,

    -- Prevents constant orbit-direction flipping.
    chaos_timer=0,

    life=_life,
    owner=_ply,

    is_homing=true,
    sp=16,

    update=function(self)
self.timer+=1
      ------------------------------------------------
      -- KEEP LIVE TARGET POSITION UPDATED
      ------------------------------------------------
if self.target==nil then
	self.life-=1
end
      if self.target then
      self.speed+= (self.speed<=2) and .01 or 0
        if can_home_target(self.target) then

          self.target_x=
            self.target.x+
            (self.target.w or 8)/2

          self.target_y=
            self.target.y+
            (self.target.h or 8)/2

       else

  -- Preserve the last valid coordinates.
  self.target=nil

  self.last_aim_angle=nil
  self.orbit_sweep=0
  self.orbit_sign=0
  self.orbit_timer=0

end
      end

      ------------------------------------------------
      -- DELAY STEERING AFTER LAUNCH
      ------------------------------------------------

      if self.steer_delay>0 then

        self.steer_delay-=1

      elseif self.target_x then

        local aim_x=self.target_x-self.x
        local aim_y=self.target_y-self.y

        local aim_dist=sqrt(
          aim_x*aim_x+
          aim_y*aim_y
        )

        if aim_dist>0 then

          ------------------------------------------------
          -- NORMALIZE TARGET DIRECTION
          ------------------------------------------------

          aim_x/=aim_dist
          aim_y/=aim_dist

          ------------------------------------------------
          -- ORBIT DETECTION
          ------------------------------------------------

          -- 1 means facing directly toward the target.
          -- 0 means traveling sideways around it.
          -- -1 means facing away.
          local alignment=
  self.dir_x*aim_x+
  self.dir_y*aim_y

------------------------------------------------
-- ORBIT DETECTION BY ANGULAR SWEEP
------------------------------------------------

-- Picotron/PICO-8 atan2 uses x,y ordering.
local aim_angle=atan2(aim_x,aim_y)

if self.last_aim_angle then

  -- Shortest signed change across the 0/1 boundary.
  local angle_change=
    (aim_angle-self.last_aim_angle+.5)%1-.5

  local change_size=abs(angle_change)

  if change_size>.0005 then

    local change_sign=
      angle_change<0 and -1 or 1

    -- Continuing around the target in the same direction.
    if self.orbit_sign==0
    or change_sign==self.orbit_sign then

      self.orbit_sweep+=change_size
      self.orbit_sign=change_sign

    else

      -- Reversing direction means it may be correcting
      -- rather than completing an orbit.
      self.orbit_sweep=
        max(0,self.orbit_sweep-change_size*2)

      if self.orbit_sweep<=0 then
        self.orbit_sign=change_sign
      end
    end
  end
end

self.last_aim_angle=aim_angle
self.last_dist=aim_dist

------------------------------------------------
-- BLEED OFF ORBIT SUSPICION WHEN CLOSING CLEANLY
------------------------------------------------

-- Strongly pointed toward the target means the missile
-- is probably intercepting rather than circling.
if alignment>.65 then

  self.orbit_sweep=
    max(0,self.orbit_sweep-.015)

end

------------------------------------------------
-- DETERMINE WHETHER IT IS ORBITING
------------------------------------------------

-- .125 is one eighth of a full revolution:
-- roughly 45 degrees of sustained sweep.
local orbiting=
  self.orbit_sweep>.125
  and alignment<.4

          ------------------------------------------------
          -- CHOOSE NORMAL OR PANIC STEERING
          ------------------------------------------------

          local turn=self.base_turn

          if orbiting then

  turn=self.panic_turn

  self.orbit_timer+=1

  -- Panic correction eventually earns a fresh evaluation.
  if self.orbit_timer>8 then
    self.orbit_sweep*=.5
    self.orbit_timer=0
  end

else

  self.orbit_timer=
    max(0,self.orbit_timer-1)

end

          ------------------------------------------------
          -- STEER TOWARD TARGET
          ------------------------------------------------

          self.dir_x=
            self.dir_x*(1-turn)+
            aim_x*turn

          self.dir_y=
            self.dir_y*(1-turn)+
            aim_y*turn

          ------------------------------------------------
          -- CHAOTIC ORBIT ESCAPE
          ------------------------------------------------

          if orbiting then

            self.chaos_timer+=1

            -- Perpendicular vector.
            local side_x=-aim_y
            local side_y= aim_x

            -- A brief sideways kick breaks clean circles.
            local shove=.08+rnd(.08)

            self.dir_x+=
              side_x*
              self.orbit_dir*
              shove

            self.dir_y+=
              side_y*
              self.orbit_dir*
              shove

            -- Occasionally reverse the spiral direction.
            if self.chaos_timer>4
            and rnd(1)<.16 then

              self.orbit_dir=
                -self.orbit_dir

              self.chaos_timer=0
            end

          else

            self.chaos_timer=
              max(0,self.chaos_timer-1)

          end

          ------------------------------------------------
          -- RENORMALIZE DIRECTION
          ------------------------------------------------

          local dir_length=sqrt(
            self.dir_x*self.dir_x+
            self.dir_y*self.dir_y
          )

          if dir_length>0 then

            self.dir_x/=dir_length
            self.dir_y/=dir_length

          end

          ------------------------------------------------
          -- REBUILD VELOCITY
          ------------------------------------------------

          self.dx=self.dir_x*self.speed
          self.dy=self.dir_y*self.speed

          ------------------------------------------------
          -- LAST-KNOWN-POSITION ARRIVAL
          ------------------------------------------------

         if not self.target
and aim_dist<5 then

  self.target_x=nil
  self.target_y=nil

  self.last_dist=nil
  self.last_aim_angle=nil

  self.orbit_sweep=0
  self.orbit_sign=0
  self.orbit_timer=0

end
end 
end
      ------------------------------------------------
      -- MOVE
      ------------------------------------------------

      self.x+=self.dx
      self.y+=self.dy
      --self.life-=1

	if self.dy~=0 then self.sp=18

end
------------------------------------------------
-- CHOOSE MISSILE ORIENTATION
------------------------------------------------

local ax=abs(self.dx)
local ay=abs(self.dy)

local cardinal=.25
local shallow=.65

if ay<=ax*cardinal then
  self.sp=32 -- horizontal

elseif ax<=ay*cardinal then
  self.sp=36 -- vertical

elseif ay<ax*shallow then
  self.sp=33 -- shallow from horizontal

elseif ax<ay*shallow then
  self.sp=35 -- shallow from vertical
  -- This may require rotation support or a separate sprite.

else
  self.sp=34 -- near 45-degree diagonal
end

self.flpx=self.dx<0
self.flpy=self.dy>0
    end,

    draw=function(self)

      ------------------------------------------------
      -- TEMPORARY MISSILE DRAW
      ------------------------------------------------
if self.owner.player==0 then
	pal(24,12)
	pal(8,28)
end
if self.timer%4==2 then 
	palt(9,true)
	palt(10,true)
end
if self.steer_delay>6 or self.target==nil  then
	palt(9,true)
	palt(10,true)	
end
      spr(
        self.sp,
        self.x,
        self.y,
        self.flpx,
        self.flpy        
      )
      pal()
 palt()     
 palt(30,true)     
--print(self.flpy,self.x,self.y,7)
      ------------------------------------------------
      -- HOMING TARGET INDICATOR
      ------------------------------------------------
local col= (self.owner.player==1) and 8 or 28
       if self.target_x then
         circ(
           self.target_x+
           sin(self.timer*.07)*rnd(5),
      
           self.target_y+
           cos(self.timer*.09)*rnd(5),
      
          1.5,
           col
         )
       end
--print(self.last_dist,self.x,self.y,7)
    end
  })
end

function add_new_fire_bullet(_x,_y,_dx,_dy,_ply,_super)
    _ply.bullets += 1

    add(bullet,{
        x = _x,
        y = _y,
        dx = _dx,
        dy = _dy,
        is_fire = true,
        super = _super or false,
        released = false,
        owner = _ply,
        life = 100,
        blink=0,
        ready=0,
        random=0,

        update=function(self)
        self.random=flr(rnd(20))
            local p = self.owner
             if p.jam then
            	del(bullet,self)
            end
            if p.dead or fanfare then
            	self.released=true
            end
            if p.weapon~="fire" then
            p.refire=0
            	self.released=true
            end
local offset= p.player==1 and 1 or 0
 local seffect=p.player==0 and 257 or 265
            if not self.released then
           
            p.recoil=18
            p.firing=true
            if p.refire>=p.max_refire then self.super=true
            end

                -- follow the player's current firing origin
                self.x = p.b_os_x
                self.y = p.b_os_y

                -- keep updating launch direction too
                self.dx = p.b_dx
                self.dy = p.b_dy
            self.blink+=1
            if self.super then
    self.ready+=1        
    self.dx *= 1.5
    self.dy *= 1.5
end

                if not btn(4, p.player) then
                if puptmr>=45 then
                if  self.super then
   sfx(seffect,14-offset,20,4)
    else
    sfx(seffect,14-offset,27,4)
    end
    end
    if self.super then
    sfx(seffect,15-offset,16,4)
   else
   sfx(seffect,15-offset,24,3)
   end
  
p.recoil=0
                    self.released = true
                    self.blink=1
                end
            else
                self.x += self.dx
                self.y += self.dy
                self.life -= 4
            end
            
            if self.super then self.blink=1 end
        end,

        draw=function(self)
        local flipx=self.random>=10 and true or false
        local flipy=self.random%2==1 and true or false
        local sprite=self.ready%10==4 and 22 or 11
        if self.blink%3==1 then
        if self.life>=60 then
        if not self.released and self.ready~=0 then
            spr(sprite,self.x,self.y-1,flipx)
            else
            spr(22,self.x,self.y)
            end
            else
            if self.super then
            spr(12,self.x-4,self.y-2,flipx,flipy)
            else
            spr(22,self.x,self.y)
            end
            end
            end
--            print(self.life,self.x,self.y,6)
        end
    })
end

function add_new_fire_bullet2nd(_x,_y,_dx,_dy,_ply, _super)

add(bullet,{

 x=_x,
 y=_y,
 is_2nd_fire=true,
 owner=_ply,
 dx=_dx,
 dy=_dy,
 life=40,
 blink=0,
 sp=_super and 12 or 22,


 update=function(self)
 
 self.x+=self.dx
 self.y+=self.dy
 self.life-=2 
 self.blink+=.5
 
 
 if self.blink>=1 then self.blink=0
 end
-- if self.blink<.5 then self.sp=22
-- else self.sp=255
-- end
 if self.life<=0 then
 del(bullet,self)
 
 
 
end
 
 end,
  draw=function(self)
if self.blink<.5 then
  spr(self.sp,self.x,self.y)
  end

 end
  
})

end

function add_new_laser(ply)
  clear_player_laser(ply)
 local shot_x=ply.b_os_x
  local shot_y=ply.b_os_y
  
  for i=0,4 do
    add_new_laser_part(shot_x, shot_y, i, ply)
  end
end

function add_new_laser_part(shot_x, shot_y, i, ply)
  ply.bullets += 1

  add(bullet,{
    is_laser=true,
    owner=ply,
    laser_part=i,

    x=shot_x,
    y=shot_y,
    start_x=shot_x,
    start_y=shot_y,
    dx=ply.b_dx,
    dy=ply.b_dy,
    flpx=false,
    flpy=false,
     delay=(ply.rapid) and i*1.5 or i*2.5,
--    delay=i*1.5,
    life=80 + (i*3),
    sp=19,

    update=function(self)
    
    
      if self.delay > 0 then
        self.delay -= 1
        self.x = self.start_x
        self.y = self.start_y
      else
        self.x += self.dx * 1.5
        self.y += self.dy * 1.3
        self.life -= 1
      end
      self.life -= 1
      
      
    end,

    draw=function(self)
    --palt(30,true)
   
    self.flpx = (self.dx<=0) and true or false 
    self.flpy = (self.dy>0) and true or false
    self.sp=(self.dy==0) and 19 or 20 
    if (self.dx~=0 and self.dy~=0) then
      	self.sp=21
      end
       if global_timer%4<=2 then
       if ply.player==0 then
    	pal(8,28)
    	pal(9,7)
    	pal(10,12)
    	else
    	pal(8,26)
    	pal(9,7)
    	pal(10,11)
    	end
    end
      spr(self.sp,self.x,self.y,self.flpx,self.flpy)
    pal()
      palt(30,true)
--      print(self.dy,self.x,self.y,7)
    end
  })
end

function clear_player_laser(ply)
  for b in all(bullet) do
    if b.owner == ply and b.is_laser then
      kill_bullet(b)
      del(bullet,b)
    end
  end
end
