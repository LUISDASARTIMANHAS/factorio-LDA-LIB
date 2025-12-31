-- control-utils.lua
local Module = {}
-- Constante para o shift padrão do ícone (Factorio base costuma usar {0, 0})
local DEFAULT_MODULE_SHIFT = {0, 0}
-- NOVO FORMATO (MAPA)
local DEFAULT_DAMAGE_TYPE = {
    "physical",
    "impact",
    "fire",
    "acid",
    "poison",
    "explosion",
    "laser",
    "electric"
    -- Note: "physical and explosion" não é um tipo de dano, mas uma combinação
    -- de *duas* resistências na lista. Para esta função, focamos nos tipos de dano únicos.
}

-- Função auxiliar para procurar um valor em um array
function Module.array_contains(array, value)
    for _, v in ipairs(array) do
        if v == value then
            return true
        end
    end
    return false
end

-- Função auxiliar genérica para mesclar uma tabela 'source' em uma tabela 'target'.
-- Parâmetros:
--   target (table): A tabela que receberá os dados.
--   source (table): A tabela de onde os dados serão copiados.
--   overwrite (boolean, opcional): Se for 'true', sobrescreve campos existentes em 'target'.
--                                  Se for 'false' ou omitido, só adiciona novos campos (mesclagem condicional).
function Module.tableMerge(target, source, overwrite)
    -- O 'overwrite' padrão é FALSE (mesclagem condicional)
    local should_overwrite = overwrite or false

    -- target é o único que precisa ser uma tabela não-nil para podermos escrever
    if not target or type(target) ~= "table" then
        -- Retornamos a source se o target for inválido (ou você pode lançar um erro)
        return source or {}
    end

    -- source deve ser uma tabela para iterar
    if source and type(source) == "table" then
        for key, value in pairs(source) do
            -- Lógica da Mesclagem
            if should_overwrite or target[key] == nil then
                target[key] = value
            end
        end
    end

    return target
end

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

function Module.createResistance(resistenceType, percent)
    -- Tipos de resistência padrão do Factorio (exemplos comuns)

    if not Module.array_contains(DEFAULT_DAMAGE_TYPE, resistenceType) then
        -- Se não for um tipo padrão, logue um aviso, mas continue
        log(
            string.format(
                "LDA-LIB WARN: O tipo de resistência '%s' não é um tipo padrão do Factorio. Certifique-se de que este tipo de dano está definido.",
                resistenceType
            )
        )
    end

    -- Validação de 'percent'
    if type(percent) ~= "number" or percent < 0 then
        percent = 0
    end

    -- usage
    -- resistances ={
    --     utils.createResistance("fire",100)
    -- }
    return {type = resistenceType, percent = percent}
end

function Module.getFullResistance(percent)
    -- Definir o valor padrão de 100% se 'percent' for nulo ou inválido
    local final_percent = 100
    if type(percent) == "number" and percent >= 0 then
        final_percent = percent
    end

    local resistances_table = {}

    -- Iterar sobre os tipos no array e criar as entradas de resistência
    for _, resistenceType in ipairs(DEFAULT_DAMAGE_TYPE) do
        local resistance_entry = {
            type = resistenceType,
            percent = final_percent
        }

        table.insert(resistances_table, resistance_entry)
    end

    -- usage
    -- resistances = utils.getFullResistance(),
    -- {
    --     {
    --         type = "physical",
    --         percent = 100
    --     },
    --     {
    --         type = "impact",
    --         percent = 100
    --     },
    --     {
    --         type = "fire",
    --         percent = 100
    --     },
    --     {
    --         type = "acid",
    --         percent = 100
    --     },
    --     {
    --         type = "poison",
    --         percent = 100
    --     },
    --     {
    --         type = "explosion",
    --         percent = 100
    --     },
    --     {
    --         type = "laser",
    --         percent = 100
    --     },
    --     {
    --         type = "electric",
    --         percent = 100
    --     }
    -- }
    return resistances_table
end

function Module.getAudio(filename, volume)
    local path = Module.basePath -- agora é global para biblioteca inteira
    -- caso o mod dependente não tenha definido o setBasePath
    if filename == nil then
        error("[LDA-LIB] [getAudio] error: filename não pode ser nulo!")
    end

    return {filename = filename .. ".ogg", volume = volume or 0.7}
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
        local filename = base_filename .. i

        -- Adiciona o objeto de som formatado à lista
        table.insert(audio_list, Module.getAudio(filename, default_volume))
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

--- Cria uma definição de Sprite/Picture para uso em listas.
-- É o equivalente visual de Module.getAudio.
-- @param filename {string} O caminho completo e nome do arquivo (ex: "__base__/graphics/sprites/iron-ore").
-- @param size {number, optional} O tamanho do sprite em pixels (largura/altura). Padrão: 64.
-- @param scale {number, optional} Fator de escala. Padrão: 0.5 (para ícones pequenos).
-- @param mipmap_count {number, optional} Mipmap count para otimização. Padrão: 4.
-- @return {table} Um objeto Picture/Sprite Definition.
function Module.getPicture(filename, size, scale, mipmap_count)
    if filename == nil then
        error("[LDA-LIB] [getPicture] error: filename não pode ser nulo!")
    end

    -- usage
    -- local pictures = {
    --     Module.getPicture("__space-age__/graphics/icons/yumako-seed-1", 64, 0.5, 4),
    --     Module.getPicture("__space-age__/graphics/icons/yumako-seed-2", 64, 0.5, 4),
    --     Module.getPicture("__space-age__/graphics/icons/yumako-seed-3", 64, 0.5, 4),
    --     Module.getPicture("__space-age__/graphics/icons/yumako-seed-4", 64, 0.5, 4)
    -- }

    return {
        size = size or 64,
        filename = filename .. ".png",
        scale = scale or 0.5,
        mipmap_count = mipmap_count or 4
    }
end

--- Gera uma lista de definições de Sprite/Picture sequenciais para Factorio.
-- Útil para listas de imagens que seguem um padrão com numeração (ex: 'seed-1.png', 'seed-2.png').
-- @param base_filename_without_ext {string} O caminho base e nome do arquivo antes do número. Ex: "__space-age__/graphics/icons/yumako-seed-"
-- @param extension {string, optional} Extensão do arquivo. Padrão: ".png".
-- @param start_index {number} O número inicial da sequência (ex: 1).
-- @param end_index {number} O número final da sequência (ex: 4).
-- @param size {number, optional} O tamanho do sprite em pixels. Padrão: 64.
-- @param scale {number, optional} Fator de escala. Padrão: 0.5.
-- @param mipmap_count {number, optional} Mipmap count. Padrão: 4.
-- @return {table} Uma tabela contendo as definições de Picture/Sprite prontas para uso.
function Module.getSequentialPictureList(base_filename, start_index, end_index, size, scale, mipmap_count)
    -- Validação: Garantir que os parâmetros essenciais não são nulos.
    if not base_filename or not start_index or not end_index then
        error(
            "[LDA-LIB] [getSequentialPictureList] error: Parâmetros base_filename, start_index e end_index não podem ser nulos!"
        )
    end

    -- Validação: Garantir que a ordem dos índices está correta.
    if start_index > end_index then
        error("[LDA-LIB] [getSequentialPictureList] error: start_index deve ser menor ou igual a end_index.")
    end

    local picture_list = {}

    for i = start_index, end_index do
        local filename = base_filename .. i

        -- Adiciona o objeto Picture/Sprite formatado à lista usando o utilitário getPicture
        table.insert(picture_list, Module.getPicture(filename, size, scale, mipmap_count))
    end

    -- usage
    -- local pictures = Module.getSequentialPictureList("__space-age__/graphics/icons/yumako-seed-", 1, 4, 64, 0.5, 4)

    return picture_list
end

return Module
