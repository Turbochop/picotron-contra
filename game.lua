--[[pod_format="raw",created="2026-02-06 05:20:50",modified="2026-04-30 22:04:34",revision=1282]]
--game state
puptmr=50
pallette=12
paltimer=0



 function update_game()
 grav=(level_type=="top down") and 0 or .07 


   spawn+=1
 if spawn>=5 then 
 	spawn=5
 
 end 

 paltimer+=1

 if paltimer>220 then
 	paltimer=0
 end
 
 --Debug stuff
--[[ 
 if mouse_b>0 then
 m_timer+=1
 if m_timer>=2 then
 	m_timer=2
 end
 else m_timer=0
 end
-- if mouse_b==3 then
-- if #players>0 then
-- 	effects={}
-- 	multiplayer=false
-- 	end
-- end
 if mouse_b==1 and m_timer==1 then
-- music(13)
--if #players==0 then
-- 	create_player(mx,my,0) 
-- 	m_timer=2
-- 	elseif #players==1 then
-- 	create_player(mx,my,1)
--multiplayer=true
-- end
--add_bridge_destroy(mx*8,my*8)
-- add_new_exp_spawner(mx,my,2,2,"instant")
end
--if mouse_b==2 and m_timer==1 then
--add_new_exp_spawner(mx,my,700)
--end
--]]

for p in all(players) do

--Player 2 drop in

 if btnp(5,1) and not (multiplayer or bfight) then
if p.player==0 and not p.dead and p.lives~=0 then
add_player_spawner(cam_x+20, cam_y, "player 2")
multiplayer=true
end
end
end


  --level scripts
  ---[[
   if cam_x>=20 and not toggle then
 add_new_spawner(-8,7,77*8,"right") 
 add_new_spawner(239,7,77*8,"left") 
 toggle=not toggle
 end
 --]] 
  
   if bfight then 
 cam_x+=.5
 map_end=217*8
 end
 



 
 if spawn==1 then
 map_helper(0,80,220)
 spawn_scan_x = -1
--create_player(cam_x+50,cam_y+20,0)
 add_player_spawner(cam_x, cam_y, "player 1")
 add_bridge_destroy(46*8,7*8)
 add_bridge_destroy(67*8,7*8)

 if multiplayer then
  add_player_spawner(cam_x+20, cam_y, "player 2")
 end

 add_new_cap_spawner(32,3,spread)
 add_new_cap_spawner(59,4,rapid)
 add_new_cap_spawner(100,9,rapid)
 add_new_cap_spawner(166,4,mgun)
end

   --level complete
 if complete==true then
  level_clear()
  clear+=.1
  
  end


  
  if clear >=20 and fanfare==false then
  music(1)
  fanfare=true
  end
  for p in all(players) do
  if clear>=50 and p.dx~=0 then
  	clear=50
  end
  end
  
  if clear>=60 then 
  cam_x_min=0
  cam_x=0
  cam_y=0
  timer=0
  scene="end"
  music(3)
  
  end

 
  
  
if puptmr~=50 then
	puptmr+=1
end
 for e in all(effect) do
  e:update()
  
  end
 
  
  for e in all(enemy) do
   e:update()
   if e.is_runner then
   local snapped_to_slope = resolve_slope(e)

-- tiny coyote-style slope glue:
-- if we were on a slope last frame and didn't quite catch this frame,
-- don't immediately declare the obj airborne from a 1-pixel seam
if not snapped_to_slope and was_on_slope and e.dy >= 0 then
    local old_y = e.y
    e.y += 2
    snapped_to_slope = resolve_slope(e)
    if not snapped_to_slope then
       e.y = old_y
    end
end  
    end
   end
 
  for eb in all(ebullet) do
   eb:update()
   end


for b in all(bullet) do
  b:update()
  --for pl in all(players) do
  	
  	 if b.life<=0 
 or b.x>=cam_x+240 
 or b.x<=cam_x-20 
 or b.y>=cam_y+132 
 or b.y<=cam_y-20 then
if not b.is_2nd_fire and not b.is_fire then
 add_new_shrap(b.x+4,b.y)
end
 kill_bullet(b)
    del(bullet,b)

 -- end
  end
  for c in all(enemy) do
  
   if hit (b.x+3,b.y+3,c.x+1,c.y+2,c.w-2,c.h-2)and b.life~=0 and c.is_cap then
   c.life-=1
   b.life-=b.life
   c.owner=b.owner
   end
  
  end

  for cn in all(enemy) do
  if hit (b.x+3,b.y+3,cn.x-2,cn.y,cn.w,cn.h) and b.life~=0 and cn.is_cannon then
   
   cn.life-=1
   b.life-=102
   if cn.life>1 then sfx(258,4,8,2)
   sfx(258,5,10,8)
   
   end
  
   end
   
   end 
 
   for en in all(enemy) do
   if en.life==1 then
  if hit (b.x+3,b.y+3,en.x,en.y-8,en.w-2,en.h+10) and b.life~=0 and en.is_runner then
   
   en.life-=1
   b.life-=b.life
  
   
   end
   end
    
 
 
 end 
 
  for st in all(enemy) do
   
   if st.life>0 and st.sp==106
   and  hit (b.x+3,b.y+3,st.x+1,st.y+2,st.w-1,st.h-5) and b.life~=0 and st.is_shutter then
   
   st.life-=1
   b.life-=b.life
   st.owner=b.owner
 end
 end

 for t in all(enemy) do
  if hit (b.x+3,b.y+3,t.x+1,t.y+2,t.w-1,t.h-5) and b.life~=0 and t.is_turret then
   
   t.life-=1
   b.life-=b.life
   if t.life>1 then sfx(258,4,8,2)
   sfx(258,5,10,8)
  
  
   end
  
   
   end
  
  end
  
  for bs in all(enemy) do
  if hit (b.x+3,b.y+3,bs.x+2,bs.y+2,bs.h-2,bs.w) and b.life~=0 and bs.is_boss then
   
   bs.life-=1
   b.life-=b.life
   if bs.life>1 then sfx(258,4,8,2)
   sfx(258,5,10,8)
   
   
   end
  
  end
  
  end
  
end
  for pl in all (players) do

   local back= 0
  pl:update()
  resolve_slope(pl)

 
     if pl.x<cam_x+back then
    pl.x=cam_x+back
   
    end
    



  if pl.x>=193*8 and bfight==false then
 
 bfight=true
 add_boss(212,11)
 add_new_cannon(211,8)
 end
  
  end
if scrolling=="both" then
update_camera_horizontal()
update_camera_vertical()
elseif scrolling == "horizontal" then
    update_camera_horizontal()
elseif scrolling == "vertical" then
    update_camera_vertical()
end

 camera(cam_x,cam_y)
update_spawn_stream()
for p in all(pup) do
  p:update()
   resolve_slope(p)
  end
   --Gameover is true by default. Players hold it false while one remains alive.
  
  
  gameover=true
for p in all(players) do
if not p.gameover then
    gameover = false
    break
  end
  end
 
 --  Are all lives gone?

if gameover then

 g_otimer+=.01
else g_otimer=0
end

 


 if g_otimer>=2 and gameover then 

 spawn=0

 g_otimer=0
 timer1=0
 cam_x_min=0
 cam_x=0
 cam_y=0
 toggle=false
 scene="gameover"
 music(2)
 end
 


end



function get_split_focus_x()
    local lead, trail = get_lead_and_trail(get_active_players(), "x")

    if not lead then
        return cam_x + 110
    end

    if lead == trail then
        return lead.x
    end

    local sep = max(0, lead.x - trail.x)
    local t = mid(0, sep / 80, 1)

    -- 1.0 = pure lead, 0.72 = max split-focus
    local bias = 1.0 - (0.28 * t)

    return trail.x * (1 - bias) + lead.x * bias
end



function get_sort_y(o)
    if o.sort_y then
        return o.sort_y
    end

    -- default: use feet if width/height style object
    return (o.y or 0) + (o.h or 0)
end

function sort_drawables_by_y(t)
    for i=2,#t do
        local item = t[i]
        local key = get_sort_y(item)
        local j = i - 1

        while j >= 1 and get_sort_y(t[j]) > key do
            t[j+1] = t[j]
            j -= 1
        end

        t[j+1] = item
    end
end



function draw_game()
 cls(0)
cls(0)

-- draw cached layer 3 first if it's a background
map()
-- draw active layer 1 gameplay map
draw_cached_layer(visual_layer_1)
--print(cam_y,cam_x,cam_y,7)
--print(map_end_y,cam_x,cam_y+16,7)


 for eb in all(ebullet) do
  eb:draw()
 end

 if level_type == "top down" then
  local drawlist = {}

  for e in all(enemy) do
   add(drawlist, e)
  end

  for p in all(pup) do
   add(drawlist, p)
  end

  for pl in all(players) do
   add(drawlist, pl)
  end

  sort_drawables_by_y(drawlist)

  for o in all(drawlist) do
   o:draw()
  end

  palt(30,true)
  for b in all(bullet) do
   b:draw()
  end

  for e in all(effect) do
   e:draw()
  end

 else
  for e in all(enemy) do
   e:draw()
  end

  palt(30,true)
  for b in all(bullet) do
   b:draw()
  end

  for p in all(pup) do
   p:draw()
  end

  for e in all(effect) do
   e:draw()
  end

  for pl in all(players) do
   pl:draw()
  end
 end

 rectfill(0+cam_x,128+cam_y,240+cam_x,136+cam_y,0)
 if g_otimer>1.9 and gameover then
  rectfill(0+cam_x,0+cam_y,240+cam_x,136+cam_y,0)
 end
end


 
 
