local utils = require("shared.control-utils")
local Module = {}

local function validateIngredientResults(list, label, name)
    if not list then return end
    for _, v in ipairs(list) do
        if v.type ~= "item" and v.type ~= "fluid" then
            error("Tipo de " .. label .. " inválido: '" .. tostring(v.type) .. "' em " .. name)
        end
    end
end

-- @param typeIcon {string} concatena pastas com base no tipo do item, ex "graphics/typeIcon/name.png"
function Module.createRecipe(typeIcon, name, crafted_in, time, ingredients, results, alternative_unlock_methods, enabled, pictures)
    validateIngredientResults(ingredients, "ingrediente", name)
    validateIngredientResults(results, "resultado", name)

    local icon_path = utils.resolveAssetPath(typeIcon, name)

    local item_data = {
        type = "recipe",
        name = name,
        categories = {crafted_in},
        enabled = enabled or false,
        energy_required = time,
        icon = icon_path,
        ingredients = ingredients,
        results = results,
        maximum_productivity = 2,
        allow_quality = true,
        always_show_madein = true,
        allowed_module_categories = {"productivity", "speed"},
        alternative_unlock_methods = alternative_unlock_methods
    }

    utils.applyIconOrPictures(item_data, pictures, 128)
    return item_data
end

-- example
--      {
--             type = "recipe",
--             name = "iron-ore",
--             categories = {"advanced-crafting"},
--             enabled = false,
--             energy_required = 120,
--             ingredients = {
--                 {type = "item", name = "supercapacitor", amount = 4096},
--                 {type = "item", name = "tungsten-plate", amount = 256},
--                 {type = "item", name = "carbon-fiber", amount = 64},
--                 {type = "item", name = "quantum-processor", amount = 256}
--             },
--             results = {
--                 {type = "item", name = "quantum-teleporter-equipment", amount = 1}
--             },
--             alternative_unlock_methods = {"Quantum-Teleporter"}
--         }
return Module
