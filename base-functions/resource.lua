local Module = {}
local controlGetModPath = require("utils.control-get-mod-path")
local resource_autoplace = require("resource-autoplace")
-- local tile_sounds = require("__base__.prototypes.tile.tile-sounds")
local simulations = require("__base__.prototypes.factoriopedia-simulations")
-- #by factorio

function Module.createResource(name, order, particleName, resource_parameters, autoplace_parameters)
    local path_main = controlGetModPath.getModPath()
    local icon_path = path_main .. "graphics/icons/" .. name .. "-ore"
    resource_autoplace.initialize_patch_set(name .. "-ore", true)
    return {
        type = "resource",
        name = name .. "-ore",
        icon_size = 128,
        icon = icon_path .. ".png",
        flags = {"placeable-neutral"},
        order = "a-b-" .. order,
        tree_removal_probability = 0.8,
        tree_removal_max_distance = 32 * 32,
        minable = {
            mining_particle = particleName or "stone-particle",
            mining_time = resource_parameters.mining_time or 1,
            result = name .. "-ore"
        },
        category = resource_parameters.category,
        subgroup = resource_parameters.subgroup,
        walking_sound = resource_parameters.walking_sound,
        driving_sound = resource_parameters.driving_sound,
        collision_mask = resource_parameters.collision_mask,
        collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        autoplace = resource_autoplace.resource_autoplace_settings {
            name = name .. "-ore",
            order = "a-b-" .. order,
            base_density = autoplace_parameters.base_density or 10,
            base_spots_per_km = autoplace_parameters.base_spots_per_km2 or 1.8,
            has_starting_area_placement = true,
            regular_rq_factor_multiplier = autoplace_parameters.regular_rq_factor_multiplier or 1.10,
            starting_rq_factor_multiplier = autoplace_parameters.starting_rq_factor_multiplier or 1.5,
            candidate_spot_count = autoplace_parameters.candidate_spot_count or 22,
            tile_restriction = autoplace_parameters.tile_restriction
        },
        stage_counts = {15000, 9500, 5500, 2900, 1300, 400, 150, 80},
        stages = {
            sheet = {
                filename = "__base__/graphics/entity/iron-ore/iron-ore.png",
                priority = "extra-high",
                size = 128,
                frame_count = 8,
                variation_count = 8,
                scale = 0.5,
            }
        },
        map_color = resource_parameters.map_color or {0.415, 0.525, 0.580},
        mining_visualisation_tint = resource_parameters.mining_visualisation_tint or
            {r = 0.895, g = 0.965, b = 1.000, a = 1.000}, -- #e4f6ffff,
        factoriopedia_simulation = resource_parameters.factoriopedia_simulation or simulations.factoriopedia_iron_ore
    }
end

return Module

-- # by FACTORIO

-- Initialize the core patch sets in a predictable order
-- resource_autoplace.initialize_patch_set("iron-ore", true)
-- resource_autoplace.initialize_patch_set("copper-ore", true)
-- resource_autoplace.initialize_patch_set("coal", true)
-- resource_autoplace.initialize_patch_set("stone", true)
-- resource_autoplace.initialize_patch_set("crude-oil", false)
-- resource_autoplace.initialize_patch_set("uranium-ore", false)

-- local function resource(resource_parameters, autoplace_parameters)
--     return {
--         type = "resource",
--         name = resource_parameters.name,
--         icon = "__base__/graphics/icons/" .. resource_parameters.name .. ".png",
--         flags = {"placeable-neutral"},
--         order = "a-b-" .. resource_parameters.order,
--         tree_removal_probability = 0.8,
--         tree_removal_max_distance = 32 * 32,
--         minable = resource_parameters.minable or
--             {
--                 mining_particle = resource_parameters.name .. "-particle",
--                 mining_time = resource_parameters.mining_time,
--                 result = resource_parameters.name
--             },
--         category = resource_parameters.category,
--         subgroup = resource_parameters.subgroup,
--         walking_sound = resource_parameters.walking_sound,
--         driving_sound = resource_parameters.driving_sound,
--         collision_mask = resource_parameters.collision_mask,
--         collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
--         selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
--         autoplace = resource_autoplace.resource_autoplace_settings {
--             name = resource_parameters.name,
--             order = resource_parameters.order,
--             base_density = autoplace_parameters.base_density,
--             base_spots_per_km = autoplace_parameters.base_spots_per_km2,
--             has_starting_area_placement = true,
--             regular_rq_factor_multiplier = autoplace_parameters.regular_rq_factor_multiplier,
--             starting_rq_factor_multiplier = autoplace_parameters.starting_rq_factor_multiplier,
--             candidate_spot_count = autoplace_parameters.candidate_spot_count,
--             tile_restriction = autoplace_parameters.tile_restriction
--         },
--         stage_counts = {15000, 9500, 5500, 2900, 1300, 400, 150, 80},
--         stages = {
--             sheet = {
--                 filename = "__base__/graphics/entity/" ..
--                     resource_parameters.name .. "/" .. resource_parameters.name .. ".png",
--                 priority = "extra-high",
--                 size = 128,
--                 frame_count = 8,
--                 variation_count = 8,
--                 scale = 0.5
--             }
--         },
--         map_color = resource_parameters.map_color,
--         mining_visualisation_tint = resource_parameters.mining_visualisation_tint,
--         factoriopedia_simulation = resource_parameters.factoriopedia_simulation
--     }
-- end

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

-- {
--     type = "resource",
--     name = "crude-oil",
--     icon = "__base__/graphics/icons/crude-oil-resource.png",
--     flags = {"placeable-neutral"},
--     category = "basic-fluid",
--     subgroup = "mineable-fluids",
--     order="a",
--     infinite = true,
--     highlight = true,
--     minimum = 60000,
--     normal = 300000,
--     infinite_depletion_amount = 10,
--     resource_patch_search_radius = 12,
--     tree_removal_probability = 0.7,
--     tree_removal_max_distance = 32 * 32,
--     minable =
--     {
--       mining_time = 1,
--       results =
--       {
--         {
--           type = "fluid",
--           name = "crude-oil",
--           amount_min = 10,
--           amount_max = 10,
--           probability = 1
--         }
--       }
--     },
--     walking_sound = tile_sounds.walking.oil({}),
--     driving_sound = tile_sounds.driving.oil,
--     collision_box = {{-1.4, -1.4}, {1.4, 1.4}},
--     selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
--     autoplace = resource_autoplace.resource_autoplace_settings
--     {
--       name = "crude-oil",
--       order = "c", -- Other resources are "b"; oil won't get placed if something else is already there.
--       base_density = 8.2,
--       base_spots_per_km2 = 1.8,
--       random_probability = 1/48,
--       random_spot_size_minimum = 1,
--       random_spot_size_maximum = 1, -- don't randomize spot size
--       additional_richness = 220000, -- this increases the total everywhere, so base_density needs to be decreased to compensate
--       has_starting_area_placement = false,
--       regular_rq_factor_multiplier = 1
--     },
--     stage_counts = {0},
--     stages =
--     {
--       sheet = util.sprite_load("__base__/graphics/entity/crude-oil/crude-oil",
--       {
--         priority = "extra-high",
--         scale = 0.5,
--         variation_count = 1,
--         frame_count = 4,
--       })
--     },
--     draw_stateless_visualisation_under_building = false,
--     stateless_visualisation =
--     {
--       {
--         count = 1,
--         render_layer = "decorative",
--         animation = util.sprite_load("__base__/graphics/entity/crude-oil/crude-oil-animation",
--         {
--           priority = "extra-high",
--           scale = 0.5,
--           frame_count = 32,
--           animation_speed = 0.2,
--         })
--       },
--       {
--         count = 1,
--         render_layer = "smoke",
--         animation = {
--           filename = "__base__/graphics/entity/crude-oil/oil-smoke-outer.png",
--           frame_count = 47,
--           line_length = 16,
--           width = 90,
--           height = 188,
--           animation_speed = 0.3,
--           shift = util.by_pixel(-2, 24 -152),
--           scale = 1.5,
--           tint = util.multiply_color({r=0.3, g=0.3, b=0.3}, 0.2)
--         }
--       },
--       {
--         count = 1,
--         render_layer = "smoke",
--         animation = {
--           filename = "__base__/graphics/entity/crude-oil/oil-smoke-inner.png",
--           frame_count = 47,
--           line_length = 16,
--           width = 40,
--           height = 84,
--           animation_speed = 0.3,
--           shift = util.by_pixel(0, 24 -78),
--           scale = 1.5,
--           tint = util.multiply_color({r=0.4, g=0.4, b=0.4}, 0.2)
--         }
--       }
--     },
--     map_color = {0.78, 0.2, 0.77},
--     map_grid = false
--   },
