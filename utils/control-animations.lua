-- control-animations.lua
-- getSequentialPictureList(base_filename, start_index, end_index, size, scale, mipmap_count)
local controlUtils = require("utils.control-utils")

local Module = {}

--- Cria uma layer base compatível com sprites do Factorio (entity/animation).
-- @param filename string               Caminho do sprite
-- @param width number                  Largura da imagem
-- @param height number                 Altura da imagem
-- @param frame_count number|nil        Número de frames (default: 1)
-- @param line_length number|nil        Frames por linha (default: frame_count)
-- @param shift table|nil               Offset da sprite (default: util.by_pixel(0, 0))
-- @param scale number|nil              Escala da sprite (default: 1)
-- @param priority string|nil           Prioridade de render (default: "high")
-- @param extra_props table|nil         Propriedades adicionais opcionais
-- @return table                        Layer compatível com Factorio
function Module.createLayer(
    filename,
    width,
    height,
    frame_count,
    line_length,
    shift,
    scale,
    draw_as_shadow,
    priority,
    extra_props
)
    local layer = {
        filename = filename,
        priority = priority or "high",
        width = width,
        height = height,
        frame_count = frame_count or 1,
        line_length = line_length or (frame_count or 1),
        shift = shift or util.by_pixel(0, 0.125),
        scale = scale or 1,
        draw_as_shadow = draw_as_shadow or false
    }

    if extra_props then
        for k, v in pairs(extra_props) do
            layer[k] = v
        end
    end

    return layer
end


--- 2. Função Privada: Cria o objeto hr_version, calculando as dimensões.
-- A partir de uma layer base, gera a versão em alta resolução (HR).
--
-- @param layer {table} Layer base já construída (contendo filename, width, height, frame_count, line_length, shift, priority)
-- @param hr_scale {number|nil} Fator de escala da versão HR (default: 0.5)
--
-- @return {table} Objeto hr_version compatível com Factorio
local function createHRVersion(layer, hr_scale)
    local scale = hr_scale or 0.5

    return {
        filename = layer.filename,
        width = layer.width / scale,
        height = layer.height / scale,
        scale = scale,
        frame_count = layer.frame_count,
        line_length = layer.line_length,
        shift = layer.shift and table.deepcopy(layer.shift),
        priority = layer.priority,
        draw_as_shadow = layer.draw_as_shadow
    }
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
    local formalizedFilename = filename .. ".png"

    local props = custom_props or {}

    local layer = Module.createLayer(
        formalizedFilename,
        width,
        height,
        props.frame_count,
        props.line_length,
        shift or util.by_pixel(-3, 3.5),
        props.scale,
        draw_as_shadow,
        "high",
        props
    )

    layer.hr_version = createHRVersion(layer, hr_scale)

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
