--[[pod_format="raw",created="2026-02-19 10:55:12",modified="2026-04-11 15:50:02",revision=377]]
--collision
--map collision


function collide_map(obj,mov,flag)
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

 return fget(mget(x1,y1),flag)
     or fget(mget(x1,y2),flag)
     or fget(mget(x2,y1),flag)
     or fget(mget(x2,y2),flag)
end

--slope helper

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