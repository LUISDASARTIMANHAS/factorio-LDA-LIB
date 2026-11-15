local BaseItem = require("data-stage.builders.items.base")
local Module = {}

--- Cria um ItemPrototype para equipamentos de grade/armadura (place_as_equipment_result = name).
--- Herda a implementação de BaseItem.createBaseItem.
---
--- Usage:
--- ```lua
--- local eq = LDA.createEquipmentItem("night-vision-equipment", "equipment", 20)
--- ```
---
--- @param name string Nome do item de equipamento
--- @param subgroup string|nil Subgrupo (padrão: "equipment")
--- @param weight number|nil Peso do item
--- @return table ItemPrototype
function Module.createEquipmentItem(name, subgroup, weight)
    return BaseItem.createBaseItem({
        name = name,
        subgroup = subgroup or "equipment",
        order = "a[" .. name .. "]",
        stack_size = 1,
        weight = weight,
        place_as_equipment_result = name
    })
end

return Module
