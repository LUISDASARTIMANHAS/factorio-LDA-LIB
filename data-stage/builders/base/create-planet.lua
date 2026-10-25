local controlGetModPath = require("shared.control-get-mod-path")
local surfaceProps = require("shared.planet-surface-properties")
local mapgenUtil = require("shared.planet-mapgen-util")
local createSpaceConnection = require("data-stage.builders.base.create-space-connection")

local Module = {}

--- Função principal que constrói o conjunto completo de protótipos de um planeta.
--- Retorna uma tabela com todos os protótipos prontos para data:extend().
---
--- @param name string  Nome interno do planeta (ex: "desert-planet")
--- @param options table {
---   label = string|nil          Chave locale para nome exibido (padrão = name)
---   icon = string|nil           Caminho completo do ícone (usa graphics/icons/<name>.png se nil)
---   icon_size = number|nil      Tamanho do ícone (padrão 256)
---   starmap_icon = string|nil   Ícone separado para o mapa estelar
---   order = string|nil          Ordem no mapa estelar (padrão "z[<name>]")
---   distance = number|nil       Distância orbital a partir da origem (padrão 1)
---   orientation = number|nil    Ângulo em relação à origem 0.0..1.0 (padrão 0.25)
---   magnitude = number|nil      Tamanho visual no mapa estelar (padrão 0.5)
---   gravity_pull = number|nil   Pull gravitacional na velocidade de plataformas (padrão 10)
---   draw_orbit = boolean|nil    Desenha a órbita no starmap (padrão true)
---   solar_power_in_space = number|nil
---   surface_properties = table|nil      surface_properties (usa preset temperate se nil)
---   map_gen_settings = table|nil        PlanetPrototypeMapGenSettings (usa default se nil)
---   entities_require_heating = boolean|nil
---   pollutant_type = string|nil
---   asteroid_spawn_influence = number|nil
---   connections = table[]|nil   Lista de {to = "nome", length = number, options = table}
---   discovery_tech = table|nil  {prerequisites = table, ingredients = table, time = number, count = number}
--- }
--- @return table[] Array de protótipos (planet, space-connections, technology opcionalmente)
function Module.createPlanet(name, options)
    options = options or {}
    local path_main = controlGetModPath.getModPath()

    -- ── Ícone ────────────────────────────────────────────────────────────────
    local icon = options.icon or (path_main .. "graphics/icons/planets/" .. name .. ".png")
    local starmap_icon = options.starmap_icon or icon
    local icon_size = options.icon_size or 256

    -- ── Propriedades de Superfície ────────────────────────────────────────────
    local surface_properties = options.surface_properties
    if not surface_properties then
        surface_properties = surfaceProps.presets.temperate()
    end

    -- ── Geração de Mapa ───────────────────────────────────────────────────────
    local map_gen = options.map_gen_settings
    if not map_gen then
        map_gen = mapgenUtil.createMapGenSettings({})
    end

    -- ── Protótipo do Planeta ──────────────────────────────────────────────────
    local planet = {
        type = "planet",
        name = name,
        icon = icon,
        icon_size = icon_size,
        starmap_icon = starmap_icon,
        starmap_icon_size = options.starmap_icon_size or icon_size,
        subgroup = options.subgroup or "planets",
        order = options.order or ("z[" .. name .. "]"),

        -- Órbita
        distance = options.distance or 1,
        orientation = options.orientation or 0.25,
        magnitude = options.magnitude or 0.5,
        gravity_pull = options.gravity_pull or 10,
        draw_orbit = options.draw_orbit ~= false,
        solar_power_in_space = options.solar_power_in_space or 100,

        -- Configurações específicas de planeta
        surface_properties = surface_properties,
        map_gen_settings = map_gen,

        -- Opcionais do Space Age
        entities_require_heating = options.entities_require_heating or false,
        asteroid_spawn_influence = options.asteroid_spawn_influence or 0,
    }

    if options.pollutant_type then
        planet.pollutant_type = options.pollutant_type
    end

    -- ── Coleta de Todos os Protótipos ─────────────────────────────────────────
    local prototypes = {planet}

    -- ── Conexões Espaciais ────────────────────────────────────────────────────
    if options.connections then
        for _, conn in ipairs(options.connections) do
            local connection = createSpaceConnection.createSpaceConnection(
                name,
                conn.to,
                conn.length,
                conn.options or {}
            )
            table.insert(prototypes, connection)
        end
    end

    -- ── Tecnologia de Descoberta ──────────────────────────────────────────────
    if options.discovery_tech then
        local tech = options.discovery_tech
        local discovery_name = "planet-discovery-" .. name

        local technology = {
            type = "technology",
            name = discovery_name,
            icon = tech.icon or (path_main .. "graphics/technology/" .. discovery_name .. ".png"),
            icon_size = tech.icon_size or 256,
            prerequisites = tech.prerequisites or {},
            effects = {
                {
                    type = "unlock-space-location",
                    space_location = name,
                    use_icon_overlay_constant = true
                }
            },
            unit = {
                count = tech.count or 1000,
                time = tech.time or 60,
                ingredients = tech.ingredients or {
                    {"automation-science-pack", 1}
                }
            },
            order = "z-" .. name
        }

        if tech.effects then
            for _, effect in ipairs(tech.effects) do
                table.insert(technology.effects, effect)
            end
        end

        table.insert(prototypes, technology)
    end

    return prototypes
end

return Module

