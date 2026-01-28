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

--- Verifica se um valor existe dentro de um array sequencial.
---
---@param array table   Lista (array) a ser percorrida
---@param value any     Valor a ser procurado no array
---@return boolean      Retorna true se o valor existir, caso contrário false
function Module.array_contains(array, value)
    for _, v in ipairs(array) do
        if v == value then
            return true
        end
    end
    return false
end

--- Mescla os campos de uma tabela `source` em uma tabela `target`.
--- Permite mesclagem condicional ou sobrescrita total dos campos existentes.
---
---@param target table|nil      Tabela que receberá os dados
---@param source table|nil      Tabela de origem dos dados
---@param overwrite boolean|nil Se true, sobrescreve campos existentes em `target`
---@return table               Tabela resultante da mesclagem
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

--- Cria uma caixa de delimitação (bounding box) simétrica.
--- Usada em `collision_box`, `selection_box` ou `drawing_box`.
--- O formato retornado é sempre: {{ -x_max, -y_max }, { x_max, y_max }}.
---
--- Usage:
--- ```lua
--- collision_box = LDA.createBoundingBox(1.2)
--- selection_box = LDA.createBoundingBox(1.5)
--- drawing_box   = LDA.createBoundingBox(1.5)
---
--- -- Caixa retangular
--- collision_box = LDA.createBoundingBox(1.2, 0.8)
--- ```
---
---@param x_max number        Deslocamento máximo horizontal a partir do centro
---@param y_max number|nil    Deslocamento máximo vertical (se nil, usa x_max)
---@return table              Bounding box pronta para uso no Factorio
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

    local x = math.abs(x_max)
    local y = math.abs(final_y_max)

    return {
        {-x, -y},
        {x, y}
    }
end

--- Cria a estrutura completa para a especificação de módulos da entidade.
--- Abstrai a definição de `module_specification` usada pelo Factorio.
---
--- Usage:
--- ```lua
--- module_specification = LDA.createModuleSpec(0)
---
--- module_specification = LDA.createModuleSpec(
---     2,
---     {0, 0.5}
--- )
--- ```
---
---@param slots number              Número de slots de módulo disponíveis (0 para nenhum)
---@param icon_shift table|nil       Ajuste da posição do ícone do módulo ({x, y})
---@return table                    Estrutura `module_specification` pronta para uso
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

    return {
        module_slots = slots,
        module_info_icon_shift = final_icon_shift
    }
end

--- Cria uma definição de resistência individual para entidades do Factorio.
--- Valida o tipo de dano contra a lista padrão e ajusta o percentual se necessário.
---
--- Usage:
--- ```lua
--- resistances = {
---     LDA.createResistance("fire", 100),
---     LDA.createResistance("physical", 50)
--- }
--- ```
---
---@param resistenceType string   Tipo de dano (ex: "fire", "physical", "acid")
---@param percent number|nil     Percentual de resistência (0–100)
---@return table                 Estrutura de resistência `{ type, percent }`
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

    return {type = resistenceType, percent = percent}
end

--- Cria uma lista completa de resistências para todos os tipos de dano padrão do Factorio.
--- Todos os tipos recebem o mesmo percentual de resistência.
---
--- Usage:
--- ```lua
--- resistances = LDA.getFullResistance()
---
--- resistances = LDA.getFullResistance(80)
--- ```
---
---@param percent number|nil   Percentual de resistência aplicado a todos os tipos (padrão: 100)
---@return table              Lista de resistências no formato aceito pelo Factorio
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

    return resistances_table
end

--- Cria uma definição de áudio simples para uso em protótipos do Factorio.
--- Concatena automaticamente a extensão `.ogg` ao nome do arquivo.
---
--- Usage:
--- ```lua
--- working_sound = LDA.getAudio("__base__/sound/furnace", 0.8)
---
--- open_sound = LDA.getAudio("__base__/sound/gui-open")
--- ```
---
---@param filename string        Caminho e nome base do arquivo de áudio (sem extensão)
---@param volume number|nil      Volume do áudio (padrão: 0.7)
---@return table                Tabela de definição de som compatível com o Factorio
function Module.getAudio(filename, volume)
    local path = Module.basePath -- agora é global para biblioteca inteira
    -- caso o mod dependente não tenha definido o setBasePath
    if filename == nil then
        error("[LDA-LIB] [getAudio] error: filename não pode ser nulo!")
    end

    return {filename = filename .. ".ogg", volume = volume or 0.7}
end

--- Gera uma lista de definições de áudio sequenciais para Factorio.
--- É útil para sons cujos arquivos seguem um padrão numérico incremental.
---
--- Usage:
--- ```lua
--- vehicle_impact_sound = Module.getSequentialAudioList(
---     "__base__/sound/car-metal-impact-",
---     2,
---     6,
---     0.5
--- )
--- ```
---
---@param base_filename string     Caminho base e nome do arquivo antes do número
---@param start_index number       Índice inicial da sequência
---@param end_index number         Índice final da sequência
---@param volume number|nil        Volume aplicado a todos os sons (padrão: 0.7)
---@return table                   Lista de definições de áudio compatíveis com o Factorio
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

    return audio_list
end

--- Cria uma definição base de som ambiente para o Factorio.
--- Esta função é genérica e serve como base para todos os tipos de trilha.
---
--- Tipos válidos de `track_type`:
--- - `"menu-track"`   : reproduz apenas no menu principal
--- - `"main-track"`   : toca intercalado com "interlude"
--- - `"hero-track"`   : toca ao pisar em um novo planeta (1 por planeta)
--- - `"interlude"`    : toca intercalado com "main-track"
---
---@param nameTrack string              Nome lógico da trilha (usado como ID)
---@param track_type string             Tipo da trilha ambiente
---@param volume number|nil             Volume do áudio (padrão: 1.2)
---@param SpaceLocationID string|nil     ID do planeta/plataforma espacial
---@return table                         Protótipo `ambient-sound` do Factorio
function Module.CreateBaseAmbientSound(nameTrack, track_type, volume, SpaceLocationID)
    if nameTrack == nil then
        error("[LDA-LIB] [CreateBaseAmbientSound] error: nameTrack não pode ser nulo!")
    end

    if track_type == nil then
        error("[LDA-LIB] [CreateBaseAmbientSound] error: track_type não pode ser nulo!")
    end

    return {
        type = "ambient-sound",
        name = nameTrack,
        weight = 1,
        track_type = track_type,
        planetoptional = SpaceLocationID,
        sound = Module.getAudio(nameTrack, volume or 1.2)
    }
end

--- Cria uma trilha do tipo `interlude`.
--- Essas faixas são tocadas alternadamente com `main-track`.
---
--- Uso:
--- ```lua
--- data:extend({
---     LDA.CreateInterludeAmbientSound("Minha Musica")
--- })
--- ```
---
---@param nameTrack string              Nome lógico da trilha
---@param volume number|nil             Volume do áudio (padrão: 1.2)
---@param SpaceLocationID string|nil     ID do planeta/plataforma espacial
---@return table                         Protótipo `ambient-sound`
function Module.CreateInterludeAmbientSound(nameTrack, volume, SpaceLocationID)
    return Module.CreateBaseAmbientSound(nameTrack, "interlude", volume or 1.2, SpaceLocationID)
end

--- Cria uma trilha exclusiva do menu principal (`menu-track`).
---
--- Uso:
--- ```lua
--- data:extend({
---     LDA.CreateMenuAmbientSound("Minha Musica de Menu")
--- })
--- ```
---
---@param nameTrack string      Nome lógico da trilha
---@param volume number|nil     Volume do áudio (padrão: 1.5)
---@return table                Protótipo `ambient-sound`
function Module.CreateMenuAmbientSound(nameTrack, volume)
    return Module.CreateBaseAmbientSound(nameTrack, "menu-track", volume or 1.5, nil)
end

--- Cria uma definição de Picture/Sprite para uso em protótipos do Factorio.
--- Utilizado em campos como `pictures`, `icons`, `animation`, entre outros.
---
--- Usage:
--- ```lua
--- local pictures = {
---     LDA.getPicture("__space-age__/graphics/icons/yumako-seed-1", 64, 0.5, 4),
---     LDA.getPicture("__space-age__/graphics/icons/yumako-seed-2", 64, 0.5, 4),
---     LDA.getPicture("__space-age__/graphics/icons/yumako-seed-3", 64, 0.5, 4),
---     LDA.getPicture("__space-age__/graphics/icons/yumako-seed-4", 64, 0.5, 4)
--- }
--- ```
---
---@param filename string            Caminho do arquivo sem extensão
---@param size number|nil            Tamanho do sprite em pixels (padrão: 64)
---@param scale number|nil           Fator de escala aplicado à imagem (padrão: 0.5)
---@param mipmap_count number|nil    Quantidade de mipmaps (padrão: 4)
---@return table                     Definição de Picture/Sprite compatível com o Factorio
function Module.getPicture(filename, size, scale, mipmap_count)
    if filename == nil then
        error("[LDA-LIB] [getPicture] error: filename não pode ser nulo!")
    end

    return {
        size = size or 64,
        filename = filename .. ".png",
        scale = scale or 0.5,
        mipmap_count = mipmap_count or 4
    }
end
--- Gera uma lista sequencial de definições de Picture/Sprite para o Factorio.
--- Ideal para conjuntos de imagens numeradas de forma incremental
--- (ex: "seed-1.png", "seed-2.png", "seed-3.png").
---
--- A função utiliza internamente `LDA.getPicture`, herdando seus padrões
--- (extensão `.png`, size 64, scale 0.5, mipmap_count 4).
---
--- Usage:
--- ```lua
--- local pictures = LDA.getSequentialPictureList(
---     "__space-age__/graphics/icons/yumako-seed-",
---     1,
---     4,
---     64,
---     0.5,
---     4
--- )
--- ```
---
---@param base_filename string       Caminho base do arquivo sem número e sem extensão
---@param start_index number         Índice inicial da sequência (ex: 1)
---@param end_index number           Índice final da sequência (ex: 4)
---@param size number|nil            Tamanho do sprite em pixels (padrão: 64)
---@param scale number|nil           Fator de escala aplicado à imagem (padrão: 0.5)
---@param mipmap_count number|nil    Quantidade de mipmaps (padrão: 4)
---@return table                     Lista de definições Picture/Sprite compatíveis com o Factorio
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

    return picture_list
end

return Module