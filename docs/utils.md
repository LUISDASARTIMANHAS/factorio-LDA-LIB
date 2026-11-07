# Utilitários Compartilhados (shared / LDA.utils*)

Este documento detalha todos os utilitários compartilhados da **LDA-LIB** para manipulação de animações, fontes de energia, resistências, bounding boxes, áudios, imagens e efeitos visuais.

---

## Sumário

1. [Configuração de Caminho](#1-configuração-de-caminho)
   - [LDA.setBasePath](#ldasetbasepath)
   - [LDA.getBasePath](#ldagetbasepath)
2. [Animações e Sprites (`LDA.utilsAnimations`)](#2-animações-e-sprites-ldautilsanimations)
   - [createLayer](#createlayer)
   - [createAnimationLayer](#createanimationlayer)
   - [createAnimation](#createanimation)
   - [createGraphicsSet](#creategraphicsset)
   - [createWaterReflection](#createwaterreflection)
3. [Fontes de Energia e Caixas de Fluido (`LDA.utilsEnergySource`)](#3-fontes-de-energia-e-caixas-de-fluido-ldautilsenergysource)
   - [createPipeConnection](#createpipeconnection)
   - [createFluidBox](#createfluidbox)
   - [createBurnerEnergySource](#createburnerenergysource)
   - [createElectricEnergySource](#createelectricenergysource)
   - [createFluidEnergySource](#createfluidenergysource)
   - [createHeatEnergySource](#createheatenergysource)
   - [createVoidEnergySource](#createvoidenergysource)
4. [Utilitários Gerais, Bounding Box e Áudio (`LDA.utils`)](#4-utilitários-gerais-bounding-box-e-áudio-ldautils)
   - [array_contains](#array_contains)
   - [tableMerge](#tablemerge)
   - [createBoundingBox](#createboundingbox)
   - [createModuleSpec](#createmodulespec)
   - [createResistance](#createresistance)
   - [getFullResistance](#getfullresistance)
   - [getRandomPositionAround](#getrandompositionaround)
   - [getAudio](#getaudio)
   - [getSequentialAudioList](#getsequentialaudiolist)
   - [Sons Ambientes (CreateBaseAmbientSound, CreateInterludeAmbientSound, CreateMenuAmbientSound)](#sons-ambientes)
   - [Imagens e Sprites (getPicture, getSequentialPictureList)](#imagens-e-sprites)
5. [Efeitos Ambientais In-Game (`LDA.utilsAmbientEffects`)](#5-efeitos-ambientais-in-game-ldautilsambienteffects)
   - [createExplosion](#createexplosion)
   - [createCrashFire](#createcrashfire)
   - [createSecondaryExplosions](#createsecondaryexplosions)
   - [createScorchmark](#createscorchmark)
6. [Utilitários de Tecnologia (`LDA.techUtils`)](#6-utilitários-de-tecnologia-ldatechutils)
   - [createEffectsUnlocksRecipes](#createeffectsunlocksrecipes)

---

## 1. Configuração de Caminho

### `LDA.setBasePath`
Define o mod consumidor para que imagens e sons sejam resolvidos automaticamente:
```lua
LDA.setBasePath("meu-mod")
```

### `LDA.getBasePath`
Recupera o prefixo formatado (ex: `"__meu-mod__/"`):
```lua
local path = LDA.getBasePath()
```

---

## 2. Animações e Sprites (`LDA.utilsAnimations`)

### `createLayer`
Cria uma camada de animação básica:
```lua
local layer = LDA.utilsAnimations.createLayer(
    "__meu-mod__/graphics/entities/maquina.png",
    128,   -- Largura
    128,   -- Altura
    16,    -- frame_count
    8,     -- line_length
    {0, 0},-- shift
    0.5,   -- scale
    false, -- draw_as_shadow
    "high" -- priority
)
```

### `createAnimationLayer`
Gera automaticamente a versão em alta resolução (`hr_version`):
```lua
local anim_layer = LDA.utilsAnimations.createAnimationLayer(
    "__meu-mod__/graphics/entities/reator", -- Sem extensão .png
    128,
    128,
    0.5,  -- hr_scale
    {0, 0},
    false,
    {frame_count = 8, line_length = 4}
)
```

### `createAnimation`
Encapsula uma camada ou tabela de camadas na estrutura `{ layers = { ... } }`:
```lua
local animacao = LDA.utilsAnimations.createAnimation(anim_layer)
```

### `createGraphicsSet`
Cria o conjunto gráfico compatível com Factorio 2.0+:
```lua
local graphics_set = LDA.utilsAnimations.createGraphicsSet(
    0.25, -- animation_progress
    nil,  -- frozen_patch
    true, -- always_draw_idle_animation
    true  -- reset_animation_when_frozen
)
```

### `createWaterReflection`
Gera a definição de reflexão da entidade na água:
```lua
local reflexao = LDA.utilsAnimations.createWaterReflection(
    "__meu-mod__/graphics/entities/barco-reflexao",
    true,  -- rotate
    false, -- orientation_to_variation
    3,     -- end_index
    64,    -- size
    0.5,   -- scale
    4      -- mipmap_count
)
```

---

## 3. Fontes de Energia e Caixas de Fluido (`LDA.utilsEnergySource`)

### `createPipeConnection` & `createFluidBox`
```lua
local entrada = LDA.utilsEnergySource.createPipeConnection(
    "input",
    defines.direction.north,
    {0, -1}
)

local saida = LDA.utilsEnergySource.createPipeConnection(
    "output",
    defines.direction.south,
    {0, 1}
)

local fluid_box = LDA.utilsEnergySource.createFluidBox(
    1000,
    "water",
    "input-output",
    {entrada, saida}
)
```

### Fontes de Energia
```lua
-- Burner (combustível sólido):
local burner = LDA.utilsEnergySource.createBurnerEnergySource(1, 0.9, {"chemical"})

-- Electric (rede elétrica):
local electric = LDA.utilsEnergySource.createElectricEnergySource("secondary-input", "10MJ", "2MW")

-- Fluid (combustível líquido):
local fluid_energy = LDA.utilsEnergySource.createFluidEnergySource(500, {entrada}, "crude-oil", 0.85, true)

-- Heat (calor/térmico):
local heat_energy = LDA.utilsEnergySource.createHeatEnergySource(1000, "1MJ", "20MW")

-- Void (sem custo de rede):
local void_energy = LDA.utilsEnergySource.createVoidEnergySource()
```

---

## 4. Utilitários Gerais, Bounding Box e Áudio (`LDA.utils`)

### `array_contains`
```lua
local existe = LDA.utils.array_contains({"a", "b", "c"}, "b") -- true
```

### `tableMerge`
```lua
local mesclada = LDA.utils.tableMerge({a = 1, b = 2}, {b = 99, c = 3}, false)
```

### `createBoundingBox`
```lua
local box_quadrada = LDA.utils.createBoundingBox(1.5)        -- {{-1.5, -1.5}, {1.5, 1.5}}
local box_retangular = LDA.utils.createBoundingBox(2.0, 1.0) -- {{-2.0, -1.0}, {2.0, 1.0}}
```

### `createModuleSpec`
```lua
local modulos = LDA.utils.createModuleSpec(4, {0, 0.5})
```

### `createResistance` & `getFullResistance`
```lua
local res_fogo = LDA.utils.createResistance("fire", 75)
local res_todas = LDA.utils.getFullResistance(80) -- 80% para todos os tipos padrão
```

### `getRandomPositionAround`
```lua
local pos = LDA.utils.getRandomPositionAround(100, 200, 10, 50)
```

### `getAudio` & `getSequentialAudioList`
```lua
local som = LDA.utils.getAudio("__meu-mod__/audios/porta-abrir", 0.8)
local passos = LDA.utils.getSequentialAudioList("__meu-mod__/audios/passo-", 1, 3, 0.5)
```

### Sons Ambientes
```lua
local musica_menu = LDA.utils.CreateMenuAmbientSound("minha-musica-menu", 1.2)
local musica_jogo = LDA.utils.CreateInterludeAmbientSound("minha-musica-fundo", 1.0, "planeta-deserto")
local som_base = LDA.utils.CreateBaseAmbientSound("ambiente-nauvis", "main-track", 1.0)
```

### Imagens e Sprites
```lua
local picture = LDA.utils.getPicture("__meu-mod__/graphics/icons/cristal", 64, 0.5, 4)
local pictures = LDA.utils.getSequentialPictureList("__meu-mod__/graphics/icons/cristal", 1, 4, 64, 0.5, 4)
```

---

## 5. Efeitos Ambientais In-Game (`LDA.utilsAmbientEffects`)

Funções de suporte executadas durante a partida com base em uma `LuaSurface`:

```lua
-- Explosão visual simples com fumaça:
LDA.utilsAmbientEffects.createExplosion(surface, {x = 0, y = 0})

-- Explosões secundárias dispersas:
LDA.utilsAmbientEffects.createSecondaryExplosions(surface, {x = 0, y = 0}, 4)

-- Chamas de impacto:
LDA.utilsAmbientEffects.createCrashFire(surface, {x = 0, y = 0}, 6)

-- Marca de queimadura no chão:
LDA.utilsAmbientEffects.createScorchmark(surface, {x = 0, y = 0})
```

---

## 6. Utilitários de Tecnologia (`LDA.techUtils`)

### `createEffectsUnlocksRecipes`
Gera a lista de efeitos de desbloqueio de receitas para tecnologias manuais:

```lua
local efeitos = LDA.techUtils.createEffectsUnlocksRecipes({
    "montadora-avancada",
    "fornalha-plasma"
})
```
