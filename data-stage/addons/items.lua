-- category = "science-matrices" feito em Matrix Lab
-- category = "advanced-crafting" maquinas de montagem tier 2 e 3
-- category = "basic-crafting" maquinas de montagem tier 1
-- category = "crafting" feito a mão
-- category = "smelting" feito em fornalhas
-- category = "centrifuging" feito na centrifuge
-- category = "organic" feito na Biochamber
-- category = "chemistry" feito na Chemical plant

-- function createAssemblerItemWithRecipe(name: any, time: any, qtde: any, ingredients: any, stack_size: any, alternative_unlock_methods: any, isEnabled: any)
local controlCreateCategoryMachinesItemWithRecipe = require("functions.create-category-machines-item-with-recipe")

-- Biomassa
data:extend(
    controlCreateCategoryMachinesItemWithRecipe.createChemicalPlantItemWithRecipe(
        "biomass",
        5,
        20,
        -- ingredients
        {
            {type = "item", name = "wood", amount = 4},
        },
        200,
        nil,
        true
    )
)

-- Solid Biofuel
data:extend(
    controlCreateCategoryMachinesItemWithRecipe.createAssemblerItemWithRecipe(
        "solid-biofuel",
        4,
        4,
        -- ingredients
        {
            {type = "item", name = "biomass", amount = 8},
        },
        200,
        nil,
        true
    )
)

-- Liquid Biofuel
data:extend(
    controlCreateCategoryMachinesItemWithRecipe.createChemicalPlantItemWithRecipe(
        "liquid-biofuel",
        4,
        4,
        -- ingredients
        {
            {type = "item", name = "solid-biofuel", amount = 6},
            {type = "fluid", name = "water", amount = 300},
        },
        200,
        nil,
        true
    )
)