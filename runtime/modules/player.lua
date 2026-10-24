local PlayerUtils = {}

--- Obtém e valida uma referência de jogador por índice, nome ou objeto.
--- @param player_or_id number|string|LuaPlayer
--- @return LuaPlayer|nil
function PlayerUtils.get(player_or_id)
    if not player_or_id then return nil end
    local p = nil
    if type(player_or_id) == "number" or type(player_or_id) == "string" then
        p = game and game.get_player(player_or_id)
    elseif type(player_or_id) == "table" and player_or_id.valid then
        p = player_or_id
    end
    return (p and p.valid) and p or nil
end

--- Verifica se um jogador é válido e conectado.
--- @param player LuaPlayer
--- @return boolean
function PlayerUtils.isValid(player)
    return player ~= nil and player.valid
end

--- Obtém a entidade Character do jogador se estiver vivo.
--- @param player LuaPlayer
--- @return LuaEntity|nil
function PlayerUtils.getCharacter(player)
    local p = PlayerUtils.get(player)
    return (p and p.character and p.character.valid) and p.character or nil
end

--- Obtém a posição atual do jogador.
--- @param player LuaPlayer
--- @return table|nil {x = number, y = number}
function PlayerUtils.getPosition(player)
    local p = PlayerUtils.get(player)
    if not p then return nil end
    local pos = p.position
    return {x = pos.x, y = pos.y}
end

--- Obtém a superfície atual do jogador.
--- @param player LuaPlayer
--- @return LuaSurface|nil
function PlayerUtils.getSurface(player)
    local p = PlayerUtils.get(player)
    return p and p.surface or nil
end

--- Obtém a tag GPS do jogador para uso em chat.
--- @param player LuaPlayer
--- @return string
function PlayerUtils.getGps(player)
    local p = PlayerUtils.get(player)
    if not p or not p.surface then return "" end
    local pos = p.position
    local surface_name = p.surface.name
    return string.format("[gps=%.1f,%.1f,%s]", pos.x, pos.y, surface_name)
end

--- Obtém a quantidade total de um item que o jogador possui no inventário principal.
--- @param player LuaPlayer
--- @param item_name string
--- @param quality string|nil
--- @return number
function PlayerUtils.getItemCount(player, item_name, quality)
    local p = PlayerUtils.get(player)
    if not p then return 0 end
    local inv = p.get_main_inventory()
    if not inv or not inv.valid then return 0 end

    if quality then
        return inv.get_item_count({name = item_name, quality = quality})
    end
    return inv.get_item_count(item_name)
end

--- Verifica se o jogador possui ao menos a quantidade especificada de um item.
--- @param player LuaPlayer
--- @param item_name string
--- @param count number|nil Padrão 1
--- @param quality string|nil
--- @return boolean
function PlayerUtils.hasItem(player, item_name, count, quality)
    local required = count or 1
    return PlayerUtils.getItemCount(player, item_name, quality) >= required
end

--- Insere itens no inventário do jogador com fallback para derrubar no chão se cheio.
--- @param player LuaPlayer
--- @param item_name string
--- @param count number
--- @param options table|nil {quality = string, spill_if_full = boolean}
--- @return number Quantidade efetivamente entregue
function PlayerUtils.give(player, item_name, count, options)
    local p = PlayerUtils.get(player)
    if not p or not item_name or count <= 0 then return 0 end

    options = options or {}
    local stack = {
        name = item_name,
        count = count,
        quality = options.quality or "normal"
    }

    local inserted = p.insert(stack)
    local remaining = count - inserted

    if remaining > 0 and options.spill_if_full and p.surface then
        p.surface.spill_item_stack({
            position = p.position,
            stack = {
                name = item_name,
                count = remaining,
                quality = options.quality or "normal"
            },
            enable_looted = true,
            force = p.force
        })
        return count
    end

    return inserted
end

--- Remove itens do inventário do jogador.
--- @param player LuaPlayer
--- @param item_name string
--- @param count number|nil Padrão 1
--- @param quality string|nil
--- @return number Quantidade removida
function PlayerUtils.remove(player, item_name, count, quality)
    local p = PlayerUtils.get(player)
    if not p or not item_name then return 0 end

    local amount = count or 1
    local inv = p.get_main_inventory()
    if not inv or not inv.valid then return 0 end

    local stack = {
        name = item_name,
        count = amount,
        quality = quality
    }
    return inv.remove(stack)
end

--- Teleporta o jogador para uma coordenada e opcionalmente uma nova superfície.
--- @param player LuaPlayer
--- @param position table {x = number, y = number}
--- @param surface LuaSurface|string|nil Superfície de destino
--- @return boolean
function PlayerUtils.teleport(player, position, surface)
    local p = PlayerUtils.get(player)
    if not p or not position then return false end

    local target_surface = surface
    if type(surface) == "string" and game then
        target_surface = game.get_surface(surface)
    end

    return p.teleport(position, target_surface)
end

--- Mostra um texto voador local visível apenas para o jogador.
--- @param player LuaPlayer
--- @param text string|table Mensagem ou LocalisedString
--- @param options table|nil {color = Color, position = Position, time_to_live = number}
function PlayerUtils.flyingText(player, text, options)
    local p = PlayerUtils.get(player)
    if not p then return end

    options = options or {}
    local pos = options.position or p.position
    p.create_local_flying_text({
        text = text,
        position = pos,
        color = options.color or {r = 1, g = 1, b = 1},
        time_to_live = options.time_to_live or 120
    })
end

--- Envia uma mensagem formatada ao jogador e opcionalmente reproduz um som.
--- @param player LuaPlayer
--- @param message string|table
--- @param sound_path string|nil Ex: "utility/achievement_unlocked"
function PlayerUtils.notify(player, message, sound_path)
    local p = PlayerUtils.get(player)
    if not p then return end

    p.print(message)
    if sound_path then
        p.play_sound({path = sound_path})
    end
end

return PlayerUtils

