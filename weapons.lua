--[[pod_format="raw",created="2026-02-06 05:18:49",modified="2026-04-08 03:48:05",revision=266]]

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
   ply.max_refire=6
   
   ply.max_bullets=6
   
    sfx(seffect,14-offset,8,4)
    
     if puptmr>=45 then
   sfx(seffect,15-offset,13,4)
   end
   add_new_mgun_bullet(ply)
   
   elseif ply.weapon=="fire" then 
   ply.max_refire=10
 -- ply.bullets+=1
   
   ply.max_bullets=1
    if puptmr>=45 then
    sfx(seffect,14-offset,24,3)
    end
    sfx(seffect,15-offset,27,5)
  add_new_fire_bullet(ply.b_os_x, ply.b_os_y, ply.b_dx, ply.b_dy, ply) 

elseif ply.weapon=="spread" then
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
  local avail = ply.max_bullets - ply.bullets
  local n = mid(1, avail, 5) -- mid clamps: mid(min,val,max)
  if avail >= 5 then
  n = 5
elseif avail >= 3 then
  n = 3
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
    s_list = { 0,  k }
    m_list = { 1.00, 1.00 }           -- balanced pair
    l_list = { 60, 60}
  elseif n ==3 then
    s_list = { -k*1, 0,  k*1 }
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
local offset= b.owner.player==1 and 1 or 0
  if b.owner and not b.is_2nd_fire then
    b.owner.bullets = max(0, (b.owner.bullets or 0) - 1)
  end
   if b.is_fire then
 if puptmr>=45 then
  sfx(257,15-offset,36,2)
    
     end
    sfx(257,14-offset,32,2)
 add_new_fire_bullet2nd(b.x,b.y,1,-1,b.owner)
 add_new_fire_bullet2nd(b.x,b.y,1,1,b.owner)
 add_new_fire_bullet2nd(b.x,b.y,-1,-1,b.owner)
 add_new_fire_bullet2nd(b.x,b.y,-1,1,b.owner)
  end
end

function add_new_bullet(_ply)
_ply.bullets += 1
ply=_ply
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
ply=_ply
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

function add_new_fire_bullet(_x,_y,_dx,_dy,_ply)
_ply.bullets += 1
add(bullet,{

 x=_x,
 is_fire=true,
 owner=_ply,
 y=_y,
 dx=_dx,
 dy=_dy,
 life=100,
 


 update=function(self)
 
 self.x+=self.dx
 self.y+=self.dy
 self.life-=4
 

 
 end,
  draw=function(self)
 

  spr(22,self.x,self.y)
  
  
 
 end
  
})

end

function add_new_fire_bullet2nd(_x,_y,_dx,_dy,_ply)

add(bullet,{

 x=_x,
 y=_y,
 is_2nd_fire=true,
 owner=_ply,
 dx=_dx,
 dy=_dy,
 life=40,
 blink=0,
 sp=22,


 update=function(self)
 
 self.x+=self.dx
 self.y+=self.dy
 self.life-=2 
 self.blink+=.5
 
 
 if self.blink>=1 then self.blink=0
 end
 if self.blink<.5 then self.sp=22
 else self.sp=255
 end
 if self.life<=0 then
 del(bullet,self)
 
 
 
end
 
 end,
  draw=function(self)

  spr(self.sp,self.x,self.y)
  

 end
  
})

end

