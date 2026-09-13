--[[pod_format="raw",created="2026-02-19 10:55:12",modified="2026-09-08 11:09:05",revision=456]]
--collision
--map collision


function collide_map(obj,mov,flag,ignore_slopes)
 local x=obj.x
 local y=obj.y
 local w=obj.w
 local h=obj.h

 local x1,y1,x2,y2

 if mov=="left" then
  x1=x   y1=y+1
  x2=x   y2=y+h-4

 elseif mov=="right" then
  x1=x+w   y1=y+1
  x2=x+w   y2=y+h-4

 elseif mov=="down" then
  x1=x+1   y1=y+h
  x2=x+w-1 y2=y+h

 elseif mov=="up" then
  x1=x+1   y1=y-1
  x2=x+w-1 y2=y-1
 end

 x1=flr(x1/8) y1=flr(y1/8)
 x2=flr(x2/8) y2=flr(y2/8)

 local function matches(tx,ty)
  local tile=mget(tx,ty)
  return fget(tile,flag) and not (ignore_slopes and
      (fget(tile,6) or fget(tile,7)))
 end
 return matches(x1,y1) or matches(x1,y2)
     or matches(x2,y1) or matches(x2,y2)
end

--slope helper

-- Living players use a single support point and continuous tile-edge heights.
-- Keep the older helper below for pickups and enemy/death movement.
function resolve_player_slope(ply,old_x,old_foot,was_grounded)
    if ply.dy < 0 then return false end

    local foot_y=ply.y+ply.h
    local foot_x=ply.x+ply.w/2
    local tx=flr(foot_x/8)
    local travel=abs(ply.x-old_x)
    local snap=was_grounded and travel+1 or 0
    local first_row=flr((min(old_foot,foot_y)-snap)/8)-1
    local last_row=flr((max(old_foot,foot_y)+snap)/8)
    local best_surface=nil

    for ty=first_row,last_row do
        local tile=mget(tx,ty)
        local sy=nil
        if fget(tile,7) then
            sy=ty*8+8-(foot_x-tx*8)
        elseif fget(tile,6) then
            sy=ty*8+(foot_x-tx*8)
        end
        if sy then
            -- Catch a crossed surface, or follow nearby ground while walking.
            -- Looking one row above also catches the low tip after crossing a seam.
            local crossed=old_foot <= sy+travel and foot_y >= sy
            local follow=was_grounded and abs(old_foot-sy) <= snap+0.001
            if (crossed or follow) and
               (best_surface==nil or sy < best_surface) then
                best_surface=sy
            end
        end
    end

    if best_surface==nil then return false end
    -- Landing ends the 6-pixel jump hitbox; restore standing height without
    -- moving the feet into the slope on the following frame.
    ply.h=8
    ply.y=best_surface-ply.h
    ply.dy=0
    ply.on_slope=true
    ply.can_jump=true
    ply.falling=false
    ply.landed=true
    ply.jumping=false
    ply.jump=1.7
    return true
end

function get_slope_y_at(tx, ty, world_x)
    local tile = mget(tx, ty)
    local local_x = flr(world_x % 8)
    local tile_top = ty * 8

    -- flag 7 = \ style slope
    if fget(tile, 7) then
        return tile_top + (7 - local_x)
    end

    -- flag 6 = / style slope
    if fget(tile, 6) then
        return tile_top + local_x
    end

    return nil
end

function resolve_slope(obj)
    local foot_y = obj.y + obj.h

    local left_x  = obj.x + 3
    local right_x = obj.x + obj.w - 1

    local left_tx  = flr(left_x / 8)
    local right_tx = flr(right_x / 8)

    -- check current row AND row below
    local ty0 = flr((foot_y - 1) / 8)
    local ty1 = flr((foot_y + 1) / 8)

    local best_surface = nil

    local function try_surface(tx, ty, wx)
        local sy = get_slope_y_at(tx, ty, wx)
        if sy then
            if best_surface == nil or sy < best_surface then
                best_surface = sy
            end
        end
    end

    try_surface(left_tx,  ty0, left_x)
    try_surface(right_tx, ty0, right_x)
    try_surface(left_tx,  ty1, left_x)
    try_surface(right_tx, ty1, right_x)

    -- sticky snap tolerance:
    -- lets player stay glued over tiny seam gaps
    local snap_dist = max(2, ceil(abs(obj.dy)) + 1)

   if best_surface and obj.dy >= 0 and foot_y >= best_surface - snap_dist then
      if obj.is_player then 
        obj.can_jump = true
        obj.falling = false
        obj.landed = true
        obj.jumping = false
        end
         obj.on_slope = true
        obj.dy = 0
        obj.y = best_surface - obj.h + 1
       if obj.is_pup then obj.dx=0
       end
        return true
    end

    return false
end

--object to object collision

function hit (x,y,ox,oy,ow,oh)
  if (x>ox and x<ox+ow) and
     (y>oy and y<oy+oh) then
     --there has been a collision
     return true
     end
   
   return false
  
  end
