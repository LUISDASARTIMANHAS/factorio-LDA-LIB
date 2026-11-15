local BaseItem = require("data-stage.builders.items.base")
local item_sounds = require("__base__.prototypes.item_sounds")

local Module = {}

--- Cria um ItemPrototype para blocos/máquinas colocáveis no mapa (place_result = name).
--- Herda a implementação de BaseItem.createBaseItem.
---
--- Usage:
--- ```lua
--- local block = LDA.createBlockItem("assembling-machine-1", "production", 50)
--- ```
---
--- @param name string Nome do item/máquina
--- @param subgroup string|nil Subgrupo (padrão: "production")
--- @param stack_size number|nil Tamanho da pilha (padrão: 1)
--- @param icon_size number|nil Tamanho do ícone (padrão: 128)
--- @param pick_sound table|nil Som ao pegar
--- @param drop_sound table|nil Som ao soltar
--- @return table ItemPrototype
function Module.createBlockItem(name, subgroup, stack_size, icon_size, pick_sound, drop_sound)
    local resolved_stack = stack_size or 1
    return BaseItem.createBaseItem({
        name = name,
        subgroup = subgroup or "production",
        order = "a[" .. name .. "]",
        stack_size = resolved_stack,
        weight = resolved_stack / 2,
        icon_size = icon_size or 128,
        inventory_move_sound = item_sounds.mechanical_inventory_move,
        pick_sound = pick_sound or item_sounds.mechanical_inventory_pickup,
        drop_sound = drop_sound or item_sounds.mechanical_inventory_move,
        place_result = name
    })
end

return Module
