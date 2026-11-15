local categoryMachines = require("data-stage.builders.specialized.create-category-machines-item-with-recipe")

local Module = {}

function Module.createThrowInWaterItemWithRecipe(
    name,
    time,
    qtde,
    ingredients,
    stack_size,
    requiredWaterValue,
    alternative_unlock_methods,
    isEnabled)
    local requiredIngredient = {
        type = "fluid",
        name = "water",
        amount = requiredWaterValue
    }

    table.insert(ingredients, requiredIngredient)

    return categoryMachines.createCategoryMachineItemWithRecipe(
        "throw-in-water",
        name,
        time,
        qtde,
        ingredients,
        stack_size or 200,
        alternative_unlock_methods,
        isEnabled
    )
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
--             categories = {"smelting"},
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
