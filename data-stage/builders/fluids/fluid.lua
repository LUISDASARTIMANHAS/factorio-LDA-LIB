local BaseFluid = require("data-stage.builders.fluids.base")
local Module = {}

--- Cria um protótipo de líquido (FluidPrototype).
--- Herda a implementação de BaseFluid.createBaseFluid.
---
--- Usage:
--- ```lua
--- local fluid = LDA.createFluid("heavy-oil", "2kJ")
--- ```
---
--- @param name string Nome do fluido
--- @param energy string|nil Capacidade térmica (ex: "1kJ")
--- @return table FluidPrototype
function Module.createFluid(name, energy)
    return BaseFluid.createBaseFluid({
        name = name,
        heat_capacity = energy,
        subgroup = "natural-resources",
        max_temperature = 100,
        base_color = {0, 0.34, 0.6},
        flow_color = {0.7, 0.7, 0.7},
        icon_folder = "icons/fluid"
    })
end

return Module
