--[[pod_format="raw",created="2026-04-11 17:24:57",modified="2026-07-01 14:21:10",revision=72]]
--[[pod_format="raw",created="2026-04-11 17:24:57",modified="2026-06-26 08:42:02",revision=70]]
--[[pod_format="raw",created="2026-04-11 17:24:57",modified="2026-04-24 01:35:05",revision=45]]
-- =========================
-- CAMERA UPDATE
-- ========================= 
function reset_camera_state()
    cam_x=0
    cam_y=0
    cam_dx=0
    cam_dy=0
    cam_x_min=0
    cam_y_min=0
    solo_front_x=110
    solo_front_y=72
    last_active_count_x=0
    last_active_count_y=0
    topdown_camera_x_blocked=false
    topdown_camera_y_blocked=false
end

function is_vertical_scroll_up()
    return scroll_dir == "up"
end

function get_vertical_front()
    return is_vertical_scroll_up() and 65 or 72
end

function get_topdown_bottom_push_y(_cam_y)
    return _cam_y + 118
end

function get_topdown_left_push_x(_cam_x)
    return _cam_x
end

function player_camera_push_hits_wall(p, target_y)
    local step = target_y < p.y and -1 or 1
    local mov = step < 0 and "up" or "down"
    local y = p.y

    while (step < 0 and y > target_y) or (step > 0 and y < target_y) do
        y += step
        if (step < 0 and y < target_y) or (step > 0 and y > target_y) then
            y = target_y
        end

        local probe = {x=p.x,y=y,w=p.w,h=p.h}
        if collide_map(probe,mov,0) then
            return true
        end
    end

    return false
end

function player_camera_push_x_hits_wall(p, target_x)
    local step = target_x < p.x and -1 or 1
    local mov = step < 0 and "left" or "right"
    local x = p.x

    while (step < 0 and x > target_x) or (step > 0 and x < target_x) do
        x += step
        if (step < 0 and x < target_x) or (step > 0 and x > target_x) then
            x = target_x
        end

        local probe = {x=x,y=p.y,w=p.w,h=p.h}
        if collide_map(probe,mov,0) then
            return true
        end
    end

    return false
end

function topdown_camera_x_push_blocked(old_cam_x, next_cam_x)
    if level_type ~= "top down" or old_cam_x == next_cam_x then
        return false
    end

    local active = get_active_players()
    if #active < 2 then
        return false
    end

    if next_cam_x > old_cam_x then
        local left_push_x = get_topdown_left_push_x(next_cam_x)
        for p in all(active) do
            if p.x < left_push_x and player_camera_push_x_hits_wall(p, left_push_x) then
                return true
            end
        end
    end

    return false
end

function topdown_camera_y_push_blocked(old_cam_y, next_cam_y)
    if level_type ~= "top down" or old_cam_y == next_cam_y then
        return false
    end

    local active = get_active_players()
    if #active < 2 then
        return false
    end

    if next_cam_y < old_cam_y then
        local bottom_push_y = get_topdown_bottom_push_y(next_cam_y)
        for p in all(active) do
            if p.y > bottom_push_y and player_camera_push_hits_wall(p, bottom_push_y) then
                return true
            end
        end
    end

    return false
end

function set_camera_for_map_start()
    if scrolling == "vertical" or scrolling == "both" then
        local bottom_limit = max(0, map_end_y - 128)
        cam_y = is_vertical_scroll_up() and bottom_limit or 0
        cam_y_min = cam_y
        solo_front_y = get_vertical_front()
    end
end

function update_camera_horizontal()

local old_cam_x = cam_x
topdown_camera_x_blocked=false
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

local right_limit = max(0, map_end_x - 240)
cam_x = mid(0, cam_x, right_limit)

if topdown_camera_x_push_blocked(old_cam_x, cam_x) then
    cam_x = old_cam_x
    topdown_camera_x_blocked=true
end

-- ratchet scrolling
if cam_x>cam_x_min then
    cam_x_min=cam_x
end

end

function update_camera_vertical()
    local old_cam_y = cam_y
    topdown_camera_y_blocked=false
    local base_front = get_vertical_front()
    local scroll_up = is_vertical_scroll_up()
    solo_front_y = solo_front_y or base_front
    last_active_count_y = last_active_count_y or 0
    local active = get_active_players()
    local active_count = #active

    -- if co-op collapses to solo, inherit the survivor's current screen position
    if last_active_count_y >= 2 and active_count == 1 then
        local survivor = active[1]
        local survivor_screen_y = survivor.y - cam_y
        if scroll_up then
            solo_front_y = min(base_front, survivor_screen_y)
        else
            solo_front_y = max(base_front, survivor_screen_y)
        end
    end

    if active_count >= 2 then
        local lead, trail = get_lead_and_trail(active, "y")

        local sep = scroll_up and max(0, trail.y - lead.y) or max(0, lead.y - trail.y)
        local threshold = 24
        local t = mid(0, (sep - threshold) / 50, 1)

        -- 1.0 = pure lead, 0.72 = max split
        local bias = 1.0 - (0.28 * t)

        local focus_y = trail.y * (1 - bias) + lead.y * bias
        local desired_cam_y = focus_y - base_front

        if not halt and ((scroll_up and desired_cam_y < cam_y) or (not scroll_up and desired_cam_y > cam_y)) then
            cam_y = desired_cam_y
        end

        -- reset solo scroll line while co-op is active
        solo_front_y = base_front

    elseif active_count == 1 then
        local p = active[1]

        -- scroll when the player pushes into the front line
        if not halt and ((scroll_up and p.y < cam_y + solo_front_y) or (not scroll_up and p.y > cam_y + solo_front_y)) then
            cam_y = p.y - solo_front_y
        end

        -- preserve current on-screen position, then relax back toward the base front line
        local current_screen_y = p.y - cam_y
        if scroll_up then
            solo_front_y = min(base_front, current_screen_y)
        else
            solo_front_y = max(base_front, current_screen_y)
        end
    end

    last_active_count_y = active_count

    local bottom_limit = max(0, map_end_y - 128)
    cam_y = mid(0, cam_y, bottom_limit)

    if topdown_camera_y_push_blocked(old_cam_y, cam_y) then
        cam_y = old_cam_y
        topdown_camera_y_blocked=true
    end

    -- ratchet scrolling: vertical progress can move either up or down the map
    if scroll_up and cam_y < cam_y_min then
        cam_y_min = cam_y
    elseif not scroll_up and cam_y > cam_y_min then
        cam_y_min = cam_y
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
        -- vertical leading depends on scroll direction
        if (is_vertical_scroll_up() and p1.y <= p2.y) or (not is_vertical_scroll_up() and p1.y >= p2.y) then
            return p1, p2
        else
            return p2, p1
        end
    end
end
