local createBlock = require("base-functions.create-block-item")
local createRecipe = require("base-functions.create-recipe")

local Module = {}

-- @param name string O nome do item e receita (ex: "solar-painel").
-- @param subgroup grupo onde ele deve ser organizado na gui do jogador (ex: "intermediate-products").
-- @param stack_size quantidade do item por stack nos inventarios (ex: 50).
-- @param crafted_in categoria onde o item pode ser construido (ex: "advanced-crafting").
-- @param time tempo que demora para ser construido em segundos (ex: 10) 10s.
-- @param ingredients tabela de ingredientes que são necessarios para construir o item.
-- @param results tabela de saidas depois de construido o item .
function Module.createBlockItemWithRecipe(name, subgroup, stack_size, crafted_in, time, ingredients, results,alternative_unlock_methods)
    local item = createBlock.createBlockItem(name,subgroup, stack_size)
    local recipe = createRecipe.createRecipe("blocos",name, crafted_in, time, ingredients, results,alternative_unlock_methods)

    return {item, recipe}
end


-- example 
-- {
--     type = "item",
--     name = "assembling-machine-1",
--     icon = "__base__/graphics/icons/assembling-machine-1.png",
--     subgroup = "production-machine",
--     color_hint = { text = "1" },
--     order = "a[assembling-machine-1]",
--     inventory_move_sound = item_sounds.mechanical_inventory_move,
--     pick_sound = item_sounds.mechanical_inventory_pickup,
--     drop_sound = item_sounds.mechanical_inventory_move,
--     place_result = "assembling-machine-1",
--     stack_size = 50,
--     random_tint_color = item_tints.iron_rust
--   },
--         {
--             type = "recipe",
--             name = "quantum-teleporter-equipment",
--             category = "advanced-crafting",
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