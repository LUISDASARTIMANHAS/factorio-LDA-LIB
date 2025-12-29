-- control-animations.lua
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
    for k, v in pairs(props) do
        hr_version[k] = v
    end

    return hr_version
end

--- Função Pública: Cria uma única camada (layer) de animação.
-- Esta função é o orquestrador que utiliza as funções privadas para garantir o SRP.
-- @param filename {string} O caminho completo para o arquivo de imagem. auto adiciona .png
-- @param width {number} A largura da sprite na versão base.
-- @param height {number} A altura da sprite na versão base.
-- @param hr_scale {number|nil} O fator de escala para a versão HR (padrão: 0.5).
-- @param custom_props {table|nil} Propriedades customizadas.
-- @return {table} Um objeto de layer de animação completo, incluindo a hr_version.
function Module.createAnimationLayer(filename, width, height, hr_scale, custom_props)
    local props = prepareProps(custom_props)
    local formalizedFilename = filename ..".png"

    -- Cria a base da camada (layer)
    local layer = {
        filename = formalizedFilename,
        width = width,
        height = height
    }

    -- Aplica as propriedades à camada base
    for k, v in pairs(props) do
        layer[k] = v
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

return Module
