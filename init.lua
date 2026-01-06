--- LDA-LIB - Init
--- Biblioteca central que exporta todas as funções utilitárias.
--- Segue o padrão estático obrigatório do Factorio (require explícito).

local LDA = {}

---------------------------------------------------------------------
-- IMPORTAÇÕES DOS MÓDULOS
---------------------------------------------------------------------
local controlGetModPath = require("utils.control-get-mod-path")
local utils = require("utils.control-utils")
local utilsEnergySource = require("utils.control-energy-sources")
local CANI = require("utils.control-animations")

-- BASE FUNCTIONS
local CO = require("base-functions.create-ore")
local CI = require("base-functions.create-item")
local CBI = require("base-functions.create-block-item")
local CIG = require("base-functions.create-item-group")
local CEI = require("base-functions.create-equipment-item")
local CF = require("base-functions.create-fluid")
local CG = require("base-functions.create-gas")
local CR = require("base-functions.create-recipe")
local CIS = require("base-functions.create-item-search")

-- GENERIC FUNCTIONS
local CIR = require("generic-functions/create-item-with-recipe")
local CFR = require("generic-functions/create-fluid-with-recipe")
local CBIR = require("generic-functions.create-block-item-with-recipe")
local CEIR = require("generic-functions.create-equipment-item-with-recipe")
local CGR = require("generic-functions.create-generic-recipe")

-- ADVANCED FUNCTIONS
local CTWIR = require("functions.create-throw-in-water-item-with-recipe")
local CSIR = require("functions.create-smelting-item-with-recipe")
local CAIR = require("functions.create-assembler-item-with-recipe")
local TECH = require("base-functions.create-technology")
local TECHTRIGGER = require("functions.create-technology-trigger")

---------------------------------------------------------------------
-- API PÚBLICA
---------------------------------------------------------------------

--- @class LDA.Functions
--- @field createOre fun(...) Cria um minério básico.
--- @field createItem fun(...) Cria um item simples.
--- @field createBlockItem fun(...) Cria um bloco estruturado.
--- @field createEquipmentItem fun(...) Cria um bloco estruturado.
--- @field createFluid fun(...) Cria um fluido.
--- @field createGas fun(...) Cria um gás.
--- @field createRecipe fun(...) Cria uma receita.
--- @field createItemSearch fun(...) Cria itens de pesquisa como kits cientificos.
--- @field createItemWithRecipe fun(...) Item + receita.
--- @field createFluidWithRecipe fun(...) Fluido + receita.
--- @field createBlockItemWithRecipe fun(...) Bloco + receita.
--- @field createSmeltingItemWithRecipe fun(...) Item especial de fundição.
--- @field createAssemblerItemWithRecipe fun(...) Máquina montadora customizada.
--- @field createTechnology fun(...) Cria tecnologias completas.
--- @field createGenericRecipe fun(...) Cria receita genérica flexível.

-- ISSO E NECESSARIO PORQUE CASO PRECISE ALTERAR UMA FUNÇÃO O USUARIO FINAL NÃO TERA SEU PROJETO QUEBRADO, POIS ISSO CRIA UMA CAMADA DE ABSTRAÇÃO.
LDA.functions = {
    utilsAnimations = CANI,
    utils = utils,
    utilsEnergySource = utilsEnergySource,
    getBasePath = controlGetModPath.getModPath,
    setBasePath = controlGetModPath.setBasePath,
    createOre = CO.createOre,
    createItemGroup = CIG.createItemGroup,
    createItem = CI.createItem,
    createEquipmentItem = CEI.createEquipmentItem,
    createBlockItem = CBI.createBlockItem,
    createFluid = CF.createFluid,
    createGas = CG.createGas,
    createRecipe = CR.createRecipe,
    createItemWithRecipe = CIR.createItemWithRecipe,
    createFluidWithRecipe = CFR.createFluidWithRecipe,
    createBlockItemWithRecipe = CBIR.createBlockItemWithRecipe,
    createEquipmentItemWithRecipe = CEIR.createEquipmentItemWithRecipe,
    createSmeltingItemWithRecipe = CSIR.createSmeltingItemWithRecipe,
    createAssemblerItemWithRecipe = CAIR.createAssemblerItemWithRecipe,
    createThrowInWaterItemWithRecipe = CTWIR.createThrowInWaterItemWithRecipe,
    createTechnology = TECH.createTechnology,
    createTechnologyTrigger = TECHTRIGGER.createTechnologyTrigger,
    createItemSearch = CIS.createItemSearch,
    createGenericRecipe = CGR.createGenericRecipe,
}

---------------------------------------------------------------------
-- RETORNO
---------------------------------------------------------------------

return LDA.functions
