local BaseRecipe = require("data-stage.builders.recipes.base")
local Module = {}

--- Cria um protótipo de Receita (RecipePrototype).
--- Herda a implementação de BaseRecipe.createBaseRecipe.
---
--- Usage:
--- ```lua
--- local recipe = LDA.createRecipe(
---     "icons",
---     "iron-gear-wheel",
---     "crafting",
---     0.5,
---     { {type = "item", name = "iron-plate", amount = 2} },
---     { {type = "item", name = "iron-gear-wheel", amount = 1} }
--- )
--- ```
---
--- @param typeIcon string Subpasta do ícone (ex: "icons", "entities")
--- @param name string Nome da receita
--- @param crafted_in string Categoria da máquina de fabricação
--- @param time number Tempo de fabricação em segundos
--- @param ingredients table Lista de ingredientes
--- @param results table Lista de resultados
--- @param alternative_unlock_methods table|nil Tecnologias alternativas que desbloqueiam
--- @param enabled boolean|nil Se a receita vem habilitada desde o início
--- @param pictures table|nil Sprites/Pictures opcionais
--- @return table RecipePrototype
function Module.createRecipe(typeIcon, name, crafted_in, time, ingredients, results, alternative_unlock_methods, enabled, pictures)
    return BaseRecipe.createBaseRecipe({
        typeIcon = typeIcon,
        name = name,
        crafted_in = crafted_in,
        time = time,
        ingredients = ingredients,
        results = results,
        alternative_unlock_methods = alternative_unlock_methods,
        enabled = enabled,
        pictures = pictures
    })
end

return Module
