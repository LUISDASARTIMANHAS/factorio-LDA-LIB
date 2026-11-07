local EquipmentGridUtils = {}

--- Obtém a LuaEquipmentGrid a partir de um jogador, entidade, item_stack ou da própria grade.
---
--- @param target LuaPlayer|LuaEntity|LuaItemStack|LuaEquipmentGrid|nil
--- @return LuaEquipmentGrid|nil
function EquipmentGridUtils.getGrid(target)
    if not target then return nil end

    -- 1. Se já for uma LuaEquipmentGrid
    if type(target) == "table" and target.valid and target.equipment ~= nil and target.width ~= nil then
        return target
    end

    -- 2. Se for um LuaPlayer
    if type(target) == "table" and target.valid and target.is_player and target.is_player() then
        -- Tenta pegar do character do jogador
        local character = target.character
        if character and character.valid then
            local inv = character.get_inventory(defines.inventory.character_armor)
            if inv and inv.valid and not inv.is_empty() and inv[1].valid_for_read and inv[1].grid then
                return inv[1].grid
            end
        end

        -- Fallback: inventário direto do player
        local inv = target.get_inventory(defines.inventory.character_armor)
        if inv and inv.valid and not inv.is_empty() and inv[1].valid_for_read and inv[1].grid then
            return inv[1].grid
        end

        return nil
    end

    -- 3. Se for uma LuaEntity (ex: veículo, spidertron, character)
    if type(target) == "table" and target.valid and target.grid ~= nil then
        return target.grid
    end

    -- 4. Se for um LuaItemStack com grade (armadura no inventário)
    if type(target) == "table" and target.valid_for_read and target.grid ~= nil then
        return target.grid
    end

    return nil
end

--- Verifica se a grade de equipamento é válida e acessível.
---
--- @param target LuaPlayer|LuaEntity|LuaItemStack|LuaEquipmentGrid|nil
--- @return boolean
function EquipmentGridUtils.isValid(target)
    local grid = EquipmentGridUtils.getGrid(target)
    return grid ~= nil and grid.valid
end

--- Obtém a energia total disponível em Joules somando todos os equipamentos válidos na grade.
--- Contorna a limitação do Factorio onde a energia reside individualmente em cada LuaEquipment.
---
--- @param target LuaPlayer|LuaEntity|LuaItemStack|LuaEquipmentGrid|nil
--- @return number Energia total em Joules (0 se indisponível)
function EquipmentGridUtils.getEnergy(target)
    local grid = EquipmentGridUtils.getGrid(target)
    if not grid or not grid.valid then
        return 0
    end

    local total = 0
    local equipments = grid.equipment
    if equipments then
        for _, eq in ipairs(equipments) do
            if eq.valid and eq.energy then
                total = total + eq.energy
            end
        end
    end

    return total
end

--- Obtém a capacidade máxima total de Joules da grade.
---
--- @param target LuaPlayer|LuaEntity|LuaItemStack|LuaEquipmentGrid|nil
--- @return number Capacidade máxima em Joules
function EquipmentGridUtils.getMaxEnergy(target)
    local grid = EquipmentGridUtils.getGrid(target)
    if not grid or not grid.valid then
        return 0
    end

    if grid.max_energy then
        return grid.max_energy
    end

    local total = 0
    local equipments = grid.equipment
    if equipments then
        for _, eq in ipairs(equipments) do
            if eq.valid and eq.max_energy then
                total = total + eq.max_energy
            end
        end
    end

    return total
end

--- Verifica se a grade possui pelo menos a quantia de Joules especificada.
---
--- @param target LuaPlayer|LuaEntity|LuaItemStack|LuaEquipmentGrid|nil
--- @param amount_in_joules number Quantidade de energia requisitada em Joules
--- @return boolean
function EquipmentGridUtils.hasEnergy(target, amount_in_joules)
    if not amount_in_joules or amount_in_joules <= 0 then
        return true
    end
    return EquipmentGridUtils.getEnergy(target) >= amount_in_joules
end

--- Drena uma quantidade de energia em Joules distribuída entre os equipamentos e baterias da grade.
--- Não possui método nativo no Factorio; itera sobre grid.equipment e deduz a energia de forma atômica.
--- Se não houver energia total suficiente e allow_partial for false/nil, aborta sem debitar nada.
---
--- @param target LuaPlayer|LuaEntity|LuaItemStack|LuaEquipmentGrid|nil
--- @param amount_in_joules number Quantia em Joules a ser drenada
--- @param allow_partial boolean|nil Se true, drena o máximo possível mesmo que não cubra o total (padrão: false)
--- @return boolean success Retorna true se a quantia requisitada foi totalmente drenada (ou parcial se permitido)
--- @return number drained_joules Quantidade real de Joules que foi drenada
function EquipmentGridUtils.drainEnergy(target, amount_in_joules, allow_partial)
    local grid = EquipmentGridUtils.getGrid(target)
    if not grid or not grid.valid or not amount_in_joules or amount_in_joules <= 0 then
        return false, 0
    end

    local total_available = EquipmentGridUtils.getEnergy(grid)
    if total_available < amount_in_joules and not allow_partial then
        -- Não possui energia suficiente para o custo total e não é permitido consumo parcial
        return false, 0
    end

    local remaining = amount_in_joules
    local drained = 0

    local equipments = grid.equipment
    if equipments then
        for _, eq in ipairs(equipments) do
            if eq.valid and eq.energy and eq.energy > 0 then
                local take = math.min(remaining, eq.energy)
                eq.energy = eq.energy - take
                remaining = remaining - take
                drained = drained + take
                if remaining <= 0 then
                    break
                end
            end
        end
    end

    local success = drained >= amount_in_joules or (allow_partial and drained > 0)
    return success, drained
end

--- Adiciona energia em Joules na grade, distribuindo entre os equipamentos que possuem capacidade livre.
---
--- @param target LuaPlayer|LuaEntity|LuaItemStack|LuaEquipmentGrid|nil
--- @param amount_in_joules number Quantia em Joules a ser injetada
--- @return number Quantidade efetivamente adicionada
function EquipmentGridUtils.addEnergy(target, amount_in_joules)
    local grid = EquipmentGridUtils.getGrid(target)
    if not grid or not grid.valid or not amount_in_joules or amount_in_joules <= 0 then
        return 0
    end

    local remaining = amount_in_joules
    local added = 0

    local equipments = grid.equipment
    if equipments then
        for _, eq in ipairs(equipments) do
            if eq.valid and eq.energy and eq.max_energy and eq.energy < eq.max_energy then
                local space = eq.max_energy - eq.energy
                local give = math.min(remaining, space)
                eq.energy = eq.energy + give
                remaining = remaining - give
                added = added + give
                if remaining <= 0 then
                    break
                end
            end
        end
    end

    return added
end

--- Retorna a lista de equipamentos instalados na grade, opcionalmente filtrados por nome do protótipo.
---
--- @param target LuaPlayer|LuaEntity|LuaItemStack|LuaEquipmentGrid|nil
--- @param name_filter string|nil Nome opcional do equipamento (ex: "battery-equipment")
--- @return LuaEquipment[]
function EquipmentGridUtils.getEquipment(target, name_filter)
    local grid = EquipmentGridUtils.getGrid(target)
    if not grid or not grid.valid then
        return {}
    end

    local list = {}
    local equipments = grid.equipment
    if equipments then
        for _, eq in ipairs(equipments) do
            if eq.valid then
                if not name_filter or eq.name == name_filter then
                    table.insert(list, eq)
                end
            end
        end
    end

    return list
end

--- Retorna a quantidade de equipamentos instalados com um determinado nome.
---
--- @param target LuaPlayer|LuaEntity|LuaItemStack|LuaEquipmentGrid|nil
--- @param name string Nome do equipamento
--- @return number
function EquipmentGridUtils.countEquipment(target, name)
    local list = EquipmentGridUtils.getEquipment(target, name)
    return #list
end

return EquipmentGridUtils
