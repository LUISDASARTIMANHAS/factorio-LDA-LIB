local CTT = require("data-stage.builders.base.create-technology-trigger")

local Module = {}

-- @param name string O nome da tecnologia (ex: "sphere-program", "electromagnetism").
-- @param unlocksList lista de receitas a desbloquear tecnologia (ex: ["processor"]).
-- @param prerequisites tabela de pre requisitos necessarios para pesquisar essa pesquisa (ex: "tech-dyston-sphere-program").
function Module.createTechnologyMineEntityTrigger(name, unlocksList, prerequisitesList, mine_entity)
    return CTT.createTechnologyTypedTrigger(name, unlocksList, prerequisitesList, "mine-entity", {
        entity = mine_entity
    })
end

-- example
-- {
--     type = "technology",
--     name = "uranium-processing",
--     icon = "__base__/graphics/technology/uranium-processing.png",
--     icon_size = 256,
--     effects =
--     {
--         {
--         type = "unlock-recipe",
--         recipe = "centrifuge"
--         },
--         {
--         type = "unlock-recipe",
--         recipe = "uranium-processing"
--         }
--     },
--     prerequisites = {"uranium-mining"},
--     research_trigger =
--     {
--         type = "mine-entity",
--         entity = "uranium-ore"
--     }
-- },

return Module
