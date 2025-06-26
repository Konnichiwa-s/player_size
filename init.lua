size_editer = {}
size_editer.priv = "size_edit"

size_editer.default_props = {
    visual_size = {x = 1, y = 1},
    collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
    eye_height = 1.47
}

minetest.register_privilege(size_editer.priv, {
    description = "Allows player to change their size",
    give_to_singleplayer = true
})

local function has_privilege(name)
    return minetest.check_player_privs(name, {[size_editer.priv] = true})
end

function size_editer.set_player_size(name, size)
    local player = minetest.get_player_by_name(name)
    if not player then return end

    
    size = math.max(0.05, math.min(size, 20))

    local meta = player:get_meta()
    meta:set_float("player_size", size)

    
    local height = 1.7 * size
    local eye_height = size_editer.default_props.eye_height * size
    local step_height = 0.6 * size
    
    
    local half_width = 0.3 * size
    local collbox = {
        -half_width,  -- x1
        0.0,          -- y1 (bottom)
        -half_width,   -- z1
        half_width,    -- x2
        height,       -- y2 (top)
        half_width    -- z2
    }

    
    player:set_properties({
        visual_size = {x = size, y = size},
        collisionbox = collbox,
        eye_height = eye_height,
        stepheight = step_height
    })

    
    local jump_boost = 1.0
    if size < 1 then
        jump_boost = 1.2 + (1 - size) * 0.8 
    elseif size > 1 then
        jump_boost = math.max(0.5, 1.0 / size) 
    end

    player:set_physics_override({
        speed = math.max(0.2, size < 1 and size or 1 / size),
        jump = jump_boost,
        gravity = 1
    })
    
    local pos = player:get_pos()
    local node_below = minetest.get_node_or_nil({x=pos.x, y=pos.y-0.1, z=pos.z})
    
    if node_below and node_below.name ~= "air" and node_below.name ~= "ignore" then
        
        pos.y = math.floor(pos.y) + 0.1
    else
        
        pos.y = pos.y + 0.1
    end
    
    player:set_pos(pos)

    
    size_editer.size_change_effect(player)
end

function size_editer.size_change_effect(player)
    local pos = player:get_pos()
    pos.y = pos.y + 0.5
    for i = 1, 20 do
        minetest.after(i / 10, function()
            if player and player:is_player() then
                minetest.add_particle({
                    pos = vector.new(pos.x, pos.y, pos.z),
                    velocity = vector.new(math.random() - 0.5, math.random() * 0.5, math.random() - 0.5),
                    acceleration = vector.new(0, -1, 0),
                    expirationtime = 1,
                    size = math.random(1, 3),
                    texture = "default_item_smoke.png",
                    glow = 5
                })
            end
        end)
    end
end

minetest.register_on_joinplayer(function(player)
    local name = player:get_player_name()
    local meta = player:get_meta()
    local size = meta:get_float("player_size") or 1
    if size ~= 1 then
        minetest.after(1, function()
            size_editer.set_player_size(name, size)
        end)
    end
end)

minetest.register_chatcommand("setsize", {
    params = "<size>",
    description = "Set your size (0.05–20.0) - Requires 'size_edit' privilege",
    func = function(name, param)
        if not has_privilege(name) then
            return false, "You need the '" .. size_editer.priv .. "' privilege to use this command"
        end
        local size = tonumber(param)
        if not size then
            return false, "Invalid size. Usage: /setsize <number>"
        end
        if size < 0.05 or size > 20 then
            return false, "Size must be between 0.05 and 20"
        end
        size_editer.set_player_size(name, size)
        return true, "Your size has been set to " .. size
    end
})

minetest.register_chatcommand("small", {
    params = "<amount>",
    description = "Decrease your size (1–100 levels) - Requires 'size_edit' privilege",
    func = function(name, param)
        if not has_privilege(name) then
            return false, "You need the '" .. size_editer.priv .. "' privilege to use this command"
        end
        local amount = tonumber(param) or 1
        if amount < 1 or amount > 100 then
            return false, "Amount must be between 1 and 100"
        end
        local player = minetest.get_player_by_name(name)
        if not player then return false, "Player not found" end
        local meta = player:get_meta()
        local current_size = meta:get_float("player_size") or 1
        local new_size = math.max(0.05, current_size - (amount * 0.01))
        size_editer.set_player_size(name, new_size)
        return true, "Size decreased to " .. new_size
    end
})

minetest.register_chatcommand("large", {
    params = "<amount>",
    description = "Increase your size (1–100 levels) - Requires 'size_edit' privilege",
    func = function(name, param)
        if not has_privilege(name) then
            return false, "You need the '" .. size_editer.priv .. "' privilege to use this command"
        end
        local amount = tonumber(param) or 1
        if amount < 1 or amount > 100 then
            return false, "Amount must be between 1 and 100"
        end
        local player = minetest.get_player_by_name(name)
        if not player then return false, "Player not found" end
        local meta = player:get_meta()
        local current_size = meta:get_float("player_size") or 1
        local new_size = math.min(20, current_size + (amount * 0.01))
        size_editer.set_player_size(name, new_size)
        return true, "Size increased to " .. new_size
    end
})

minetest.register_chatcommand("super_small", {
    description = "Become very small (size 0.05)",
    func = function(name)
        if not has_privilege(name) then return false, "You need '" .. size_editer.priv .. "' privilege" end
        size_editer.set_player_size(name, 0.05)
        return true, "You are now super small!"
    end
})

minetest.register_chatcommand("micro", {
    description = "Become microscopic (size 0.05)",
    func = function(name)
        if not has_privilege(name) then return false, "You need '" .. size_editer.priv .. "' privilege" end
        size_editer.set_player_size(name, 0.05)
        return true, "You are now microscopic!"
    end
})

minetest.register_chatcommand("super_large", {
    description = "Become extremely large (size 20)",
    func = function(name)
        if not has_privilege(name) then return false, "You need '" .. size_editer.priv .. "' privilege" end
        size_editer.set_player_size(name, 20)
        return true, "You are now super large!"
    end
})

minetest.register_chatcommand("normal_size", {
    description = "Reset to normal size (1.0)",
    func = function(name)
        if not has_privilege(name) then return false, "You need '" .. size_editer.priv .. "' privilege" end
        size_editer.set_player_size(name, 1)
        return true, "Back to normal size!"
    end
})
