local createItemWithRecipe = require("generic-functions.create-item-with-recipe")
-- category = "science-matrices" feito em Matrix Lab
-- category = "advanced-crafting" maquinas de montagem tier 2 e 3
-- category = "basic-crafting" maquinas de montagem tier 1
-- category = "crafting" feito a mão
-- category = "smelting" feito em fornalhas
-- category = "centrifuging" feito na centrifuge
-- category = "organic" feito na Biochamber
-- category = "chemistry" feito na Chemical plant

local Module = {}

-- metodo padrão pra adicionar a receita uma maquina que constroi baseado na category, por exemplo: uma maquina de montagem tier 1 que resulta em um item, a receita dessa maquina tem que ser feita na category "basic-crafting", e assim por diante.
local function constructor(name, time, qtde, ingredients, stack_size,crafted_in,alternative_unlock_methods,isEnabled)
    local results = {
        {type = "item", name = name, amount = qtde}
    }
    local crafted_in_Resolved = crafted_in or "basic-crafting"
    local subgroup = "intermediate-product"
    local size = stack_size or 100

    local itemAndRecipe =
        createItemWithRecipe.createItemWithRecipe(name,subgroup, size, crafted_in_Resolved, time, ingredients, results,alternative_unlock_methods,isEnabled)

    return itemAndRecipe
end

-- metodos filhos que ja tem a category pre-definida, pra facilitar a criação de itens com receita para maquinas especificas, por exemplo: uma maquina de montagem tier 1 que resulta em um item, a receita dessa maquina tem que ser feita na category "advanced-crafting", e assim por diante.
function Module.createAssemblerItemWithRecipe(name, time, qtde, ingredients, stack_size,alternative_unlock_methods,isEnabled)
    local crafted_in = "advanced-crafting"
    return constructor(name, time, qtde, ingredients, stack_size,crafted_in,alternative_unlock_methods,isEnabled)
end

function Module.createChemicalPlantItemWithRecipe(name, time, qtde, ingredients, stack_size,alternative_unlock_methods,isEnabled)
    local crafted_in = "chemistry"
    return constructor(name, time, qtde, ingredients, stack_size,crafted_in,alternative_unlock_methods,isEnabled)
end

function Module.createBiochamberItemWithRecipe(name, time, qtde, ingredients, stack_size,alternative_unlock_methods,isEnabled)
    local crafted_in = "organic"
    return constructor(name, time, qtde, ingredients, stack_size,crafted_in,alternative_unlock_methods,isEnabled)
end

function Module.createSmeltingItemWithRecipe(name, time, qtde, ingredients, stack_size,alternative_unlock_methods,isEnabled)
    local crafted_in = "smelting"
    return constructor(name, time, qtde, ingredients, stack_size,crafted_in,alternative_unlock_methods,isEnabled)
end


-- example
--    {
--         {
--             type = "item",
--             name = "iron-ore",
--             icon = path_main .. "graphics/itens/iron-ore.png",
--             icon_size = 128,
--             subgroup = "itens",
--             -- diz pro jogo que o equipamento deve ser colocado com o item especificado
--             place_as_equipment_result = "quantum-teleporter-equipment",
--             order = "a[quantum-teleporter-item]",
--             stack_size = 1
--         },
--         {
--             type = "recipe",
--             name = "iron-ore",
--             category = "smelting",
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
