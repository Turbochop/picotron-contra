--[[pod_format="raw",created="2026-04-11 17:24:57",modified="2026-05-29 13:07:57",revision=46]]
--[[pod_format="raw",created="2026-04-11 17:24:57",modified="2026-04-24 01:35:05",revision=45]]
-- =========================
-- CAMERA UPDATE
-- ========================= 
function update_camera_horizontal()

local base_front = 110
solo_front_x = solo_front_x or base_front
last_active_count_x = last_active_count_x or 0
local active = get_active_players()
local active_count = #active

-- if co-op collapses to solo, inherit the survivor's current screen position
if last_active_count_x >= 2 and active_count == 1 then
    local survivor = active[1]
    solo_front_x = max(base_front, survivor.x - cam_x)
end

if active_count >= 2 then
    local lead, trail = get_lead_and_trail(active, "x")

    local sep = max(0, lead.x - trail.x)
    local threshold = 24
    local t = mid(0, (sep - threshold) / 80, 1)

    -- 1.0 = pure lead, 0.72 = max split
    local bias = 1.0 - (0.28 * t)

    local focus_x = trail.x * (1 - bias) + lead.x * bias
    local desired_cam_x = focus_x - base_front

    if not halt and desired_cam_x > cam_x then
        cam_x = desired_cam_x
    end

    -- reset solo scroll line while co-op is active
    solo_front_x = base_front

elseif active_count == 1 then
    local p = active[1]

    -- only scroll when the survivor pushes into the inherited scroll line
    if not halt and p.x > cam_x + solo_front_x then
        cam_x = p.x - solo_front_x
    end

    -- if the player walks back toward center, relax solo_front back toward 110
    local current_screen_x = p.x - cam_x
    solo_front_x = max(base_front, current_screen_x)
end

last_active_count_x = active_count
-- ratchet scrolling
 
 if cam_x>cam_x_min then
 	cam_x_min=cam_x
 end
 -- right edge clamp
if cam_x > map_end_x - 240 then
    cam_x = map_end_x - 240

end

end

function update_camera_vertical()
if keyp("1") then
	map_end_y+=1
end
    local base_front = 72
    solo_front_y = solo_front_y or base_front
    last_active_count_y = last_active_count_y or 0
    local active = get_active_players()
    local active_count = #active

    -- if co-op collapses to solo, inherit the survivor's current screen position
    if last_active_count_y >= 2 and active_count == 1 then
        local survivor = active[1]
        solo_front_y = max(base_front, survivor.y - cam_y)
    end

    if active_count >= 2 then
        local lead, trail = get_lead_and_trail(active, "y")

        local sep = max(0, lead.y - trail.y)
        local threshold = 24
        local t = mid(0, (sep - threshold) / 50, 1)

        -- 1.0 = pure lead, 0.72 = max split
        local bias = 1.0 - (0.28 * t)

        local focus_y = trail.y * (1 - bias) + lead.y * bias
        local desired_cam_y = focus_y - base_front

        if not halt and desired_cam_y > cam_y then
            cam_y = desired_cam_y
        end

        -- reset solo scroll line while co-op is active
        solo_front_y = base_front

    elseif active_count == 1 then
        local p = active[1]

        -- scroll when the player moves below the front line
        if not halt and p.y > cam_y + solo_front_y then
            cam_y = p.y - solo_front_y
        end

        -- preserve current on-screen position, but never less than base_front
        local current_screen_y = p.y - cam_y
        solo_front_y = max(base_front, current_screen_y)
    end

    last_active_count_y = active_count

    -- ratchet scrolling: for downward movement, cam_y becoming larger means progress
    if cam_y > cam_y_min then
        cam_y_min = cam_y
    end

    local bottom_limit = max(0, map_end_y - 128)

    -- bottom edge clamp
    if cam_y > bottom_limit then
        cam_y = bottom_limit
   end
end

function get_active_players()
    local active = {}
    for p in all(players) do
        if not p.dead and not p.gameover and p.health > 0 then
            add(active, p)
        end
    end
    return active
end

function get_lead_and_trail(active, axis)
    active = active or get_active_players()
    axis = axis or ((scrolling == "horizontal") and "x" or "y")

    if #active == 0 then
        return nil, nil
    end

    if #active == 1 then
        return active[1], active[1]
    end

    local p1 = active[1]
    local p2 = active[2]

    if axis == "x" then
        -- bigger x is leading
        if p1.x >= p2.x then
            return p1, p2
        else
            return p2, p1
        end
    else
        -- downward scrolling: bigger y is leading
        if p1.y >= p2.y then
            return p1, p2
        else
            return p2, p1
        end
    end
end
