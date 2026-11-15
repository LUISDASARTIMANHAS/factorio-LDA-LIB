local Module = {}
local item_sounds = require("__base__.prototypes.item_sounds")
local item_tints = require("__base__.prototypes.item-tints")
local controlGetModPath = require("shared.control-get-mod-path")
local utils = require("shared.control-utils")

--- Cria um protótipo base genérico de item (ItemPrototype). seguindo o estilo de herança
--- Função genérica e extensível para qualquer subtipo ou variação de item.
---
--- Usage:
--- ```lua
--- local item = LDA.createBaseItem({
---     name = "my-custom-item",
---     subgroup = "raw-material",
---     stack_size = 50,
---     place_result = "my-entity"
--- })
--- ```
---
--- @param params table Configurações do item
--- @return table ItemPrototype
function Module.createBaseItem(params)
    if type(params) ~= "table" or not params.name then
        error("[LDA-LIB] [createBaseItem] Parâmetro 'name' é obrigatório.")
    end

    local name = params.name
    local stack_size = params.stack_size or 100
    local icon_path = params.icon or utils.resolveAssetPath("icons", name)
    local subgroup = params.subgroup or "basic-crafting"
    local order = params.order or ("b[" .. subgroup .. "]-a[" .. name .. "item]")

    local item_data = {
        type = params.type or "item",
        name = name,
        icon = icon_path,
        subgroup = subgroup,
        order = order,
        stack_size = stack_size,
        weight = params.weight or (stack_size / 2),
        color_hint = params.color_hint or {text = "1"},
        inventory_move_sound = params.inventory_move_sound or item_sounds.metal_small_inventory_move,
        pick_sound = params.pick_sound or item_sounds.metal_small_inventory_pickup,
        drop_sound = params.drop_sound or item_sounds.metal_small_inventory_move,
        random_tint_color = params.random_tint_color or item_tints.iron_rust,
        ingredient_to_weight_coefficient = params.ingredient_to_weight_coefficient
    }

    if params.place_result then
        item_data.place_result = params.place_result
    end

    if params.place_as_equipment_result then
        item_data.place_as_equipment_result = params.place_as_equipment_result
    end

    utils.applyIconOrPictures(item_data, params.pictures, params.icon_size or 128)

    if params.extra and type(params.extra) == "table" then
        utils.tableMerge(item_data, params.extra, true)
    end

    return item_data
end

--- Cria um protótipo de Item (ItemPrototype).
-- @param name (string) Nome único do item (e.g., "iron-gear-wheel").
-- @param subgroup (string, optional) Subgrupo do menu de crafting. Padrão: "basic-crafting".
-- @param stack_size (uint16, optional) Tamanho da pilha. Padrão: 100.
-- @param pictures (array[SpritePath], optional) Lista de sprites/pictures (impede o uso de icon_size).
-- @return (table) ItemPrototype
function Module.createItem(name, subgroup, stack_size, pictures)
    return Module.createBaseItem({
        name = name,
        subgroup = subgroup or "basic-crafting",
        stack_size = stack_size or 100,
        pictures = pictures,
        ingredient_to_weight_coefficient = 0.28
    })
end

-- example
-- {
--     type = "item",
--     name = "electronic-circuit",
--     icon = "__base__/graphics/icons/electronic-circuit.png",
--     subgroup = "intermediate-product",
--     color_hint = { text = "1" },
--     order = "b[circuits]-a[electronic-circuit]",
--     inventory_move_sound = item_sounds.electric_small_inventory_move,
--     pick_sound = item_sounds.electric_small_inventory_pickup,
--     drop_sound = item_sounds.electric_small_inventory_move,
--     stack_size = 200,
--     ingredient_to_weight_coefficient = 0.28
--   },

return Module
