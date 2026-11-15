local Module = {}
local createItem = require("data-stage.builders.base.create-item")

function Module.createEquipmentItem(name, subgroup, weight)
    return createItem.createBaseItem({
        name = name,
        subgroup = subgroup or "equipment",
        order = "a[" .. name .. "]",
        stack_size = 1,
        weight = weight,
        place_as_equipment_result = name
    })
end

-- example
-- {
-- type = "item",
-- name = "quantum-teleporter-equipment",
-- icon = path_main .. "graphics/itens/quantum-teleporter-equipment-128.png",
-- icon_size = 128,
-- subgroup = "itens",
-- -- diz pro jogo que o equipamento deve ser colocado com o item especificado
-- place_as_equipment_result = "quantum-teleporter-equipment",
-- order = "a[quantum-teleporter-item]",
-- stack_size = 1
-- },

return Module
