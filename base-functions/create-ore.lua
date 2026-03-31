local Module = {}
local item_sounds = require("__base__.prototypes.item_sounds")
local controlGetModPath = require("utils.control-get-mod-path")
local utils = require("utils.control-utils")
local controlAutoplace = require("autoplace-control")
local controlResource = require("resource")

-- graphics/icons - icones de itens

function Module.createOre(name, stack_size, fuel_category, fuel_value,order)
    local path_main = controlGetModPath.getModPath()
    local icon_path = path_main .. "graphics/icons/" .. name .. "-ore"
    return {
        -- Ore Item
        {
            type = "item",
            name = name .. "-ore",
            icon = icon_path .. ".png",
            icon_size = 128,
            pictures = utils.getSequentialPictureList(icon_path, 1, 4, 64, 0.5, 4),
            fuel_category = fuel_category or nil,
            -- "4MJ"
            fuel_value = fuel_value or nil,
            subgroup = "raw-resource",
            color_hint = {text = "I"},
            order = "e[" .. name .. "-ore" .. "]",
            inventory_move_sound = item_sounds.resource_inventory_move,
            pick_sound = item_sounds.resource_inventory_pickup,
            drop_sound = item_sounds.resource_inventory_move,
            stack_size = stack_size or 100,
            weight = stack_size / 2
        },
        -- Autoplace Control for Map Generation Menu
        controlAutoplace.createAutoplaceControl(name, "a-d", nil, 128),
        -- Resource Definition
        controlResource.createResource(
            name,
            order or name,
            -- particleName
            nil,
            -- resource_parameters
            {
                order = order or name,
                map_color = {0.415, 0.525, 0.580},
                mining_visualisation_tint = {r = 0.895, g = 0.965, b = 1.000, a = 1.000} -- #e4f6ffff
            },
            -- autoplace_parameters
            {
                base_density = 10,
                regular_rq_factor_multiplier = 1.10,
                starting_rq_factor_multiplier = 1.5,
                candidate_spot_count = 22 -- To match 0.17.50 placement
            }
        )
    }
end
-- by factorio 
-- resource(
--     {
--       name = "iron-ore",
--       order = "b",
--       map_color = {0.415, 0.525, 0.580},
--       mining_time = 1,
--       walking_sound = tile_sounds.walking.ore,
--       driving_sound = tile_sounds.driving.stone,
--       mining_visualisation_tint = {r = 0.895, g = 0.965, b = 1.000, a = 1.000}, -- #e4f6ffff
--       factoriopedia_simulation = simulations.factoriopedia_iron_ore,
--     },
--     {
--       base_density = 10,
--       regular_rq_factor_multiplier = 1.10,
--       starting_rq_factor_multiplier = 1.5,
--       candidate_spot_count = 22, -- To match 0.17.50 placement
--     }
--   )

-- example
-- {
--     type = "item",
--     name = "coal",
--     icon = "__base__/graphics/icons/coal.png",
--     dark_background_icon = "__base__/graphics/icons/coal-dark-background.png",
--     pictures =
--     {
--       {size = 64, filename = "__base__/graphics/icons/coal.png", scale = 0.5, mipmap_count = 4},
--       {size = 64, filename = "__base__/graphics/icons/coal-1.png", scale = 0.5, mipmap_count = 4},
--       {size = 64, filename = "__base__/graphics/icons/coal-2.png", scale = 0.5, mipmap_count = 4},
--       {size = 64, filename = "__base__/graphics/icons/coal-3.png", scale = 0.5, mipmap_count = 4}
--     },
--     fuel_category = "chemical",
--     fuel_value = "4MJ",
--     subgroup = "raw-resource",
--     order = "b[coal]",
--     inventory_move_sound = item_sounds.resource_inventory_move,
--     pick_sound = item_sounds.resource_inventory_pickup,
--     drop_sound = item_sounds.resource_inventory_move,
--     stack_size = 50,
--     weight = 2 * kg,
--     random_tint_color = item_tints.yellowing_coal
--   },
return Module
