local Module = {}
local item_sounds = require("__base__.prototypes.item_sounds")
local item_tints = require("__base__.prototypes.item-tints")
local utils = require("shared.control-utils")

--- Cria um protótipo de ferramenta/pacote científico de pesquisa (type = "tool").
---
--- Usage:
--- ```lua
--- local pack = LDA.createItemSearch("advanced-science-pack", 200)
--- ```
---
--- @param name string Nome do pacote científico
--- @param stack_size number|nil Tamanho do stack (padrão: 200)
--- @return table ToolPrototype
function Module.createItemSearch(name, stack_size)
    local icon_path = utils.resolveAssetPath("icons", name .. ".png")
    return {
        type = "tool",
        durability = 1,
        name = name,
        icon = icon_path,
        icon_size = 128,
        color_hint = {text = "1"},
        subgroup = "science",
        order = "a[science]-z[" .. name .. "]",
        inventory_move_sound = item_sounds.metal_small_inventory_move,
        pick_sound = item_sounds.metal_small_inventory_pickup,
        drop_sound = item_sounds.metal_small_inventory_move,
        stack_size = stack_size or 200,
        ingredient_to_weight_coefficient = 0.28,
        random_tint_color = item_tints.iron_rust
    }
end

return Module
