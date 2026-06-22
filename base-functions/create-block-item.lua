local Module = {}
local item_sounds = require("__base__.prototypes.item_sounds")
local item_tints = require("__base__.prototypes.item-tints")
local controlGetModPath = require("utils.control-get-mod-path")

-- graphics/icons - icones de itens

function Module.createBlockItem(name, subgroup, stack_size,icon_size,pick_sound,drop_sound)
    local path_main = controlGetModPath.getModPath()

    local icon_path = path_main .. "graphics/icons/" .. name .. ".png"
    return {
        type = "item",
        name = name,
        icon = icon_path,
        icon_size = icon_size or 128,
        color_hint = {text = "1"},
        subgroup = subgroup or "production",
        order = "a[" .. name .. "]",
        inventory_move_sound = item_sounds.mechanical_inventory_move,
        pick_sound = pick_sound or item_sounds.mechanical_inventory_pickup,
        drop_sound = drop_sound or item_sounds.mechanical_inventory_move,
        place_result = name,
        stack_size = stack_size or 1,
        -- ex: 50/2 = 25
        weight = stack_size / 2,
        random_tint_color = item_tints.iron_rust
    }
end

-- example
-- {
--     type = "item",
--     name = "assembling-machine-1",
--     icon = "__base__/graphics/icons/assembling-machine-1.png",
--     subgroup = "production-machine",
--     color_hint = { text = "1" },
--     order = "a[assembling-machine-1]",
--     inventory_move_sound = item_sounds.mechanical_inventory_move,
--     pick_sound = item_sounds.mechanical_inventory_pickup,
--     drop_sound = item_sounds.mechanical_inventory_move,
--     place_result = "assembling-machine-1",
--     stack_size = 50,
--     random_tint_color = item_tints.iron_rust
--   },
return Module
