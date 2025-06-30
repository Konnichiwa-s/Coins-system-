local modpath = minetest.get_modpath("coin_system")
local S = minetest.get_translator("coin_system")


local coin_values = {
    gold = 1,
    steel = 10,
    diamond = 100
}


minetest.register_craftitem("coin_system:gold_coin", {
    description = S("Gold Coin") .. "\n" .. minetest.colorize("#00FF00", S("Value: @1", coin_values.gold)),
    inventory_image = "coin_system_gold_coin.png",
    groups = {coin = 1, gold_coin = 1},
    stack_max = 9999
})

minetest.register_craftitem("coin_system:steel_coin", {
    description = S("Steel Coin") .. "\n" .. minetest.colorize("#00FF00", S("Value: @1", coin_values.steel)),
    inventory_image = "coin_system_steel_coin.png",
    groups = {coin = 1, steel_coin = 1},
    stack_max = 9999
})

minetest.register_craftitem("coin_system:diamond_coin", {
    description = S("Diamond Coin") .. "\n" .. minetest.colorize("#00FF00", S("Value: @1", coin_values.diamond)),
    inventory_image = "coin_system_diamond_coin.png",
    groups = {coin = 1, diamond_coin = 1},
    stack_max = 9999
})


minetest.register_craft({
    output = "coin_system:gold_coin 4",
    recipe = {
        {"default:gold_ingot", "default:gold_ingot"},
        {"default:gold_ingot", "default:gold_ingot"}
    }
})

minetest.register_craft({
    output = "coin_system:steel_coin",
    recipe = {
        {"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
        {"default:steel_ingot", "default:mese_crystal", "default:steel_ingot"},
        {"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"}
    }
})

minetest.register_craft({
    output = "coin_system:diamond_coin",
    recipe = {
        {"default:diamond", "default:diamond", "default:diamond"},
        {"default:diamond", "default:mese_block", "default:diamond"},
        {"default:diamond", "default:diamond", "default:diamond"}
    }
})


minetest.register_chatcommand("total_coins", {
    description = S("Show total coins in the game"),
    func = function(name)
        local gold = 0
        local steel = 0
        local diamond = 0
        
        
        for _, player in ipairs(minetest.get_connected_players()) do
            local inv = player:get_inventory()
            for i = 1, inv:get_size("main") do
                local stack = inv:get_stack("main", i)
                if stack:get_name() == "coin_system:gold_coin" then
                    gold = gold + stack:get_count()
                elseif stack:get_name() == "coin_system:steel_coin" then
                    steel = steel + stack:get_count()
                elseif stack:get_name() == "coin_system:diamond_coin" then
                    diamond = diamond + stack:get_count()
                end
            end
        end
        
        
        local total_value = (gold * coin_values.gold) +
                           (steel * coin_values.steel) +
                           (diamond * coin_values.diamond)
        
        minetest.chat_send_player(name, S("Total Coins in Game:"))
        minetest.chat_send_player(name, minetest.colorize("#FFFF00", S("Gold Coins: ")) .. minetest.colorize("#00FF00", gold))
        minetest.chat_send_player(name, minetest.colorize("#FFFF00", S("Steel Coins: ")) .. minetest.colorize("#00FF00", steel))
        minetest.chat_send_player(name, minetest.colorize("#FFFF00", S("Diamond Coins: ")) .. minetest.colorize("#00FF00", diamond))
        minetest.chat_send_player(name, minetest.colorize("#FFFF00", S("Total Value: ")) .. minetest.colorize("#00FF00", total_value))
        
        return true
    end
})


minetest.register_chatcommand("set_coin", {
    params = "<coin_type> <value>",
    description = S("Set coin exchange value (coin_types: gold, steel, diamond)"),
    privs = {coin_admin = true},
    func = function(name, param)
        local coin_type, value_str = param:match("^(%S+)%s+(%d+)$")
        if not coin_type or not value_str then
            return false, S("Usage: /set_coin <gold|steel|diamond> <value>")
        end
        
        local value = tonumber(value_str)
        if not value or value < 1 then
            return false, S("Value must be a positive number")
        end
        
        coin_type = coin_type:lower()
        if coin_type == "gold" then
            coin_values.gold = value
        elseif coin_type == "steel" then
            coin_values.steel = value
        elseif coin_type == "diamond" then
            coin_values.diamond = value
        else
            return false, S("Invalid coin type. Use: gold, steel, diamond")
        end
        
        
        minetest.override_item("coin_system:gold_coin", {
            description = S("Gold Coin") .. "\n" .. minetest.colorize("#00FF00", S("Value: @1", coin_values.gold))
        })
        
        minetest.override_item("coin_system:steel_coin", {
            description = S("Steel Coin") .. "\n" .. minetest.colorize("#00FF00", S("Value: @1", coin_values.steel))
        })
        
        minetest.override_item("coin_system:diamond_coin", {
            description = S("Diamond Coin") .. "\n" .. minetest.colorize("#00FF00", S("Value: @1", coin_values.diamond))
        })
        
        minetest.chat_send_player(name, S("@1 coin value set to @2", coin_type, value))
        return true
    end
})


minetest.register_chatcommand("show_coins", {
    description = S("Show current coin exchange values"),
    func = function(name)
        minetest.chat_send_player(name, minetest.colorize("#FFFF00", S("Current Coin Values:")))
        minetest.chat_send_player(name, minetest.colorize("#FFFF00", S("Gold Coin: ")) .. minetest.colorize("#00FF00", coin_values.gold))
        minetest.chat_send_player(name, minetest.colorize("#FFFF00", S("Steel Coin: ")) .. minetest.colorize("#00FF00", coin_values.steel))
        minetest.chat_send_player(name, minetest.colorize("#FFFF00", S("Diamond Coin: ")) .. minetest.colorize("#00FF00", coin_values.diamond))
        return true
    end
})


minetest.register_privilege("coin_admin", {
    description = "Can set coin exchange values",
    give_to_singleplayer = true,
    give_to_admin = true
})


minetest.log("action", "[Coin System] Coin values initialized: " ..
    "Gold=" .. coin_values.gold .. ", " ..
    "Steel=" .. coin_values.steel .. ", " ..
    "Diamond=" .. coin_values.diamond)
