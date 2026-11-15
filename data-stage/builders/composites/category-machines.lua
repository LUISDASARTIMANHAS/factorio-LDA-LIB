local createItemWithRecipe = require("data-stage.builders.composites.item-with-recipe")

local Module = {}

--- Construtor genérico para itens e receitas voltados a categorias de máquinas específicas.
--- Cria automaticamente o par item + receita na categoria desejada.
---
--- Usage:
--- ```lua
--- local pair = LDA.createCategoryMachineItemWithRecipe(
---     "advanced-crafting",
---     "electronic-component",
---     2, 1,
---     { {type = "item", name = "copper-cable", amount = 3} },
---     100
--- )
--- ```
---
--- @param category string Categoria de crafting (ex: "advanced-crafting", "chemistry", "organic", "smelting")
--- @param name string Nome do item e da receita
--- @param time number Tempo de fabricação
--- @param qtde number Quantidade produzida
--- @param ingredients table Lista de ingredientes
--- @param stack_size number|nil Tamanho do stack (padrão: 100)
--- @param alternative_unlock_methods table|nil Tecnologias alternativas
--- @param isEnabled boolean|nil Habilitado inicialmente
--- @return table Array {item, recipe}
function Module.createCategoryMachineItemWithRecipe(category, name, time, qtde, ingredients, stack_size, alternative_unlock_methods, isEnabled)
    local results = {
        {type = "item", name = name, amount = qtde}
    }
    local crafted_in = category or "basic-crafting"
    local subgroup = "intermediate-product"
    local size = stack_size or 100

    return createItemWithRecipe.createItemWithRecipe(
        name,
        subgroup,
        size,
        crafted_in,
        time,
        ingredients,
        results,
        alternative_unlock_methods,
        isEnabled
    )
end

function Module.createAssemblerItemWithRecipe(name, time, qtde, ingredients, stack_size, alternative_unlock_methods, isEnabled)
    return Module.createCategoryMachineItemWithRecipe("advanced-crafting", name, time, qtde, ingredients, stack_size, alternative_unlock_methods, isEnabled)
end

function Module.createChemicalPlantItemWithRecipe(name, time, qtde, ingredients, stack_size, alternative_unlock_methods, isEnabled)
    return Module.createCategoryMachineItemWithRecipe("chemistry", name, time, qtde, ingredients, stack_size, alternative_unlock_methods, isEnabled)
end

function Module.createBiochamberItemWithRecipe(name, time, qtde, ingredients, stack_size, alternative_unlock_methods, isEnabled)
    return Module.createCategoryMachineItemWithRecipe("organic", name, time, qtde, ingredients, stack_size, alternative_unlock_methods, isEnabled)
end

function Module.createSmeltingItemWithRecipe(name, time, qtde, ingredients, stack_size, alternative_unlock_methods, isEnabled)
    return Module.createCategoryMachineItemWithRecipe("smelting", name, time, qtde, ingredients, stack_size, alternative_unlock_methods, isEnabled)
end

return Module
