local controlGetModPath = require("shared.control-get-mod-path")
local surfaceProps = require("shared.planet-surface-properties")
local mapgenUtil = require("shared.planet-mapgen-util")
local createSpaceConnection = require("data-stage.builders.world.space-connection")

local Module = {}

--- Função principal que constrói o conjunto completo de protótipos de um planeta.
--- Retorna uma tabela com todos os protótipos prontos para data:extend().
---
--- @param name string Nome interno do planeta (ex: "desert-planet")
--- @param options table Opções do planeta
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
        map_gen = mapgenUtil.createMapGenSettings({
            autoplace_settings = options.autoplace_settings,
            cliff_settings = options.cliff_settings
        })
    end

    -- ── Protótipo do Planeta ──────────────────────────────────────────────────
    local planet_prototype = {
        type = "planet",
        name = name,
        icon = icon,
        icon_size = icon_size,
        starmap_icon = starmap_icon,
        starmap_icon_size = options.starmap_icon_size or icon_size,
        gravity_pull = options.gravity_pull or 10,
        distance = options.distance or 1,
        orientation = options.orientation or 0.25,
        magnitude = options.magnitude or 0.5,
        order = options.order or ("z[" .. name .. "]"),
        subgroup = options.subgroup or "planets",
        map_gen_settings = map_gen,
        pollutant_type = options.pollutant_type,
        solar_power_in_space = options.solar_power_in_space or 300,
        surface_properties = surface_properties,
        entities_require_heating = options.entities_require_heating or false,
        asteroid_spawn_influence = options.asteroid_spawn_influence or 1,
        draw_orbit = options.draw_orbit ~= false
    }

    if options.label then
        planet_prototype.label = options.label
    end

    local prototypes = { planet_prototype }

    -- ── Conexões Espaciais (space-connections) ────────────────────────────────
    if options.connections and type(options.connections) == "table" then
        for _, conn in ipairs(options.connections) do
            local conn_options = conn.options or {}
            local conn_proto = createSpaceConnection.createSpaceConnection(
                name,
                conn.to,
                conn.length,
                conn_options
            )
            prototypes[#prototypes + 1] = conn_proto
        end
    end

    -- ── Tecnologia de Descoberta (opcional) ───────────────────────────────────
    if options.discovery_tech then
        local tech_opt = options.discovery_tech
        local tech_icon = tech_opt.icon or
            (path_main .. "graphics/technology/planet-discovery-" .. name .. ".png")

        local discovery_tech = {
            type = "technology",
            name = "planet-discovery-" .. name,
            icons = {
                {
                    icon = "__space-age__/graphics/technology/planet-discovery.png",
                    icon_size = 256
                },
                {
                    icon = tech_icon,
                    icon_size = tech_opt.icon_size or 256
                }
            },
            essential = tech_opt.essential ~= false,
            effects = {
                {
                    type = "unlock-space-location",
                    space_location = name,
                    use_icon_overlay_constant = true
                }
            },
            prerequisites = tech_opt.prerequisites or {"space-science-pack"},
            unit = {
                count = tech_opt.count or 1000,
                ingredients = tech_opt.ingredients or {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack",   1},
                    {"chemical-science-pack",   1},
                    {"space-science-pack",      1}
                },
                time = tech_opt.time or 60
            },
            order = options.order or ("ea[" .. name .. "]")
        }

        prototypes[#prototypes + 1] = discovery_tech
    end

    return prototypes
end

return Module
