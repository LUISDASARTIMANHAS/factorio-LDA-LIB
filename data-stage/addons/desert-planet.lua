-- Addon: Desert Planet Prototype
-- Um planeta desértico de exemplo demonstrando o uso de createPlanet().
-- Para usar em outro mod, apenas copie este arquivo e adapte os parâmetros.

local createPlanet = require("data-stage.builders.world.planet")
local surfaceProps = require("shared.planet-surface-properties")
local mapgenUtil = require("shared.planet-mapgen-util")

-- ── Configuração Ambiental ────────────────────────────────────────────────────
-- Planeta árido: solo seco, temperatura elevada, alta irradiação solar,
-- poucos penhascos e sem água disponível.
local surface_properties = surfaceProps.presets.desert()

local map_gen_settings =
    mapgenUtil.createMapGenSettings(
    {
        -- Terreno levemente segmentado, sem água
        terrain_segmentation = 0.8,
        water = 0,
        -- Penhascos baixos e espaçados
        cliff_name = "cliff",
        cliff_interval = 60,
        -- Recursos minerais presentes, ajustados para o bioma
        autoplace_controls = {
            ["iron-ore"] = {frequency = 1.2, size = 0.8, richness = 1},
            ["copper-ore"] = {frequency = 1.0, size = 0.8, richness = 1},
            ["stone"] = {frequency = 2.0, size = 1.5, richness = 1.5},
            ["coal"] = {frequency = 0.5, size = 0.5, richness = 0.5},
            ["enemy-base"] = {frequency = 0.8, size = 1.0, richness = 1.0}
        },
        -- Semeia a geração para um mundo consistente de demonstração
        seed = 42
    }
)

-- ── Construção do Planeta e seus Protótipos ───────────────────────────────────
local prototypes =
    createPlanet.createPlanet(
    "desert-planet",
    {
        -- Órbita no mapa estelar
        distance = 1.5,
        orientation = 0.6,
        magnitude = 0.6,
        gravity_pull = 10,
        draw_orbit = true,
        solar_power_in_space = 200,
        order = "z[desert-planet]",
        -- Física do planeta
        surface_properties = surface_properties,
        map_gen_settings = map_gen_settings,
        pollutant_type = "pollution",
        entities_require_heating = false,
        asteroid_spawn_influence = 0.1,
        -- Rotas espaciais: conecta este planeta a Nauvis
        connections = {
            {
                to = "nauvis",
                length = 15000,
                options = {
                    asteroid_density = "medium",
                    asteroid_speed = 1
                }
            }
        },
        -- Tecnologia de descoberta necessária para o jogador viajar ao planeta
        discovery_tech = {
            prerequisites = {"space-science-pack"},
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1}
            },
            count = 1500,
            time = 60
        }
    }
)

-- Registra todos os protótipos gerados
data:extend(prototypes)
