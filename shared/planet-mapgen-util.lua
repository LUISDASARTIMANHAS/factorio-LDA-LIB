local Module = {}

--- Cria configurações de penhascos (cliffs) para a geração do mapa do planeta.
--- @param name string|nil Nome da entidade de penhasco (ex: "cliff", "cliff-vulcanus", "cliff-fulgora")
--- @param interval number|nil Distância vertical entre níveis de penhasco (padrão 40)
--- @param elevation_0 number|nil Elevação onde começam os penhascos (padrão 10)
--- @return table CliffPlacementSettings
function Module.createCliffSettings(name, interval, elevation_0)
    return {
        name = name or "cliff",
        cliff_elevation_interval = interval or 40,
        cliff_elevation_0 = elevation_0 or 10,
        cliff_smoothing = 0.5
    }
end

--- Monta e valida a estrutura PlanetPrototypeMapGenSettings para planetas.
--- @param params table|nil Parâmetros de geração de mapa
--- @return table PlanetPrototypeMapGenSettings
function Module.createMapGenSettings(params)
    params = params or {}

    local settings = {
        terrain_segmentation = params.terrain_segmentation or 1,
        water = params.water or 1,
        autoplace_controls = {},
        autoplace_settings = {},
        property_expression_names = params.property_expression_names or {}
    }

    -- Configuração de Penhascos
    if params.cliff_settings ~= false then
        if type(params.cliff_settings) == "table" then
            settings.cliff_settings = params.cliff_settings
        else
            settings.cliff_settings = Module.createCliffSettings(params.cliff_name, params.cliff_interval)
        end
    end

    -- Normaliza Controles de Autoplace (minérios, inimigos)
    if params.autoplace_controls then
        for name, ctrl in pairs(params.autoplace_controls) do
            if type(ctrl) == "table" then
                settings.autoplace_controls[name] = {
                    frequency = ctrl.frequency or 1,
                    size = ctrl.size or 1,
                    richness = ctrl.richness or 1
                }
            elseif type(ctrl) == "number" then
                settings.autoplace_controls[name] = {
                    frequency = ctrl,
                    size = ctrl,
                    richness = ctrl
                }
            end
        end
    end

    -- Configurações específicas de Entidades, Tiles e Decorativos
    if params.autoplace_settings then
        settings.autoplace_settings = params.autoplace_settings
    else
        if params.tiles then
            settings.autoplace_settings["tile"] = {
                settings = params.tiles
            }
        end
        if params.entities then
            settings.autoplace_settings["entity"] = {
                settings = params.entities
            }
        end
        if params.decoratives then
            settings.autoplace_settings["decorative"] = {
                settings = params.decoratives
            }
        end
    end

    if params.seed then
        settings.seed = params.seed
    end

    return settings
end

return Module

