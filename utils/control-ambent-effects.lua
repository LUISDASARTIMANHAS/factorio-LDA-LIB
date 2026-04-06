-- control-ambent-effects.lua
local utils = require("utils.control-utils")
local Module = {}

--- Cria uma explosão visual no local.
--- @param surface LuaSurface
--- @param position MapPosition
--- @return nil
function Module.createExplosion(surface, position)
    surface.create_entity({
        name = "big-explosion",
        position = position
    })

    surface.create_entity({
        name = "crash-site-explosion-smoke",
        position = position
    })
end


--- Cria fogo decorativo ao redor da entididade.
--- @param surface LuaSurface
--- @param center MapPosition
--- @param count number|nil
--- @return nil
function Module.createCrashFire(surface, center, count)
    local fire_count = count or math.random(4, 8)

    for _ = 1, fire_count do
        local fire_position = utils.getRandomPositionAround(center.x, center.y, 2, 7)

        surface.create_entity({
            name = "crash-site-fire-flame",
            position = fire_position
        })

        surface.create_entity({
            name = "crash-site-fire-smoke",
            position = fire_position
        })
    end
end

--- Cria explosões secundárias aleatórias próximas do impacto.
--- @param surface LuaSurface
--- @param center MapPosition
--- @param count number|nil
--- @return nil
function Module.createSecondaryExplosions(surface, center, count)
    local explosion_count = count or math.random(2, 4)

    for _ = 1, explosion_count do
        local explosion_position = utils.getRandomPositionAround(center.x, center.y, 2, 8)

        surface.create_entity({
            name = "big-explosion",
            position = explosion_position
        })
    end
end

--- Cria marcas de impacto no chão.
--- @param surface LuaSurface
--- @param position MapPosition
--- @return nil
function Module.createScorchmark(surface, position)
    surface.create_entity({
        name = "medium-scorchmark-tintable",
        position = position
    })
end

return Module