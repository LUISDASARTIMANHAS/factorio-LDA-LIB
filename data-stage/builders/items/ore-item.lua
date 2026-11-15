local BaseItem = require("data-stage.builders.items.base")
local utils = require("shared.control-utils")

local Module = {}

--- Cria um ItemPrototype especializado para minérios.
--- Herda a implementação de BaseItem.createBaseItem.
--- Aceita tanto chamada posicional quanto via tabela de opções.
---
--- Usage:
--- ```lua
--- -- Posicional:
--- local ore_item = LDA.createOreItem("bauxite", 100, "chemical", "2MJ")
---
--- -- Tabela:
--- local ore_item = LDA.createOreItem({
---     name = "lepidolite",
---     stack_size = 100,
---     fuel_categories = {"chemical"},
---     fuel_value = "1.2MJ"
--- })
--- ```
---
--- @param name_or_opts string|table Nome do minério ou tabela com todas as opções
--- @param stack_size number|nil Tamanho da pilha
--- @param fuel_categories string|table|nil Categorias de combustível
--- @param fuel_value string|nil Valor energético (ex: "1.5MJ")
--- @param order string|nil Ordem do item
--- @param options table|nil Opções adicionais (quando usando chamada posicional)
--- @return table ItemPrototype
function Module.createOreItem(name_or_opts, stack_size, fuel_categories, fuel_value, order, options)
    local name
    local opts = {}

    if type(name_or_opts) == "table" then
        opts = name_or_opts
        name = opts.name
        stack_size = opts.stack_size or stack_size
        fuel_categories = opts.fuel_categories or opts.fuel_category or fuel_categories
        fuel_value = opts.fuel_value or fuel_value
        order = opts.order or order
    elseif type(name_or_opts) == "string" and name_or_opts ~= "" then
        name = name_or_opts
        opts = options or {}
    else
        error("[LDA-LIB] [createOreItem] Nome inválido. Esperada string ou tabela com campo 'name'.")
    end

    if type(fuel_categories) == "string" then
        fuel_categories = { fuel_categories }
    end

    local item_name = opts.full_name or (name .. "-ore")

    -- Herança: criação do protótipo base
    local item = BaseItem.createBaseItem({
        name = item_name,
        icon = opts.icon or (not opts.icons and utils.resolveAssetPath("icons", name .. "-ore.png") or nil),
        pictures = opts.pictures,
        icon_size = opts.icon_size or 128,
        subgroup = opts.subgroup or "raw-resource",
        order = order or ("e[" .. item_name .. "]"),
        stack_size = stack_size or 100,
        weight = opts.weight,
        color_hint = opts.color_hint or { text = "I" },
        inventory_move_sound = opts.inventory_move_sound,
        pick_sound = opts.pick_sound,
        drop_sound = opts.drop_sound,
        random_tint_color = opts.random_tint_color,
        ingredient_to_weight_coefficient = opts.ingredient_to_weight_coefficient,
        extra = opts.extra
    })

    -- Se passou lista de ícones (layers com tints)
    if opts.icons then
        item.icons = opts.icons
        item.icon = nil
    end

    -- Especialização: propriedades exclusivas do minério
    item.fuel_categories = fuel_categories
    item.fuel_value = fuel_value

    return item
end

return Module
