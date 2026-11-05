local NetworkUtils = {}

--- Obtém a tabela raiz de persistência das redes dentro de `storage`.
--- Compatível com Factorio 2.0+ (utiliza a tabela global `storage`).
--- @return table|nil
local function get_storage()
    if not storage then return nil end
    storage.lda = storage.lda or {}
    storage.lda.networks = storage.lda.networks or {}
    return storage.lda.networks
end

--- Obtém a tabela (bucket) de uma rede específica, criando-a se solicitado.
--- @param network_name string
--- @param create_if_missing boolean|nil
--- @return table|nil
local function get_network_bucket(network_name, create_if_missing)
    if not network_name or type(network_name) ~= "string" then return nil end
    local networks = get_storage()
    if not networks then return nil end

    if not networks[network_name] and create_if_missing then
        networks[network_name] = {}
    end
    return networks[network_name]
end

--- Extrai com segurança o unit_number a partir de uma entidade, nó ou identificador numérico.
--- @param entity_or_id LuaEntity|table|number|string
--- @return number|nil
local function extract_unit_number(entity_or_id)
    if type(entity_or_id) == "number" then
        return entity_or_id
    end
    if type(entity_or_id) == "string" then
        return tonumber(entity_or_id)
    end
    if type(entity_or_id) == "table" then
        if entity_or_id.unit_number then
            return entity_or_id.unit_number
        end
        if entity_or_id.entity and entity_or_id.entity.valid and entity_or_id.entity.unit_number then
            return entity_or_id.entity.unit_number
        end
    end
    return nil
end

--- Registra uma entidade em uma rede de entidades persistida em `storage`.
---
--- @param network_name string Nome da rede (ex: "portals", "beacons", "power-nodes")
--- @param entity LuaEntity Entidade válida do Factorio a ser registrada
--- @param metadata table|nil Tabela com metadados adicionais arbitrários (ex: {name = "Alpha", destination_id = ...})
--- @return table|nil Retorna a estrutura do nó registrado ou nil em caso de falha
function NetworkUtils.register(network_name, entity, metadata)
    if not network_name or not entity or not entity.valid then
        return nil
    end

    local unit_number = entity.unit_number
    if not unit_number then
        -- Entidades sem unit_number não podem ser indexadas unicamente no padrão Factorio
        return nil
    end

    local bucket = get_network_bucket(network_name, true)
    if not bucket then return nil end

    metadata = metadata or {}
    local friendly_name = metadata.name
    if not friendly_name or friendly_name == "" then
        if pcall(function() return entity.backer_name end) and entity.backer_name then
            friendly_name = entity.backer_name
        else
            friendly_name = entity.name .. " #" .. tostring(unit_number)
        end
    end

    local force_name = (entity.force and entity.force.valid and entity.force.name) or "player"
    local surface_name = (entity.surface and entity.surface.valid and entity.surface.name) or "nauvis"
    local pos = entity.position

    local node = {
        entity = entity,
        unit_number = unit_number,
        name = friendly_name,
        force_name = force_name,
        surface_name = surface_name,
        position = {x = pos.x, y = pos.y},
        registered_tick = (game and game.tick) or 0,
        metadata = metadata
    }

    bucket[unit_number] = node
    return node
end

--- Remove uma entidade de uma rede pelo objeto ou por seu `unit_number`.
---
--- @param network_name string Nome da rede
--- @param entity_or_id LuaEntity|number|table Entidade ou unit_number a ser desregistrado
--- @return table|nil Retorna o nó removido se existia, ou nil
function NetworkUtils.unregister(network_name, entity_or_id)
    local unit_number = extract_unit_number(entity_or_id)
    if not unit_number then return nil end

    local bucket = get_network_bucket(network_name, false)
    if not bucket then return nil end

    local removed = bucket[unit_number]
    bucket[unit_number] = nil
    return removed
end

--- Obtém o registro de uma entidade em uma rede pelo seu `unit_number`.
--- Efetua auto-limpeza caso a entidade tenha sido destruída sem evento.
---
--- @param network_name string Nome da rede
--- @param entity_or_id LuaEntity|number|table Entidade ou unit_number
--- @return table|nil Retorna o nó válido ou nil se não encontrado/inválido
function NetworkUtils.get(network_name, entity_or_id)
    local unit_number = extract_unit_number(entity_or_id)
    if not unit_number then return nil end

    local bucket = get_network_bucket(network_name, false)
    if not bucket then return nil end

    local node = bucket[unit_number]
    if not node then return nil end

    -- Auto-limpeza de entidades que se tornaram inválidas silenciosamente
    if not node.entity or not node.entity.valid then
        bucket[unit_number] = nil
        return nil
    end

    return node
end

--- Consulta todos os nós válidos de uma rede com suporte a filtros opcionais.
--- Remove automaticamente do `storage` nós cujas entidades se tornaram inválidas.
---
--- @param network_name string Nome da rede
--- @param filter_or_force string|table|function|nil Pode ser:
---   - string: nome da força/time (ex: "player")
---   - table: filtros {force = "player", surface = "nauvis", name = "..."}
---   - function: predicado function(node) -> boolean
--- @return table Array sequencial com todos os nós válidos correspondentes
function NetworkUtils.getAll(network_name, filter_or_force)
    local bucket = get_network_bucket(network_name, false)
    if not bucket then return {} end

    local results = {}
    local dead_ids = {}

    local filter_type = type(filter_or_force)
    local target_force = nil
    local target_surface = nil
    local target_name = nil
    local custom_filter = nil

    if filter_type == "string" then
        target_force = filter_or_force
    elseif filter_type == "table" then
        target_force = filter_or_force.force
        target_surface = filter_or_force.surface
        target_name = filter_or_force.name
    elseif filter_type == "function" then
        custom_filter = filter_or_force
    end

    for unit_number, node in pairs(bucket) do
        local ent = node.entity
        if not ent or not ent.valid then
            table.insert(dead_ids, unit_number)
        else
            -- Atualiza caches dinâmicos se disponíveis
            local current_force = ent.force and ent.force.name or node.force_name
            local current_surface = ent.surface and ent.surface.name or node.surface_name
            node.force_name = current_force
            node.surface_name = current_surface

            local match = true

            if target_force and current_force ~= target_force then
                match = false
            end

            if match and target_surface and current_surface ~= target_surface then
                match = false
            end

            if match and target_name and node.name ~= target_name then
                match = false
            end

            if match and custom_filter and not custom_filter(node) then
                match = false
            end

            if match then
                table.insert(results, node)
            end
        end
    end

    -- Auto-limpeza das entidades órfãs encontradas
    for _, dead_id in ipairs(dead_ids) do
        bucket[dead_id] = nil
    end

    return results
end

--- Altera o nome amigável de uma entidade na rede.
---
--- @param network_name string Nome da rede
--- @param entity_or_id LuaEntity|number|table Entidade ou unit_number
--- @param name string Novo nome
--- @return boolean True se o nome foi atualizado com sucesso
function NetworkUtils.setName(network_name, entity_or_id, name)
    local node = NetworkUtils.get(network_name, entity_or_id)
    if not node then return false end

    node.name = tostring(name)
    if node.metadata then
        node.metadata.name = node.name
    end

    -- Atualiza backer_name na entidade se suportado pelo protótipo
    if node.entity and node.entity.valid then
        pcall(function()
            node.entity.backer_name = node.name
        end)
    end

    return true
end

--- Atualiza ou substitui os metadados de um nó na rede.
---
--- @param network_name string Nome da rede
--- @param entity_or_id LuaEntity|number|table Entidade ou unit_number
--- @param metadata table Novos metadados
--- @param merge boolean|nil Se true, mescla com os metadados existentes; se false/nil, substitui
--- @return boolean True se atualizado com sucesso
function NetworkUtils.setMetadata(network_name, entity_or_id, metadata, merge)
    local node = NetworkUtils.get(network_name, entity_or_id)
    if not node or type(metadata) ~= "table" then return false end

    if merge then
        node.metadata = node.metadata or {}
        for k, v in pairs(metadata) do
            node.metadata[k] = v
        end
    else
        node.metadata = metadata
    end

    if metadata.name then
        NetworkUtils.setName(network_name, entity_or_id, metadata.name)
    end

    return true
end

--- Encontra uma posição livre de colisão ao redor de uma entidade ou posição para spawn seguro
--- de jogadores, veículos ou entidades (como saída de teletransporte de portais).
---
--- @param entity_or_position LuaEntity|table Entidade de referência ou tabela com {x, y}
--- @param target_name string|nil Nome do protótipo a ser spawnado (padrão: "character")
--- @param radius number|nil Raio máximo de busca em tiles (padrão: 5)
--- @param surface_or_nil LuaSurface|string|number|nil Superfície (obrigatória se passada apenas posição)
--- @return table {x = number, y = number} Posição segura para spawn
function NetworkUtils.findFreeSpawnPosition(entity_or_position, target_name, radius, surface_or_nil)
    if not entity_or_position then
        return {x = 0, y = 0}
    end

    local surface = surface_or_nil
    local center_pos = nil
    local target = target_name or "character"
    local max_radius = radius or 5

    if type(entity_or_position) == "table" and entity_or_position.valid and entity_or_position.position then
        -- LuaEntity
        surface = entity_or_position.surface
        center_pos = entity_or_position.position
    elseif type(entity_or_position) == "table" and entity_or_position.entity and entity_or_position.entity.valid then
        -- Node da rede
        surface = entity_or_position.entity.surface
        center_pos = entity_or_position.entity.position
    elseif type(entity_or_position) == "table" then
        -- {x = ..., y = ...}
        center_pos = entity_or_position
        if not surface and game then
            surface = game.surfaces[1]
        end
    end

    if type(surface) == "string" or type(surface) == "number" then
        if game then
            surface = game.get_surface(surface)
        end
    end

    if not surface or not center_pos then
        return center_pos or {x = 0, y = 0}
    end

    local cx = center_pos.x or center_pos[1] or 0
    local cy = center_pos.y or center_pos[2] or 0

    -- Busca posição livre que não colida com entidades
    local safe_pos = surface.find_non_colliding_position(target, {cx, cy}, max_radius, 0.5)
    if safe_pos then
        return {x = safe_pos.x, y = safe_pos.y}
    end

    -- Fallback seguro com leve deslocamento lateral caso não encontre
    return {x = cx + 1.5, y = cy + 1.5}
end

--- Executa uma limpeza de todas as entidades inválidas (órfãs) em uma rede ou em todas as redes.
---
--- @param network_name string|nil Nome da rede específica ou nil para limpar todas as redes
--- @return number Quantidade total de entidades órfãs removidas
function NetworkUtils.cleanup(network_name)
    local networks = get_storage()
    if not networks then return 0 end

    local removed_count = 0

    local function cleanup_bucket(bucket)
        local to_remove = {}
        for unit_number, node in pairs(bucket) do
            if not node.entity or not node.entity.valid then
                table.insert(to_remove, unit_number)
            end
        end
        for _, id in ipairs(to_remove) do
            bucket[id] = nil
            removed_count = removed_count + 1
        end
    end

    if network_name then
        local bucket = networks[network_name]
        if bucket then cleanup_bucket(bucket) end
    else
        for _, bucket in pairs(networks) do
            cleanup_bucket(bucket)
        end
    end

    return removed_count
end

--- Retorna o total de entidades registradas em uma rede (com auto-limpeza aplicada).
---
--- @param network_name string Nome da rede
--- @param filter_or_force string|table|nil Filtros opcionais
--- @return number
function NetworkUtils.count(network_name, filter_or_force)
    local all = NetworkUtils.getAll(network_name, filter_or_force)
    return #all
end

--- Remove todos os registros de uma rede em `storage`.
---
--- @param network_name string Nome da rede
function NetworkUtils.clear(network_name)
    local bucket = get_network_bucket(network_name, false)
    if bucket then
        local networks = get_storage()
        networks[network_name] = {}
    end
end

--- Retorna a lista de nomes de todas as redes registradas em `storage`.
--- @return string[]
function NetworkUtils.getNetworks()
    local networks = get_storage()
    if not networks then return {} end

    local list = {}
    for name, _ in pairs(networks) do
        table.insert(list, name)
    end
    table.sort(list)
    return list
end

return NetworkUtils

