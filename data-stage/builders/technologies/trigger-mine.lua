local triggerBuilder = require("data-stage.builders.technologies.trigger")

local Module = {}

--- Cria uma tecnologia desbloqueada ao minerar uma entidade de recurso específica (mine-entity trigger).
--- Herda a implementação de trigger.createTechnologyTypedTrigger.
---
--- Usage:
--- ```lua
--- local tech = LDA.createTechnologyMineEntityTrigger(
---     "uranium-processing",
---     {"centrifuge", "uranium-processing"},
---     {"uranium-mining"},
---     "uranium-ore"
--- )
--- ```
---
--- @param name string O nome da tecnologia
--- @param unlocksList table Lista de receitas a desbloquear
--- @param prerequisitesList table|nil Lista de pré-requisitos necessários
--- @param mine_entity string Nome da entidade que precisa ser minerada
--- @return table TechnologyPrototype
function Module.createTechnologyMineEntityTrigger(name, unlocksList, prerequisitesList, mine_entity)
    return triggerBuilder.createTechnologyTypedTrigger(name, unlocksList, prerequisitesList, "mine-entity", {
        entity = mine_entity
    })
end

return Module
