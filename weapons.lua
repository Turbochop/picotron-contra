--[[pod_format="raw",created="2026-02-06 05:18:49",modified="2026-08-29 23:37:35",revision=1036]]
--weapons
local weaponsheet=4

-- Convert a projected bullet position back into the
-- unprojected coordinates used by 3d movement.
function get_bullet_world_position(_x,_y,_z)

 local world_x=_x
 local world_y=0
 local z=_z or 0

 if level_type=="3d" and perspective_3d then
  world_x=perspective_3d:world_x_from_screen(_x,z)
  world_y=perspective_3d:world_y_from_screen(_y,z)
 end

 return world_x,world_y

end

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
    
  add_new_fire_bullet(ply.b_os_x, ply.b_os_y, ply.b_dx, ply.b_dy, ply, nil, (ply.b_os_z or 0), ply.b_dz or 0) 
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
  -- Only fire if we have at least one slot (Homing, Spread and Spread 2 use the same 
  -- Spread distribution code
  if ply.bullets < ply.max_bullets then
  add_spread_shot(ply.b_os_x, ply.b_os_y, ply.b_dx, ply.b_dy, ply,60, (ply.b_os_z or 0), ply.b_dz or 0)
  end
 

elseif ply.weapon=="spread" then
  ply.max_refire=10
  ply.max_bullets=6
   if puptmr>=45 then sfx(seffect,13-offset,44,4) end
  sfx(seffect,15-offset,40,4)

  -- Only fire if we have at least one slot
  if ply.bullets < ply.max_bullets then
  add_spread_shot(ply.b_os_x, ply.b_os_y, ply.b_dx, ply.b_dy, ply,60, (ply.b_os_z or 0), ply.b_dz or 0)
  end

  
 elseif ply.weapon=="spread 2" then
 ply.max_refire=10
ply.max_bullets=10


  if puptmr>=45 then sfx(seffect,13-offset,40,4) end
  sfx(seffect,15-offset,44,4)

  -- Only fire if we have at least one slot
  if ply.bullets < ply.max_bullets then
  add_spread_shot(ply.b_os_x, ply.b_os_y, ply.b_dx, ply.b_dy, ply,60, (ply.b_os_z or 0), ply.b_dz or 0)
  end
end
end

function add_spread_shot(_x,_y,_dx,_dy,_ply,_life,_z,_dz)
local ply = _ply

local life=_life
local z=_z or 0
local dz=_dz or 0
  -- how wide the cone is
  local k = 0.18

  -- sideways skew per pellet
  local px = -_dy
  local py =  _dx

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

 local s=s_list[i]
 local m=m_list[i]
 local l=l_list[i]

 local pellet_s=s
 local pellet_dz=dz

 if level_type=="3d"
 and perspective_3d
 and ply.weapon~="homing" then

  local is_outer=
   i==1 or i==#s_list

  -- Give only the outside pellets a wider launch angle.
  if is_outer and s~=0 then
   pellet_s*=
    perspective_3d.spread_outer_bias
  end

  -- Apply the existing nose-shape multiplier
  -- to actual forward depth movement.
  pellet_dz*=m

 end

 if ply.weapon~="homing" then

  add_new_spread_bullet(
   _x,
   _y,

   _dx*m+px*pellet_s,
   _dy*m+py*pellet_s,

   ply,
   l,
   z,
   pellet_dz
  )

 else

  add_new_homing_bullet(
   _x,
   _y,

   _dx*m+px*s,
   _dy*m+py*s,

   ply,
   l,
   z,
   dz
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
 add_new_fire_bullet2nd(b.x,b.y,1,-1,b.owner, b.super,b.z,b.dz)
 add_new_fire_bullet2nd(b.x,b.y,1,1,b.owner, b.super,b.z,b.dz)
 add_new_fire_bullet2nd(b.x,b.y,-1,-1,b.owner, b.super,b.z,b.dz)
 add_new_fire_bullet2nd(b.x,b.y,-1,1,b.owner, b.super,b.z,b.dz)
 if b.super then
 add_new_exp_spawner(b.x+4,b.y+8,0)
 	add_new_fire_bullet2nd(b.x,b.y,0,-1.5,b.owner, b.super,b.z,b.dz)
 add_new_fire_bullet2nd(b.x,b.y,1.5,0,b.owner, b.super,b.z,b.dz)
 add_new_fire_bullet2nd(b.x,b.y,0,1.5,b.owner, b.super,b.z,b.dz)
 add_new_fire_bullet2nd(b.x,b.y,-1.5,0,b.owner, b.super,b.z,b.dz)
 end
  end
end

function add_new_bullet(_ply)
_ply.bullets += 1
local ply=_ply
local world_x,world_y=get_bullet_world_position(
 ply.b_os_x,
 ply.b_os_y,
 ply.b_os_z or 0
)
add(bullet,{
 world_x=world_x,
 world_y=world_y,
 x=ply.b_os_x,
 y=ply.b_os_y,
 z=ply.b_os_z or 0,
 dx=ply.b_dx or 0,
 dy=ply.b_dy or 0,
 dz=ply.b_dz or 0,
 dworld_y=ply.b_dworld_y or 0,
 life=60,
 owner=_ply,
 
  update=function(self)
if  level_type=="3d" and perspective_3d then
 self.world_x+=self.dx
 self.world_y+=self.dworld_y
 self.z+=self.dz
 perspective_3d:project(self)
else
 self.x+=self.dx
 self.y+=self.dy
end

self.life-=(level_type=="3d") and 1.5 or 1

 end,
 draw=function(self)
-- palt(30,true)
  sspr(weaponsheet,16,16,8,8,self.x,self.y,8,8)
-- print(self.z,self.x,self.y,7)
-- print(self.owner,self.x,self.y,7)
--  palt()
 end
  
})

end


function add_new_mgun_bullet(_ply)
_ply.bullets += 1
local ply=_ply
local world_x,world_y=get_bullet_world_position(
 ply.b_os_x,
 ply.b_os_y,
 ply.b_os_z or 0
)
add(bullet,{
world_x=world_x,
world_y=world_y,
x=ply.b_os_x,
y=ply.b_os_y,
dx=ply.b_dx or 0,
dy=ply.b_dy or 0,
dz=ply.b_dz or 0,
dworld_y=ply.b_dworld_y or 0,
z=(ply.b_os_z or 0),
 life=60,
 owner=_ply,
 update=function(self)
if  level_type=="3d" and perspective_3d then
 self.world_x+=self.dx
 self.world_y+=self.dworld_y
 self.z+=self.dz
 perspective_3d:project(self)
else
 self.x+=self.dx
 self.y+=self.dy
end

self.life-=(level_type=="3d") and 1.5 or 1

 end,
 draw=function(self)

  sspr(weaponsheet,24,16,8,8,self.x,self.y,8,8)
 
 end
  
})

end

function add_new_spread_bullet(_x,_y,_dx,_dy,_ply,_life,_z,_dz)
  _ply.bullets += 1

  local world_x,world_y=get_bullet_world_position(
   _x,
   _y,
   _z or 0
  )

  add(bullet,{
    world_x=world_x,
    world_y=world_y,
    x=_x, y=_y,
    z=_z or 0,
    dx=_dx or 0, dy=_dy or 0,dz=_dz or 0,
    dworld_y=_ply.b_dworld_y or 0,
    life=_life or 60,
   owner=_ply,
    sp=16,

    update=function(self)
     if  level_type=="3d" and perspective_3d then
 self.world_x+=self.dx
 self.world_y+=self.dworld_y
 self.z+=self.dz
 perspective_3d:project(self)
else
 self.x+=self.dx
 self.y+=self.dy
end

self.life-=(level_type=="3d") and 1.5 or 1
     if (self.life==30 or self.life==48) then self.sp+=8
      end
      
--      if self.life==30 then self.sp+=8
--      end


    end,

    draw=function(self)
      sspr(weaponsheet,self.sp,16,8,8,self.x,self.y,8,8)
--      print(self.dx,self.x,self.y-8,7)
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

function add_new_homing_bullet(_x,_y,_dx,_dy,_ply,_life,_z,_dz)

  _ply.bullets+=1

  local x=_x
  local y=_y
  local z=_z or 0
  local dx=_dx or 0
  local dy=_dy or 0
  local dz=_dz or 0
  local world_x,world_y=get_bullet_world_position(x,y,z)

 

  local planar_speed=sqrt(dx*dx+dy*dy)
  local speed=planar_speed

  if planar_speed<=0 and dz==0 then
    dx=1
    planar_speed=1
    speed=1
  elseif speed<=0 then
    speed=max(abs(dz),1)
  end

  local dir_x=0
  local dir_y=0

  if planar_speed>0 then
    dir_x=dx/planar_speed
    dir_y=dy/planar_speed
  end

  

  local target=find_homing_target(x,y)

  local target_x=nil
  local target_y=nil
  local target_z=nil

  if target then
    target_x=target.x+(target.w or 8)/2
    target_y=target.y+(target.h or 8)/2
--    target_z=(target.z or 0)+(target.d or 0)/2
  end

 

 

  add(bullet,{

    x=x,
    y=y,
    z=z,
    world_x=world_x,
    world_y=world_y,
    dx=dx,
    dy=dy,
    dz=dz,
    dworld_y=_ply.b_dworld_y or 0,
    flpx=false,
    flpy=false,
    speed=speed,
    timer=0+flr(rnd(10)),
    dir_x=dir_x,
    dir_y=dir_y,

    target=target,

    target_x=target_x,
    target_y=target_y,
    target_z=target_z,

    -- Initial launch is dumb
    steer_delay=(_ply.rapid) and 10+flr(rnd(5)) or 20+flr(rnd(10))+flr(rnd(5)),

    
    base_turn=.05+rnd(.135),
    panic_turn=.25,

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
    local increment3d= level_type=="3d" and 2 or 1
self.timer+=increment3d
      
if self.target==nil then
	self.life-=(level_type=="3d") and 1.5 or 1
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

          self.target_z=
--            (self.target.z or 0)+
            (self.target.d or 0)/2

       else

  -- Preserve the last valid coordinates.
  self.target=nil

  self.last_aim_angle=nil
  self.orbit_sweep=0
  self.orbit_sign=0
  self.orbit_timer=0

end
      end

      
      -- Dumb launch
      

     if self.steer_delay>0 then

 local steer_step=
  level_type=="3d" and 2 or 1

 self.steer_delay=
  max(0,self.steer_delay-steer_step)

elseif self.target_x then

        local aim_x=self.target_x-self.x
        local aim_y=self.target_y-self.y

        local aim_dist=sqrt(
          aim_x*aim_x+
          aim_y*aim_y
        )

        if aim_dist>0 then

          
          -- NORMALIZE TARGET DIRECTION
          

          aim_x/=aim_dist
          aim_y/=aim_dist

          
          -- Missile direction relative to target
          

          -- 1 means facing directly toward the target.
          -- 0 means traveling sideways around it.
          -- -1 means facing away.
          local alignment=
  self.dir_x*aim_x+
  self.dir_y*aim_y


local aim_angle=atan2(aim_x,aim_y)

if self.last_aim_angle then

  
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




if alignment>.65 then

  self.orbit_sweep=
    max(0,self.orbit_sweep-.015)

end

-- Am I orbiting?
local orbiting=
  self.orbit_sweep>.125
  and alignment<.4

          -- Then fix it...

          local turn=self.base_turn

   if level_type=="3d" then
   turn*=1.5   
   end


          if orbiting then
-- different turn to get out of the orbit

  turn=self.panic_turn

  self.orbit_timer+=1

  -- check again...
  if self.orbit_timer>8 then
    self.orbit_sweep*=.5
    self.orbit_timer=0
  end

else

  self.orbit_timer=
    max(0,self.orbit_timer-1)

end

          
          -- Steer toward target
          

          self.dir_x=
            self.dir_x*(1-turn)+
            aim_x*turn

          self.dir_y=
            self.dir_y*(1-turn)+
            aim_y*turn

         

          if orbiting then

            self.chaos_timer+=1

            -- draw a line from missile to target
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

         

          local dir_length=sqrt(
            self.dir_x*self.dir_x+
            self.dir_y*self.dir_y
          )

          if dir_length>0 then

            self.dir_x/=dir_length
            self.dir_y/=dir_length

          end

         

        self.dx=self.dir_x*self.speed
self.dy=self.dir_y*self.speed

if level_type=="3d" then

 -- Negative screen dy means moving deeper
 -- into the Base room.
 self.dz=-self.dy

end

          
          -- No target? Break off and expire
         

         if not self.target
and aim_dist<5 then

  self.target_x=nil
  self.target_y=nil
  self.target_z=nil

  self.last_dist=nil
  self.last_aim_angle=nil

  self.orbit_sweep=0
  self.orbit_sign=0
  self.orbit_timer=0

end
end 
end
     

    if  level_type=="3d" and perspective_3d then
 self.world_x+=self.dx
 self.world_y+=self.dworld_y
 self.z+=self.dz
 perspective_3d:project(self)
else
 self.x+=self.dx
 self.y+=self.dy
end

--self.life-=1

	if self.dy~=0 then self.sp=18

end

local ax=abs(self.dx)
local ay=abs(self.dy)

local cardinal=.25
local shallow=.65

if ay<=ax*cardinal then
  self.sp=16

elseif ax<=ay*cardinal then
  self.sp=48

elseif ay<ax*shallow then
  self.sp=24 

elseif ax<ay*shallow then
  self.sp=40 

else
  self.sp=32
end

self.flpx=self.dx<0
self.flpy=self.dy>0
    end,

    draw=function(self)

 local ply=_ply   
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
      sspr(
        weaponsheet,
        self.sp,
        48,
        8,
        8,
        self.x,
        self.y,
        8,
        8,
        self.flpx,      
        self.flpy      
      )
      pal()
 palt()     
 palt(30,true)     
--print(self.flpy,self.x,self.y,7)
    
      -- Targeting reticle
    
local col= (self.owner.player==1) and 8 or 28
local circsize= (self.steer_delay*2)+1.5
       if self.target_x
        and 
       self.steer_delay<= 6
       then
         circ(
           self.target_x+
           sin(self.timer*.07)*rnd(5),
      
           self.target_y+
           cos(self.timer*.09)*rnd(5),
      
          circsize,
           col
         )
       end
--print(self.last_dist,self.x,self.y,7)
    end
  })
end

function add_new_fire_bullet(_x,_y,_dx,_dy,_ply,_super,_z,_dz)
    _ply.bullets += 1

    local world_x,world_y=get_bullet_world_position(
     _x,
     _y,
     _z or 0
    )

    add(bullet,{
        world_x=world_x,
        world_y=world_y,
        x = _x,
        y = _y,
        z= _z or 0,
        dx = _dx or 0,
        dy = _dy or 0,
        dz=_dz or 0,
        dworld_y=_ply.b_dworld_y or 0,
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
                self.z = (p.b_os_z or 0)+4

                -- The charged shot follows the player until released,
                -- so its unprojected position must follow as well.
                self.world_x,self.world_y=
                 get_bullet_world_position(
                  self.x,
                  self.y,
                  self.z
                 )

                -- keep updating launch direction too
                self.dx = p.b_dx or 0
                self.dy = p.b_dy or 0
                self.dz = p.b_dz or 0
                self.dworld_y=p.b_dworld_y or 0
            self.blink+=1
            if self.super then
    self.ready+=1        
    self.dx *= 1.5
    self.dy *= 1.5
    self.dz *= 1.5
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
                if level_type=="3d" and perspective_3d then
 self.world_x+=self.dx
 self.world_y+=self.dworld_y
 self.z+=self.dz
 perspective_3d:project(self)
else
 self.x+=self.dx
 self.y+=self.dy
end

self.life-=4
--                self.life -= 4
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
            sspr(weaponsheet,16,40,8,8,self.x,self.y-1,8,8,flipx)
            else
                sspr(
        weaponsheet,
        16,
        32,
        8,
        8,
        self.x,
        self.y,
        8,
        8,
        self.flpx,      
        self.flpy      
      ) 
            end
            else
            if self.super then
            sspr(weaponsheet, 24,32,16,16,self.x-4,self.y-2,16,16,flipx,flipy)
            else
             sspr(
        weaponsheet,
        16,
        32,
        8,
        8,
        self.x,
        self.y,
        8,
        8,
        self.flpx,      
        self.flpy      
      ) 
            end
            end
            end
--            print(self.life,self.x,self.y,6)
        end
    })
end

function add_new_fire_bullet2nd(_x,_y,_dx,_dy,_ply, _super,_z,_dz)

local world_x,world_y=get_bullet_world_position(
 _x,
 _y,
 _z or 0
)

add(bullet,{
 world_x=world_x,
 world_y=world_y,
 x=_x,
 y=_y,
 z=_z or 0,
 w=_super and 16 or 8,
 h=_super and 16 or 8,
 is_2nd_fire=true,
 owner=_ply,
 dx=_dx or 0,
 dy=_dy or 0,
 dz=_dz or 0,
 -- Positive screen dy points down, while positive world_y points up.
 dworld_y=-(_dy or 0),
 life=40,
 blink=0,
 sp=_super and 24 or 16,


 update=function(self)
 
 if  level_type=="3d" and perspective_3d then
 self.world_x+=self.dx
 self.world_y+=self.dworld_y
 self.z+=self.dz
 perspective_3d:project(self)
else
 self.x+=self.dx
 self.y+=self.dy
end

--self.life-=1
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
sspr(weaponsheet, self.sp,32,self.w,self.h,self.x-4,self.y,self.w,self.h)
--  spr(self.sp,self.x,self.y)
  end

 end
  
})

end

function add_new_laser(_ply)

 local ply=_ply

 clear_player_laser(ply)

 local shot_x=ply.b_os_x
 local shot_y=ply.b_os_y
 local shot_z=ply.b_os_z or 0
 local shot_dz=ply.b_dz or 0

 for i=0,4 do
  add_new_laser_part(
   shot_x,
   shot_y,
   i,
   ply,
   shot_z,
   shot_dz
  )
 end

end


function add_new_laser_part(
 _x,
 _y,
 _i,
 _ply,
 _z,
 _dz
)

 local shot_x=_x
 local shot_y=_y
 local i=_i
 local ply=_ply
 local shot_z=_z or 0
 local dz=_dz or 0

 -- Default world coordinates.
 local shot_world_x=shot_x
 local shot_world_y=0

 -- Convert the initial projected position back
 -- into unprojected world coordinates.
 if level_type=="3d" and perspective_3d then

  shot_world_x=
   perspective_3d:world_x_from_screen(
    shot_x,
    shot_z
   )

  shot_world_y=
   perspective_3d:world_y_from_screen(
    shot_y,
    shot_z
   )

 end

 ply.bullets+=1

 add(bullet,{

  is_laser=true,
  owner=ply,
  laser_part=i,

  -- Actual projected collision position.
  x=shot_x,
  y=shot_y,
  z=shot_z,

  -- Unprojected 3D position.
  world_x=shot_world_x,
  world_y=shot_world_y,

  -- Starting projected position.
  start_x=shot_x,
  start_y=shot_y,
  start_z=shot_z,

  -- Starting unprojected position.
  start_world_x=shot_world_x,
  start_world_y=shot_world_y,

  -- World movement.
  dx=ply.b_dx or 0,
  dy=ply.b_dy or 0,
  dz=dz,
  dworld_y=ply.b_dworld_y or 0,

  flpx=false,
  flpy=false,

  delay=(ply.rapid) and i*1.5 or i*2.5,
  life=80+(i*3),
  sp=19,

  update=function(self)

   self.flpx=self.dx<=0
   self.flpy=self.dy>0

   self.sp=(self.dy==0) and 16 or 24

   if self.dx~=0 and self.dy~=0 then
    self.sp=32
   end

   if self.delay>0 then

    self.delay-=1

    -- Hold this segment at its starting point.
    self.x=self.start_x
    self.y=self.start_y
    self.z=self.start_z

    self.world_x=self.start_world_x
    self.world_y=self.start_world_y

   else

    if  level_type=="3d" and perspective_3d then

     -- Move through unprojected 3D space.
     self.world_x+=self.dx*1.5
     self.world_y+=self.dworld_y*1.3
     self.z+=self.dz*1.5

     -- The bullet loop calls:
     -- perspective_3d:project(self)

    else

     self.x+=self.dx*1.5
     self.y+=self.dy*1.3

    end

   self.life-=(level_type=="3d") and 3 or 2

   end

  end,

  draw=function(self)

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

   sspr(
    weaponsheet,
    self.sp,
    24,
    8,
    8,
    self.x,
    self.y,
    8,
    8,
    self.flpx,
    self.flpy
   )

   pal()
   palt(30,true)

  end

 })

end


function clear_player_laser(_ply)

 local ply=_ply

 for b in all(bullet) do

  if b.owner==ply and b.is_laser then
   kill_bullet(b)
   del(bullet,b)
  end

 end

end
