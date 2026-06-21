-- control-animations.lua
-- getSequentialPictureList(base_filename, start_index, end_index, size, scale, mipmap_count)
local controlUtils = require("utils.control-utils")

local Module = {}

-- Constantes para a animação padrão
local DEFAULT_ANIM_PROPS = {
    line_length = 1,
    frame_count = 1,
    priority = "high",
    shift = {0, 0.125}
}

--- 1. Função Privada: Une as propriedades padrão com as customizadas.
-- @param custom_props {table|nil} Propriedades customizadas a serem aplicadas.
-- @return {table} Tabela de propriedades combinadas.
local function prepareProps(custom_props)
    local props = {}
    -- Copia as propriedades padrão
    for k, v in pairs(DEFAULT_ANIM_PROPS) do
        props[k] = v
    end
    -- Sobrescreve com as customizadas
    if custom_props then
        for k, v in pairs(custom_props) do
            props[k] = v
        end
    end
    return props
end

--- 2. Função Privada: Cria o objeto hr_version, calculando as dimensões.
-- @param base_width {number} Largura da sprite base.
-- @param base_height {number} Altura da sprite base.
-- @param filename {string} Nome do arquivo (para ser repetido no HR).
-- @param props {table} Propriedades já unidas (shift, priority, frame_count, etc.).
-- @param hr_scale {number|nil} O fator de escala (padrão: 0.5).
-- @return {table} O objeto hr_version completo.
local function createHRVersion(base_width, base_height, filename, props, hr_scale)
    local scale = hr_scale or 0.5
    local hr_width = base_width / scale
    local hr_height = base_height / scale

    local hr_version = {
        filename = filename,
        width = hr_width,
        height = hr_height,
        scale = scale
    }

    -- Aplica as propriedades compartilhadas (frame_count, shift, priority, etc.)
    for k, value in pairs(props) do
        hr_version[k] = value
    end

    return hr_version
end

--- Função Pública: Cria uma única camada (layer) de animação.
-- Esta função é o orquestrador que utiliza as funções privadas para garantir o SRP.
-- @param filename {string} O caminho completo para o arquivo de imagem. auto adiciona .png
-- @param width {number} A largura da sprite na versão base.
-- @param height {number} A altura da sprite na versão base.
-- @param hr_scale {number|nil} O fator de escala para a versão HR (padrão: 0.5).
-- @param draw_as_shadow {boolean} se o layer deve ser uma sombra (padrão: false).
-- @param custom_props {table|nil} Propriedades customizadas.
-- @return {table} Um objeto de layer de animação completo, incluindo a hr_version.
function Module.createAnimationLayer(filename, width, height, hr_scale, shift, draw_as_shadow, custom_props)
    local props = prepareProps(custom_props)
    local formalizedFilename = filename .. ".png"

    -- Cria a base da camada (layer)
    local layer = {
        filename = formalizedFilename,
        width = width,
        height = height,
        shift = shift or util.by_pixel(-3, 3.5),
        draw_as_shadow = draw_as_shadow or false
    }

    -- Aplica as propriedades à camada base
    for k, value in pairs(props) do
        layer[k] = value
    end

    -- Anexa a versão HR
    layer.hr_version = createHRVersion(width, height, formalizedFilename, props, hr_scale)

    return layer
    -- usage
    -- 1. Cria a camada de animação (Layer)
    -- local my_layer = animation_utils.createAnimationLayer(
    --     MOD_GRAPHICS_PATH .. "assembly-unit-main.png", -- filename
    --     128,                                           -- width (Base)
    --     128,                                           -- height (Base)
    --     0.5,                                           -- hr_scale (HR será 256x256)
    --     {                                              -- custom_props
    --         shift = {0, 0.125},
    --         frame_count = 16,                          -- 16 frames no sprite-sheet
    --         line_length = 8,                           -- 8 frames por linha
    --         animation_speed = 0.5
    --     }
    -- )
end

--- Cria a estrutura completa de animação para um protótipo, a partir de uma ou mais layers.
-- (Esta função permaneceu inalterada, pois já tinha responsabilidade única)
-- @param layers_or_single_layer {table} Uma única layer de animação ou uma tabela com múltiplas layers.
-- @return {table} A estrutura final 'animation'.
function Module.createAnimation(layers_or_single_layer)
    local layers_array = {}
    if type(layers_or_single_layer) == "table" and layers_or_single_layer.filename then
        table.insert(layers_array, layers_or_single_layer)
    elseif type(layers_or_single_layer) == "table" then
        layers_array = layers_or_single_layer
    else
        error("[LDA-LIB] [createAnimation] error: O parâmetro deve ser uma layer ou uma tabela de layers.")
    end

    return {
        layers = layers_array
    }

    -- usage
    -- data:extend(
    -- {
    --     {
    --         type = "assembling-machine",
    --         name = "my-new-machine",

    --         -- O uso da função pública de animação:
    --         animation = animation_utils.createAnimation(my_layer),

    --         -- ...
    --     }
    -- })
end

--- Cria a definição de reflexão na água (WaterReflectionDefinition).
-- @param pictures {table} SpriteVariations utilizadas na reflexão.
-- @param rotate {boolean|nil} Rotaciona a reflexão junto com a entidade (padrão: true).
-- @param orientation_to_variation {boolean|nil} Usa a orientação para selecionar a variação (padrão: false).
-- @return {table} Estrutura WaterReflectionDefinition.
function Module.createWaterReflection(
    base_filename,
    rotate,
    orientation_to_variation,
    end_index,
    size,
    scale,
    mipmap_count)
    if not base_filename then
        error("[LDA-LIB] [createWaterReflection] error: base_filename é obrigatório.")
    end

    return {
        pictures = controlUtils.getSequentialPictureList(base_filename, 1, end_index or 3, size, scale, mipmap_count),
        rotate = rotate ~= false,
        orientation_to_variation = orientation_to_variation or false
    }

    -- usage
    --
    -- example return
    -- {
    -- pictures = {
    --   {size = 64, filename = "__base__/graphics/icons/coal.png", scale = 0.5, mipmap_count = 4},
    --   {size = 64, filename = "__base__/graphics/icons/coal-1.png", scale = 0.5, mipmap_count = 4},
    --   {size = 64, filename = "__base__/graphics/icons/coal-2.png", scale = 0.5, mipmap_count = 4},
    --   {size = 64, filename = "__base__/graphics/icons/coal-3.png", scale = 0.5, mipmap_count = 4}
    -- },
    --     rotate = false,
    --     orientation_to_variation = false
    -- }
end

--- Cria a estrutura completa de graphics_set para um protótipo.
-- Compatível com Factorio 2.0+, substituindo a antiga propriedade animation.
--
-- @param animation_progress number|nil               Progresso inicial da animação (default: 0.25)
-- @param frozen_patch table|nil                      Sprite usada quando a entidade está congelada
-- @param always_draw_idle_animation boolean|nil      Força renderização da idle animation (default: true)
-- @param reset_animation_when_frozen boolean|nil     Reinicia animação ao congelar (default: true)
-- @param base_filename string|nil                    Base usada para water_reflection (default: coal)
--
-- @return table                                      Estrutura pronta de graphics_set
function Module.createGraphicsSet(
    animation_progress,
    frozen_patch,
    always_draw_idle_animation,
    reset_animation_when_frozen,
    base_filename)
    return {
        animation_progress = animation_progress or 0.25,
        always_draw_idle_animation = always_draw_idle_animation ~= false,
        frozen_patch = {
            north = {
                filename = "__base__/graphics/entity/assembling-machine-3/assembling-machine-3-pipe-N.png",
                priority = "extra-high",
                width = 71,
                height = 38,
                shift = util.by_pixel(2.25, 13.5),
                scale = 0.5
            },
            east = {
                filename = "__base__/graphics/entity/assembling-machine-3/assembling-machine-3-pipe-E.png",
                priority = "extra-high",
                width = 42,
                height = 76,
                shift = util.by_pixel(-24.5, 1),
                scale = 0.5
            },
            south = {
                filename = "__base__/graphics/entity/assembling-machine-3/assembling-machine-3-pipe-S.png",
                priority = "extra-high",
                width = 88,
                height = 61,
                shift = util.by_pixel(0, -31.25),
                scale = 0.5
            },
            west = {
                filename = "__base__/graphics/entity/assembling-machine-3/assembling-machine-3-pipe-W.png",
                priority = "extra-high",
                width = 39,
                height = 73,
                shift = util.by_pixel(25.75, 1.25),
                scale = 0.5
            }
        },
        water_reflection = Module.createWaterReflection(base_filename),
        reset_animation_when_frozen = reset_animation_when_frozen ~= false
    }

    -- usage
    -- graphics_set = animation_utils.createGraphicsSet()
    -- example return
    -- return {
    --     animation_progress = 0.25,
    --     always_draw_idle_animation = true,
    --     frozen_patch = util.sprite_load("__space-age__/graphics/entity/electromagnetic-plant/electromagnetic-plant-frozen", {scale = 0.5}),
    --     reset_animation_when_frozen = true
    --   },
end

return Module
