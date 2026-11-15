local Module = {}

--- Converte uma lista de nomes de itens/fluidos ou tabelas de resultados parciais em uma lista de resultados
--- completa no formato de protótipo do Factorio, padronizando 'amount = 1' quando ausente.
-- @param results_list {table} Uma tabela contendo nomes de itens/fluidos (string) ou 
--                             definições parciais de resultados (tabela com name e type/amount).
-- @return {table} Uma tabela no formato de resultados do protótipo de receita do Factorio.
function Module.formatResultsList(results_list)
    local final_results = {}

    if not results_list or type(results_list) ~= "table" then
        return final_results
    end

    for _, result_data in ipairs(results_list) do
        local result_definition = nil
        local type_default = "item"

        if type(result_data) == "string" then
            local item_name = result_data
            if item_name:match("fluid") or item_name:match("gas") then 
                type_default = "fluid"
            end

            result_definition = {
                type = type_default,
                name = item_name,
                amount = 1
            }
        elseif type(result_data) == "table" and result_data.name then
            result_definition = {
                type = result_data.type or type_default,
                name = result_data.name,
                amount = result_data.amount or 1
            }
        end

        if result_definition then
            table.insert(final_results, result_definition)
        end
    end

    return final_results
end

return Module
