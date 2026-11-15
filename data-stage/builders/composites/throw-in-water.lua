local categoryMachines = require("data-stage.builders.composites.category-machines")

local Module = {}

--- Cria o par {item, recipe} para itens que requerem jogar na água (categoria throw-in-water).
--- Herda a implementação de categoryMachines.createCategoryMachineItemWithRecipe.
---
--- Usage:
--- ```lua
--- local pair = LDA.createThrowInWaterItemWithRecipe(
---     "wet-biomass", 5, 1,
---     { {type = "item", name = "dry-biomass", amount = 1} },
---     200, 50
--- )
--- ```
---
--- @param name string Nome do item e da receita
--- @param time number Tempo de fabricação
--- @param qtde number Quantidade produzida
--- @param ingredients table Lista de ingredientes
--- @param stack_size number|nil Tamanho do stack
--- @param requiredWaterValue number Quantidade de água requerida
--- @param alternative_unlock_methods table|nil Tecnologias alternativas
--- @param isEnabled boolean|nil Se vem desbloqueado
--- @return table Array {item, recipe}
function Module.createThrowInWaterItemWithRecipe(
    name,
    time,
    qtde,
    ingredients,
    stack_size,
    requiredWaterValue,
    alternative_unlock_methods,
    isEnabled
)
    local requiredIngredient = {
        type = "fluid",
        name = "water",
        amount = requiredWaterValue
    }

    table.insert(ingredients, requiredIngredient)

    return categoryMachines.createCategoryMachineItemWithRecipe(
        "throw-in-water",
        name,
        time,
        qtde,
        ingredients,
        stack_size or 200,
        alternative_unlock_methods,
        isEnabled
    )
end

return Module
