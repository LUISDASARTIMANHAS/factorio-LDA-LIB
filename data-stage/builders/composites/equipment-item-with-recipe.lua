local createEquipment = require("data-stage.builders.items.equipment-item")
local compositeBase = require("data-stage.builders.composites.base")

local Module = {}

--- Cria o par {equipment_item, recipe} para um equipamento de grade.
---
--- Usage:
--- ```lua
--- local pair = LDA.createEquipmentItemWithRecipe(
---     "night-vision-equipment", "equipment", 20,
---     "advanced-crafting", 10,
---     { {type = "item", name = "steel-plate", amount = 10} },
---     { {type = "item", name = "night-vision-equipment", amount = 1} }
--- )
--- ```
---
--- @param name string Nome do item e receita
--- @param subgroup string Grupo na GUI
--- @param weight number Peso do item
--- @param crafted_in string Categoria de fabricação
--- @param time number Tempo em segundos
--- @param ingredients table Ingredientes
--- @param results table Saídas
--- @param alternative_unlock_methods table|nil Desbloqueios alternativos
--- @param isEnabled boolean|nil Se vem desbloqueado
--- @param pictures table|nil Sprites/Pictures
--- @return table Array {item, recipe}
function Module.createEquipmentItemWithRecipe(name, subgroup, weight, crafted_in, time, ingredients, results, alternative_unlock_methods, isEnabled, pictures)
    local item = createEquipment.createEquipmentItem(name, subgroup, weight)
    return compositeBase.createCompositePrototype(item, "equipment", name, crafted_in, time, ingredients, results, alternative_unlock_methods, isEnabled, pictures)
end

return Module
