local BaseTechnology = require("data-stage.builders.technologies.base")

local Module = {}

--- Constrói uma tecnologia acionada por gatilho (research_trigger).
--- Herda a implementação de BaseTechnology.createBaseTechnology.
---
--- Usage:
--- ```lua
--- local tech = LDA.createTechnologyTrigger(
---     "uranium-processing",
---     {"centrifuge", "uranium-processing"},
---     {"uranium-mining"},
---     {type = "mine-entity", entity = "uranium-ore"}
--- )
--- ```
---
--- @param name string Nome da tecnologia
--- @param unlocksList table Lista de receitas a desbloquear
--- @param prerequisitesList table Lista de pré-requisitos necessários
--- @param research_trigger table Definição do gatilho do Factorio (research_trigger)
--- @return table TechnologyPrototype
function Module.createTechnologyTrigger(name, unlocksList, prerequisitesList, research_trigger)
    return BaseTechnology.createBaseTechnology({
        name = name,
        prerequisites = prerequisitesList,
        unlocks = unlocksList,
        research_trigger = research_trigger,
        order = "a-b-" .. name
    })
end

--- Constrói uma tecnologia acionada por gatilho genérico com tipo e payload customizáveis.
--- Herda a implementação de BaseTechnology.createBaseTechnology através de createTechnologyTrigger.
---
--- Usage:
--- ```lua
--- local tech = LDA.createTechnologyTypedTrigger(
---     "steel-axe",
---     {"steel-axe"},
---     {"steel-processing"},
---     "craft-item",
---     {item = "steel-plate", count = 50}
--- )
--- ```
---
--- @param name string Nome da tecnologia
--- @param unlocksList table Lista de receitas a desbloquear
--- @param prerequisitesList table Lista de pré-requisitos
--- @param trigger_type string Tipo de gatilho (ex: "craft-item", "mine-entity", "send-item-to-orbit")
--- @param trigger_payload table|nil Campos adicionais do gatilho (ex: item, count, entity, etc.)
--- @return table TechnologyPrototype
function Module.createTechnologyTypedTrigger(name, unlocksList, prerequisitesList, trigger_type, trigger_payload)
    local trigger = {type = trigger_type}
    if type(trigger_payload) == "table" then
        for k, v in pairs(trigger_payload) do
            trigger[k] = v
        end
    end
    return Module.createTechnologyTrigger(name, unlocksList, prerequisitesList, trigger)
end

return Module
