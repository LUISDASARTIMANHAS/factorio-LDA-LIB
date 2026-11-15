return {
    -- Utilitários compartilhados
    utilsAnimations = {module = "shared.control-animations"},
    utils = {module = "shared.control-utils"},
    utilsAmbientEffects = {module = "shared.control-ambent-effects"},
    utilsEnergySource = {module = "shared.control-energy-sources"},
    techUtils = {module = "shared.tech-util"},
    getBasePath = {module = "shared.control-get-mod-path", member = "getModPath"},
    setBasePath = {module = "shared.control-get-mod-path", member = "setBasePath"},
    resolveAssetPath = {module = "shared.control-utils", member = "resolveAssetPath"},
    applyIconOrPictures = {module = "shared.control-utils", member = "applyIconOrPictures"},
    isFactorioObjectValid = {module = "shared.control-utils", member = "isFactorioObjectValid"},
    formatMetricUnit = {module = "shared.control-utils", member = "formatMetricUnit"},
    createSurfaceProperties = {module = "shared.planet-surface-properties", member = "createSurfaceProperties"},
    surfacePropertiesPresets = {module = "shared.planet-surface-properties", member = "presets"},
    createMapGenSettings = {module = "shared.planet-mapgen-util", member = "createMapGenSettings"},
    createCliffSettings = {module = "shared.planet-mapgen-util", member = "createCliffSettings"},

    -- Itens
    createBaseItem = {module = "data-stage.builders.items.base", member = "createBaseItem"},
    createItem = {module = "data-stage.builders.items.item", member = "createItem"},
    createOreItem = {module = "data-stage.builders.items.ore-item", member = "createOreItem"},
    createBlockItem = {module = "data-stage.builders.items.block-item", member = "createBlockItem"},
    createEquipmentItem = {module = "data-stage.builders.items.equipment-item", member = "createEquipmentItem"},
    createItemGroup = {module = "data-stage.builders.items.item-group", member = "createItemGroup"},
    createItemSearch = {module = "data-stage.builders.items.item-search", member = "createItemSearch"},

    -- Fluidos
    createBaseFluid = {module = "data-stage.builders.fluids.base", member = "createBaseFluid"},
    createFluid = {module = "data-stage.builders.fluids.fluid", member = "createFluid"},
    createGas = {module = "data-stage.builders.fluids.gas", member = "createGas"},

    -- Entidades
    createBaseEntity = {module = "data-stage.builders.entities.base", member = "createBaseEntity"},
    createEntity = {module = "data-stage.builders.entities.entity", member = "createEntity"},
    createAccumulator = {module = "data-stage.builders.entities.accumulator", member = "createAccumulator"},

    -- Tecnologias
    createBaseTechnology = {module = "data-stage.builders.technologies.base", member = "createBaseTechnology"},
    createTechnology = {module = "data-stage.builders.technologies.technology", member = "createTechnology"},
    createTechnologyTrigger = {module = "data-stage.builders.technologies.trigger", member = "createTechnologyTrigger"},
    createTechnologyTypedTrigger = {module = "data-stage.builders.technologies.trigger", member = "createTechnologyTypedTrigger"},
    createTechnologyCraftEntityTrigger = {module = "data-stage.builders.technologies.trigger-craft", member = "createTechnologyCraftEntityTrigger"},
    createTechnologyMineEntityTrigger = {module = "data-stage.builders.technologies.trigger-mine", member = "createTechnologyMineEntityTrigger"},

    -- Receitas
    createBaseRecipe = {module = "data-stage.builders.recipes.base", member = "createBaseRecipe"},
    createRecipe = {module = "data-stage.builders.recipes.recipe", member = "createRecipe"},
    formatResultsList = {module = "data-stage.builders.recipes.format-results", member = "formatResultsList"},

    -- Compósitos
    createCompositePrototype = {module = "data-stage.builders.composites.base", member = "createCompositePrototype"},
    createItemWithRecipe = {module = "data-stage.builders.composites.item-with-recipe", member = "createItemWithRecipe"},
    createBlockItemWithRecipe = {module = "data-stage.builders.composites.block-item-with-recipe", member = "createBlockItemWithRecipe"},
    createEquipmentItemWithRecipe = {module = "data-stage.builders.composites.equipment-item-with-recipe", member = "createEquipmentItemWithRecipe"},
    createFluidWithRecipe = {module = "data-stage.builders.composites.fluid-with-recipe", member = "createFluidWithRecipe"},
    createGenericRecipe = {module = "data-stage.builders.composites.generic-recipe", member = "createGenericRecipe"},
    createCategoryMachineItemWithRecipe = {module = "data-stage.builders.composites.category-machines", member = "createCategoryMachineItemWithRecipe"},
    createAssemblerItemWithRecipe = {module = "data-stage.builders.composites.category-machines", member = "createAssemblerItemWithRecipe"},
    createChemicalPlantItemWithRecipe = {module = "data-stage.builders.composites.category-machines", member = "createChemicalPlantItemWithRecipe"},
    createBiochamberItemWithRecipe = {module = "data-stage.builders.composites.category-machines", member = "createBiochamberItemWithRecipe"},
    createSmeltingItemWithRecipe = {module = "data-stage.builders.composites.category-machines", member = "createSmeltingItemWithRecipe"},
    createThrowInWaterItemWithRecipe = {module = "data-stage.builders.composites.throw-in-water", member = "createThrowInWaterItemWithRecipe"},

    -- Mundo e Recursos
    createAutoplaceControl = {module = "data-stage.builders.world.autoplace-control", member = "createAutoplaceControl"},
    createResource = {module = "data-stage.builders.world.resource", member = "createResource"},
    createOre = {module = "data-stage.builders.world.ore", member = "createOre"},
    createPlanet = {module = "data-stage.builders.world.planet", member = "createPlanet"},
    createSpaceConnection = {module = "data-stage.builders.world.space-connection", member = "createSpaceConnection"},
    generateAsteroidSpawns = {module = "data-stage.builders.world.space-connection", member = "generateAsteroidSpawns"}
}
