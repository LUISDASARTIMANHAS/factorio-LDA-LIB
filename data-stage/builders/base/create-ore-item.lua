
local Module = {}

local BaseItem = require("data-stage.builders.base.create-base-item")
local utils = require("shared.control-utils")

--- Cria um ItemPrototype especializado para minérios.
--- Herda a implementação de createBaseItem.
---
--- @param name string Nome base do minério.
--- @param stack_size number Tamanho da pilha.
--- @param fuel_categories string|table Categorias de combustível.
--- @param fuel_value string Valor energético.
--- @param order string Ordem do item.
--- @param options table Opções adicionais.
--- @return table ItemPrototype
function Module.createOreItem(
    name,
    stack_size,
    fuel_categories,
    fuel_value,
    order,
    options
)
    if type(name) ~= "string" or name == "" then
        error("[LDA-LIB] [createOreItem] Nome inválido.")
    end

    options = options or {}

    if type(fuel_categories) == "string" then
        fuel_categories = { fuel_categories }
    end

    local item_name = options.full_name or (name .. "-ore")

    -- Herança: criação do protótipo-base.
    local item = BaseItem.createBaseItem({
        name = item_name,
        icon = options.icon or utils.resolveAssetPath(
            "icons",
            name .. "-ore.png"
        ),
        pictures = options.pictures,
        icon_size = options.icon_size or 128,

        subgroup = options.subgroup or "raw-resource",
        order = order or ("e[" .. item_name .. "]"),

        stack_size = stack_size or 100,
        weight = options.weight,

        color_hint = options.color_hint or { text = "I" },

        inventory_move_sound = options.inventory_move_sound,
        pick_sound = options.pick_sound,
        drop_sound = options.drop_sound,

        random_tint_color = options.random_tint_color,
        ingredient_to_weight_coefficient = options.ingredient_to_weight_coefficient,

        extra = options.extra
    })

    -- Especialização: propriedades exclusivas do minério.
    item.fuel_categories = fuel_categories
    item.fuel_value = fuel_value

    return item
end

return Module