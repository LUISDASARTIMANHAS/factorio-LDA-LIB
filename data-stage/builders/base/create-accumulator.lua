local Module = {}
local controlGetModPath = require("shared.control-get-mod-path")
local utils = require("shared.control-utils")

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

--- Resolve uma bounding box que pode ser informada como número (simétrica) ou tabela.
local function resolve_bounding_box(box, fallback)
    if type(box) == "number" then
        return utils.createBoundingBox(box)
    elseif type(box) == "table" then
        return box
    end
    return fallback
end

--- Cria um protótipo de Acumulador (type = "accumulator") modular para o Factorio 2.0+.
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

    -- ── 1. Bounding Boxes ────────────────────────────────────────────────────────
    local collision_box = resolve_bounding_box(params.collision_box, {{-0.9, -0.9}, {0.9, 0.9}})
    local selection_box = resolve_bounding_box(params.selection_box, {{-1.0, -1.0}, {1.0, 1.0}})
    local drawing_box = resolve_bounding_box(params.drawing_box, nil)

    -- ── 2. Ícones ────────────────────────────────────────────────────────────────
    local icon = params.icon
    local icons = params.icons
    local icon_size = params.icon_size
    if not icon and not icons then
        icon = path_main .. "graphics/entities/" .. name .. ".png"
        icon_size = icon_size or 128
    elseif icon and not icon_size then
        icon_size = 128
    end

    -- ── 3. Fonte de Energia (Electric Energy Source) ──────────────────────────────
    local buffer_capacity = format_energy(params.buffer_capacity, "J", "5MJ")
    local input_flow_limit = format_energy(params.input_flow_limit, "kW", "300kW")
    -- Permite expressamente "0kW" para retenção exclusiva de energia (sem saída para rede)
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

    -- ── 4. Gráficos (Estáticos ou ChargableGraphics) ──────────────────────────────
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
                        width = params.sprite_width or 128,
                        height = params.sprite_height or 128,
                        shift = params.sprite_shift or {0, 0},
                        scale = params.sprite_scale or 1
                    }
                }
            }
        end

        chargable_graphics = {
            picture = picture
        }
    end

    -- Suporte a campos de animação/luz fornecidos na raiz de params caso não estejam no chargable_graphics
    if params.charge_animation and chargable_graphics.charge_animation == nil then
        chargable_graphics.charge_animation = params.charge_animation
    end
    if params.discharge_animation and chargable_graphics.discharge_animation == nil then
        chargable_graphics.discharge_animation = params.discharge_animation
    end
    if params.charge_cooldown ~= nil and chargable_graphics.charge_cooldown == nil then
        chargable_graphics.charge_cooldown = params.charge_cooldown
    end
    if params.discharge_cooldown ~= nil and chargable_graphics.discharge_cooldown == nil then
        chargable_graphics.discharge_cooldown = params.discharge_cooldown
    end
    if params.charge_light and chargable_graphics.charge_light == nil then
        chargable_graphics.charge_light = params.charge_light
    end
    if params.discharge_light and chargable_graphics.discharge_light == nil then
        chargable_graphics.discharge_light = params.discharge_light
    end

    -- ── 5. Sons de Operação ──────────────────────────────────────────────────────
    local working_sound = nil
    if params.working_sound ~= false then
        if type(params.working_sound) == "table" then
            working_sound = params.working_sound
        else
            working_sound = {
                sound = {
                    filename = "__base__/sound/accumulator-working.ogg",
                    volume = 0.4
                },
                idle_sound = {
                    filename = "__base__/sound/accumulator-idle.ogg",
                    volume = 0.35
                },
                max_sounds_per_type = 3,
                audible_distance_modifier = 0.5,
                fade_in_ticks = 4,
                fade_out_ticks = 20
            }
        end
    end

    -- ── 6. Resistências ──────────────────────────────────────────────────────────
    local resistances = nil
    if params.resistances ~= false then
        if type(params.resistances) == "table" then
            resistances = params.resistances
        else
            resistances = {
                {type = "fire", percent = 80},
                {type = "impact", percent = 30}
            }
        end
    end

    -- ── 7. Mineração ─────────────────────────────────────────────────────────────
    local minable = nil
    if params.minable ~= false then
        if type(params.minable) == "table" then
            minable = params.minable
        else
            minable = {
                mining_time = params.mining_time or 0.2,
                result = params.minable_result or name
            }
        end
    end

    -- ── 8. Construção do Protótipo ───────────────────────────────────────────────
    local prototype = {
        type = "accumulator",
        name = name,
        flags = params.flags or {"placeable-neutral", "player-creation"},
        minable = minable,
        max_health = params.max_health or 150,
        corpse = params.corpse or "accumulator-remnants",
        dying_explosion = params.dying_explosion or "accumulator-explosion",
        collision_box = collision_box,
        selection_box = selection_box,
        drawing_box = drawing_box,
        fast_replaceable_group = params.fast_replaceable_group or "accumulator",
        impact_category = params.impact_category or "metal",
        energy_source = energy_source,
        chargable_graphics = chargable_graphics,
        picture = chargable_graphics.picture or picture,
        working_sound = working_sound,
        resistances = resistances,
        subgroup = params.subgroup or "energy",
        order = params.order or ("e[accumulator]-a[" .. name .. "]"),
        default_output_signal = params.default_output_signal or {type = "virtual", name = "signal-A"},
        circuit_wire_max_distance = params.circuit_wire_max_distance or 9,
        open_sound = params.open_sound or {filename = "__base__/sound/open-close/electric-large-open.ogg", volume = 0.6},
        close_sound = params.close_sound or {filename = "__base__/sound/open-close/electric-large-close.ogg", volume = 0.6}
    }

    if icon then
        prototype.icon = icon
        prototype.icon_size = icon_size
    elseif icons then
        prototype.icons = icons
    end

    if params.circuit_connector ~= nil then
        prototype.circuit_connector = params.circuit_connector
    end
    if params.circuit_wire_connection_point ~= nil then
        prototype.circuit_wire_connection_point = params.circuit_wire_connection_point
    end
    if params.circuit_connector_sprites ~= nil then
        prototype.circuit_connector_sprites = params.circuit_connector_sprites
    end
    if params.damaged_trigger_effect ~= nil then
        prototype.damaged_trigger_effect = params.damaged_trigger_effect
    end
    if params.water_reflection ~= nil then
        prototype.water_reflection = params.water_reflection
    end
    if params.collision_mask ~= nil then
        prototype.collision_mask = params.collision_mask
    end

    -- Permite mesclar quaisquer outras propriedades personalizadas passadas pelo mod
    if type(params.extra_props) == "table" then
        prototype = utils.tableMerge(prototype, params.extra_props, true)
    end

    return prototype
end

return Module

