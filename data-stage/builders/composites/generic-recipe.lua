local createItem = require("data-stage.builders.items.item")
local createRecipe = require("data-stage.builders.recipes.recipe")

local Module = {}

--- Cria um par genérico básico de item e receita padrão.
---
--- Usage:
--- ```lua
--- local pair = LDA.createGenericRecipe("my-placeholder-item")
--- ```
---
--- @param name string O nome do item e receita
--- @return table Array {item, recipe}
function Module.createGenericRecipe(name)
    local results = {
        {type = "item", name = name, amount = 1}
    }
    local ingredients = {
        {type = "item", name = "iron-plate", amount = 1}
    }
    local item = createItem.createItem(name, "other-consumables", 50)
    local recipe = createRecipe.createRecipe("icons", name, "advanced-crafting", 10, ingredients, results)

    return {item, recipe}
end

return Module
