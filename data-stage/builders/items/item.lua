local BaseItem = require("data-stage.builders.items.base")
local Module = {}

--- Cria um protótipo padrão de Item (ItemPrototype).
--- Herda a implementação de BaseItem.createBaseItem.
---
--- Usage:
--- ```lua
--- local item = LDA.createItem("iron-gear-wheel", "intermediate-product", 100)
--- ```
---
--- @param name string Nome único do item
--- @param subgroup string|nil Subgrupo do menu de crafting (padrão: "basic-crafting")
--- @param stack_size number|nil Tamanho da pilha (padrão: 100)
--- @param pictures table|nil Lista de sprites/pictures
--- @return table ItemPrototype
function Module.createItem(name, subgroup, stack_size, pictures)
    return BaseItem.createBaseItem({
        name = name,
        subgroup = subgroup or "basic-crafting",
        stack_size = stack_size or 100,
        pictures = pictures,
        ingredient_to_weight_coefficient = 0.28
    })
end

return Module
