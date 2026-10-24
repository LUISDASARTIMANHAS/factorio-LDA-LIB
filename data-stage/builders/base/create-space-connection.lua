local Module = {}

--- Gera definições básicas de asteroides para conexões espaciais conforme o nível de perigo.
--- @param density string|nil "none"|"low"|"medium"|"high"|"extreme"
--- @return table[]|nil Array de SpaceConnectionAsteroidSpawnDefinition
function Module.generateAsteroidSpawns(density)
    if density == "none" then return nil end

    local factor = 1
    if density == "low" then factor = 0.5
    elseif density == "high" then factor = 2.0
    elseif density == "extreme" then factor = 4.0
    end

    return {
        {
            asteroid = "metallic-asteroid-chunk",
            spawn_points = {
                {distance = 0.1, probability = 0.01 * factor},
                {distance = 0.5, probability = 0.03 * factor},
                {distance = 0.9, probability = 0.01 * factor}
            }
        },
        {
            asteroid = "carbonaceous-asteroid-chunk",
            spawn_points = {
                {distance = 0.1, probability = 0.01 * factor},
                {distance = 0.5, probability = 0.03 * factor},
                {distance = 0.9, probability = 0.01 * factor}
            }
        },
        {
            asteroid = "oxide-asteroid-chunk",
            spawn_points = {
                {distance = 0.1, probability = 0.01 * factor},
                {distance = 0.5, probability = 0.03 * factor},
                {distance = 0.9, probability = 0.01 * factor}
            }
        }
    }
end

--- Cria um protótipo de conexão espacial (SpaceConnectionPrototype) entre dois corpos celestes.
--- @param from string Nome do planeta/localização de origem (ex: "nauvis")
--- @param to string Nome do planeta/localização de destino
--- @param length number|nil Distância em km (padrão 15000, não pode ser 0)
--- @param options table|nil {name = string, shape = "arc"|"line", asteroid_density = string, asteroid_spawn_definitions = table, order = string, subgroup = string, icon = string, icon_size = number}
--- @return table Prototype de 'space-connection'
function Module.createSpaceConnection(from, to, length, options)
    options = options or {}

    local connection_name = options.name or (from .. "-" .. to)
    local connection_length = length or 15000
    if connection_length <= 0 then
        connection_length = 600
    end

    local spawns = options.asteroid_spawn_definitions
    if not spawns and options.asteroid_density ~= "none" then
        spawns = Module.generateAsteroidSpawns(options.asteroid_density or "medium")
    end

    local prototype = {
        type = "space-connection",
        name = connection_name,
        from = from,
        to = to,
        length = connection_length,
        subgroup = options.subgroup or "planet-connections",
        shape = options.shape or "arc",
        order = options.order or ("c[" .. from .. "-" .. to .. "]"),
        asteroid_spawn_definitions = spawns
    }

    if options.icon then
        prototype.icon = options.icon
        prototype.icon_size = options.icon_size or 64
    end

    return prototype
end

return Module

