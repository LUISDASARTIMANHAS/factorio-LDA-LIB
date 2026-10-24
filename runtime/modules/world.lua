local WorldUtils = {}

--- Obtém e valida uma superfície do Factorio por nome, índice ou objeto.
--- @param surface_or_id LuaSurface|string|number|nil
--- @return LuaSurface|nil
function WorldUtils.getSurface(surface_or_id)
    if not game then return nil end
    if surface_or_id == nil then
        return game.surfaces[1]
    end
    if type(surface_or_id) == "string" or type(surface_or_id) == "number" then
        return game.get_surface(surface_or_id)
    end
    if type(surface_or_id) == "table" and surface_or_id.valid then
        return surface_or_id
    end
    return nil
end

--- Calcula a distância euclidiana entre duas posições {x, y}.
--- @param pos1 table {x=number, y=number}
--- @param pos2 table {x=number, y=number}
--- @return number
function WorldUtils.getDistance(pos1, pos2)
    local dx = (pos1.x or pos1[1]) - (pos2.x or pos2[1])
    local dy = (pos1.y or pos1[2]) - (pos2.y or pos2[2])
    return math.sqrt(dx * dx + dy * dy)
end

--- Formata uma posição em string de tag GPS do Factorio para mensagens e alertas.
--- @param position table {x=number, y=number}
--- @param surface LuaSurface|string|nil
--- @return string Ex: "[gps=10.5,-20.0,nauvis]"
function WorldUtils.formatGps(position, surface)
    if not position then return "" end
    local s = WorldUtils.getSurface(surface)
    local sname = s and s.name or "nauvis"
    local x = position.x or position[1] or 0
    local y = position.y or position[2] or 0
    return string.format("[gps=%.1f,%.1f,%s]", x, y, sname)
end

--- Procura entidades dentro de um raio circular ao redor de uma coordenada.
--- @param surface LuaSurface|string|number
--- @param position table {x=number, y=number}
--- @param radius number
--- @param filters table|nil {name = string|table, type = string|table, force = string|LuaForce, limit = number}
--- @return LuaEntity[]
function WorldUtils.findEntitiesInRadius(surface, position, radius, filters)
    local s = WorldUtils.getSurface(surface)
    if not s or not position or not radius then return {} end

    local x = position.x or position[1]
    local y = position.y or position[2]
    local area = {
        {x - radius, y - radius},
        {x + radius, y + radius}
    }

    local query = {
        area = area,
        position = position,
        radius = radius
    }

    if filters then
        for k, v in pairs(filters) do
            query[k] = v
        end
    end

    return s.find_entities_filtered(query)
end

--- Procura entidades dentro de uma caixa delimitadora (área retangular).
--- @param surface LuaSurface|string|number
--- @param area table {{x1, y1}, {x2, y2}}
--- @param filters table|nil
--- @return LuaEntity[]
function WorldUtils.findEntitiesInBox(surface, area, filters)
    local s = WorldUtils.getSurface(surface)
    if not s or not area then return {} end

    local query = {area = area}
    if filters then
        for k, v in pairs(filters) do
            query[k] = v
        end
    end

    return s.find_entities_filtered(query)
end

--- Encontra uma posição livre de colisão próxima para colocar uma entidade.
--- @param surface LuaSurface|string|number
--- @param entity_name string
--- @param position table {x=number, y=number}
--- @param radius number|nil Padrão 10
--- @param precision number|nil Padrão 0.5
--- @return table|nil {x=number, y=number}
function WorldUtils.findFreePosition(surface, entity_name, position, radius, precision)
    local s = WorldUtils.getSurface(surface)
    if not s or not entity_name or not position then return nil end

    return s.find_non_colliding_position(entity_name, position, radius or 10, precision or 0.5)
end

--- Cria/spawna uma entidade no mundo de forma simplificada.
--- @param surface LuaSurface|string|number
--- @param name string
--- @param position table {x=number, y=number}
--- @param options table|nil {force = string|LuaForce, direction = defines.direction, fast_replace = boolean, raise_built = boolean, player = LuaPlayer, quality = string}
--- @return LuaEntity|nil
function WorldUtils.spawnEntity(surface, name, position, options)
    local s = WorldUtils.getSurface(surface)
    if not s or not name or not position then return nil end

    options = options or {}
    local params = {
        name = name,
        position = position,
        force = options.force or "player",
        direction = options.direction or defines.direction.north,
        fast_replace = options.fast_replace or false,
        raise_built = options.raise_built ~= false,
        player = options.player,
        quality = options.quality or "normal"
    }

    return s.create_entity(params)
end

--- Modifica um único tile no mapa.
--- @param surface LuaSurface|string|number
--- @param position table {x=number, y=number}
--- @param tile_name string Ex: "concrete", "grass-1"
function WorldUtils.setTile(surface, position, tile_name)
    local s = WorldUtils.getSurface(surface)
    if not s or not position or not tile_name then return end

    local x = math.floor(position.x or position[1])
    local y = math.floor(position.y or position[2])
    s.set_tiles({{name = tile_name, position = {x = x, y = y}}})
end

--- Modifica múltiplos tiles no mapa de forma eficiente em lote.
--- @param surface LuaSurface|string|number
--- @param tiles table Array de {name = string, position = {x, y}}
--- @param correct_tiles boolean|nil Padrão true
function WorldUtils.setTiles(surface, tiles, correct_tiles)
    local s = WorldUtils.getSurface(surface)
    if not s or not tiles or #tiles == 0 then return end

    s.set_tiles(tiles, correct_tiles ~= false)
end

--- Retorna o nome do tile em uma posição.
--- @param surface LuaSurface|string|number
--- @param position table {x=number, y=number}
--- @return string|nil
function WorldUtils.getTile(surface, position)
    local s = WorldUtils.getSurface(surface)
    if not s or not position then return nil end

    local tile = s.get_tile(position.x or position[1], position.y or position[2])
    return (tile and tile.valid) and tile.name or nil
end

--- Dispara uma explosão ou efeito visual em uma coordenada.
--- @param surface LuaSurface|string|number
--- @param position table {x=number, y=number}
--- @param explosion_name string|nil Padrão "explosion"
function WorldUtils.createExplosion(surface, position, explosion_name)
    local s = WorldUtils.getSurface(surface)
    if not s or not position then return end

    s.create_entity({
        name = explosion_name or "explosion",
        position = position
    })
end

--- Teleporta uma entidade móvel para uma nova coordenada e superfície.
--- @param entity LuaEntity
--- @param position table {x=number, y=number}
--- @param surface LuaSurface|string|number|nil
--- @return boolean
function WorldUtils.teleportEntity(entity, position, surface)
    if not entity or not entity.valid or not position then return false end

    local target_surface = surface and WorldUtils.getSurface(surface) or nil
    return entity.teleport(position, target_surface)
end

return WorldUtils

