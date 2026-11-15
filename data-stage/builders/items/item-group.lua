local Module = {}
local controlGetModPath = require("shared.control-get-mod-path")

--- Cria a definição para um Item Group (Categoria Principal) e seus Item Subgroups (Subgrupos) no Factorio.
-- @param group_name {string} O nome único (ID) do Item Group (Categoria). Ex: "AE2-category".
-- @param group_order {string} A ordem de exibição do grupo na lista de categorias. Ex: "e".
-- @param icon_size {number} O tamanho do ícone em pixels (Factorio usa 32, 64, 128, etc.).
-- @param subgroups {table|nil} Uma tabela de strings ou uma tabela de objetos para definir os subgrupos.
-- @param icon_mipmaps {number|nil} O número de mipmaps para o ícone. Opcional.
-- @return {table} Uma tabela contendo a definição do Item Group e todos os Item Subgroups.
function Module.createItemGroup(group_name, group_order, icon_size, subgroups, icon_mipmaps)
    local path_main = controlGetModPath.getModPath()

    -- 1. Definição do Item Group (Categoria Principal)
    local group_definition = {
        type = "item-group",
        name = group_name,
        order = group_order,
        icon = path_main .. "graphics/item-group/" .. group_name .. ".png",
        icon_size = icon_size or 32,
        icon_mipmaps = type(icon_mipmaps) == "number" and icon_mipmaps or nil
    }

    local definitions = { group_definition }

    -- 2. Definições dos Item Subgroups (Subgrupos)
    if subgroups and type(subgroups) == "table" and #subgroups > 0 then
        for _, subgroup_data in ipairs(subgroups) do
            local subgroup_name
            local subgroup_order

            if type(subgroup_data) == "string" then
                subgroup_name = subgroup_data
                subgroup_order = group_name .. "-" .. subgroup_data
            elseif type(subgroup_data) == "table" then
                subgroup_name = subgroup_data.name
                subgroup_order = subgroup_data.order or (group_name .. "-" .. subgroup_name)
            end

            if subgroup_name then
                local subgroup_definition = {
                    type = "item-subgroup",
                    name = subgroup_name,
                    group = group_name,
                    order = subgroup_order
                }
                table.insert(definitions, subgroup_definition)
            end
        end
    end

    return definitions
end

return Module
