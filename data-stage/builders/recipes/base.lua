local utils = require("shared.control-utils")
local Module = {}

local function validateIngredientResults(list, label, name)
    if not list then return end
    for _, v in ipairs(list) do
        if v.type ~= "item" and v.type ~= "fluid" then
            error("[LDA-LIB] [createBaseRecipe] Tipo de " .. label .. " inválido: '" .. tostring(v.type) .. "' em " .. tostring(name))
        end
    end
end

--- Cria um protótipo base genérico de receita (RecipePrototype).
--- Raiz de herança para criação de receitas e compósitos no Factorio 2.0+.
---
--- Usage:
--- ```lua
--- local recipe = LDA.createBaseRecipe({
---     name = "iron-gear-wheel",
---     time = 0.5,
---     ingredients = { {type = "item", name = "iron-plate", amount = 2} },
---     results = { {type = "item", name = "iron-gear-wheel", amount = 1} }
--- })
--- ```
---
--- @param params table Configurações da receita
--- @return table RecipePrototype
function Module.createBaseRecipe(params)
    if type(params) ~= "table" or not params.name then
        error("[LDA-LIB] [createBaseRecipe] Parâmetro 'name' é obrigatório.")
    end

    local name = params.name
    validateIngredientResults(params.ingredients, "ingrediente", name)
    validateIngredientResults(params.results, "resultado", name)

    local icon_path = params.icon
    if not icon_path and not params.icons then
        icon_path = utils.resolveAssetPath(params.typeIcon or "icons", name)
    end

    local categories = params.categories
    if not categories then
        local crafted_in = params.crafted_in or "crafting"
        categories = {crafted_in}
    end

    local recipe_data = {
        type = "recipe",
        name = name,
        categories = categories,
        enabled = params.enabled or false,
        energy_required = params.energy_required or params.time or 1,
        icon = icon_path,
        icons = params.icons,
        ingredients = params.ingredients or {},
        results = params.results or {},
        maximum_productivity = params.maximum_productivity or 2,
        allow_quality = params.allow_quality ~= false,
        always_show_madein = params.always_show_madein ~= false,
        allowed_module_categories = params.allowed_module_categories or {"productivity", "speed"},
        alternative_unlock_methods = params.alternative_unlock_methods
    }

    utils.applyIconOrPictures(recipe_data, params.pictures, params.icon_size or 128)

    if params.extra and type(params.extra) == "table" then
        utils.tableMerge(recipe_data, params.extra, true)
    end

    return recipe_data
end

return Module
