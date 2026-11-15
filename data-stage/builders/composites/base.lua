local createRecipe = require("data-stage.builders.recipes.recipe")

local Module = {}

--- Construtor genérico base de compósitos (Item/Entidade/Fluido + Receita).
--- Elimina a repetição de instanciação de receitas e empacotamento em par {prototype, recipe}.
---
--- Usage:
--- ```lua
--- local pair = LDA.createCompositePrototype(item_obj, "icons", "my-item", "crafting", 5, ing, res)
--- ```
---
--- @param item_or_creator table|function Objeto pronto ou função construtora do protótipo
--- @param typeIcon string Subpasta do ícone ("icons", "entities", "equipment", "fluid")
--- @param name string Nome do item e da receita
--- @param crafted_in string Categoria de fabricação
--- @param time number Tempo de fabricação em segundos
--- @param ingredients table Lista de ingredientes
--- @param results table Lista de saídas
--- @param alternative_unlock_methods table|nil Desbloqueios alternativos
--- @param isEnabled boolean|nil Habilitado inicialmente
--- @param pictures table|nil Sprites/Pictures
--- @return table Array {prototype, recipe}
function Module.createCompositePrototype(item_or_creator, typeIcon, name, crafted_in, time, ingredients, results, alternative_unlock_methods, isEnabled, pictures)
    local item = item_or_creator
    if type(item_or_creator) == "function" then
        item = item_or_creator()
    end
    local recipe = createRecipe.createRecipe(typeIcon, name, crafted_in, time, ingredients, results, alternative_unlock_methods, isEnabled, pictures)
    return {item, recipe}
end

return Module
