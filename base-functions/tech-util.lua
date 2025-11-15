local Module = {}

-- Lista de receitas do jogo base que não devem receber o prefixo "DSP-".
-- Esta lista pode ser expandida conforme a necessidade.
local base_game_recipes_and_items = {
    ["transport-belt"] = true,
    ["underground-belt"] = true,
    ["fast-splitter"] = true,
    ["fast-transport-belt"] = true,
    ["fast-underground-belt"] = true,
    ["splitter"] = true,
    ["pipe"] = true,
    ["pipe-to-ground"] = true,
    ["offshore-pump"] = true,
    ["boiler"] = true,
    ["steam-engine"] = true,
    ["assembling-machine-1"] = true,
    ["assembling-machine-2"] = true,
    ["assembling-machine-3"] = true,
    ["storage-tank"] = true,
    ["basic-circuit-board"] = true, -- Exemplo de receita do jogo base
    -- Pacotes científicos
    ["automation-science-pack"] = true,
    ["logistic-science-pack"] = true,
    ["chemical-science-pack"] = true,
    ["production-science-pack"] = true,
    ["utility-science-pack"] = true,
    ["space-science-pack"] = true
    -- Adicione mais receitas do jogo base aqui, se necessário.
}

--- Copia os pré-requisitos fornecidos para uma nova tabela.
-- @param prerequisites table (opcional) A tabela de pré-requisitos a ser copiada.
-- @return table Uma nova tabela contendo os pré-requisitos copiados.
function Module.copyPrerequisites(prerequisites)
    local copied_prereqs = {}
    if prerequisites then
        for _, prereq in ipairs(prerequisites) do
            table.insert(copied_prereqs, prereq)
        end
    end
    return copied_prereqs
end

--- Adiciona pré-requisitos automáticos com base no nome da tecnologia.
-- @param tech_name string O nome da tecnologia (ex: "sphere-program", "electromagnetism").
-- @param current_prerequisites table A tabela de pré-requisitos atual para adicionar.
function Module.addAutomaticPrerequisites(tech_name, current_prerequisites)
    -- Adicionar 'tech-dyson-sphere-program' condicionalmente
    -- Não adiciona a si mesma
    if tech_name ~= "sphere-program" then
        table.insert(current_prerequisites, "tech-dyson-sphere-program")
    end

    -- Adicionar 'tech-dyson-electromagnetism' condicionalmente
    -- Não adiciona a si mesma nem a 'tech-dyson-sphere-program'
    if tech_name ~= "electromagnetism" and tech_name ~= "sphere-program" then
        table.insert(current_prerequisites, "tech-dyson-electromagnetism")
    end
end

--- Remove duplicatas de uma lista de pré-requisitos.
-- @param prerequisites_list table A tabela de pré-requisitos com possíveis duplicatas.
-- @return table Uma nova tabela com pré-requisitos únicos.
function Module.removeDuplicates(prerequisites_list)
    local unique_prerequisites = {}
    local seen = {}
    for _, prereq in ipairs(prerequisites_list) do
        if not seen[prereq] then
            table.insert(unique_prerequisites, prereq)
            seen[prereq] = true
        end
    end
    return unique_prerequisites
end

-- @param unlocks table Uma lista de nomes de receitas (strings) OU uma tabela de efeitos no formato Factorio.
-- @param modtag string (mymod-) usado para verificar se a receita está na lista de exceções do jogo base
-- @return table A tabela de efeitos no formato Factorio.
function Module.processUnlocks(unlocks,modtag)
    local modtag = "DPS-"
    local processed_unlocks = {}
    if unlocks then
        -- Verificar se 'unlocks' é uma lista simples de nomes de receitas (strings)
        if type(unlocks) == "table" and #unlocks > 0 and type(unlocks[1]) == "string" then
            for _, recipe_name in ipairs(unlocks) do
                local final_recipe_name = recipe_name
                -- Verifica se a receita está na lista de exceções do jogo base
                if not base_game_recipes_and_items[recipe_name] then
                    final_recipe_name = modtag .. recipe_name
                end

                table.insert(
                    processed_unlocks,
                    {
                        type = "unlock-recipe",
                        recipe = final_recipe_name
                    }
                )
            end
        else
            -- Se não for uma lista de strings, assumir que já está no formato correto de efeitos
            processed_unlocks = unlocks
        end
    else
        -- Desbloqueio padrão se 'unlocks' for nil
        processed_unlocks = {
            {
                type = "unlock-recipe",
                recipe = "transport-belt"
            }
        }
    end
    return processed_unlocks
end

--- Processa uma lista de pacotes de ciencias em formato compacto. por ex:
--- {
--     {"electromagnetic-matrix", 1}
-- },
-- @param ingredients table Lista original de ingredientes.
-- @return table Lista convertida no formato padronizado {"item", quantidade}.
function Module.processUnlockIngredients(scienceIngredients)
    local processed_scienceIngredients = {}

    if scienceIngredients then
        for i, scienceIngredient in ipairs(scienceIngredients) do

            local item_name
            local item_amount

            -- FORMATO COMPACTO: { "iron-plate", 3 }
            if type(scienceIngredient) == "table" and #scienceIngredient >= 2 then
                item_name = scienceIngredient[1]
                item_amount = scienceIngredient[2]

            else
                error(
                    "LDA TECH-UTIL ERR: O ingrediente no índice " .. i ..
                    " está mal formatado. Suportado: { iron-plate', 3 }."
                )
            end

            -- Valida tipos
            if type(item_name) ~= "string" or type(item_amount) ~= "number" then
                error(
                    "LDA TECH-UTIL ERR: science Ingredient inválido no índice " .. i ..
                    ". 'name' deve ser string e 'amount' um número."
                )
            end

            -- Prefixos especiais (sua lógica original)
            local final_item_name = base_game_recipes_and_items[item_name]
                and item_name
                or item_name

            table.insert(
                processed_scienceIngredients,
                {final_item_name, item_amount}
            )
        end

    else
        processed_scienceIngredients = {
            {"automation-science-pack", 1}
        }
    end

    return processed_scienceIngredients
end

return Module
