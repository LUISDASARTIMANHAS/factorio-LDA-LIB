local Module = {}
local controlGetModPath = require("shared.control-get-mod-path")
local resource_autoplace = require("resource-autoplace")
local simulations = require("__base__.prototypes.factoriopedia-simulations")

function Module.createResource(name, order, particleName, resource_parameters, autoplace_parameters)
    local path_main = controlGetModPath.getModPath()
    local icon_path = path_main .. "graphics/icons/" .. name .. "-ore"
    local res_params = resource_parameters or {}
    local auto_params = autoplace_parameters or {}
    resource_autoplace.initialize_patch_set(name .. "-ore", true)

    return {
        type = "resource",
        name = name .. "-ore",
        icon_size = res_params.icon_size or 128,
        icon = res_params.icons and nil or (res_params.icon or (icon_path .. ".png")),
        icons = res_params.icons or nil,
        flags = {"placeable-neutral"},
        order = "a-b-" .. order,
        tree_removal_probability = 0.8,
        tree_removal_max_distance = 32 * 32,
        minable = {
            mining_particle = particleName or "stone-particle",
            mining_time = res_params.mining_time or 1,
            result = name .. "-ore"
        },
        category = res_params.category,
        subgroup = res_params.subgroup,
        walking_sound = res_params.walking_sound,
        driving_sound = res_params.driving_sound,
        collision_mask = res_params.collision_mask,
        collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        autoplace = resource_autoplace.resource_autoplace_settings {
            name = name .. "-ore",
            order = "a-b-" .. order,
            base_density = auto_params.base_density or 10,
            base_spots_per_km = auto_params.base_spots_per_km2 or 1.8,
            has_starting_area_placement = true,
            regular_rq_factor_multiplier = auto_params.regular_rq_factor_multiplier or 1.10,
            starting_rq_factor_multiplier = auto_params.starting_rq_factor_multiplier or 1.5,
            candidate_spot_count = auto_params.candidate_spot_count or 22,
            tile_restriction = auto_params.tile_restriction
        },
        stage_counts = res_params.stage_counts or {15000, 9500, 5500, 2900, 1300, 400, 150, 80},
        stages = res_params.stages or {
            sheet = {
                filename = "__base__/graphics/entity/iron-ore/iron-ore.png",
                priority = "extra-high",
                size = 128,
                frame_count = 8,
                variation_count = 8,
                scale = 0.5
            }
        },
        map_color = res_params.map_color or {0.415, 0.525, 0.580},
        mining_visualisation_tint = res_params.mining_visualisation_tint or
            {r = 0.895, g = 0.965, b = 1.000, a = 1.000},
        factoriopedia_simulation = simulations.factoriopedia_iron_ore
    }
end

return Module
