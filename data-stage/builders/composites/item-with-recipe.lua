local createItem = require("data-stage.builders.items.item")
local compositeBase = require("data-stage.builders.composites.base")

local Module = {}

--- Cria o par {item, recipe} para um item padrão.
---
--- Usage:
--- ```lua
--- local pair = LDA.createItemWithRecipe(
---     "electronic-circuit", "intermediate-product", 200,
---     "crafting", 0.5,
---     { {type = "item", name = "iron-plate", amount = 1}, {type = "item", name = "copper-cable", amount = 3} },
---     { {type = "item", name = "electronic-circuit", amount = 1} }
--- )
--- ```
---
--- @param name string O nome do item e receita
--- @param subgroup string Grupo onde deve ser organizado na GUI
--- @param stack_size number Quantidade do item por pilha
--- @param crafted_in string Categoria de fabricação
--- @param time number Tempo de fabricação em segundos
--- @param ingredients table Lista de ingredientes
--- @param results table Lista de saídas
--- @param alternative_unlock_methods table|nil Tecnologias alternativas
--- @param isEnabled boolean|nil Se a receita vem habilitada
--- @param pictures table|nil Sprites/Pictures
--- @return table Array {item, recipe}
function Module.createItemWithRecipe(name, subgroup, stack_size, crafted_in, time, ingredients, results, alternative_unlock_methods, isEnabled, pictures)
    local item = createItem.createItem(name, subgroup, stack_size, pictures)
    return compositeBase.createCompositePrototype(item, "icons", name, crafted_in, time, ingredients, results, alternative_unlock_methods, isEnabled, pictures)
end

Module.createCompositePrototype = compositeBase.createCompositePrototype

return Module
