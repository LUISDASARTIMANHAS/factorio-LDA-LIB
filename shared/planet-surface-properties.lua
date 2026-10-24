local Module = {}

--- Cria e formata a tabela de surface_properties para planetas no Factorio 2.0+.
--- @param custom_props table|nil {gravity = number, pressure = number, magnetic_field = number, solar_power = number, day_night_cycle = number, temperature = number}
--- @return table dictionary[SurfacePropertyID -> double]
function Module.createSurfaceProperties(custom_props)
    custom_props = custom_props or {}

    local properties = {
        ["gravity"] = custom_props.gravity or 10,
        ["pressure"] = custom_props.pressure or 1000,
        ["magnetic-field"] = custom_props.magnetic_field or 99,
        ["solar-power"] = custom_props.solar_power or 100,
        ["day-night-cycle"] = custom_props.day_night_cycle or 25000
    }

    if custom_props.temperature then
        properties["temperature"] = custom_props.temperature
    end

    -- Permite passar quaisquer propriedades adicionais de mods
    for k, v in pairs(custom_props) do
        if not properties[k] and type(v) == "number" then
            properties[k] = v
        end
    end

    return properties
end

--- Conjunto de predefinições ambientais inspiradas nos biomas do Space Age.
Module.presets = {
    --- Estilo terrestre (Nauvis): clima ameno, gravidade e pressão normais.
    temperate = function(overrides)
        local base = {
            gravity = 10,
            pressure = 1000,
            magnetic_field = 99,
            solar_power = 100,
            day_night_cycle = 25000,
            temperature = 298.15 -- 25°C
        }
        return Module.createSurfaceProperties(overrides and tableMerge(base, overrides) or base)
    end,

    --- Estilo vulcânico (Vulcanus): alta gravidade, atmosfera densa, forte radiação solar.
    volcanic = function(overrides)
        local base = {
            gravity = 12,
            pressure = 4000,
            magnetic_field = 80,
            solar_power = 400,
            day_night_cycle = 20000,
            temperature = 340.0
        }
        return Module.createSurfaceProperties(overrides and tableMerge(base, overrides) or base)
    end,

    --- Estilo tempestades eletromagnéticas (Fulgora): atmosfera fina, forte campo magnético.
    lightning = function(overrides)
        local base = {
            gravity = 8,
            pressure = 200,
            magnetic_field = 150,
            solar_power = 60,
            day_night_cycle = 35000,
            temperature = 270.0
        }
        return Module.createSurfaceProperties(overrides and tableMerge(base, overrides) or base)
    end,

    --- Estilo orgânico/pantanoso (Gleba): dias longos, pressão moderada e calor úmido.
    swamp = function(overrides)
        local base = {
            gravity = 10,
            pressure = 1200,
            magnetic_field = 100,
            solar_power = 80,
            day_night_cycle = 40000,
            temperature = 310.0
        }
        return Module.createSurfaceProperties(overrides and tableMerge(base, overrides) or base)
    end,

    --- Estilo criogênico/congelado (Aquilo): frio extremo, energia solar quase nula, atmosfera rarefeita.
    frozen = function(overrides)
        local base = {
            gravity = 11,
            pressure = 100,
            magnetic_field = 50,
            solar_power = 1,
            day_night_cycle = 50000,
            temperature = 70.0 -- -203°C
        }
        return Module.createSurfaceProperties(overrides and tableMerge(base, overrides) or base)
    end,

    --- Estilo vácuo / lua estéril: sem pressão atmosférica, gravidade baixa.
    vacuum = function(overrides)
        local base = {
            gravity = 3,
            pressure = 0,
            magnetic_field = 10,
            solar_power = 120,
            day_night_cycle = 60000,
            temperature = 150.0
        }
        return Module.createSurfaceProperties(overrides and tableMerge(base, overrides) or base)
    end
}

function tableMerge(base, extra)
    local result = {}
    for k, v in pairs(base) do result[k] = v end
    for k, v in pairs(extra) do result[k] = v end
    return result
end

return Module

