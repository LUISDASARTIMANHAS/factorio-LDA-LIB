local resource_autoplace = require("__base__.resource-autoplace")

-- Explicitly initialize Bauxite's patch set
resource_autoplace.initialize_patch_set("bauxite", true)

data:extend({
  -- Autoplace Control for Map Generation Menu
  {
    type = "autoplace-control",
    name = "bauxite",
    localised_name = {"", "[entity=bauxite] ", {"entity-name.bauxite"}},
    richness = true,
    order = "a-i",
    category = "resource",
    icons = {
      {
        icon = "__base__/graphics/icons/copper-ore.png", -- Use copper ore icon
        tint = {r = 0.8, g = 0.2, b = 0.2, a = 1.0} -- Dark red hue
      }
    },
    icon_size = 64,
    icon_mipmaps = 4
  },

  -- Bauxite Ore Item
  {
    type = "item",
    name = "bauxite",
    icons = {
      {
        icon = "__more-ore__/graphics/icons/bauxite-ore.png"
      }
    },
    icon_size = 64,
    icon_mipmaps = 4,
    stack_size = 50,
    subgroup = "raw-resource",
    order = "b[bauxite]"
  },

  -- Bauxite Resource Definition
  {
    type = "resource",
    name = "bauxite",
    localised_name = {"entity-name.bauxite"},
    localised_description = {"entity-description.bauxite"},
    icons = {
      {
        icon = "__base__/graphics/icons/copper-ore.png",
        tint = {r = 0.8, g = 0.2, b = 0.2, a = 1.0} -- Dark red hue
      }
    },
    icon_size = 64,
    icon_mipmaps = 4,
    flags = {"placeable-neutral"},
    order = "a-b-i",
    map_color = {0.8, 0.2, 0.2}, -- Dark red map color
    minable = {
      mining_particle = "copper-ore-particle",
      mining_time = 1.5,
      result = "bauxite"
    },
    collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    stage_counts = {15000, 9500, 5500, 2900, 1300, 400, 150, 80},
    stages = {
      sheet = {
        filename = "__base__/graphics/entity/copper-ore/copper-ore.png",
        priority = "extra-high",
        size = 128,
        frame_count = 8,
        variation_count = 8,
        scale = 0.5,
        tint = {r = 0.8, g = 0.2, b = 0.2, a = 1.0} -- Dark red hue
      }
    },
    autoplace = resource_autoplace.resource_autoplace_settings({
      name = "bauxite",
      order = "b",
      base_density = 6,
      base_spots_per_km2 = 1.5,
      has_starting_area_placement = false,
      regular_rq_factor_multiplier = 1.2,
      starting_rq_factor_multiplier = 1.4,
      random_spot_size_minimum = 0.5,
      random_spot_size_maximum = 2,
      tile_restriction = nil,
      additional_richness = 0
    })
  },

  -- Bauxite Smelting Recipe
  {
    type = "recipe",
    name = "bauxite-plate",
    category = "smelting",
    enabled = false,
    energy_required = 3.2,
    allow_productivity = true,
    ingredients = {
      {type = "item", name = "bauxite", amount = 5}
    },
    results = {
      {type = "item", name = "bauxite-plate", amount = 1}
    },
    main_product = "bauxite-plate"
  },

  -- Bauxite Plate Item
  {
    type = "item",
    name = "bauxite-plate",
    icons = {
      {
        icon = "__more-ore__/graphics/icons/bauxite-plate.png"
      }
    },
    icon_size = 64,
    icon_mipmaps = 4,
    stack_size = 100,
    subgroup = "intermediate-product",
    order = "b[bauxite-plate]"
  },

  -- Technology Unlock
})

-- Ensure Bauxite is added to Nauvis' map generation settings
if data.raw.planet and data.raw.planet.nauvis and data.raw.planet.nauvis.map_gen_settings then
  data.raw.planet.nauvis.map_gen_settings.autoplace_controls["bauxite"] = {
    frequency = "normal",
    size = "normal",
    richness = "normal"
  }

  if not data.raw.planet.nauvis.map_gen_settings.autoplace_settings then
    data.raw.planet.nauvis.map_gen_settings.autoplace_settings = { entity = { settings = {} } }
  end

  data.raw.planet.nauvis.map_gen_settings.autoplace_settings.entity.settings["bauxite"] = {
    starting_area = true,
    base_density = 6,
    base_spots_per_km2 = 1.5,
    random_probability = 1.0,
  }
end
