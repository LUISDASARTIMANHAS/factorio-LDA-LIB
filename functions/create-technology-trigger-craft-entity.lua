local CTT = require("base-functions.create-technology-trigger")

local Module = {}
-- graphics/technology - icones de pesquisa

-- @param name string O nome da tecnologia (ex: "sphere-program", "electromagnetism").
-- @param unlocksList lista de receitas a desbloquear tecnologia (ex: ["processor"]).
-- @param prerequisites tabela de pre requisitos necessarios para pesquisar essa pesquisa (ex: "tech-dyston-sphere-program").
function Module.createTechnologyCraftEntityTrigger(name, unlocksList, prerequisitesList, item, count)
    local research_trigger = {
        type = "craft-item",
        item = item,
        count = count or 50
    }
    local technologyTrigger = CTT.createTechnologyTrigger(name, unlocksList, prerequisitesList, research_trigger)

    return technologyTrigger
end

-- example
-- {
--     type = "technology",
--     name = "steel-axe",
--     icon = "__base__/graphics/technology/steel-axe.png",
--     icon_size = 256,
--     effects =
--     {
--       {
--         type = "character-mining-speed",
--         modifier = 1
--       }
--     },
--     prerequisites = {"steel-processing"},
--     research_trigger =
--     {
--       type = "craft-item",
--       item = "steel-plate",
--       count = 50
--     }
--   },

return Module
