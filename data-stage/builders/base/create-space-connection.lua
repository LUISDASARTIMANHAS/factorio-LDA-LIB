local Module = {}

local DEFAULT_LENGTH = 15000
local MINIMUM_LENGTH = 600
local DEFAULT_DENSITY = "medium"
local DEFAULT_ASTEROID_SPEED = 1

local DENSITY_FACTORS = {
    none = 0,
    low = 0.5,
    medium = 1,
    high = 2,
    extreme = 4
}

local DEFAULT_ASTEROIDS = {
    {
        type = "asteroid-chunk",
        asteroid = "metallic-asteroid-chunk"
    },
    {
        type = "asteroid-chunk",
        asteroid = "carbonic-asteroid-chunk"
    },
    {
        type = "asteroid-chunk",
        asteroid = "oxide-asteroid-chunk"
    }
}

local DEFAULT_SPAWN_POINTS = {
    {distance = 0.1, probability = 0.01},
    {distance = 0.5, probability = 0.03},
    {distance = 0.9, probability = 0.01}
}

--- Gera os pontos de surgimento de um asteroide.
--- @param factor number Fator de densidade.
--- @param speed number Velocidade dos asteroides, maior que zero.
--- @return table[] Pontos de surgimento configurados.
local function generateSpawnPoints(factor, speed)
    local spawn_points = {}

    for _, point in ipairs(DEFAULT_SPAWN_POINTS) do
        spawn_points[#spawn_points + 1] = {
            distance = point.distance,
            probability = point.probability * factor,
            speed = speed
        }
    end

    return spawn_points
end

--- Gera definições de surgimento de asteroides.
--- @param density string|nil none, low, medium, high ou extreme.
--- @param speed number|nil Velocidade positiva dos asteroides.
--- @return table[]|nil Definições de surgimento.
function Module.generateAsteroidSpawns(density, speed)
    density = density or DEFAULT_DENSITY

    local factor = DENSITY_FACTORS[density]

    assert(factor ~= nil, "Densidade de asteroides inválida: " .. tostring(density))

    if factor == 0 then
        return nil
    end

    speed = speed or DEFAULT_ASTEROID_SPEED

    assert(type(speed) == "number" and speed > 0, "A velocidade dos asteroides deve ser maior que zero.")

    local definitions = {}

    for _, asteroid in ipairs(DEFAULT_ASTEROIDS) do
        definitions[#definitions + 1] = {
            type = asteroid.type,
            asteroid = asteroid.asteroid,
            spawn_points = generateSpawnPoints(factor, speed)
        }
    end

    return definitions
end

--- Cria um protótipo de conexão espacial entre dois locais.
--- @param from string Nome do local de origem.
--- @param to string Nome do local de destino.
--- @param length number|nil Comprimento positivo da conexão.
--- @param options table|nil Opções adicionais do protótipo.
--- @return table Protótipo space-connection.
function Module.createSpaceConnection(from, to, length, options)
    assert(type(from) == "string" and from ~= "", "O local de origem deve ser uma string não vazia.")

    assert(type(to) == "string" and to ~= "", "O local de destino deve ser uma string não vazia.")

    options = options or {}

    local connection_length = length or DEFAULT_LENGTH

    assert(type(connection_length) == "number", "O comprimento da conexão deve ser numérico.")

    if connection_length <= 0 then
        connection_length = MINIMUM_LENGTH
    end

    local density = options.asteroid_density or DEFAULT_DENSITY
    local spawns = options.asteroid_spawn_definitions

    if spawns == nil and density ~= "none" then
        spawns = Module.generateAsteroidSpawns(density, options.asteroid_speed)
    end

    local prototype = {
        type = "space-connection",
        name = options.name or (from .. "-" .. to),
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
