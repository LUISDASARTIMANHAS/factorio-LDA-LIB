local BaseEntity = require("data-stage.builders.entities.base")
local controlGetModPath = require("shared.control-get-mod-path")
local Module = {}

--- Cria uma entidade padrão personalizável.
--- Herda a implementação de BaseEntity.createBaseEntity.
---
--- Usage:
--- ```lua
--- local entity = LDA.createEntity("solar-panel", "advanced-solar-panel", "production")
--- ```
---
--- @param typeEntity string Tipo do protótipo (ex: "solar-panel", "electric-pole")
--- @param name string Nome da entidade
--- @param subgroup string|nil Subgrupo da entidade
--- @param stack_size number|nil Tamanho da pilha do item correspondente
--- @param options table|nil Opções adicionais de configuração
--- @return table EntityPrototype
function Module.createEntity(typeEntity, name, subgroup, stack_size, options)
    local opts = options or {}
    local path_main = controlGetModPath.getModPath()
    local icon_path = opts.icon or (path_main .. "graphics/entities/" .. name .. ".png")

    local entity = BaseEntity.createBaseEntity({
        type = typeEntity,
        name = name,
        icon = icon_path,
        icon_size = opts.icon_size or 128,
        flags = opts.flags or {"placeable-neutral", "player-creation"},
        minable = opts.minable or {hardness = 0.2, mining_time = 1, result = opts.minable_result or name},
        fast_replaceable_group = opts.fast_replaceable_group or (typeEntity == "solar-panel" and "solar-panel" or nil),
        max_health = opts.max_health or 200,
        corpse = opts.corpse or "big-remnants",
        dying_explosion = opts.dying_explosion or "big-explosion",
        selection_box = opts.selection_box or {{-1.2, -1.2}, {1.2, 1.2}},
        collision_box = opts.collision_box or {{-1.0, -1.0}, {1.0, 1.0}},
        subgroup = subgroup or opts.subgroup,
        extra = opts.extra
    })

    -- Se for do tipo solar-panel ou se forneceu picture, adiciona os gráficos e produção padrão
    if typeEntity == "solar-panel" or opts.production then
        entity.energy_source = opts.energy_source or {
            type = "electric",
            usage_priority = "solar"
        }
        entity.production = opts.production or "360kW"
        entity.impact_category = opts.impact_category or "glass"
    end

    if opts.picture then
        entity.picture = opts.picture
    elseif typeEntity == "solar-panel" then
        entity.picture = {
            layers = {
                {
                    filename = icon_path,
                    priority = "high",
                    size = 128,
                    shift = util and util.by_pixel(-3, 3.5) or {-0.1, 0.1},
                    scale = 2
                },
                {
                    filename = icon_path,
                    priority = "high",
                    size = 128,
                    shift = util and util.by_pixel(9.5, 6) or {0.3, 0.2},
                    draw_as_shadow = true,
                    scale = 2
                }
            }
        }
    end

    return entity
end

return Module
