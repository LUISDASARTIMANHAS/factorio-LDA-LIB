local Module = {}
local item_sounds = require("__base__.prototypes.item_sounds")
local item_tints = require("__base__.prototypes.item-tints")
local controlGetModPath = require("base-functions.control-get-mod-path")

function Module.createEquipmentItem(name, subgroup, weight)
    local path_main = controlGetModPath.getModPath()

    local icon_path = path_main .. "graficos/itens/" .. name .. ".png"
    return {
        type = "item",
        name = name,
        icon = icon_path,
        icon_size = 128,
        subgroup = subgroup or "equipment",
        order = "a[" .. name .. "]",
        -- inventory_move_sound = item_sounds.mechanical_inventory_move,
        -- pick_sound = item_sounds.mechanical_inventory_pickup,
        -- drop_sound = item_sounds.mechanical_inventory_move,
        place_as_equipment_result = name,
        stack_size = 1,
        -- ex: 50/2 = 25
        weight = weight,
    }
end

-- example
-- {
-- type = "item",
-- name = "quantum-teleporter-equipment",
-- icon = path_main .. "graficos/itens/quantum-teleporter-equipment-128.png",
-- icon_size = 128,
-- subgroup = "itens",
-- -- diz pro jogo que o equipamento deve ser colocado com o item especificado
-- place_as_equipment_result = "quantum-teleporter-equipment",
-- order = "a[quantum-teleporter-item]",
-- stack_size = 1
-- },

return Module