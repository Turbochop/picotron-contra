--[[pod_format="raw",created="2026-08-15 04:05:02",modified="2026-08-30 01:02:03",revision=271]]
-- 3d mode player update code
perspective_3d=nil

function threedee_perspective_helper()

 local helper={
  -- trapezoid geometry
  cx=120,

  top_y=52,
  bottom_y=88,

  top_width=50,
  bottom_width=130,
  player_pull=.015, --Players have additional x influence when advancing
                    -- bullet depth range
  spread_outer_bias=1, -- Weapons that spread have their 
                         --outer most shots influenced more
  near_z=0,
  far_z=50,

  projection_values=function(self,z)

 local depth=mid(
  0,
  (z-self.near_z)/(self.far_z-self.near_z),
  1
 )

 local width=
  self.bottom_width+
  (self.top_width-self.bottom_width)*depth

 local scale=width/self.bottom_width

 local ground_y=
  self.bottom_y+
  (self.top_y-self.bottom_y)*depth

 return depth,scale,ground_y

end,

world_x_from_screen=function(self,screen_x,z)

 local depth,scale,ground_y=
  self:projection_values(z)

 return self.cx+
  (screen_x-self.cx)/scale

end,

project_point=function(self,world_x,world_y,z)

 local depth,scale,ground_y=
  self:projection_values(z)

 local screen_x=
  self.cx+
  (world_x-self.cx)*scale

 local screen_y=
  ground_y-
  (world_y or 0)*scale

 return screen_x,screen_y

end,

world_y_from_screen=function(self,screen_y,z)

 local depth,scale,ground_y=
  self:projection_values(z)

 return (ground_y-screen_y)/scale

end,

z_from_ground_y=function(self,screen_y)

 local depth=mid(
  0,
  (self.bottom_y-screen_y)/
   (self.bottom_y-self.top_y),
  1
 )

 return self.near_z+
  (self.far_z-self.near_z)*depth

end,

project=function(self,b)

 b.x,b.y=self:project_point(
  b.world_x,
  b.world_y,
  b.z
 )

end,

  update=function(self)
  if bfight then 
  del(effect,perspective_3d)
  perspective_3d=nil
  del(effect,self)
  
  end
  end,

  draw=function(self)
--[[
   local tl=self.cx-self.top_width/2
   local tr=self.cx+self.top_width/2
   local bl=self.cx-self.bottom_width/2
   local br=self.cx+self.bottom_width/2

   line(tl,self.top_y,tr,self.top_y,8)
   line(bl,self.bottom_y,br,self.bottom_y,8)
   line(tl,self.top_y,bl,self.bottom_y,8)
   line(tr,self.top_y,br,self.bottom_y,8)
--]]
  end
 }

 perspective_3d=helper
 add(effect,helper)

end


function threedee_mode_update()
--if #enemy==0 then phase_complete = true
--end

 if clear >=200 and fanfare==false then
  music(1)
  fanfare=true
  end
  for p in all(players) do
  if clear>=500 and p.dx~=0 then
  	clear=500
  end
  end

if phase_complete then

for e in all (enemy) do
if not e.is_shutter then
	e.life=0
	end
end

for eb in all (ebullet) do
	eb.life=0
end
end


		for p in all(players) do

		if ((btn(2,p.player) and p.landed) or p.gameover)  then
			p.advready=true
		else
			p.advready=false
		end
		end


	local canadvance=false
if multiplayer then
      local p1ready=false
		local p2ready=false

		for p in all(players) do
		if  (phase_complete and delay_timer==delay_timer_max
			and not complete) then

			if p.player==0 then
			p1ready=p.advready
			elseif p.player==1 then
				p2ready=p.advready
			end

		end
      end
		bothready=p1ready and p2ready
		canadvance=(phase_complete) and bothready or false

	else

--		single player only needs themselves ready
		for p in all(players) do
			if p.advready and (phase_complete and delay_timer==delay_timer_max
			and not complete and not p.dead)
			
			 then
				canadvance=true
			end
		end

	end



	if canadvance then

		for p in all(players) do

			if not p.advancing then
			p.advsavex=p.x
p.advsavey=p.y

-- Center-bottom of the 8x16 advancing sprite.
local anchor_x=p.x+4
local anchor_y=p.y+8

p.adv_z=
 perspective_3d:z_from_ground_y(
  anchor_y
 )

p.adv_world_x=
 perspective_3d:world_x_from_screen(
  anchor_x,
  p.adv_z
 )

p.adv_world_y=
 perspective_3d:world_y_from_screen(
  anchor_y,
  p.adv_z
 )

p.advancing=true
			end

		end

	end




	local someone_advancing=false
	local all_finished=true

	for p in all(players) do

		if p.advancing then

			someone_advancing=true

			if p.advstep<5 then
				all_finished=false
			end

		end

	end


	

	if someone_advancing and all_finished then

	
		for p in all(players) do

			if p.advancing then
		      p.advframe=2
				p.x=p.advsavex
            p.y=p.advsavey
				p.advancing=false
				p.advready=false
				p.advstep=0
				
			end

		end

	   pup={}
	   enemy={}
		screen+=1
      

	

		if screen>=4 then

			--save / launch all players
			for p in all(players) do
            p.bullets=0
				p.dy-=p.jump
				p.jumping=true
				p.landed=false
				p.can_prone=false
          delay_timer=1-spawn
--				save_player_state(p)

			end

			--global state
			bullet={}
			for s in all(effect)do
				if s.is_shadow then
				del(effect,s)
				end
			end
--			effect={}
--			players={}
			spawn=0
			phase+=1
			
			screen=1

		end

	end



	if phase==5 and not bfight and not complete then
		music(22,0,0xf)
		bfight=true
	end







end





--3d mode player drawing logic

function player_3d_draw(_ply)
	local ply=_ply

	

 local xframe={16,24,32,40,48,56,64,72}
 local player_sheet=1

 local offset=
  level_type=="top down"
  and 40
  or 16
  
	local offset= (level_type=="3d") and 4 or 0
	local dipy = (ply.firing and ply.recoil<5) and 7 or 8
	local playerside1= (ply.player==0) and 24 or 32
  local playerside2= (ply.player==0) and 32 or 24
 --3d body sprite source x
 local threedeesp=16

 if level_type=="3d" and ply.aim==0 then
  offset= ply.prone and 112 or 104

  if ply.running then
 
   threedeesp=
    ply.flp0==false
    and playerside1
    or playerside2
  end
 
 end
 

  -- player dead graphics
  
  if ply.dead then

    sspr(
     player_sheet,
     xframe[ply.td_death_frame],
    (level_type=="top down") and 88 or 120,
   (level_type=="top down") and 8 or 16,16,
     ply.x-offset,ply.y-3,
     (level_type=="top down") and 8 or 16,16,
    ply.player==0 and true or false,ply.inv0
    )
end

-- all active player states besides "dead" fall under blinking code

	if ply.blink==0 then
	if not ply.advancing then
	--player jumping
	
	if ply.jumping then
		sspr(
    player_sheet,
    xframe[flr(ply.sp1)],
    24,
    8,8,
    ply.x,ply.y,
    8,8,
    ply.flp1,ply.inv1
   )
	end
	
	 --player idle state
 
  if not (ply.running or ply.jumping) and not (ply.prone or ply.dead) then

-- legs
   sspr(
    player_sheet,
    16,112,
    8,8,
    ply.x,ply.y,
    8,8,ply.flp0,ply.inv0
   )
   
   --body

 sspr(
    player_sheet,
    16,
    104,
    8,8,
    ply.x,ply.y-dipy,
    8,8,ply.flp1
)
  end
  
	
	-- player prone state
  if (ply.prone and not ply.dead) then
  
  	
  	sspr(
      player_sheet,
      24,112,
      16,8,
      ply.x-4,ply.y+9-dipy,
      16,8,ply.player==1 and true or false
     )
    
     end

-- running states

--regular running (not firing)

   if (ply.running
   and not ply.firing and not ply.jumping) then
    --legs
     sspr(
     player_sheet,
     xframe[flr(ply.sp1)],
     32,
     8,8,
     ply.x,ply.y,
     8,8,
     ply.flp1,ply.inv1
    )
    
    
    --body
    
    sspr(
     player_sheet,
     xframe[flr(ply.aim+1)],16,
     8,8,
     ply.x,ply.y-8,
     8,8,
     ply.flp0,ply.inv0
    )

end

--running and firing

 if (ply.running
   and ply.firing and not ply.jumping and not ply.aiming) then
  
  --legs
  
  
  sspr(
     player_sheet,
     xframe[flr(ply.sp1)],
     32,
     8,8,
     ply.x,ply.y,
     8,8,
     ply.flp1,ply.inv1
    )
  
  
  
   --body
   
   sspr(
      player_sheet,
      threedeesp,104,
      8,8,
      ply.x,ply.y-dipy,
      8,8,ply.player==1 and true or false
     )	
   
   
   end

--body is aiming and running
  
  if  (ply.running and ply.aiming) then
  
    sspr(
     player_sheet,
     xframe[flr(ply.sp1)],
     32,
     8,8,
     ply.x,ply.y,
     8,8,
     ply.flp1,ply.inv1
    )

	 sspr(
     player_sheet,
     xframe[5],16,
     8,8,
     ply.x,ply.y-dipy,
     8,8,
     ply.flp0,ply.inv0
    )
  
  end
  end
  if ply.advancing then
 sspr(
      player_sheet,
      xframe[flr(ply.advframe)],136,
      8,16,
      ply.x,ply.y-8,
      8,16,ply.player==1 and true or false
     
     )


  end
end
	
end