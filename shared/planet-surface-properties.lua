-- vulcanus
-- surface_properties =
--     {
--       ["day-night-cycle"] = 1.5 * minute,
--       ["magnetic-field"] = 25,
--       ["solar-power"] = 400,
--       pressure = 4000,
--       gravity = 40
--     },
-- gleba
-- surface_properties =
--     {
--       ["day-night-cycle"] = 10 * minute,
--       ["magnetic-field"] = 25,
--       ["solar-power"] = 50,
--       pressure = 2000,
--       gravity = 20
--     },
-- fulgora
-- surface_properties =
--     {
--       ["day-night-cycle"] = 3 * minute,
--       ["magnetic-field"] = 99,
--       ["solar-power"] = 20,
--       pressure = 800,
--       gravity = 8
--     },
-- aquilo
-- {
--       ["day-night-cycle"] = 20 * minute,
--       ["magnetic-field"] = 10,
--       ["solar-power"] = 1,
--       ["robot-energy-usage"] = 5,
--       pressure = 300,
--       gravity = 15
--     },

local Module = {}

local DEFAULT_PROPERTIES = {
    gravity = 10,
    pressure = 1000,
    ["magnetic-field"] = 90,
    ["solar-power"] = 100,
    ["day-night-cycle"] = 300
}

--- Combina duas tabelas sem modificar as originais.
--- @param base table Valores padrão.
--- @param overrides table Valores personalizados.
--- @return table Tabela combinada.
local function tableMerge(base, overrides)
    local result = {}

    for key, value in pairs(base) do
        result[key] = value
    end

    for key, value in pairs(overrides) do
        result[key] = value
    end

    return result
end

--- Cria propriedades de superfície usando IDs oficiais do Factorio.
--- @param custom_props table|nil Propriedades personalizadas.
--- @return table<string, number> Propriedades do planeta.
function Module.createSurfaceProperties(custom_props)
    local properties = tableMerge(
        DEFAULT_PROPERTIES,
        custom_props or {}
    )

    for name, value in pairs(properties) do
        assert(
            type(value) == "number",
            "A propriedade '" .. tostring(name)
                .. "' deve ter um valor numérico."
        )
    end

    return properties
end

--- Cria uma predefinição ambiental personalizável.
--- @param defaults table Propriedades padrão.
--- @return fun(overrides: table|nil): table
local function createPreset(defaults)
    return function(overrides)
        return Module.createSurfaceProperties(
            tableMerge(defaults, overrides or {})
        )
    end
end

Module.presets = {
    -- Nauvis
    temperate = createPreset({
        gravity = 10,
        pressure = 1000,
        ["magnetic-field"] = 90,
        ["solar-power"] = 100,
        ["day-night-cycle"] = 25000
    }),

    -- Vulcanus
    volcanic = createPreset({
        gravity = 40,
        pressure = 4000,
        ["magnetic-field"] = 25,
        ["solar-power"] = 400,
        ["day-night-cycle"] = 1.5 * 60 * 60
    }),

    -- Gleba
    swamp = createPreset({
        gravity = 20,
        pressure = 2000,
        ["magnetic-field"] = 25,
        ["solar-power"] = 50,
        ["day-night-cycle"] = 10 * 60 * 60
    }),

    -- Fulgora
    lightning = createPreset({
        gravity = 8,
        pressure = 800,
        ["magnetic-field"] = 99,
        ["solar-power"] = 20,
        ["day-night-cycle"] = 3 * 60 * 60
    }),

    -- Aquilo
    frozen = createPreset({
        gravity = 15,
        pressure = 300,
        ["magnetic-field"] = 10,
        ["solar-power"] = 1,
        ["robot-energy-usage"] = 5,
        ["day-night-cycle"] = 20 * 60 * 60
    }),

    -- Vácuo
    vacuum = createPreset({
        gravity = 3,
        pressure = 0,
        ["magnetic-field"] = 10,
        ["solar-power"] = 120,
        ["day-night-cycle"] = 60000
    }),

    -- Planeta desértico personalizado
    desert = createPreset({
        gravity = 10,
        pressure = 800,
        ["magnetic-field"] = 40,
        ["solar-power"] = 350,
        ["day-night-cycle"] = 30000
    })
}

return Module