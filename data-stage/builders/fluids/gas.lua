local BaseFluid = require("data-stage.builders.fluids.base")
local Module = {}

--- Cria um protótipo de gás (FluidPrototype com gas_temperature).
--- Herda a implementação de BaseFluid.createBaseFluid.
---
--- Usage:
--- ```lua
--- local gas = LDA.createGas("steam", "0.2kJ")
--- ```
---
--- @param name string Nome do gás
--- @param energy string|nil Capacidade térmica (ex: "0.2kJ")
--- @return table FluidPrototype
function Module.createGas(name, energy)
    return BaseFluid.createBaseFluid({
        name = name,
        heat_capacity = energy,
        subgroup = "fluid",
        max_temperature = 5000,
        base_color = {0.5, 0.5, 0.5},
        flow_color = {1.0, 1.0, 1.0},
        icon_folder = "icons/gas",
        gas_temperature = 15,
        auto_barrel = false
    })
end

return Module
