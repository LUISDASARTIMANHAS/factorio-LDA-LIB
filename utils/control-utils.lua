-- control-utils.lua
local Module = {}
-- Constante para o shift padrão do ícone (Factorio base costuma usar {0, 0})
local DEFAULT_MODULE_SHIFT = {0, 0}

--- Cria uma caixa de delimitação (bounding box) simétrica, usada para collision_box, selection_box ou drawing_box.
-- O formato da caixa é sempre: {{ -x_max, -y_max }, { x_max, y_max }}.
-- @param x_max {number} O deslocamento máximo horizontal a partir do centro.
-- @param y_max {number|nil} O deslocamento máximo vertical. Se nulo, usa x_max (cria uma caixa quadrada/simétrica).
-- @return {table} Um objeto de caixa de delimitação pronto para uso.
function Module.createBoundingBox(x_max, y_max)
    -- Validação básica:
    if type(x_max) ~= "number" or x_max <= 0 then
        error("[LDA-LIB] [createBoundingBox] error: x_max deve ser um número positivo.")
    end

    -- Garante que y_max seja igual a x_max se não for fornecido (caixa quadrada)
    local final_y_max = y_max
    if final_y_max == nil or type(final_y_max) ~= "number" or final_y_max <= 0 then
        final_y_max = x_max
    end

    local x = math.abs(x_max) -- Usa o valor absoluto para garantir que seja positivo
    local y = math.abs(final_y_max)

    -- Retorna o formato: {{ canto inferior esquerdo }, { canto superior direito }}
    return {
        {-x, -y},
        {x, y}
    }

-- Colisão e Seleção (Tamanho 2.4 x 2.4, conforme seu exemplo)
    -- x_max = 1.2, y_max = 1.2 (automático)
    -- collision_box = utils.createBoundingBox(1.2), 
    -- x_max = 1.5, y_max = 1.5 (automático)
    -- selection_box = utils.createBoundingBox(1.5), 
    -- x_max = 1.5, y_max = 1.5 (automático)
    -- drawing_box = utils.createBoundingBox(1.5),   
end

--- Cria a estrutura completa para a especificação de módulos da entidade.
-- Abstrai a definição de 'module_specification'.
-- @param slots {number} O número de slots de módulo disponíveis (0 para nenhum).
-- @param icon_shift {table|nil} Ajuste da posição do ícone de informação do módulo.
--        Formato: {x_offset, y_offset}. Padrão: {0, 0}.
-- @return {table} Um objeto 'module_specification' pronto para uso.
function Module.createModuleSpec(slots, icon_shift)
    -- Validação básica
    if type(slots) ~= "number" or slots < 0 then
        -- Definimos 0 como padrão se for nulo, mas lançamos erro se for um valor inválido
        slots = 0
    end

    local final_icon_shift = DEFAULT_MODULE_SHIFT
    if icon_shift and type(icon_shift) == "table" and #icon_shift >= 2 then
        final_icon_shift = icon_shift
    end

    -- usage
    -- module_specification =
    --     utils.createModuleSpec(
    --     0, -- slots
    --     {0, 0.5} -- icon_shift (ajuste vertical para cima)
    -- )

    return {
        module_slots = slots,
        module_info_icon_shift = final_icon_shift
    }
end

--- Gera uma lista de definições de áudio sequenciais para Factorio.
-- É útil para sons como 'vehicle_impact_sound' onde os nomes dos arquivos
-- seguem um padrão com numeração (ex: 'impact-1.ogg', 'impact-2.ogg').
-- @param base_filename {string} O caminho base e nome do arquivo antes do número.
--        Ex: "__base__/sound/car-metal-impact-"
-- @param start_index {number} O número inicial da sequência (ex: 2).
-- @param end_index {number} O número final da sequência (ex: 6).
-- @param volume {number|nil} O volume a ser aplicado a cada som. Padrão: 0.7.
-- @return {table} Uma tabela contendo as definições de som prontas para uso
--         em atributos como 'vehicle_impact_sound'.
function Module.getSequentialAudioList(base_filename, start_index, end_index, volume)
    -- Validação: Garantir que os parâmetros essenciais não são nulos.
    if not base_filename or not start_index or not end_index then
        error(
            "[LDA-LIB] [getSequentialAudioList] error: Parâmetros base_filename, start_index e end_index não podem ser nulos!"
        )
    end

    -- Validação: Garantir que a ordem dos índices está correta.
    if start_index > end_index then
        error("[LDA-LIB] [getSequentialAudioList] error: start_index deve ser menor ou igual a end_index.")
    end

    local audio_list = {}
    local default_volume = volume or 0.7 -- Volume padrão, se não for fornecido

    for i = start_index, end_index do
        local filename = base_filename .. i .. ".ogg"

        -- Adiciona o objeto de som formatado à lista
        table.insert(
            audio_list,
            {
                filename = filename,
                volume = default_volume
            }
        )
    end

    -- usage exemplo
    -- Sons de Impacto de Veículo
    -- vehicle_impact_sound = utils.getSequentialAudioList(
    --     "__base__/sound/car-metal-impact-", -- Nome base do arquivo
    --     2,                                 -- Começa no 2 (car-metal-impact-2.ogg)
    --     6,                                 -- Termina no 6 (car-metal-impact-6.ogg)
    --     0.5                                -- Volume (opcional, mas bom manter)
    -- )

    return audio_list
end

function Module.getAudio(filename, volume)
    local path = Module.basePath -- agora é global para biblioteca inteira
    -- caso o mod dependente não tenha definido o setBasePath
    if filename == nil then
        error("[LDA-LIB] [getAudio] error: filename não pode ser nulo!")
    end

    return {filename = filename .. ".ogg", volume = volume or 0.7}
end

return Module
