# Utilitários de Espaço e Planetas (Space Age)

Este documento descreve os recursos da **LDA-LIB** para criação de planetas, geração de superfícies e rotas espaciais no Factorio 2.0+ (com suporte à expansão *Space Age*).

---

## Sumário

1. [Criação de Planetas](#1-criação-de-planetas)
   - [LDA.createPlanet](#ldacreateplanet)
2. [Propriedades de Superfície](#2-propriedades-de-superfície)
   - [LDA.createSurfaceProperties](#ldacreatesurfaceproperties)
   - [LDA.surfacePropertiesPresets](#ldasurfacepropertiespresets)
3. [Geração de Terreno e Penhascos](#3-geração-de-terreno-e-penhascos)
   - [LDA.createMapGenSettings](#ldacreatemapgensettings)
   - [LDA.createCliffSettings](#ldacreatecliffsettings)
4. [Conexões Espaciais e Asteroides](#4-conexões-espaciais-e-asteroides)
   - [LDA.createSpaceConnection](#ldacreatespaceconnection)
   - [LDA.generateAsteroidSpawns](#ldagenerateasteroidspawns)

---

## 1. Criação de Planetas

### `LDA.createPlanet`
Constrói o conjunto completo de protótipos de um planeta: a entidade de mapa estelar (`type = "planet"`), as rotas espaciais especificadas e a tecnologia de descoberta orbital:

```lua
local planeta_completo = LDA.createPlanet("planeta-deserto", {
    icon_size = 256,
    distance = 18,
    orientation = 0.45,
    magnitude = 0.8,
    gravity_pull = 12,
    surface_properties = LDA.createSurfaceProperties({
        gravity = 11,
        pressure = 1800,
        temperature = 315,
        solar_power = 300
    }),
    map_gen_settings = LDA.createMapGenSettings({
        terrain_segmentation = 1.2,
        water = 0.3,
        cliff_settings = LDA.createCliffSettings("cliff", 40, 10),
        autoplace_controls = {
            ["iron-ore"] = { frequency = 2, size = 1.5, richness = 2 }
        }
    }),
    connections = {
        { to = "nauvis", length = 20000, options = { asteroid_density = "medium" } }
    },
    discovery_tech = {
        prerequisites = {"space-science-pack"},
        ingredients = {{"space-science-pack", 1}},
        time = 60,
        count = 500
    }
})

data:extend(planeta_completo)
```

---

## 2. Propriedades de Superfície

### `LDA.createSurfaceProperties`
Configura gravidade, pressão, campo magnético, temperatura e energia solar de uma superfície:

```lua
local propriedades = LDA.createSurfaceProperties({
    gravity = 14,
    pressure = 2000,
    temperature = 320,
    solar_power = 250,
    magnetic_field = 120
})
```

### `LDA.surfacePropertiesPresets`
Predefinições inspiradas nos ambientes do Space Age:

```lua
local vulcanus = LDA.surfacePropertiesPresets.volcanic()
local fulgora  = LDA.surfacePropertiesPresets.lightning()
local gleba    = LDA.surfacePropertiesPresets.swamp()
local aquilo   = LDA.surfacePropertiesPresets.frozen()
local nauvis   = LDA.surfacePropertiesPresets.temperate()
```

---

## 3. Geração de Terreno e Penhascos

### `LDA.createMapGenSettings`
Monta e valida a estrutura `PlanetPrototypeMapGenSettings`:

```lua
local map_gen = LDA.createMapGenSettings({
    terrain_segmentation = 1.5,
    water = 0.5,
    cliff_interval = 30,
    autoplace_controls = {
        ["iron-ore"] = { frequency = 1.5, size = 1, richness = 2 },
        ["copper-ore"] = 1.2
    }
})
```

### `LDA.createCliffSettings`
Define a frequência e elevação inicial de penhascos (cliffs):

```lua
local cliffs = LDA.createCliffSettings(
    "cliff-vulcanus",  -- Entidade de penhasco
    30,                -- Intervalo vertical entre níveis
    15                 -- Elevação inicial
)
```

---

## 4. Conexões Espaciais e Asteroides

### `LDA.createSpaceConnection`
Cria uma rota espacial (`space-connection`) entre dois corpos celestes:

```lua
local rota = LDA.createSpaceConnection(
    "nauvis",
    "planeta-deserto",
    25000,  -- Comprimento da viagem
    {
        asteroid_density = "high" -- "none", "low", "medium", "high", "extreme"
    }
)

data:extend({ rota })
```

### `LDA.generateAsteroidSpawns`
Gera a tabela de probabilidades de surgimento e velocidade de asteroides ao longo da rota:

```lua
local spawns = LDA.generateAsteroidSpawns("extreme", 2.0)
```
