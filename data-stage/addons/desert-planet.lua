-- Addon: Desert Planet Prototype
-- Um planeta desértico de exemplo demonstrando o uso de createPlanet().
-- Para usar em outro mod, apenas copie este arquivo e adapte os parâmetros.

local createPlanet = require("data-stage.builders.base.create-planet")
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




-- {
--     type = "planet",
--     name = "fulgora",
--     icon = "__space-age__/graphics/icons/fulgora.png",
--     starmap_icon = "__space-age__/graphics/icons/starmap-planet-fulgora.png",
--     starmap_icon_size = 512,
--     gravity_pull = 10,
--     distance = 25,
--     orientation = 0.325,
--     magnitude = 0.9,
--     label_orientation = 0.35,
--     order = "d[fulgora]",
--     subgroup = "planets",
--     map_gen_settings = planet_map_gen.fulgora(),
--     pollutant_type = nil,
--     solar_power_in_space = 120,
--     platform_procession_set =
--     {
--       arrival = {"planet-to-platform-b", "platform-to-platform-b"},
--       departure = {"platform-to-planet-a", "platform-to-platform-a"}
--     },
--     planet_procession_set =
--     {
--       arrival = {"platform-to-planet-b"},
--       departure = {"planet-to-platform-a"}
--     },
--     procession_graphic_catalogue = planet_catalogue_fulgora,
--     surface_properties =
--     {
--       ["day-night-cycle"] = 3 * minute,
--       ["magnetic-field"] = 99,
--       ["solar-power"] = 20,
--       pressure = 800,
--       gravity = 8
--     },
--     lightning_properties =
--     {
--       lightnings_per_chunk_per_tick = 1 / (60 * 10), --cca once per chunk every 10 seconds (600 ticks)
--       search_radius = 10.0,
--       lightning_types = {"lightning"},
--       priority_rules =
--       {
--         {
--           type = "id",
--           string = "lightning-collector",
--           priority_bonus = 10000
--         },
--         {
--           type = "prototype",
--           string = "lightning-attractor",
--           priority_bonus = 1000
--         },
--         {
--           type = "id",
--           string = "fulgoran-ruin-vault",
--           priority_bonus = 95
--         },
--         {
--           type = "id",
--           string = "fulgoran-ruin-colossal",
--           priority_bonus = 94
--         },
--         {
--           type = "id",
--           string = "fulgoran-ruin-huge",
--           priority_bonus = 93
--         },
--         {
--           type = "id",
--           string = "fulgoran-ruin-big",
--           priority_bonus = 92
--         },
--         {
--           type = "id",
--           string = "fulgoran-ruin-medium",
--           priority_bonus = 91
--         },
--         {
--           type = "prototype",
--           string = "pipe",
--           priority_bonus = 1
--         },
--         {
--           type = "prototype",
--           string = "pump",
--           priority_bonus = 1
--         },
--         {
--           type = "prototype",
--           string = "offshore-pump",
--           priority_bonus = 1
--         },
--         {
--           type = "prototype",
--           string = "electric-pole",
--           priority_bonus = 10
--         },
--         {
--           type = "prototype",
--           string = "power-switch",
--           priority_bonus = 10
--         },
--         {
--           type = "prototype",
--           string = "logistic-robot",
--           priority_bonus = 100
--         },
--         {
--           type = "prototype",
--           string = "construction-robot",
--           priority_bonus = 100
--         },
--         {
--           type = "impact-soundset",
--           string = "metal",
--           priority_bonus = 1
--         }
--       },
--       exemption_rules =
--       {
--         {
--           type = "prototype",
--           string = "rail-support",
--         },
--         {
--           type = "prototype",
--           string = "legacy-straight-rail",
--         },
--         {
--           type = "prototype",
--           string = "legacy-curved-rail",
--         },
--         {
--           type = "prototype",
--           string = "straight-rail",
--         },
--         {
--           type = "prototype",
--           string = "curved-rail-a",
--         },
--         {
--           type = "prototype",
--           string = "curved-rail-b",
--         },
--         {
--           type = "prototype",
--           string = "half-diagonal-rail",
--         },
--         {
--           type = "prototype",
--           string = "rail-ramp",
--         },
--         {
--           type = "prototype",
--           string = "elevated-straight-rail",
--         },
--         {
--           type = "prototype",
--           string = "elevated-curved-rail-a",
--         },
--         {
--           type = "prototype",
--           string = "elevated-curved-rail-b",
--         },
--         {
--           type = "prototype",
--           string = "elevated-half-diagonal-rail",
--         },
--         {
--           type = "prototype",
--           string = "rail-signal",
--         },
--         {
--           type = "prototype",
--           string = "rail-chain-signal",
--         },
--         {
--           type = "prototype",
--           string = "locomotive",
--         },
--         {
--           type = "prototype",
--           string = "artillery-wagon",
--         },
--         {
--           type = "prototype",
--           string = "cargo-wagon",
--         },
--         {
--           type = "prototype",
--           string = "fluid-wagon",
--         },
--         {
--           type = "prototype",
--           string = "land-mine",
--         },
--         {
--           type = "prototype",
--           string = "wall",
--         },
--         {
--           type = "prototype",
--           string = "tree",
--         },
--         {
--           type = "countAsRockForFilteredDeconstruction",
--           string = "true",
--         },
--         {
--           type = "prototype",
--           string = "cargo-pod"
--         },
--         {
--           type = "id",
--           string = "cargo-pod-container",
--         }
--       }
--     },
--     surface_render_parameters =
--     {
--       clouds =
--       {
--         shape_noise_texture =
--         {
--           filename = "__core__/graphics/clouds-noise.png",
--           color_channels = 3,
--           size = 2048
--         },
--         detail_noise_texture =
--         {
--           filename = "__core__/graphics/clouds-detail-noise.png",
--           color_channels = 1,
--           size = 2048
--         },

--         warp_sample_1 = { scale = 0.8 / 16 },
--         warp_sample_2 = { scale = 3.75 * 0.8 / 32, wind_speed_factor = 0 },
--         warped_shape_sample = { scale = 2 * 0.18 / 32 },
--         additional_density_sample = { scale = 1.5 * 0.18 / 32, wind_speed_factor = 1.77 },
--         detail_sample_1 = { scale = 1.709 / 32, wind_speed_factor = 0.2 / 1.709 },
--         detail_sample_2 = { scale = 2.179 / 32, wind_speed_factor = 0.33 / 2.179 },

--         scale = 1,
--         movement_speed_multiplier = 0.75,
--         opacity = 0.25,
--         opacity_at_night = 0.25,
--         density_at_night = 1,
--         detail_factor = 1.5,
--         detail_factor_at_night = 2,
--         shape_warp_strength = 0.06,
--         shape_warp_weight = 0.4,
--         detail_sample_morph_duration = 0,
--       },

--       -- Should be based on the default day/night times, ie
--       -- sun starts to set at 0.25
--       -- sun fully set at 0.45
--       -- sun starts to rise at 0.55
--       -- sun fully risen at 0.75
--       -- On fulgora night looks a bit longer to look right with the lightning.
--       day_night_cycle_color_lookup =
--       {
--         {0.0, "__space-age__/graphics/lut/fulgora-1-noon.png"},
--         {0.2, "__space-age__/graphics/lut/fulgora-1-noon.png"},
--         {0.3, "__space-age__/graphics/lut/fulgora-2-afternoon.png"},
--         {0.4, "__space-age__/graphics/lut/fulgora-3-after-sunset.png"},
--         {0.6, "__space-age__/graphics/lut/fulgora-4-before-dawn.png"},
--         {0.7, "__space-age__/graphics/lut/fulgora-5-morning.png"},
--       },

--       terrain_tint_effect =
--       {
--         noise_texture =
--         {
--           filename = "__space-age__/graphics/terrain/vulcanus/tint-noise.png",
--           color_channels = 3,
--           size = 4096
--         },

--         offset = { 0.2, 0, 0.4, 0.8 },
--         intensity = { 0.4, 0.4, 0.4, 0.7 },
--         scale_u = { 1.1, 1.85, 1.85, 0.5 },
--         scale_v = { 0.45, 1, 1, 0.7 },

--         global_intensity = 0.3,
--         global_scale = 0.25,
--         zoom_factor = 3.8,
--         zoom_intensity = 0.75
--       }
--     },
--     asteroid_spawn_influence = 1,
--     asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.nauvis_fulgora, 0.9),
--     persistent_ambient_sounds =
--     {
--       base_ambience = {filename = "__space-age__/sound/wind/base-wind-fulgora.ogg", volume = 0.5},
--       wind = {filename = "__space-age__/sound/wind/wind-fulgora.ogg", volume = 0.8},
--       crossfade =
--       {
--         order = {"wind", "base_ambience"},
--         curve_type = "cosine",
--         from = {control = 0.35, volume_percentage = 0.0},
--         to = {control = 2, volume_percentage = 100.0}
--       },
--       semi_persistent =
--       {
--         {
--           sound = {variations = sound_variations("__space-age__/sound/world/semi-persistent/distant-thunder", 4, 0.6)},
--           delay_mean_seconds = 33,
--           delay_variance_seconds = 7
--         },
--         {
--           sound =
--           {
--             variations = sound_variations("__space-age__/sound/world/semi-persistent/sand-wind-gust", 5, 0.45),
--             advanced_volume_control =
--             {
--               fades = {fade_in = {curve_type = "cosine", from = {control = 0.5, volume_percentage = 0.0}, to = {1.5, 100.0}}}
--             }
--           },
--           delay_mean_seconds = 15,
--           delay_variance_seconds = 9,
--         },
--       }
--     }
--   },