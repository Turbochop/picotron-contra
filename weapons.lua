--[[pod_format="raw",created="2026-02-06 05:18:49",modified="2026-07-10 21:35:56",revision=740]]

--weapons


function ply_weapon(_ply)


local ply=_ply
  ply.recoil+=1
 local offset= ply.player==1 and 1 or 0
 local seffect=ply.player==0 and 257 or 265

 if ply.weapon=="base" then 
   ply.max_refire=10
 
    if puptmr>=45 then
   sfx(seffect,14-offset,0,2)
   end
   sfx(seffect,15-offset,3,5)
   ply.max_bullets=4
  
   add_new_bullet(ply) 
   
   
   elseif ply.weapon=="mgun" then 
  -- ply.bullets+=1
   ply.max_refire=5
   
   ply.max_bullets=6
   
    sfx(seffect,14-offset,8,4)
    
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
  if puptmr>=45 then sfx(seffect,14-offset,48,8) end
  add_new_laser(ply)
 
  

elseif ply.weapon=="spread" then
  ply.max_refire=10
  ply.max_bullets=6
   if puptmr>=45 then sfx(seffect,14-offset,40,4) end
  sfx(seffect,15-offset,44,4)

  -- Only fire if we have at least one slot
  if ply.bullets < ply.max_bullets then
  add_spread_shot(ply.b_os_x, ply.b_os_y, ply.b_dx, ply.b_dy, ply,60)
  end

  
 elseif ply.weapon=="spread 2" then
 ply.max_refire=10
ply.max_bullets=10


  if puptmr>=45 then sfx(seffect,14-offset,40,4) end
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
  local avail = ply.max_bullets - ply.bullets
  local n = mid(1, avail, 5) -- mid clamps: mid(min,val,max)
  if avail >= 5  then
  n =(ply.weapon=="spread 2") and 5 or 3
elseif avail >= 3 then
  n = 3
  elseif (avail>= 2 and ply.weapon=="spread") then
  n = 2
elseif avail >= 1 then
  n = 1
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
  elseif (n ==3 and ply.weapon=="spread") then
    s_list = { -k*2, 0,  k*2 }       -- wider 3 grouping for base spread
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
    add_new_spread_bullet(
      x, y,
      dx*m + px*s,
      dy*m + py*s, ply, l
    )
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
 add_new_exp_spawner(b.x+4,b.y+4,0)
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
