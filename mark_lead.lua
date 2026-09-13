--[[pod_format="raw",created="2026-09-04 04:17:40",modified="2026-09-04 04:17:40",revision=0]]
-- Marksman target-leading module
--
-- Predicts where a constant-speed projectile can intercept a moving target.
-- The target is expected to expose x, y, dx, dy, and prone fields.

function mark_lead_point(_sx,_sy,_target,_speed,_strength,_max_time)
	local speed=_speed or 1
	local strength=_strength or 1
	local max_time=_max_time or 60

	-- Aim near the player's upper body. Lower the point while prone.
	local tx=_target.x+4
	local ty=_target.y+(_target.prone and 6 or 4)
	local vx=_target.dx or 0
	local vy=_target.dy or 0

	if speed<=0 then
		return tx,ty,0
	end

	local rx=tx-_sx
	local ry=ty-_sy

	-- Solve:
	-- |target_position + target_velocity*t - shooter_position|
	--     = projectile_speed*t
	local a=vx*vx+vy*vy-speed*speed
	local b=2*(rx*vx+ry*vy)
	local c=rx*rx+ry*ry
	local intercept_time=nil

	if abs(a)<.0001 then
		-- The quadratic has become effectively linear.
		if abs(b)>.0001 then
			local t=-c/b

			if t>0 then
				intercept_time=t
			end
		end
	else
		local discriminant=b*b-4*a*c

		if discriminant>=0 then
			local root=sqrt(discriminant)
			local t1=(-b-root)/(2*a)
			local t2=(-b+root)/(2*a)

			if t1>0 and t2>0 then
				intercept_time=min(t1,t2)
			elseif t1>0 then
				intercept_time=t1
			elseif t2>0 then
				intercept_time=t2
			end
		end
	end

	-- If no exact interception exists, use the direct travel time as a
	-- conservative fallback. The horizon below keeps the guess reasonable.
	if intercept_time==nil then
		intercept_time=sqrt(c)/speed
	end

	intercept_time=max(0,min(intercept_time,max_time))

	local lead_x=tx+vx*intercept_time*strength
	local lead_y=ty+vy*intercept_time*strength

	return lead_x,lead_y,intercept_time
end