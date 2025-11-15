--- LDA-LIB - Init
--- Biblioteca central que exporta todas as funções utilitárias.
--- Segue o padrão estático obrigatório do Factorio (require explícito).

local LDA = {}

---------------------------------------------------------------------
-- IMPORTAÇÕES DOS MÓDULOS
---------------------------------------------------------------------

local CO = require("__LDA-LIB__/generic-functions/create-ore")
local CI = require("__LDA-LIB__/generic-functions/create-item")
local CBI = require("__LDA-LIB__/generic-functions/create-block-item")
local CBIR = require("__LDA-LIB__/generic-functions/create-block-item-with-recipe")
local CF = require("__LDA-LIB__/generic-functions/create-fluid")
local CG = require("__LDA-LIB__/generic-functions/create-gas")
local CR = require("__LDA-LIB__/generic-functions/create-recipe")
local CIR = require("__LDA-LIB__/generic-functions/create-item-with-recipe")
local CFR = require("__LDA-LIB__/generic-functions/create-fluid-with-recipe")
local CGR = require("__LDA-LIB__/generic-functions/create-generic-recipe")

-- funções avançadas
local CSIR = require("__LDA-LIB__/functions/create-smelting-item-with-recipe")
local CIRM = require("__LDA-LIB__/functions/create-item-with-recipe-matrix")
local CAIR = require("__LDA-LIB__/functions/create-assembler-item-with-recipe")
local CPCIR = require("__LDA-LIB__/functions/create-particle-collider-item-with-recipe")
local TECH = require("__LDA-LIB__/functions/create-technology")

---------------------------------------------------------------------
-- API PÚBLICA
---------------------------------------------------------------------

--- @class LDA.Functions
--- @field createOre fun(...) Cria um minério básico.
--- @field createItem fun(...) Cria um item simples.
--- @field createBlockItem fun(...) Cria um bloco estruturado.
--- @field createFluid fun(...) Cria um fluido.
--- @field createGas fun(...) Cria um gás.
--- @field createRecipe fun(...) Cria uma receita.
--- @field createItemWithRecipe fun(...) Item + receita.
--- @field createFluidWithRecipe fun(...) Fluido + receita.
--- @field createBlockItemWithRecipe fun(...) Bloco + receita.
--- @field createSmeltingItemWithRecipe fun(...) Item especial de fundição.
--- @field createItemWithRecipeMatrix fun(...) Matrizes de receitas complexas.
--- @field createAssemblerItemWithRecipe fun(...) Máquina montadora customizada.
--- @field createParticleColiderItemWithRecipe fun(...) Item + receita para colisor.
--- @field createTechnology fun(...) Cria tecnologias completas.
--- @field createGenericRecipe fun(...) Cria receita genérica flexível.

LDA.functions = {
    createOre = CO.createOre,
    createItem = CI.createItem,
    createBlockItem = CBI.createBlockItem,
    createFluid = CF.createFluid,
    createGas = CG.createGas,
    createRecipe = CR.createRecipe,
    createItemWithRecipe = CIR.createItemWithRecipe,
    createFluidWithRecipe = CFR.createFluidWithRecipe,
    createBlockItemWithRecipe = CBIR.createBlockItemWithRecipe,
    createSmeltingItemWithRecipe = CSIR.createSmeltingItemWithRecipe,
    createItemWithRecipeMatrix = CIRM.createItemWithRecipeMatrix,
    createAssemblerItemWithRecipe = CAIR.createAssemblerItemWithRecipe,
    createParticleColiderItemWithRecipe = CPCIR.createParticleColiderItemWithRecipe,
    createTechnology = TECH.createTechnology,
    createGenericRecipe = CGR.createGenericRecipe
}

---------------------------------------------------------------------
-- RETORNO
---------------------------------------------------------------------

return LDA
