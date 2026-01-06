local createFluid = require("base-functions.create-fluid")
local createRecipe = require("base-functions.create-recipe")

local Module = {}

function Module.createFluidWithRecipe(name, heatEnergy, crafted_in, time, ingredients, results,alternative_unlock_methods,isEnabled,pictures)
    local item = createFluid.createFluid(name, heatEnergy)
    local recipe = createRecipe.createRecipe("fluid",name, crafted_in, time, ingredients, results,alternative_unlock_methods,isEnabled,pictures)

    return {item, recipe}
end

-- example
-- {
--     type = "recipe",
--     name = "advanced-oil-processing",
--     category = "oil-processing",
--     enabled = false,
--     energy_required = 5,
--     ingredients =
--     {
--       {type = "fluid", name = "water", amount = 50},
--       {type = "fluid", name = "crude-oil", amount = 100}
--     },
--     results =
--     {
--       {type = "fluid", name = "heavy-oil", amount = 25},
--       {type = "fluid", name = "light-oil", amount = 45},
--       {type = "fluid", name = "petroleum-gas", amount = 55}
--     },
--     allow_productivity = true,
--     icon = "__base__/graphics/icons/fluid/advanced-oil-processing.png",
--     subgroup = "fluid-recipes",
--     order = "a[oil-processing]-b[advanced-oil-processing]"
--   }
return Module
