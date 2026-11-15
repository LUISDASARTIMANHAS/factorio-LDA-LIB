local utils = require("shared.control-utils")
local Module = {}

--- Cria um protótipo base genérico de fluido (FluidPrototype).
--- Função genérica para construção de qualquer tipo de líquido ou gás.
---
--- Usage:
--- ```lua
--- local fluid = LDA.createBaseFluid({
---     name = "heavy-water",
---     heat_capacity = "2kJ",
---     subgroup = "fluid"
--- })
--- ```
---
--- @param params table Configurações do fluido
--- @return table FluidPrototype
function Module.createBaseFluid(params)
    if type(params) ~= "table" or not params.name then
        error("[LDA-LIB] [createBaseFluid] Parâmetro 'name' é obrigatório.")
    end

    local name = params.name
    local folder = params.icon_folder or "icons/fluid"
    local icon_path = params.icon or utils.resolveAssetPath(folder, name)
    local subgroup = params.subgroup or "natural-resources"
    local order = params.order or ("a[" .. subgroup .. "]-a[" .. name .. "]-a[" .. name .. "]")

    local fluid_data = {
        type = "fluid",
        name = name,
        subgroup = subgroup,
        default_temperature = params.default_temperature or 15,
        max_temperature = params.max_temperature or 100,
        heat_capacity = params.heat_capacity or "1kJ",
        base_color = params.base_color or {0, 0.34, 0.6},
        flow_color = params.flow_color or {0.7, 0.7, 0.7},
        icon = icon_path,
        icon_size = params.icon_size or 128,
        order = order
    }

    if params.gas_temperature ~= nil then
        fluid_data.gas_temperature = params.gas_temperature
    end
    if params.auto_barrel ~= nil then
        fluid_data.auto_barrel = params.auto_barrel
    end

    if params.extra and type(params.extra) == "table" then
        utils.tableMerge(fluid_data, params.extra, true)
    end

    return fluid_data
end

function Module.createFluid(name, energy)
    return Module.createBaseFluid({
        name = name,
        heat_capacity = energy,
        subgroup = "natural-resources",
        max_temperature = 100,
        base_color = {0, 0.34, 0.6},
        flow_color = {0.7, 0.7, 0.7},
        icon_folder = "icons/fluid"
    })
end

-- example
-- {
--     type = "fluid",
--     name = "water",
--     subgroup = "fluid",
--     default_temperature = 15,
--     max_temperature = 100,
--     heat_capacity = "2kJ",
--     base_color = {0, 0.34, 0.6},
--     flow_color = {0.7, 0.7, 0.7},
--     icon = "__base__/graphics/icons/fluid/water.png",
--     order = "a[fluid]-a[water]-a[water]"
--   },

return Module
