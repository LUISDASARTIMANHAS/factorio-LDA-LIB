local createBlock = require("data-stage.builders.items.block-item")
local compositeBase = require("data-stage.builders.composites.base")

local Module = {}

--- Cria o par {block_item, recipe} para um bloco ou máquina colocável.
---
--- Usage:
--- ```lua
--- local pair = LDA.createBlockItemWithRecipe(
---     "assembling-machine-1", "production-machine", 50,
---     "crafting", 0.5,
---     { {type = "item", name = "iron-gear-wheel", amount = 5}, {type = "item", name = "electronic-circuit", amount = 3} },
---     { {type = "item", name = "assembling-machine-1", amount = 1} }
--- )
--- ```
---
--- @param name string O nome do item e receita
--- @param subgroup string Grupo na GUI
--- @param stack_size number Quantidade do item por stack
--- @param crafted_in string Categoria onde o item é construído
--- @param time number Tempo em segundos
--- @param ingredients table Ingredientes
--- @param results table Saídas
--- @param alternative_unlock_methods table|nil Desbloqueios alternativos
--- @param isEnabled boolean|nil Se vem desbloqueado
--- @param pictures table|nil Sprites/Pictures
--- @param icon_size number|nil Tamanho do ícone
--- @param pick_sound table|nil Som ao pegar
--- @param drop_sound table|nil Som ao soltar
--- @return table Array {item, recipe}
function Module.createBlockItemWithRecipe(name, subgroup, stack_size, crafted_in, time, ingredients, results, alternative_unlock_methods, isEnabled, pictures, icon_size, pick_sound, drop_sound)
    local item = createBlock.createBlockItem(name, subgroup, stack_size, icon_size, pick_sound, drop_sound)
    return compositeBase.createCompositePrototype(item, "entities", name, crafted_in, time, ingredients, results, alternative_unlock_methods, isEnabled, pictures)
end

return Module
