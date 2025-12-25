local Module = {}
local item_sounds = require("__base__.prototypes.item_sounds")
local item_tints = require("__base__.prototypes.item-tints")
local controlGetModPath = require("utils.control-get-mod-path")
-- stone-brick
-- subgroup = terrain 

-- wood,coal,iron-ore
-- subgroup = raw-resource

-- iron-plate, copper-plate
-- subgroup = raw-material

-- copper-cable,iron-stick,iron-gear-wheel
-- subgroup = intermediate-product

-- wooden-chest,
-- subgroup = storage

-- stone-furnace
-- subgroup = rawsmelting-machine

-- burner-mining-drill,electric-mining-drill
-- subgroup = extraction-machine

-- burner-inserter,inserter
-- subgroup = inserter

-- pipe,small-electric-pole
-- subgroup = energy-pipe-distribution

-- boiler,steam-engine
-- subgroup = energy

-- radar
-- subgroup = defensive-structure

-- small-lamp
-- subgroup = circuit-network

-- assembling-machine-1
-- subgroup = production-machine

-- red-wire,green-wire
-- subgroup = spawnables

-- repair-pack,automation-science-pack
-- subgroup = tool

-- car
-- subgroup = transport


function Module.createItem(name, subgroup, stack_size)
    local path_main = controlGetModPath.getModPath()
    local icon_path = path_main .. "graficos/itens/" .. name .. ".png"
    return {
        type = "item",
        name = name,
        icon = icon_path,
        icon_size = 128,
        color_hint = {text = "1"},
        subgroup = subgroup or "intermediate-products",
        order = "b["..subgroup.."]-a[" .. name .. "item" .. "]",
        inventory_move_sound = item_sounds.metal_small_inventory_move,
        pick_sound = item_sounds.metal_small_inventory_pickup,
        drop_sound = item_sounds.metal_small_inventory_move,
        stack_size = stack_size or 100,
        weight = stack_size/2,
        ingredient_to_weight_coefficient = 0.28,
        random_tint_color = item_tints.iron_rust
    }
end

-- example
-- {
--     type = "item",
--     name = "electronic-circuit",
--     icon = "__base__/graphics/icons/electronic-circuit.png",
--     subgroup = "intermediate-product",
--     color_hint = { text = "1" },
--     order = "b[circuits]-a[electronic-circuit]",
--     inventory_move_sound = item_sounds.electric_small_inventory_move,
--     pick_sound = item_sounds.electric_small_inventory_pickup,
--     drop_sound = item_sounds.electric_small_inventory_move,
--     stack_size = 200,
--     ingredient_to_weight_coefficient = 0.28
--   },

return Module
