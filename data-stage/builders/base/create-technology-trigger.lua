local techUtil = require("shared.tech-util")
local utils = require("shared.control-utils")

local Module = {}

--- Constrói uma tecnologia acionada por gatilho (research_trigger).
--- @param name string O nome da tecnologia (ex: "sphere-program", "electromagnetism").
--- @param unlocksList table Lista de receitas a desbloquear pela tecnologia.
--- @param prerequisitesList table Lista de pré-requisitos necessários.
--- @param research_trigger table Definição do trigger do Factorio.
--- @return table Protótipo de Technology
function Module.createTechnologyTrigger(name, unlocksList, prerequisitesList, research_trigger)
    local icon_path = utils.resolveAssetPath("technology", name .. "-256x256")

    local technologyTrigger = {
        type = "technology",
        name = name,
        icon = icon_path,
        icon_size = 256,
        icon_mipmaps = 4,
        prerequisites = prerequisitesList,
        effects = techUtil.createEffectsUnlocksRecipes(unlocksList),
        research_trigger = research_trigger,
        order = "a-b-" .. name
    }
    return technologyTrigger
end

--- Constrói uma tecnologia acionada por gatilho genérico com tipo e payload customizáveis.
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
--- @return table Protótipo de Technology
function Module.createTechnologyTypedTrigger(name, unlocksList, prerequisitesList, trigger_type, trigger_payload)
    local trigger = {type = trigger_type}
    if type(trigger_payload) == "table" then
        for k, v in pairs(trigger_payload) do
            trigger[k] = v
        end
    end
    return Module.createTechnologyTrigger(name, unlocksList, prerequisitesList, trigger)
end

-- example
-- {
--     type = "technology",
--     name = "steam-power",
--     icon = "__base__/graphics/technology/steam-power.png",
--     icon_size = 256,
--     effects =
--     {
--       {
--         type = "unlock-recipe",
--         recipe = "pipe"
--       },
--       {
--         type = "unlock-recipe",
--         recipe = "pipe-to-ground"
--       },
--       {
--         type = "unlock-recipe",
--         recipe = "offshore-pump"
--       },
--       {
--         type = "unlock-recipe",
--         recipe = "boiler"
--       },
--       {
--         type = "unlock-recipe",
--         recipe = "steam-engine"
--       }
--     },
--     research_trigger =
--     {
--       type = "craft-item",
--       item = "iron-plate",
--       count = 50
--     }
--   },

return Module
