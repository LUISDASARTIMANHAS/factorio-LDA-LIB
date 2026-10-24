local ItemUtils = {}

--- Verifica se um LuaItemStack é válido e possui conteúdo para leitura (não é slot vazio).
--- @param stack LuaItemStack
--- @return boolean
function ItemUtils.isValid(stack)
    return stack ~= nil and stack.valid and stack.valid_for_read
end

--- Converte um LuaItemStack em uma tabela simples com suas propriedades.
--- @param stack LuaItemStack
--- @return table|nil {name = string, count = number, quality = string, health = number, ammo = number}
function ItemUtils.toTable(stack)
    if not ItemUtils.isValid(stack) then return nil end

    return {
        name = stack.name,
        count = stack.count,
        quality = stack.quality and stack.quality.name or "normal",
        health = stack.health,
        durability = stack.durability,
        ammo = stack.ammo
    }
end

--- Retorna a quantidade de slots vazios disponíveis em um inventário.
--- @param inventory LuaInventory
--- @return number
function ItemUtils.getEmptySlotCount(inventory)
    if not inventory or not inventory.valid then return 0 end
    if inventory.count_empty_stacks then
        return inventory.count_empty_stacks()
    end
    return 0
end

--- Verifica se um inventário ou entidade possui capacidade para receber a quantidade de itens informada.
--- @param target LuaInventory|LuaEntity
--- @param item_name string
--- @param count number
--- @param quality string|nil
--- @return boolean
function ItemUtils.canFit(target, item_name, count, quality)
    if not target or not target.valid or not item_name or count <= 0 then return false end

    local stack = {
        name = item_name,
        count = count,
        quality = quality or "normal"
    }

    if target.can_insert then
        return target.can_insert(stack)
    end
    return false
end

--- Transfere itens de um inventário de origem para um de destino com segurança.
--- @param source_inv LuaInventory
--- @param target_inv LuaInventory
--- @param item_name string
--- @param count number|nil Quantidade máxima a transferir (padrão todos disponíveis)
--- @param quality string|nil
--- @return number Quantidade efetivamente transferida
function ItemUtils.transfer(source_inv, target_inv, item_name, count, quality)
    if not source_inv or not source_inv.valid or not target_inv or not target_inv.valid then
        return 0
    end
    if not item_name then return 0 end

    local query = {name = item_name, quality = quality}
    local available = source_inv.get_item_count(quality and query or item_name)
    if available <= 0 then return 0 end

    local to_transfer = count and math.min(count, available) or available
    if to_transfer <= 0 then return 0 end

    local insert_stack = {
        name = item_name,
        count = to_transfer,
        quality = quality or "normal"
    }

    local inserted = target_inv.insert(insert_stack)
    if inserted > 0 then
        source_inv.remove({
            name = item_name,
            count = inserted,
            quality = quality
        })
    end

    return inserted
end

--- Derrama itens no chão ao redor de uma coordenada.
--- @param surface LuaSurface
--- @param position table {x=number, y=number}
--- @param item_name string
--- @param count number
--- @param options table|nil {quality = string, force = LuaForce, enable_looted = boolean, radius = number}
function ItemUtils.spill(surface, position, item_name, count, options)
    if not surface or not surface.valid or not position or not item_name or count <= 0 then
        return
    end

    options = options or {}
    surface.spill_item_stack({
        position = position,
        stack = {
            name = item_name,
            count = count,
            quality = options.quality or "normal"
        },
        enable_looted = options.enable_looted ~= false,
        force = options.force,
        radius = options.radius
    })
end

--- Localiza entidades do tipo 'item-on-ground' (itens caídos no chão) em um raio.
--- @param surface LuaSurface
--- @param position table {x=number, y=number}
--- @param radius number
--- @param item_name string|nil Filtra por nome do item específico se fornecido
--- @return LuaEntity[]
function ItemUtils.findOnGround(surface, position, radius, item_name)
    if not surface or not surface.valid or not position or not radius then return {} end

    local x = position.x or position[1]
    local y = position.y or position[2]

    local ground_items = surface.find_entities_filtered({
        area = {{x - radius, y - radius}, {x + radius, y + radius}},
        position = position,
        radius = radius,
        name = "item-on-ground"
    })

    if not item_name then
        return ground_items
    end

    local filtered = {}
    for _, entity in ipairs(ground_items) do
        if entity.valid and entity.stack and entity.stack.valid_for_read and entity.stack.name == item_name then
            table.insert(filtered, entity)
        end
    end
    return filtered
end

--- Recolhe itens caídos no chão diretamente para dentro do jogador ou inventário de uma entidade.
--- @param surface LuaSurface
--- @param position table {x=number, y=number}
--- @param radius number Raio de coleta
--- @param target LuaPlayer|LuaEntity Jogador ou entidade que receberá os itens
--- @return number Quantidade total de itens recolhidos
function ItemUtils.collectFromGround(surface, position, radius, target)
    if not surface or not surface.valid or not target or not target.valid then return 0 end

    local items = ItemUtils.findOnGround(surface, position, radius)
    local total_collected = 0

    for _, ground_entity in ipairs(items) do
        if ground_entity.valid and ground_entity.stack and ground_entity.stack.valid_for_read then
            local stack = ground_entity.stack
            local stack_data = {
                name = stack.name,
                count = stack.count,
                quality = stack.quality and stack.quality.name or "normal"
            }

            local inserted = target.insert(stack_data)
            if inserted > 0 then
                total_collected = total_collected + inserted
                if inserted >= stack_data.count then
                    ground_entity.destroy()
                else
                    stack.count = stack.count - inserted
                end
            end
        end
    end

    return total_collected
end

--- Obtém o tamanho máximo da pilha (stack size) de um item a partir dos protótipos do Factorio.
--- @param item_name string
--- @return number|nil
function ItemUtils.getStackSize(item_name)
    if not prototypes or not prototypes.item then return nil end
    local proto = prototypes.item[item_name]
    return proto and proto.stack_size or nil
end

--- Obtém o nome do subgrupo de um item nos protótipos.
--- @param item_name string
--- @return string|nil
function ItemUtils.getSubgroup(item_name)
    if not prototypes or not prototypes.item then return nil end
    local proto = prototypes.item[item_name]
    return (proto and proto.subgroup) and proto.subgroup.name or nil
end

return ItemUtils

