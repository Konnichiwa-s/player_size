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

minetest.register_chatcommand("setsize", {
    params = "<size>",
    description = "Set your size (0.001-20.0) - Requires 'size_edit' privilege",
    func = function(name, param)
        if not has_privilege(name) then
            return false, "You need the '" .. size_editer.priv .. "' privilege to use this command"
        end
        
        local size = tonumber(param)
        if not size then
            return false, "Invalid size. Usage: /setsize <number>"
        end
        
        if size < 0.001 or size > 20 then
            return false, "Size must be between 0.001 and 20"
        end
        
        size_editer.set_player_size(name, size)
        return true, "Your size has been set to " .. size
    end
})

minetest.register_chatcommand("small", {
    params = "<amount>",
    description = "Decrease your size (1-100 levels) - Requires 'size_edit' privilege",
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
        local new_size = math.max(0.001, current_size - (amount * 0.01))
        
        size_editer.set_player_size(name, new_size)
        return true, "Size decreased to " .. new_size
    end
})

minetest.register_chatcommand("large", {
    params = "<amount>",
    description = "Increase your size (1-100 levels) - Requires 'size_edit' privilege",
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
    description = "Become extremely small (size 0.01) - Requires 'size_edit' privilege",
    func = function(name)
        if not has_privilege(name) then
            return false, "You need the '" .. size_editer.priv .. "' privilege to use this command"
        end
        size_editer.set_player_size(name, 0.01)
        return true, "You are now super small!"
    end
})

minetest.register_chatcommand("micro", {
    description = "Become microscopic (size 0.001) - Requires 'size_edit' privilege",
    func = function(name)
        if not has_privilege(name) then
            return false, "You need the '" .. size_editer.priv .. "' privilege to use this command"
        end
        size_editer.set_player_size(name, 0.001)
        return true, "You are now microscopic!"
    end
})

minetest.register_chatcommand("super_large", {
    description = "Become extremely large (size 20) - Requires 'size_edit' privilege",
    func = function(name)
        if not has_privilege(name) then
            return false, "You need the '" .. size_editer.priv .. "' privilege to use this command"
        end
        size_editer.set_player_size(name, 20)
        return true, "You are now super large!"
    end
})

minetest.register_chatcommand("normal_size", {
    description = "Return to normal size - Requires 'size_edit' privilege",
    func = function(name)
        if not has_privilege(name) then
            return false, "You need the '" .. size_editer.priv .. "' privilege to use this command"
        end
        size_editer.set_player_size(name, 1)
        return true, "Back to normal size!"
    end
})

function size_editer.set_player_size(name, size)
    local player = minetest.get_player_by_name(name)
    if not player then return end

  
    local meta = player:get_meta()
    meta:set_float("player_size", size)
    
    player:set_properties({
        visual_size = {
            x = size,
            y = size
        }
    })
    
    
    local collbox = {
        -0.3 * size,
        0.0,
        -0.3 * size,
        0.3 * size,
        1.7 * size,
        0.3 * size
    }
    
    
    local step_height = math.max(0.01, 0.6 * size)
    
    
    local eye_height = size_editer.default_props.eye_height * size
    
    
    player:set_properties({
        collisionbox = collbox,
        eye_height = eye_height,
        stepheight = step_height
    })
    
    
    if size > 1 then
        player:set_physics_override({
            speed = 1 / size,
            jump = 0.5 / size
        })
    else
        player:set_physics_override({
            speed = size,
            jump = size
        })
    end
    
    
    size_editer.size_change_effect(player)
end


function size_editer.size_change_effect(player)
    local pos = player:get_pos()
    pos.y = pos.y + 0.5
    
    for i = 1, 20 do
        minetest.after(i/10, function()
            minetest.add_particle({
                pos = vector.new(pos.x, pos.y, pos.z),
                velocity = vector.new(
                    math.random() - 0.5,
                    math.random() * 0.5,
                    math.random() - 0.5
                ),
                acceleration = vector.new(0, -1, 0),
                expirationtime = 1,
                size = math.random(1, 3),
                texture = "default_item_smoke.png",
                glow = 5
            })
        end)
    end
end

-- Apply saved size on join
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
