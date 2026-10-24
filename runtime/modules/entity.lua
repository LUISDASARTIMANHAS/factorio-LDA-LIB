local EntityUtils = {}

--- Verifica com segurança se a entidade existe e está válida no jogo.
--- @param entity LuaEntity
--- @return boolean
function EntityUtils.isValid(entity)
    return entity ~= nil and entity.valid
end

--- Obtém a vida atual da entidade.
--- @param entity LuaEntity
--- @return number|nil
function EntityUtils.getHealth(entity)
    if not EntityUtils.isValid(entity) then return nil end
    return entity.health
end

--- Define a vida da entidade de forma segura.
--- @param entity LuaEntity
--- @param health number
function EntityUtils.setHealth(entity, health)
    if not EntityUtils.isValid(entity) or not entity.health then return end
    entity.health = math.max(0, health)
end

--- Cura a entidade aumentando sua vida atual sem ultrapassar o máximo.
--- @param entity LuaEntity
--- @param amount number
function EntityUtils.heal(entity, amount)
    if not EntityUtils.isValid(entity) or not entity.health or not entity.max_health then return end
    entity.health = math.min(entity.max_health, entity.health + amount)
end

--- Aplica dano à entidade respeitando forças e tipo de dano.
--- @param entity LuaEntity
--- @param amount number
--- @param force LuaForce|string|nil
--- @param damage_type string|nil Ex: "physical", "fire", "laser"
--- @return number Dano efetivo aplicado
function EntityUtils.damage(entity, amount, force, damage_type)
    if not EntityUtils.isValid(entity) then return 0 end
    local target_force = force or "neutral"
    local dtype = damage_type or "physical"
    return entity.damage(amount, target_force, dtype)
end

--- Obtém o nível atual de energia de uma máquina ou acumulador.
--- @param entity LuaEntity
--- @return number Energia em Joules ou 0
function EntityUtils.getEnergy(entity)
    if not EntityUtils.isValid(entity) or not entity.energy then return 0 end
    return entity.energy
end

--- Define o nível de energia de uma entidade.
--- @param entity LuaEntity
--- @param energy number
function EntityUtils.setEnergy(entity, energy)
    if not EntityUtils.isValid(entity) or entity.energy == nil then return end
    entity.energy = math.max(0, energy)
end

--- Retorna a posição {x, y} segura da entidade.
--- @param entity LuaEntity
--- @return table|nil
function EntityUtils.getPosition(entity)
    if not EntityUtils.isValid(entity) then return nil end
    local pos = entity.position
    return {x = pos.x, y = pos.y}
end

--- Retorna a superfície em que a entidade se encontra.
--- @param entity LuaEntity
--- @return LuaSurface|nil
function EntityUtils.getSurface(entity)
    if not EntityUtils.isValid(entity) then return nil end
    return entity.surface
end

--- Retorna a força (time) da entidade.
--- @param entity LuaEntity
--- @return LuaForce|nil
function EntityUtils.getForce(entity)
    if not EntityUtils.isValid(entity) then return nil end
    return entity.force
end

--- Retorna a caixa delimitadora (bounding box) da entidade.
--- @param entity LuaEntity
--- @return BoundingBox|nil
function EntityUtils.getBoundingBox(entity)
    if not EntityUtils.isValid(entity) then return nil end
    return entity.bounding_box
end

--- Verifica se a entidade é um fantasma de construção.
--- @param entity LuaEntity
--- @return boolean
function EntityUtils.isGhost(entity)
    if not EntityUtils.isValid(entity) then return false end
    return entity.type == "entity-ghost" or entity.type == "tile-ghost"
end

--- Tenta reviver um fantasma de entidade.
--- @param ghost LuaEntity
--- @return table|nil {entity = LuaEntity, item_requests = table}
function EntityUtils.reviveGhost(ghost)
    if not EntityUtils.isValid(ghost) or ghost.type ~= "entity-ghost" then return nil end
    local success, revived, requests = ghost.revive({return_item_request_proxy = true})
    if success and revived then
        return {entity = revived, item_requests = requests}
    end
    return nil
end

--- Destrói uma entidade com opções de disparar evento ou matá-la (die).
--- @param entity LuaEntity
--- @param options table|nil {die = boolean, cause = LuaEntity, force = LuaForce, raise_destroy = boolean}
--- @return boolean
function EntityUtils.destroy(entity, options)
    if not EntityUtils.isValid(entity) then return false end
    options = options or {}

    if options.die then
        return entity.die(options.force, options.cause)
    end

    return entity.destroy({
        raise_destroy = options.raise_destroy ~= false
    })
end

--- Insere itens no inventário ou receptáculo de uma entidade.
--- @param entity LuaEntity
--- @param item_name string
--- @param count number
--- @param quality string|nil
--- @return number Quantidade inserida
function EntityUtils.insert(entity, item_name, count, quality)
    if not EntityUtils.isValid(entity) or not item_name or count <= 0 then return 0 end
    return entity.insert({
        name = item_name,
        count = count,
        quality = quality or "normal"
    })
end

--- Remove itens de uma entidade.
--- @param entity LuaEntity
--- @param item_name string
--- @param count number|nil
--- @param quality string|nil
--- @return number Quantidade removida
function EntityUtils.remove(entity, item_name, count, quality)
    if not EntityUtils.isValid(entity) or not item_name then return 0 end
    return entity.remove_item({
        name = item_name,
        count = count or 1,
        quality = quality
    })
end

return EntityUtils

