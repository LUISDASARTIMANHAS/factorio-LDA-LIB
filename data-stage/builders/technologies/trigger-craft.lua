local triggerBuilder = require("data-stage.builders.technologies.trigger")

local Module = {}

--- Cria uma tecnologia desbloqueada ao fabricar uma quantidade específica de um item (craft-item trigger).
--- Herda a implementação de trigger.createTechnologyTypedTrigger.
---
--- Usage:
--- ```lua
--- local tech = LDA.createTechnologyCraftEntityTrigger(
---     "steel-axe",
---     {"steel-axe"},
---     {"steel-processing"},
---     "steel-plate",
---     50
--- )
--- ```
---
--- @param name string O nome da tecnologia
--- @param unlocksList table Lista de receitas a desbloquear
--- @param prerequisitesList table|nil Lista de pré-requisitos necessários
--- @param item string Nome do item que deve ser fabricado
--- @param count number|nil Quantidade necessária (padrão: 50)
--- @return table TechnologyPrototype
function Module.createTechnologyCraftEntityTrigger(name, unlocksList, prerequisitesList, item, count)
    return triggerBuilder.createTechnologyTypedTrigger(name, unlocksList, prerequisitesList, "craft-item", {
        item = item,
        count = count or 50
    })
end

return Module
