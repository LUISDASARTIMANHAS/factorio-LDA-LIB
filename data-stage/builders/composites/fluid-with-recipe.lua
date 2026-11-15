local createFluid = require("data-stage.builders.fluids.fluid")
local compositeBase = require("data-stage.builders.composites.base")

local Module = {}

--- Cria o par {fluid, recipe} para um fluido/líquido.
---
--- Usage:
--- ```lua
--- local pair = LDA.createFluidWithRecipe(
---     "heavy-water", "2kJ",
---     "chemistry", 5,
---     { {type = "fluid", name = "water", amount = 100} },
---     { {type = "fluid", name = "heavy-water", amount = 10} }
--- )
--- ```
---
--- @param name string Nome do fluido e receita
--- @param energy string Capacidade de calor/energia (ex: "1kJ")
--- @param crafted_in string Categoria da máquina de fabricação
--- @param time number Tempo de fabricação em segundos
--- @param ingredients table Lista de ingredientes
--- @param results table Lista de saídas
--- @param alternative_unlock_methods table|nil Tecnologias alternativas
--- @param isEnabled boolean|nil Se a receita vem habilitada
--- @return table Array {fluid, recipe}
function Module.createFluidWithRecipe(name, energy, crafted_in, time, ingredients, results, alternative_unlock_methods, isEnabled)
    local fluid = createFluid.createFluid(name, energy)
    return compositeBase.createCompositePrototype(fluid, "fluid", name, crafted_in, time, ingredients, results, alternative_unlock_methods, isEnabled)
end

return Module
