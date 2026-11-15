local utils = require("shared.control-utils")
local controlGetModPath = require("shared.control-get-mod-path")
local Module = {}

--- Resolve uma bounding box que pode ser informada como número (simétrica) ou tabela.
local function resolve_bounding_box(box, fallback)
    if type(box) == "number" then
        return utils.createBoundingBox(box)
    elseif type(box) == "table" then
        return box
    end
    return fallback
end

--- Cria um protótipo base genérico de entidade (EntityPrototype).
--- Raiz de herança para todos os protótipos de entidades do Factorio 2.0+.
---
--- Usage:
--- ```lua
--- local entity = LDA.createBaseEntity({
---     type = "solar-panel",
---     name = "advanced-solar-panel",
---     max_health = 300,
---     collision_box = 1.0,
---     selection_box = 1.2
--- })
--- ```
---
--- @param params table Configurações da entidade
--- @return table EntityPrototype
function Module.createBaseEntity(params)
    if type(params) ~= "table" or not params.name or not params.type then
        error("[LDA-LIB] [createBaseEntity] Campos 'name' e 'type' são obrigatórios.")
    end

    local name = params.name
    local entity_type = params.type
    local path_main = controlGetModPath.getModPath()

    local icon = params.icon
    local icons = params.icons
    local icon_size = params.icon_size
    if not icon and not icons then
        icon = path_main .. "graphics/entities/" .. name .. ".png"
        icon_size = icon_size or 128
    elseif icon and not icon_size then
        icon_size = 128
    end

    local collision_box = resolve_bounding_box(params.collision_box, {{-0.9, -0.9}, {0.9, 0.9}})
    local selection_box = resolve_bounding_box(params.selection_box, {{-1.0, -1.0}, {1.0, 1.0}})
    local drawing_box = resolve_bounding_box(params.drawing_box, nil)

    local minable = params.minable
    if minable == nil then
        minable = {
            mining_time = params.mining_time or 1,
            result = params.minable_result or name
        }
    end

    local entity_data = {
        type = entity_type,
        name = name,
        icon = icon,
        icons = icons,
        icon_size = icon_size,
        flags = params.flags or {"placeable-neutral", "player-creation"},
        minable = minable,
        max_health = params.max_health or 200,
        corpse = params.corpse or "medium-remnants",
        dying_explosion = params.dying_explosion or "medium-explosion",
        collision_box = collision_box,
        selection_box = selection_box,
        drawing_box = drawing_box,
        subgroup = params.subgroup,
        order = params.order,
        resistances = params.resistances,
        damaged_trigger_effect = params.damaged_trigger_effect,
        fast_replaceable_group = params.fast_replaceable_group
    }

    if params.extra and type(params.extra) == "table" then
        utils.tableMerge(entity_data, params.extra, true)
    end

    return entity_data
end

return Module
