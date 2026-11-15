local Module = {}
local controlGetModPath = require("shared.control-get-mod-path")
local controlOreItem = require("data-stage.builders.base.create-ore-item")
local controlAutoplace = require("data-stage.builders.base.autoplace-control")
local controlResource = require("data-stage.builders.base.resource")

--- Cria o conjunto completo de protótipos para um minério: Item, AutoplaceControl e ResourceEntity.
-- Suporta chamada posicional clássica ou tabela de opções detalhadas.
-- @param name (string|table) Nome base do minério ou tabela com todas as opções.
-- @param stack_size (number, optional) Tamanho da pilha do item (padrão: 100).
-- @param fuel_category (string|table, optional) Categoria(s) de combustível ("chemical" ou {"chemical"}).
-- @param fuel_value (string, optional) Valor de combustível (ex: "2MJ").
-- @param order (string, optional) Ordem do protótipo no inventário e geração.
-- @return (table) Array de protótipos Factorio: { ItemPrototype, AutoplaceControl, ResourceEntity }
function Module.createOre(name, stack_size, fuel_category, fuel_value, order)
    local opts = {}
    if type(name) == "table" then
        opts = name
        name = opts.name
        stack_size = opts.stack_size
        fuel_category = opts.fuel_categories or opts.fuel_category
        fuel_value = opts.fuel_value
        order = opts.order
    end

    if not name or type(name) ~= "string" then
        error("LDA.createOre: 'name' é obrigatório e deve ser uma string.")
    end

    -- 1. Cria o Item do minério através do módulo atômico
    local item_prototype = controlOreItem.createOreItem(
        name,
        stack_size,
        fuel_category,
        fuel_value,
        opts.item_options or opts
    )

    -- 2. Autoplace Control para menu de geração de mapa
    local autoplace_order = opts.autoplace_order or order or "a-d"
    local autoplace_control = controlAutoplace.createAutoplaceControl(
        name,
        autoplace_order,
        opts.autoplace_tint,
        opts.autoplace_icon_size or opts.icon_size or 128,
        opts.autoplace_icon_mipmaps
    )
    if opts.autoplace_icons or opts.icons then
        autoplace_control.icons = opts.autoplace_icons or opts.icons
    elseif opts.autoplace_icon or opts.icon then
        autoplace_control.icons = {
            {
                icon = opts.autoplace_icon or opts.icon,
                icon_size = opts.autoplace_icon_size or opts.icon_size or 64,
                tint = opts.autoplace_tint
            }
        }
    end

    -- 3. Definição da Entidade de Recurso no mapa
    local res_order = order or opts.order or name
    local resource_parameters = opts.resource_parameters or {
        order = res_order,
        map_color = opts.map_color or {0.415, 0.525, 0.580},
        mining_visualisation_tint = opts.mining_visualisation_tint or {r = 0.895, g = 0.965, b = 1.000, a = 1.000},
        mining_time = opts.mining_time or 1,
        category = opts.category,
        subgroup = opts.subgroup,
        walking_sound = opts.walking_sound,
        driving_sound = opts.driving_sound,
        collision_mask = opts.collision_mask,
        icon = opts.resource_icon or opts.icon,
        icons = opts.resource_icons or opts.icons,
        icon_size = opts.resource_icon_size or opts.icon_size or 128
    }
    if not resource_parameters.order then
        resource_parameters.order = res_order
    end
    if resource_parameters.icon == nil and opts.icon ~= nil then
        resource_parameters.icon = opts.icon
    end
    if resource_parameters.icons == nil and opts.icons ~= nil then
        resource_parameters.icons = opts.icons
    end

    local autoplace_parameters = opts.autoplace_parameters or {
        base_density = opts.base_density or 10,
        regular_rq_factor_multiplier = opts.regular_rq_factor_multiplier or 1.10,
        starting_rq_factor_multiplier = opts.starting_rq_factor_multiplier or 1.5,
        candidate_spot_count = opts.candidate_spot_count or 22,
        base_spots_per_km2 = opts.base_spots_per_km2,
        tile_restriction = opts.tile_restriction
    }

    local resource_entity = controlResource.createResource(
        name,
        res_order,
        opts.particle_name or opts.mining_particle,
        resource_parameters,
        autoplace_parameters
    )

    return {
        item_prototype,
        autoplace_control,
        resource_entity
    }
end

-- Exporta também a função createOreItem diretamente neste módulo
Module.createOreItem = controlOreItem.createOreItem

return Module
