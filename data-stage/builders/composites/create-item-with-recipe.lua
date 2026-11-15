local createItem = require("data-stage.builders.base.create-item")
local createRecipe = require("data-stage.builders.base.create-recipe")

local Module = {}

--- Construtor genérico de compósitos (Item/Entidade/Fluido + Receita).
--- Elimina a repetição de instanciação de receitas e empacotamento em par {item, recipe}.
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
--- @return table Array {item, recipe}
function Module.createCompositePrototype(item_or_creator, typeIcon, name, crafted_in, time, ingredients, results, alternative_unlock_methods, isEnabled, pictures)
    local item = item_or_creator
    if type(item_or_creator) == "function" then
        item = item_or_creator()
    end
    local recipe = createRecipe.createRecipe(typeIcon, name, crafted_in, time, ingredients, results, alternative_unlock_methods, isEnabled, pictures)
    return {item, recipe}
end

-- @param name string O nome do item e receita (ex: "solar-painel").
-- @param subgroup grupo onde ele deve ser organizado na gui do jogador (ex: "intermediate-products").
-- @param stack_size quantidade do item por stack nos inventarios (ex: 50).
-- @param crafted_in categoria onde o item pode ser construido (ex: "advanced-crafting").
-- @param time tempo que demora para ser construido em segundos (ex: 10) 10s.
-- @param ingredients tabela de ingredientes que são necessarios para construir o item.
-- @param results tabela de saidas depois de construido o item.
-- @param alternative_unlock_methods quais outras techs desbloqueiam esse item.
-- @param isEnabled se o item ja deve vir com a receita desbloqueada.
--  Construtor main
function Module.createItemWithRecipe(name, subgroup, stack_size, crafted_in, time, ingredients, results, alternative_unlock_methods, isEnabled, pictures)
    local item = createItem.createItem(name, subgroup, stack_size, pictures)
    return Module.createCompositePrototype(item, "icons", name, crafted_in, time, ingredients, results, alternative_unlock_methods, isEnabled, pictures)
end


-- example 
-- {
--             type = "item",
--             name = "quantum-teleporter-equipment",
--             icon = path_main .. "graphics/itens/quantum-teleporter-equipment-128.png",
--             icon_size = 128,
--             subgroup = "itens",
--             -- diz pro jogo que o equipamento deve ser colocado com o item especificado
--             place_as_equipment_result = "quantum-teleporter-equipment",
--             order = "a[quantum-teleporter-item]",
--             stack_size = 1
--         },
--         {
--             type = "recipe",
--             name = "quantum-teleporter-equipment",
--             categories = {"advanced-crafting"},
--             enabled = false,
--             energy_required = 120,
--             ingredients = {
--                 {type = "item", name = "supercapacitor", amount = 4096},
--                 {type = "item", name = "tungsten-plate", amount = 256},
--                 {type = "item", name = "carbon-fiber", amount = 64},
--                 {type = "item", name = "quantum-processor", amount = 256}
--             },
--             results = {
--                 {type = "item", name = "quantum-teleporter-equipment", amount = 1}
--             },
--             alternative_unlock_methods = {"Quantum-Teleporter"}
--         }
--     }
return Module
