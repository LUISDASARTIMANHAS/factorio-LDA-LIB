local BaseEntity = require("data-stage.builders.entities.base")
local controlGetModPath = require("shared.control-get-mod-path")
local utils = require("shared.control-utils")

local Module = {}

--- Converte ou formata valores numéricos para strings de energia válidas do Factorio.
local function format_energy(value, default_unit, fallback)
    if value == nil then
        return fallback
    end
    if type(value) == "number" then
        return tostring(value) .. (default_unit or "kW")
    end
    if type(value) == "string" then
        return value
    end
    return fallback
end

--- Cria um protótipo de Acumulador (type = "accumulator") modular para o Factorio 2.0+.
--- Herda a implementação de BaseEntity.createBaseEntity.
---
--- Usage:
--- ```lua
--- local acc = LDA.createAccumulator({
---     name = "super-accumulator",
---     buffer_capacity = "50MJ",
---     input_flow_limit = "1MW",
---     output_flow_limit = "1MW"
--- })
--- ```
---
--- @param name_or_params string|table Nome da entidade ou tabela com todos os parâmetros.
--- @param maybe_params table|nil Parâmetros adicionais quando o 1º argumento for o nome.
--- @return table Protótipo da entidade accumulator pronto para ser estendido em data:extend().
function Module.createAccumulator(name_or_params, maybe_params)
    local params = {}
    if type(name_or_params) == "table" then
        params = name_or_params
    elseif type(name_or_params) == "string" then
        params = maybe_params or {}
        params.name = name_or_params
    else
        error("[LDA-LIB] [createAccumulator] Parâmetros inválidos. Esperado nome (string) ou tabela de configurações.")
    end

    local name = params.name
    if not name or name == "" then
        error("[LDA-LIB] [createAccumulator] Campo 'name' é obrigatório para construir o protótipo do acumulador.")
    end

    local path_main = controlGetModPath.getModPath()

    -- ── 1. Herança: BaseEntity ───────────────────────────────────────────────────
    local entity = BaseEntity.createBaseEntity({
        type = "accumulator",
        name = name,
        icon = params.icon,
        icons = params.icons,
        icon_size = params.icon_size,
        collision_box = params.collision_box or {{-0.9, -0.9}, {0.9, 0.9}},
        selection_box = params.selection_box or {{-1.0, -1.0}, {1.0, 1.0}},
        drawing_box = params.drawing_box,
        flags = params.flags or {"placeable-neutral", "player-creation"},
        minable = params.minable or {
            mining_time = params.mining_time or 0.1,
            result = params.minable_result or name
        },
        max_health = params.max_health or 150,
        corpse = params.corpse or "accumulator-remnants",
        dying_explosion = params.dying_explosion or "accumulator-explosion",
        damaged_trigger_effect = params.damaged_trigger_effect,
        fast_replaceable_group = params.fast_replaceable_group or "accumulator",
        subgroup = params.subgroup,
        order = params.order,
        resistances = params.resistances,
        extra = params.extra
    })

    -- ── 2. Fonte de Energia (Electric Energy Source) ──────────────────────────────
    local buffer_capacity = format_energy(params.buffer_capacity, "J", "5MJ")
    local input_flow_limit = format_energy(params.input_flow_limit, "kW", "300kW")
    local output_flow_limit = format_energy(params.output_flow_limit, "kW", "300kW")
    local usage_priority = params.usage_priority or "tertiary"

    local energy_source = {
        type = "electric",
        buffer_capacity = buffer_capacity,
        usage_priority = usage_priority,
        input_flow_limit = input_flow_limit,
        output_flow_limit = output_flow_limit
    }

    if params.drain ~= nil then
        energy_source.drain = format_energy(params.drain, "kW", "0kW")
    end

    if type(params.energy_source) == "table" then
        energy_source = utils.tableMerge(energy_source, params.energy_source, true)
    end
    entity.energy_source = energy_source

    -- ── 3. Gráficos (Estáticos ou ChargableGraphics) ──────────────────────────────
    local chargable_graphics = params.chargable_graphics
    local picture = params.picture

    if not chargable_graphics then
        if not picture then
            local sprite_path = params.sprite_path or params.sprite or (path_main .. "graphics/entities/" .. name .. ".png")
            picture = {
                layers = {
                    {
                        filename = sprite_path,
                        priority = "extra-high",
                        width = params.sprite_width or 130,
                        height = params.sprite_height or 189,
                        line_length = params.line_length or 1,
                        repeat_count = 1,
                        shift = params.sprite_shift or util.by_pixel(0, -11),
                        scale = params.scale or 0.5
                    }
                }
            }
        end
        entity.picture = picture
    else
        entity.chargable_graphics = chargable_graphics
    end

    -- ── 4. Áudio e Sons de Operação ──────────────────────────────────────────────
    if params.working_sound then
        entity.working_sound = params.working_sound
    end

    if params.open_sound then
        entity.open_sound = params.open_sound
    end

    if params.close_sound then
        entity.close_sound = params.close_sound
    end

    -- ── 5. Conexões com Circuito Lógico (Circuit Network) ────────────────────────
    if params.circuit_wire_connection_points then
        entity.circuit_wire_connection_points = params.circuit_wire_connection_points
    elseif circuit_connector_definitions and circuit_connector_definitions["accumulator"] then
        entity.circuit_wire_connection_points = circuit_connector_definitions["accumulator"].points
    end

    if params.circuit_connector_sprites then
        entity.circuit_connector_sprites = params.circuit_connector_sprites
    elseif circuit_connector_definitions and circuit_connector_definitions["accumulator"] then
        entity.circuit_connector_sprites = circuit_connector_definitions["accumulator"].sprites
    end

    entity.circuit_wire_max_distance = params.circuit_wire_max_distance or default_circuit_wire_max_distance

    if params.default_output_signal then
        entity.default_output_signal = params.default_output_signal
    else
        entity.default_output_signal = {type = "virtual", name = "signal-A"}
    end

    return entity
end

return Module
