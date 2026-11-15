local Module = {}
local item_sounds = require("__base__.prototypes.item_sounds")
local controlGetModPath = require("shared.control-get-mod-path")
local utils = require("shared.control-utils")

--- Cria um protótipo de Item para minério (ItemPrototype) para Factorio 2.0+ / 2.1+.
-- @param name (string|table) Nome base do minério (gera "<name>-ore") ou tabela com parâmetros.
-- @param stack_size (number, optional) Tamanho da pilha (padrão: 100).
-- @param fuel_category (string|table, optional) Categoria(s) de combustível ("chemical" ou {"chemical"}).
-- @param fuel_value (string, optional) Valor de combustível (ex: "2MJ").
-- @param options (table, optional) Opções adicionais de customização (icon, subgroup, order, pictures, weight, etc.).
-- @return (table) ItemPrototype
function Module.createOreItem(name, stack_size, fuel_category, fuel_value, options)
    local opts = options or {}
    if type(name) == "table" then
        opts = name
        name = opts.name
        stack_size = opts.stack_size
        fuel_category = opts.fuel_categories or opts.fuel_category
        fuel_value = opts.fuel_value
    end

    if not name or type(name) ~= "string" then
        error("LDA.createOreItem: 'name' é obrigatório e deve ser uma string.")
    end

    local path_main = controlGetModPath.getModPath()
    local item_name = opts.full_name or (name .. "-ore")
    local icon_path = opts.icon or (path_main .. "graphics/icons/" .. name .. "-ore")
    local icon_file = opts.icon or (icon_path .. ".png")
    local resolved_stack_size = stack_size or opts.stack_size or 100

    local resolved_fuel_categories = nil
    local raw_fuel_cat = fuel_category or opts.fuel_categories or opts.fuel_category
    if type(raw_fuel_cat) == "string" then
        resolved_fuel_categories = {raw_fuel_cat}
    elseif type(raw_fuel_cat) == "table" then
        resolved_fuel_categories = raw_fuel_cat
    end

    local resolved_fuel_val = fuel_value or opts.fuel_value or nil
    local resolved_order = opts.order or ("e[" .. item_name .. "]")
    local resolved_subgroup = opts.subgroup or "raw-resource"
    local resolved_weight = opts.weight or (resolved_stack_size / 2)

    local resolved_pictures = nil
    if opts.pictures ~= false then
        if type(opts.pictures) == "table" then
            resolved_pictures = opts.pictures
        elseif not opts.icon and not opts.icons then
            resolved_pictures = utils.getSequentialPictureList(icon_path, 1, 4, 64, 0.5, 4)
        end
    end

    local item_prototype = {
        type = "item",
        name = item_name,
        icon = opts.icons and nil or icon_file,
        icons = opts.icons or nil,
        icon_size = opts.icon_size or 128,
        pictures = resolved_pictures,
        fuel_categories = resolved_fuel_categories,
        fuel_value = resolved_fuel_val,
        subgroup = resolved_subgroup,
        color_hint = opts.color_hint or {text = "I"},
        order = resolved_order,
        inventory_move_sound = opts.inventory_move_sound or item_sounds.resource_inventory_move,
        pick_sound = opts.pick_sound or item_sounds.resource_inventory_pickup,
        drop_sound = opts.drop_sound or item_sounds.resource_inventory_move,
        stack_size = resolved_stack_size,
        weight = resolved_weight
    }

    return item_prototype
end

return Module
