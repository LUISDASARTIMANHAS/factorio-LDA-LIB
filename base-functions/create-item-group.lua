local Module = {}
local controlGetModPath = require("utils.control-get-mod-path")
-- graphics/item-group - icones de grupos e categorias de itens

--- Cria a definição para um Item Group (Categoria Principal) e seus Item Subgroups (Subgrupos) no Factorio.
-- @param group_name {string} O nome único (ID) do Item Group (Categoria). Ex: "AE2-category".
-- @param group_order {string} A ordem de exibição do grupo na lista de categorias. Ex: "e".
-- @param icon_size {number} O tamanho do ícone em pixels (Factorio usa 32, 64, 128, etc.).
-- @param subgroups {table|nil} Uma tabela de strings ou uma tabela de objetos para definir os subgrupos.
--   Se for uma tabela de strings: {"subgrupo1", "subgrupo2"}. O nome do subgrupo será a string e a ordem será [Group-Name]-[String].
--  Se for uma tabela de objetos: {{name = "nome-sub", order = "ordem-sub"}}.
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
        icon_size = icon_size or 32, -- Padrão 32 se não for especificado
        -- Adiciona icon_mipmaps apenas se for um número válido
        icon_mipmaps = type(icon_mipmaps) == "number" and icon_mipmaps or nil
    }

    local definitions = { group_definition }

    -- 2. Definições dos Item Subgroups (Subgrupos)
    if subgroups and type(subgroups) == "table" and #subgroups > 0 then
        for _, subgroup_data in ipairs(subgroups) do
            local subgroup_name
            local subgroup_order

            -- Trata os dois formatos de entrada (string simples ou tabela complexa)
            if type(subgroup_data) == "string" then
                subgroup_name = subgroup_data
                -- Padrão de ordem: "GROUPNAME-SUBGROUPNAME" para fácil rastreamento
                subgroup_order = group_name .. "-" .. subgroup_data
            elseif type(subgroup_data) == "table" then
                subgroup_name = subgroup_data.name
                -- Se a ordem não for fornecida, cria uma ordem padrão.
                subgroup_order = subgroup_data.order or (group_name .. "-" .. subgroup_name)
            end

            -- Adiciona a definição do Subgroup se tiver um nome válido
            if subgroup_name then
                local subgroup_definition = {
                    type = "item-subgroup",
                    name = subgroup_name,
                    -- Indexando o subgrupo à categoria (muito importante!)
                    group = group_name,
                    order = subgroup_order
                }
                table.insert(definitions, subgroup_definition)
            end
        end
    end

    return definitions
end

-- example
    -- {
    --     ----------------------------------------- AE2-category
    --     {
    --         type = "item-group",
    --         -- nome da categoria
    --         name = "AE2-category",
    --         order = "e",
    --         icon = "Applied-Energistics-2/graphics/technology/AE2.png",
    --         icon_size = 126,
    --         icon_mipmaps = 2
    --     },
    --     {
    --         type = "item-subgroup",
    --         -- nome usado para definir o grupo dos itens
    --         name = "auto-craft",
    --         -- indexando o grupo a categoria
    --         group = "AE2-category",
    --         -- ordem de A a Z e de cima para baixo para organização dos grupos
    --         order = "AE2-auto-craft"
    --     },
    --     {
    --         type = "item-subgroup",
    --         name = "component",
    --         group = "AE2-category",
    --         order = "AE2-component"
    --     },
    --     {
    --         type = "item-subgroup",
    --         name = "data-terminal",
    --         group = "AE2-category",
    --         order = "AE2-data-terminal"
    --     },
    --     {
    --         type = "item-subgroup",
    --         name = "processing",
    --         group = "AE2-category",
    --         order = "AE2-processing"
    --     },
    --     {
    --         type = "item-subgroup",
    --         name = "storage-ME",
    --         group = "AE2-category",
    --         order = "AE2-storage-ME"
    --     },
    --     {
    --         type = "item-subgroup",
    --         name = "resources-generated",
    --         group = "AE2-category",
    --         order = "AE2-resources-generated"
    --     }
    -- }
return Module

-- example usage
-- Supondo que você salvou o módulo como 'item-group-creator.lua'
-- local LDAFunctions = require("__LDA-LIB__/init")

-- -- Define os subgrupos, usando strings simples para o nome:
-- local ae2_subgroups = {
--     "auto-craft",
--     "component",
--     "data-terminal",
--     "processing",
--     "storage-ME",
--     "resources-generated"
-- }

-- -- Chama a função
-- local ae2_category_definitions = LDAFunctions.createItemGroup(
--     "AE2-category", -- group_name
--     "e",            -- group_order
--     "Applied-Energistics-2/graphics/technology/AE2.png", -- icon_filename (Caminho completo de um ícone de outro mod, neste caso)
--     126,            -- icon_size
--     ae2_subgroups,  -- subgroups
--     2               -- icon_mipmaps
-- )

-- -- Adicione as definições aos protótipos de dados do Factorio
-- -- (O Factorio usa 'data:extend' no arquivo data-final-fixes.lua ou similar)
-- data:extend(ae2_category_definitions)