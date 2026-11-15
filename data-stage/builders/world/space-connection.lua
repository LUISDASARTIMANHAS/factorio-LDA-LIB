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

function Module.generateAsteroidSpawns(density, custom_asteroids, speed)
    local selected_density = density or DEFAULT_DENSITY
    local factor = DENSITY_FACTORS[selected_density]

    if factor == nil then
        error("[LDA-LIB] Densidade de asteroides desconhecida: " .. tostring(selected_density))
    end

    if factor == 0 then
        return {}
    end

    local resolved_speed = speed or DEFAULT_ASTEROID_SPEED
    if resolved_speed <= 0 then
        error("[LDA-LIB] A velocidade dos asteroides deve ser maior que zero.")
    end

    local asteroids = custom_asteroids or DEFAULT_ASTEROIDS
    local spawn_definitions = {}

    for _, asteroid_entry in ipairs(asteroids) do
        spawn_definitions[#spawn_definitions + 1] = {
            type = asteroid_entry.type or "asteroid-chunk",
            asteroid = asteroid_entry.asteroid,
            spawn_points = generateSpawnPoints(factor, resolved_speed)
        }
    end

    return spawn_definitions
end

function Module.createSpaceConnection(from, to, length, options)
    options = options or {}

    if not from or not to then
        error("[LDA-LIB] 'from' e 'to' são obrigatórios para criar uma conexão espacial.")
    end

    local connection_name = from .. "-" .. to
    local resolved_length = length or DEFAULT_LENGTH

    if resolved_length < MINIMUM_LENGTH then
        error("[LDA-LIB] O comprimento da conexão deve ser no mínimo " .. MINIMUM_LENGTH .. ".")
    end

    local asteroids = options.asteroids
    if asteroids == nil then
        asteroids = Module.generateAsteroidSpawns(
            options.asteroid_density,
            options.custom_asteroids,
            options.asteroid_speed
        )
    end

    local connection = {
        type = "space-connection",
        name = connection_name,
        subgroup = options.subgroup or "planet-connections",
        from = from,
        to = to,
        order = options.order or ("c[" .. connection_name .. "]"),
        length = resolved_length,
        asteroid_spawn_definitions = asteroids
    }

    if options.icons then
        connection.icons = options.icons
    elseif options.icon then
        connection.icon = options.icon
        connection.icon_size = options.icon_size or 64
    end

    return connection
end

return Module
