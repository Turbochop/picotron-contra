--[[pod_format="raw",created="2026-02-06 05:20:50",modified="2026-09-03 22:43:36",revision=1938]]
--[[pod_format="raw",created="2026-02-06 05:20:50",modified="2026-09-03 08:03:57",revision=1892]]
--[[pod_format="raw",created="2026-02-06 05:20:50",modified="2026-07-01 13:27:00",revision=1414]]
--game state
puptmr=50
pallette=12
paltimer=0



 function update_game()

  grav=.07 
  
  if spawn==0 then
 
  
   level_setup(level)
  spawn_players()
  
  end
  if spawn==1 then
  	 if level==3 then
  	for p in all(players) do
  	add_shadow(p.x,cam_y+88,p.player)
  	end
  end
  end
--  if not transfer then
  spawn+=1
--
--  end
 if spawn>=5 then 
 	spawn=5

 end 

 paltimer+=1

 if paltimer>220 then
 	paltimer=0
 end
 





--Player 2 drop in
for p in all (players) do
 if btnp(5,1) and not (multiplayer or bfight) then
if p.player==0 and not (p.dead or p.advancing) and (p.lives~=0 and p.respawn>=7) then
add_player_spawner(cam_x+20, cam_y, "player 2")
multiplayer=true
end
end
end


  --level scripts

  if level==1 then
   if cam_x>=20 and not toggle then
 add_new_spawner(-8,7,77*8,"right") 
 add_new_spawner(239,7,77*8,"left") 
 toggle=not toggle
 end
 end

 


   --level complete
 if complete==true then
 
  level_clear()

 
  
  end

if level_type=="3d" then
	threedee_mode_update()
end
  
  if clear >=200 and fanfare==false then
  music(level~=5 and 1 or 13)
  fanfare=true
  end
  for p in all(players) do
  if clear>=500 and (p.dx~=0 or stat(466)~=-1) then
  	clear=500
  end
  end
  

  if clear>=600  then 
  level_reset()
  timer=0
  if level~=5 then
  level+=1
  scene="card"
  else
  music(3)
  scene="end"
end
  
  end

 
  
  
if puptmr~=50 then
	puptmr+=1
end
 for e in all(effect) do
  e:update()
  
  end
 
  
  for e in all(enemy) do
   e:update()
   if complete then e.life=0
   end
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
   if complete then eb.life=0
   end
   end


for b in all(bullet) do

  b:update()
 if level_type=="3d" and perspective_3d then
perspective_3d:project(b)
 end

  	
if b.life<=0
or b.x>=cam_x+240
or b.x<=cam_x-20
or b.y>=cam_y+132
or b.y<=cam_y-10
or (
 (b.z or 0)>=57
 and not b.is_fire
 and not b.is_2nd_fire
)
then

 if not b.is_2nd_fire
 and not b.is_fire then
  add_new_shrap(b.x+4,b.y)
 end

 kill_bullet(b)
 del(bullet,b)

end
  for c in all(enemy) do
  
   if hit (b.x+3,b.y+3,c.x+1,c.y+2,c.w-2,c.h-2)and b.life~=0 and c.is_cap then
   c.owner=b.owner
   c.life-=1
  if not b.is_fire then 
  if not b.is_laser then
   b.life-=b.life
   end
  end
  
   end
  
  end

  for cn in all(enemy) do
  if hit (b.x+3,b.y+3,cn.x-2,cn.y,cn.w,cn.h) and b.life~=0 and cn.is_cannon then
   
   cn.life-=1

   b.life-=b.life

    if (b.is_fire and b.released==false) then
   		for p in all(players) do
   		local p = b.owner
   		p.refire=2
   		p.jam=true
   	end
   end
   if cn.life>1 then
    if puptmr==50 then
   sfx(258,4,8,2)
   sfx(258,5,10,6)
   end
   sfx(258,6,16,3)
   
   end
  
   end
   
   end 
 
   for en in all(enemy) do
   if en.life==1 then
  if hit (b.x+3,b.y+3,en.x,en.y-8,en.w-2,en.h+10) and (b.life~=0 or (b.is_fire 
  and b.released)) 
  and en.exposed --exposed is any enemy, that isn't a capsule or 
                --a shutter, that can be shot only when not hidden, IE ducked behind cover
                
  then
   
   en.life-=en.life
  
   if (b.is_fire and b.super) then
   if b.released then
   if not b.is_laser then
   b.life-=10
   end
   else

   	for p in all(players) do
   		local p = b.owner
   		p.refire=2
   		p.jam=true
   	end
   	del(bullet,b)
   end
   else
    if not b.is_laser then
   b.life-=b.life
   end
end
   
   end
   end
    
 
 
 end 
 
  for st in all(enemy) do
   
   if st.life>0 and st.sp==64
   and  hit (b.x+3,b.y+3,st.x+1,st.y+2,st.w-1,st.h-5) and b.life~=0 and st.is_shutter then
   st.owner=b.owner
   st.life-=1
   if not b.is_laser then
   b.life-=b.life
   end
   
 end
 end

 for t in all(enemy) do
  if hit (b.x+3,b.y+3,t.x+1,t.y+2,t.w-1,t.h-5) and b.life~=0 and t.is_turret and (t.opened and t.deployed) then
   
   t.life-=1

    
   b.life-=b.life

   if (b.is_fire and b.released==false) then
   		for p in all(players) do
   		local p = b.owner
   		p.refire=2
   		p.jam=true
   	end
   end
   if t.life>1 then
   if puptmr==50 then
   sfx(258,4,8,2)
   sfx(258,5,10,6)
   end
   sfx(258,6,16,3)
  
  
   end
  
   
   end
  
  end
  
  for bs in all(enemy) do
  if hit (b.x+3,b.y+3,bs.x+2,bs.y+2,bs.h-2,bs.w) and b.life~=0 and bs.is_boss then
   if bs.life>=1 then
   bs.life-=1
   end

   b.life-=b.life

    if (b.is_fire and b.released==false) then
   		for p in all(players) do
   		local p = b.owner
   		p.refire=2
   		p.jam=true
   	end
   end
   if bs.life>1 then
   if puptmr==50 then
   sfx(258,4,8,2)
   sfx(258,5,10,6)
   end
   sfx(258,6,16,3)
   
   
   
   
   end
  
  end
  
  end
  
end
  for pl in all (players) do

   local back= 0
   local front= 240
   local bottom= 130
   
  pl:update()
  resolve_slope(pl)

 
     if pl.x<cam_x+back then
    pl.x=cam_x+back
   
    end
    
if level_type=="top down" then
if pl.x+8>cam_x+front then
    pl.x=cam_x+front-8
   
    end
    if pl.y+12>cam_y+bottom then
    pl.y=cam_y+bottom-12
   
    end
    end
--boss spawners?

if level==1 then
  if pl.x>=193*8 and not pl.dead and bfight==false then
 
 bfight=true
 add_boss(212,11)
 add_new_cannon(211,8)
 end
 end
 
 if (level==5 and chunk==4) then
  if pl.x>=58*8 and not pl.dead and bfight==false then
 
 bfight=true
 add_boss(77,9)
 add_new_cannon(76,6)
 end
 end
  
  end
  
   if ((level==2 and cam_y<=30) or ((level==4 and chunk==2) and cam_y<=1) and #enemy==0) then
   if spawn==5 and not complete then
   music(-1,1000)
   complete=true
   end
   cam_y-=.7
--  print("Good Work!",cam_x+60,cam_y+50,6)
  end
  
  -- 3d mode setup

if level_type=="3d" then

enemycount=0

for e in all(enemy) do
	if not e.is_shutter then
		enemycount+=1
	end
end
if spawn==4 then
	
if not phase_complete  then
	local wall = (phase==5) and 30 or 10
	wallexplosions=wall

	end
threedee_perspective_helper(11,2)
  add_wall_destroy(11,5)
  end
  
	if enemycount==0 and spawn==5 and not gameover then 
	if not phase_complete then
	
	if global_timer%8==2 then
	add_new_exp_spawner(cam_x+100+flr(rnd(20)),cam_y+48,3,2)
	wallexplosions-=1
	end

if wallexplosions<=0  then

if phase~=5 then
sfx(263,11)
else
music(127)
end

	phase_complete=true
	
	
		if phase==5 then complete=true
		end
		end
	end
	end

if wallexplosions==0 and delay_timer<delay_timer_max then
	delay_timer+=1
end
	
end

if not transfer then

if scrolling=="both" then
    update_camera_horizontal()
    update_camera_vertical()
elseif scrolling=="horizontal" then
    update_camera_horizontal()
elseif scrolling=="vertical" then
    update_camera_vertical()
end

update_camera_autoscroll()

clamp_topdown_camera_blocked_players()
camera(cam_x,flr(cam_y))
 end

-- if level~=0 then
update_spawn_stream()
--end
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
 reset_camera_state()
 toggle=false
 scene="gameover"
 music(2)
 end
 


end



function clamp_topdown_camera_blocked_players()
 if level_type ~= "top down" then
  return
 end

 if topdown_camera_y_blocked then
  local front_y = cam_y + get_vertical_front()
  for p in all(get_active_players()) do
   if is_vertical_scroll_up() then
    if p.y < front_y then
     p.y = p.y+1
    end
   elseif p.y > front_y then
    p.y = p.y+1
   end
  end
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
 camera(cam_x,cam_y)

 cls(0)


-- draw cached layer 3 first if it's a background
map()
-- draw active layer 1 gameplay map
--if level~=0 then
draw_cached_layer(visual_layer_1)
--end

if ((level==3 and phase==1) or (level_type=="3d")) and not bfight then
palt(30,true)
palt(0,false)
local offset= (phase_complete) and 1 or 0
	spr((247+offset)+screen)
end
palt()
palt(30,true)
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
  palt(30,true)
  pal()
   o:draw()
  end
  
  if level==2 and cam_y<=30 and spawn==5 then
--  print("There is no boss here yet...",cam_x+60,cam_y+40,6)
  print("Good Work!",cam_x+60,cam_y+50,6)
  end

  palt(30,true)
  for b in all(bullet) do
  
   b:draw()
  end

  for e in all(effect) do
  pal()
  palt(30,true)
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
  pal()
  palt(30,true)
   p:draw()
  end

  for e in all(effect) do
   e:draw()
  end
  
 

  for pl in all(players) do
   

--]]

   pl:draw()
   
  end
 end


 rectfill(0+cam_x,128+cam_y,240+cam_x,136+cam_y,0)

 if ((g_otimer>1.9 and gameover) or (clear>=585)) then
  rectfill(0+cam_x,0+cam_y,240+cam_x,136+cam_y,0)
 end
-- rect(x1r,x2r,y1r,y2r,7)
--print(screen,cam_x+70,cam_y+120,7)
--print(#ebullet,cam_x+90,cam_y+100,7)
end
